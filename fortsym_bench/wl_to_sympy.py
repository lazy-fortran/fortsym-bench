"""Small, deterministic Wolfram-expression to SymPy translation runtime.

The corpus contains complete Wolfram scripts, not just isolated expressions.
The generated Python companions therefore keep the source assignment text and
evaluate it in order with SymPy's Mathematica parser.  This is deliberately a
bounded translator: a statement it cannot lower is skipped and remains visible
in the generated file's manifest instead of being replaced by a guessed value.
"""

from __future__ import annotations

from dataclasses import dataclass
import hashlib
from itertools import combinations, product
import re
from typing import Iterable

import sympy as sp
from sympy.parsing.mathematica import parse_mathematica
from sympy.simplify.fu import TR8

MAX_MAP_LEVEL = 4
MAX_MAP_NODES = 20_000

# These heads have names that the Mathematica parser either treats as Python
# syntax or evaluates while constructing its parent expression. Give them
# inert parser spellings and lower them explicitly below.  The aliases are
# deliberately private: they are not Wolfram names that can leak into a
# translated result.
_PARSER_HEAD_ALIASES = {
    "Subscript": "fortsymSubscript",
    "StringMatchQ": "fortsymStringMatchQ",
    "StringReplace": "fortsymStringReplace",
    "ToExpression": "fortsymToExpression",
}
_STRING_ATOMS: dict[str, str] = {}
_STRING_LITERALS: dict[str, str] = {}
_NUMBER_STRING = re.compile(
    r"[+-]?(?:(?:\d+(?:\.\d*)?)|(?:\.\d+))(?:[eE*^][+-]?\d+)?"
)


@dataclass(frozen=True)
class Assignment:
    """A plain Set or simple SetDelayed extracted from a Wolfram statement."""

    name: str
    rhs: str
    parameters: tuple[str, ...] = ()
    # Legacy generated companions use three-item tuples and historically
    # treated callable definitions as delayed. Source extraction records the
    # actual Wolfram operator while preserving that default for old tuples.
    delayed: bool = True


@dataclass(frozen=True)
class WolframRule:
    left: object
    right: object


class WolframFunction:
    """A small closure for ``f[x_] := rhs`` definitions."""

    def __init__(
        self,
        parameters: tuple[str, ...],
        rhs: str | object,
        closure: dict,
        delayed: bool = True,
    ):
        self.parameters = parameters
        self.rhs = rhs
        self.closure = closure
        self.delayed = delayed

    def call(self, arguments: tuple[object, ...]):
        if len(arguments) != len(self.parameters):
            raise NotImplementedError("function arity is not supported")
        local = dict(self.closure)
        local.update(zip(self.parameters, arguments))
        if self.delayed:
            return evaluate_expression(self.rhs, local)
        value = self.rhs
        for parameter, argument in zip(self.parameters, arguments):
            value = _substitute(value, sp.Symbol(parameter), argument)
        return value


class WolframPureFunction:
    """A parsed ``Function``/``#`` closure used by Map and Apply."""

    def __init__(self, parameters: tuple[object, ...], body, closure: dict):
        self.parameters = parameters
        self.body = body
        self.closure = closure

    def call(self, arguments: tuple[object, ...]):
        if len(arguments) != len(self.parameters):
            raise NotImplementedError("pure-function arity is not supported")
        local = dict(self.closure)
        local.update(
            (str(parameter), argument)
            for parameter, argument in zip(self.parameters, arguments)
        )
        return _lower(self.body, local)


def split_wolfram_statements(source: str) -> list[str]:
    """Split top-level Wolfram statements without splitting nested code."""

    source = _strip_comments(source)
    statements: list[str] = []
    depth = 0
    start = 0
    in_string = False
    escaped = False
    for index, char in enumerate(source):
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue
        if char == '"':
            in_string = True
        elif char in "[{(":
            depth += 1
        elif char in "]})":
            depth = max(0, depth - 1)
        elif depth == 0 and char == ";":
            _append_statement(statements, source[start:index])
            start = index + 1
        elif depth == 0 and char == "\n" and not _awaits_operand(source, start, index):
            _append_statement(statements, source[start:index])
            start = index + 1
    _append_statement(statements, source[start:])
    return statements


def extract_assignments(source: str) -> tuple[list[Assignment], list[str]]:
    """Return translatable assignments and statements requiring hand work."""

    assignments: list[Assignment] = []
    skipped: list[str] = []
    for statement in split_wolfram_statements(source):
        # A top-level comma is Wolfram's CompoundExpression separator.  A
        # fair amount of the older teaching material uses ``Clear[..., ...],
        # Null, x = ...`` on one physical line, so extracting only the whole
        # line would lose the useful assignment at its end.
        fragments = _split_top_level(statement, ",")
        for fragment in fragments:
            wrapper = _times_compound_prefix(fragment)
            if wrapper is not None:
                prefix, remainder = wrapper
                prefix_assignments, prefix_skipped = extract_assignments(prefix)
                assignments.extend(prefix_assignments)
                skipped.extend(prefix_skipped)
                if remainder:
                    # The suffix is deliberately retained as unsupported.  In
                    # particular, do not turn a plotting head into a guessed
                    # SymPy value just because its setup assignments are usable.
                    skipped.append(remainder)
                continue
            assignment = assignment_from_statement(fragment)
            if assignment is None:
                if fragment.strip():
                    skipped.append(fragment.strip())
                continue
            assignments.append(assignment)
    return assignments, skipped


def assignment_from_statement(statement: str) -> Assignment | None:
    """Recognise ``name = rhs`` and simple ``f[x_] := rhs`` statements."""

    position, width = _top_level_assignment(statement)
    if position < 0:
        return None
    left = statement[:position].strip()
    right = statement[position + width :].strip()
    if not right:
        return None

    plain = _plain_name(left)
    if plain is not None:
        return Assignment(plain, right)

    function = _function_name_and_parameters(left)
    if function is not None:
        name, parameters = function
        return Assignment(name, right, parameters, delayed=width == 2)
    return None


def evaluate_assignments(
    assignments: Iterable[tuple[str, str, tuple[str, ...]] | Assignment],
    source_name: str = "<translated Wolfram script>",
) -> dict[str, object]:
    """Evaluate extracted assignments in order, returning successful bindings."""

    assignments = tuple(_as_assignment(item) for item in assignments)
    # A Wolfram script made entirely of definitions, checks, or side effects
    # can legitimately expose no named value.  The benchmark protocol treats
    # that as an empty result set; turning it into an unsupported backend hides
    # a valid translation and prevents the empty result from being cached.
    if not assignments:
        return {}

    environment: dict[str, object] = {}
    results: dict[str, object] = {}
    failures: list[str] = []
    for item in assignments:
        assignment = item
        try:
            if assignment.parameters:
                if assignment.delayed:
                    environment[assignment.name] = WolframFunction(
                        assignment.parameters, assignment.rhs, environment
                    )
                else:
                    # Set evaluates a patterned right-hand side immediately,
                    # before installing the new definition. Evaluate it with
                    # symbolic pattern variables so a redefinition can use
                    # the previous callable, as in successive definitions of
                    # v[tau1_].
                    definition_environment = dict(environment)
                    definition_environment.update(
                        (parameter, sp.Symbol(parameter))
                        for parameter in assignment.parameters
                    )
                    body = evaluate_expression(
                        assignment.rhs, definition_environment
                    )
                    environment[assignment.name] = WolframFunction(
                        assignment.parameters,
                        body,
                        environment,
                        delayed=False,
                    )
                continue
            value = evaluate_expression(assignment.rhs, environment)
            environment[assignment.name] = value
            # Rule objects, Python containers and opaque control-flow values
            # are useful in the sequential environment but cannot be emitted
            # through the benchmark's SymPy ``srepr`` protocol.  Keep them
            # available to later assignments and leave their names out of the
            # result set rather than making the whole companion un-runnable.
            if _is_serializable(value):
                results[assignment.name] = value
        except (Exception, NotImplementedError) as exc:
            failures.append(f"{assignment.name}: {exc}")

    if not results:
        # A script containing only SetDelayed definitions has changed the
        # Wolfram environment but exposes no named value to the benchmark
        # protocol.  It is the same empty result set as a script made only of
        # checks or side effects; do not turn a valid zero-binding translation
        # into an artificial unsupported backend.
        if not failures and all(
            assignment.parameters for assignment in assignments
        ):
            return {}
        reason = failures[0] if failures else "no translatable assignments"
        raise NotImplementedError(f"{source_name}: {reason}")
    return results


def evaluate_expression(text: str, environment: dict[str, object] | None = None):
    """Parse and lower one Wolfram expression using the SymPy API."""

    environment = {} if environment is None else environment
    normalised = _normalise_expression_layout(_normalise_named_characters(text))
    normalised = _protect_string_literals(normalised)
    normalised = _normalise_numeric_powers(normalised)
    normalised = _normalise_prefix_calls(normalised)
    normalised = _normalise_derivative_calls(normalised)
    normalised = _protect_thread_equal(normalised)
    normalised = _wrap_string_predicates(normalised)
    for original, alias in _PARSER_HEAD_ALIASES.items():
        normalised = _replace_identifier(normalised, original, alias)
    # SymPy's Mathematica parser eagerly constructs Max/Min and rejects a
    # Wolfram list as one incomparable argument. Protect those heads so the
    # bounded lowering below receives the original argument sequence.
    normalised = _replace_identifier(normalised, "Max", "fortsymMax")
    normalised = _replace_identifier(normalised, "Min", "fortsymMin")
    greek_restore = {}
    for character, safe_name in _GREEK_PARSE_NAMES.items():
        if character not in normalised:
            continue
        normalised = re.sub(
            rf"(?<![\\w$]){re.escape(character)}(?![\\w$])",
            safe_name,
            normalised,
        )
        greek_restore[safe_name] = character
    parser_restore = {}
    for name in _PARSER_RESERVED_NAMES:
        if re.search(
            rf"(?<![A-Za-z0-9$]){re.escape(name)}(?![A-Za-z0-9$])",
            normalised,
        ):
            safe_name = f"fortsymParserName{name.capitalize()}"
            normalised = _replace_identifier(normalised, name, safe_name)
            parser_restore[safe_name] = name
    protected, parse_environment, restore = _protect_bound_names(
        normalised, environment
    )
    # A protected parser name still needs to lower to the original symbol in
    # operator arguments.  Otherwise ``D[r, zeta]`` differentiates with
    # respect to the temporary parser spelling while ``r`` contains the
    # restored symbol.
    parse_environment.update(
        {safe: sp.Symbol(original) for safe, original in parser_restore.items()}
    )
    parse_names = dict(greek_restore)
    parse_names.update(parser_restore)
    if parse_names:
        parse_environment = {
            name: _rename_parse_names(value, parse_names)
            for name, value in parse_environment.items()
        }
    parsed = parse_mathematica(protected)
    restore.update(greek_restore)
    restore.update(parser_restore)
    return _restore_names(_lower(parsed, parse_environment), restore)


def _lower(expression, environment: dict[str, object]):
    if isinstance(expression, sp.Symbol):
        value = environment.get(str(expression), expression)
        # A Wolfram function has a value only when applied.  In a bare
        # position (for example ``Array[a, ...]`` or a matrix containing the
        # symbol ``a``) it remains a symbol.
        return sp.Symbol(str(expression)) if isinstance(value, WolframFunction) else value
    if isinstance(expression, sp.Tuple):
        lowered = tuple(_lower(arg, environment) for arg in expression)
        # SymPy tuples sympify their members.  A list of Wolfram rules is a
        # perfectly valid Wolfram value but a Rule is intentionally kept as a
        # small Python object until ReplaceAll consumes it.
        if any(isinstance(arg, (WolframRule, tuple, list)) for arg in lowered):
            return tuple(lowered)
        return sp.Tuple(*lowered)
    if expression.is_Atom:
        return expression

    name = _head_name(expression)
    if name == "Lambda":
        parameters = _sequence_items(expression.args[0])
        if parameters is None:
            parameters = (expression.args[0],)
        return WolframPureFunction(tuple(parameters), expression.args[1], environment)
    if name == "Module":
        return _module(expression.args, environment)
    if name == "With":
        return _with(expression.args, environment)
    if name == "Map":
        return _map(expression.args, environment)
    if name == "Select":
        return _select(expression.args, environment)
    if name == "MapThread":
        return _map_thread(expression.args, environment)
    if name == "Apply":
        return _apply(expression.args, environment)
    if name == "Array":
        return _array(expression.args, environment)
    if name == "ConstantArray":
        return _constant_array(expression.args, environment)
    if name == "Outer":
        return _outer(expression.args, environment)
    if name == "Thread":
        return _thread(expression.args, environment)
    if name == "_Str":
        literal = _raw_string_literal(expression)
        if literal is None:
            raise NotImplementedError("malformed string literal")
        return _string_atom(literal)
    if name == "Slot":
        if len(expression.args) != 1 or not _is_integer(expression.args[0]):
            raise NotImplementedError("Slot needs one positive integer index")
        index = int(expression.args[0])
        if index < 1:
            raise NotImplementedError("Slot indices are one-based")
        value = environment.get(f"__fortsymSlot{index}")
        if value is None:
            raise NotImplementedError(
                "Slot is translated only as an argument of a bounded pure function"
            )
        return value
    if name == "SlotSequence":
        raise NotImplementedError("SlotSequence is outside the bounded translator")
    arguments = tuple(_lower(arg, environment) for arg in expression.args)
    bound = environment.get(name)
    if isinstance(bound, WolframFunction):
        return bound.call(arguments)

    if name == "fortsymSubscript":
        if len(arguments) != 2:
            raise NotImplementedError("Subscript needs a base and one index")
        # Subscript is notation for a symbolic label in this corpus, not a
        # Python sequence access. Keep its two arguments explicit so R_0 and
        # B_0 cannot collide with ordinary names or be mistaken for a list.
        return sp.Function("Subscript")(*arguments)
    if name == "fortsymStringMatchQ":
        return _string_match(arguments)
    if name == "fortsymStringReplace":
        return _string_replace(arguments)
    if name == "fortsymToExpression":
        return _to_expression(arguments)

    if name == "D":
        return _differentiate(arguments)
    if name == "DSolve":
        return _dsolve(arguments)
    if name in ("Simplify", "FullSimplify"):
        return sp.simplify(arguments[0])
    if name in ("Expand", "ExpandAll"):
        return sp.expand(arguments[0])
    if name == "Factor":
        return sp.factor(arguments[0])
    if name == "Coefficient":
        return _coefficient(arguments)
    if name == "CoefficientList":
        return _coefficient_list(arguments)
    if name == "Exponent":
        return _exponent(arguments)
    if name == "PolynomialGCD":
        return _polynomial_gcd(arguments)
    if name in ("PolynomialQuotient", "PolynomialRemainder"):
        return _polynomial_division(arguments, name == "PolynomialQuotient")
    if name in ("Numerator", "Denominator"):
        return _numerator_or_denominator(arguments, name == "Numerator")
    if name in ("Together", "Cancel", "Apart"):
        return getattr(sp, name.lower())(arguments[0])
    if name == "Collect":
        return sp.collect(arguments[0], arguments[1])
    if name == "TrigReduce":
        return _trig_reduce(arguments)
    if name == "Integrate":
        # Wolfram's first range is the outermost one: later ranges are
        # evaluated inside it and may refer to its variable. SymPy's
        # multi-limit API consumes the innermost range first, so reverse the
        # explicit ranges at this boundary.
        limits = [
            argument
            for argument in arguments[1:]
            if not isinstance(argument, WolframRule)
        ]
        return sp.integrate(
            arguments[0],
            *reversed(limits),
        )
    if name == "Limit":
        return _limit(arguments)
    if name == "Series":
        return _series(arguments)
    if name == "Normal":
        return arguments[0].removeO() if hasattr(arguments[0], "removeO") else arguments[0]
    if name in ("N", "SetPrecision"):
        precision = int(arguments[1]) if len(arguments) > 1 else 15
        return _evalf(arguments[0], precision)
    if name == "Solve":
        return _solve(arguments)
    if name == "Sum":
        return sp.summation(
            arguments[0],
            *[argument for argument in arguments[1:] if not isinstance(argument, WolframRule)],
        )
    if name == "Product":
        return sp.product(
            arguments[0],
            *[argument for argument in arguments[1:] if not isinstance(argument, WolframRule)],
        )
    if name == "Table":
        return _table(arguments)
    if name == "Range":
        return _range(arguments)
    if name == "Position":
        return _position(arguments)
    if name == "Union":
        return _union(arguments)
    if name == "Append":
        return _append(arguments)
    if name == "Flatten":
        return _flatten(arguments)
    if name == "Join":
        return sp.Tuple(*(item for argument in arguments for item in _sequence_items(argument)))
    if name == "Reverse":
        return sp.Tuple(*reversed(_sequence_items(arguments[0])))
    if name == "First":
        return _sequence_items(arguments[0])[0]
    if name == "Last":
        return _sequence_items(arguments[0])[-1]
    if name == "Rest":
        return sp.Tuple(*_sequence_items(arguments[0])[1:])
    if name == "Most":
        return _most(arguments)
    if name == "Take":
        return _take(arguments)
    if name == "Drop":
        return _drop(arguments)
    if name == "FoldList":
        return _fold_list(arguments)
    if name == "Total":
        return sp.Add(*_sequence_items(arguments[0]))
    if name == "SingularValueList":
        return _singular_value_list(arguments)
    if name in ("fortsymMax", "fortsymMin"):
        return _numeric_extremum(arguments, name[7:])
    if name == "Tr":
        matrix = _matrix(arguments[0])
        return sp.Add(*(matrix[index, index] for index in range(min(matrix.rows, matrix.cols))))
    if name == "Length":
        return sp.Integer(len(_sequence_items(arguments[0])))
    if name == "If":
        return _if(arguments)
    if name == "MatrixForm" or name == "TableForm":
        return arguments[0]
    if name == "IdentityMatrix":
        return _identity_matrix(arguments)
    if name == "DiagonalMatrix":
        return _diagonal_matrix(arguments)
    if name == "MatrixRank":
        return _matrix(arguments[0]).rank()
    if name == "RowReduce":
        return _matrix_to_tuple(_matrix(arguments[0]).rref()[0])
    if name == "NullSpace":
        return sp.Tuple(*(_vector_to_tuple(vector) for vector in _matrix(arguments[0]).nullspace()))
    if name == "PseudoInverse":
        return _matrix_to_tuple(_matrix(arguments[0]).pinv())
    if name == "LinearSolve":
        solution = _matrix(arguments[0]).inv() * _column_matrix(arguments[1])
        return _vector_to_tuple(solution)
    if name == "CharacteristicPolynomial":
        return _matrix(arguments[0]).charpoly(arguments[1]).as_expr()
    if name == "Minors":
        return _minors(arguments)
    if name == "KroneckerProduct":
        result = _matrix(arguments[0])
        for argument in arguments[1:]:
            result = result.kronecker_product(_matrix(argument))
        return _matrix_to_tuple(result)
    if name == "ArrayFlatten":
        return _array_flatten(arguments[0])
    if name == "MatrixPower":
        return _matrix_to_tuple(_matrix(arguments[0]) ** int(arguments[1]))
    if name == "MatrixExp":
        return _matrix_to_tuple(_matrix(arguments[0]).exp())
    if name == "Diagonal":
        if len(arguments) != 1 or not _is_nested_sequence(arguments[0]):
            return sp.Function("Diagonal")(*arguments)
        matrix = _matrix(arguments[0])
        return sp.Tuple(*(matrix[i, i] for i in range(min(matrix.rows, matrix.cols))))
    if name == "LegendreP":
        if len(arguments) == 2 and _is_integer(arguments[0]) and int(arguments[0]) >= 0:
            return sp.legendre(int(arguments[0]), arguments[1])
        if (
            len(arguments) == 3
            and all(_is_integer(argument) for argument in arguments[:2])
            and int(arguments[0]) >= 0
        ):
            return sp.assoc_legendre(int(arguments[0]), int(arguments[1]), arguments[2])
        return sp.Function("LegendreP")(*arguments)
    if name == "Rule":
        return WolframRule(arguments[0], arguments[1])
    if name == "RuleDelayed":
        return WolframRule(arguments[0], arguments[1])
    if name == "ReplaceAll":
        return _replace_all(arguments)
    if name == "Part":
        return _part(arguments)
    if name == "Transpose":
        return _matrix_to_tuple(_matrix(arguments[0]).T)
    if name == "Dot":
        return _dot(arguments)
    if name == "Cross":
        return _cross(arguments)
    if name == "Det":
        return _matrix(arguments[0]).det()
    if name == "Inverse":
        return _matrix_to_tuple(_matrix(arguments[0]).inv())
    if name == "Piecewise":
        return _piecewise(arguments)
    if name == "Boole":
        return _boole(arguments)
    if name == "Which":
        return _which(arguments)
    if name == "Add":
        return _elementwise_add(arguments)
    if name == "Mul":
        return _elementwise_mul(arguments)
    if name == "Pow":
        return _power(arguments)
    if name == "Equality" and any(_is_sequence(argument) for argument in arguments):
        return sp.And(*(_elementwise_equal(arguments[0], arguments[1])))

    # Mathematica's parser already maps arithmetic and standard functions to
    # SymPy heads. Rebuilding them after recursively lowering the arguments
    # preserves those semantics and keeps unknown applied functions opaque.
    try:
        return expression.func(*arguments)
    except Exception as exc:
        raise NotImplementedError(f"{name} is not lowerable: {exc}") from exc


def _differentiate(arguments: tuple[object, ...]):
    if len(arguments) < 2:
        raise NotImplementedError("D needs an expression and a variable")
    result = arguments[0]
    for specification in arguments[1:]:
        if isinstance(specification, sp.Tuple) and len(specification) == 2:
            result = _differentiate_value(
                result, specification[0], int(specification[1])
            )
        else:
            result = _differentiate_value(result, specification, 1)
    return result


def _module(arguments: tuple[object, ...], environment: dict[str, object]):
    """Lower the bounded lexical ``Module`` form used by the corpus.

    This deliberately covers local symbol declarations, initializer values,
    and sequential ``Set`` statements in the body.  Wolfram's full Module
    semantics include generated names, local function definitions, and
    scoping of many procedural constructs; those remain outside this small
    deterministic translator rather than being guessed here.
    """

    if len(arguments) != 2:
        raise NotImplementedError("Module needs local declarations and a body")
    declarations = _sequence_items(arguments[0])
    if declarations is None:
        raise NotImplementedError("Module declarations must be a list")

    local = dict(environment)
    names: dict[str, sp.Symbol] = {}
    initializers: list[tuple[str, object]] = []
    for declaration in declarations:
        head = _head_name(declaration)
        if head == "Set" and len(declaration.args) == 2:
            target = declaration.args[0]
            if not isinstance(target, sp.Symbol):
                raise NotImplementedError("Module initializers need symbol names")
            name = str(target)
            initializers.append((name, declaration.args[1]))
        elif isinstance(declaration, sp.Symbol):
            name = str(declaration)
        else:
            raise NotImplementedError("Module declarations need symbols or Set initializers")
        # Fresh symbols keep nested Modules lexically distinct when an
        # uninitialized local survives into the returned expression.
        names.setdefault(name, sp.Dummy(name))

    local.update(names)
    for name, initializer in initializers:
        local[name] = _lower(initializer, local)
    return _lower_module_body(arguments[1], local)


def _with(arguments: tuple[object, ...], environment: dict[str, object]):
    """Lower the bounded lexical ``With`` form used by the corpus.

    Wolfram evaluates all local initializers in the surrounding environment,
    then substitutes those values into the body. Keeping that two-phase order
    matters for sibling bindings such as ``{a = 1, b = a + 1}``.
    """

    if len(arguments) != 2:
        raise NotImplementedError("With needs local declarations and a body")
    declarations = _sequence_items(arguments[0])
    if declarations is None:
        raise NotImplementedError("With declarations must be a list")

    local = dict(environment)
    for declaration in declarations:
        if _head_name(declaration) != "Set" or len(declaration.args) != 2:
            raise NotImplementedError("With declarations need symbol initializers")
        target, initializer = declaration.args
        if not isinstance(target, sp.Symbol):
            raise NotImplementedError("With declarations need symbol names")
        local[str(target)] = _lower(initializer, environment)
    return _lower(arguments[1], local)


def _lower_module_body(expression, environment: dict[str, object]):
    """Evaluate the sequential statement subset accepted inside Module."""

    if _head_name(expression) == "CompoundExpression":
        if not expression.args:
            raise NotImplementedError("empty Module body")
        result = None
        for statement in expression.args:
            result = _lower_module_statement(statement, environment)
        return result
    return _lower_module_statement(expression, environment)


def _lower_module_statement(expression, environment: dict[str, object]):
    if _head_name(expression) == "Set" and len(expression.args) == 2:
        target, value = expression.args
        if not isinstance(target, sp.Symbol):
            raise NotImplementedError("Module assignments need symbol targets")
        lowered = _lower(value, environment)
        environment[str(target)] = lowered
        return lowered
    if _head_name(expression) == "SetDelayed":
        raise NotImplementedError("Module local function definitions are not translated")
    return _lower(expression, environment)


def _dsolve(arguments: tuple[object, ...]):
    """Lower the bounded scalar first-order ODE form used by the corpus."""

    if len(arguments) < 2 or not isinstance(arguments[0], sp.Equality):
        raise NotImplementedError("DSolve needs one scalar differential equation")
    equation = arguments[0]
    function = arguments[1]
    if isinstance(function, sp.Basic) and function.is_Function:
        function = function.func
    elif not isinstance(function, sp.FunctionClass):
        raise NotImplementedError("DSolve needs a callable dependent variable")
    variable = arguments[2] if len(arguments) > 2 else None
    if variable is None or not isinstance(variable, sp.Symbol):
        raise NotImplementedError("DSolve needs one independent variable")
    trial = function(variable)
    if not equation.has(trial) and not equation.has(sp.Derivative(trial, variable)):
        raise NotImplementedError("DSolve equation does not contain the requested function")
    solution = sp.dsolve(equation, trial)
    # SymPy names integration constants C1, C2, ...; Wolfram's DSolve emits
    # callable constants C[1], C[2], ... and later corpus code addresses them
    # with Solve[C[1], ...]. Preserve the Wolfram spelling at this boundary.
    constants = {
        sp.Symbol(f"C{index}"): sp.Function("C")(index)
        for index in range(1, 10)
    }
    right = solution.rhs.xreplace(constants)
    rule = sp.Function("Rule")(trial, right)
    return sp.Tuple(sp.Tuple(rule))


def _differentiate_value(value, variable, order: int):
    """Differentiate Wolfram lists componentwise.

    SymPy represents a derivative of a tuple of non-scalar expressions as an
    ``ArrayDerivative``. Wolfram's ``D`` maps over ``List`` instead, and the
    componentwise result is also what the native evaluator and Mathics expose.
    Keep nested tuples as lists of independently differentiated values.
    """
    items = _sequence_items(value)
    if items is not None:
        return sp.Tuple(
            *(_differentiate_value(item, variable, order) for item in items)
        )
    return sp.diff(value, variable, order)


def _limit(arguments: tuple[object, ...]):
    if len(arguments) < 2 or not isinstance(arguments[1], WolframRule):
        raise NotImplementedError("Limit needs a variable rule")
    rule = arguments[1]
    return sp.limit(arguments[0], rule.left, rule.right)


def _series(arguments: tuple[object, ...]):
    if len(arguments) < 2 or not isinstance(arguments[1], sp.Tuple):
        raise NotImplementedError("Series needs a {variable, point, order} range")
    variable, point, order = arguments[1]
    return sp.series(arguments[0], variable, point, int(order) + 1).removeO()


def _table(arguments: tuple[object, ...]):
    if len(arguments) < 2:
        raise NotImplementedError("Table needs a range")
    ranges = [_table_range(argument) for argument in arguments[1:]]

    def build(level: int, body):
        if level == len(ranges):
            return body
        variable, values = ranges[level]
        children = []
        for value in values:
            replaced = _substitute(body, variable, value) if variable is not None else body
            children.append(build(level + 1, replaced))
        return sp.Tuple(*children)

    return build(0, arguments[0])


def _thread(raw_arguments, environment):
    """Thread one explicit Wolfram expression over its list arguments."""

    if len(raw_arguments) != 1:
        raise NotImplementedError("Thread takes one expression")
    expression = raw_arguments[0]
    head = _head_name(expression)
    if head == "fortsymThreadEqual":
        return _thread_equal(expression.args, environment)
    if isinstance(expression, sp.Equality):
        return _thread_equal(expression.args, environment)

    arguments = tuple(_lower(argument, environment) for argument in expression.args)
    sequences = [_sequence_items(argument) for argument in arguments]
    lengths = {len(items) for items in sequences if items is not None}
    if not lengths:
        return _lower(expression, environment)
    if len(lengths) != 1:
        raise NotImplementedError("Thread list lengths do not match")
    length = lengths.pop()
    values = []
    for index in range(length):
        items = tuple(
            sequence[index] if sequence is not None else argument
            for argument, sequence in zip(arguments, sequences)
        )
        values.append(_lower(expression.func(*items), environment))
    return sp.Tuple(*values)


def _thread_equal(raw_arguments, environment):
    if len(raw_arguments) != 2:
        raise NotImplementedError("Thread Equal needs two arguments")
    arguments = tuple(_lower(argument, environment) for argument in raw_arguments)
    sequences = [_sequence_items(argument) for argument in arguments]
    lengths = {len(items) for items in sequences if items is not None}
    if not lengths:
        return sp.Eq(*arguments)
    if len(lengths) != 1:
        raise NotImplementedError("Thread Equal list lengths do not match")
    length = lengths.pop()
    left, right = arguments
    left_items, right_items = sequences
    return sp.Tuple(
        *(
            sp.Eq(
                left_items[index] if left_items is not None else left,
                right_items[index] if right_items is not None else right,
            )
            for index in range(length)
        )
    )


def _resolve_mapper(raw_mapper, environment):
    if isinstance(raw_mapper, sp.Symbol):
        bound = environment.get(str(raw_mapper))
        if isinstance(bound, (WolframFunction, WolframPureFunction)):
            return bound
    return _lower(raw_mapper, environment)


def _call_mapper(mapper, arguments, environment):
    if isinstance(mapper, (WolframFunction, WolframPureFunction)):
        return mapper.call(tuple(arguments))
    if isinstance(mapper, sp.Symbol):
        return _lower(sp.Function(str(mapper))(*arguments), environment)
    raise NotImplementedError("Map needs a named or pure function")


def _map(expression_arguments, environment):
    if len(expression_arguments) not in (2, 3):
        raise NotImplementedError("Map needs a function and a list")
    mapper = _resolve_mapper(expression_arguments[0], environment)
    level = 1
    if len(expression_arguments) == 3:
        specification = _sequence_items(
            _lower(expression_arguments[2], environment)
        )
        if specification is None or len(specification) != 1:
            raise NotImplementedError("Map level must be a one-item list")
        level = specification[0]
        if not _is_integer(level) or not 1 <= int(level) <= MAX_MAP_LEVEL:
            raise NotImplementedError("Map level is outside the bounded subset")
        level = int(level)
    budget = [MAX_MAP_NODES]
    return _map_values(
        mapper, _lower(expression_arguments[1], environment), level, environment, budget
    )


def _map_values(mapper, value, level, environment, budget):
    values = _sequence_items(value)
    if values is None:
        raise NotImplementedError("Map needs a list at the requested level")
    if len(values) > budget[0]:
        raise NotImplementedError("Map expansion exceeds its safety bound")
    budget[0] -= len(values)
    if level == 1:
        return sp.Tuple(
            *(_call_mapper(mapper, (item,), environment) for item in values)
        )
    return sp.Tuple(
        *(_map_values(mapper, item, level - 1, environment, budget) for item in values)
    )


def _select(expression_arguments, environment):
    """Lower ``Select[list, predicate]`` for a concrete bounded list."""

    if len(expression_arguments) != 2:
        raise NotImplementedError("Select needs a list and one predicate")
    values = _sequence_items(_lower(expression_arguments[0], environment))
    if values is None:
        raise NotImplementedError("Select needs an explicit list")
    predicate = _resolve_mapper(expression_arguments[1], environment)
    selected = []
    for value in values:
        result = _call_mapper(predicate, (value,), environment)
        if result is True or result is sp.true:
            selected.append(value)
        elif result is False or result is sp.false:
            continue
        else:
            raise NotImplementedError("Select predicate did not resolve to True or False")
    return sp.Tuple(*selected)


def _map_thread(expression_arguments, environment):
    if len(expression_arguments) != 2:
        raise NotImplementedError("MapThread needs a function and lists")
    mapper = _resolve_mapper(expression_arguments[0], environment)
    rows = _sequence_items(_lower(expression_arguments[1], environment))
    if rows is None:
        raise NotImplementedError("MapThread needs a list of lists")
    columns = [_sequence_items(row) for row in rows]
    if any(column is None for column in columns):
        raise NotImplementedError("MapThread needs a list of lists")
    if not columns:
        return sp.Tuple()
    if len({len(column) for column in columns}) != 1:
        raise NotImplementedError("MapThread list lengths do not match")
    return sp.Tuple(
        *(
            _call_mapper(mapper, tuple(column[index] for column in columns), environment)
            for index in range(len(columns[0]))
        )
    )


def _apply(expression_arguments, environment):
    if len(expression_arguments) != 2:
        raise NotImplementedError("Apply needs a function and an expression")
    raw_mapper, raw_value = expression_arguments
    value = _lower(raw_value, environment)
    items = _sequence_items(value)
    if items is None:
        raise NotImplementedError("Apply needs an explicit expression head")
    mapper = _resolve_mapper(raw_mapper, environment)
    if isinstance(mapper, (WolframFunction, WolframPureFunction)):
        return mapper.call(tuple(items))
    if not isinstance(raw_mapper, sp.Symbol):
        raise NotImplementedError("Apply needs a named head")
    name = str(raw_mapper)
    if name == "Plus":
        return sp.Add(*items)
    if name == "Times":
        return sp.Mul(*items)
    if name == "List":
        return sp.Tuple(*items)
    return _lower(sp.Function(name)(*items), environment)


def _table_range(specification):
    items = _sequence_items(specification)
    if not items:
        raise NotImplementedError("empty Table range")
    if len(items) == 1:
        count = items[0]
        if not _is_integer(count) or int(count) < 0:
            raise NotImplementedError("Table needs concrete bounds")
        return None, tuple(sp.Integer(index) for index in range(1, int(count) + 1))

    variable, bound = items[0], items[1]
    if _is_sequence(bound):
        return variable, _sequence_items(bound)
    if len(items) == 2:
        lower, upper, step = sp.Integer(1), bound, sp.Integer(1)
    elif len(items) == 3:
        lower, upper, step = items[1], items[2], sp.Integer(1)
    elif len(items) == 4:
        lower, upper, step = items[1], items[2], items[3]
    else:
        raise NotImplementedError("malformed Table range")
    return variable, _numeric_range(lower, upper, step)


def _range(arguments: tuple[object, ...]):
    if not 1 <= len(arguments) <= 3:
        raise NotImplementedError("Range needs one to three bounds")
    if len(arguments) == 1:
        lower, upper, step = sp.Integer(1), arguments[0], sp.Integer(1)
    elif len(arguments) == 2:
        lower, upper, step = arguments[0], arguments[1], sp.Integer(1)
    else:
        lower, upper, step = arguments
    return sp.Tuple(*_numeric_range(lower, upper, step))


def _position(arguments: tuple[object, ...]):
    """Return bounded one-based positions, including explicit heads.

    The corpus uses the two-argument form.  Wolfram positions expose a head
    at index zero, so ``Position[expr, Power]`` finds the heads of power
    subexpressions while ordinary list matches retain their one-based child
    indices.  Levels, options, and other pattern constructs remain unsupported.
    """

    if len(arguments) != 2:
        raise NotImplementedError("Position needs an expression and a pattern")
    value, pattern = arguments
    positions: list[sp.Tuple] = []

    def visit(item, path: tuple[int, ...]) -> None:
        if isinstance(pattern, sp.Symbol):
            if _head_matches(item, pattern):
                positions.append(sp.Tuple(*(path + (0,))))
            elif item == pattern:
                positions.append(sp.Tuple(*path))
        elif _position_pattern_matches(item, pattern):
            positions.append(sp.Tuple(*path))

        children = _sequence_items(item)
        if children is None and isinstance(item, sp.Basic) and not item.is_Atom:
            children = item.args
        if children is None:
            return
        for index, child in enumerate(children, start=1):
            visit(child, path + (index,))

    visit(value, ())
    return sp.Tuple(*positions)


def _head_matches(value, pattern: sp.Symbol) -> bool:
    """Match a plain Wolfram head name against a SymPy value."""

    name = str(pattern)
    aliases = {
        "Power": "Pow",
        "Plus": "Add",
        "Times": "Mul",
        "List": "Tuple",
        "Log": "log",
        "Exp": "exp",
    }
    return _head_name(value) == aliases.get(name, name)


def _position_pattern_matches(value, pattern) -> bool:
    """Match the corpus's bounded blank-power pattern."""

    if (
        isinstance(pattern, sp.Pow)
        and len(pattern.args) == 2
        and all(
            getattr(argument, "func", None).__name__ == "Pattern"
            and len(argument.args) == 2
            and getattr(argument.args[1].func, "__name__", "") == "Blank"
            for argument in pattern.args
        )
    ):
        return isinstance(value, sp.Pow)
    return value == pattern


def _union(arguments: tuple[object, ...]):
    """Flatten one level of explicit lists, remove duplicates, and sort."""

    if not arguments or any(not _is_sequence(argument) for argument in arguments):
        raise NotImplementedError("Union needs explicit list arguments")
    values = []
    for argument in arguments:
        for item in _sequence_items(argument):
            if not any(item == previous for previous in values):
                values.append(item)
    return sp.Tuple(*sorted(values, key=sp.default_sort_key))


def _numeric_range(lower, upper, step):
    if not all(_is_numeric(value) for value in (lower, upper, step)):
        raise NotImplementedError("symbolic range bounds are not translated")
    if step == 0:
        raise NotImplementedError("range step cannot be zero")
    quotient = sp.cancel((upper - lower) / step)
    count = int(sp.floor(quotient)) + 1 if quotient >= 0 else 0
    return tuple(lower + index * step for index in range(count))


def _append(arguments: tuple[object, ...]):
    if len(arguments) != 2:
        raise NotImplementedError("Append needs a list and a value")
    return sp.Tuple(*_sequence_items(arguments[0]), arguments[1])


def _flatten(arguments: tuple[object, ...]):
    if not arguments:
        raise NotImplementedError("Flatten needs a list")
    level = None
    if len(arguments) > 1:
        if not _is_integer(arguments[1]):
            raise NotImplementedError("symbolic Flatten level is not translated")
        level = int(arguments[1])

    def flatten(value, remaining):
        items = _sequence_items(value)
        if items is None or remaining == 0:
            return [value]
        next_level = None if remaining is None else remaining - 1
        flattened = []
        for item in items:
            flattened.extend(flatten(item, next_level))
        return flattened

    return sp.Tuple(*flatten(arguments[0], level))


def _take(arguments: tuple[object, ...]):
    if len(arguments) != 2:
        raise NotImplementedError("Take needs a list and a specification")
    items = _sequence_items(arguments[0])
    specification = arguments[1]
    if _is_integer(specification):
        count = int(specification)
        selected = items[:count] if count >= 0 else items[count:]
    else:
        bounds = _sequence_items(specification)
        if len(bounds) != 2 or not all(_is_integer(bound) for bound in bounds):
            raise NotImplementedError("Take specification is not translated")
        start, stop = (int(bound) for bound in bounds)
        start = _selector_index(start, len(items))
        stop = _selector_index(stop, len(items))
        selected = items[start - 1:stop] if start <= stop else ()
    return sp.Tuple(*selected)


def _most(arguments: tuple[object, ...]):
    if len(arguments) != 1:
        raise NotImplementedError("Most needs one list")
    items = _sequence_items(arguments[0])
    if items is None or not items:
        raise NotImplementedError("Most needs a non-empty list")
    return sp.Tuple(*items[:-1])


def _drop(arguments: tuple[object, ...]):
    if len(arguments) != 2:
        raise NotImplementedError("Drop needs a list and a specification")
    items = _sequence_items(arguments[0])
    if items is None:
        raise NotImplementedError("Drop needs a list")
    specification = arguments[1]
    if _is_integer(specification):
        count = int(specification)
        selected = items[count:] if count >= 0 else items[:count]
    else:
        bounds = _sequence_items(specification)
        if len(bounds) != 2 or not all(_is_integer(bound) for bound in bounds):
            raise NotImplementedError("Drop specification is not translated")
        start, stop = (int(bound) for bound in bounds)
        start = _selector_index(start, len(items))
        stop = _selector_index(stop, len(items))
        selected = items[: start - 1] + items[stop:] if start <= stop else items
    return sp.Tuple(*selected)


def _fold_list(arguments: tuple[object, ...]):
    """Evaluate the bounded Wolfram ``FoldList[Plus, init, list]`` form."""

    if len(arguments) != 3:
        raise NotImplementedError("FoldList needs an operation, initial value, and list")
    operation, accumulator, sequence = arguments
    items = _sequence_items(sequence)
    if items is None:
        raise NotImplementedError("FoldList needs an explicit list")
    if not isinstance(operation, sp.Symbol) or str(operation) != "Plus":
        raise NotImplementedError("FoldList supports Plus only")
    values = [accumulator]
    for item in items:
        accumulator = accumulator + item
        values.append(accumulator)
    return sp.Tuple(*values)


def _selector_index(value: int, length: int) -> int:
    if value == 0:
        raise NotImplementedError("selector indices are one-based")
    index = value if value > 0 else length + value + 1
    if not 1 <= index <= length:
        raise NotImplementedError("selector index is outside the sequence")
    return index


def _if(arguments: tuple[object, ...]):
    if len(arguments) not in (2, 3):
        raise NotImplementedError("If needs two or three arguments")
    condition = arguments[0]
    then_value = arguments[1]
    else_value = arguments[2] if len(arguments) == 3 else sp.Integer(0)
    if condition is True or condition == sp.true:
        return then_value
    if condition is False or condition == sp.false:
        return else_value
    return sp.Piecewise((then_value, condition), (else_value, True))


def _identity_matrix(arguments: tuple[object, ...]):
    if len(arguments) != 1 or not _is_integer(arguments[0]):
        raise NotImplementedError("IdentityMatrix needs an integer size")
    return _matrix_to_tuple(sp.eye(int(arguments[0])))


def _diagonal_matrix(arguments: tuple[object, ...]):
    if not arguments:
        raise NotImplementedError("DiagonalMatrix needs a vector")
    values = _sequence_items(arguments[0])
    offset = int(arguments[1]) if len(arguments) > 1 and _is_integer(arguments[1]) else 0
    matrix = sp.zeros(len(values) + abs(offset))
    for index, value in enumerate(values):
        row = index + max(0, -offset)
        column = index + max(0, offset)
        matrix[row, column] = value
    return _matrix_to_tuple(matrix)


def _array(expression_arguments, environment):
    if len(expression_arguments) < 2:
        raise NotImplementedError("Array needs a head and dimensions")
    head = expression_arguments[0]
    dimensions = _sequence_items(_lower(expression_arguments[1], environment))
    if dimensions is None:
        dimensions = (_lower(expression_arguments[1], environment),)
    if not all(_is_integer(dimension) for dimension in dimensions):
        raise NotImplementedError("symbolic Array dimensions are not translated")
    origin = (
        _lower(expression_arguments[2], environment)
        if len(expression_arguments) > 2
        else sp.Integer(1)
    )

    def apply(indices):
        bound = environment.get(str(head)) if isinstance(head, sp.Symbol) else None
        if isinstance(bound, WolframFunction):
            return bound.call(tuple(indices))
        if isinstance(head, sp.Symbol):
            return sp.Function(str(head))(*indices)
        return _lower(head, environment)

    def build(level, prefix):
        if level == len(dimensions):
            return apply(prefix)
        size = int(dimensions[level])
        values = [origin + index for index in range(size)]
        return sp.Tuple(*(build(level + 1, prefix + (value,)) for value in values))

    return build(0, ())


def _constant_array(expression_arguments, environment):
    if len(expression_arguments) != 2:
        raise NotImplementedError("ConstantArray needs a value and dimensions")
    value = _lower(expression_arguments[0], environment)
    dimensions = _sequence_items(_lower(expression_arguments[1], environment))
    if dimensions is None:
        dimensions = (_lower(expression_arguments[1], environment),)

    def build(level):
        if level == len(dimensions):
            return value
        return sp.Tuple(*(build(level + 1) for _ in range(int(dimensions[level]))))

    return build(0)


def _outer(expression_arguments, environment):
    if len(expression_arguments) < 3:
        raise NotImplementedError("Outer needs a head and two lists")
    raw_head = expression_arguments[0]
    head = _lower(raw_head, environment)
    lists = [_sequence_items(_lower(argument, environment)) for argument in expression_arguments[1:]]
    if any(items is None for items in lists):
        raise NotImplementedError("Outer needs list arguments")

    def apply(values):
        name = str(raw_head)
        if name == "Times":
            return _elementwise_mul(values) if any(_is_sequence(value) for value in values) else sp.Mul(*values)
        if name == "Plus":
            return _elementwise_add(values) if any(_is_sequence(value) for value in values) else sp.Add(*values)
        if name == "List":
            return sp.Tuple(*values)
        if name == "Dot":
            return _dot(tuple(values))
        if isinstance(head, WolframFunction):
            return head.call(tuple(values))
        if isinstance(raw_head, sp.Symbol):
            return sp.Function(str(raw_head))(*values)
        return head(*values)

    def build(level, prefix):
        if level == len(lists):
            return apply(prefix)
        return sp.Tuple(*(build(level + 1, prefix + (value,)) for value in lists[level]))

    return build(0, ())


def _dot(arguments: tuple[object, ...]):
    if len(arguments) < 2:
        raise NotImplementedError("Dot needs at least two arguments")
    result = arguments[0]
    for argument in arguments[1:]:
        result = _dot_two(result, argument)
    return result


def _coefficient(arguments: tuple[object, ...]):
    """Return a Wolfram coefficient using SymPy's expanded expression form."""

    if len(arguments) not in (2, 3):
        raise NotImplementedError("Coefficient needs two or three arguments")
    expression, variable = arguments[:2]
    order = arguments[2] if len(arguments) == 3 else sp.Integer(1)
    if not _is_integer(order) or int(order) < 0:
        raise NotImplementedError("Coefficient power is not a non-negative integer")
    if isinstance(variable, sp.Pow) and _is_integer(variable.exp):
        order = variable.exp
        variable = variable.base
    return sp.expand(expression).coeff(variable, int(order))


def _coefficient_list(arguments: tuple[object, ...]):
    """Return coefficients from constant term upward, including nested lists."""

    if len(arguments) != 2:
        raise NotImplementedError("CoefficientList needs two arguments")
    expression = sp.expand(arguments[0])
    variables = _sequence_items(arguments[1])
    if variables is None:
        variables = (arguments[1],)
    if not variables:
        return sp.Tuple(expression)

    def coefficients(value, index):
        variable = variables[index]
        degree = sp.degree(value, variable)
        if degree is None:
            degree = 0
        degree = int(degree)
        terms = [sp.expand(value).coeff(variable, power) for power in range(degree + 1)]
        if index + 1 == len(variables):
            return sp.Tuple(*terms)
        return sp.Tuple(*(coefficients(term, index + 1) for term in terms))

    return coefficients(expression, 0)


def _exponent(arguments: tuple[object, ...]):
    """Return the largest power of a form in an exact polynomial."""

    if len(arguments) != 2:
        raise NotImplementedError("Exponent needs an expression and a form")
    expression, form = arguments
    try:
        degree = sp.degree(sp.expand(expression), form)
    except sp.PolynomialError:
        degree = _monomial_exponent(expression, form)
    if degree is None:
        return -sp.oo
    return sp.Integer(degree) if isinstance(degree, int) else degree


def _monomial_exponent(expression, form):
    """Handle the bounded monomial form with an exact fractional power."""

    if expression == form:
        return sp.Integer(1)
    if isinstance(expression, sp.Pow) and expression.base == form:
        if expression.exp.is_number:
            return expression.exp
        raise NotImplementedError("Exponent has a non-numeric power")
    if isinstance(expression, sp.Mul):
        total = sp.Integer(0)
        for factor in expression.args:
            if factor.has(form):
                total += _monomial_exponent(factor, form)
        return total
    if not expression.has(form):
        return sp.Integer(0)
    raise NotImplementedError("Exponent needs a polynomial or monomial")


def _polynomial_gcd(arguments: tuple[object, ...]):
    """Return the polynomial gcd, retaining integer content like Wolfram."""

    if len(arguments) != 2:
        raise NotImplementedError("PolynomialGCD needs two polynomials")
    return sp.gcd(arguments[0], arguments[1])


def _polynomial_division(arguments: tuple[object, ...], quotient: bool):
    """Divide two polynomials in the explicitly supplied Wolfram variable."""

    if len(arguments) != 3:
        raise NotImplementedError(
            "PolynomialQuotient and PolynomialRemainder need two polynomials "
            "and a variable"
        )
    dividend, divisor, variable = arguments
    if _is_sequence(variable) or not isinstance(variable, sp.Symbol):
        raise NotImplementedError("polynomial division needs one variable")
    left = sp.Poly(dividend, variable, domain="EX")
    right = sp.Poly(divisor, variable, domain="EX")
    result, remainder = sp.div(left, right)
    return (result if quotient else remainder).as_expr()


def _numerator_or_denominator(arguments: tuple[object, ...], numerator: bool):
    if len(arguments) != 1:
        raise NotImplementedError("Numerator and Denominator take one argument")
    top, bottom = sp.fraction(sp.cancel(arguments[0]))
    return top if numerator else bottom


def _cross(arguments: tuple[object, ...]):
    if len(arguments) != 2:
        return _opaque_cross(arguments)
    left = _sequence_items(arguments[0])
    right = _sequence_items(arguments[1])
    if left is None or right is None or len(left) != 3 or len(right) != 3:
        return _opaque_cross(arguments)
    try:
        return sp.Tuple(
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        )
    except Exception:
        return _opaque_cross(arguments)


def _opaque_cross(arguments: tuple[object, ...]):
    """Keep an unsupported Cross expression visible to the comparator."""

    return sp.Function("Cross")(*arguments)


def _dot_two(left, right):
    left_sequence = _is_sequence(left)
    right_sequence = _is_sequence(right)
    if not left_sequence and not right_sequence:
        return left * right
    if left_sequence and right_sequence:
        left_items = _sequence_items(left)
        right_items = _sequence_items(right)
        left_matrix = _is_nested_sequence(left)
        right_matrix = _is_nested_sequence(right)
        if not left_matrix and not right_matrix:
            if len(left_items) != len(right_items):
                raise NotImplementedError("Dot vector dimensions do not match")
            return sp.Add(*(a * b for a, b in zip(left_items, right_items)))
        if not left_matrix and right_matrix:
            result = sp.Matrix([list(left_items)]) * _matrix(right)
        else:
            result = _matrix(left) * _column_matrix(right)
        if left_matrix and right_matrix:
            return _matrix_to_tuple(result)
        return _vector_to_tuple(result)
    return _elementwise_binary(left, right, sp.Mul)


def _elementwise_add(arguments):
    if not arguments:
        return sp.Integer(0)
    result = arguments[0]
    for argument in arguments[1:]:
        result = _elementwise_binary(result, argument, sp.Add)
    return result


def _elementwise_mul(arguments):
    if not arguments:
        return sp.Integer(1)
    result = arguments[0]
    for argument in arguments[1:]:
        result = _elementwise_binary(result, argument, sp.Mul)
    return result


def _power(arguments):
    if len(arguments) != 2:
        raise NotImplementedError("Power needs two arguments")
    base, exponent = arguments
    if _is_sequence(base):
        if _is_nested_sequence(base) and _is_integer(exponent):
            return _matrix_to_tuple(_matrix(base) ** int(exponent))
        return _elementwise_binary(base, exponent, sp.Pow)
    return sp.Pow(base, exponent)


def _elementwise_binary(left, right, operation):
    if _is_sequence(left) or _is_sequence(right):
        left_items = _sequence_items(left) if _is_sequence(left) else None
        right_items = _sequence_items(right) if _is_sequence(right) else None
        if left_items is not None and right_items is not None:
            if len(left_items) != len(right_items):
                raise NotImplementedError("elementwise dimensions do not match")
            values = [
                _elementwise_binary(a, b, operation)
                for a, b in zip(left_items, right_items)
            ]
        elif left_items is not None:
            values = [_elementwise_binary(a, right, operation) for a in left_items]
        else:
            values = [_elementwise_binary(left, b, operation) for b in right_items]
        return sp.Tuple(*values)
    return operation(left, right)


def _elementwise_equal(left, right):
    if _is_sequence(left) or _is_sequence(right):
        left_items = _sequence_items(left) if _is_sequence(left) else None
        right_items = _sequence_items(right) if _is_sequence(right) else None
        if left_items is not None and right_items is not None:
            return [item for pair in zip(left_items, right_items) for item in _elementwise_equal(*pair)]
        items = left_items if left_items is not None else right_items
        scalar = right if left_items is not None else left
        return [item for value in items for item in _elementwise_equal(value, scalar)]
    return [sp.Eq(left, right)]


def _matrix(value):
    if isinstance(value, sp.MatrixBase):
        return value
    items = _sequence_items(value)
    if items is None:
        return sp.Matrix([[value]])
    if items and all(_is_sequence(item) for item in items):
        return sp.Matrix([list(_sequence_items(item)) for item in items])
    return sp.Matrix(list(items))


def _singular_value_list(arguments):
    """Lower the bounded numeric diagonal/zero SingularValueList form."""
    if len(arguments) != 1:
        raise NotImplementedError("SingularValueList takes one matrix")
    matrix = _matrix(arguments[0])
    opaque = sp.Function("SingularValueList")(*arguments)
    count = min(matrix.rows, matrix.cols)
    values = []
    for row in range(matrix.rows):
        for column in range(matrix.cols):
            value = matrix[row, column]
            if row != column and not value.is_zero:
                return opaque
            if row == column and row < count:
                values.append(sp.Abs(value))
    if not all(value.is_number for value in values):
        return opaque
    values.sort(key=lambda value: float(value), reverse=True)
    return sp.Tuple(*values)


def _numeric_extremum(arguments, name):
    if len(arguments) == 1 and _is_sequence(arguments[0]):
        values = _sequence_items(arguments[0])
    elif all(not _is_sequence(argument) for argument in arguments):
        values = arguments
    else:
        return getattr(sp, name)(*arguments)
    if not values:
        return getattr(sp, name)(*values)
    if not all(value.is_number for value in values):
        return getattr(sp, name)(*values)
    return getattr(sp, name)(*values)


def _column_matrix(value):
    items = _sequence_items(value)
    if items is None:
        return sp.Matrix([value])
    return sp.Matrix(list(items))


def _matrix_to_tuple(value):
    matrix = _matrix(value)
    return sp.Tuple(*(sp.Tuple(*(matrix[row, column] for column in range(matrix.cols))) for row in range(matrix.rows)))


def _vector_to_tuple(value):
    matrix = _matrix(value)
    if matrix.cols == 1:
        return sp.Tuple(*(matrix[row, 0] for row in range(matrix.rows)))
    if matrix.rows == 1:
        return sp.Tuple(*(matrix[0, column] for column in range(matrix.cols)))
    return _matrix_to_tuple(matrix)


def _array_flatten(value):
    rows = _sequence_items(value)
    if rows is None:
        raise NotImplementedError("ArrayFlatten needs a block array")
    row_matrices = []
    for row in rows:
        blocks = _sequence_items(row)
        if blocks is None:
            raise NotImplementedError("ArrayFlatten needs a rectangular block array")
        current = _matrix(blocks[0])
        for block in blocks[1:]:
            current = current.row_join(_matrix(block))
        row_matrices.append(current)
    result = row_matrices[0]
    for row in row_matrices[1:]:
        result = result.col_join(row)
    return _matrix_to_tuple(result)


def _minors(arguments):
    if len(arguments) != 2 or not _is_integer(arguments[1]):
        raise NotImplementedError("Minors needs a matrix and integer order")
    matrix = _matrix(arguments[0])
    order = int(arguments[1])
    if order < 1 or order > min(matrix.rows, matrix.cols):
        raise NotImplementedError("minor order is out of range")
    values = []
    for row_indices in combinations(range(matrix.rows), order):
        row = []
        for column_indices in combinations(range(matrix.cols), order):
            row.append(matrix.extract(row_indices, column_indices).det())
        values.append(sp.Tuple(*row))
    return sp.Tuple(*values)


def _select_part(value, index):
    if isinstance(value, sp.MatrixBase):
        value = _matrix_to_tuple(value)
    items = _sequence_items(value)
    if items is None:
        raise NotImplementedError("Part needs a list-like value")
    if _is_all(index):
        return value
    if _is_sequence(index):
        return sp.Tuple(*(_select_part(value, item) for item in _sequence_items(index)))
    if not _is_integer(index):
        raise NotImplementedError("Part needs integer indices")
    position = int(index)
    if position < 0:
        return items[position]
    return items[position - 1]


def _substitute(value, variable, replacement):
    if variable is None:
        return value
    if hasattr(value, "subs"):
        return value.subs(variable, replacement)
    if _is_sequence(value):
        return sp.Tuple(*(_substitute(item, variable, replacement) for item in _sequence_items(value)))
    return value


def _evalf(value, precision):
    if _is_sequence(value):
        return sp.Tuple(*(_evalf(item, precision) for item in _sequence_items(value)))
    return value.evalf(precision) if hasattr(value, "evalf") else sp.N(value, precision)


def _solve(arguments):
    filtered = tuple(argument for argument in arguments if not isinstance(argument, WolframRule))
    result = sp.solve(*filtered)
    variables = []
    for argument in arguments[1:]:
        if isinstance(argument, WolframRule):
            continue
        items = _sequence_items(argument)
        variables.extend(items if items is not None else (argument,))
    if isinstance(result, dict):
        result = [result]
    if isinstance(result, list):
        rows = []
        for solution in result:
            if isinstance(solution, dict):
                pairs = solution.items()
            elif isinstance(solution, (tuple, list)) and len(variables) == len(solution):
                pairs = zip(variables, solution)
            elif isinstance(solution, (tuple, list)):
                rows.append(sp.Tuple(*solution))
                continue
            else:
                if len(variables) == 1:
                    pairs = ((variables[0], solution),)
                else:
                    rows.append(solution)
                    continue
            rows.append(sp.Tuple(*(sp.Function("Rule")(key, value) for key, value in pairs)))
        return sp.Tuple(*rows)
    return result


def _rules(value):
    if isinstance(value, WolframRule):
        return [value]
    if (
        isinstance(value, sp.Basic)
        and _head_name(value) in ("Rule", "RuleDelayed")
        and len(value.args) == 2
    ):
        return [WolframRule(value.args[0], value.args[1])]
    if _is_sequence(value):
        rules = []
        for item in _sequence_items(value):
            rules.extend(_rules(item))
        return rules
    return []


def _pattern_binding(value):
    """Return the variable from the parser's ``Pattern(x, Blank())`` AST."""

    if (
        isinstance(value, sp.Basic)
        and _head_name(value) == "Pattern"
        and len(value.args) == 2
        and isinstance(value.args[0], sp.Symbol)
        and _head_name(value.args[1]) == "Blank"
        and not value.args[1].args
    ):
        return value.args[0]
    return None


def _contains_pattern(value) -> bool:
    if not isinstance(value, sp.Basic):
        return False
    if _head_name(value) in ("Pattern", "Blank", "BlankSequence", "BlankNullSequence"):
        return True
    return any(_contains_pattern(argument) for argument in value.args)


def _derivative_pattern(value):
    """Recognise one-argument ``Derivative[n][f][x_]`` patterns only."""

    if not isinstance(value, sp.Basic) or _head_name(value) != "Derivative1":
        return None
    if len(value.args) != 3 or not isinstance(value.args[0], sp.Symbol):
        return None
    variable = _pattern_binding(value.args[2])
    if variable is None or not _is_integer(value.args[1]):
        return None
    return value.args[0], value.args[1], variable


def _replace_derivative_pattern(value, rule, pattern):
    function, order, variable = pattern

    def matches(candidate):
        return (
            isinstance(candidate, sp.Basic)
            and _head_name(candidate) == "Derivative1"
            and len(candidate.args) == 3
            and candidate.args[:2] == (function, order)
        )

    return value.replace(
        matches,
        lambda candidate: _substitute(rule.right, variable, candidate.args[2]),
    )


def _sequence_items(value):
    if isinstance(value, sp.MatrixBase):
        return tuple(value)
    if isinstance(value, (sp.Tuple, tuple, list)):
        return tuple(value)
    return None


def _is_sequence(value) -> bool:
    return _sequence_items(value) is not None


def _is_nested_sequence(value) -> bool:
    items = _sequence_items(value)
    return bool(items) and all(_is_sequence(item) for item in items)


def _is_integer(value) -> bool:
    return bool(getattr(value, "is_integer", False))


def _is_numeric(value) -> bool:
    return bool(getattr(value, "is_number", False))


def _is_all(value) -> bool:
    return isinstance(value, sp.Symbol) and str(value) == "All"


def _is_serializable(value) -> bool:
    return isinstance(value, (sp.Basic, sp.MatrixBase))


def _protect_bound_names(text: str, environment: dict[str, object]):
    """Protect assigned names that SymPy's Mathematica parser treats as API."""

    parse_environment = {}
    restore = {}
    protected = text
    for index, (name, value) in enumerate(environment.items()):
        if not _parser_returns_symbol(name):
            safe = f"fortsymBound{index}"
            parse_environment[safe] = value
            restore[safe] = name
            protected = _replace_identifier(protected, name, safe)
        else:
            parse_environment[name] = value
    return protected, parse_environment, restore


def _parser_returns_symbol(name: str) -> bool:
    try:
        return isinstance(parse_mathematica(name), sp.Symbol)
    except Exception:
        return False


def _rename_parse_names(value, safe_to_original: dict[str, str]):
    """Use the parser's protected spellings inside already-bound values."""

    replacements = {
        sp.Symbol(original): sp.Symbol(safe)
        for safe, original in safe_to_original.items()
    }
    if isinstance(value, sp.Basic):
        return value.xreplace(replacements)
    if isinstance(value, sp.MatrixBase):
        return value.applyfunc(lambda item: _rename_parse_names(item, safe_to_original))
    if isinstance(value, WolframRule):
        return WolframRule(
            _rename_parse_names(value.left, safe_to_original),
            _rename_parse_names(value.right, safe_to_original),
        )
    if _is_sequence(value):
        return tuple(
            _rename_parse_names(item, safe_to_original)
            for item in _sequence_items(value)
        )
    return value


def _replace_identifier(text: str, old: str, new: str) -> str:
    pattern = re.compile(rf"(?<![A-Za-z0-9$]){re.escape(old)}(?![A-Za-z0-9$])")
    pieces = re.split(r'("(?:\\.|[^"\\])*")', text)
    for index in range(0, len(pieces), 2):
        pieces[index] = pattern.sub(new, pieces[index])
    return "".join(pieces)


def _protect_string_literals(text: str) -> str:
    """Keep parser-invalid Wolfram string contents out of SymPy's parser."""

    pieces: list[str] = []
    cursor = 0
    index = 0
    while index < len(text):
        if text[index] != '"':
            index += 1
            continue
        start = index
        index += 1
        escaped = False
        while index < len(text):
            char = text[index]
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                break
            index += 1
        if index >= len(text):
            raise NotImplementedError("unterminated string literal")
        literal = text[start + 1 : index]
        digest = hashlib.sha256(literal.encode("utf-8")).hexdigest()
        placeholder = "fortsymLiteral" + digest
        _STRING_LITERALS[placeholder] = literal
        pieces.extend((text[cursor:start], '"', placeholder, '"'))
        cursor = index + 1
        index += 1
    pieces.append(text[cursor:])
    return "".join(pieces)


def _wrap_string_predicates(text: str) -> str:
    """Make ``StringMatchQ`` safe inside Mathematica's eager ``&&`` parser."""

    marker = "StringMatchQ["
    pieces: list[str] = []
    cursor = 0
    while True:
        start = text.find(marker, cursor)
        if start < 0:
            pieces.append(text[cursor:])
            return "".join(pieces)
        open_index = start + len(marker) - 1
        depth = 0
        in_string = False
        escaped = False
        close_index = None
        for index in range(open_index, len(text)):
            char = text[index]
            if in_string:
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == '"':
                    in_string = False
                continue
            if char == '"':
                in_string = True
            elif char == "[":
                depth += 1
            elif char == "]":
                depth -= 1
                if depth == 0:
                    close_index = index
                    break
        if close_index is None:
            raise NotImplementedError("malformed StringMatchQ call")
        pieces.append(text[cursor:start])
        pieces.append("(")
        pieces.append(text[start : close_index + 1])
        pieces.append(" == 1)")
        cursor = close_index + 1


def _raw_string_literal(expression) -> str | None:
    if _head_name(expression) != "_Str" or len(expression.args) != 1:
        return None
    value = str(expression.args[0])
    return _STRING_LITERALS.get(value, value)


def _string_atom(literal: str):
    """Represent a Wolfram string as the existing collision-safe SymPy atom."""

    quoted = f'"{literal}"'
    digest = hashlib.sha256(quoted.encode("utf-8")).hexdigest()
    name = "fortsymString" + digest
    _STRING_ATOMS[name] = literal
    return sp.Symbol(name)


def _string_literal(value) -> str | None:
    if isinstance(value, str):
        return value
    if isinstance(value, sp.Symbol):
        return _STRING_ATOMS.get(str(value))
    return None


def _string_match(arguments: tuple[object, ...]):
    if len(arguments) != 2:
        raise NotImplementedError("StringMatchQ needs a string and one pattern")
    literal = _string_literal(arguments[0])
    if literal is None or str(arguments[1]) != "NumberString":
        raise NotImplementedError("StringMatchQ supports NumberString only")
    # Use 0/1 rather than a Boolean atom: the parser-safe wrapper around this
    # head compares it with ``1`` so it can remain inside Mathematica's ``&&``
    # expression while the pure-function predicate is being constructed.
    return sp.Integer(1) if _is_number_string(literal) else sp.Integer(0)


def _string_replace(arguments: tuple[object, ...]):
    if len(arguments) != 2:
        raise NotImplementedError("StringReplace needs a string and one rule")
    literal = _string_literal(arguments[0])
    rules = _rules(arguments[1])
    if literal is None or len(rules) != 1:
        raise NotImplementedError("StringReplace needs one literal-string rule")
    left = _string_literal(rules[0].left)
    right = _string_literal(rules[0].right)
    if left is None or right is None:
        raise NotImplementedError("StringReplace needs literal strings")
    return _string_atom(literal.replace(left, right))


def _to_expression(arguments: tuple[object, ...]):
    if len(arguments) != 1:
        raise NotImplementedError("ToExpression needs one string")
    literal = _string_literal(arguments[0])
    if literal is None:
        raise NotImplementedError("ToExpression needs a literal numeric string")
    numeric = literal.replace("*^", "e")
    if not _is_number_string(literal):
        raise NotImplementedError("ToExpression only accepts NumberString literals")
    try:
        return sp.sympify(numeric)
    except (TypeError, ValueError, SyntaxError) as exc:
        raise NotImplementedError("numeric string could not be parsed") from exc


def _is_number_string(literal: str) -> bool:
    return bool(_NUMBER_STRING.fullmatch(literal.replace("*^", "e")))


def _protect_thread_equal(text: str) -> str:
    """Keep list-valued Equal arguments intact through SymPy parsing."""

    return re.sub(
        r"(?<![A-Za-z0-9$])Thread\s*\[\s*Equal\s*\[",
        "Thread[fortsymThreadEqual[",
        text,
    )


def _restore_names(value, restore: dict[str, str]):
    if not restore:
        return value
    if isinstance(value, sp.Basic):
        return value.xreplace(
            {sp.Symbol(safe): sp.Symbol(original) for safe, original in restore.items()}
        )
    if isinstance(value, sp.MatrixBase):
        return value.applyfunc(lambda item: _restore_names(item, restore))
    if isinstance(value, WolframRule):
        return WolframRule(
            _restore_names(value.left, restore), _restore_names(value.right, restore)
        )
    if _is_sequence(value):
        return tuple(_restore_names(item, restore) for item in _sequence_items(value))
    return value


def _replace_all(arguments: tuple[object, ...]):
    if len(arguments) != 2:
        raise NotImplementedError("ReplaceAll needs rules")
    rules = _rules(arguments[1])
    if not rules:
        raise NotImplementedError("ReplaceAll needs at least one rule")
    value = arguments[0]
    patterned = []
    for rule in rules:
        if not _contains_pattern(rule.left):
            continue
        pattern = _derivative_pattern(rule.left)
        if pattern is None:
            raise NotImplementedError(
                "only one-argument derivative Pattern/Blank rules are supported"
            )
        patterned.append((rule, pattern))
    if hasattr(value, "subs"):
        if patterned:
            if len(patterned) != len(rules):
                raise NotImplementedError(
                    "patterned and ordinary replacement rules cannot be mixed"
                )
            for rule, pattern in patterned:
                value = _replace_derivative_pattern(value, rule, pattern)
            return value
        result = value.subs(
            [(rule.left, rule.right) for rule in rules], simultaneous=True
        )
        # Wolfram evaluates derivatives before applying ``/.``.  SymPy keeps
        # a derivative whose dummy variable was replaced as ``Subs`` instead
        # of reducing it to the derivative at the replacement point.  Lower
        # those wrappers here so ``D[f[x], x] /. x -> y`` has the expected
        # ``Derivative(f(y), y)`` form.
        if isinstance(result, sp.Basic) and result.has(sp.Subs):
            result = result.replace(
                lambda item: isinstance(item, sp.Subs),
                lambda item: item.doit(),
            )
        return result
    if _is_sequence(value):
        return sp.Tuple(*(_replace_all((item, arguments[1])) for item in _sequence_items(value)))
    raise NotImplementedError("ReplaceAll value is not an expression")


def _part(arguments: tuple[object, ...]):
    if len(arguments) < 2:
        raise NotImplementedError("Part needs an index")
    value = arguments[0]
    for index in arguments[1:]:
        value = _select_part(value, index)
    return value


def _piecewise(arguments: tuple[object, ...]):
    if not arguments:
        raise NotImplementedError("Piecewise needs branches")
    branches = arguments[0]
    if not isinstance(branches, sp.Tuple):
        raise NotImplementedError("Piecewise branches are not a tuple")
    pairs = []
    for branch in branches:
        if not isinstance(branch, sp.Tuple) or len(branch) != 2:
            raise NotImplementedError("malformed Piecewise branch")
        pairs.append(tuple(branch))
    if len(arguments) > 1:
        return sp.Piecewise(*pairs, (arguments[1], True))
    return sp.Piecewise(*pairs)


def _boole(arguments: tuple[object, ...]):
    if len(arguments) != 1:
        raise NotImplementedError("Boole needs one condition")
    condition = arguments[0]
    if condition is sp.true:
        return sp.Integer(1)
    if condition is sp.false:
        return sp.Integer(0)
    return sp.Function("Boole")(condition)


def _which(arguments: tuple[object, ...]):
    if len(arguments) < 2 or len(arguments) % 2:
        raise NotImplementedError("Which needs condition-value pairs")
    preserved = []
    for index in range(0, len(arguments), 2):
        condition = arguments[index]
        value = arguments[index + 1]
        if condition is sp.true:
            if not preserved:
                return value
            preserved.extend((condition, value))
            continue
        if condition is sp.false:
            continue
        preserved.extend((condition, value))
    return sp.Function("Which")(*preserved)


def _trig_reduce(arguments: tuple[object, ...]):
    if len(arguments) != 1:
        raise NotImplementedError("TrigReduce needs one expression")
    expression = arguments[0]
    if sp.count_ops(expression) > 2_000:
        raise NotImplementedError("TrigReduce input exceeds its safety bound")
    reduced = TR8(expression)
    if sp.count_ops(reduced) > 10_000:
        raise NotImplementedError("TrigReduce result exceeds its safety bound")
    return reduced


def _as_assignment(item) -> Assignment:
    if isinstance(item, Assignment):
        return item
    if len(item) == 3:
        name, rhs, parameters = item
        return Assignment(name, rhs, tuple(parameters))
    name, rhs, parameters, delayed = item
    return Assignment(name, rhs, tuple(parameters), bool(delayed))


def _head_name(expression) -> str:
    return getattr(expression.func, "__name__", str(expression.func))


def _plain_name(text: str) -> str | None:
    if re.fullmatch(r"[A-Za-z$][A-Za-z0-9$]*", text):
        return text
    if re.fullmatch(r"\\\[[A-Za-z][A-Za-z0-9]*\]", text):
        return _normalise_named_characters(text)
    return None


def _function_name_and_parameters(text: str):
    match = re.fullmatch(r"([A-Za-z$][A-Za-z0-9$]*)\[(.*)\]", text, re.DOTALL)
    if match is None:
        return None
    parameters = []
    for item in _split_top_level(match.group(2), ","):
        parameter = re.fullmatch(r"([A-Za-z$][A-Za-z0-9$]*)_+\.?", item.strip())
        if parameter is None:
            return None
        parameters.append(parameter.group(1))
    return match.group(1), tuple(parameters)


def _top_level_assignment(text: str) -> tuple[int, int]:
    depth = 0
    in_string = False
    escaped = False
    for index, char in enumerate(text):
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue
        if char == '"':
            in_string = True
        elif char in "[{(":
            depth += 1
        elif char in "]})":
            depth = max(0, depth - 1)
        elif char == "=" and depth == 0:
            previous = text[index - 1] if index else ""
            following = text[index + 1] if index + 1 < len(text) else ""
            if previous in "=<>!" or following == "=":
                continue
            if previous == ":":
                return index - 1, 2
            return index, 1
    return -1, 0


def _split_top_level(text: str, separator: str) -> list[str]:
    parts = []
    depth = 0
    start = 0
    for index, char in enumerate(text):
        if char in "[{(":
            depth += 1
        elif char in "]})":
            depth = max(0, depth - 1)
        elif char == separator and depth == 0:
            parts.append(text[start:index])
            start = index + 1
    parts.append(text[start:])
    return parts


def _times_compound_prefix(text: str) -> tuple[str, str] | None:
    """Separate ``(compound assignments)*opaque_head`` notebook wrappers."""

    text = text.strip()
    if not text.startswith("("):
        return None
    close = _matching_delimiter(text, 0)
    if close < 0:
        return None
    suffix = text[close + 1 :].lstrip()
    if not suffix.startswith("*"):
        return None
    prefix = text[1:close]
    if len(_split_top_level(prefix, ";")) == 1:
        return None
    return prefix, suffix[1:].strip()


def _matching_delimiter(text: str, opening: int) -> int:
    pairs = {"[": "]", "{": "}", "(": ")"}
    stack = [text[opening]]
    in_string = False
    escaped = False
    for index in range(opening + 1, len(text)):
        char = text[index]
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue
        if char == '"':
            in_string = True
        elif char in pairs:
            stack.append(char)
        elif char in pairs.values():
            if not stack or pairs[stack[-1]] != char:
                return -1
            stack.pop()
            if not stack:
                return index
    return -1


def _strip_comments(source: str) -> str:
    output = []
    depth = 0
    index = 0
    while index < len(source):
        if depth:
            if source.startswith("(*", index):
                depth += 1
                output.append("  ")
                index += 2
            elif source.startswith("*)", index):
                depth -= 1
                output.append("  ")
                index += 2
            else:
                output.append("\n" if source[index] == "\n" else " ")
                index += 1
            continue
        if source.startswith("(*", index):
            depth = 1
            output.append("  ")
            index += 2
        else:
            output.append(source[index])
            index += 1
    return "".join(output)


def _append_statement(statements: list[str], statement: str) -> None:
    if statement.strip():
        statements.append(statement.strip())


def _awaits_operand(source: str, start: int, end: int) -> bool:
    index = end - 1
    while index >= start and source[index] in " \t\r":
        index -= 1
    if index >= start and source[index] in "+-*/.^=<>|@:,~":
        return True

    # Wolfram input is commonly formatted with a continuation operator at the
    # beginning of the next physical line.  Treating that newline as a
    # statement boundary silently dropped the remainder of assignments such
    # as ``a = first_term\n  + second_term`` from generated SymPy companions.
    index = end + 1
    while index < len(source) and source[index] in " \t\r":
        index += 1
    return index < len(source) and source[index] in "+-*/.^=<>|@:,~"


def _normalise_named_characters(text: str) -> str:
    return re.sub(
        r"\\\[([A-Za-z][A-Za-z0-9]*)\]",
        lambda match: match.group(1),
        text,
    )


# SymPy's Mathematica parser treats a Unicode Greek name as a Python-like
# subscript target when it appears inside a function call (for example
# ``CharacteristicPolynomial[m, λ]``). Keep the Wolfram spelling in returned
# expressions, but parse the affected identifier as an ordinary ASCII symbol.
_GREEK_PARSE_NAMES = {
    "λ": "fortsymGreekLambda",
    "α": "fortsymGreekAlpha",
    "β": "fortsymGreekBeta",
    "φ": "fortsymGreekPhi",
    "ϑ": "fortsymGreekTheta",
}

# SymPy's Mathematica parser resolves these names as parser/domain objects,
# while Wolfram scripts may use them as ordinary symbols.  In particular,
# ``CC`` is SymPy's complex domain, not a Wolfram built-in.  Protect only
# these known collisions; other built-in heads must retain their normal
# parsing semantics.
_PARSER_RESERVED_NAMES = ("CC", "len", "zeta")


_DERIVATIVE_CALL = re.compile(
    r"Derivative\[([0-9]+)\]"
    r"\[([A-Za-z$][A-Za-z0-9$]*)\]"
    r"\[([^\[\]]*)\]"
)


def _normalise_derivative_calls(text: str) -> str:
    """Protect one-argument Wolfram derivatives from eager SymPy parsing."""

    return _DERIVATIVE_CALL.sub(
        lambda match: (
            f"Derivative1[{match.group(2)}, {match.group(1)}, {match.group(3)}]"
        ),
        text,
    )


def _normalise_expression_layout(text: str) -> str:
    """Make physical line breaks whitespace inside one assignment RHS.

    ``extract_assignments`` has already established the statement boundary.
    Passing its original newlines to SymPy's Mathematica parser would turn a
    continued expression into ``CompoundExpression`` instead of arithmetic.
    Wolfram's backslash-newline continuation is equivalent to the same space.
    String contents remain byte-for-byte unchanged.
    """
    pieces: list[str] = []
    start = 0
    index = 0
    in_string = False
    escaped = False
    while index < len(text):
        char = text[index]
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            index += 1
            continue
        if char == '"':
            in_string = True
            index += 1
            continue
        if char == "\\" and index + 1 < len(text) and text[index + 1] in "\r\n":
            pieces.append(text[start:index])
            pieces.append(" ")
            index += 2
            if index < len(text) and text[index - 1] == "\r" and text[index] == "\n":
                index += 1
            start = index
            continue
        if char in "\r\n":
            pieces.append(text[start:index])
            pieces.append(" ")
            index += 1
            if index < len(text) and char == "\r" and text[index] == "\n":
                index += 1
            start = index
            continue
        index += 1
    pieces.append(text[start:])
    return "".join(pieces)


def _normalise_prefix_calls(text: str) -> str:
    """Rewrite Wolfram ``f@Head[...]`` before SymPy sees it.

    SymPy's Mathematica parser treats the prefix operator as multiplication,
    which turns ``First@Solve[...]`` into ``First * Solve[...]``.  Restrict
    this normalization to prefix calls with a bracketed operand; those have a
    clear balanced extent and cover the corpus forms without guessing where
    an atomic prefix operand ends.
    """
    pattern = re.compile(
        r"(?<![A-Za-z0-9$])([A-Za-z][A-Za-z0-9$]*)\s*@\s*"
        r"([A-Za-z][A-Za-z0-9$]*)\s*\["
    )
    while match := pattern.search(text):
        opening = text.find("[", match.start(2), match.end())
        closing = _matching_delimiter(text, opening)
        if closing < 0:
            break
        operand = text[match.start(2) : closing + 1]
        text = text[: match.start(1)] + match.group(1) + "[" + operand + "]" + text[closing + 1 :]
    return text


def _normalise_numeric_powers(text: str) -> str:
    """Parenthesize numeric powers before SymPy parses implicit products.

    Wolfram input commonly writes constants such as ``4 Pi 10^-7``.  The
    Mathematica parser in SymPy gives the exponent tighter binding than the
    implicit multiplication in that spelling, effectively reading it as
    ``(4 Pi 10)^-7``.  Parenthesizing only a numeric base and numeric exponent
    preserves Wolfram precedence without rewriting identifiers or calls such
    as ``f[10^-7]``.
    """

    power = re.compile(
        r"(?<![A-Za-z0-9_.$])"
        r"(?:\d+(?:\.\d*)?|\.\d+)"
        r"\s*\^\s*[+-]?\d+"
    )
    pieces: list[str] = []
    start = 0
    index = 0
    in_string = False
    escaped = False
    while index < len(text):
        char = text[index]
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            index += 1
            continue
        if char == '"':
            in_string = True
            index += 1
            continue
        match = power.match(text, index)
        if match is None:
            index += 1
            continue
        pieces.append(text[start:index])
        pieces.append("(" + match.group(0) + ")")
        index = match.end()
        start = index
    pieces.append(text[start:])
    return "".join(pieces)

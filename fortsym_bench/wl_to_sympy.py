"""Small, deterministic Wolfram-expression to SymPy translation runtime.

The corpus contains complete Wolfram scripts, not just isolated expressions.
The generated Python companions therefore keep the source assignment text and
evaluate it in order with SymPy's Mathematica parser.  This is deliberately a
bounded translator: a statement it cannot lower is skipped and remains visible
in the generated file's manifest instead of being replaced by a guessed value.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations, product
import re
from typing import Iterable

import sympy as sp
from sympy.parsing.mathematica import parse_mathematica


@dataclass(frozen=True)
class Assignment:
    """A plain Set or simple SetDelayed extracted from a Wolfram statement."""

    name: str
    rhs: str
    parameters: tuple[str, ...] = ()


@dataclass(frozen=True)
class WolframRule:
    left: object
    right: object


class WolframFunction:
    """A small closure for ``f[x_] := rhs`` definitions."""

    def __init__(self, parameters: tuple[str, ...], rhs: str, closure: dict):
        self.parameters = parameters
        self.rhs = rhs
        self.closure = closure

    def call(self, arguments: tuple[object, ...]):
        if len(arguments) != len(self.parameters):
            raise NotImplementedError("function arity is not supported")
        local = dict(self.closure)
        local.update(zip(self.parameters, arguments))
        return evaluate_expression(self.rhs, local)


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
        return Assignment(name, right, parameters)
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
                environment[assignment.name] = WolframFunction(
                    assignment.parameters, assignment.rhs, dict(environment)
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
        reason = failures[0] if failures else "no translatable assignments"
        raise NotImplementedError(f"{source_name}: {reason}")
    return results


def evaluate_expression(text: str, environment: dict[str, object] | None = None):
    """Parse and lower one Wolfram expression using the SymPy API."""

    environment = {} if environment is None else environment
    normalised = _normalise_expression_layout(_normalise_named_characters(text))
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
    protected, parse_environment, restore = _protect_bound_names(
        normalised, environment
    )
    parsed = parse_mathematica(protected)
    restore.update(greek_restore)
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
    if name == "Map":
        return _map(expression.args, environment)
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
    arguments = tuple(_lower(arg, environment) for arg in expression.args)
    bound = environment.get(name)
    if isinstance(bound, WolframFunction):
        return bound.call(arguments)

    if name == "D":
        return _differentiate(arguments)
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
    if name in ("Together", "Cancel", "Apart"):
        return getattr(sp, name.lower())(arguments[0])
    if name == "Collect":
        return sp.collect(arguments[0], arguments[1])
    if name == "Integrate":
        return sp.integrate(
            arguments[0],
            *[argument for argument in arguments[1:] if not isinstance(argument, WolframRule)],
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
    if name == "Total":
        return sp.Add(*_sequence_items(arguments[0]))
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
    if len(expression_arguments) != 2:
        raise NotImplementedError("Map needs a function and a list")
    mapper = _resolve_mapper(expression_arguments[0], environment)
    values = _sequence_items(_lower(expression_arguments[1], environment))
    if values is None:
        raise NotImplementedError("Map needs a list")
    return sp.Tuple(*(_call_mapper(mapper, (value,), environment) for value in values))


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
    if isinstance(result, dict):
        result = [result]
    if isinstance(result, list):
        rows = []
        for solution in result:
            if isinstance(solution, dict):
                rows.append(sp.Tuple(*(sp.Tuple(key, value) for key, value in solution.items())))
            elif isinstance(solution, (tuple, list)):
                rows.append(sp.Tuple(*solution))
            else:
                rows.append(solution)
        return sp.Tuple(*rows)
    return result


def _rules(value):
    if isinstance(value, WolframRule):
        return [value]
    if _is_sequence(value):
        rules = []
        for item in _sequence_items(value):
            rules.extend(_rules(item))
        return rules
    return []


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


def _replace_identifier(text: str, old: str, new: str) -> str:
    pattern = re.compile(rf"(?<![A-Za-z0-9$]){re.escape(old)}(?![A-Za-z0-9$])")
    pieces = re.split(r'("(?:\\.|[^"\\])*")', text)
    for index in range(0, len(pieces), 2):
        pieces[index] = pattern.sub(new, pieces[index])
    return "".join(pieces)


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
    if hasattr(value, "subs"):
        return value.subs([(rule.left, rule.right) for rule in rules], simultaneous=True)
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


def _as_assignment(item) -> Assignment:
    if isinstance(item, Assignment):
        return item
    name, rhs, parameters = item
    return Assignment(name, rhs, tuple(parameters))


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
}


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

"""Normalise results from every backend into SymPy objects and compare them.

One parser per syntax, in one place. The Python backends emit SymPy's ``srepr``;
the Wolfram backends emit ``InputForm``, read by ``sympy.parsing.mathematica``.
Both parsers are BSD SymPy, so the comparison path carries no licence question.
"""

from __future__ import annotations

from dataclasses import dataclass
import hashlib
import re

AGREE = "agree"
DIFFER = "differ"
UNSUPPORTED = "unsupported"
ERROR = "error"
ORACLE_DISAGREEMENT = "oracle-disagreement"
ORACLE_MISSING = "oracle-missing"
UNAVAILABLE = "unavailable"
TIMEOUT = "timeout"
UNTRANSLATED = "untranslated"

# A malformed or unexpectedly expanded CAS result must not pin the whole
# corpus audit in SymPy's parser.  Four MiB is well above every ordinary
# result in this corpus; larger values are retained in the report as an
# explicit comparison error unless their raw text already matches.
MAX_COMPARISON_TEXT = 4 * 1024 * 1024


@dataclass
class Comparison:
    outcome: str
    detail: str = ""


def parse(text: str, syntax: str):
    import sympy
    from sympy.parsing.mathematica import parse_mathematica

    if syntax == "srepr":
        parsed = _normalise_sympy_derivatives(sympy.sympify(text))
        _validate_sympy_tree(parsed)
        return parsed
    if syntax == "inputform":
        normalised, restore = _normalise_inputform(text)

        def parse_inputform(candidate: str):
            parsed = parse_mathematica(candidate)
            parsed = _restore_inputform_symbols(parsed, restore)
            parsed = _normalise_sympy_derivatives(parsed)
            _validate_sympy_tree(parsed)
            return parsed

        try:
            return parse_inputform(normalised)
        except (AttributeError, TypeError, ValueError, RuntimeError):
            # SymPy's Mathematica parser eagerly maps List[...] to Tuple.
            # That is correct for a list on its own, but it can construct an
            # invalid non-Expr tree for list-valued arithmetic such as
            # Sqrt[List[x, y]], or return one that fails later during
            # serialization. On this narrow retry, preserve List as an opaque
            # head. This is intentionally not a semantic threading rule: a
            # native result containing list arithmetic must remain
            # distinguishable from an elementwise SymPy result.
            protected_lists = normalised.replace(
                "List[", "fortsymInputOpaqueList["
            )
            try:
                return parse_inputform(protected_lists)
            except (AttributeError, TypeError, ValueError, RuntimeError):
                if not any(
                    f"fortsymInputOpaque{name}" in normalised
                    for name in _OPAQUE_INPUTFORM_HEADS
                ):
                    raise
                # Higher-order and rendering heads may force SymPy's parser
                # to execute a predicate or option expression even after the
                # head itself is protected. Keep the complete Wolfram form
                # opaque in that bounded case. A digest atom can only compare
                # equal to the same normalized text; it never invents a
                # semantic equivalence.
                digest = hashlib.sha256(normalised.encode("utf-8")).hexdigest()
                return sympy.Symbol("fortsymInputOpaqueExpression" + digest)
    raise ValueError(f"unknown syntax: {syntax}")


def _validate_sympy_tree(expression) -> None:
    """Reject SymPy trees that its printers and simplifiers cannot consume.

    SymPy's Mathematica parser can construct deprecated arithmetic nodes with
    a ``Tuple`` child when Mathics emits list-valued arithmetic. Such a tree
    may parse successfully but fail much later in ``srepr`` with an unrelated
    ``as_coeff_Mul`` error. Keep the malformed result observable as a bounded
    parse failure instead of allowing it into the comparison cache.
    """
    import sympy

    arithmetic_heads = (sympy.Add, sympy.Mul, sympy.Pow)

    def visit(node) -> None:
        if not isinstance(node, sympy.Basic):
            return
        if node.func in arithmetic_heads:
            for argument in node.args:
                if not isinstance(argument, sympy.Expr):
                    raise ValueError(
                        f"malformed SymPy {node.func.__name__}: "
                        f"non-expression child {type(argument).__name__}"
                    )
        for argument in node.args:
            visit(argument)

    visit(expression)


def _normalise_inputform(text: str) -> tuple[str, dict[str, str]]:
    """Bridge Mathics' Unicode pretty-printer to SymPy's input parser.

    Mathics emits these Unicode spellings for ordinary Wolfram operators in
    several result classes. SymPy's Mathematica parser accepts the ASCII
    spellings but not the pretty-printed ones. The phi variant is also parsed
    as a non-callable symbol, so an opaque function such as ``A[r, ϕ, z]``
    fails before comparison; ``phi`` is the parser's callable spelling.
    These are syntax normalisations, not mathematical rewrites.
    """
    text = (
        text.replace("⇾", "->")
        .replace("⩵", "==")
        .replace("≥", ">=")
        .replace("∧", "&&")
        .replace("ϕ", "phi")
    )
    # Wolfram arbitrary-precision reals carry a precision marker such as
    # ``44209.7`40.``.  SymPy's Mathematica parser does not implement that
    # InputForm syntax: it reads the marker as multiplication by 40, turning
    # a valid Mathics oracle value into a false factor-of-40 disagreement.
    # The digits after the marker are metadata, so remove only the marker and
    # retain the numeric mantissa.  This is deliberately limited to numeric
    # literals; a backtick in any other text must remain observable.
    text = re.sub(
        r"(?<![A-Za-z0-9_$])(?P<number>[+-]?(?:\d+(?:\.\d*)?|\.\d+)"
        r"(?:\*\^[+-]?\d+)?)`(?:\d+(?:\.\d*)?|\.\d+)",
        r"\g<number>",
        text,
    )
    text = _protect_inputform_strings(text)
    text = _normalise_derivative_calls(text)
    # Mathics sometimes prints higher-order heads with round delimiters
    # (``Part(Slot(1), 1)``), while the Mathematica parser's opaque fallback
    # is reliable for square-delimited applications. Normalize the bounded
    # nested forms before protecting those heads.
    text = re.sub(r"\bSlot\s*\(([^()]*)\)", r"Slot[\1]", text)
    text = re.sub(r"\bPart\s*\(([^()]*)\)", r"Part[\1]", text)
    text = re.sub(
        r"\bStringMatchQ\s*\(([^()]*)\)",
        r"StringMatchQ[\1]",
        text,
    )
    text = _protect_inputform_opaque_heads(text)
    # SymPy's Mathematica parser cannot build an AST for the Wolfram empty
    # list spelling. Use the same collision-resistant atom as the empty-call
    # bridge below, then restore it to an actual empty Tuple after parsing.
    text = text.replace("{}", "fortsymInputEmptyList")
    text = re.sub(
        r"(\d+(?:\.\d*)?|\.\d+)\*\^([+-]?\d+)",
        r"\1*10^(\2)",
        text,
    )
    # SymPy's Mathematica parser gives a bare numeric power the wrong
    # precedence when it follows an adjacent factor: ``4 Pi 10^-7`` becomes
    # ``4 Pi^(10^-7)``.  Parenthesize only numeric-base integer powers; this
    # preserves ordinary symbol products and function/application syntax.
    text = re.sub(
        r"(?<![A-Za-z0-9_$.)])((?:\d+(?:\.\d*)?|\.\d+))\s*\^\s*([+-]?\d+)",
        r"(\1^\2)",
        text,
    )
    text = re.sub(r"([eE][+-]?)0+(\d+)", r"\1\2", text)
    text = re.sub(r"\\\[([A-Za-z][A-Za-z0-9]*)\]", r"\1", text)
    text = re.sub(
        r"\b([A-Za-z$][A-Za-z0-9$]*)\s*\[\s*\]",
        lambda match: "fortsymInputEmpty" + match.group(1),
        text,
    )
    text, protected = _protect_inputform_greek_symbols(text)
    return _protect_inputform_builtin_symbols(text, protected)


_OPAQUE_INPUTFORM_HEADS = (
    # These heads are either option-heavy rendering forms or higher-order
    # constructs that SymPy's Mathematica parser tries to evaluate while
    # parsing. Preserve their Wolfram tree shape so a cross-backend mismatch
    # is reported as a difference, not as a parser error.
    "Subscript", "Slot", "Part", "Select", "Take", "StringMatchQ",
    "StringReplace", "ToExpression", "FileNameJoin", "LogPlot", "Plot",
    "ContourPlot", "Plot3D", "ParametricPlot", "ParametricPlot3D",
    "PolarPlot", "Graphics", "Graphics3D", "Show", "Manipulate",
    "ColorData", "LineLegend", "BarLegend", "Placed", "Legended",
)


def _protect_inputform_opaque_heads(text: str) -> str:
    for name in _OPAQUE_INPUTFORM_HEADS:
        text = re.sub(
            rf"(?<![A-Za-z0-9$]){name}\s*([\[\(])",
            lambda match: f"fortsymInputOpaque{name}{match.group(1)}",
            text,
        )
    return text


def _protect_inputform_greek_symbols(text: str) -> tuple[str, dict[str, str]]:
    protected = {}
    pieces = []
    start = 0
    for match in re.finditer(r"[α-ωΑ-Ωϕϑ]|%[0-9]*", text):
        replacement = f"fortsymInputSymbol{len(protected)}"
        protected[replacement] = match.group(0)
        pieces.append(text[start:match.start()])
        pieces.append(replacement)
        start = match.end()
    pieces.append(text[start:])
    return "".join(pieces), protected


def _protect_inputform_builtin_symbols(
    text: str, protected: dict[str, str]
) -> tuple[str, dict[str, str]]:
    """Protect bare WL symbols that SymPy's Mathematica parser predefines."""
    import sympy
    from sympy.parsing.mathematica import parse_mathematica

    pieces = []
    start = 0
    identifier = re.compile(r"[A-Za-z$][A-Za-z0-9$]*")
    for match in identifier.finditer(text):
        name = match.group(0)
        # A head followed by '[' is an application, not a bare symbol. String
        # literals were replaced before this pass, so identifier matches here
        # cannot occur inside a quoted path or message.
        following = match.end()
        while following < len(text) and text[following].isspace():
            following += 1
        if following < len(text) and text[following] == "[":
            continue
        try:
            parsed = parse_mathematica(name)
        except Exception:
            parsed = None
        if isinstance(parsed, sympy.Symbol):
            continue
        # These are genuine Wolfram constants and should retain their parser
        # meaning. Other names are ordinary corpus symbols that happen to
        # collide with a SymPy helper such as beta, zeta, len, or plot.
        if name in {
            "True", "False", "Null", "Infinity", "ComplexInfinity",
            "Indeterminate", "I", "E", "Pi", "Degree", "Catalan",
            "EulerGamma", "GoldenRatio",
        }:
            continue
        replacement = f"fortsymInputSymbol{len(protected)}"
        protected[replacement] = name
        pieces.append(text[start:match.start()])
        pieces.append(replacement)
        start = match.end()
    pieces.append(text[start:])
    return "".join(pieces), protected


def _restore_inputform_symbols(expression, protected: dict[str, str]):
    import sympy

    if not isinstance(expression, sympy.Basic):
        return expression
    if isinstance(expression, sympy.Symbol):
        name = str(expression)
        if name == "fortsymInputEmptyList":
            return sympy.Tuple()
        name = protected.get(name)
        return sympy.Symbol(name) if name is not None else expression
    try:
        arguments = tuple(expression.args)
    except TypeError:
        return expression
    restored = tuple(_restore_inputform_symbols(argument, protected) for argument in arguments)
    function_name = getattr(getattr(expression, "func", None), "__name__", "")
    if function_name.startswith("fortsymInputOpaque"):
        return sympy.Function(function_name.removeprefix("fortsymInputOpaque"))(
            *restored
        )
    if restored == arguments:
        return expression
    try:
        return expression.func(*restored)
    except Exception:
        try:
            return expression.func(*restored, evaluate=False)
        except Exception:
            return expression


def _protect_inputform_strings(text: str) -> str:
    """Represent string literals as collision-resistant symbolic atoms.

    ``parse_mathematica`` currently strips the quotes and sends a Wolfram
    string into Python's expression parser, where paths and ordinary text are
    syntax errors. Hashing the complete literal preserves equality and
    inequality for comparison while keeping the parser's job purely symbolic.
    """
    pieces: list[str] = []
    start = 0
    index = 0
    while index < len(text):
        if text[index] != '"':
            index += 1
            continue
        pieces.append(text[start:index])
        end = index + 1
        escaped = False
        while end < len(text):
            char = text[end]
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                end += 1
                break
            end += 1
        literal = text[index:end]
        digest = hashlib.sha256(literal.encode("utf-8")).hexdigest()
        pieces.append("fortsymString" + digest)
        index = end
        start = end
    pieces.append(text[start:])
    return "".join(pieces)


_DERIVATIVE_CALL = re.compile(
    r"Derivative\[([0-9]+(?:\s*,\s*[0-9]+)*)\]"
    r"\[([A-Za-z$][A-Za-z0-9$]*)\]\[([^\[\]]*)\]"
)


def _normalise_derivative_calls(text: str) -> str:
    """Use fortsym's opaque derivative spelling for WL derivatives."""
    def replace(match: re.Match[str]) -> str:
        orders = [part.strip() for part in match.group(1).split(",")]
        head = match.group(2)
        arguments = match.group(3).strip()
        # Derivative[n][f][x] is Wolfram's one-argument prime notation,
        # including n > 1.  The native parser preserves that spelling as
        # Derivative1[f, n, x]; only a multi-index function uses the
        # DerivativeN coordinate-index encoding below.
        if len(orders) == 1:
            return f"Derivative1[{head}, {orders[0]}, {arguments}]"
        indices = []
        for position, order in enumerate(orders, start=1):
            if not order.isdigit() or int(order) < 0:
                return match.group(0)
            indices.extend([str(position)] * int(order))
        if not indices:
            return match.group(0)
        name = f"Derivative{len(indices)}"
        return f"{name}[{head}, {', '.join(indices)}, {arguments}]"

    previous = None
    while previous != text:
        previous = text
        text = _DERIVATIVE_CALL.sub(replace, text)
    return text


def _normalise_sympy_derivatives(expression):
    """Match SymPy's opaque-function derivatives to WL output.

    SymPy serializes an unevaluated derivative as ``Derivative(f(x), (x, n))``.
    The native Wolfram protocol uses ``Derivative1[f, n, x]`` for a
    one-argument derivative and ``DerivativeN[f, i1, ..., x1, ...]`` for a
    partial derivative of a multi-argument function. Built-in functions that
    SymPy has already differentiated never enter this branch.
    """
    import sympy

    if not isinstance(expression, sympy.Basic):
        return expression
    function_name = getattr(getattr(expression, "func", None), "__name__", "")
    if function_name.startswith("Derivative"):
        try:
            order = int(function_name.removeprefix("Derivative"))
        except ValueError:
            order = 0
        # Native differentiation of a one-argument function accumulates
        # indices in DerivativeN[f, 1, ..., 1, x], whereas the Wolfram
        # prime spelling is Derivative1[f, N, x].  The argument count is
        # recoverable here because the opaque node stores all indices before
        # the original function arguments.
        if order > 1 and len(expression.args) == order + 2:
            indices = expression.args[1:order + 1]
            if all(index == sympy.Integer(1) for index in indices):
                return sympy.Function("Derivative1")(
                    expression.args[0], sympy.Integer(order), expression.args[-1]
                )
    if isinstance(expression, sympy.Derivative):
        value = _normalise_sympy_derivatives(expression.expr)
        if getattr(value, "is_Function", False):
            indices = []
            for variable, count in expression.variable_count:
                positions = [
                    index
                    for index, argument in enumerate(value.args, start=1)
                    if argument == variable
                ]
                if len(positions) != 1:
                    indices = []
                    break
                indices.extend([positions[0]] * count)
            if indices:
                head = sympy.Symbol(value.func.__name__)
                arguments = tuple(
                    _normalise_sympy_derivatives(argument)
                    for argument in value.args
                )
                if len(value.args) == 1:
                    return sympy.Function("Derivative1")(
                        head, sympy.Integer(len(indices)), *arguments
                    )
                indices.sort()
                derivative = sympy.Function(f"Derivative{len(indices)}")
                return derivative(
                    head,
                    *(sympy.Integer(index) for index in indices),
                    *arguments,
                )

    raw_arguments = tuple(expression.args)
    arguments = tuple(
        _normalise_sympy_derivatives(argument) for argument in raw_arguments
    )
    if arguments == raw_arguments:
        return expression
    try:
        return expression.func(*arguments)
    except Exception:
        try:
            return expression.func(*arguments, evaluate=False)
        except Exception:
            return expression


def compare(candidate, reference, strictness: str) -> Comparison:
    """Compare one result against the oracle at the declared strictness.

    ``structural``, ``equivalent``, and ``numeric`` are all legitimate bars.
    Which one a result is held to is declared in the corpus file, not chosen
    here — a comparator that quietly falls back from structural to a looser
    policy would hide precisely the differences worth knowing about.
    """
    import sympy

    try:
        _validate_sympy_tree(candidate)
        _validate_sympy_tree(reference)
    except (AttributeError, TypeError, ValueError) as exc:
        return Comparison(ERROR, f"malformed comparison operand: {exc}")

    if strictness == "structural":
        try:
            equal = bool(candidate == reference)
        except Exception as exc:
            return Comparison(ERROR, f"comparison failed: {type(exc).__name__}: {exc}")
        if equal:
            return Comparison(AGREE)
        try:
            detail = f"{sympy.srepr(candidate)} != {sympy.srepr(reference)}"
        except Exception as exc:
            return Comparison(
                ERROR,
                f"cannot serialize comparison operands: {type(exc).__name__}: {exc}",
            )
        return Comparison(DIFFER, detail)

    if strictness == "equivalent":
        if _equivalent(candidate, reference):
            return Comparison(AGREE)
        try:
            detail = f"{candidate} is not equivalent to {reference}"
        except Exception as exc:
            return Comparison(
                ERROR,
                f"cannot format comparison operands: {type(exc).__name__}: {exc}",
            )
        return Comparison(DIFFER, detail)

    if strictness == "numeric":
        if _numeric_equivalent(candidate, reference):
            return Comparison(AGREE)
        try:
            detail = f"{candidate} is not numerically equal to {reference}"
        except Exception as exc:
            return Comparison(
                ERROR,
                f"cannot format comparison operands: {type(exc).__name__}: {exc}",
            )
        return Comparison(DIFFER, detail)

    raise ValueError(f"unknown strictness: {strictness}")


def compare_text(
    candidate_text: str,
    reference_text: str,
    syntax: str,
    strictness: str,
    parsed_cache: dict | None = None,
) -> Comparison:
    """Compare serialized results without reparsing avoidable work.

    Exact serialized equality is already a stronger witness than the
    structural comparison used below.  It is common for cached oracle output
    and a native result to be byte-for-byte identical, so parsing both sides
    in that case only burns time.  Conversely, a giant non-identical result is
    reported as an explicit error instead of allowing a parser to consume
    unbounded CPU and memory; the raw values remain available in the runner's
    diagnostic path.
    """
    if candidate_text == reference_text:
        return Comparison(AGREE)
    largest = max(len(candidate_text), len(reference_text))
    if largest > MAX_COMPARISON_TEXT:
        return Comparison(
            ERROR,
            "comparison operand is too large to parse: "
            f"{largest} characters exceeds {MAX_COMPARISON_TEXT}",
        )

    def parse_once(text: str):
        if parsed_cache is None:
            return parse(text, syntax)
        key = (syntax, text)
        if key not in parsed_cache:
            parsed_cache[key] = parse(text, syntax)
        return parsed_cache[key]

    try:
        candidate = parse_once(candidate_text)
        reference = parse_once(reference_text)
    except Exception as exc:
        return Comparison(ERROR, f"unparseable: {exc}")
    return compare(candidate, reference, strictness)


def compare_cross_text(
    candidate_text: str,
    candidate_syntax: str,
    reference_text: str,
    reference_syntax: str,
    strictness: str,
    parsed_cache: dict | None = None,
) -> Comparison:
    """Compare results emitted in two different backend syntaxes.

    The native Wolfram path and the SymPy path describe the same symbols but
    serialize them differently. Parse each side with its own grammar, then
    remove SymPy-only assumption metadata before applying the declared bar.
    """
    largest = max(len(candidate_text), len(reference_text))
    if largest > MAX_COMPARISON_TEXT:
        return Comparison(
            ERROR,
            "comparison operand is too large to parse: "
            f"{largest} characters exceeds {MAX_COMPARISON_TEXT}",
        )

    def parse_once(text: str, syntax: str):
        if parsed_cache is None:
            return parse(text, syntax)
        key = (syntax, text)
        if key not in parsed_cache:
            parsed_cache[key] = parse(text, syntax)
        return parsed_cache[key]

    try:
        candidate = parse_once(candidate_text, candidate_syntax)
        reference = parse_once(reference_text, reference_syntax)
    except Exception as exc:
        return Comparison(ERROR, f"unparseable: {exc}")
    return compare(strip_assumptions(candidate), strip_assumptions(reference), strictness)


def _equivalent(a, b) -> bool:
    import sympy

    if isinstance(a, sympy.Tuple) or isinstance(b, sympy.Tuple):
        if not isinstance(a, sympy.Tuple) or not isinstance(b, sympy.Tuple):
            return False
        return len(a) == len(b) and all(
            _equivalent(left, right) for left, right in zip(a, b)
        )
    if not isinstance(a, sympy.Basic) or not isinstance(b, sympy.Basic):
        return False
    try:
        return bool(sympy.simplify(a - b) == 0)
    except Exception:
        # The comparison oracle failing to decide is not evidence of agreement.
        return False


def _numeric_equivalent(a, b) -> bool:
    """Compare matching expression trees while allowing rounded numeric leaves.

    ``N[expr, p]`` is an approximate operation. SymPy and the native MPFR
    path can therefore retain different guard digits even when both values
    agree to the requested precision. This policy is explicit: expression
    heads and symbolic leaves still have to match, while numeric leaves are
    compared with a tolerance derived from the lower precision of the two
    operands.
    """
    import sympy

    try:
        if a == b:
            return True
    except Exception:
        return False

    if _numeric_leaf_equivalent(a, b):
        return True

    if isinstance(a, sympy.MatrixBase) and isinstance(b, sympy.MatrixBase):
        if a.shape != b.shape:
            return False
        return all(
            _numeric_equivalent(left, right)
            for left, right in zip(a, b)
        )

    if not isinstance(a, sympy.Basic) or not isinstance(b, sympy.Basic):
        return False
    if a.func != b.func or len(a.args) != len(b.args):
        return False
    if not a.args:
        # Atomic SymPy nodes such as Symbol('x') have the same head and no
        # children even when their values differ. The equality check above is
        # the only valid comparison for those nodes.
        return False
    return all(
        _numeric_equivalent(left, right)
        for left, right in zip(a.args, b.args)
    )


def _numeric_leaf_equivalent(a, b) -> bool:
    import sympy

    if not isinstance(a, sympy.Basic) or not isinstance(b, sympy.Basic):
        return False
    if not a.is_number or not b.is_number:
        return False
    if a.free_symbols or b.free_symbols:
        return False
    # Non-finite values are only equal through the exact equality check above;
    # a tolerance must never turn two different infinities or NaNs into a pass.
    if a.is_finite is False or b.is_finite is False:
        return False

    precisions = [
        precision
        for value in (a, b)
        for precision in (getattr(value, "_prec", None),)
        if isinstance(precision, int) and precision > 0
    ]
    if not precisions:
        return _equivalent(a, b)

    bits = min(precisions)
    decimal_digits = max(1, int(bits / 3.321928094887362) - 2)
    work_prec = max(80, bits + 32)
    tolerance = sympy.Float(10) ** (-decimal_digits)
    try:
        difference = sympy.Abs(sympy.N(a - b, work_prec))
        scale = max(
            sympy.Integer(1),
            sympy.Abs(sympy.N(a, work_prec)),
            sympy.Abs(sympy.N(b, work_prec)),
        )
        return bool(difference <= sympy.N(tolerance * scale, work_prec))
    except Exception:
        # A failed numeric decision is not evidence of agreement.
        return False


def strip_assumptions(expr):
    """Drop SymPy assumption metadata from every symbol in ``expr``.

    Only ever used when comparing *across* languages. A Wolfram symbol carries
    no assumptions, so ``Symbol('x')`` and ``Symbol('x', real=True)`` are the
    same symbol as far as the two oracles can possibly agree — comparing the
    metadata would report a difference in SymPy's representation as if it were a
    difference in the mathematics.

    Within one language the metadata is meaningful and is left alone.
    """
    import sympy

    if not isinstance(expr, sympy.Basic):
        return expr
    if isinstance(expr, sympy.Symbol):
        return sympy.Symbol(expr.name) if expr.assumptions0 else expr

    # ``Tuple.subs`` can fail when one of its members is an opaque applied
    # function containing an assumed symbol. Rebuild the small expression tree
    # instead of asking SymPy to substitute through that mixed container.
    try:
        raw_arguments = tuple(expr.args)
    except TypeError:
        return expr
    arguments = tuple(strip_assumptions(argument) for argument in raw_arguments)
    if arguments == raw_arguments:
        return expr
    try:
        return expr.func(*arguments)
    except Exception:
        try:
            return expr.func(*arguments, evaluate=False)
        except Exception:
            # Assumption stripping is a comparison convenience. If a backend
            # emits a non-reconstructible opaque node, leave it intact so the
            # comparison reports a difference rather than crashing the audit.
            return expr


def check_oracles(sympy_value, mathics_value, strictness: str) -> Comparison | None:
    """Cross-check the two oracles against each other.

    Where they disagree, neither is ground truth for that result and fortsym is
    not scored on it. Averaging them, or silently preferring one, would bury a
    real finding.
    """
    if sympy_value is None or mathics_value is None:
        return None
    result = compare(
        strip_assumptions(mathics_value), strip_assumptions(sympy_value), strictness
    )
    if result.outcome is AGREE or result.outcome == AGREE:
        return None
    return Comparison(ORACLE_DISAGREEMENT, result.detail)

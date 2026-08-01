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
        return sympy.sympify(text)
    if syntax == "inputform":
        normalised, restore = _normalise_inputform(text)
        return _restore_inputform_symbols(parse_mathematica(normalised), restore)
    raise ValueError(f"unknown syntax: {syntax}")


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
    text = _protect_inputform_strings(text)
    text = _normalise_derivative_calls(text)
    text, protected = _protect_inputform_greek_symbols(text)
    return _protect_inputform_builtin_symbols(text, protected)


def _protect_inputform_greek_symbols(text: str) -> tuple[str, dict[str, str]]:
    protected = {}
    pieces = []
    start = 0
    for match in re.finditer(r"[α-ωΑ-Ωϕ]|%[0-9]*", text):
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
            continue
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

    if not protected or not isinstance(expression, sympy.Basic):
        return expression
    if isinstance(expression, sympy.Symbol):
        name = protected.get(str(expression))
        return sympy.Symbol(name) if name is not None else expression
    try:
        arguments = tuple(expression.args)
    except TypeError:
        return expression
    restored = tuple(_restore_inputform_symbols(argument, protected) for argument in arguments)
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
    """Use fortsym's opaque derivative spelling for simple WL derivatives."""
    def replace(match: re.Match[str]) -> str:
        orders = [part.strip() for part in match.group(1).split(",")]
        head = match.group(2)
        arguments = match.group(3).strip()
        if len(orders) == 1:
            return f"Derivative1[{head}, {orders[0]}, {arguments}]"
        # Mathics writes a first partial derivative as a multi-index, while
        # fortsym records the same operation by one-based coordinate number.
        # Preserve genuinely higher-order or mixed derivatives as opaque
        # nodes: collapsing those would erase a real semantic difference.
        if all(order in {"0", "1"} for order in orders):
            nonzero = [index for index, order in enumerate(orders, start=1) if order == "1"]
            if len(nonzero) == 1:
                return f"Derivative1[{head}, {nonzero[0]}, {arguments}]"
        return "DerivativeIndex[{head}, {orders}, {arguments}]".format(
            head=head,
            orders=", ".join(orders),
            arguments=arguments,
        )

    previous = None
    while previous != text:
        previous = text
        text = _DERIVATIVE_CALL.sub(replace, text)
    return text


def compare(candidate, reference, strictness: str) -> Comparison:
    """Compare one result against the oracle at the declared strictness.

    ``structural`` and ``equivalent`` are both legitimate bars. Which one a
    result is held to is declared in the corpus file, not chosen here — a
    comparator that quietly falls back from structural to equivalent would hide
    precisely the canonical-form differences worth knowing about.
    """
    import sympy

    if strictness == "structural":
        try:
            equal = candidate == reference
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

    try:
        return sympy.simplify(a - b) == 0
    except Exception:
        # The comparison oracle failing to decide is not evidence of agreement.
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

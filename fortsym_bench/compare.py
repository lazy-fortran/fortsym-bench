"""Normalise results from every backend into SymPy objects and compare them.

One parser per syntax, in one place. The Python backends emit SymPy's ``srepr``;
the Wolfram backends emit ``InputForm``, read by ``sympy.parsing.mathematica``.
Both parsers are BSD SymPy, so the comparison path carries no licence question.
"""

from __future__ import annotations

from dataclasses import dataclass

AGREE = "agree"
DIFFER = "differ"
UNSUPPORTED = "unsupported"
ERROR = "error"
ORACLE_DISAGREEMENT = "oracle-disagreement"
ORACLE_MISSING = "oracle-missing"
UNAVAILABLE = "unavailable"
TIMEOUT = "timeout"
UNTRANSLATED = "untranslated"


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
        return parse_mathematica(text)
    raise ValueError(f"unknown syntax: {syntax}")


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
        if _equivalent(candidate, reference):
            return Comparison(
                DIFFER,
                "mathematically equivalent but structurally different; "
                "declared strictness is 'structural'",
            )
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

    if not hasattr(expr, "free_symbols"):
        return expr
    replacements = {
        s: sympy.Symbol(s.name) for s in expr.free_symbols if s.assumptions0
    }
    return expr.subs(replacements, simultaneous=True) if replacements else expr


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

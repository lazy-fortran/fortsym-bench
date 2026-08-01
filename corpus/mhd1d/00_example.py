"""Worked example showing the corpus contract. Not a physics derivation."""

import sympy as sp

# Declared strictness per result. Default is "structural".
COMPARE = {"series": "equivalent"}


def results():
    x = sp.Symbol("x", real=True)
    y = sp.Symbol("y", positive=True)
    return {
        "pythagorean": sp.simplify(sp.sin(x) ** 2 + sp.cos(x) ** 2),
        "derivative": sp.diff(sp.exp(x * y), x),
        "exact_rational": sp.Rational(1, 3) + sp.Rational(1, 6),
        "series": sp.series(sp.exp(x), x, 0, 4).removeO(),
    }

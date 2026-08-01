"""Worked example showing the corpus contract.

The Wolfram source stores its answers in an Association, which is not part of
the deliberately small expression parser used for generated companions.  It
is clearer and more faithful to hand-expand this one fixture into the same
named SymPy results that the association contains.
"""

import sympy as sp


COMPARE = {"series": "equivalent"}

def results():
    x = sp.Symbol("x", real=True)
    y = sp.Symbol("y", positive=True)
    return {
        "pythagorean": sp.simplify(sp.sin(x) ** 2 + sp.cos(x) ** 2),
        "derivative": sp.diff(sp.exp(x * y), x),
        "exact_rational": sp.Rational(1, 3) + sp.Rational(1, 6),
        "series": sp.series(sp.exp(x), x, 0, 5).removeO(),
    }

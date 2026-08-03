from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/37_memo_update_20260717.py"
)


def _load():
    spec = importlib.util.spec_from_file_location("memo_update_37_v107", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_memo37_gamma_fixture_preserves_the_independent_compact_normal_form():
    actual = _load().results()["gammaExpr"]
    x = sp.Symbol("x")
    expected = x**3 * (
        sp.Rational(21, 1250) * x**6
        + sp.Rational(59, 50) * x**4
        + sp.Rational(145, 6) * x**2
        + sp.Rational(3125, 18)
    ) / (27 * x**6 + 675 * x**4 + 5625 * x**2 + 15625)

    # The independently written fixture formula checks the value, while the
    # tree assertion protects the source-faithful Wolfram normal form.
    assert sp.simplify(actual - expected) == 0
    assert sp.srepr(actual) == sp.srepr(expected)

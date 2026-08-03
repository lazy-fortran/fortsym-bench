from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/37_memo_update_20260717.py"
)


def test_memo37_lowers_named_derivative_upvalues_before_series_expansion():
    spec = importlib.util.spec_from_file_location("memo_update_37", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    values = module.results()
    s0 = sp.Symbol("s0")
    PP = sp.Function("PP")
    QQ = sp.Function("QQ")

    # From d/ds Psi0F[s0] = PP[s0], the first-order coefficient is
    # (u1 PP[s0] + QQ[s0]) Cos[phi], hence its zero is -QQ/PP.
    assert values["u1Sol"] == -QQ(s0) / PP(s0)


def test_memo37_fexpr_matches_the_source_derivative_polynomial():
    spec = importlib.util.spec_from_file_location("memo_update_37_fexpr", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    values = module.results()
    x = sp.Symbol("x")
    expected = x**2 * (125 + 3 * x**2) / 37500

    # Independent exact evaluations cover two nonzero radii and avoid merely
    # asserting that the generated expression has a particular tree shape.
    assert sp.simplify(values["fExpr"] - expected).subs(x, 1) == 0
    assert sp.simplify(values["fExpr"] - expected).subs(x, 2) == 0

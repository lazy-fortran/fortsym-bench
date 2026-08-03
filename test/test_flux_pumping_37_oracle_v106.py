from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/37_memo_update_20260717.py"
)


def _load():
    spec = importlib.util.spec_from_file_location("memo_update_37_v106", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_memo37_g0pp_matches_an_independent_quotient_second_derivative():
    values = _load().results()
    s = sp.Symbol("s")
    s0 = sp.Symbol("s0")
    m = sp.Integer(7)
    pp = 2 + s + s**2
    tt = 3 - s + 2 * s**2

    derivative1 = sp.Function("Derivative1")
    substitutions = {
        sp.Symbol("m"): m,
        sp.Function("PP")(s0): pp.subs(s, s0),
        sp.Function("TT")(s0): tt.subs(s, s0),
        derivative1(sp.Symbol("PP"), 1, s0): sp.diff(pp, s).subs(s, s0),
        derivative1(sp.Symbol("PP"), 2, s0): sp.diff(pp, s, 2).subs(s, s0),
        derivative1(sp.Symbol("TT"), 1, s0): sp.diff(tt, s).subs(s, s0),
        derivative1(sp.Symbol("TT"), 2, s0): sp.diff(tt, s, 2).subs(s, s0),
    }
    actual = values["g0pp"].xreplace(substitutions)

    # Independent exact evaluations keep this a behavioral check rather than
    # a test of the generated derivative tree or its printed normal form.
    for point in (0, 1):
        expected = sp.diff(m * tt / pp, s, 2).subs(s, point)
        assert sp.simplify(actual.subs(s0, point) - expected) == 0

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/37_memo_update_20260717.py"
)


def _load():
    spec = importlib.util.spec_from_file_location("memo_update_37_remaining", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_memo37_second_order_fixture_uses_the_solved_mean_shift():
    values = _load().results()
    s0 = sp.Symbol("s0")
    PP = sp.Function("PP")
    QQ = sp.Function("QQ")
    pp = sp.Function("pp")

    u1 = -QQ(s0) / PP(s0)
    expected_shift = -(sp.diff(PP(s0), s0) * u1**2 / 4 + pp(s0) * u1 / 2) / PP(s0)
    assert sp.simplify(values["u20Sol"] - expected_shift) == 0
    assert sp.simplify(values["u22Sol"] - expected_shift) == 0


def test_memo37_derived_fixture_matches_an_independent_exact_value():
    values = _load().results()
    expected = -sp.Rational(7013593, 1286250000)

    assert abs(sp.N(values["derivedFixture"], 30) - sp.N(expected, 30)) < sp.Rational(1, 10**18)


def test_memo37_fixture_rules_preserve_the_source_flux_derivative_pair():
    values = _load().results()
    rule = sp.Function("Rule")
    derivative1 = sp.Function("Derivative1")
    s0 = sp.Symbol("s0")
    s0v = sp.Symbol("s0v")
    rules = {
        item.args[0]: item.args[1]
        for item in values["fixtureRules"]
        if item.func == rule
    }

    # Independent exact evaluation of the source's x = Sqrt[2 s0v] fixture:
    # detExpr = 1/5 + iotaBackgroundExpr/5 and QQ = x fExpr.
    x = sp.Symbol("x")
    radial = sp.sqrt(2 * s0v)
    expected_det = sp.Rational(1, 5) + (-sp.Rational(3, 4) + sp.Rational(3, 100) * radial**2) / 5
    expected_qq = radial * radial**2 * (3 * radial**2 + 125) / 37500
    qq_x = x * x**2 * (3 * x**2 + 125) / 37500
    expected_qq2 = (sp.diff(sp.diff(qq_x, x) / x, x) / x).subs(x, radial)
    assert sp.simplify(rules[sp.Function("PP")(s0)] - expected_det) == 0
    assert sp.simplify(rules[derivative1(sp.Symbol("QQ"), 2, s0)] - expected_qq2) == 0
    assert sp.simplify(rules[sp.Function("QQ")(s0)] - expected_qq) == 0

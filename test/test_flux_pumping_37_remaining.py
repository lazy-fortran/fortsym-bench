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

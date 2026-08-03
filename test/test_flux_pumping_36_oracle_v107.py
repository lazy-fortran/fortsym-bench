"""Independent checks for the source-derived memo36 fixture lowering."""

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/36_memo_update_20260716.py"
)


def _load():
    spec = importlib.util.spec_from_file_location("memo_update_36_v107", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_memo36_b15_update_has_the_source_gamma_reduction_and_numeric_value():
    values = _load().results()
    gamma_third = sp.Symbol("gammaThird")
    gamma_sixth = sp.sqrt(3) * gamma_third**2 / (
        2 ** sp.Rational(1, 3) * sp.sqrt(sp.pi)
    )
    gamma = sp.Function("Gamma")
    assert sp.simplify(
        values["b15New"].subs({
            gamma(sp.Rational(1, 6)): gamma_sixth,
            gamma(sp.Rational(1, 3)): gamma_third,
        })
        - values["b15Ours"].subs(gamma(sp.Rational(1, 3)), gamma_third)
    ) == 0
    numeric = values["b15New"].subs({
        gamma(sp.Rational(1, 6)): sp.gamma(sp.Rational(1, 6)),
        gamma(sp.Rational(1, 3)): sp.gamma(sp.Rational(1, 3)),
    })
    assert abs(sp.N(numeric, 30) - sp.Float("2.1401304355", 30)) < sp.Rational(1, 10**9)


def test_memo36_fixture_derivative_polynomial_is_source_derived():
    values = _load().results()
    x = sp.Symbol("x")
    expected = x**2 * (125 + 3 * x**2) / 37500
    assert sp.simplify(values["fExpr"] - expected) == 0
    assert sp.simplify(values["phaseExpr"] - x * (x**2 + 25) / 2500) == 0

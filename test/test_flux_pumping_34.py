from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp
import pytest


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/34_memo_maxwell_20260714.py"
)


def test_memo34_y_long_keeps_radial_powers_as_factors():
    spec = importlib.util.spec_from_file_location("memo_maxwell_34", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    values = module.results()
    r, ell, n, cap_r, cl, signed_m = sp.symbols(
        "r ell n capR cl signedM"
    )
    lower_moment = sp.Function("lowerMoment")
    upper_moment = sp.Function("upperMoment")
    expected = 2 * sp.pi * n / (cl * signed_m * cap_r) * (
        r ** (-ell) * lower_moment(r) - r**ell * upper_moment(r)
    )

    assert sp.simplify(values["yLong"] - expected) == 0
    numeric = values["yLong"]
    numeric = numeric.subs(
        {symbol: {"r": 2, "ell": 1, "n": 3, "capR": 5, "cl": 7, "signedM": -1}[symbol.name]
         for symbol in numeric.free_symbols}
    )
    numeric = numeric.subs(
        {sp.Function("lowerMoment")(2): 11, sp.Function("upperMoment")(2): 13}
    )
    assert numeric == sp.Rational(123, 35) * sp.pi


def test_memo34_kernel_relative_error_uses_the_positive_numeric_branch():
    spec = importlib.util.spec_from_file_location("memo_maxwell_34", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    values = module.results()
    product = sp.besseli(1, sp.Rational(1, 10)) * sp.besselk(
        1, sp.Rational(1, 10)
    )
    expected = sp.Abs(2 * product - 1)
    value = values["kernelRelativeError"].xreplace({
        sp.Function("BesselI")(1, sp.Rational(1, 10)):
            sp.besseli(1, sp.Rational(1, 10)),
        sp.Function("BesselK")(1, sp.Rational(1, 10)):
            sp.besselk(1, sp.Rational(1, 10)),
    })
    assert abs(float(sp.N(value.args[0], 15))) == pytest.approx(
        float(sp.N(expected, 15))
    )
    assert sp.N(expected, 15) > 0.01

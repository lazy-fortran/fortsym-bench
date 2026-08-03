from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/34_memo_maxwell_20260714.py"
)


def _translated_values():
    spec = importlib.util.spec_from_file_location("memo_maxwell_34_v106", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.results()


def test_memo34_br_long_keeps_the_two_radial_moment_products_separate():
    values = _translated_values()
    r, ell, cap_r, cl, signed_m = sp.symbols(
        "r ell capR cl signedM"
    )
    lower_moment = sp.Function("lowerMoment")
    upper_moment = sp.Function("upperMoment")
    expected = 2 * sp.pi * sp.I * cap_r * ell / (cl * signed_m * r) * (
        r ** (-ell) * lower_moment(r) + r**ell * upper_moment(r)
    )

    assert sp.simplify(values["brLong"] - expected) == 0

    numeric = values["brLong"].subs(
        {r: 2, ell: 1, cap_r: 5, cl: 7, signed_m: -1}
    ).subs({lower_moment(2): 11, upper_moment(2): 13})
    assert numeric == -sp.Rational(45, 2) * sp.pi * sp.I

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = Path(__file__).parents[1] / 'corpus/archive-tu/math10y.py'
_SPEC = importlib.util.spec_from_file_location('math10y', _SOURCE)
math10y = importlib.util.module_from_spec(_SPEC)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(math10y)


def test_math10y_recovered_bindings_match_the_wolfram_formulas():
    values = math10y.results()
    a, t, x, y, z = sp.symbols('a t x y z')
    radius = sp.sqrt(x**2 + y**2 + z**2)

    assert values['r'] == radius
    assert values['fss'] == sp.Function('UnitStep')(a + t) + sp.Function(
        'UnitStep'
    )(a - t) - 1
    assert values['ft'] == 1 / (t**2 + a**2)


def test_math10y_recovery_is_bounded_and_does_not_enter_expensive_examples():
    values = math10y.results()

    assert {'ps', 'pa', 'fw', 'fut', 'nn', 'f0'}.isdisjoint(values)
    assert values['iaf'] == 0
    assert values['irf'] == 0

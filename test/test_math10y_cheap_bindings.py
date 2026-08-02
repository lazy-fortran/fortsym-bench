from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = Path(__file__).parents[1] / 'corpus/archive-tu/math10y.py'
_SPEC = importlib.util.spec_from_file_location('math10y_cheap', _SOURCE)
math10y = importlib.util.module_from_spec(_SPEC)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(math10y)


def test_cheap_math10y_late_bindings_are_source_formulas():
    values = math10y.results()
    a, b, x = sp.symbols('a b x')

    assert values['gc'] == sp.cos(1) - sp.cos(2)
    assert values['k'] == -sp.sin(3 * x) * sp.cos(x) ** 2
    assert values['fxd'] == (
        sp.sin(a * x + b * x) - sp.sin(a * x - b * x)
    ) / 2


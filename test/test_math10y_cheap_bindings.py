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


def test_math10y_literal_rule_assignments_preserve_source_values():
    values = math10y.results()
    rule = sp.Function('Rule')
    phi = sp.Symbol('phi')
    y, x = sp.symbols('y x')

    assert values['sy'] == rule(
        y, sp.Symbol('b') * sp.sqrt(1 - x**2 / sp.Symbol('a')**2) * sp.sin(phi)
    )
    assert values['sua'] == rule(sp.Symbol('a'), 1)
    assert values['sa'] == sp.Tuple(rule(sp.Symbol('a'), 1))
    assert values['su'] == sp.Tuple(
        rule(sp.Symbol('a'), sp.Float('0.37')),
        rule(sp.Symbol('b'), sp.Float('1.23')),
        rule(sp.Symbol('c'), sp.Float('0.79')),
        rule(sp.Symbol('d'), sp.Float('3.21')),
    )
    assert values['svd'] == sp.Tuple(
        rule(sp.Symbol('V0'), 10),
        rule(sp.Symbol('R'), 22),
        rule(sp.Symbol('L'), 110),
        rule(sp.Symbol('C'), 1),
    )
    assert values['svs'] == sp.Tuple(
        rule(sp.Symbol('V0'), 10),
        rule(sp.Symbol('R'), 22),
        rule(sp.Symbol('L'), 110),
        rule(sp.Symbol('C'), 19),
    )

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


def test_math10y_recovered_geometry_values_have_independent_numeric_oracles():
    values = math10y.results()
    a, b, x, phi = sp.symbols('a b x phi')

    assert values['dy'] == b * sp.sqrt(1 - x**2 / a**2) * sp.cos(phi)
    expected_corners = {
        'g11': sp.Float('-4.393958173231915'),
        'g01': sp.Float('-4.739667394322384'),
        'g10': sp.Float('-0.3494354499302735'),
        'g00': sp.Float('-0.6528664717019914'),
    }
    for name, expected in expected_corners.items():
        assert abs(values[name] - expected) < sp.Float('1e-14')


def test_math10y_step_binding_matches_independent_numeric_oracle():
    values = math10y.results()
    step = values['ft1']
    t, a = sp.symbols('t a')

    assert step.subs({t: -1, a: 0}) == 0
    assert step.subs({t: 0, a: 0}) == 0
    assert step.subs({t: 1, a: 0}) == 1


def test_math10y_final_which_binding_matches_independent_numeric_oracle():
    value = math10y.results()['f']
    x = sp.Symbol('x')

    assert [value.subs(x, sample) for sample in (-1, sp.Rational(1, 2), 1, 3)] == [
        0,
        1,
        1,
        -1,
    ]


def test_math10y_ellipsoid_bindings_match_independent_numeric_oracles():
    values = math10y.results()
    a, b, c, x, phi = sp.symbols('a b c x phi')

    # Integrating dz dy dx over the positive octant of an ellipsoid gives
    # one eighth of 4*pi*a*b*c/3, independently of the Wolfram translation.
    assert values['v'] == sp.pi * a * b * c / 6

    sample = {a: 2, b: 3, c: 4, x: sp.Rational(1, 2), phi: sp.Rational(1, 3)}
    expected_vvy = 4 * sp.sqrt(
        1 - sp.Rational(1, 2) ** 2 / 2**2
        - (1 - sp.Rational(1, 2) ** 2 / 2**2) * sp.sin(sp.Rational(1, 3)) ** 2
    )
    assert abs(values['vvy'].subs(sample).evalf() - expected_vvy.evalf()) < 1e-14
    assert values['vy'].subs(sample) == (
        sp.pi * 3 * 4 * (1 - sp.Rational(1, 2) ** 2 / 2**2) / 4
    )

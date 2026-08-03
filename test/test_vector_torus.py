import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = (
    Path(__file__).parents[1]
    / 'corpus'
    / 'nc-stud-Master_Florian_Seeber'
    / 'test_vector_torus.py'
)
_SPEC = importlib.util.spec_from_file_location('vector_torus_translation', _SOURCE)
_MODULE = importlib.util.module_from_spec(_SPEC)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(_MODULE)


def test_v123_sqg_uses_the_positive_source_assumption_branch():
    values = _MODULE.results()
    a, et, th = sp.symbols('a et th')
    denominator = sp.cosh(et) - sp.cos(th)

    expected = a**3 * sp.sinh(et) / denominator**3
    assert values['sqg'] == expected


def test_v123_equations_keep_only_source_indexed_components():
    values = _MODULE.results()
    a, et, th, m = sp.symbols('a et th m')
    denominator = sp.cosh(et) - sp.cos(th)
    coefficient = m**2 * denominator / (a * sp.sinh(et))

    A = sp.Function('A')
    AR = sp.Function('AR')
    assert values['eq1'] == sp.Eq(coefficient * A(1), 0)
    assert values['eq2'] == sp.Eq(coefficient * A(2), 0)
    assert values['eq1R'] == sp.Eq(coefficient * AR(1), 0)
    assert values['eq2R'] == sp.Eq(coefficient * AR(2), 0)


def test_v123_equations_are_not_derivatives_of_component_functions():
    values = _MODULE.results()

    for name in ('eq1', 'eq2', 'eq1R', 'eq2R'):
        assert not values[name].has(sp.Derivative)

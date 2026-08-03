import importlib.util
import math
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
_VALUES = _MODULE.results()


def _numeric_equivalent(actual, expected, substitutions):
    """Use an independent machine-real policy for this small source slice."""
    observed = complex(sp.N(actual.subs(substitutions), 30))
    target = complex(expected)
    return math.isclose(
        observed.real,
        target.real,
        rel_tol=1.0e-12,
        abs_tol=1.0e-12,
    ) and math.isclose(
        observed.imag,
        target.imag,
        rel_tol=1.0e-12,
        abs_tol=1.0e-12,
    )


def test_v123_sqg_retains_the_explicit_source_square_root():
    a, et, th = sp.symbols('a et th')
    denominator = sp.cosh(et) - sp.cos(th)

    expected = a**3 * sp.sinh(et) / denominator**3
    assert _VALUES['sqg'] != expected


def test_v123_sqg_is_independently_numeric_equivalent_to_that_branch():
    a, et, th = sp.symbols('a et th')
    m = sp.symbols('m')
    A = sp.Function('A')
    AR = sp.Function('AR')
    samples = ((2.0, 0.4, -2.0), (1.25, 1.1, 0.7), (3.0, 0.08, 2.4))

    for a_value, et_value, th_value in samples:
        denominator = math.cosh(et_value) - math.cos(th_value)
        source_metric = math.sqrt(
            (a_value**2 / denominator**2)
            * (a_value**2 / denominator**2)
            * (a_value**2 * math.sinh(et_value) ** 2 / denominator**2)
        )
        positive_branch = a_value**3 * math.sinh(et_value) / denominator**3
        substitutions = {a: a_value, et: et_value, th: th_value}
        assert _numeric_equivalent(_VALUES['sqg'], source_metric, substitutions)
        assert math.isclose(source_metric, positive_branch, rel_tol=1.0e-12)

        coefficient = a_value**2 * 1.7**2 / positive_branch / denominator**2
        for name, component in (
            ('eq1', (A(1), 2.0)),
            ('eq2', (A(2), -0.75)),
            ('eq1R', (AR(1), 1.25)),
            ('eq2R', (AR(2), 3.5)),
        ):
            equation_substitutions = {
                **substitutions,
                m: 1.7,
                component[0]: component[1],
            }
            assert _numeric_equivalent(
                _VALUES[name].lhs,
                coefficient * component[1],
                equation_substitutions,
            )


def test_v123_equations_keep_only_source_indexed_components():
    a, et, th, m = sp.symbols('a et th m')
    denominator = sp.cosh(et) - sp.cos(th)
    g11 = a**2 / denominator**2
    sqg = sp.sqrt(g11 * g11 * g11 * sp.sinh(et)**2)
    coefficient = a**2 * m**2 / sqg / denominator**2

    A = sp.Function('A')
    AR = sp.Function('AR')
    assert _VALUES['eq1'] == sp.Eq(coefficient * A(1), 0)
    assert _VALUES['eq2'] == sp.Eq(coefficient * A(2), 0)
    assert _VALUES['eq1R'] == sp.Eq(coefficient * AR(1), 0)
    assert _VALUES['eq2R'] == sp.Eq(coefficient * AR(2), 0)


def test_v123_equations_are_not_derivatives_of_component_functions():
    for name in ('eq1', 'eq2', 'eq1R', 'eq2R'):
        assert not _VALUES[name].has(sp.Derivative)


def test_v123_numeric_policy_rejects_the_wrong_square_root_branch():
    a_value, et_value, th_value = 2.0, 0.6, -0.3
    denominator = math.cosh(et_value) - math.cos(th_value)
    positive_branch = a_value**3 * math.sinh(et_value) / denominator**3
    assert not math.isclose(
        positive_branch,
        -positive_branch,
        rel_tol=1.0e-12,
        abs_tol=1.0e-12,
    )

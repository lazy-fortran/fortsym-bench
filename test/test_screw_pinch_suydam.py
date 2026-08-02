"""Independent checks for the screw-pinch source bindings."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/screw_pinch_suydam.py'
    )
    spec = importlib.util.spec_from_file_location('screw_pinch_suydam', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_force_balance_binding_preserves_source_rule_and_algebra():
    values = _load().results()
    r, mu0 = sp.symbols('r mu0')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')
    expected = (
        -btheta(r) * (
            btheta(r) + r * derivative1(sp.Symbol('btheta'), 1, r)
        ) / (mu0 * r)
        - bz(r) * derivative1(sp.Symbol('bz'), 1, r) / mu0
    )

    rule = values['forceBalance']
    assert rule.func == sp.Function('RuleDelayed')
    assert rule.args[0] == derivative1(
        sp.Symbol('p'), 1,
        sp.Function('Pattern')(sp.Symbol('rr'), sp.Function('Blank')()),
    )
    assert sp.simplify(
        rule.args[1].subs({sp.Symbol('rr'): r}) - expected
    ) == 0


def test_resonance_binding_is_the_source_rule():
    values = _load().results()
    m, rs = sp.symbols('m rs')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')

    assert values['resonance'] == sp.Function('Rule')(
        sp.Symbol('k'), -m * btheta(rs) / (rs * bz(rs))
    )


def test_late_frobenius_coefficients_follow_source_reduction():
    values = _load().results()
    assert values['fCoefficient'] == 0
    assert values['crossCoefficient'] == 0
    assert values['cCoefficient'] == 0
    assert values['gCoefficient'] == 0
    assert values['fQuadratic'] == 0
    assert values['gResonant'] == 0
    assert values['indicialRatio'] == 1


def test_suydam_ratio_is_the_source_equilibrium_expression():
    values = _load().results()
    mu0, rs, length = sp.symbols('mu0 rs len')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')
    den = (
        -rs * derivative1(sp.Symbol('btheta'), 1, rs) * bz(rs)
        / (length * btheta(rs) ** 2)
        + rs * derivative1(sp.Symbol('bz'), 1, rs)
        / (length * btheta(rs))
        + bz(rs) / (length * btheta(rs))
    )
    expected = 1 + 8 * mu0 * rs * derivative1(
        sp.Symbol('p'), 1, rs
    ) / (length ** 2 * btheta(rs) ** 2 * den ** 2)
    assert values['suydamRatio'] == expected


def test_quadratic_keeps_the_source_radial_prefactor():
    values = _load().results()
    assert values['quadratic'] == sp.Tuple(
        sp.Symbol('r') * sp.Symbol('realDensity')
    )

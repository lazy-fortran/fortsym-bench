"""Independent checks for the source-faithful force-balance lowering."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/two_component_energy_identity.py'
    )
    spec = importlib.util.spec_from_file_location('two_component_energy_identity', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_force_balance_rule_and_pressure_slope_are_source_faithful():
    values = _load().results()
    r, mu0 = sp.symbols('r mu0')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    btheta_prime = sp.Function('Derivative1')(sp.Symbol('btheta'), 1, r)
    bz_prime = sp.Function('Derivative1')(sp.Symbol('bz'), 1, r)
    expected = -bz_prime * bz(r) - btheta(r) * (
        btheta(r) + r * btheta_prime
    ) / r

    assert sp.simplify(values['pressureSlope'] - expected) == 0

    rule = values['forceBalance']
    assert rule.func == sp.Function('RuleDelayed')
    assert rule.args[0] == sp.Function('Derivative1')(
        sp.Symbol('p'), 1,
        sp.Function('Pattern')(sp.Symbol('rr'), sp.Function('Blank')())
    )
    assert sp.simplify(
        rule.args[1].subs({sp.Symbol('rr'): r}) - expected / mu0
    ) == 0


def test_jdotb_is_the_cylindrical_current_field_contraction():
    values = _load().results()
    r = sp.Symbol('r')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')

    # For B = (0, btheta, bz), cylindrical curl(B) has components
    # (0, -bz', (btheta + r btheta')/r).  The mu0 in the source cancels
    # the current's 1/mu0 factor before the dot product.
    btheta_value, bz_value = 3, 5
    btheta_prime, bz_prime = 7, 11
    expression = values['jDotB'].subs({
        r: 2,
        btheta(r): btheta_value,
        bz(r): bz_value,
        derivative1(sp.Symbol('btheta'), 1, r): btheta_prime,
        derivative1(sp.Symbol('bz'), 1, r): bz_prime,
    })
    assert expression == sp.Rational(19, 2)

    # Check the same contraction at a second point, including a vanishing
    # azimuthal field, to exercise both cylindrical-current terms.
    expression = values['jDotB'].subs({
        r: 4,
        btheta(r): 0,
        bz(r): 2,
        derivative1(sp.Symbol('btheta'), 1, r): -3,
        derivative1(sp.Symbol('bz'), 1, r): 13,
    })
    assert expression == -6

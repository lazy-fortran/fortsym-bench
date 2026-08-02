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

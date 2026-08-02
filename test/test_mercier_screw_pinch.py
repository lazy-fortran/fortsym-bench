import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = Path(__file__).parents[1] / 'corpus/proj-gvec-stability/mercier_screw_pinch.py'
    spec = importlib.util.spec_from_file_location('mercier_screw_pinch', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_force_balance_rule_and_geodesic_term_are_source_faithful():
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
    assert sp.simplify(
        rule.args[1].subs({sp.Symbol('rr'): r}) - expected
    ) == 0
    assert values['dGeodesic'] == 0

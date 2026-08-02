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

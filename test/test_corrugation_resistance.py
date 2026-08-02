"""Independent checks for the corrugation ledger recoveries."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/39_corrugation_resistance.py'
    )
    spec = importlib.util.spec_from_file_location('corrugation_resistance', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_constraint_composite_and_surface_rules_match_the_source():
    values = _module().results()
    r, rho, th, z, chi = sp.symbols('r rho th z chi')
    eps, m, k = sp.symbols('eps m k')
    p = sp.Function('p')
    t = sp.Function('t')
    w = sp.Function('w')
    derivative1 = sp.Function('Derivative1')
    Delta = sp.Function('Delta')
    rr2 = sp.Function('rr2')
    rr2c = sp.Function('rr2c')

    expected_constraint = (
        derivative1(sp.Symbol('p'), 1, r)
        + p(r) / r - m * t(r) / r - k * w(r)
    )
    assert sp.simplify(values['divConstraint'] - expected_constraint) == 0
    expected_composite = (
        rho * derivative1(sp.Symbol('p'), 1, rho) + p(rho)
        - k * rho * w(rho)
    ) / m
    assert sp.simplify(values['tComposite'] - expected_composite) == 0

    rules = values['onSurf']
    assert all(item.func == sp.Function('Rule') for item in rules)
    assert rules[0].args[0] == r
    assert rules[1] == sp.Function('Rule')(th, chi / m)
    assert rules[2] == sp.Function('Rule')(z, 0)
    assert rules[0].args[1].subs({eps: 0}) == rho

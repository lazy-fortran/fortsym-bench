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


def test_vector_repairs_preserve_source_forms():
    values = _module().results()
    r, th, z = sp.symbols('r th z')
    bvec = sp.Symbol('Bvec')
    dot = sp.Function('Dot')
    b2 = dot(bvec, bvec)
    assert values['B2On'] == b2
    assert values['Bmag'] == sp.sqrt(b2)
    assert values['ratioOn'] == b2 / sp.Symbol('BzOn')
    assert values['lhsId'] == sp.Function('divCyl')(
        sp.Function('g')(r, th, z) * bvec / sp.sqrt(b2), r, th, z
    )

def test_vector_identities_match_independent_source_forms():
    values = _module().results()
    r, th, z, m, k, alpha, B0 = sp.symbols(
        'r th z m k alpha B0'
    )
    Bth = sp.Function('Bth')
    Delta = sp.Function('Delta')
    p = sp.Function('p')
    chi = m * th + k * z
    expected_tangency = p(r) * sp.sin(chi) - Delta(r) * (
        m * Bth(r) / r + k * B0
    ) * sp.sin(chi + alpha)
    assert sp.simplify(values['tangency'] - expected_tangency) == 0
    assert sp.simplify(
        values['BtS'] + values['BxS'] * sp.sin(th)
        - values['ByS'] * sp.cos(th)
    ) == 0

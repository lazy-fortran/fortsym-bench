"""Independent source-model check for the v99 flux derivative recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/two_component_energy_identity.py'
    )
    spec = importlib.util.spec_from_file_location(
        'two_component_energy_identity_v99', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_flux_t_slope_matches_independent_product_rule_at_two_points():
    values = _load().results()
    r = sp.Symbol('r')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')
    source_derivative = sp.diff(2 * sp.pi * r * bz(r), r)
    source_derivative = source_derivative.xreplace({
        sp.Derivative(bz(r), r): derivative1(sp.Symbol('bz'), 1, r),
    })

    for point in (
        {r: sp.Rational(3, 2), bz(r): 5,
         derivative1(sp.Symbol('bz'), 1, r): 7},
        {r: 4, bz(r): sp.Rational(1, 3),
         derivative1(sp.Symbol('bz'), 1, r): -2},
    ):
        observed = values['fluxTslope'].subs(point)
        expected = source_derivative.subs(point)
        assert sp.simplify(observed - expected) == 0

    # Preserve the source's distributed product-rule tree for the structural
    # oracle instead of regrouping it under a common 2 Pi factor.
    bz_prime = derivative1(sp.Symbol('bz'), 1, r)
    assert values['fluxTslope'] == sp.Add(
        sp.Mul(2, sp.pi, r, bz_prime, evaluate=False),
        sp.Mul(2, sp.pi, bz(r), evaluate=False),
        evaluate=False,
    )

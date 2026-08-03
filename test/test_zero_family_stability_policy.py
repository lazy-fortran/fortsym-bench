"""Independent checks for the zero-family response reduction."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/zero_family_stability_policy.py'
    )
    spec = importlib.util.spec_from_file_location(
        'zero_family_stability_policy', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_zero_harmonic_rules_preserve_source_response_reduction():
    values = _load().results()
    rule = sp.Function('Rule')
    expected_rules = sp.Tuple(
        rule(sp.Symbol('sqrtgXiRadial'), 0),
        rule(sp.Symbol('sqrtgEtaTheta'), sp.Symbol('gt') * sp.Symbol('eta')),
        rule(sp.Symbol('sqrtgEtaZeta'), sp.Symbol('gz') * sp.Symbol('eta')),
        rule(sp.Symbol('muTheta'), 0),
        rule(sp.Symbol('muZeta'), 0),
    )
    assert values['zeroHarmonicRules'] == expected_rules

    # Independently apply the five source substitutions to the general
    # divergence and derive the expected odd response from its two surviving
    # angular terms.
    g, ft, fp = sp.symbols('g ft fp', nonzero=True)
    sqrtg_xi_radial, sqrtg_eta_theta = sp.symbols(
        'sqrtgXiRadial sqrtgEtaTheta'
    )
    sqrtg_eta_zeta, mu_theta, mu_zeta = sp.symbols(
        'sqrtgEtaZeta muTheta muZeta'
    )
    gt, gz, eta = sp.symbols('gt gz eta')
    general = (
        sqrtg_xi_radial / g
        + (
            ft * sqrtg_eta_theta
            - fp * sqrtg_eta_zeta
            + fp * mu_theta
            + ft * mu_zeta
        ) / (g * (ft**2 + fp**2))
    )
    reduced = general.subs({
        sqrtg_xi_radial: 0,
        sqrtg_eta_theta: gt * eta,
        sqrtg_eta_zeta: gz * eta,
        mu_theta: 0,
        mu_zeta: 0,
    })
    expected = eta * (ft * gt - fp * gz) / (g * (ft**2 + fp**2))
    assert sp.simplify(reduced - expected) == 0

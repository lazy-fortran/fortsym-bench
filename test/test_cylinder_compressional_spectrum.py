"""Independent checks for the cylinder force-balance lowering."""

import importlib.util
from pathlib import Path

import sympy as sp


def test_force_balance_and_pressure_slope_follow_the_source_rule():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/cylinder_compressional_spectrum.py'
    )
    spec = importlib.util.spec_from_file_location('cylinder_spectrum', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    values = module.results()

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


def test_bounded_vector_products_contract_and_unbounded_products_stay_opaque():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/cylinder_compressional_spectrum.py'
    )
    spec = importlib.util.spec_from_file_location('cylinder_spectrum_dot', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    values = module.results()

    r, mu0 = sp.symbols('r mu0')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    expected_jdotb = mu0 * (
        -btheta(r) * sp.diff(bz(r), r) / mu0
        + (r * sp.diff(btheta(r), r) + btheta(r)) * bz(r) / (mu0 * r)
    )
    assert sp.simplify(values['jDotB'] - expected_jdotb) == 0

    dot = sp.Function('Dot')
    vector = sp.Tuple(sp.Symbol('xv'), sp.Symbol('xd'))
    expected = dot(dot(vector, sp.Symbol('schurPhysical')), vector)
    assert values['lagPhysicalRed'] == expected
    assert values['lagTP'] == expected


def test_source_check_summary_preserves_non_plotting_wolfram_counts():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/cylinder_compressional_spectrum.py'
    )
    spec = importlib.util.spec_from_file_location('cylinder_spectrum_summary', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)

    values = module.results()

    # Independent behavioral oracle: the source has 17 deterministic checks;
    # six pass and eleven fail under its exact Wolfram evaluation.
    assert (values['pass'], values['fail']) == (sp.Integer(6), sp.Integer(11))

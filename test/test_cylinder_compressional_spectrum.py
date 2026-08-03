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


def test_c_two_uses_the_source_current_contraction_at_numeric_profile_values():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/cylinder_compressional_spectrum.py'
    )
    spec = importlib.util.spec_from_file_location('cylinder_spectrum_ctwo', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    c_two = module.results()['cTwo']

    r, k, length, m, mu0, phi = sp.symbols('r k len m mu0 phi')
    btheta, bz, et, xr = sp.symbols('btheta bz et xr')
    btheta_prime, bz_prime = sp.symbols('btheta_prime bz_prime')
    expected_jdotb = -bz_prime * btheta / mu0 + bz * (
        btheta + r * btheta_prime
    ) / (mu0 * r)
    expected = -(
        2 * sp.pi * k * length * r * bz * et * sp.cos(phi)
        + 2 * sp.pi * length * m * btheta * et * sp.cos(phi)
        + 2 * sp.pi * length * mu0 * r * expected_jdotb * xr * sp.cos(phi)
        - (
            2 * sp.pi * length * r * btheta_prime * bz
            - length * btheta * (2 * sp.pi * r * bz_prime + 2 * sp.pi * bz)
        ) * xr * sp.cos(phi)
    ) / (2 * sp.pi * length * r * sp.sqrt(btheta**2 + bz**2))

    derivative1 = sp.Function('Derivative1')
    substitutions = {
        sp.Symbol('r'): sp.Rational(7, 5),
        sp.Symbol('k'): sp.Rational(-2, 3),
        sp.Symbol('len'): sp.Rational(11, 2),
        sp.Symbol('m'): 3,
        sp.Symbol('mu0'): sp.Rational(5, 7),
        sp.Symbol('phi'): sp.Rational(2, 5),
        sp.Function('btheta')(sp.Symbol('r')): sp.Rational(4, 5),
        sp.Function('bz')(sp.Symbol('r')): sp.Rational(9, 10),
        sp.Function('et')(sp.Symbol('r')): sp.Rational(3, 7),
        sp.Function('xr')(sp.Symbol('r')): sp.Rational(-2, 9),
        derivative1(sp.Symbol('btheta'), 1, sp.Symbol('r')): sp.Rational(1, 6),
        derivative1(sp.Symbol('bz'), 1, sp.Symbol('r')): sp.Rational(-1, 8),
    }
    expected_numeric = expected.subs({
        r: sp.Rational(7, 5), k: sp.Rational(-2, 3),
        length: sp.Rational(11, 2), m: 3, mu0: sp.Rational(5, 7),
        phi: sp.Rational(2, 5), btheta: sp.Rational(4, 5),
        bz: sp.Rational(9, 10), et: sp.Rational(3, 7), xr: sp.Rational(-2, 9),
        btheta_prime: sp.Rational(1, 6), bz_prime: sp.Rational(-1, 8),
    })
    assert sp.N(c_two.subs(substitutions) - expected_numeric, 30) == 0

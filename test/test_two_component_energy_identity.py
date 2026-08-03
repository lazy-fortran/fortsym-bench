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


def test_density_matches_the_direct_numeric_vector_contraction():
    values = _load().results()
    r = sp.Symbol('r')
    numeric = {
        r: 2,
        sp.Symbol('theta'): 0,
        sp.Symbol('z'): 0,
        sp.Symbol('m'): 1,
        sp.Symbol('k'): 3,
        sp.Symbol('len'): 4,
        sp.Symbol('mu0'): 2,
        sp.Function('btheta')(r): 3,
        sp.Function('bz')(r): 5,
        sp.Function('xr')(r): 7,
        sp.Function('eta')(r): 11,
        sp.Function('Derivative1')(sp.Symbol('xr'), 1, r): 13,
        sp.Derivative(sp.Function('btheta')(r), r): 17,
        sp.Derivative(sp.Function('bz')(r), r): 19,
        sp.Derivative(sp.Function('xr')(r), r): 13,
        sp.Function('Derivative1')(sp.Symbol('p'), 1, r): 23,
    }
    observed = sp.simplify(values['density'].subs(numeric))

    # Independent evaluation of the source definition at the same point:
    # q, current, and xi are the three vectors produced by the cylindrical
    # formulas, and div(xi) is evaluated from its radial/theta/z components.
    phase = 1
    bmag = sp.sqrt(3**2 + 5**2)
    xi = sp.Matrix([7, -sp.I * 11 * 5 / bmag, sp.I * 11 * 3 / bmag])
    current = sp.Matrix([
        0,
        -sp.Rational(19, 2),
        (17 + sp.Rational(3, 2)) / 2,
    ])
    q = sp.Matrix([
        sp.I * sp.Rational(3 * 2 * 5 * 7 + 1 * 3 * 7, 2),
        sp.Rational(3 * 3**2 * 11 + 3 * 5**2 * 11, 1) / bmag
        - 3 * 13 - 7 * 17,
        -sp.Rational((3**2 + 5**2) * 11, 2) / bmag
        - sp.Rational(2 * 5 * 13 + 2 * 7 * 19 + 5 * 7, 2),
    ])
    div = sp.Rational(7 + 2 * 13, 2) + 11 * (
        sp.Rational(1 * 5, 2) - 3 * 3
    ) / bmag
    gradp = sp.Matrix([23, 0, 0])
    expected = (
        (q.dot(sp.conjugate(q)) / 2)
        - sp.conjugate(xi).dot(current.cross(q))
        + xi.dot(gradp) * sp.conjugate(div)
    )
    assert sp.simplify(observed - expected) == 0


def test_physical_weighted_applies_source_phase_and_force_balance_numerically():
    values = _load().results()
    r = sp.Symbol('r')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')

    # These are the same local cylindrical fields as the source, evaluated
    # independently rather than by reusing values['physicalWeighted'].
    radius, length, mu0 = sp.Rational(2), sp.Rational(4), sp.Rational(2)
    btheta_value, bz_value = sp.Rational(3), sp.Rational(5)
    btheta_prime, bz_prime = sp.Rational(17), sp.Rational(19)
    xr_value, xr_prime, eta_value = sp.Rational(7), sp.Rational(13), sp.Rational(11)
    m, k = sp.Rational(1), sp.Rational(3)
    bmag = sp.sqrt(btheta_value**2 + bz_value**2)
    xi = sp.Matrix([
        xr_value,
        -sp.I * eta_value * bz_value / bmag,
        sp.I * eta_value * btheta_value / bmag,
    ])
    current = sp.Matrix([
        0,
        -bz_prime / mu0,
        (btheta_prime + btheta_value / radius) / mu0,
    ])
    q = sp.Matrix([
        sp.I * (k * radius * bz_value * xr_value + m * btheta_value * xr_value) / radius,
        k * eta_value * (btheta_value**2 + bz_value**2) / bmag
        - btheta_prime * xr_value - btheta_value * xr_prime,
        (-radius * bz_prime * xr_value - radius * bz_value * xr_prime
         - bz_value * xr_value
         - m * eta_value * (btheta_value**2 + bz_value**2) / bmag) / radius,
    ])
    divergence = (xr_value + radius * xr_prime) / radius + eta_value * (
        m * bz_value / radius - k * btheta_value
    ) / bmag
    pressure_slope = (
        -bz_prime * bz_value
        - btheta_value * (btheta_value + radius * btheta_prime) / radius
    ) / mu0
    expected_density = (
        q.dot(sp.conjugate(q)) / mu0
        - sp.conjugate(xi).dot(current.cross(q))
        + xi.dot(sp.Matrix([pressure_slope, 0, 0])) * sp.conjugate(divergence)
    )
    expected = 2 * sp.pi * length * radius * sp.re(expected_density)
    observed = values['physicalWeighted'].subs({r: radius})
    observed = observed.subs({
        sp.Symbol('len'): length,
        sp.Symbol('mu0'): mu0,
        sp.Symbol('m'): m,
        sp.Symbol('k'): k,
        btheta(radius): btheta_value,
        bz(radius): bz_value,
        sp.Function('eta')(radius): eta_value,
        derivative1(sp.Symbol('btheta'), 1, radius): btheta_prime,
        derivative1(sp.Symbol('bz'), 1, radius): bz_prime,
        sp.Function('xr')(radius): xr_value,
        derivative1(sp.Symbol('xr'), 1, radius): xr_prime,
        sp.Derivative(btheta(radius), r): btheta_prime,
        sp.Derivative(bz(radius), r): bz_prime,
        sp.Derivative(sp.Function('xr')(r), r).subs(r, radius): xr_prime,
        sp.Subs(sp.Derivative(btheta(r), r), r, radius): btheta_prime,
        sp.Subs(sp.Derivative(bz(r), r), r, radius): bz_prime,
    })
    assert sp.simplify(observed - expected) == 0


def test_pressure_slope_preserves_the_source_mu0_force_balance_assignment():
    values = _load().results()
    r = sp.Symbol('r')
    mu0 = sp.Symbol('mu0')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')

    # The Wolfram source computes mu0 Derivative[1][p][r] by substituting
    # forceBalance.  Check the resulting value independently at two points;
    # the assertion deliberately does not depend on the generated binding's
    # expression as its expected value.
    for point in (
        {r: 2, mu0: 3, btheta(r): 5, bz(r): 7,
         derivative1(sp.Symbol('btheta'), 1, r): 11,
         derivative1(sp.Symbol('bz'), 1, r): 13},
        {r: 4, mu0: 2, btheta(r): -3, bz(r): 6,
         derivative1(sp.Symbol('btheta'), 1, r): 17,
         derivative1(sp.Symbol('bz'), 1, r): -19},
    ):
        expected = -point[bz(r)] * point[
            derivative1(sp.Symbol('bz'), 1, r)
        ] - point[btheta(r)] * (
            point[btheta(r)] + point[r] * point[
                derivative1(sp.Symbol('btheta'), 1, r)
            ]
        ) / point[r]
        observed = values['pressureSlope'].subs(point)
        assert sp.simplify(observed - expected) == 0


def test_flux_t_slope_is_the_source_radial_derivative_at_two_points():
    values = _load().results()
    r = sp.Symbol('r')
    bz = sp.Function('bz')
    derivative1 = sp.Function('Derivative1')
    bz_prime = derivative1(sp.Symbol('bz'), 1, r)

    # Independent numerical evaluation of D[2 Pi r bz[r], r], retaining the
    # source's two contributions at each radius.
    for point in (
        {r: sp.Rational(3, 2), bz(r): 5, bz_prime: 7},
        {r: 4, bz(r): sp.Rational(1, 3), bz_prime: -2},
    ):
        expected = 2 * sp.pi * (point[bz(r)] + point[r] * point[bz_prime])
        observed = values['fluxTslope'].subs(point)
        assert sp.simplify(observed - expected) == 0

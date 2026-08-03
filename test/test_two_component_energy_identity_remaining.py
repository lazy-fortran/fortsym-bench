"""Independent checks for the remaining two-component energy binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/two_component_energy_identity.py'
    )
    spec = importlib.util.spec_from_file_location(
        'two_component_energy_identity_remaining', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def _independent_constant_bz_difference(parameters):
    """Evaluate both source quadratic reductions at a constant axial field."""
    radius, length, mu0, m, k, btheta, bz, btheta_prime, xr, xr_prime = (
        sp.Rational(value) for value in parameters
    )
    eta, phi = sp.symbols('eta phi', real=True)
    bmag = sp.sqrt(btheta**2 + bz**2)
    sqg = 2 * sp.pi * length * radius
    flux_t = 2 * sp.pi * radius * bz
    flux_p = length * btheta
    flux_t_slope = 2 * sp.pi * bz
    flux_p_slope = length * btheta_prime
    current_i = length * bz
    current_j = 2 * sp.pi * radius * btheta
    j_dot_b = bz * (btheta_prime + btheta / radius)

    xi_val = xr * sp.cos(phi)
    xi_s = xr_prime * sp.cos(phi)
    xi_theta = -2 * sp.pi * m * xr * sp.sin(phi)
    xi_zeta = -k * length * xr * sp.sin(phi)
    eta_theta = 2 * sp.pi * m * eta * sp.cos(phi)
    eta_zeta = k * length * eta * sp.cos(phi)
    bgrad_xi = (flux_p * xi_theta + flux_t * xi_zeta) / sqg
    bgrad_eta = (flux_p * eta_theta + flux_t * eta_zeta) / sqg
    c_one = bgrad_xi
    c_two = -(
        sqg * bgrad_eta
        - (flux_t * flux_p_slope - flux_t_slope * flux_p) * xi_val
        + j_dot_b * sqg * xi_val
    ) / (bmag * sqg)
    pressure_slope = -btheta * (btheta + radius * btheta_prime) / radius
    c_three = (
        current_j * eta_zeta
        - current_i * eta_theta
        - (flux_t * current_i + flux_p * current_j) * xi_s
        - (current_j * flux_p_slope + current_i * flux_t_slope) * xi_val
        - pressure_slope * sqg * xi_val
    ) / (bmag * sqg)
    drive_a = 2 * btheta * (btheta + radius * btheta_prime) / (
        mu0 * radius**2
    )
    kernel_density = (
        c_one**2 + c_two**2 + c_three**2 - mu0 * drive_a * xi_val**2
    )
    kernel_average = sp.integrate(
        kernel_density, (phi, 0, 2 * sp.pi)
    ) / (2 * sp.pi)
    kernel_weighted = sp.expand(kernel_average * sqg / mu0 * 2)

    # Direct physical-side construction from q = Curl[xi x B], current, and
    # the force-balance pressure slope, with bz' = 0 as in the source.
    xi = sp.Matrix([xr, -sp.I * eta * bz / bmag, sp.I * eta * btheta / bmag])
    current = sp.Matrix([0, 0, (btheta_prime + btheta / radius) / mu0])
    q_field = sp.Matrix([
        sp.I * (k * radius * bz * xr + m * btheta * xr) / radius,
        k * eta * bmag - btheta_prime * xr - btheta * xr_prime,
        (-radius * bz * xr_prime - bz * xr - m * eta * bmag) / radius,
    ])
    divergence = (
        (xr + radius * xr_prime) / radius
        + eta * (m * bz / radius - k * btheta) / bmag
    )
    pressure = pressure_slope / mu0
    density = (
        q_field.dot(sp.conjugate(q_field)) / mu0
        - sp.conjugate(xi).dot(current.cross(q_field))
        + xi.dot(sp.Matrix([pressure, 0, 0]))
        * sp.conjugate(divergence)
    )
    physical_weighted = sp.expand(
        2 * sp.pi * length * radius * sp.re(density)
    )

    def reduce_quadratic(expression):
        return sp.factor(
            expression.coeff(eta, 0)
            - expression.coeff(eta, 1) ** 2
            / (4 * expression.coeff(eta, 2))
        )

    return sp.simplify(
        reduce_quadratic(kernel_weighted)
        - reduce_quadratic(physical_weighted)
    )


def test_constant_bz_reduction_matches_independent_source_model():
    values = _load().results()

    # Independent source evaluation gives zero for two non-degenerate
    # profiles, including a negative helical wave number in the second case.
    profiles = (
        (2, 4, 3, 1, 2, 3, 5, 7, 11, 13),
        (3, 5, 2, 2, -1, 4, 7, -3, 5, 9),
    )
    for profile in profiles:
        assert _independent_constant_bz_difference(profile) == 0

    assert values['constantBz'] == sp.Integer(0)

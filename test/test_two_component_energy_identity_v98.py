"""Independent source-model check for the v98 qField recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/two_component_energy_identity.py'
    )
    spec = importlib.util.spec_from_file_location(
        'two_component_energy_identity_v98', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def _independent_cylindrical_q_field(point):
    """Evaluate Curl[Cross[xiPerp, B]] from the cylindrical component rules."""
    radius, theta, z, m, k = (
        point[name] for name in ('r', 'theta', 'z', 'm', 'k')
    )
    btheta, bz, eta, xr = (
        point[name] for name in ('btheta', 'bz', 'eta', 'xr')
    )
    btheta_prime, bz_prime, xr_prime = (
        point[name] for name in ('btheta_prime', 'bz_prime', 'xr_prime')
    )
    phase = sp.exp(sp.I * (m * theta + k * z))
    bmag = sp.sqrt(btheta**2 + bz**2)
    return sp.Matrix([
        sp.I * (k * radius * bz + m * btheta) * xr * phase / radius,
        (
            k * (btheta**2 + bz**2) * eta * phase / bmag
            - (btheta_prime * xr + xr_prime * btheta) * phase
        ),
        (
            -m * (btheta**2 + bz**2) * eta * phase / bmag
            + radius * (-bz_prime * xr - xr_prime * bz) * phase
            - bz * xr * phase
        ) / radius,
    ])


def test_qfield_matches_independent_cylindrical_curl_at_two_points():
    values = _load().results()
    r = sp.Symbol('r')
    theta = sp.Symbol('theta')
    z = sp.Symbol('z')
    m = sp.Symbol('m')
    k = sp.Symbol('k')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    eta = sp.Function('eta')
    xr = sp.Function('xr')

    for point in (
        {
            'r': sp.Rational(3, 2), 'theta': sp.Rational(1, 5),
            'z': sp.Rational(-2, 7), 'm': 2, 'k': -3,
            'btheta': 4, 'bz': 5, 'eta': 7, 'xr': 11,
            'btheta_prime': -13, 'bz_prime': 17, 'xr_prime': 19,
        },
        {
            'r': 4, 'theta': sp.Rational(-1, 3), 'z': sp.Rational(2, 5),
            'm': -1, 'k': 2, 'btheta': -3, 'bz': 6, 'eta': 5,
            'xr': -7, 'btheta_prime': 11, 'bz_prime': -13,
            'xr_prime': 17,
        },
    ):
        substitutions = {
            r: point['r'], theta: point['theta'], z: point['z'],
            m: point['m'], k: point['k'],
            btheta(r): point['btheta'], bz(r): point['bz'],
            eta(r): point['eta'], xr(r): point['xr'],
            sp.Derivative(btheta(r), r): point['btheta_prime'],
            sp.Derivative(bz(r), r): point['bz_prime'],
            sp.Derivative(xr(r), r): point['xr_prime'],
        }
        observed = sp.Matrix(values['qField']).subs(substitutions)
        expected = _independent_cylindrical_q_field(point)
        assert all(sp.simplify(a - b) == 0 for a, b in zip(observed, expected))

    # The source-preserving radial product is the recovered structural detail;
    # it must remain nested instead of being distributed by differentiation.
    numerator = values['qField'][2].args[1]
    assert any(
        isinstance(term, sp.Mul)
        and r in term.free_symbols
        and any(isinstance(arg, sp.Add) for arg in term.args)
        for term in numerator.args
    )

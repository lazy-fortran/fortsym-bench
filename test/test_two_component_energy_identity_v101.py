"""Independent source-model check for the v101 ``jDotB`` recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/two_component_energy_identity.py'
    )
    spec = importlib.util.spec_from_file_location(
        'two_component_energy_identity_v101', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def _independent_current_dot_field(*, radius, mu0, btheta, bz, btheta_prime,
                                   bz_prime):
    """Compute mu0 J.B from the cylindrical curl component directly."""
    # For B = (0, btheta(r), bz(r)), cylindrical Curl[B] has only the
    # axial component btheta'(r) + btheta(r)/r and the toroidal component
    # -bz'(r).  Dotting with B and retaining the source's current scaling
    # gives this independently constructed scalar.
    current = sp.Matrix([
        0,
        -bz_prime / mu0,
        (btheta_prime + btheta / radius) / mu0,
    ])
    field = sp.Matrix([0, btheta, bz])
    return sp.simplify(mu0 * current.dot(field))


def test_jdotb_matches_independent_cylindrical_current_oracle():
    values = _load().results()
    radius, mu0 = sp.Rational(7, 3), sp.Rational(5, 2)
    btheta, bz = sp.Rational(-11, 4), sp.Rational(13, 5)
    btheta_prime, bz_prime = sp.Rational(17, 6), sp.Rational(-19, 7)

    r = sp.Symbol('r')
    substitutions = {
        r: radius,
        sp.Symbol('mu0'): mu0,
        sp.Function('btheta')(r): btheta,
        sp.Function('bz')(r): bz,
        sp.Function('Derivative1')(sp.Symbol('btheta'), 1, r): btheta_prime,
        sp.Function('Derivative1')(sp.Symbol('bz'), 1, r): bz_prime,
    }
    observed = values['jDotB'].subs(substitutions)
    expected = _independent_current_dot_field(
        radius=radius,
        mu0=mu0,
        btheta=btheta,
        bz=bz,
        btheta_prime=btheta_prime,
        bz_prime=bz_prime,
    )
    assert sp.simplify(observed - expected) == 0

    # Keep the source-level mu0 wrapper that the native oracle compares.
    assert values['jDotB'].args[0] == sp.Symbol('mu0')

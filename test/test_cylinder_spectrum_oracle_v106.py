"""Independent v106 oracle for the cylinder pointwise energy density."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load_module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/cylinder_compressional_spectrum.py'
    )
    spec = importlib.util.spec_from_file_location('cylinder_spectrum_v106', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_w_density_matches_an_independent_cylindrical_contraction():
    module = _load_module()
    actual = module.results()['wDensity']

    r, theta, z, k, m, mu0, gam = sp.symbols(
        'r theta z k m mu0 gam'
    )
    p, btheta, bz, xr, xt, xz = sp.symbols(
        'p btheta bz xr xt xz'
    )
    p_prime, btheta_prime, bz_prime, xr_prime = sp.symbols(
        'p_prime btheta_prime bz_prime xr_prime'
    )
    phase = k * z + m * theta
    sine, cosine = sp.sin(phase), sp.cos(phase)

    # Independent cylindrical identities for the source's background field,
    # perturbation, Curl and Div.  The implementation's generated expression
    # is only evaluated after its opaque helper heads are replaced by these
    # independently derived values.
    xi = sp.Tuple(xr * cosine, -xt * sine, -xz * sine)
    current = sp.Tuple(
        0,
        -bz_prime / mu0,
        (btheta + r * btheta_prime) / (mu0 * r),
    )
    q_field = sp.Tuple(
        -(k * r * bz * xr * sine + m * btheta * xr * sine) / r,
        (
            k * btheta * xz * cosine
            - k * bz * xt * cosine
            - (btheta_prime * xr + xr_prime * btheta) * cosine
        ),
        (
            r * (-bz_prime * xr * cosine - xr_prime * bz * cosine)
            - bz * xr * cosine
            - (m * btheta * xz * cosine - m * bz * xt * cosine)
        ) / r,
    )
    divergence = (
        xr_prime + xr / r - m * xt / r - k * xz
    ) * cosine
    cross_current_q = sp.Matrix(current).cross(sp.Matrix(q_field))
    expected = (
        sum(component**2 for component in q_field) / mu0
        - sum(left * right for left, right in zip(xi, cross_current_q))
        + gam * p * divergence**2
        + xr * cosine * p_prime * divergence
    )

    replacements = {}
    profile_values = {
        'p': p,
        'btheta': btheta,
        'bz': bz,
        'xr': xr,
        'xt': xt,
        'xz': xz,
    }
    derivative_values = {
        'p': p_prime,
        'btheta': btheta_prime,
        'bz': bz_prime,
        'xr': xr_prime,
    }
    for node in actual.atoms(sp.Function):
        name = node.func.__name__
        if name == 'Div':
            replacements[node] = divergence
        elif name == 'Derivative1' and node.args[1:] == (sp.Integer(1), r):
            replacements[node] = derivative_values[str(node.args[0])]
        elif name in profile_values and node.args == (r,):
            replacements[node] = profile_values[name]
    for node in actual.atoms(sp.Derivative):
        if node.variables == (r,):
            replacements[node] = derivative_values[node.expr.func.__name__]

    actual = actual.xreplace(replacements)
    samples = (
        {
            r: sp.Rational(7, 5),
            theta: sp.Rational(2, 7),
            z: sp.Rational(-3, 11),
            k: sp.Rational(5, 4),
            m: 3,
            mu0: sp.Rational(7, 10),
            gam: sp.Rational(5, 3),
            p: sp.Rational(11, 6),
            btheta: sp.Rational(4, 5),
            bz: sp.Rational(9, 10),
            xr: sp.Rational(-2, 9),
            xt: sp.Rational(3, 8),
            xz: sp.Rational(-5, 7),
            p_prime: sp.Rational(2, 13),
            btheta_prime: sp.Rational(1, 6),
            bz_prime: sp.Rational(-1, 8),
            xr_prime: sp.Rational(5, 12),
        },
        {
            r: sp.Rational(9, 4),
            theta: sp.Rational(-1, 6),
            z: sp.Rational(5, 13),
            k: sp.Rational(-3, 5),
            m: 2,
            mu0: sp.Rational(11, 9),
            gam: sp.Rational(7, 5),
            p: sp.Rational(13, 8),
            btheta: sp.Rational(-2, 7),
            bz: sp.Rational(5, 6),
            xr: sp.Rational(3, 10),
            xt: sp.Rational(-4, 9),
            xz: sp.Rational(7, 11),
            p_prime: sp.Rational(-3, 14),
            btheta_prime: sp.Rational(5, 17),
            bz_prime: sp.Rational(2, 15),
            xr_prime: sp.Rational(-1, 13),
        },
    )
    for sample in samples:
        difference = sp.trigsimp(
            actual.subs(sample) - expected.subs(sample)
        )
        assert sp.simplify(difference) == 0

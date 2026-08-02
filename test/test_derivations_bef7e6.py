"""Independent check for the recovered Bz integral."""

import importlib.util
from pathlib import Path

import mpmath
import sympy as sp


def test_bz_matches_independent_azimuthal_quadrature():
    path = (
        Path(__file__).parents[1]
        / 'corpus/nc-stud-Bacc_Rosa_Posch/derivations_bef7e6.py'
    )
    spec = importlib.util.spec_from_file_location('derivations_bef7e6', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    value = module.results()['Bz']

    n0, mu0, Ic, R, z = 1.7, 0.9, 2.3, 1.2, 0.4
    expected = mpmath.quad(
        lambda phi: n0 * mu0 * Ic / (4 * mpmath.pi)
        * R**2 / (R**2 + z**2) ** mpmath.mpf('1.5'),
        [0, 2 * mpmath.pi],
    )
    actual = float(
        value.subs({
            sp.Symbol('n0'): n0,
            sp.Symbol('mu0'): mu0,
            sp.Symbol('Ic'): Ic,
            sp.Symbol('R'): R,
            sp.Symbol('z'): z,
        })
    )
    assert mpmath.almosteq(actual, expected, rel_eps=mpmath.mpf('1e-12'))

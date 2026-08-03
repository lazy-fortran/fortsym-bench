"""Independent v107 regression for the cylinder Alfven point."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load_module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/cylinder_compressional_spectrum.py'
    )
    spec = importlib.util.spec_from_file_location('cylinder_spectrum_v107', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_alfven_point_matches_the_independent_source_fixture_formula():
    values = _load_module().results()

    # Rebuild the pinned fixture independently from the Wolfram source:
    # b0F=1, rho0F=2, mu0F=4 Pi 10^-7, lenF=6 Pi, and modeN=1.
    b0 = sp.Integer(1)
    rho0 = sp.Integer(2)
    mu0 = 4 * sp.pi * sp.Integer(10) ** -7
    wave_number = -2 * sp.pi / (6 * sp.pi)
    expected = sp.N(wave_number**2 * b0**2 / (mu0 * rho0), 40)

    assert values['mu0F'] == sp.pi / 2_500_000
    assert abs(values['alfvenPoint'] - expected) < sp.Rational(1, 10**30)

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/generalized_profile_certificate.py'
    )
    spec = importlib.util.spec_from_file_location(
        'generalized_profile_certificate', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_source_residual_bindings_are_preserved_independently():
    values = _load().results()
    lam = sp.Symbol('lambda')
    u11, u12, u22 = sp.symbols('u11 u12 u22')
    a11, a12, a22 = sp.symbols('a11 a12 a22')
    y1, y2 = sp.symbols('y1 y2')
    expected_general = sp.Tuple(
        a11 * y1 + a12 * y2 - lam * (u11**2 * y1 + u11 * u12 * y2),
        a12 * y1 + a22 * y2
        - lam * (u11 * u12 * y1 + (u12**2 + u22**2) * y2),
    )
    assert values['rGeneral'] == expected_general
    assert values['rStandard'] == sp.Tuple(
        expected_general[0] / u11,
        -u12 * expected_general[0] / (u11 * u22)
        + expected_general[1] / u22,
    )

    lambda1, lambda2, theta, rayleigh = sp.symbols(
        'lambda1 lambda2 theta rayleigh'
    )
    assert values['residualNorm'] == sp.sqrt(
        (lambda1 * sp.cos(theta) - rayleigh * sp.cos(theta)) ** 2
        + (lambda2 * sp.sin(theta) - rayleigh * sp.sin(theta)) ** 2
    )
    assert values['unwantedSeparation'] == lambda2 - rayleigh

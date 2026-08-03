"""Independent behavioral check for the recovered damped-response coefficient."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/gh-krystophny-andreas-ntv/build_notebooks.py'
    )
    spec = importlib.util.spec_from_file_location('build_notebooks_gh_v105', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_b_coef_matches_the_independent_damped_response_formula():
    value = _module().results()['bCoef']
    j = sp.Symbol('j')
    m, nu = sp.symbols('m nu')
    h = sp.Function('h')(j)
    derivative = sp.Function('Derivative1')(sp.Symbol('f0'), 1, j)
    capital_omega = sp.Function('capitalOmega')(j)
    omega = sp.Symbol('omega')
    detuning = m * capital_omega - omega

    expected = m * h * derivative * nu / (detuning**2 + nu**2)

    assert sp.simplify(value - expected) == 0

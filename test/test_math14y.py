"""Independent behavioral checks for the recovered math14y final cells."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math14y.py'
    spec = importlib.util.spec_from_file_location('math14y', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_final_curl_identity_uses_the_preceding_gradient_binding():
    values = _module().results()
    r, phi, z, k = sp.symbols('r φ z k')
    psi = sp.Function('ψ')(r, phi, z)
    grad = sp.Function('Grad')
    div = sp.Function('Div')
    expected_l = grad(psi)
    expected_c = grad(div(expected_l)) + k**2 * expected_l

    assert values['l'] == expected_l
    assert values['c'] == expected_c


def test_independent_symbol_derivatives_and_late_curve_assignment():
    values = _module().results()
    a, t = sp.symbols('a t')

    assert values['kreis'] == sp.Tuple(a, t, 0)
    assert values['drsps'] == values['dpsps'] == values['dzsps'] == 0
    assert values['ddsps'] == sp.Function('Union')(0, 0, 0, 0, 0, 0, sp.Symbol('dsps'))

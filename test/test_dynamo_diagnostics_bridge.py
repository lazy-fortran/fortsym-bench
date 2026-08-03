from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/40_dynamo_diagnostics_bridge.py'
    )
    spec = importlib.util.spec_from_file_location('dynamo_bridge', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_mhd_ledger_exposes_all_source_equations():
    values = _module().results()
    expected = {
        'M3D-A1', 'M3D-A2', 'M3D-A3', 'M3D-A4', 'M3D-A5', 'M3D-A6',
        'M3D-A7', 'JOREK-1', 'JOREK-2', 'JOREK-3', 'JOREK-4i', 'JOREK-4e',
    }
    assert expected <= values.keys()

    # Check governing equations independently of the generated ledger text.
    for name in expected:
        held = values[name]
        assert held.func == sp.Function('HoldComplete')
        equation = held.args[0]
        assert equation.func == sp.Equality
        assert equation.lhs != equation.rhs
    assert values['M3D-A5'].args[0].lhs == sp.Symbol('mag')
    assert values['M3D-A6'].args[0].lhs == sp.Symbol('elec')
    assert values['JOREK-1'].args[0].lhs == sp.Function('dtOp')(sp.Symbol('vecPot'))


def test_helicity_diagnostics_match_independent_numeric_averages():
    values = _module().results()
    r = sp.Symbol('r')
    br, bri, bt, bti, bz, bzi = sp.symbols('br bri bt bti bz bzi')
    vr, vri, vt, vti, vz, vzi = sp.symbols('vr vri vt vti vz vzi')
    substitutions = {
        sp.Symbol('B0'): 3,
        sp.Function('Bth')(r): 4,
        r: 1,
        **dict(zip((br, bri, bt, bti, bz, bzi), (2, -1, 1, 3, -2, 1))),
        **dict(zip((vr, vri, vt, vti, vz, vzi), (1, 2, -2, 1, 3, -1))),
    }
    actual = sp.N(values['epsPar'].subs(substitutions))

    chi = sp.symbols('chi', real=True)
    harmonic = lambda real, imag: real * sp.cos(chi) - imag * sp.sin(chi)
    v = sp.Matrix([
        harmonic(1, 2), harmonic(-2, 1), harmonic(3, -1),
    ])
    b = sp.Matrix([
        harmonic(2, -1), 4 + harmonic(1, 3), 3 + harmonic(-2, 1),
    ])
    b0v = sp.Matrix([0, 4, 3])
    direct = sp.integrate(b0v.dot(v.cross(b)), (chi, 0, 2 * sp.pi))
    direct /= 2 * sp.pi * sp.sqrt(b0v.dot(b0v))
    assert sp.N(actual - direct) == 0

    tor_actual = sp.N(values['torCorr'].subs(substitutions))
    tor_direct = sp.integrate(v.cross(b)[1], (chi, 0, 2 * sp.pi)) / (2 * sp.pi)
    assert sp.N(tor_actual - tor_direct) == 0


def test_source_vector_projection_and_stationary_ohm_average_are_identities():
    values = _module().results()
    assert values['jardinProjection'] == 0

    chi = sp.symbols('chi', real=True)
    harmonic = lambda real, imag: real * sp.cos(chi) - imag * sp.sin(chi)
    v = sp.Matrix([1 + harmonic(2, -1), 2 + harmonic(-1, 3), -1 + harmonic(3, 2)])
    b = sp.Matrix([harmonic(1, 2), 4 + harmonic(-2, 1), 5 + harmonic(2, -3)])
    current = sp.Matrix([harmonic(2, 1), 3 + harmonic(1, -2), -2 + harmonic(-1, 1)])
    eta = 7 + 2 * sp.cos(chi)
    left = sp.integrate(b.dot(eta * current - v.cross(b)), (chi, 0, 2 * sp.pi))
    right = sp.integrate(eta * b.dot(current), (chi, 0, 2 * sp.pi))
    assert sp.simplify(left - right) == 0

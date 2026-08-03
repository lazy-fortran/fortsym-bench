"""Independent checks for the recovered Bacc derivation bindings."""

import cmath
import importlib.util
import math
from pathlib import Path

import mpmath
import sympy as sp


def _results():
    path = (
        Path(__file__).parents[1]
        / 'corpus/nc-stud-Bacc_Rosa_Posch/derivations_bef7e6.py'
    )
    spec = importlib.util.spec_from_file_location('derivations_bef7e6', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def test_bz_matches_independent_azimuthal_quadrature():
    value = _results()['Bz']

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


def test_qfac_matches_independent_resonance_bandwidth_ratio():
    values = _results()
    inductance, capacitance, resistance = 0.45, 3.2e-6, 2.7

    resonant_frequency = 1.0 / math.sqrt(inductance * capacitance)
    bandwidth = resistance / inductance
    expected = resonant_frequency / bandwidth
    actual = float(values['Qfac'].subs({
        'L': inductance,
        'C': capacitance,
        'R': resistance,
    }))

    assert math.isclose(actual, expected, rel_tol=1e-13)


def test_pabs_matches_independent_complex_drude_power_density():
    values = _results()
    density, charge, mass = 2.5e17, 1.602e-19, 9.109e-31
    collision_rate, angular_frequency, field = 3.2e7, 8.5e7, 240.0

    conductivity = density * charge**2 / (
        mass * (collision_rate - 1j * angular_frequency)
    )
    expected = 0.5 * conductivity.real * field**2
    actual = float(values['pabs'].subs({
        'ne': density,
        'e': charge,
        'me': mass,
        'nu': collision_rate,
        'w': angular_frequency,
        'Emag': field,
    }))

    assert math.isclose(actual, expected, rel_tol=1e-13)


def test_paschen_derivative_and_minimum_match_independent_numeric_curve():
    values = _results()
    ap, bp, gamma = 12.0, 180.0, 0.05

    def paschen_voltage(u):
        return bp * u / (
            math.log(ap * u) - math.log(math.log1p(1.0 / gamma))
        )

    point, step = 0.8, 1.0e-6
    expected_derivative = (
        paschen_voltage(point + step) - paschen_voltage(point - step)
    ) / (2.0 * step)
    actual_derivative = float(values['dVb'].subs({
        'Ap': ap,
        'Bp': bp,
        'gse': gamma,
        'u': point,
    }))
    assert math.isclose(actual_derivative, expected_derivative, rel_tol=1e-8)

    minimum = math.e * math.log1p(1.0 / gamma) / ap
    expected_voltage = paschen_voltage(minimum)
    actual_minimum = float(values['uMin'].subs({
        'Ap': ap,
        'gse': gamma,
    }))
    actual_voltage = float(values['VbMin'].subs({
        'Ap': ap,
        'Bp': bp,
        'gse': gamma,
    }))
    assert math.isclose(actual_minimum, minimum, rel_tol=1e-13)
    assert math.isclose(actual_voltage, expected_voltage, rel_tol=1e-13)


def test_eta_matches_independent_complex_transformer_impedance():
    values = _results()
    angular_frequency = 2.7
    l11, mutual_inductance, resistance = 0.031, 0.012, 1.8
    l22, coil_resistance = 0.025, 0.7

    impedance = 1j * angular_frequency * l11 + (
        angular_frequency**2 * mutual_inductance**2
        / (resistance + 1j * angular_frequency * l22)
    )
    expected = impedance.real / (impedance.real + coil_resistance)
    actual = float(values['eta'].subs({
        'w': angular_frequency,
        'L11': l11,
        'M': mutual_inductance,
        'R2': resistance,
        'L22': l22,
        'Rcoil': coil_resistance,
    }))

    assert cmath.isclose(actual, expected, rel_tol=1e-13, abs_tol=0.0)
    assert 0.0 < actual < 1.0

"""Independent checks for the hand-lowered Appendix-B integrals."""

import importlib.util
from pathlib import Path

import mpmath as mp
import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-flux_pumping/06_ext_appendixB.py"
    spec = importlib.util.spec_from_file_location("appendix_b", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_gaussian_and_maxwellian_reductions_are_independent_identities():
    values = _module().results()
    k, x = sp.symbols("k x")
    point = {k: sp.Rational(7, 10), x: sp.Rational(2, 5)}
    got_forward = complex(values["gaussianForward"].subs(point).evalf(30))
    got_inverse = complex(values["gaussianInverse"].subs(point).evalf(30))
    mp.mp.dps = 30
    expected_forward = mp.quad(
        lambda q: mp.e ** (-1j * mp.mpf("0.7") * q - q * q), [-10, 10]
    )
    expected_inverse = mp.e ** (-mp.mpf("0.4") ** 2)
    assert abs(got_forward - complex(expected_forward)) < 1e-12
    assert abs(got_inverse - complex(expected_inverse)) < 1e-12

    me, Te, ne, vpar = sp.symbols("me Te ne vpar")
    point = {me: 2, Te: 3, ne: sp.Rational(7, 10), vpar: sp.Rational(2, 5)}
    got_red = float(values["red"].subs(point).evalf(30))
    perpendicular = mp.quad(
        lambda q: mp.e ** (-2 * q * q / 6), [-8, 8]
    )
    expected_red = mp.mpf("0.7") * (mp.mpf(2) / (6 * mp.pi)) ** 1.5
    expected_red *= perpendicular**2 * mp.e ** (-2 * mp.mpf("0.4") ** 2 / 6)
    assert abs(got_red - float(expected_red)) < 1e-10


def test_appendix_b_velocity_moments_and_cubic_integral():
    values = _module().results()
    vT, tau, kp, dr = sp.symbols("vT tau kp dr")
    point = {vT: 1.3, tau: 0.8, kp: 0.9, dr: 0.6}
    got_velocity = float(values["vint1"].subs(point).evalf(30))
    expected_velocity = mp.quad(
        lambda q: q * mp.e ** (-q * q / (2 * mp.mpf("1.3") ** 2))
        * mp.sin(mp.mpf("0.8") * q * mp.mpf("0.9") * mp.mpf("0.6")),
        [-10, 10],
    )
    assert abs(got_velocity - float(expected_velocity)) < 1e-10
    gamma_head = sp.Function("Gamma")
    uint = values["uint"].xreplace({
        gamma_head(sp.Rational(7, 6)): sp.gamma(sp.Rational(7, 6))
    })
    tint = values["tint"].xreplace({
        gamma_head(sp.Rational(4, 3)): sp.gamma(sp.Rational(4, 3))
    })
    expected_uint = mp.quad(lambda q: q ** (mp.mpf(4) / 3) * mp.e ** (-q * q), [0, 8])
    expected_tint = mp.quad(lambda q: mp.e ** (-q**3), [0, 8])
    assert abs(float(uint.evalf(30)) - float(expected_uint)) < 1e-12
    assert abs(float(tint.evalf(30)) - float(expected_tint)) < 1e-12

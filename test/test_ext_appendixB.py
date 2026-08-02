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


def test_cderived_preserves_source_intermediate_contract():
    value = _module().results()['cDerived']
    uint, tint = sp.symbols('uint tint')
    expected = 4 * sp.sqrt(2 / sp.pi) * (3 * sp.sqrt(2)) ** sp.Rational(1, 3) * uint * tint
    assert sp.simplify(value - expected) == 0
    substitutions = {uint: sp.gamma(sp.Rational(7, 6)) / 2, tint: sp.gamma(sp.Rational(4, 3))}
    assert abs(float(value.subs(substitutions).evalf(30)) - 2.1401304355) < 1e-10


def test_appendix_b_electric_bindings_preserve_source_intermediates():
    values = _module().results()
    gamma = sp.Function("Gamma")
    tint, mean_abs_v, mean_abs_v13 = sp.symbols(
        "tint meanAbsV meanAbsV13"
    )
    kp, nu, w_e, da = sp.symbols("kp nu wE DA")

    assert values["uintRequiredByMemo"] == (
        2 * gamma(sp.Rational(1, 3)) ** 2 / (27 * tint)
    )
    assert values["ieNoan"] == (
        sp.pi * sp.I * mean_abs_v * w_e / (kp * (nu + sp.I * w_e))
    )
    assert values["ieAnom"] == (
        3 ** sp.Rational(1, 3) * sp.I * sp.pi * mean_abs_v13 * w_e
        * (kp / da) ** sp.Rational(1, 3)
        * gamma(sp.Rational(4, 3)) / kp ** 2
    )

    # Independently evaluate the two Maxwellian moments appearing in the
    # source formulae, then check the recovered expressions numerically.
    mp.mp.dps = 30
    point = {
        tint: mp.gamma(mp.mpf(4) / 3),
        mean_abs_v: mp.sqrt(2 / mp.pi) * mp.mpf("1.2"),
        mean_abs_v13: (
            2 ** (mp.mpf(1) / 6) * mp.gamma(mp.mpf(2) / 3)
            * mp.mpf("1.2") ** (mp.mpf(1) / 3) / mp.sqrt(mp.pi)
        ),
        kp: mp.mpf("0.8"),
        nu: mp.mpf("0.3"),
        w_e: mp.mpf("0.7"),
        da: mp.mpf("1.1"),
    }
    assert abs(
        complex(values["ieNoan"].subs(point).evalf(30))
        - complex(
            mp.pi * 1j * point[mean_abs_v] * point[w_e]
            / (point[kp] * (point[nu] + 1j * point[w_e]))
        )
    ) < 1e-12
    assert abs(
        complex(
            values["ieAnom"]
            .subs(point)
            .xreplace({gamma(sp.Rational(4, 3)): sp.gamma(sp.Rational(4, 3))})
            .evalf(30)
        )
        - complex(
            3 ** (mp.mpf(1) / 3) * 1j * mp.pi * point[mean_abs_v13]
            * point[w_e] * (point[kp] / point[da]) ** (mp.mpf(1) / 3)
            * mp.gamma(mp.mpf(4) / 3) / point[kp] ** 2
        )
    ) < 1e-12

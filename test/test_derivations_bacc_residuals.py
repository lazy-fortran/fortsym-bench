"""Independent behavioral oracles for the recovered Bacc residual bindings."""

import cmath
import importlib.util
import math
from pathlib import Path

import mpmath
import sympy as sp


def _results():
    path = Path(__file__).parents[1] / "corpus/nc-stud-Bacc_Rosa_Posch/derivations.py"
    spec = importlib.util.spec_from_file_location("bacc_derivations_residuals", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def _besselj(expression):
    return expression.replace(
        lambda node: node.func.__name__ == "BesselJ",
        lambda node: sp.besselj(*node.args),
    )


def test_recovered_residual_bindings_have_independent_behavioral_values():
    values = _results()

    s = 3.0
    assert math.isclose(
        float(values["delFraction"].subs({"s": s})),
        4.0 * s / (s + 1.0) ** 2,
        rel_tol=1e-13,
    )
    assert math.isclose(
        float(values["sensitivity"].subs({"s": s})),
        -4.0 * (s - 1.0) / (s + 1.0) ** 3,
        rel_tol=1e-13,
    )

    omega, mu0, turns, length = 2.3, 4.0e-7 * math.pi, 5.0, 0.17
    radius, k, ba = 0.08, 1.4 + 0.6j, 2.1
    j0 = mpmath.besselj(0, k * radius)
    j1 = mpmath.besselj(1, k * radius)
    flux = 2.0 * math.pi * radius * ba * j1 / (k * j0)
    substitutions = {
        "Omega": omega,
        "Mu0": mu0,
        "nn": turns,
        "lc": length,
        "a": radius,
        "kk": k,
        "Ba": ba,
        "Rc": 0.12,
    }
    actual_flux = complex(_besselj(values["fluxPlasma"]).subs(substitutions).evalf(16))
    assert cmath.isclose(actual_flux, complex(flux), rel_tol=1e-13, abs_tol=1e-15)

    expected_zpl = 1j * omega * mu0 * turns**2 / length * (
        2.0 * math.pi * radius * j1 / (k * j0) - math.pi * radius**2
    )
    for name, expected in (
        ("zTotal", expected_zpl + 1j * omega * mu0 * turns**2 * math.pi * 0.12**2 / length),
        ("zPl", expected_zpl),
    ):
        actual = complex(_besselj(values[name]).subs(substitutions).evalf(16))
        assert cmath.isclose(actual, complex(expected), rel_tol=1e-13, abs_tol=1e-15)

    sigma = 3.2e5
    expected_uniform = math.pi * omega**2 * mu0**2 * sigma * turns**2 * radius**4 / (8.0 * length)
    for name in ("zPlSeries", "rplUniform"):
        actual = float(values[name].subs({**substitutions, "Sigma": sigma}))
        assert math.isclose(actual, expected_uniform, rel_tol=1e-13)

    aa, bb = 0.8, 3.5
    assert math.isclose(
        float(values["iOp"].subs({"aa": aa, "bb": bb})),
        math.sqrt(2.0 * bb / aa),
        rel_tol=1e-13,
    )
    ap, bp, gamma = 12.0, 180.0, 0.05
    expected_vmin = math.e * bp / ap * math.log1p(1.0 / gamma)
    assert math.isclose(
        float(values["vbMin"].subs({"AP": ap, "BP": bp, "Gammase": gamma})),
        expected_vmin,
        rel_tol=1e-13,
    )

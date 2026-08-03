"""Independent regression for the simplified Bacc plasma impedance."""

import cmath
import importlib.util
import math
from pathlib import Path

import mpmath
import sympy as sp


def _results():
    path = Path(__file__).parents[1] / "corpus/nc-stud-Bacc_Rosa_Posch/derivations.py"
    spec = importlib.util.spec_from_file_location("bacc_derivations_v102", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def test_plasma_impedance_matches_independent_bessel_formula():
    values = _results()
    omega, mu0, turns, length = 2.3, 4.0e-7 * math.pi, 5.0, 0.17
    radius, k = 0.08, 1.4 + 0.6j

    j0 = mpmath.besselj(0, k * radius)
    j1 = mpmath.besselj(1, k * radius)
    expected = 1j * omega * mu0 * turns**2 / length * (
        2 * math.pi * radius * j1 / (k * j0) - math.pi * radius**2
    )

    impedance = values["zPl"].replace(
        lambda node: node.func.__name__ == "BesselJ",
        lambda node: sp.besselj(*node.args),
    )
    actual = complex(impedance.subs({
        "Omega": omega,
        "Mu0": mu0,
        "nn": turns,
        "lc": length,
        "a": radius,
        "kk": k,
    }).evalf(16))

    assert cmath.isclose(actual, complex(expected), rel_tol=1e-13, abs_tol=1e-15)

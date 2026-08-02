"""Independent checks for the hand-lowered Bacc/Rosa/Posch translation."""

import importlib.util
import math
import unittest
from pathlib import Path

import mpmath
import sympy as sp


def _results():
    path = Path(__file__).parents[1] / "corpus/nc-stud-Bacc_Rosa_Posch/derivations.py"
    spec = importlib.util.spec_from_file_location("bacc_derivations", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


class BaccDerivationTest(unittest.TestCase):
    def test_flux_and_pascal_formulas(self):
        results = _results()
        a, k, ba = 0.7, 1.3, 2.1
        expected_flux = 2 * math.pi * ba * a * float(
            mpmath.besselj(1, k * a)
        ) / (k * float(mpmath.besselj(0, k * a)))
        flux = results["fluxPlasma"].replace(
            lambda node: node.func.__name__ == "BesselJ",
            lambda node: sp.besselj(*node.args),
        )
        actual_flux = float(
            flux.subs(
                {sp.Symbol("a"): a, sp.Symbol("kk"): k, sp.Symbol("Ba"): ba}
            ).evalf()
        )
        self.assertTrue(math.isclose(actual_flux, expected_flux, rel_tol=1e-12))

        pd, ap, bp, gamma = 4.0, 12.0, 180.0, 0.05
        expected_vb = bp * pd / (
            math.log(ap * pd) - math.log(math.log(1 + 1 / gamma))
        )
        actual_vb = float(
            results["vb"].subs(
                {
                    sp.Symbol("pd"): pd,
                    sp.Symbol("AP"): ap,
                    sp.Symbol("BP"): bp,
                    sp.Symbol("Gammase"): gamma,
                }
            )
        )
        self.assertTrue(math.isclose(actual_vb, expected_vb, rel_tol=1e-12))

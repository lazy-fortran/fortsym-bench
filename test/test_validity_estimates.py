import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = Path(__file__).parents[1] / "corpus/proj-flux_pumping/04_validity_estimates.py"
_SPEC = importlib.util.spec_from_file_location("validity_estimates", _SOURCE)
validity = importlib.util.module_from_spec(_SPEC)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(validity)


def test_validity_estimates_follow_the_independent_numeric_chain():
    values = validity.results()
    clight = sp.Float("2.99792458e10", 80)
    charge = sp.Float("4.80320425e-10", 80)
    mass = sp.Float("3.34358377e-24", 80)
    energy = 5 * sp.Float("1.602176634e-12", 80) * 10**3
    b0 = sp.Integer(2) * 10**4
    rmaj, rmin = sp.Float(170, 80), sp.Float(10, 80)
    drift_speed = sp.sqrt(2 * energy / mass)
    gyroradius = mass * drift_speed * clight / (charge * b0)

    def close(actual, expected):
        error = abs(sp.N(actual - expected, 50))
        scale = max(1, abs(sp.N(expected, 50)))
        assert error / scale < sp.Float("1e-12")

    close(values["vD"], drift_speed)
    close(values["rhoL"], gyroradius)
    close(values["drp"], 2 * gyroradius)
    close(values["drt"], 2 * gyroradius * sp.sqrt(rmaj / rmin))
    close(values["ft"], sp.sqrt(rmin / rmaj))

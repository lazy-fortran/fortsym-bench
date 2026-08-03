"""Independent regression for the solved SWR bindings."""

import importlib.util
import math
from pathlib import Path


def _results():
    path = Path(__file__).parents[1] / "corpus/nc-stud-Bacc_Rosa_Posch/derivations.py"
    spec = importlib.util.spec_from_file_location("bacc_derivations_v83", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def test_swr_solution_and_delivered_power_are_sequentially_resolved():
    results = _results()
    s = 3.0
    gamma = float(results["gammaOfSWR"].subs({"s": s}))
    delivered = float(results["delFraction"].subs({"s": s}))
    sensitivity = float(results["sensitivity"].subs({"s": s}))

    assert math.isclose(gamma, (s - 1.0) / (s + 1.0), rel_tol=1e-13)
    assert math.isclose(delivered, 1.0 - gamma**2, rel_tol=1e-13)
    assert math.isclose(sensitivity, -4.0 * (s - 1.0) / (s + 1.0) ** 3, rel_tol=1e-13)

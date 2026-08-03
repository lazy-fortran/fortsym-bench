"""Independent regression for the remaining Bacc derivation bindings."""

import importlib.util
import math
from pathlib import Path


def _results():
    path = Path(__file__).parents[1] / "corpus/nc-stud-Bacc_Rosa_Posch/derivations.py"
    spec = importlib.util.spec_from_file_location("bacc_derivations_remaining", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def test_finite_solenoid_center_field_matches_independent_closed_form():
    values = _results()
    mu0, turns, current = 4.0e-7 * math.pi, 7.0, 2.5
    radius, length = 0.12, 0.08

    expected = mu0 * turns * current / math.sqrt(length**2 + 4 * radius**2)
    actual = float(values["bCenter"].subs({
        "Mu0": mu0,
        "nn": turns,
        "II": current,
        "Rc": radius,
        "lc": length,
    }))

    assert math.isclose(actual, expected, rel_tol=1.0e-13, abs_tol=0.0)

from __future__ import annotations

import importlib.util
import math
from pathlib import Path


_SOURCE = (
    Path(__file__).parents[1]
    / "corpus/proj-flux_pumping/44_kinetic_mhd_bridge_aug.py"
)


def _values():
    spec = importlib.util.spec_from_file_location("kinetic_mhd_bridge_aug", _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.results()


def test_vte_matches_the_independent_machine_precision_source_formula():
    values = _values()
    eta0 = 2.41e-9
    electron_charge = 1.602177e-19
    electron_mass = 9.1093837e-31
    te_kev = (1.65e-9 * 15 / eta0) ** (2 / 3)
    expected = math.sqrt(te_kev * 10**3 * electron_charge / electron_mass)

    assert math.isclose(float(values["vte"]), expected, rel_tol=1e-15)

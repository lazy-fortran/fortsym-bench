from __future__ import annotations

from decimal import Decimal, getcontext
import importlib.util
from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).parents[1]))


def _load_target():
    path = Path(__file__).parents[1] / "corpus/proj-flux_pumping/44_kinetic_mhd_bridge_aug.py"
    spec = importlib.util.spec_from_file_location("kinetic_mhd_bridge_aug", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_kinetic_bridge_numeric_bindings_follow_source_formulae():
    getcontext().prec = 50
    module = _load_target()
    values = module.results()

    eta0 = Decimal("2.41e-9")
    electron_charge = Decimal("1.602177e-19")
    electron_mass = Decimal("9.1093837e-31")
    density = Decimal("0.98e20")
    rr0 = Decimal("4.41") / Decimal("2.57")

    expected_nu = density * electron_charge**2 * eta0 / electron_mass
    expected_eps = Decimal("1.5") * Decimal("0.15") / rr0
    expected_whole = Decimal("1.5") * Decimal("0.50") / rr0
    expected_scale = Decimal("0.02690807725830191") / Decimal("0.1809482656966454")

    def close(actual, expected):
        return abs(Decimal(str(actual)) - expected) <= Decimal("2e-14") * max(Decimal("1"), abs(expected))

    assert close(values["nuEff"], expected_nu)
    assert close(values["epsBetaCore"][0], expected_eps)
    assert close(values["epsBetaWhole"], expected_whole)
    assert close(values["qFloorCore"][1], expected_scale * Decimal("1.5") * Decimal("0.20") / rr0)

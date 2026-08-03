from __future__ import annotations

from decimal import Decimal, getcontext
import importlib.util
from pathlib import Path
import sys

import sympy as sp
import pytest

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


def test_kinetic_bridge_corrugation_chain_preserves_the_source_abs_detuning():
    module = _load_target()
    values = module.results()

    rr0 = 4.41 / 2.57
    delta = 0.05
    eta0 = 2.41e-9
    j_core = 2.5e6
    abs_detuning = sp.Function("Abs")(sp.Float("0.01"))
    resolved = {
        abs_detuning: sp.Float("0.01"),
    }
    d_over_b = float(sp.N(values["dOverB"].xreplace(resolved), 15))
    deficit = float(sp.N(values["deficitCorr"].xreplace(resolved), 15))
    field = float(sp.N(values["eDynCorr"].xreplace(resolved), 15))

    expected_d_over_b = 0.01 / rr0
    expected_deficit = 1.5 * (delta * expected_d_over_b) ** 2
    expected_field = eta0 * j_core * expected_deficit
    assert d_over_b == pytest.approx(expected_d_over_b, rel=1e-14)
    assert deficit == pytest.approx(expected_deficit, rel=1e-14)
    assert field == pytest.approx(expected_field, rel=1e-14)

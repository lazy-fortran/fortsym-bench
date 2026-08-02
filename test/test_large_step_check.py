from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments


def _large_step_module():
    path = Path(__file__).parents[1] / "corpus/proj-cpp-derivation/large_step_check.py"
    spec = importlib.util.spec_from_file_location("large_step_check", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_large_step_hessian_uses_all_six_coordinate_derivatives():
    module = _large_step_module()
    assignments = []
    for assignment in module._ASSIGNMENTS:
        assignments.append(assignment)
        if assignment[0] == "SqcAt":
            break

    values = evaluate_assignments(assignments)
    assert "SqcSym" in values
    assert "SqcAt" in values

    r, th = sp.symbols("r th")
    expected_pp = (
        1,
        1 / r**2,
        1 / (r**2 * sp.cos(th)**2 + 6 * r * sp.cos(th) + 9),
    )
    translated = values["SqcSym"]
    assert tuple(translated[3 + i][3 + i] for i in range(3)) == expected_pp
    assert all(
        translated[3 + i][3 + j] == 0
        for i in range(3)
        for j in range(3)
        if i != j
    )
    sampled = values["SqcAt"]
    assert abs(float(sampled[3][3]) - 1.0) < 1e-12
    assert abs(float(sampled[3][4])) < 1e-12


def test_large_step_lte_cancels_first_two_orders_and_has_slow_cubic_term():
    module = _large_step_module()
    values = module.results()
    dt = sp.Symbol("dt")
    assert values["lteCoeff1"] == 0
    assert values["lteCoeff2"] == 0
    assert values["lteCoeff3"].has(dt) is False
    assert values["lteCoeff3"] != 0
    assert not values["lteCoeff3"].has(sp.Symbol("qc"), sp.Symbol("wc"), sp.Symbol("eps"))

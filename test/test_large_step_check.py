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


def test_large_step_hessian_matches_independent_six_variable_oracle():
    module = _large_step_module()
    assignments = []
    for assignment in module._ASSIGNMENTS:
        assignments.append(assignment)
        if assignment[0] == "SqcAt":
            break

    values = evaluate_assignments(assignments)
    assert "SqcSym" in values
    assert "SqcAt" in values

    coordinates = sp.symbols("r th ph p1 p2 p3")
    expected = sp.hessian(values["Hqc"], coordinates)
    translated = values["SqcSym"]
    assert all(
        sp.simplify(translated[i][j] - expected[i, j]) == 0
        for i in range(6)
        for j in range(6)
    )
    sampled = values["SqcAt"]
    assert abs(float(sampled[3][3]) - 1.0) < 1e-12
    assert abs(float(sampled[3][4])) < 1e-12


def test_large_step_magnetic_norm_matches_independent_curl_oracle():
    module = _large_step_module()
    values = evaluate_assignments(
        (*module._ASSIGNMENTS, ("BmodAt", "BmodF[rr, tth]", ()))
    )
    r, th = sp.symbols("rr tth")
    metric = sp.diag(1, r**2, (3 + r * sp.cos(th))**2)
    sqrt_metric = sp.sqrt(metric.det())
    a_th = r**2 / 2 - r**3 * sp.cos(th) / 9
    a_ph = -(r**2 / 2 - r**4 / 4)
    b = sp.Matrix([
        sp.diff(a_ph, th),
        -sp.diff(a_ph, r),
        sp.diff(a_th, r),
    ]) / sqrt_metric
    expected_squared = sp.factor((b.T * metric * b)[0])
    translated_squared = sp.factor(values["BmodAt"] ** 2)
    assert sp.simplify(translated_squared - expected_squared) == 0


def test_large_step_lte_cancels_first_two_orders_and_has_slow_cubic_term():
    module = _large_step_module()
    values = module.results()
    dt = sp.Symbol("dt")
    assert values["lteCoeff1"] == 0
    assert values["lteCoeff2"] == 0
    assert values["lteCoeff3"].has(dt) is False
    assert values["lteCoeff3"] != 0
    assert not values["lteCoeff3"].has(sp.Symbol("qc"), sp.Symbol("wc"), sp.Symbol("eps"))

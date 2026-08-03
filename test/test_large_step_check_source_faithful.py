from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-cpp-derivation/large_step_check.py"
    spec = importlib.util.spec_from_file_location("large_step_check_source_faithful", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_source_slow_third_map_is_numeric_and_eps_independent():
    values = _module().results()

    # Independent oracle for the cubic local-error coefficient of implicit
    # midpoint: F'' F^2 / 24 - F'^2 F / 12 at the source's sample point.
    y0 = sp.Rational(1, 4)
    f = 1 + sp.Rational(1, 2) * y0 + sp.Rational(1, 3) * y0**2 + sp.Rational(1, 5) * y0**3
    fp = sp.Rational(1, 2) + 2 * sp.Rational(1, 3) * y0 + 3 * sp.Rational(1, 5) * y0**2
    fpp = 2 * sp.Rational(1, 3) + 6 * sp.Rational(1, 5) * y0
    expected = sp.N(fpp * f**2 / 24 - fp**2 * f / 12)

    assert values["thirdVals"] == (expected,) * 5
    assert values["lteOverDt3"] == (expected,) * 5


def test_source_free_of_fast_binding_is_an_independent_boolean_result():
    values = _module().results()
    qc, wc, eps = sp.symbols("qc wc eps")
    expected = not values["lteCoeff3"].has(qc, wc, eps)

    assert expected is True
    assert values["freeOfFast"] is True

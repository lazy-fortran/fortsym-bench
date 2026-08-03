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


def _matmul(matrix, vector):
    return [sum(row[j] * vector[j] for j in range(len(vector))) for row in matrix]


def _spectral_norm(matrix):
    vector = [1.0] * len(matrix[0])
    for _ in range(80):
        image = _matmul(matrix, vector)
        transpose_image = [
            sum(matrix[row][column] * image[row] for row in range(len(matrix)))
            for column in range(len(matrix[0]))
        ]
        scale = sum(value * value for value in transpose_image) ** 0.5
        vector = [value / scale for value in transpose_image]
    image = _matmul(matrix, vector)
    return sum(value * value for value in image) ** 0.5


def test_source_full_operator_norm_and_step_are_numeric():
    values = _module().results()
    j_inverse = [
        [0.0, 0.0, 0.0, -1.0, 0.0, 0.0],
        [0.0, 0.0, 0.0, 0.0, -1.0, 0.0],
        [0.0, 0.0, 0.0, 0.0, 0.0, -1.0],
        [1.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        [0.0, 1.0, 0.0, 0.0, 0.0, 0.0],
        [0.0, 0.0, 1.0, 0.0, 0.0, 0.0],
    ]
    expected_steps = []
    for hessian in values["SfullList"]:
        operator = [
            _matmul(j_inverse, [float(entry) for entry in column])
            for column in zip(*hessian)
        ]
        operator = [list(column) for column in zip(*operator)]
        expected_steps.append(2.0 / _spectral_norm(operator))

    actual_norms = [float(value) for value in values["LopNorms"]]
    actual_steps = [float(value) for value in values["dtFull"]]
    assert all(abs(2.0 / norm - step) < 1e-12 for norm, step in zip(actual_norms, actual_steps))
    for actual, expected in zip(actual_steps, expected_steps):
        assert abs(actual - expected) / expected < 1e-8

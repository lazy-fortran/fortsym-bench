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


def test_source_residual_blocks_and_reduced_geometry_have_independent_values():
    values = _module().results()
    r, th, eps, vpar = sp.symbols("r th eps vpar")
    metric = sp.diag(1, r**2, (3 + r * sp.cos(th))**2)
    sqrt_metric = sp.sqrt(metric.det())
    a = sp.Matrix([0, r**2 / 2 - r**3 * sp.cos(th) / 9, -(r**2 / 2 - r**4 / 4)])
    b = sp.Matrix([sp.diff(a[2], th), -sp.diff(a[2], r), sp.diff(a[1], r)]) / sqrt_metric
    b_cov = metric * b
    bmag = sp.sqrt((b.T * metric * b)[0])
    hcov = b_cov / bmag
    hctr = b / bmag
    grad = sp.Matrix([sp.diff(bmag, r), sp.diff(bmag, th), 0])
    astar = a + eps * vpar * hcov
    bstar = sp.Matrix([
        sp.diff(astar[2], th), -sp.diff(astar[2], r), sp.diff(astar[1], r)
    ]) / sqrt_metric
    point = {r: sp.Rational(1, 2), th: sp.Rational(7, 10), eps: sp.Rational(1, 7), vpar: sp.Rational(3, 10)}

    def close(actual, expected):
        return abs(float(sp.N((actual - expected).subs(point), 20))) < 1e-12

    assert all(close(actual, expected) for actual, expected in zip(values["BcovS"], b_cov))
    assert close(values["BmagS"], bmag)
    assert all(close(actual, expected) for actual, expected in zip(values["hcovS"], hcov))
    assert all(close(actual, expected) for actual, expected in zip(values["hctrS"], hctr))
    assert all(close(actual, expected) for actual, expected in zip(values["gradB"], grad))
    assert all(close(actual, expected) for actual, expected in zip(values["Astar"], astar))
    assert close(values["BstarPar"], (hcov.T * bstar)[0])
    assert close(values["vpardot"], -sp.Rational(1, 10) * (hctr.T * grad)[0])

"""Independent checks for the explicit numeric math12y residual tables."""

import importlib.util
import math
from pathlib import Path


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math12y.py'
    spec = importlib.util.spec_from_file_location('math12y_numeric', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_chebyshev_coefficients_match_independent_quadrature():
    import mpmath as mp

    values = _module().results()['cn']
    for order, value in enumerate(values):
        expected = (4 / mp.pi) * mp.quad(
            lambda theta: mp.cos(order * theta) / (3 + mp.cos(theta)),
            [0, mp.pi],
        )
        assert math.isclose(float(value), float(expected), rel_tol=2e-14,
                            abs_tol=2e-15)


def test_d2_matches_the_source_function_and_derivative_at_each_data_point():
    values = _module().results()['d2']
    points = (-1, -0.5, 0, 1, 3, 6, 9)
    for row, point in zip(values, points):
        function = (math.exp(-point) - 1)**2
        derivative = 2 * (1 - math.exp(-point)) * math.exp(-point)
        assert math.isclose(float(row[0][0]), point, rel_tol=0, abs_tol=1e-14)
        assert math.isclose(float(row[1]), function, rel_tol=2e-14,
                            abs_tol=2e-15)
        assert math.isclose(float(row[2]), derivative, rel_tol=2e-14,
                            abs_tol=2e-15)

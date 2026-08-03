"""Independent behavioral check for the v98 math10y recovery."""

import importlib.util
import math
from pathlib import Path


def _module():
    path = Path(__file__).parents[1] / "corpus/archive-tu/math10y.py"
    spec = importlib.util.spec_from_file_location("archive_tu_math10y_v98", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def _g(x, y):
    z = 3.31
    radius = math.sqrt(x * x + y * y + z * z)
    return (
        x * y * radius / 6.0
        + z**3 * math.atan(x * y / (z * radius)) / 3.0
        + x**3 * math.log(y + radius) / 3.0
        - (y**3 + 3.0 * y * z**2) * math.log(x + radius) / 6.0
    )


def test_fn_is_the_final_mixed_derivative_against_independent_finite_difference():
    value = _module().results()["fn"]
    symbols = {symbol.name: symbol for symbol in value.free_symbols}
    x = symbols["x"]
    y = symbols["y"]

    for point_x, point_y in ((0.2, 0.4), (0.7, 0.3)):
        step = 1.0e-4
        actual = float(value.subs({x: point_x, y: point_y}).evalf())
        expected = (
            _g(point_x + step, point_y + step)
            - _g(point_x + step, point_y - step)
            - _g(point_x - step, point_y + step)
            + _g(point_x - step, point_y - step)
        ) / (4.0 * step * step)
        assert math.isclose(actual, expected, rel_tol=2.0e-6, abs_tol=2.0e-8)

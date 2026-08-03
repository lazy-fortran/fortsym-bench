from __future__ import annotations

import importlib.util
from pathlib import Path

import mpmath
import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-maxent19-gp/heat.py"
    spec = importlib.util.spec_from_file_location("maxent19_gp_heat", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_recovered_k3_is_the_full_line_heat_kernel_convolution():
    values = _module().results()
    x0, x1, t0, t1 = sp.symbols("x0 x1 t0 t1")
    expected = sp.exp(-(x0 - x1) ** 2 / (4 * (t0 + t1))) / (
        2 * sp.sqrt(sp.pi) * sp.sqrt(t0 + t1)
    )

    assert set(values) == {"k1", "k2", "k3"}
    assert sp.simplify(values["k3"] - expected) == 0


def test_recovered_k3_matches_an_independent_numeric_value():
    value = _module().results()["k3"]
    sample = {"x0": 1, "x1": 0, "t0": 1, "t1": 2}
    expected = sp.exp(-sp.Rational(1, 12)) / (2 * sp.sqrt(3 * sp.pi))

    assert abs(sp.N(value.subs(sample) - expected, 30)) < sp.Float("1e-25")


def test_recovered_k1_matches_independent_numeric_left_truncated_convolution():
    value = _module().results()["k1"]
    sample = {"x0": 1, "x1": 0, "t0": 1, "t1": 2, "xa": sp.Rational(1, 2)}
    candidate = value.subs(sample).replace(
        lambda expression: expression.func.__name__ == "Erf",
        lambda expression: sp.erf(*expression.args),
    ).evalf(30)

    def gaussian(x, t, xi):
        return mpmath.exp(-(x - xi) ** 2 / (4 * t)) / mpmath.sqrt(4 * mpmath.pi * t)

    expected = mpmath.quad(
        lambda xi: gaussian(1, 1, xi) * gaussian(0, 2, xi),
        [-mpmath.inf, mpmath.mpf("0.5")],
    )
    assert abs(mpmath.mpf(str(candidate)) - expected) < mpmath.mpf("1e-25")


def test_recovered_k2_matches_independent_numeric_right_truncated_convolution():
    value = _module().results()["k2"]
    sample = {"x0": 1, "x1": 0, "t0": 1, "t1": 2, "xb": sp.Rational(1, 2)}
    candidate = value.subs(sample).replace(
        lambda expression: expression.func.__name__ == "Erf",
        lambda expression: sp.erf(*expression.args),
    ).evalf(30)

    def gaussian(x, t, xi):
        return mpmath.exp(-(x - xi) ** 2 / (4 * t)) / mpmath.sqrt(4 * mpmath.pi * t)

    expected = mpmath.quad(
        lambda xi: gaussian(1, 1, xi) * gaussian(0, 2, xi),
        [mpmath.mpf("0.5"), mpmath.inf],
    )
    assert abs(mpmath.mpf(str(candidate)) - expected) < mpmath.mpf("1e-25")

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-cpp-derivation/large_step_check.py"
    spec = importlib.util.spec_from_file_location("large_step_check_v103", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_inverse_metric_is_the_source_factored_diagonal_inverse():
    values = _module().results()
    r, th = sp.symbols("r th")
    expected = sp.diag(1, r**-2, (r * sp.cos(th) + 3) ** -2)
    actual = sp.Matrix(values["gIS"])

    assert actual == expected
    assert actual * sp.diag(1, r**2, (r * sp.cos(th) + 3) ** 2) == sp.eye(3)

"""Independent checks for the recovered flux-coordinate report scalar."""

import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / "corpus/proj-plasma-sign-conventions/flux_coordinate_handedness.py"
    )
    spec = importlib.util.spec_from_file_location("flux_coordinate_handedness", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_native_report_result_count_is_preserved_as_a_sympy_integer():
    values = _load().results()

    # Independent native v94 InputForm oracle: Length[report["TestResults"]]
    # emitted 1 for this script.  Check both value and type so the recovered
    # binding remains a scalar result rather than an opaque report expression.
    assert values["nRun"] == sp.Integer(1)
    assert values["nRun"].is_Integer

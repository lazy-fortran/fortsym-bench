import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-cpp-derivation/gc_drift.py"
    spec = importlib.util.spec_from_file_location("gc_drift_generated", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_unresolved_series_keeps_the_native_opaque_head():
    assert _module().results()["vGCser"] == sp.Symbol("vGC")

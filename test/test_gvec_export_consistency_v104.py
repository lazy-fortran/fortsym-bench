"""Independent behavioral check for the v104 gvec CSV rows binding."""

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _load_target():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-gvec-stability/gvec_export_consistency.py'
    )
    spec = importlib.util.spec_from_file_location(
        'gvec_export_consistency_v104', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_fourier_rows_preserves_unresolved_source_binding():
    values = _load_target().results()
    expected = sp.Function('Rest')(sp.Symbol('fourierTable'))

    assert values['fourierRows'] == expected

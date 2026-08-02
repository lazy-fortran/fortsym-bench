from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-cpp-derivation/projected_scheme.py'
    )
    spec = importlib.util.spec_from_file_location('projected_scheme', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_scalar_intermediates_preserve_source_forms():
    values = _module().results()

    expected_det = sp.Function('Abs')(
        sp.Function('Det')(sp.Symbol('Kbounce'))
    )
    assert values['detKKT'] == expected_det
    assert values['dtGCmax'] == sp.Integer(2)

    # Independent arithmetic oracle for the source Table[d, {d, 1/20,
    # 30/20, 1/400}].  This also documents why the native List[1, 2, 3]
    # result is not a source-faithful replacement.
    expected_scan = tuple(
        sp.Rational(d, 400) for d in range(20, 601)
    )
    assert values['dtScan'] == expected_scan

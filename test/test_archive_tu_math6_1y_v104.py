"""Independent check for the v104 archive-tu math6-1y cleared symbol."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math6-1y.py'
    spec = importlib.util.spec_from_file_location(
        'archive_tu_math6_1y_v104', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_r_uses_t_after_source_clear():
    # The Wolfram source executes Clear[..., t] before ``r = t``.  The
    # expected result is therefore the bare symbol, not the earlier numeric
    # value assigned to t near the beginning of the script.
    assert _module().results()['r'] == sp.Symbol('t')

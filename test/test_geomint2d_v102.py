"""Independent check for the v102 geomint2d Aphi binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-kineq-old/geomint2d.py'
    spec = importlib.util.spec_from_file_location('geomint2d_v102', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_aphi_preserves_the_source_alias_to_the_opaque_integral():
    actual = _module().results()['Aphi']

    # The Wolfram source assigns Aphi directly from Aphsol2.  The native
    # subset intentionally retains that unsupported integral as a symbol.
    expected = sp.Symbol('Aphsol2')
    assert actual == expected
    assert actual.is_Symbol

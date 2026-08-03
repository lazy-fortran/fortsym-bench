"""Independent checks for the remaining geomint2d symbolic binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-kineq-old/geomint2d.py'
    spec = importlib.util.spec_from_file_location('geomint2d', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_minv_preserves_the_source_symbolic_inverse_head():
    values = _module().results()

    expected = sp.Function('Inverse')(sp.Symbol('Mtri'))
    assert values['Minv'] == expected
    assert values['Minv'].func == sp.Function('Inverse')
    assert values['Minv'].args == (sp.Symbol('Mtri'),)

"""Independent check for the v101 archive-tu math6-1y ellipse binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math6-1y.py'
    spec = importlib.util.spec_from_file_location(
        'archive_tu_math6_1y_v101', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_k_preserves_the_source_parametric_ellipse():
    actual = _module().results()['k']
    phi = sp.Symbol('ϕ')
    expected = sp.Function('ParametricPlot')(
        sp.Tuple(2 * sp.cos(phi), sp.sin(phi)),
        sp.Tuple(phi, 0, 2 * sp.pi),
    )

    assert actual == expected

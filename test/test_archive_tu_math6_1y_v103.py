"""Independent check for the final archive-tu math6-1y ``k1`` binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math6-1y.py'
    spec = importlib.util.spec_from_file_location(
        'archive_tu_math6_1y_v103', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_k1_preserves_the_final_show_head_and_ellipse_geometry():
    actual = _module().results()['k1']
    assert actual.func.__name__ == 'Show'
    assert actual.args[0].func.__name__ == 'ParametricPlot'
    assert actual.args[0].args[1] == sp.Tuple(
        sp.Symbol('ϕ'), 0, 2 * sp.pi
    )

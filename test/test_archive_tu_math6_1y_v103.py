"""Independent check for the v103 archive-tu math6-1y local ellipse."""

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


def test_k1_preserves_its_local_parametric_iterator():
    actual = _module().results()['k1']
    t = sp.Symbol('t')
    expected = sp.Function('ParametricPlot')(
        sp.Tuple(sp.Float('0.5') + sp.cos(t), 1 + sp.sin(t)),
        sp.Tuple(t, 0, 2 * sp.pi),
    )

    assert actual == expected

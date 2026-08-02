"""Independent behavioral checks for the recovered math12y point binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math12y.py'
    spec = importlib.util.spec_from_file_location('math12y', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_poi_preserves_the_source_point_map_and_size_option():
    values = _module().results()
    point = sp.Function('Point')
    expected = sp.Tuple(
        sp.Function('AbsolutePointSize')(8),
        sp.Tuple(
            point(sp.Tuple(2, 1)),
            point(sp.Tuple(3, 7)),
            point(sp.Tuple(5, 8)),
            point(sp.Tuple(6, 11)),
        ),
    )
    assert values['poi'] == expected

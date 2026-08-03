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


def test_con_is_the_exact_bilinear_least_squares_solution():
    values = _module().results()
    rules = dict((str(rule.args[0]), rule.args[1]) for rule in values['con'])
    coefficients = sp.Matrix([rules[name] for name in ('a', 'b', 'c', 'd')])
    design = sp.Matrix([
        [1, 2, 1, 2],
        [1, 3, 7, 21],
        [1, 5, 8, 40],
        [1, 6, 11, 66],
    ])
    target = sp.Matrix([1, 2, 3, 4])
    assert design.T * (design * coefficients - target) == sp.zeros(4, 1)
    assert list(coefficients) == [sp.Rational(51, 134), sp.Rational(35, 134),
                                  sp.Rational(7, 134), sp.Rational(3, 134)]


def test_unsupported_plot_random_spline_and_model_residuals_remain_opaque():
    values = _module().results()
    assert values['dp'] == sp.Function('Show')(sp.Symbol('d'), sp.Symbol('sp'))
    assert values['fr'] is sp.nan
    assert values['nlm'].func == sp.Function('NonlinearModelFit')

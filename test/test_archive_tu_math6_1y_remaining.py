"""Independent check for a remaining archive-tu math6-1y binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math6-1y.py'
    spec = importlib.util.spec_from_file_location('archive_tu_math6_1y_remaining', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_pi_preserves_each_source_plot_and_style():
    plots = _module().results()['pi']
    x = sp.Symbol('x')
    plot = sp.Function('Plot')
    rule = sp.Function('Rule')
    style = sp.Symbol('PlotStyle')
    thick = sp.Symbol('Thick')
    hue = sp.Function('Hue')

    expected = sp.Tuple(*(
        plot(
            sp.sin(k * x),
            sp.Tuple(x, 0, 2 * sp.pi),
            rule(style, sp.Tuple(thick, hue(sp.Float(k * 0.25)))),
        )
        for k in range(1, 5)
    ))

    assert plots == expected

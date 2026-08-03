"""Independent regression for the v98 archive-old math6-1y recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-old/math6-1y.py'
    spec = importlib.util.spec_from_file_location('archive_old_math6_1y_v98', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_ellipse_plot_keeps_the_source_parameter_and_geometry():
    values = _module().results()
    phi = sp.Symbol('ϕ')
    expected = sp.Function('ParametricPlot')(
        sp.Tuple(2 * sp.cos(phi), sp.sin(phi)),
        sp.Tuple(phi, 0, 2 * sp.pi),
    )

    assert values['k'] == expected
    assert values['k'].args[0] == sp.Tuple(2 * sp.cos(phi), sp.sin(phi))
    assert values['k'].args[1] == sp.Tuple(phi, 0, 2 * sp.pi)

"""Independent checks for two bounded archive-tu math6-1y bindings."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math6-1y.py'
    spec = importlib.util.spec_from_file_location(
        'archive_tu_math6_1y_v109', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_final_k4_preserves_source_geometry_and_plot_style():
    phi = sp.Symbol('ϕ')
    expected = sp.Function('ParametricPlot')(
        sp.Tuple(2 * sp.cos(phi), sp.sin(phi)),
        sp.Tuple(phi, 0, 2 * sp.pi),
        sp.Function('Rule')(
            sp.Symbol('PlotStyle'),
            sp.Tuple(
                sp.Function('Hue')(0),
                sp.Function('Thickness')(sp.Float('0.01')),
            ),
        ),
    )

    assert _module().results()['k4'] == expected


def test_delayed_pp_uses_later_xcm_assignment():
    x = sp.Symbol('x')
    expected = sp.Function('Plot')(
        sp.sin(x),
        sp.Tuple(x, 0, 3 * sp.pi),
        sp.Function('Rule')(sp.Symbol('ImageSize'), 174),
    )

    assert _module().results()['pp'] == expected

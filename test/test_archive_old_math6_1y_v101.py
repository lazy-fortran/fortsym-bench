"""Independent regression for the v101 archive-old math6-1y recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-old/math6-1y.py'
    spec = importlib.util.spec_from_file_location('archive_old_math6_1y_v101', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_styled_ellipse_keeps_source_geometry_and_options():
    values = _module().results()
    phi = sp.Symbol('ϕ')
    rule = sp.Function('Rule')
    expected = sp.Function('ParametricPlot')(
        sp.Tuple(2 * sp.cos(phi), sp.sin(phi)),
        sp.Tuple(phi, 0, 2 * sp.pi),
        rule(
            sp.Symbol('Background'),
            sp.Function('RGBColor')(
                sp.Float(0.0), sp.Float(0.999), sp.Float(0.0)
            ),
        ),
        rule(sp.Symbol('PlotStyle'), sp.Tuple(sp.Symbol('Red'))),
    )

    assert values['k3'] == expected
    assert values['k3'].args[0] == sp.Tuple(2 * sp.cos(phi), sp.sin(phi))
    assert values['k3'].args[2] == expected.args[2]

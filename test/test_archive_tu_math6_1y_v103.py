"""Independent check for the final archive-tu math6-1y ``k1`` binding."""

import hashlib
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


def test_k1_preserves_the_final_show_options_and_k4_source_tree():
    actual = _module().results()['k1']
    phi = sp.Symbol('ϕ')
    k4 = sp.Function('ParametricPlot')(
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
    string_atom = lambda literal: sp.Symbol(
        'fortsymString' + hashlib.sha256(f'"{literal}"'.encode()).hexdigest()
    )
    expected = sp.Function('Show')(
        k4,
        sp.Function('Rule')(
            sp.Symbol('AxesLabel'),
            sp.Tuple(string_atom('x'), string_atom('y')),
        ),
        sp.Function('Rule')(
            sp.Symbol('Background'), sp.Function('GrayLevel')(sp.Float('0.3')),
        ),
        sp.Function('Rule')(
            sp.Symbol('BaseStyle'), sp.Function('Hue')(sp.Float('0.3')),
        ),
        sp.Function('Rule')(
            sp.Symbol('PlotLabel'),
            sp.Function('Style')(
                string_atom('Ellipse\n'),
                sp.Function('Rule')(sp.Symbol('FontSize'), 16),
                sp.Function('Rule')(sp.Symbol('FontFamily'), sp.Symbol('Helvetica')),
            ),
        ),
    )

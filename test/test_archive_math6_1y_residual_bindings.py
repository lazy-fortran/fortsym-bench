"""Independent source-derived checks for the residual math6-1y bindings."""

import hashlib
import importlib.util
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).parents[1]


def _module(relative_path: str, name: str):
    path = ROOT / relative_path
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def _expected_p3():
    x = sp.Symbol('x')
    return sp.Function('Plot')(
        sp.sin(x),
        sp.Tuple(x, 0, 10),
        sp.Function('Rule')(
            sp.Symbol('TicksStyle'),
            sp.Function('Directive')(
                sp.Symbol('Thick'), sp.Symbol('Orange'), 14
            ),
        ),
    )


def _expected_k3():
    phi = sp.Symbol('ϕ')
    return sp.Function('ParametricPlot')(
        sp.Tuple(2 * sp.cos(phi), sp.sin(phi)),
        sp.Tuple(phi, 0, 2 * sp.pi),
        sp.Function('Rule')(
            sp.Symbol('Background'),
            sp.Function('RGBColor')(
                sp.Float('0.0'), sp.Float('0.999'), sp.Float('0.0')
            ),
        ),
        sp.Function('Rule')(sp.Symbol('PlotStyle'), sp.Tuple(sp.Symbol('Red'))),
    )


def _expected_k1():
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
    return sp.Function('Show')(
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


def _expected_ps2():
    return sp.Function('ListPlot')(
        sp.Tuple(2, 3, 1, 4, sp.Float('2.5'), sp.Float('1.5')),
        sp.Function('Rule')(sp.Symbol('PlotJoined'), True),
    )


def test_both_companions_preserve_source_plot_residuals():
    old = _module('corpus/archive-old/math6-1y.py', 'archive_old_math6_1y_residuals')
    tu = _module('corpus/archive-tu/math6-1y.py', 'archive_tu_math6_1y_residuals')

    for values in (old.results(), tu.results()):
        assert values['p3'] == _expected_p3()
        assert values['k3'] == _expected_k3()
        assert values['ps2'] == _expected_ps2()

    assert tu.results()['k1'] == _expected_k1()

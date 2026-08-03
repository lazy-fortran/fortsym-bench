import importlib.util

import sympy as sp


def _module():
    path = 'corpus/archive-old/math6-2y.py'
    spec = importlib.util.spec_from_file_location('math6_2y', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_recovered_potential_is_differentiated_independently():
    values = _module().results()
    x, y, mu = sp.symbols('x y μ')
    expected = (
        -mu / sp.sqrt(y**2 + (x + mu - 1) ** 2)
        + (mu - 1) / sp.sqrt(y**2 + (x + mu) ** 2)
        - (x**2 + y**2) / 2
    )
    assert sp.simplify(values['fu'] - expected) == 0
    assert sp.simplify(values['fx'] + sp.diff(expected, x)) == 0
    assert sp.simplify(values['fy'] + sp.diff(expected, y)) == 0
    assert sp.simplify(values['um'] - expected.subs(mu, sp.Rational(1, 4))) == 0


def test_recovered_marker_coordinates_are_source_values():
    values = _module().results()
    assert values['pm'] == sp.Tuple(
        sp.Function('Point')(sp.Tuple(-sp.Rational(1, 4), 0)),
        sp.Function('Point')(sp.Tuple(sp.Rational(3, 4), 0)),
    )
    assert values['pms'] == sp.Tuple(
        sp.Tuple(-sp.Rational(1, 4), sp.Float(0.15)),
        sp.Tuple(sp.Rational(3, 4), sp.Float(0.15)),
    )


def test_clipping_binding_keeps_coordinates_from_its_source_assignment():
    values = _module().results()
    x, y = sp.symbols('x y')
    expected = sp.Function('Abs')(
        sp.Function('JacobiCN')(
            x + sp.I * y,
            sp.Float('0.8') ** 2,
        )
    )

    assert values['cna'] == expected


def test_last_emitted_p1_keeps_the_source_parametric_plot_head():
    values = _module().results()
    u = sp.Symbol('u')
    expected = sp.Function('ParametricPlot3D')(
        sp.Tuple(
            sp.sin(8 * u) * sp.sin(u),
            sp.cos(8 * u) * sp.sin(u),
            sp.cos(u),
        ),
        sp.Tuple(u, 0, 2 * sp.pi),
        sp.Function('Rule')(sp.Symbol('PlotPoints'), 200),
    )

    assert values['p1'] == expected


def test_parametric_surface_keeps_its_source_ranges_and_options():
    values = _module().results()
    x, y = sp.symbols('x y')
    expected = sp.Function('ParametricPlot3D')(
        sp.Tuple(x, y, sp.sin(x * y)),
        sp.Tuple(x, 1, 2),
        sp.Tuple(y, 1, 2),
        sp.Function('Rule')(sp.Symbol('PlotPoints'), 4),
        sp.Function('Rule')(
            sp.Symbol('BoxRatios'), sp.Tuple(1, 1, sp.Float('0.4'))
        ),
    )

    assert values['pa'] == expected

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / (
        'corpus/archive-old/math6-2y_deleted_4d8899d2-ea9971-3c018e87.py'
    )
    spec = importlib.util.spec_from_file_location('math6_2y_deleted', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_final_p1_preserves_source_parametric_plot():
    value = _module().results()['p1']
    u = sp.Symbol('u')
    expected = sp.Function('ParametricPlot3D')(
        sp.Tuple(sp.sin(8 * u) * sp.sin(u), sp.cos(8 * u) * sp.sin(u), sp.cos(u)),
        sp.Tuple(u, 0, 2 * sp.pi),
        sp.Function('Rule')(sp.Symbol('PlotPoints'), 200),
    )
    assert value == expected


def test_clear_and_potential_bindings_follow_source_state():
    values = _module().results()
    x, y, mu = sp.symbols('x y μ')
    expected_cna = sp.Function('Abs')(
        sp.Function('JacobiCN')(x + sp.I * y, sp.Float('0.8') ** 2)
    )
    assert values['cna'] == expected_cna
    expected_fu = (
        -sp.Rational(1, 2) * (x**2 + y**2)
        - mu / sp.sqrt(y**2 + (-1 + x + mu) ** 2)
        + (mu - 1) / sp.sqrt(y**2 + (x + mu) ** 2)
    )
    assert values['fu'] == expected_fu
    assert values['fy'] == -sp.diff(expected_fu, y)
    assert values['um'] == expected_fu.subs(mu, sp.Rational(1, 4))
    assert values['pms'] == sp.Tuple(
        sp.Tuple(-sp.Rational(1, 4), sp.Float('0.15')),
        sp.Tuple(sp.Rational(3, 4), sp.Float('0.15')),
    )

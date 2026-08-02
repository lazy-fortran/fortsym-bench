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

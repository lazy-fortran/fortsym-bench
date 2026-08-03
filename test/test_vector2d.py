"""Independent numeric checks for the triangular vector-field recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-kineq-old/vector2d.py'
    spec = importlib.util.spec_from_file_location('vector2d', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_phic_fields_match_source_at_an_interior_point():
    values = _module().results()
    x, y = sp.symbols('x y')
    expected = {
        'phic11': (2 * x, 0),
        'phic12': (0, 2 * y),
        'phic21': (-2 * y, 2 * y),
        'phic22': (2 * (x + y - 1), 0),
        'phic31': (0, 2 * (x + y - 1)),
        'phic32': (2 * x, -2 * x),
    }
    point = {x: sp.Rational(1, 4), y: sp.Rational(3, 4)}
    for name, expression in expected.items():
        assert tuple(values[name].subs(point)) == tuple(
            sp.sympify(component).subs(point) for component in expression
        )

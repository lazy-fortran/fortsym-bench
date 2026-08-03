"""Independent check for the remaining source-level vector2d binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-kineq-old/vector2d.py'
    spec = importlib.util.spec_from_file_location('vector2d_remaining', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_g11_preserves_the_pre_unconverted_vector_plot():
    value = _module().results()['g11']
    x, y = sp.symbols('x y')
    expected = sp.Function('StreamPlot')(
        sp.Tuple(
            sp.sqrt(2) * (sp.Rational(1, 2) + sp.sqrt(3) / 6) * x
            / (sp.sqrt(3) / 3),
            sp.sqrt(2) * y,
        ),
        sp.Tuple(x, 0, 1),
        sp.Tuple(y, 0, 1),
    )

    assert value == expected
    vector = value.args[0]
    point = {x: sp.Rational(1, 3), y: sp.Rational(1, 4)}
    assert tuple(component.subs(point) for component in vector) == (
        sp.sqrt(2) * (sp.Rational(1, 2) + sp.sqrt(3) / 6) / (sp.sqrt(3) / 3) / 3,
        sp.sqrt(2) / 4,
    )

"""Independent behavioral regression for the v102 vector2d recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-kineq-old/vector2d.py'
    spec = importlib.util.spec_from_file_location('vector2d_v102', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_g12_preserves_the_pre_unconverted_field_plot():
    value = _module().results()['g12']
    x, y = sp.symbols('x y')

    assert value.func == sp.Function('StreamPlot')
    assert value.args[1:] == (
        sp.Tuple(x, 0, 1),
        sp.Tuple(y, 0, 1),
    )

    # Independently reconstruct l2[y] e2 from the Wolfram definitions and
    # check the vector at an interior point, rather than comparing to the
    # generated expression itself.
    g1 = sp.Rational(1, 2) - sp.sqrt(3) / 6
    g2 = sp.Rational(1, 2) + sp.sqrt(3) / 6
    point = {x: sp.Rational(1, 4), y: sp.Rational(3, 4)}
    l2 = (point[y] - g1) / (g2 - g1)
    expected = (l2 * (point[x] - 1), l2 * point[y])
    vector = value.args[0]
    assert tuple(component.subs(point) for component in vector) == expected

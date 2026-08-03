"""Independent behavioral check for the remaining vector2d field plots."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-kineq-old/vector2d.py'
    spec = importlib.util.spec_from_file_location('vector2d_v109', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_remaining_first_block_plots_match_independent_field_oracles():
    values = _module().results()
    x, y = sp.symbols('x y')
    g1 = sp.Rational(1, 2) - sp.sqrt(3) / 6
    g2 = sp.Rational(1, 2) + sp.sqrt(3) / 6
    point = {x: sp.Rational(1, 4), y: sp.Rational(3, 4)}

    # Reconstruct phi13, phi21, phi22, and phi23 directly from the Wolfram
    # definitions; do not derive the oracle from the generated module.
    l1x = (point[x] - g2) / (g1 - g2)
    l2y = (point[y] - g1) / (g2 - g1)
    l1y = (point[y] - g2) / (g1 - g2)
    l2x = (point[x] - g1) / (g2 - g1)
    expected = {
        'g13': (l1x * point[x], l1x * (point[y] - 1)),
        'g21': (l2y * sp.sqrt(2) * point[x], l2y * sp.sqrt(2) * point[y]),
        'g22': (l1y * (point[x] - 1), l1y * point[y]),
        'g23': (l2x * point[x], l2x * (point[y] - 1)),
    }

    for name, vector in expected.items():
        value = values[name]
        assert value.func == sp.Function('StreamPlot')
        assert value.args[1:] == (
            sp.Tuple(x, 0, 1),
            sp.Tuple(y, 0, 1),
        )
        assert tuple(component.subs(point) for component in value.args[0]) == vector

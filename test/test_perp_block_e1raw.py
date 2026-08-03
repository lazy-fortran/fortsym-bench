"""Independent regression for the opaque source Dot contraction."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/proj-cpp-derivation/perp_block_check.py'
    spec = importlib.util.spec_from_file_location('perp_block_e1raw', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_e1raw_preserves_source_dot_structure_and_numeric_projection():
    values = _module().results()
    dot = sp.Function('Dot')
    bc, bn = sp.symbols('Bc Bn')
    projection = dot(sp.Tuple(1, 0, 0), bc / bn)
    expected = sp.Tuple(
        1 - bc * projection / bn,
        -bc * projection / bn,
        -bc * projection / bn,
    )
    assert values['e1raw'] == expected

    # Independent numeric oracle for the three-component contraction: the
    # first component of (Bc/Bn, 0, 0) is Bc/Bn.
    numeric = (bc, bn, sp.Integer(2), sp.Integer(5))
    actual = values['e1raw'].subs({bc: numeric[2], bn: numeric[3]})
    expected_numeric = sp.Tuple(sp.Rational(21, 25), -sp.Rational(4, 25), -sp.Rational(4, 25))
    assert actual.replace(
        lambda expr: expr.func == dot,
        lambda expr: expr.args[1],
    ) == expected_numeric

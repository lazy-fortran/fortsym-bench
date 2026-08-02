"""Independent checks for literal TDRK guiding-centre intermediates."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / (
        'corpus/code-integrator-benchmark/tdrk_guiding_center_G.py'
    )
    spec = importlib.util.spec_from_file_location('tdrk_guiding_center_G', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_d2_index_is_the_source_ordered_symmetric_table():
    values = _module().results()
    rule = sp.Function('Rule')
    expected = sp.Tuple(
        *(rule(sp.Tuple(i, j), value) for (i, j), value in (
            ((1, 1), 1), ((1, 2), 2), ((1, 3), 3),
            ((2, 2), 4), ((2, 3), 5), ((3, 3), 6),
            ((1, 4), 7), ((2, 4), 8), ((3, 4), 9),
            ((4, 4), 10),
        ))
    )
    assert values['d2Index'] == expected


def test_numeric_spot_check_point_preserves_exact_rationals():
    values = _module().results()
    rule = sp.Function('Rule')
    assert values['pt'] == sp.Tuple(
        rule(sp.Symbol('r'), sp.Rational(37, 100)),
        rule(sp.Symbol('th'), sp.Rational(61, 100)),
        rule(sp.Symbol('ph'), sp.Rational(117, 100)),
        rule(sp.Symbol('pph'), sp.Rational(43, 100)),
    )

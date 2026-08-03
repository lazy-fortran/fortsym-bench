"""Independent regression for the v99 archive-old math6-1y recovery."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-old/math6-1y.py'
    spec = importlib.util.spec_from_file_location('archive_old_math6_1y_v99', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_ticks_plot_keeps_its_local_parameter_and_range():
    values = _module().results()
    t = sp.Symbol('t')
    expected = sp.Function('Plot')(
        sp.sin(t),
        sp.Tuple(t, 0, 2 * sp.pi),
    )

    assert values['s'] == expected
    assert values['s'].args[0] == sp.sin(t)
    assert values['s'].args[1] == sp.Tuple(t, 0, 2 * sp.pi)

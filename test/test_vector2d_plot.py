"""Independent checks for vector2d plot representation parity."""

import importlib.util
from pathlib import Path

import sympy as sp

from fortsym_bench.compare import AGREE, DIFFER, compare_cross_text


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-kineq-old/vector2d.py'
    spec = importlib.util.spec_from_file_location('vector2d_plot', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_vector2d_plots_remain_symbolic_and_opt_into_handle_bridge():
    module = _module()
    values = module.results()
    plot_names = (
        'g11', 'g12', 'g13', 'g21', 'g22', 'g23', 'g14', 'g15',
        'gr1', 'gr2', 'gr3',
    )

    assert set(module.COMPARE) == set(plot_names)
    for name in plot_names:
        assert values[name].func == sp.Function('StreamPlot')


def test_plot_policy_accepts_only_a_native_handle_and_plot_tree():
    reference = "Function('StreamPlot')(Tuple(Symbol('x'), Symbol('y')))"

    assert compare_cross_text(
        'fortsym-plot-12.png', 'inputform', reference, 'srepr', 'plot'
    ).outcome == AGREE
    assert compare_cross_text(
        'plot.png', 'inputform', reference, 'srepr', 'plot'
    ).outcome == DIFFER
    assert compare_cross_text(
        'fortsym-plot-12.png', 'inputform', "Integer(1)", 'srepr', 'plot'
    ).outcome == DIFFER

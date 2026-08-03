"""Independent check for the recovered RF-crossing flow-chart node."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/proj-ecnl-gorilla-recovery/07_figures.py'
    spec = importlib.util.spec_from_file_location('ecnl_figures_v99', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_rf_crossing_kernel_node_preserves_source_coordinate():
    values = _module().results()

    # Independent source oracle: the node is ``{2.2, 2}`` in 07_figures.wl.
    assert values['RF crossing kernel'] == sp.Tuple(sp.Float('2.2'), 2)

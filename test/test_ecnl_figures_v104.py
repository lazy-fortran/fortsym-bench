"""Independent check for the recovered GORILLA flow-chart node."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/proj-ecnl-gorilla-recovery/07_figures.py'
    spec = importlib.util.spec_from_file_location('ecnl_figures_v104', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_gorilla_orbit_node_preserves_source_coordinate():
    values = _module().results()

    # Independent source oracle: ``"GORILLA orbit" -> {4.6, 2}`` in
    # corpus/proj-ecnl-gorilla-recovery/07_figures.wl.
    assert values['GORILLA orbit'] == sp.Tuple(sp.Float('4.6'), 2)

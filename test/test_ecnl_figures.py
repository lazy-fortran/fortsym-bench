"""Independent check for the recovered first flow-chart node."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/proj-ecnl-gorilla-recovery/07_figures.py'
    spec = importlib.util.spec_from_file_location('ecnl_figures', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_wave_beam_node_preserves_source_coordinate():
    values = _module().results()

    # Source: ``"wave / beam" -> {0, 2}`` in the ``nodes`` association.
    assert values['wave / beam'] == sp.Tuple(0, 2)

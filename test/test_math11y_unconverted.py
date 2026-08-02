"""Independent checks for the observable unconverted math11y cells."""

import importlib.util
from pathlib import Path

import sympy as sp


def test_unconverted_cells_preserve_their_symbolic_outputs():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math11y.py'
    spec = importlib.util.spec_from_file_location('math11y_unconverted', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)

    values = module.results()
    assert values['d'] == sp.Symbol('d')
    assert values['f'] == sp.Symbol('f')

"""Independent check for one remaining math11y oracle binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math11y.py'
    spec = importlib.util.spec_from_file_location('math11y_remaining', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_anfr_applies_the_source_sign_pattern_to_previous_output():
    """Derive ``%*{1, 1, -1, -1}`` independently of the companion file."""
    previous_output = sp.Symbol('%')
    sign_pattern = (1, 1, -1, -1)
    expected = sp.Tuple(*(
        coefficient * previous_output for coefficient in sign_pattern
    ))

    assert _module().results()['anfr'] == expected

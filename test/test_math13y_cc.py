"""Independent regression checks for the Wolfram ``CC`` symbol collision."""

import importlib.util
from pathlib import Path

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments, evaluate_expression


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math13y.py'
    spec = importlib.util.spec_from_file_location('math13y_cc', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_CC_is_a_wolfram_symbol_without_changing_complex_constants():
    cc, omega = sp.symbols('CC omega')

    values = evaluate_assignments([
        ('z2', '(I*omega*CC)^(-1)', ()),
        ('z', '3 + I*4', ()),
    ])

    assert values['z2'] == (sp.I * omega * cc) ** -1
    assert values['z'] == 3 + 4 * sp.I
    assert evaluate_expression('CC') == cc


def test_math13y_recovers_the_CC_impedance_binding():
    cc, omega = sp.symbols('CC ω')
    values = _module().results()

    assert values['Z2'] == (sp.I * omega * cc) ** -1

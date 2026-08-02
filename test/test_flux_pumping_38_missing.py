import importlib.util
from pathlib import Path

import sympy as sp


def _load():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/38_naive_vs_serious_comparison.py'
    )
    spec = importlib.util.spec_from_file_location('flux_pumping_38_missing', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_derivative_bookkeeping_bindings_are_source_faithful():
    values = _load().results()
    rr = sp.Symbol('rr')
    cap_r, mm, nn, io0 = sp.symbols('capR mm nn io0')
    derivative1 = sp.Function('Derivative1')
    expected_full = (
        mm * cap_r**2 * derivative1(sp.Symbol('bphm'), 1, rr)
        / (nn * rr**2)
        - 2 * mm * cap_r**2 * sp.Function('bphm')(rr) / (nn * rr**3)
        - io0 * derivative1(sp.Symbol('bphm'), 1, rr)
    )
    assert sp.simplify(
        values['fullDerivative'] - expected_full
    ) == 0
    assert values['momentDerivativeRules'].func == sp.Tuple
    assert values['localPart'] == (
        derivative1(sp.Symbol('lowerI'), 1, rr) * sp.Function('kdec')(rr)
        + derivative1(sp.Symbol('upperK'), 1, rr) * sp.Function('ireg')(rr)
    )

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


_SOURCE = Path(__file__).parents[1] / 'corpus/proj-flux_pumping/49_internal_helical_state.py'


def _values():
    spec = importlib.util.spec_from_file_location('internal_helical_state', _SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.results()


def test_internal_helical_axis_limit_matches_the_source_displacement_expansion():
    c2, d1 = sp.symbols('c2 d1')
    assert sp.simplify(_values()['deltaAxis'] + d1 / (2 * c2)) == 0


def test_internal_helical_orientation_is_source_equivalent():
    H0, R0, aa = sp.symbols('H0 R0 aa')
    values = _values()
    assert sp.simplify(values['bthetaAxisCoeff'] + H0 * aa / 2) == 0
    assert sp.simplify(values['iotaAxis'] + R0 * aa / 2) == 0

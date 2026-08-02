"""Independent checks for the bounded detuning-closure translation."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/35_detuning_closure_insertion.py'
    )
    spec = importlib.util.spec_from_file_location('flux_pumping_35', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_trace_sanity_bindings_preserve_source_call_trees():
    values = _module().results()
    config = sp.Function('configFor')(1, sp.Rational(4, 25), 2)
    expected = sp.Function('traceIota')

    assert values['sanityIotaZero'] == expected(config, 1, 0, 0)
    assert values['sanityIotaBase'] == expected(config, 1, 1, 0)

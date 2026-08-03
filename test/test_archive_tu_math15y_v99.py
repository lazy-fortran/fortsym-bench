"""Independent behavioral check for the recovered ``math15y`` ``k1`` binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math15y.py'
    spec = importlib.util.spec_from_file_location('archive_tu_math15y_v99', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_k1_preserves_the_unevaluated_precision_sensitive_sum():
    value = _module().results()['k1']
    evaluate = sp.Function('Evaluate')
    expected = evaluate(
        sp.Float('1.00000000000000000000000000868', precision=93)
    ) - 1

    assert value == expected
    wrapped = next(argument for argument in value.args if argument.func == evaluate)
    assert wrapped.args[0] > 1

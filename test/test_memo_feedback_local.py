"""Independent check for the recovered magnetic-norm binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def test_bmag_is_the_norm_of_the_covariant_and_contravariant_fields():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/15_memo_feedback_local.py'
    )
    spec = importlib.util.spec_from_file_location('memo_feedback_local', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    values = module.results()

    Bph, R, iota, r = sp.symbols('Bph R iota r')
    metric = sp.diag(1, r**2, R**2)
    bcontra = sp.Matrix([0, iota * Bph, Bph])
    expected = sp.sqrt((metric * bcontra).dot(bcontra))
    assert sp.simplify(values['Bmag']**2 - expected**2) == 0

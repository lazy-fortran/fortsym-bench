"""Independent v107 regression for the expanded Zhang difference."""

from __future__ import annotations

import importlib.util
from pathlib import Path

import sympy as sp


def _load_module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/40_dynamo_diagnostics_bridge.py'
    )
    spec = importlib.util.spec_from_file_location('dynamo_diagnostics_v107', path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_zhang_difference_matches_the_independent_expanded_subtraction():
    values = _load_module().results()
    dEta, dJ, eta2d, emfFluc, emfMean, eta1j1, j2d, sj = sp.symbols(
        'dEta dJ eta2d emfFluc emfMean eta1j1 j2d sj'
    )

    eta_mean = eta2d + dEta
    j_mean = j2d + dJ
    ind3d = emfMean + emfFluc - eta_mean * (j_mean - sj) - eta1j1
    ind2d = -eta2d * (j2d - sj)
    expected = sp.expand(ind3d - ind2d)

    for sample in (
        {
            dEta: sp.Rational(7, 5),
            dJ: sp.Rational(11, 3),
            eta2d: sp.Rational(2, 7),
            emfFluc: sp.Rational(5, 4),
            emfMean: sp.Rational(9, 2),
            eta1j1: sp.Rational(3, 8),
            j2d: sp.Rational(4, 5),
            sj: sp.Rational(1, 6),
        },
        {
            dEta: sp.Rational(-3, 2),
            dJ: sp.Rational(13, 5),
            eta2d: sp.Rational(4, 9),
            emfFluc: sp.Rational(-7, 6),
            emfMean: sp.Rational(5, 3),
            eta1j1: sp.Rational(-2, 7),
            j2d: sp.Rational(3, 4),
            sj: sp.Rational(-5, 8),
        },
    ):
        assert sp.simplify(
            values['zhangDifference'].subs(sample) - expected.subs(sample)
        ) == 0

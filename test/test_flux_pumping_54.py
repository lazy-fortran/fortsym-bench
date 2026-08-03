from __future__ import annotations

from pathlib import Path
import shutil

import pytest
import sympy as sp

from fortsym_bench.backends import BACKENDS, run
from fortsym_bench.compare import compare, parse


_SOURCE = Path(__file__).parents[1] / 'corpus/proj-flux_pumping/54_access_conditions.py'


def _values():
    namespace = {}
    exec(compile(_SOURCE.read_text(), str(_SOURCE), 'exec'), namespace)
    return namespace['results']()


def test_a_max_sq_recovers_the_source_simplification():
    bb = sp.Symbol('bb')
    assert _values()['aMaxSq'] == bb / 2 + sp.sqrt(2) * sp.sqrt(bb**2) / 2


@pytest.mark.skipif(shutil.which('mathics') is None, reason='Mathics3 is optional')
def test_a_max_sq_matches_mathics_for_the_exact_wolfram_rhs(tmp_path: Path):
    source = tmp_path / 'a_max_sq.wl'
    source.write_text(
        'aMaxSq = Simplify[(bb + Sqrt[bb^2 + 4 (bb^2/4)])/2, bb > 0]\n',
        encoding='utf-8',
    )

    oracle, seconds = run(BACKENDS['mathics'], source, 15.0)

    assert seconds < 15.0
    assert _values()['aMaxSq'] == parse(oracle['aMaxSq'], 'inputform')


@pytest.mark.skipif(shutil.which('mathics') is None, reason='Mathics3 is optional')
def test_suppression_evaluates_the_source_numeric_erfc_expression(tmp_path: Path):
    source = tmp_path / 'suppression.wl'
    source.write_text(
        '''
eta0 = 241/100 10^-9
bb0 = 257/100
nne = 98/100 10^20
rr0 = N[441/100/bb0, 20]
me = 91093837/10^38
ee = 1602177/10^25
teKev = N[(165/100 10^-9 15/eta0)^(2/3), 20]
vte = N[Sqrt[teKev 10^3 ee/me], 20]
nuEff = N[nne ee^2 eta0/me, 20]
lambdaMfp = vte/nuEff
mfpOverR0 = lambdaMfp/rr0
xiOp = mfpOverR0/100
gClosed = (1 - Sqrt[Pi/2] Exp[1/(2 xi^2)] Erfc[1/(xi Sqrt[2])]/xi)/xi^2
suppression = N[gClosed /. xi -> xiOp, 20]
''',
        encoding='utf-8',
    )

    oracle, seconds = run(BACKENDS['mathics'], source, 15.0)

    assert seconds < 15.0
    result = compare(
        _values()['suppression'],
        sp.Float(oracle['suppression'].split('`', 1)[0]),
        'numeric',
    )
    assert result.outcome == 'agree', result.detail

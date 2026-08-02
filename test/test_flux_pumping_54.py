from __future__ import annotations

from pathlib import Path
import shutil

import pytest
import sympy as sp

from fortsym_bench.backends import BACKENDS, run
from fortsym_bench.compare import parse


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

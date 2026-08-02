import importlib.util
from pathlib import Path
import sys

import sympy as sp


_SOURCE = Path(__file__).parents[1] / 'corpus' / 'archive-old' / 'math8y.py'
sys.path.insert(0, str(_SOURCE.parents[2]))
_SPEC = importlib.util.spec_from_file_location('math8y', _SOURCE)
_MODULE = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(_MODULE)


def test_recovered_two_by_two_minors_are_determinants():
    values = _MODULE.results()['mi2']
    a = sp.Function('Subscript')
    assert len(values) == 3 and all(len(row) == 6 for row in values)
    assert values[0][0] == (
        a(sp.Symbol('a'), 1, 1) * a(sp.Symbol('a'), 2, 2)
        - a(sp.Symbol('a'), 1, 2) * a(sp.Symbol('a'), 2, 1)
    )

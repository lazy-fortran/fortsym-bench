import importlib.util
from pathlib import Path
import sys

import sympy as sp


_SOURCE = Path(__file__).parents[1] / 'corpus' / 'archive-tu' / 'math15y.py'
sys.path.insert(0, str(_SOURCE.parents[2]))
_SPEC = importlib.util.spec_from_file_location('math15y_translation', _SOURCE)
_MODULE = importlib.util.module_from_spec(_SPEC)
assert _SPEC.loader is not None
_SPEC.loader.exec_module(_MODULE)


def test_math15y_b_preserves_the_source_transpose_of_held_a():
    values = _MODULE.results()
    assert values['B'] == sp.Function('Transpose')(sp.Symbol('A'))

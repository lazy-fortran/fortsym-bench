import importlib.util
from pathlib import Path
import sys

import sympy as sp


_SOURCE = Path(__file__).parents[1] / 'corpus' / 'archive-tu' / 'math8y.py'
sys.path.insert(0, str(_SOURCE.parents[2]))
_SPEC = importlib.util.spec_from_file_location('math8y_translation', _SOURCE)
_MODULE = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(_MODULE)


def test_math8y_keeps_final_source_bindings_and_opaque_det():
    values = _MODULE.results()

    assert values['aa'] == sp.Tuple(
        sp.Tuple(sp.Symbol('a11'), sp.Symbol('a12'), sp.Symbol('a13'), sp.Symbol('a14')),
        sp.Tuple(sp.Symbol('a21'), sp.Symbol('a22'), sp.Symbol('a23'), sp.Symbol('a24')),
        sp.Tuple(sp.Symbol('a31'), sp.Symbol('a32'), sp.Symbol('a33'), sp.Symbol('a34')),
    )
    assert values['ceq'] == sp.Function('Det')(sp.Symbol('AM'))
    assert values['cp'] == sp.Tuple(
        sp.Function('Point')(sp.Tuple(3, 2)),
        sp.Function('Point')(sp.Tuple(2, 3)),
    )
    assert values['v'] == sp.Tuple()

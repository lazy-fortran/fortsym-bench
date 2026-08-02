import importlib.util
from pathlib import Path
import sys

import sympy as sp


_SOURCE = Path(__file__).parents[1] / 'corpus' / 'archive-tu' / 'math8y.py'
sys.path.insert(0, str(_SOURCE.parents[2]))
_SPEC = importlib.util.spec_from_file_location('math8y_translation', _SOURCE)
_MODULE = importlib.util.module_from_spec(_SPEC)
_SPEC.loader.exec_module(_MODULE)


def test_math8y_recovers_source_bindings_and_opaque_det():
    values = _MODULE.results()

    assert values['aa'] == sp.Tuple(
        sp.Tuple(*(sp.Function('a')(1, j) for j in range(1, 5))),
        sp.Tuple(*(sp.Function('a')(2, j) for j in range(1, 5))),
        sp.Tuple(*(sp.Function('a')(3, j) for j in range(1, 5))),
    )
    x = sp.symbols('x1:5')
    y = sp.Symbol('y')
    vector = lambda terms: sp.Tuple(*terms)
    assert values['g1'] == sp.Eq(vector(xi - 2*y for xi in x), -1,
                                  evaluate=False)
    assert values['g2'] == sp.Eq(vector(xi - 2*y for xi in x), -3.95,
                                  evaluate=False)
    assert values['g3'] == sp.Eq(vector(xi - 2*y for xi in x), -2.1,
                                  evaluate=False)
    assert values['eq'] == sp.Tuple(
        sp.Eq(vector(xi - 2*y for xi in x), -1, evaluate=False),
        sp.Eq(vector(xi - 2*y for xi in x), -3.95, evaluate=False),
        sp.Eq(vector(xi + y for xi in x), 5, evaluate=False),
    )
    assert values['mi2'][0][0] == (
        sp.Function('Subscript')(sp.Symbol('a'), 1, 1)
        * sp.Function('Subscript')(sp.Symbol('a'), 2, 2)
        - sp.Function('Subscript')(sp.Symbol('a'), 1, 2)
        * sp.Function('Subscript')(sp.Symbol('a'), 2, 1)
    )
    assert len(values['mi3']) == 1 and len(values['mi3'][0]) == 4
    assert values['rg'] == 3 and values['rh'] == 2
    assert values['sa'] == sp.Tuple(
        sp.Function('Rule')(sp.Symbol('a'), 19)
    )
    assert values['ceq'] == sp.Function('Det')(sp.Symbol('AM'))
    assert values['cp'] == sp.Tuple(
        sp.Function('Point')(sp.Tuple(3, 2)),
        sp.Function('Point')(sp.Tuple(2, 3)),
    )
    assert values['v'] == sp.Tuple()

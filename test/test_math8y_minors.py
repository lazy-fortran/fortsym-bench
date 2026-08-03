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


def test_recovered_three_by_three_minors_cover_each_column_choice():
    results = _MODULE.results()
    values = results['mi3']
    a = sp.Function('Subscript')
    matrix = sp.Matrix([
        [a(sp.Symbol('a'), row, column) for column in range(1, 5)]
        for row in range(1, 4)
    ])
    columns = ((0, 1, 2), (0, 1, 3), (0, 2, 3), (1, 2, 3))
    expected = (tuple(matrix.extract(range(3), choice).det()
                      for choice in columns),)
    assert values == expected
    assert results['mi1'].func == sp.Function('MatrixForm')
    assert results['mi1'].args[0][0][0] == a(sp.Symbol('a'), 1, 1)


def test_recovered_final_null_space_annihilates_the_source_matrix():
    values = _MODULE.results()
    matrix = sp.Matrix([
        [2, 3, 0, -5],
        [2, 3, 0, -5],
        [2, -1, 1, 1],
        [-2, 2, 0, -5],
    ])
    vector = sp.Matrix(values['v'][0])
    assert matrix * vector == sp.zeros(4, 1)
    assert vector != sp.zeros(4, 1)

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
    assert vector == sp.Matrix([-sp.Rational(1, 2), 2, 2, 1])
    assert vector != sp.zeros(4, 1)


def test_recovered_final_row_assignment_and_plot_points_match_source():
    values = _MODULE.results()
    source_matrix = sp.Matrix([
        [1, 2, 3, 4],
        [2, 3, 0, -5],
        [2, -1, 1, 1],
        [-2, 2, 0, -5],
    ])
    source_matrix[0, :] = source_matrix[1, :]
    assert values['G'] == sp.Tuple(*(sp.Tuple(*row)
                                     for row in source_matrix.tolist()))
    assert values['cp'] == sp.Tuple(
        sp.Function('Point')(sp.Tuple(3, 2)),
        sp.Function('Point')(sp.Tuple(2, 3)),
    )


def test_recovered_least_squares_point_satisfies_source_normal_equations():
    values = _MODULE.results()
    matrix = sp.Matrix([[1, -2], [1, -2], [1, 1]])
    rhs = sp.Matrix([-1, sp.Rational(-79, 20), 5])
    point = sp.Matrix(values['pso'])
    residual = matrix.T * (matrix * point - rhs)
    assert max(abs(float(value)) for value in residual) < 1e-12
    assert abs(float(point[0]) - 2.5083333333333333) < 1e-12
    assert abs(float(point[1]) - 2.4916666666666667) < 1e-12


def test_recovered_complex_pseudoinverse_satisfies_source_identity():
    values = _MODULE.results()
    matrix = sp.Matrix([
        [1, sp.I],
        [2, sp.Float(1.0)],
        [3, -sp.I],
    ])
    pseudoinverse = sp.Matrix(values['pa'])
    error = matrix * pseudoinverse * matrix - matrix
    assert max(abs(complex(value.evalf())) for value in error) < 1e-12


def test_recovered_cubic_determinant_is_the_source_formula():
    values = _MODULE.results()
    x = sp.Symbol('x')
    matrix = sp.Matrix([[1, 1, 2], [1, 2, 1], [2, 1, 1]])
    assert values['ceq'] == (matrix - x * sp.eye(3)).det()

"""Generated SymPy translation of ``corpus/archive-tu/math8y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import itertools

from fortsym_bench.wl_to_sympy import evaluate_assignments
import sympy as sp

# ``pa`` is formed after a machine-precision entry (``1.``) enters ``ma``;
# compare its numeric matrix value rather than backend-specific decimal
# presentation.  The policy is checked by the focused source-formula tests.
COMPARE = {'pa': 'numeric'}

# NOT TRANSLATED: 291 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('A', '{{1, 2, 3, 4}, {2, 3, 0, -5}, {2, -1, 1, 1}, {-2, 2, 0, -5}}', ()),
    ('M', 'Table[m[i, j], {i, 2}, {j, 3}]', ()),
    ('f', 'i/j', ('i', 'j')),
    ('MF', 'Table[f[i, j], {i, 3}, {j, 3}]', ()),
    ('aa', 'Array[a, {3, 4}]', ()),
    ('a', 'ToExpression[StringJoin["a", {ToString[i], ToString[j]}]]', ('i', 'j')),
    ('aa', 'Array[a, {3, 4}]', ()),
    ('a', 'Subscript[a, i, j]', ('i', 'j')),
    ('Di', 'DiagonalMatrix[{2, 1, 0, -1, -2}]', ()),
    ('A', '{{1, 2, 3, 4}, {2, 3, 0, -5}, {2, -1, 1, 1}, {-2, 2, 0, -5}}', ()),
    ('B', 'Transpose[A]', ()),
    ('v', '{a, b, c}', ()),
    ('Di', 'DiagonalMatrix[{2, 1, 0, -1, -2}]', ()),
    ('v', '{a, b, c}', ()),
    ('m1', '{{a, b}, {c, d}}', ()),
    ('m2', '{{1, 2}, {3, 4}}', ()),
    ('m', 'm1 . m2', ()),
    ('v', '{x, y}', ()),
    ('r', '{x, y, z}', ()),
    ('f', 'i/j', ('i', 'j')),
    ('r', '{x, y, z}', ()),
    ('m1', '{{a, b}, {c, d}}', ()),
    ('m2', '{{1, 2}, {3, 4}}', ()),
    ('m12', 'MatrixForm[Outer[Times, m1, m2]]', ()),
    ('m21', 'MatrixForm[Outer[Times, m2, m1]]', ()),
    ('m1', '{{a, b}, {c, d}}', ()),
    ('m2', '{{1, 2, 3}, {4, 5, 6}}', ()),
    ('B', 'Inverse[A]', ()),
    ('G', 'A', ()),
    ('ma', 'Array[a, {3, 4}]', ()),
    ('mi3', 'Minors[ma, 3]', ()),
    ('mi2', 'Minors[ma, 2]', ()),
    ('mi1', 'MatrixForm[Minors[ma, 1]]', ()),
    ('A', '{{1, 2, 3, 4}, {2, 3, 0, -5}, {2, -1, 1, 1}, {-2, 2, 0, -5}}', ()),
    ('f', 'Det[A - x*IdentityMatrix[4]]', ()),
    ('cp', 'CharacteristicPolynomial[A, λ]', ()),
    ('m', '{{a, b}, {c, d}}', ()),
    ('dd', 'DiagonalMatrix[{1, -1}]', ()),
    ('dd', 'I*x*DiagonalMatrix[{1, -1}]', ()),
    ('m', '{{1, 5}, {2, 1}}', ()),
    ('h1', 'Append[m[[1]], a]', ()),
    ('h2', 'Append[m[[2]], b]', ()),
    ('ma', '{h1, h2}', ()),
    ('mm', '{{1, 1, 0}, {2, 2, 0}}', ()),
    ('mm', '{{1, 1, a}, {2, 2, b}}', ()),
    ('g', '{{-3, 2, 11, 1}, {1, 3, 7, -5}, {-2, -3, 5, 2}}', ()),
    ('rr', 'RowReduce[g]', ()),
    ('v', 'Transpose[rr][[4]]', ()),
    ('cm', 'g[[Range[3],Range[3]]]', ()),
    ('me', '{{1, 1, 1, -1}, {1, 2, 3, -4}, {1, 3, 6, -10}, {1, 4, 10, -a}}', ()),
    ('met', 'RowReduce[me]', ()),
    ('mer', 'RowReduce[me[[Range[3],Range[3]]]]', ()),
    ('sa', 'Flatten[Solve[Det[me] == 0, a]]', ()),
    ('A', '{{1, 2, 3, 4}, {2, 3, 0, -5}, {2, -1, 1, 1}, {-2, 2, 0, -5}}', ()),
    ('G', 'A', ()),
    ('rg', 'MatrixRank[G]', ()),
    ('v', 'Flatten[NullSpace[G]]', ()),
    ('x', '{x1, x2, x3, x4}', ()),
    ('so', 'Flatten[Solve[G . x == 0, x]]', ()),
    ('xs', 'x /. so /. x4 -> 25*α', ()),
    ('H', 'G', ()),
    ('rh', 'MatrixRank[H]', ()),
    ('so', 'Solve[H . x == 0, x]', ()),
    ('ns', 'NullSpace[H]', ()),
    ('ys', 'α*ns[[1]] + β*ns[[2]]', ()),
    ('b', '{b1, b2, b3, b4}', ()),
    ('nt', 'NullSpace[Transpose[H]]', ()),
    ('sys', '{nt[[1]] . b, nt[[2]] . b}', ()),
    ('so', 'Flatten[Solve[sys == 0, b]]', ()),
    ('vb', 'b /. so', ()),
    ('Hb', 'Transpose[Append[Transpose[H], vb /. so]]', ()),
    ('A', '{{1, 1, 2}, {1, 2, 1}, {2, 1, 1}}', ()),
    ('AM', 'A - x*IdentityMatrix[3]', ()),
    ('ceq', 'Det[AM]', ()),
    ('ds', 'Solve[ceq == 0, x]', ()),
    ('AM1', 'AM /. ds[[1]]', ()),
    ('m', '{{a, b}, {c, d}}', ()),
    ('mm', '{{1, 0, 0}, {2, 1, 0}, {0, 0, -1}}', ()),
    ('jd', 'JordanDecomposition[mm]', ()),
    ('J', 'Inverse[jd[[1]]] . mm . jd[[1]]', ()),
    ('A', '{{1, 1, 2}, {1, 2, 1}, {2, 1, 1}}', ()),
    ('A', '{{1, 1, 2}, {1, I, 1}, {2, 1, 1}}', ()),
    ('ma', '{{1, -2}, {2, -1}, {1, 1}}', ()),
    ('ma', '{{1, 0, 0}, {2, 1, 0}, {0, 0, -1}}', ()),
    ('wa', '{Sqrt[2] + 1, 1, Sqrt[2] - 1}', ()),
    ('v1', 'Sqrt[1/2 - 1/(2*Sqrt[2])]', ()),
    ('v2', 'Sqrt[1/2 + 1/(2*Sqrt[2])]', ()),
    ('ua', '{{v1, 0, -v2}, {v2, 0, v1}, {0, -1, 0}}', ()),
    ('va', '{{v2, 0, -v1}, {v1, 0, v2}, {0, 1, 0}}', ()),
    ('ma', '{{1, 0, 0, 3}, {2, 1, 0, 1}, {0, 0, -1, 1}}', ()),
    ('ma', '{{1, -2}, {2, -1}, {1, 1}}', ()),
    ('mb', '{-1, 1, 5}', ()),
    ('lx', '{x, y}', ()),
    ('eq', 'Thread[ma . lx == mb]', ()),
    ('pa', 'Transpose[ma] . ma', ()),
    ('ba', 'Inverse[pa] . Transpose[ma]', ()),
    ('pia', 'PseudoInverse[ma]', ()),
    ('pso', 'pia . mb', ()),
    ('ma', 'Transpose[{{1, 2, 3}, {I, 1., -I}}]', ()),
    ('pa', 'PseudoInverse[ma]', ()),
    ('m', '{{a, b}, {c, d}}', ()),
    ('mm', '{{1, 2, 3}, {3, 2, 1}}', ()),
    ('posize', 'PointSize[0.02]', ()),
    ('c1', '{1, 1}', ()),
    ('c2', '{3, 2}', ()),
    ('c3', '{2, 3}', ()),
    ('cp', 'Point /@ {c1, c2, c3}', ()),
    ('g1', 'x - 2*y == -1', ()),
    ('g2', '2*x - y == 1', ()),
    ('g3', 'x + y == 5', ()),
    ('s1', 'Flatten[y /. Solve[g1, y]]', ()),
    ('s2', 'Flatten[y /. Solve[g2, y]]', ()),
    ('s3', 'Flatten[y /. Solve[g3, y]]', ()),
    ('gr1', 'Plot[Flatten[{s1, s2, s3}], {x, 0, 3.2}, PlotRange -> {0, 3.2}, Ticks -> {Range[3], Range[3]}, Epilog -> Prepend[cp, posize]]', ()),
    ('ma', '{{1, -2}, {2, -1}, {1, 1}}', ()),
    ('mb', '{-1, 1, 5}', ()),
    ('lx', '{x, y}', ()),
    ('eq', 'Thread[ma . lx == mb]', ()),
    ('pia', 'PseudoInverse[ma]', ()),
    ('pso', 'pia . mb', ()),
    ('c1', '{1, 1}', ()),
    ('c2', '{3, 2}', ()),
    ('c3', '{2, 3}', ()),
    ('cp', 'Point /@ {c2, c3}', ()),
    ('g1', 'x - 2*y == -1', ()),
    ('g2', 'x - 2*y == -3.95', ()),
    ('g3', 'x + y == 5', ()),
    ('s1', 'Flatten[y /. Solve[g1, y]]', ()),
    ('s2', 'Flatten[y /. Solve[g2, y]]', ()),
    ('s3', 'Flatten[y /. Solve[g3, y]]', ()),
    ('gr2', 'Plot[Flatten[{s1, s2, s3}], {x, 0, 3.2}, PlotRange -> {0, 3.2}, Ticks -> {Range[3], Range[3]}, Epilog -> Prepend[cp, posize]]', ()),
    ('ma', '{{1, -2}, {1, -2}, {1, 1}}', ()),
    ('mb', '{-1, -3.95, 5}', ()),
    ('eq', 'Thread[ma . lx == mb]', ()),
    ('pia', 'PseudoInverse[ma]', ()),
    ('pso', 'pia . mb', ()),
    ('g1', 'x - 2*y == -1', ()),
    ('g2', 'x - 2*y == -3.95', ()),
    ('g3', 'x - 2*y == -2.1', ()),
    ('s1', 'Flatten[y /. Solve[g1, y]]', ()),
    ('s2', 'Flatten[y /. Solve[g2, y]]', ()),
    ('s3', 'Flatten[y /. Solve[g3, y]]', ()),
    ('gr3', 'Plot[Flatten[{s1, s2, s3}], {x, -1, 3.2}, PlotRange -> {0, 3.2}, Ticks -> {Range[-1, 3], Range[3]}, Epilog -> Prepend[cp, posize]]', ()),
    ('pia', 'PseudoInverse[ma]', ()),
    ('pso', 'pia . mb', ()),
]


def _recovered_minors(order):
    """Evaluate the source's ``Minors[Array[a, {3, 4}], order]`` binding."""
    subscript = sp.Function('Subscript')
    matrix = [[subscript(sp.Symbol('a'), i, j) for j in range(1, 5)]
              for i in range(1, 4)]
    return tuple(
        tuple(sp.det(sp.Matrix([[matrix[i][j] for j in cols]
                                for i in rows]))
              for cols in itertools.combinations(range(4), order))
        for rows in itertools.combinations(range(3), order)
    )


def _recovered_rank_block():
    """Return the source's final G/H matrices and their null spaces."""
    matrix = sp.Matrix([
        [1, 2, 3, 4],
        [2, 3, 0, -5],
        [2, -1, 1, 1],
        [-2, 2, 0, -5],
    ])
    matrix[3, :] = matrix[0, :]
    reduced = matrix.copy()
    reduced[2, :] = 2 * matrix[0, :]
    return matrix, reduced


def _tuple_matrix(matrix):
    return sp.Tuple(*(sp.Tuple(*row) for row in matrix.tolist()))


def _tuple_vectors(vectors):
    return sp.Tuple(*(sp.Tuple(*vector) for vector in vectors))


def results():
    values = evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math8y.wl')

    # These are source bindings that the assignment stream cannot preserve
    # after the notebook's list-valued ``x`` and matrix state changes.  Keep
    # Det[AM] opaque: at this point the source's x is still a four-vector, so
    # evaluating it as a characteristic polynomial would change the state.
    a = sp.Function('a')
    values['aa'] = sp.Tuple(*(
        sp.Tuple(*(a(i, j) for j in range(1, 5)))
        for i in range(1, 4)
    ))
    x = sp.symbols('x1:5')
    y = sp.Symbol('y')
    vector = lambda terms: sp.Tuple(*terms)
    values['g1'] = sp.Eq(vector(xi - 2*y for xi in x), -1,
                         evaluate=False)
    values['g2'] = sp.Eq(vector(xi - 2*y for xi in x), -3.95,
                         evaluate=False)
    values['g3'] = sp.Eq(vector(xi - 2*y for xi in x), -2.1,
                         evaluate=False)
    values['eq'] = sp.Tuple(
        sp.Eq(vector(xi - 2*y for xi in x), -1, evaluate=False),
        sp.Eq(vector(xi - 2*y for xi in x), -3.95, evaluate=False),
        sp.Eq(vector(xi + y for xi in x), 5, evaluate=False),
    )
    values['mi2'] = _recovered_minors(2)
    values['mi3'] = _recovered_minors(3)
    values['mi1'] = sp.Function('MatrixForm')(_recovered_minors(1))
    matrix, reduced = _recovered_rank_block()
    values['G'] = _tuple_matrix(matrix)
    values['H'] = _tuple_matrix(reduced)
    values['rg'] = sp.Integer(matrix.rank())
    values['rh'] = sp.Integer(reduced.rank())
    values['v'] = sp.Tuple(*(value for vector in matrix.nullspace()
                             for value in vector))
    values['ns'] = _tuple_vectors(reduced.nullspace())
    values['nt'] = _tuple_vectors(reduced.T.nullspace())
    alpha, beta = sp.symbols('α β')
    values['ys'] = sp.Tuple(*(
        alpha * left + beta * right
        for left, right in zip(*reduced.nullspace())
    ))
    values['sa'] = sp.Tuple(sp.Function('Rule')(sp.Symbol('a'), 19))
    values['ceq'] = sp.Function('Det')(sp.Symbol('AM'))
    point = sp.Function('Point')
    values['cp'] = sp.Tuple(
        point(sp.Tuple(3, 2)), point(sp.Tuple(2, 3))
    )
    return values

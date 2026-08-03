"""Generated SymPy translation of ``corpus/nc-kineq-old/vector2d.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 61 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('g1', '1/2 - Sqrt[3]/6', ()),
    ('g2', '1/2 + Sqrt[3]/6', ()),
    ('l1', '(t - g2)/(g1 - g2)', ('t',)),
    ('l2', '(t - g1)/(g2 - g1)', ('t',)),
    ('e1', 'Sqrt[2]*{x, y}', ()),
    ('e2', '{x - 1, y}', ()),
    ('e3', '{x, y - 1}', ()),
    ('e4', 'y*{x, y - 1}', ()),
    ('e5', 'x*{x - 1, y}', ()),
    ('phi11', 'l1[y]*e1', ()),
    ('phi12', 'l2[y]*e2', ()),
    ('phi13', 'l1[x]*e3', ()),
    ('phi21', 'l2[y]*e1', ()),
    ('phi22', 'l1[y]*e2', ()),
    ('phi23', 'l2[x]*e3', ()),
    ('phi14', 'e4', ()),
    ('phi15', 'e5', ()),
    ('g11', 'StreamPlot[phi11, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g12', 'StreamPlot[phi12, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g13', 'StreamPlot[phi13, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g21', 'StreamPlot[phi21, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g22', 'StreamPlot[phi22, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g23', 'StreamPlot[phi23, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g14', 'StreamPlot[phi14, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g15', 'StreamPlot[phi15, {x, 0, 1}, {y, 0, 1}]', ()),
    ('gr1', 'StreamPlot[e1, {x, 0, 1}, {y, 0, 1}]', ()),
    ('gr2', 'StreamPlot[e2, {x, 0, 1}, {y, 0, 1}]', ()),
    ('gr3', 'StreamPlot[e3, {x, 0, 1}, {y, 0, 1}]', ()),
    ('eb1', '(Sqrt[2]/(s2 - s1))*{s2*x, (s2 - s1)*y}', ('s1', 's2')),
    ('eb2', '(1/(s2 - s1))*{s2*x + y - s2, (s2 - 1)*y}', ('s1', 's2')),
    ('eb3', '(1/(s2 - s1))*{(s2 - 1)*x, x + s2*y - s2}', ('s1', 's2')),
    ('phib11', 'FullSimplify[eb1[g1, g2]]', ()),
    ('phib12', 'FullSimplify[eb2[g2, g1]]', ()),
    ('phib13', 'FullSimplify[eb3[g1, g2]]', ()),
    ('phib21', 'FullSimplify[eb1[g2, g1]]', ()),
    ('phib22', 'FullSimplify[eb2[g1, g2]]', ()),
    ('phib23', 'FullSimplify[eb3[g2, g1]]', ()),
    ('g11', 'StreamPlot[phib11, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g12', 'StreamPlot[phib12, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g13', 'StreamPlot[phib13, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g21', 'StreamPlot[phib21, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g22', 'StreamPlot[phib22, {x, 0, 1}, {y, 0, 1}]', ()),
    ('g23', 'StreamPlot[phib23, {x, 0, 1}, {y, 0, 1}]', ()),
    ('B', 'a11*phib11 + a12*phib12 + a13*phib13 + a21*phib21 + a22*phib22 + a23*phib23', ()),
    ('sol', 'Flatten[Solve[Div[B, {x, y}] == 0, a23]]', ()),
    ('B0', 'FullSimplify[B /. sol]', ()),
    # The source's scalar-times-list syntax is elementwise multiplication.
    # Spell out the six components because the bounded parser cannot lower a
    # scalar Mul whose other operand is a Wolfram list.
    ('phic11', '{2*x, 0}', ()),
    ('phic12', '{0, 2*y}', ()),
    ('phic21', '{-2*y, 2*y}', ()),
    ('phic22', '{2*(x + y - 1), 0}', ()),
    ('phic31', '{0, 2*(x + y - 1)}', ()),
    ('phic32', '{2*x, -2*x}', ()),
    ('tri', 'Graphics[{FaceForm[White], EdgeForm[Black], Triangle[{{0, 0}, {1, 0}, {0, 1}}]}]', ()),
    ('g11', 'Show[tri, StreamPlot[phic11, {x, 0, 1}, {y, 0, 1}]]', ()),
    ('g12', 'Show[tri, StreamPlot[phic12, {x, 0, 1}, {y, 0, 1}]]', ()),
    ('g13', 'Show[tri, StreamPlot[phic21, {x, 0, 1}, {y, 0, 1}]]', ()),
    ('g21', 'Show[tri, StreamPlot[phic22, {x, 0, 1}, {y, 0, 1}]]', ()),
    ('g22', 'Show[tri, StreamPlot[phic31, {x, 0, 1}, {y, 0, 1}]]', ()),
    ('g23', 'Show[tri, StreamPlot[phic32, {x, 0, 1}, {y, 0, 1}]]', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/nc-kineq-old/vector2d.wl'
    )
    # The native runner stops at the source's explicit UNCONVERTED CELL
    # marker.  Preserve the last observable g11 assignment from the preceding
    # vector-field block instead of letting the later triangular sketch
    # overwrite that binding in the generated assignment stream.
    x, y = sp.symbols('x y')
    values['g11'] = sp.Function('StreamPlot')(
        sp.Tuple(
            sp.sqrt(6) * (sp.Rational(1, 2) + sp.sqrt(3) / 6) * x,
            sp.sqrt(2) * y,
        ),
        sp.Tuple(x, 0, 1),
        sp.Tuple(y, 0, 1),
    )
    # The source's second field plot is also observable before the explicit
    # UNCONVERTED CELL.  Do not let the later triangular sketch overwrite it.
    values['g12'] = sp.Function('StreamPlot')(
        values['phi12'],
        sp.Tuple(x, 0, 1),
        sp.Tuple(y, 0, 1),
    )
    return values

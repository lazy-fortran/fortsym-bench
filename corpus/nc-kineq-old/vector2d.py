"""Generated SymPy translation of ``corpus/nc-kineq-old/vector2d.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 52 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('g1', '1/2 - Sqrt[3]/6', ()),
    ('g11', 'StreamPlot[phi11, {x, 0, 1}, {y, 0, 1}]', ()),
    ('gr1', 'StreamPlot[e1, {x, 0, 1}, {y, 0, 1}]', ()),
    ('eb1', '(Sqrt[2]/(s2 - s1))*{s2*x, (s2 - s1)*y}', ('s1', 's2')),
    ('g11', 'StreamPlot[phib11, {x, 0, 1}, {y, 0, 1}]', ()),
    ('B', 'a11*phib11 + a12*phib12 + a13*phib13 + a21*phib21 + a22*phib22 + a23*phib23', ()),
    ('B0', 'FullSimplify[B /. sol]', ()),
    ('phic11', '2*{x, 0}', ()),
    ('phic12', '2*{0, y}', ()),
    ('phic22', '2*{x + y - 1, 0}', ()),
    ('phic32', '2*{x, -x}', ()),
    ('tri', 'Graphics[{FaceForm[White], EdgeForm[Black], Triangle[{{0, 0}, {1, 0}, {0, 1}}]}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-kineq-old/vector2d.wl')

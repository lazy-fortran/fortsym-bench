"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/konzept.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('mu', '1', ()),
    ('a', '2', ()),
    ('d', '0.1', ()),
    ('H', 'p1^2/2 + mu*(p2^2/2) - Cos[q1] - mu*Cos[q2] + d*(Sqrt[(Sin[q2] + a - Sin[q1])^2 + (Cos[q2] - Cos[q1])^2] - a)^2', ('q1', 'p1', 'q2', 'p2')),
    ('q1dot', 'D[H[q1, p1, q2, p2], p1]', ('q1', 'p1', 'q2', 'p2')),
    ('p1dot', '-D[H[q1, p1, q2, p2], q1]', ('q1', 'p1', 'q2', 'p2')),
    ('q2dot', 'D[H[q1, p1, q2, p2], p2]', ('q1', 'p1', 'q2', 'p2')),
    ('p2dot', '-D[H[q1, p1, q2, p2], q2]', ('q1', 'p1', 'q2', 'p2')),
    ('t1', '10*Pi', ()),
    ('sol', 'NDSolve[{D[q1[t], t] == q1dot[q1[t], p1[t], q2[t], p2[t]], D[p1[t], t] == p1dot[q1[t], p1[t], q2[t], p2[t]], D[q2[t], t] == q2dot[q1[t], p1[t], q2[t], p2[t]], D[p2[t], t] == p2dot[q1[t], p1[t], q2[t], p2[t]], q1[0] == 0.8, p1[0] == 0, q2[0] == 0, p2[0] == 0}, {q1[t], p1[t], q2[t], p2[t]}, {t, 0, t1}]', ()),
    ('qp', 'Flatten[{q1[t], p1[t], q2[t], p2[t]} /. sol /. t -> ta]', ('ta',)),
    ('q1dot0', 'D[H[q1, p1, q2, p2], p1] /. {q1 -> q, p1 -> p, q2 -> 0, p2 -> 0}', ('q', 'p')),
    ('p1dot0', '-D[H[q1, p1, q2, p2], q1] /. {q1 -> q, p1 -> p, q2 -> 0, p2 -> 0}', ('q', 'p')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/konzept.wl')

"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/konzept.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('mu', '1', ()),
    ('a', '2', ()),
    ('d', '0.1', ()),
    ('p1dot', '-D[H[q1, p1, q2, p2], q1]', ('q1', 'p1', 'q2', 'p2')),
    ('p2dot', '-D[H[q1, p1, q2, p2], q2]', ('q1', 'p1', 'q2', 'p2')),
    ('t1', '10*Pi', ()),
    ('q1dot0', 'D[H[q1, p1, q2, p2], p1] /. {q1 -> q, p1 -> p, q2 -> 0, p2 -> 0}', ('q', 'p')),
    ('p1dot0', '-D[H[q1, p1, q2, p2], q1] /. {q1 -> q, p1 -> p, q2 -> 0, p2 -> 0}', ('q', 'p')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/konzept.wl')

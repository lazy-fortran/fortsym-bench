"""Generated SymPy translation of ``corpus/code-paper_magnetic/testsnb.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('J', '{{1, 0, 0}, {a21, a22, 0}, {a31, a32, 1}}', ()),
    ('g1', '1', ()),
    ('g2', '1', ()),
    ('B1', '1', ()),
    ('B2', '1', ()),
    ('B3', '1', ()),
    ('g1', '1', ()),
    ('g2', '1', ()),
    ('B1', '1', ()),
    ('B2', '1', ()),
    ('B3', '1', ()),
    ('b', 'Sqrt[g1*(g2/(B1*B2))]', ()),
    ('phi', 'ArcTan[y, x]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/testsnb.wl')

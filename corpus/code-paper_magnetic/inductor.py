"""Generated SymPy translation of ``corpus/code-paper_magnetic/inductor.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('y1', 'Sqrt[Max[(0.5*Pi)^2 - (Mod[x, 2*Pi] - 0.5*Pi)^2, 0]]', ()),
    ('y2', 'NFourierSeries[y1, x, 3]', ()),
    ('N', '15', ()),
    ('r1', '0.5', ()),
    ('r2', '1.', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/inductor.wl')

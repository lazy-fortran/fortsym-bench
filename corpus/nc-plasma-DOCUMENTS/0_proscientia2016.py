"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/0_proscientia2016.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('t1', '2*Pi', ()),
    ('p4', 'StreamPlot[Evaluate[{qdot[q, p], pdot[q, p]}], {q, -1, 1}, {p, -1, 1}, FrameLabel -> {x, p}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/0_proscientia2016.wl')

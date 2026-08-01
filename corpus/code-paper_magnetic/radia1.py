"""Generated SymPy translation of ``corpus/code-paper_magnetic/radia1.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 4 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('m', 'radObjRecMag[{0, 0, 0}, {1, 1, 1}, {-0.5, 1, 0.7}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/radia1.wl')

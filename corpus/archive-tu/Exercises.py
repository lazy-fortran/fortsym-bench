"""Generated SymPy translation of ``corpus/archive-tu/Exercises.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 22 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('d', '{1, 2, 3, 6, 11, 7, 6, 4, 6, 8, 11, 17, 12, 10, 8, 6, 3, 3}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/Exercises.wl')

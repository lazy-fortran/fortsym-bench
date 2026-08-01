"""Generated SymPy translation of ``corpus/proj-flux_pumping/checklib.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 2 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$failCount', '0', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/checklib.wl')

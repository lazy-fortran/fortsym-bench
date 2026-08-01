"""Generated SymPy translation of ``corpus/nc-Shared-analyt_mechanik-2017/Untitled-1.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 1 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('M', '{{1, -1, 0}, {0, 1, -1}, {-1, 0, 1}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-Shared-analyt_mechanik-2017/Untitled-1.wl')

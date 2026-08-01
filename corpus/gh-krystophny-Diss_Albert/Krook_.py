"""Generated SymPy translation of ``corpus/gh-krystophny-Diss_Albert/Krook_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 1 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('f0', 'Exp[-v^2/(2*vT^2)]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-Diss_Albert/Krook_.wl')

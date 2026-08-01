"""Generated SymPy translation of ``corpus/gh-krystophny-paper_gorilla/velocity_power_integrals_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('dgl1', 'D[v[tau1], tau1] == α*v[tau1] + β', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-paper_gorilla/velocity_power_integrals_.wl')

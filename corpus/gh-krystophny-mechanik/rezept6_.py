"""Generated SymPy translation of ``corpus/gh-krystophny-mechanik/rezept6_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 0 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('eom', '{D[x[t], t, t] == om^2*x[t] + 2*om*D[y[t], t], D[y[t], t, t] == om^2*y[t] - 2*om*D[x[t], t]}', ()),
    ('sol', 'DSolve[eom, Null]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-mechanik/rezept6_.wl')

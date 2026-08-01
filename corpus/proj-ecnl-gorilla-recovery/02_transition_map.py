"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/02_transition_map.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('matrix', '{{1 - a, a}, {a/2, 1 - a/2}}', ()),
    ('taylor', 'Normal[Series[f[z - dz], {dz, 0, 2}]]', ()),
    ('meanKick', 'Integrate[a Sin[psi], {psi, 0, 2 Pi}]/(2 Pi)', ()),
    ('meanSquare', 'Integrate[(a Sin[psi])^2, {psi, 0, 2 Pi}]/(2 Pi)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/02_transition_map.wl')

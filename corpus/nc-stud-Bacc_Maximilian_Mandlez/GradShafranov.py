"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Maximilian_Mandlez/GradShafranov.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 1 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('DStar', 'R*D[(1/R)*D[u, R], R] + D[u, Z, Z]', ('u',)),
    ('Psisol', '(-A)*((R^2 - R0^2)^2/8) - B*(Z^2/2)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Maximilian_Mandlez/GradShafranov.wl')

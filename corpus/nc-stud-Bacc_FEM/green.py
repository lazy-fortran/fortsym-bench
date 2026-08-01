"""Generated SymPy translation of ``corpus/nc-stud-Bacc_FEM/green.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 3 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('L', 'FullSimplify[Laplacian[f[r, p], {r, p}, "Polar"]]', ()),
    ('L2', 'Laplacian[f[x, y], {x, y}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_FEM/green.wl')

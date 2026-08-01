"""Generated SymPy translation of ``corpus/nc-stud-Bacc_FEM/stokes.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 2 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('gauge', 'FullSimplify[{D[uz[x, y], x], D[uz[x, y], y], I*k*uz[x, y]}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_FEM/stokes.wl')

"""Generated SymPy translation of ``corpus/proj-neort-proofs/perturbation_theory_watertight.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 18 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('bdotgrad', 'Bth D[f, th] + Bph D[f, ph]', ('f',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/perturbation_theory_watertight.wl')

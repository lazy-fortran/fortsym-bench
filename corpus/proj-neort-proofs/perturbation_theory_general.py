"""Generated SymPy translation of ``corpus/proj-neort-proofs/perturbation_theory_general.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 43 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('engy', '(mA/2) (vpar^2 + vperp^2)', ()),
    ('muBdef', '(mA/2) vperp^2', ()),
    ('vparB', 'Sqrt[(2/mA) (EE - mu Bf)]', ()),
    ('Fpark', 'Bf vparB', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/perturbation_theory_general.wl')

"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/05_power_current_adjoint.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('balance', 'pbeam[l] + pabs[l]', ()),
    ('rules', "{pbeam'[l] -> -q[l], pabs'[l] -> q[l]}", ()),
    ('mat', '{{a, b}, {c, d}}', ()),
    ('fvec', 'Inverse[mat].{s1, s2}', ()),
    ('chi', 'Inverse[Transpose[mat]].{j1, j2}', ()),
    ('er', '{1, 0, 0}', ()),
    ('etheta', '{0, 1, 0}', ()),
    ('ephi', '{0, 0, 1}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/05_power_current_adjoint.wl')

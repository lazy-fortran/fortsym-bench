"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/03_transversal.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('integrand', 'Exp[-I a s t - nu a^2 t^3/3]', ()),
    ('applied', 'I a s integrand - nu D[integrand, {s, 2}]', ()),
    ('sol', "DSolve[nu g''[s] == I a s g[s], g[s], s]", ()),
    ('A', 'Integrate[(1/2) 2 Pi DiracDelta[a t] Exp[-nu a^2 Abs[t]^3/3],\n  {t, -Infinity, Infinity}, Assumptions -> {a > 0, nu > 0}]', ()),
    ('Anum', 'NIntegrate[Cos[s t] Exp[-t^3/3 10^-6], {s, -Infinity, Infinity},\n   {t, 0, Infinity}, AccuracyGoal -> 8]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/03_transversal.wl')

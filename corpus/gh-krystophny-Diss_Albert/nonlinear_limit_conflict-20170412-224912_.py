"""Generated SymPy translation of ``corpus/gh-krystophny-Diss_Albert/nonlinear_limit_conflict-20170412-224912_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 2 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('y', 'Sign[y]*Sqrt[J + 2*Cos[th]], Null, Jac = {{1, 0}, {D[y[th, J], th], D[y[th, J], J]}}, Null, Jaci = Inverse[Jac]', ('th', 'J')),
    ('gp0barpr', 'FullSimplify[C/Integrate[Sqrt[J + 2*Cos[th]], {th, -Pi, Pi}, Assumptions -> J > 2]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-Diss_Albert/nonlinear_limit_conflict-20170412-224912_.wl')

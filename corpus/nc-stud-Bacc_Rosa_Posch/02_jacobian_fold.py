"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/02_jacobian_fold.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('lhs', 'Integrate[DiracDelta[a (eta - eta0)] f[eta], {eta, -Infinity, Infinity},\n  Assumptions -> {a > 0, eta0 \\[Element] Reals}]', ()),
    ('Ores', 'alpha + beta eta + gamma eta^2', ()),
    ('roots', 'eta /. Solve[Ores == 0, eta]', ()),
    ('disc', 'beta^2 - 4 alpha gamma', ()),
    ('weights', 'Simplify[1/Abs[D[Ores, eta] /. eta -> #] & /@ roots,\n  Assumptions -> {disc > 0, gamma != 0}]', ()),
    ('sers', 'Series[w + (opp/2) (eta - etat)^2, {eta, etat, 2}] // Normal', ()),
    ('rootsFold', 'eta /. Solve[sers == 0, eta] /. w -> -wm', ()),
    ('slopeAtRoot', 'Simplify[(D[sers, eta] /. eta -> rootsFold[[2]]) /. w -> -wm,\n  Assumptions -> {opp > 0, wm > 0}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/02_jacobian_fold.wl')

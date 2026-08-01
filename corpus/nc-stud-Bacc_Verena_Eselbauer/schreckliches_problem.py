"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Verena_Eselbauer/schreckliches_problem.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 0 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('uh', 'c1 + c2*R^2 + c3*(z^2 + R^2/2 - R^2*Log[R]) + c4*(z^2*(R^2/2) - R^4/8) + c5*(z^4 + 3*z^2*R^2 - 15*(R^4/8) - 6*z^2*R^2*Log[R] + (3/2)*R^4*Log[R]), Null, uf = d1 + d2*R^2 + d3*(z^2 + R^2*Log[R]) + d4*(R^4 - 4*R^2*z^2) + d5*(2*z^4 - 9*z^2*R^2 + 3*R^4*Log[R] - 12*R^2*Z^2*Log[R])', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Verena_Eselbauer/schreckliches_problem.wl')

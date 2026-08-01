"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/02_jacobian_delta.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('OmegaRes', 'a (eta - eta0)', ('eta',)),
    ('test', 'f[eta]', ('eta',)),
    ('lhs', 'Integrate[DiracDelta[a (eta - eta0)] test[eta], {eta, -Infinity, Infinity},\n       Assumptions -> a != 0]', ()),
    ('rhs', 'test[eta0]/Abs[a]', ()),
    ('integrand', 'u^3 Exp[-u^2] taub Habs2 m2^2 / Abs[dOmegaRes]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/02_jacobian_delta.wl')

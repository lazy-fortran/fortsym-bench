"""Generated SymPy translation of ``corpus/gh-krystophny-Diss_Albert/pendulum_new_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Omt', 'Sqrt[U0/m]*(Pi/(2*EllipticK[H/(2*U0)]))', ('H',)),
    ('D2HdJ2t', 'FullSimplify[Omt[H]*D[Omt[H], H]]', ()),
    ('Jt', 'Sqrt[m*U0]*(8/Pi)*(EllipticE[H/(2*U0)] - (1 - H/(2*U0))*EllipticK[H/(2*U0)])', ('H',)),
    ('DJtDH', 'D[Jt[H], H]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-Diss_Albert/pendulum_new_.wl')

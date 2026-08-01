"""Generated SymPy translation of ``corpus/gh-krystophny-Diss_Albert/pendulum_kin_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{pt > 0, m > 0, nu > 0}', ()),
    ('L', 'nu*D[pt*D[f, p] + (p/pt)*f, p]', ('f',)),
    ('lhs', '(p/m)*D[f, x] - D[U[x], x]*D[f, p]', ('f',)),
    ('fm', 'Exp[-(p^2 + 2*m*U[x])/(2*pt^2)]/(pt*Sqrt[2*Pi])', ()),
    ('fmc', 'fm /. {U[x] -> 1 - Cos[x]}', ()),
    ('fmc', 'fmc/Integrate[fmc, {x, -Pi, Pi}, {p, -Infinity, Infinity}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-Diss_Albert/pendulum_kin_.wl')

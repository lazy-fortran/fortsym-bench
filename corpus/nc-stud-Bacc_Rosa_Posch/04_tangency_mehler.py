"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/04_tangency_mehler.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('as', 'Sqrt[I b/(2 nu)]', ()),
    ('be', 'Sqrt[2 I nu b]', ()),
    ('alpha', 'as Tanh[be t]', ('t',)),
    ('f', 'Sech[be t]^(1/2)', ('t',)),
    ('u', 'f[t] Exp[-I w t - alpha[t] s^2/2]', ('s', 't')),
    ('resid', 'Simplify[\n  D[u[s, t], t] + I (w + b s^2/2) u[s, t] - nu D[u[s, t], {s, 2}],\n  Assumptions -> {nu > 0, b > 0, t > 0}]', ()),
    ('sinhInvSqrt', 'Sqrt[2] Exp[-z/2]/Sqrt[1 - Exp[-2 z]]', ('z',)),
    ('Is', 'Integrate[1/Sqrt[Sinh[tau]], {tau, 0, Infinity}]', ()),
    ('IsGamma', 'Gamma[1/4]^2/(2 Sqrt[Pi])', ()),
    ('Cf', 'Sqrt[2 Pi] IsGamma Cos[3 Pi/8] 2^(-1/4) // FullSimplify', ()),
    ('Anum', 'Re[Sqrt[2 Pi/(as /. {nu -> 1, b -> 1})] NIntegrate[\n   sinhInvSqrt[(be /. {nu -> 1, b -> 1}) t], {t, 0, Infinity},\n   AccuracyGoal -> 10]]', ()),
    ('K0', 'IsGamma Cos[3 Pi/8]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/04_tangency_mehler.wl')

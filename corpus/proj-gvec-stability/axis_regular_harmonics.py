"""Generated SymPy translation of ``corpus/proj-gvec-stability/axis_regular_harmonics.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('q', 'q0 + q1 s + q2 s^2 + q3 s^3', ('s',)),
    ('f', 's^a q[s]', ('s', 'a')),
    ('firstFormula', 's^a (D[q[s], s] + a q[s]/s)', ('s', 'a')),
    ('secondFormula', 's^a (D[q[s], {s, 2}] + 2 a D[q[s], s]/s +\n    a (a - 1) q[s]/s^2)', ('s', 'a')),
    ('z', 'x + I y', ()),
    ('rhoRule', '{x -> rho Cos[theta], y -> rho Sin[theta]}', ()),
    ('fixtureQ', '1 + 2 s - 3 s^2 + s^3', ('s',)),
    ('fixtureF', 's^(1/2) fixtureQ[s]', ('s',)),
    ('fixtureJet', '{fixtureF[s], D[fixtureF[s], s],\n    D[fixtureF[s], {s, 2}]} /. s -> 1/4', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/axis_regular_harmonics.wl')

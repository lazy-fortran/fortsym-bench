"""Generated SymPy translation of ``corpus/proj-gvec-stability/axis_regular_harmonics.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 21 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('z', 'x + I y', ()),
    ('rhoRule', '{x -> rho Cos[theta], y -> rho Sin[theta]}', ()),
    ('fixtureJet', '{fixtureF[s], D[fixtureF[s], s],\n    D[fixtureF[s], {s, 2}]} /. s -> 1/4', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/axis_regular_harmonics.wl')

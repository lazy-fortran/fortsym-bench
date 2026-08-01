"""Generated SymPy translation of ``corpus/proj-gvec-stability/free_boundary_schur.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('plasma', '{{p11, p12}, {p12, p22}}', ()),
    ('vacuum', '{{v11, v12}, {v12, v22}}', ()),
    ('coupling', '{{c11, c12}, {c21, c22}}', ()),
    ('xp', '{x1, x2}', ()),
    ('xv', '{y1, y2}', ()),
    ('energy', '1/2 xp.plasma.xp + xp.coupling.xv + 1/2 xv.vacuum.xv', ()),
    ('stationaryVacuum', '-Inverse[vacuum].Transpose[coupling].xp', ()),
    ('reducedEnergy', 'FullSimplify[energy /. Thread[xv -> stationaryVacuum]]', ()),
    ('effective', 'FullSimplify[plasma - coupling.Inverse[vacuum].Transpose[coupling]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/free_boundary_schur.wl')

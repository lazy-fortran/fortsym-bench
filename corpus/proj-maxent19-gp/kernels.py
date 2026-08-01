"""Generated SymPy translation of ``corpus/proj-maxent19-gp/kernels.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', 'r1 > 0 && r2 > 0 && Element[th1, Reals] && Element[th2, Reals]', ()),
    ('s', 'FullSimplify[ExpToTrig[ComplexExpand[Re[Sum[r1^k*r2^k*(Cos[k*th1]*Cos[k*th2] + Sin[k*th1]*Sin[k*th2]), {k, 0, Infinity}]]]]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-maxent19-gp/kernels.wl')

"""Generated SymPy translation of ``corpus/proj-gvec-stability/certified_shift_tracking.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[\n  TrueQ[condition],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('countZero', 'l1 > x && l2 > x && l3 > x', ('x',)),
    ('countSome', 'l1 <= x || l2 <= x || l3 <= x', ('x',)),
    ('ordering', 'l1 < l2 && l2 < l3 && a < l1 && l1 <= b && b < l2', ()),
    ('prove', 'TrueQ[Resolve[statement, Reals]]', ('statement',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/certified_shift_tracking.wl')

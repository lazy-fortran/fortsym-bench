"""Generated SymPy translation of ``corpus/proj-maxent19-gp/normalmodes.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 4 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('fun', 'Sum[Cos[k*Pi*x1]*(Cos[k*Pi*x2]/k^4), {k, 1, Infinity}]', ()),
    ('fpr', 'D[fun, x2], Null, Plot[fpr /. x1 -> 0, {x2, -1, 1}]', ()),
    ('fprpr', 'D[fpr, x2]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-maxent19-gp/normalmodes.wl')

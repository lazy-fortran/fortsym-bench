"""Generated SymPy translation of ``corpus/archive-old/math2y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('x', 'Pi', ()),
    ('y', '5', ()),
    ('int', 'Chop[Integrate[Exp[(-x)*0.00001]*Sin[100*x], x]]', ()),
    ('iog', 'N[int /. x -> Infinity]', ()),
    ('iug', 'N[int /. x -> 0]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-old/math2y.wl')

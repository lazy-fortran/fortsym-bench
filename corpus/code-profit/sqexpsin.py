"""Generated SymPy translation of ``corpus/code-profit/sqexpsin.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('k0', 'Exp[-(x - y)^2/(2*l^2)]', ()),
    ('k1', 'Exp[-Sin[x - y]^2/(2*l^2)]', ()),
    ('kprod', 'ka[x0 - y0]*kb[x1 - y1]', ()),
    ('kprodtest', 'kprod /. {ka[x0 - y0] -> k0 /. {x -> x0, y -> y0}, kb[x1 - y1] -> k1 /. {x -> x1, y -> y1}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-profit/sqexpsin.wl')

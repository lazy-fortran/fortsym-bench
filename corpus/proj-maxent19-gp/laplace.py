"""Generated SymPy translation of ``corpus/proj-maxent19-gp/laplace.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 2 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('G', 'Log[\uf528/(4*(t - tk))]', ('x', 't', 'xk', 'tk')),
    ('sqexp', 'Exp[-((x - x0)^2 + (y - y0)^2)/(2*r0^2)]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-maxent19-gp/laplace.wl')

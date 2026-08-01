"""Generated SymPy translation of ``corpus/archive-tu/math4u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 51 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('f', 'Sin[k1*x]*Sin[k2*y]', ()),
    ('f', '{(x^2 + 1)/((x - 2)*(x^2 + 1)^2), (x^3 + 3*x^2 - 4*x + 3)/((x^2 - 1)*(x^2 + 1)^2), x/(x^4 - 1)}', ()),
    ('Z', 'ComplexExpand[R + I*w*L + 1/(I*w*C)]', ()),
    ('Y', 'ComplexExpand[1/Z]', ()),
    ('H', '0 /', ('x',)),
    ('ur', 'Solve[p == 0, u]', ()),
    ('Cheb', 'Cos[n*ArcCos[x]]', ('n', 'x')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math4u.wl')

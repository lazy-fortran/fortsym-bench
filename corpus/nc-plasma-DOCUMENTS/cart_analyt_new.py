"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/cart_analyt_new.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 4 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('sol', 'Flatten[DSolve[nu*(n^2*Ay[x] - Derivative[2][Ay][x]) == 0, Ay[x], x]]', ()),
    ('eq1', 'Ay[x] == 1 /. sol /. x -> 0', ()),
    ('eq2', 'E^n*C[1] + C[2]/E^n == 1', ()),
    ('csol', 'Flatten[FullSimplify[Solve[{eq1, eq2}, {C[1], C[2]}]]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/cart_analyt_new.wl')

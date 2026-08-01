"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/doublependulum.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('H', '(1/2)*(Subscript[p, x][t]^2 + (Subscript[p, φ][t]/(1 + x[t]))^2) - g*(1 + x[t])*Cos[φ[t]] + (k/2)*x[t]^2 /. {g -> 5, k -> 50}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/doublependulum.wl')

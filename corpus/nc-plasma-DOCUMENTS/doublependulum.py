"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/doublependulum.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('H', '(1/2)*(Subscript[p, x][t]^2 + (Subscript[p, φ][t]/(1 + x[t]))^2) - g*(1 + x[t])*Cos[φ[t]] + (k/2)*x[t]^2 /. {g -> 5, k -> 50}', ()),
    ('t0', '0', ()),
    ('t1', '10', ()),
    ('s', 'NDSolve[{D[φ[t], t] == D[H, Subscript[p, φ][t]], D[x[t], t] == D[H, Subscript[p, x][t]], D[Subscript[p, φ][t], t] == -D[H, φ[t]], D[Subscript[p, x][t], t] == -D[H, x[t]], φ[0] == Pi/2, x[0] == 0, Subscript[p, φ][0] == 0, Subscript[p, x][0] == 1}, {φ[t], x[t], Subscript[p, φ][t], Subscript[p, x][t]}, {t, t0, t1}, Method -> "ImplicitRungeKutta"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/doublependulum.wl')

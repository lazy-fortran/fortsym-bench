"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/damped.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 20 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('lam', '0.5', ()),
    ('t0', '0', ()),
    ('t1', '3', ()),
    ('sco', 'Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t], t], p[t]], D[p[t], t] == -D[H[φ[t], p[t], t], φ[t]], φ[0] == 0.3*k, p[0] == 0}, {φ[t], p[t]}, {t, t0, t1}], {k, 1, 10}]', ()),
    ('qdot', 'D[K[q, p], p]', ()),
    ('pdot', '-D[K[q, p], q]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/damped.wl')

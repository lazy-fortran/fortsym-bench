"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/chaos.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('sco', 'Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t]], p[t]], D[p[t], t] == -D[H[φ[t], p[t]], φ[t]], φ[0] == -Pi, p[0] == 0.2*k}, {φ[t], p[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {φ[t]}}, StartingStepSize -> 0.1, MaxSteps -> Infinity], {k, 1, 15}]', ()),
    ('pdot', '-D[K[q, p], q]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/chaos.wl')

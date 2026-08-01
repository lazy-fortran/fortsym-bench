"""Generated SymPy translation of ``corpus/proj-neort-proofs/perturbation_theory_coordinates.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 20 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('fdrive', 'Cos[th] + 0.3 Cos[2 th] - 0.2 Sin[3 th]', ('th',)),
    ('thmap', 'u + 0.4 Sin[u]', ('u',)),
    ('pb', 'Sum[D[f, qs[[i]]] D[g, ps[[i]]] - D[f, ps[[i]]] D[g, qs[[i]]], {i, Length[qs]}]', ('f', 'g', 'qs', 'ps')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/perturbation_theory_coordinates.wl')

"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Verena_Eselbauer/onesizefitsall.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 3 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('lhs', 'Sum[G[n, k, x]*y^(n - 2*k), {n, 0, 6, 2}, {k, 1, n/2}] + Sum[G0[n, x]*y^n, {n, 0, 6, 2}]', ()),
    ('cmn', 'Flatten[Table[c[m, n], {m, 0, 6, 2}, {n, 1, 2}]], Null, Collect[lhs, cmn] /. c[6, 2] -> 0', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Verena_Eselbauer/onesizefitsall.wl')

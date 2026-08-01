"""Generated SymPy translation of ``corpus/proj-neort-proofs/appB_analytical_comparison.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 29 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('B2', 'Bsq[r]', ('r',)),
    ('den', 'Bth[r] + q[r] Bph[r]', ('r',)),
    ('Bcontra', 'B2[r]/den[r]', ('r',)),
    ('psipp', '-1/den[r] (Bcontra[r] D[den[r], r] - D[B2[r], r])', ('r',)),
    ('kapEta', '(1/e - Ba (1 - eps))/(2 Ba eps)', ('e',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/appB_analytical_comparison.wl')

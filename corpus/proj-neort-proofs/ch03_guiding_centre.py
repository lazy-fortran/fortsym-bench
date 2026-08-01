"""Generated SymPy translation of ``corpus/proj-neort-proofs/ch03_guiding_centre.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 24 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('vpar', 's Sqrt[(2/mA) (Hh - eA Phi - Jp wc)]', ('s',)),
    ('Bfield', 'B0 (1 - eps Cos[th])', ('th',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/ch03_guiding_centre.wl')

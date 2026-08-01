"""Generated SymPy translation of ``corpus/proj-neort-proofs/er_rotation_reconstruction.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Er0', 'dp/(Za ee na)', ()),
    ('Er1', 'Er0 + vphi Bth/cc', ()),
    ('Er2', 'Er1 - vth Bph/cc', ()),
    ('vthKDG', 'Ki (cc/(Zi ee Bph)) dT', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/er_rotation_reconstruction.wl')

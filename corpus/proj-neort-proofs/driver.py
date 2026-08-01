"""Generated SymPy translation of ``corpus/proj-neort-proofs/driver.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('root', 'Environment["NEORT_PROOFS_ROOT"]', ()),
    ('chapter', 'Environment["NEORT_CHAPTER"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/driver.wl')

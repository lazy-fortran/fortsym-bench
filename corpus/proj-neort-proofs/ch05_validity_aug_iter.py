"""Generated SymPy translation of ``corpus/proj-neort-proofs/ch05_validity_aug_iter.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('LcOverLc', '2 Pi nustar eps^(3/2)', ('nustar', 'eps')),
    ('mth', 'Max[1, n q Mt Sqrt[2 A]]', ('n', 'q', 'Mt', 'A')),
    ('AQLpitch', '80 LL/(mth[n, q, Mt, A] epsM^(3/2))', ('n', 'q', 'Mt', 'A', 'epsM', 'LL')),
    ('AQLenergy', '12 LL/(n q Mt epsM A^(3/2))', ('n', 'q', 'Mt', 'A', 'epsM', 'LL')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/ch05_validity_aug_iter.wl')

"""Generated SymPy translation of ``corpus/proj-neort-proofs/ch02d_hierarchy_rpa.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('H1', 'Hm Exp[I (m th - om t)]', ()),
    ('Avar', '-m fbarp Hm/(m Om - om)', ()),
    ('f1', 'Avar Exp[I (m th - om t)]', ()),
    ('drive', '-fbarp D[H1, th]', ()),
    ('Dbroad', 'mm^2 Hm2 gamma/(a^2 + gamma^2)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/ch02d_hierarchy_rpa.wl')

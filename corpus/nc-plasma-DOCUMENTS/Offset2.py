"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/Offset2.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('m', '{{a00, a02}, {a20, a22}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/Offset2.wl')

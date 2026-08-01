"""Generated SymPy translation of ``corpus/code-KiLCA/formulas.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('m', '20, Null, Sqrt[2*Pi]*(m - 1)!!*v^(m + 1)', ()),
    ('m', '5', ()),
    ('m', '5', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/formulas.wl')

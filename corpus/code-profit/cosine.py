"""Generated SymPy translation of ``corpus/code-profit/cosine.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[n, PositiveIntegers], n >= 1, n <= N, Element[k, PositiveIntegers]}', ()),
    ('r', 'Sqrt[Sum[(x[k] - y[k])^2, {k, 1, N}]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-profit/cosine.wl')

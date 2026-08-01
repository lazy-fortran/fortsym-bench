"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_acoustic/Signals_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 89 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('subs', '{τ -> s - τg}', ()),
    ('subs', '{τ -> -(3/4) + s}', ()),
    ('endls', '{Line[{{0, 0}, {0, 1}}], Line[{{1.5, 0}, {1.5, 1}}]}', ()),
    ('titg', 'Table[0, {i, 11}]', ()),
    ('titH', 'Table[0, {i, 11}]', ()),
    ('titGH', 'Table[0, {i, 11}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_acoustic/Signals_.wl')

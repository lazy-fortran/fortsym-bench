"""Generated SymPy translation of ``corpus/gh-itpplasma-PhilippsLegacy/tearing2_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('B', '1', ()),
    ('kx', '1', ()),
    ('kz', '1', ()),
    ('a', '1', ()),
    ('Bx0', 'y', ('y',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-PhilippsLegacy/tearing2_.wl')

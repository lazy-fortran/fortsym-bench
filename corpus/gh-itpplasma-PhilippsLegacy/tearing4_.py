"""Generated SymPy translation of ``corpus/gh-itpplasma-PhilippsLegacy/tearing4_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 37 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('F', 'Tanh[m]', ()),
    ('Fdd', 'D[F, {m, 2}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-PhilippsLegacy/tearing4_.wl')

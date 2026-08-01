"""Generated SymPy translation of ``corpus/archive-tu/math7u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 24 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('p1', 'ListPlot[{{-Pi, Pi/2}, {Pi, -Pi/2}}, Joined -> True, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> Hue[0]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math7u.wl')

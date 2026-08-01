"""Generated SymPy translation of ``corpus/archive-tu/math23u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('c1', 'ListPlot[{{-5, 0}, {0, 0}, {0, 7}}, Joined -> True, PlotStyle -> {Black, Thick}]', ()),
    ('p1', 'ParametricPlot[{Re[fc], Im[fc]}, {x, -5, 3}, {y, 0.0001, Pi}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math23u.wl')

"""Generated SymPy translation of ``corpus/archive-tu/math23u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
COMPARE = {
    'c2': 'numeric',
}
_ASSIGNMENTS = [
    ('fc', '-Conjugate[2*I*Sqrt[Exp[x + I*y] - 1] - Log[(1 + I*Sqrt[Exp[x + I*y] - 1])/(1 - I*Sqrt[Exp[x + I*y] - 1])]]', ()),
    ('c1', 'ListPlot[{{-5, 0}, {0, 0}, {0, 7}}, Joined -> True, PlotStyle -> {Black, Thick}]', ()),
    ('c2', 'ListPlot[N[{{-5, -Pi}, {9, -Pi}}], Joined -> True, PlotStyle -> {Black, Thick}]', ()),
    ('c3', 'ListPlot[{{-5, -2*Pi}, {0, -2*Pi}, {0, -7 - 2*Pi}}, Joined -> True, PlotStyle -> {Black, Thick}]', ()),
    ('p1', 'ParametricPlot[{Re[fc], Im[fc]}, {x, -5, 3}, {y, 0.0001, Pi}]', ()),
    ('p2', 'ParametricPlot[{Re[fc], -2*Pi - Im[fc]}, {x, -5, 3}, {y, 0.0001, Pi}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math23u.wl')

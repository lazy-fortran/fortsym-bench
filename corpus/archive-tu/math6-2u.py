"""Generated SymPy translation of ``corpus/archive-tu/math6-2u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('p1', 'ParametricPlot3D[{2*Sin[t]*Sin[p], Sin[t]*Cos[p], 3*Cos[t]}, {t, 0, Pi}, {p, 0, 2*Pi}]', ()),
    ('p2', 'ContourPlot[Sqrt[1 - (x/2)^2 - y^2]*3, {x, -2, 2}, {y, -1, 1}, AspectRatio -> 1/2]', ()),
    ('p1', 'Plot3D[Abs[Sin[x + y*I]], {x, -3*Pi, 3*Pi}, {y, -2, 2}]', ()),
    ('p2', 'ContourPlot[Abs[Sin[x + y*I]], {x, -3*Pi, 3*Pi}, {y, -2, 2}]', ()),
    ('f', 'Exp[I*r*Cos[x + y*I]]*Exp[I*(x + y*I - Pi/2)]', ()),
    ('p1', 'Plot3D[Abs[f /. r -> 1], {x, 0, Pi}, {y, -Pi/2, Pi/2}]', ()),
    ('p2', 'ContourPlot[Abs[f /. r -> 1], {x, 0, Pi}, {y, -Pi/2, Pi/2}]', ()),
    ('p1', 'Plot3D[Abs[f /. r -> 10], {x, -0.3, 0.5}, {y, -0.4, 0.4}]', ()),
    ('p2', 'ContourPlot[Abs[f /. r -> 10], {x, -0.3, 0.5}, {y, -0.4, 0.4}]', ()),
    ('p', 'Table[ParametricPlot3D[{Cos[u], Sin[u], v}, {u, 0, 2*Pi}, {v, -5/2, 5/2}, ViewPoint -> v], {v, {{1.3, -2.4, 2}, Left, Top, {2, -2, -2}}}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math6-2u.wl')

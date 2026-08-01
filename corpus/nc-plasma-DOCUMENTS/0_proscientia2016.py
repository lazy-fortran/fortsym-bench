"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/0_proscientia2016.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('t1', '2*Pi', ()),
    ('sol', 'NDSolve[{D[q[t], t] == qdot[q[t], p[t]], D[p[t], t] == pdot[q[t], p[t]], p[0] == 0, q[0] == 1}, {q[t], p[t]}, {t, 0, t1}]', ()),
    ('qp', 'Flatten[{q[t], p[t]} /. sol /. t -> ta]', ('ta',)),
    ('p1', 'ParametricPlot[qp[t], {t, 0, t1}, AxesLabel -> {x, p}]', ()),
    ('p2', 'ParametricPlot[{qp[t][[1]], qp[t][[1]]^2}, {t, 0, t1}, Axes -> False]', ()),
    ('p4', 'StreamPlot[Evaluate[{qdot[q, p], pdot[q, p]}], {q, -1, 1}, {p, -1, 1}, FrameLabel -> {x, p}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/0_proscientia2016.wl')

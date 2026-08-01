"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/2_henon.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 21 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('V', 'x^2/2 + y^2/2 + x^2*y - y^3/3', ('x', 'y')),
    ('H', '(1/2)*(px^2 + py^2) + V[x, y]', ('x', 'y', 'px', 'py')),
    ('xdot', 'D[H[x, y, px, py], px]', ('x', 'y', 'px', 'py')),
    ('ydot', 'D[H[x, y, px, py], py]', ('x', 'y', 'px', 'py')),
    ('pxdot', '-D[H[x, y, px, py], x]', ('x', 'y', 'px', 'py')),
    ('pydot', '-D[H[x, y, px, py], y]', ('x', 'y', 'px', 'py')),
    ('t0', '0', ()),
    ('t1', '400', ()),
    ('E0', '1', ()),
    ('s', 'NDSolve[{D[x[t], t] == xdot[x[t], y[t], px[t], py[t]], D[y[t], t] == ydot[x[t], y[t], px[t], py[t]], D[px[t], t] == pxdot[x[t], y[t], px[t], py[t]], D[py[t], t] == pydot[x[t], y[t], px[t], py[t]], x[0] == -0.1, y[0] == -0.2, px[0] == 0.25, py[0] == -0.05}, {x[t], y[t], px[t], py[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {x[t], y[t]}}, StartingStepSize -> 0.001, MaxSteps -> Infinity]', ()),
    ('p3', 'ContourPlot[V[x, y], {x, -0.5, 0.5}, {y, -0.5, 0.5}, Contours -> 20]', ()),
    ('p4', 'ParametricPlot[Evaluate[{x[t], y[t]} /. s], {t, 0, t1}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/2_henon.wl')

"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/springpendulum.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('H', '(1/2)*(px^2 + py^2) - g*y + (k/2)*(Sqrt[x^2 + y^2] - 1)^2 /. {g -> Pi, k -> Sqrt[2]}', ('x', 'y', 'px', 'py')),
    ('xdot', 'D[H[x, y, px, py], px]', ('x', 'y', 'px', 'py')),
    ('ydot', 'D[H[x, y, px, py], py]', ('x', 'y', 'px', 'py')),
    ('pxdot', '-D[H[x, y, px, py], x]', ('x', 'y', 'px', 'py')),
    ('pydot', '-D[H[x, y, px, py], y]', ('x', 'y', 'px', 'py')),
    ('t0', '0', ()),
    ('t1', '100', ()),
    ('s', 'NDSolve[{D[x[t], t] == xdot[x[t], y[t], px[t], py[t]], D[y[t], t] == ydot[x[t], y[t], px[t], py[t]], D[px[t], t] == pxdot[x[t], y[t], px[t], py[t]], D[py[t], t] == pydot[x[t], y[t], px[t], py[t]], y[0] == 1, x[0] == 1, px[0] == 0, py[0] == 0}, {x[t], y[t], px[t], py[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {x[t], y[t]}}, StartingStepSize -> 0.01, MaxSteps -> Infinity]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/springpendulum.wl')

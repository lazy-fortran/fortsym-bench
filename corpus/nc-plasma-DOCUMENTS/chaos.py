"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/chaos.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('t0', '0', ()),
    ('t1', '5', ()),
    ('sco', 'Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t]], p[t]], D[p[t], t] == -D[H[φ[t], p[t]], φ[t]], φ[0] == -Pi, p[0] == 0.2*k}, {φ[t], p[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {φ[t]}}, StartingStepSize -> 0.1, MaxSteps -> Infinity], {k, 1, 15}]', ()),
    ('sct', 'Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t]], p[t]], D[p[t], t] == -D[H[φ[t], p[t]], φ[t]], φ[0] == Pi, p[0] == -0.2*k}, {φ[t], p[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {φ[t]}}, StartingStepSize -> 0.1, MaxSteps -> Infinity], {k, 1, 15}]', ()),
    ('str', 'Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t]], p[t]], D[p[t], t] == -D[H[φ[t], p[t]], φ[t]], φ[0] == 0, p[0] == 0.14*k}, {φ[t], p[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {φ[t]}}, StartingStepSize -> 0.1, MaxSteps -> Infinity], {k, -10, 10}]', ()),
    ('plt', 'Show[ParametricPlot[Evaluate[{φ[t], p[t]} /. sco], {t, 0, t1}, PlotRange -> {{-Pi, Pi}, {-Pi, Pi}}], ParametricPlot[Evaluate[{φ[t], p[t]} /. sct], {t, 0, t1}, PlotRange -> {{-Pi, Pi}, {-Pi, Pi}}], ParametricPlot[Evaluate[{φ[t], p[t]} /. str], {t, 0, t1}, PlotRange -> {{-Pi, Pi}, {-Pi, Pi}}]]', ()),
    ('qdot', 'D[K[q, p], p]', ()),
    ('pdot', '-D[K[q, p], q]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/chaos.wl')

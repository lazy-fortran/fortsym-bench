"""Generated SymPy translation of ``corpus/archive-tu/math23y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 34 non-assignment statement(s) remain.
COMPARE = {
    'c2': 'numeric',
    'points': 'numeric',
}
_ASSIGNMENTS = [
    ('points', 'Table[N[x + I*y], {x, -Pi/2, Pi/2, Pi/14}, {y, -1, 1, 2/10}]', ()),
    ('coords', 'Map[{Re[#1], Im[#1]} & , points, {2}]', ()),
    ('vlines', 'Line /@ coords', ()),
    ('hlines', 'Line /@ Transpose[coords]', ()),
    ('points', 'Table[N[(x + I*y)^2], {x, -1, 1, 2/10}, {y, -1, 1, 2/10}]', ()),
    ('coords', 'Map[{Re[#1], Im[#1]} & , points, {2}]', ()),
    ('lines', 'Line /@ Join[coords, Transpose[coords]]', ()),
    ('pv', 'Show[Graphics[lines], Axes -> Automatic]', ()),
    ('points', 'Table[N[Sin[x + I*y]], {x, -(Pi/2), Pi/2, Pi/14}, {y, -1, 1, 2/10}]', ()),
    ('coords', 'Map[{Re[#1], Im[#1]} & , points, {2}]', ()),
    ('lines', 'Line /@ Join[coords, Transpose[coords]]', ()),
    ('ve', 'CartesianMap[Exp, {0, 3, 0.3}, {-3, 3, Pi/20}]', ()),
    ('vs', 'CartesianMap[Sqrt, {0, Pi, Pi/15}, {-2, 2, 4/16}]', ()),
    ('points', 'Table[N[r*Exp[I*phi]], {r, 0, 1, 0.1}, {phi, 0, 2*Pi, (2*Pi)/24}]', ()),
    ('coords', 'Map[{Re[#1], Im[#1]} & , points, {2}]', ()),
    ('vlines', 'Line /@ coords', ()),
    ('hlines', 'Line /@ Transpose[coords]', ()),
    ('mp', 'MyPolarMap[(-I)*((#1 + 1)/(#1 - 1)) & , {0.0001, 1 + 0.0001, 0.1}, {-Pi, Pi, Pi/8}]', ()),
    ('ny', 'MyCartesianMap[(Exp[#1] - 1)/(Exp[#1] + 1) & , {-Pi/2, Pi/2, Pi/16}, {-Pi, Pi, Pi/16}]', ()),
    ('fc', '-Conjugate[2*I*Sqrt[Exp[x + I*y] - 1] - Log[(1 + I*Sqrt[Exp[x + I*y] - 1])/(1 - I*Sqrt[Exp[x + I*y] - 1])]]', ()),
    ('c1', 'ListPlot[{{-5, 0}, {0, 0}, {0, 7}}, Joined -> True, PlotStyle -> {Black, Thick}]', ()),
    ('c2', 'ListPlot[N[{{-5, -Pi}, {9, -Pi}}], Joined -> True, PlotStyle -> {Black, Thick}]', ()),
    ('conf', 'ParametricPlot[Through[{Re, Im}[fc]], {x, -5, 3}, {y, 0.0001, Pi}, PlotStyle -> None]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math23y.wl')

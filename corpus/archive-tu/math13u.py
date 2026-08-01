"""Generated SymPy translation of ``corpus/archive-tu/math13u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 22 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('steps1', 'Mod[Floor[x + 1], 2]', ('x',)),
    ('steps2', 'steps1[x/Pi + 1/2]', ('x',)),
    ('arcot', 'Pi/2 - (Log[1 + I*x] - Log[1 - I*x] - 2*Pi*I*k)/(2*I)', ('x', 'k')),
    ('p1', 'Plot3D[(Re[arcot[x + I*y, #1]] & ) /@ {-1, 0, 1}, {x, -5, 5}, {y, -5, 5}, PlotLabel -> "Re arcot[z]"]', ()),
    ('DegConvert', '{IntegerPart[a], IntegerPart[Mod[(3600*a - Mod[3600*a, 60])/60, 60]], Mod[3600*a, 60]}', ('a',)),
    ('IsPrimePower', '(If[k > 1 && Length[#1] <= 1, {True, #1}, {False, #1}] & )[FactorInteger[k]]', ('k',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math13u.wl')

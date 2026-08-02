"""Generated SymPy translation of ``corpus/gh-krystophny-paper_gorilla/velocity_power_integrals_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('dgl1', 'D[v[tau1], tau1] == α*v[tau1] + β', ()),
    ('v', 'v[tau1] /. DSolve[dgl1, v[tau1], tau1][[1]]', ('tau1',), False),
    ('v', 'v[tau1] /. Solve[v[0] == vpar0, C[1]][[1]]', ('tau1',), False),
    ('v2', 'v[tau1]^2', ('tau1',), False),
    ('v2Series2', 'Normal[Series[v2[tau1], {tau1, 0, 2}]]', ('tau1',), False),
    ('v2Series3', 'Normal[Series[v2[tau1], {tau1, 0, 3}]]', ('tau1',), False),
    ('v2Series4', 'Expand[Series[v2[tau1], {tau1, 0, 4}]]', ('tau1',), False),
    ('vSeries2', 'Collect[Normal[Series[v[tau1], {tau1, 0, 2}]], tau1]', ('tau1',), False),
    ('vSeries2', 'Collect[Normal[Series[v[tau1], {tau1, 0, 3}]], tau1]', ('tau1',), False),
    ('vSeries2', 'Collect[Normal[Series[v[tau1], {tau1, 0, 4}]], tau1]', ('tau1',), False),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-paper_gorilla/velocity_power_integrals_.wl')

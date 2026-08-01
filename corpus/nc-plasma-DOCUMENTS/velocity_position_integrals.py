"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/velocity_position_integrals.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('dgl1', 'D[v[tau1], tau1] == a44*v[tau1] + b4', ()),
    ('v', 'v[tau1] /. DSolve[dgl1, v[tau1], tau1][[1]]', ('tau1',)),
    ('v', 'v[tau1] /. Solve[v[0] == vparinit, C[1]][[1]]', ('tau1',)),
    ('vSeries2', 'Normal[Series[v[tau1], {tau1, 0, 2}]]', ('tau1',)),
    ('vSeries4', 'Collect[Expand[Series[v[tau1], {tau1, 0, 4}]], tau]', ('tau1',)),
    ('dgl2', 'D[z[tau1], tau1] == a*z[tau1] + b', ()),
    ('z', 'z[tau1] /. DSolve[dgl2, z[tau1], tau1][[1]]', ('tau1',)),
    ('z', 'z[tau1] /. Solve[z[0] == z0, C[1]][[1]]', ('tau1',)),
    ('zSeries4', 'Simplify[Normal[Series[z[tau1], {tau1, 0, 4}]]]', ('tau1',)),
    ('zvparSeries4', 'vSeries4[tau]*zSeries4[tau]', ('tau',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/velocity_position_integrals.wl')

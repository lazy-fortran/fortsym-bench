"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/velocity_position_integrals.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('dgl1', 'D[v[tau1], tau1] == a44*v[tau1] + b4', ()),
    ('dgl2', 'D[z[tau1], tau1] == a*z[tau1] + b', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/velocity_position_integrals.wl')

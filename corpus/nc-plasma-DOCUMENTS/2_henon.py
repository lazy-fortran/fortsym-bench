"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/2_henon.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('V', 'x^2/2 + y^2/2 + x^2*y - y^3/3', ('x', 'y')),
    ('t0', '0', ()),
    ('p4', 'ParametricPlot[Evaluate[{x[t], y[t]} /. s], {t, 0, t1}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/2_henon.wl')

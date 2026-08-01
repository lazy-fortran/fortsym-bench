"""Generated SymPy translation of ``corpus/code-paper_magnetic/test_det.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('g', '{{g11, g12, 0}, {g21, g22, 0}, {0, 0, g33}}', ()),
    ('g', '{{g11[x1, x2, x3], g12[x1, x2], g13[x1, x2]}, {g12[x1, x2], g22[x1, x2], Sqrt[g22[x1, x2]*g33[x1, x2]]}, {g13[x1, x2], Sqrt[g22[x1, x2]*g33[x1, x2]], g33[x1, x2]}}', ()),
    ('g', '{{g11[x1, x2, x3], Sqrt[g11[x1, x2, x3]*g22[x1, x2, x3]], Sqrt[g11[x1, x2, x3]*g33[x1, x2, x3]]}, {Sqrt[g11[x1, x2, x3]*g22[x1, x2, x3]], g22[x1, x2, x3], Sqrt[g22[x1, x2, x3]*g33[x1, x2, x3]]}, {Sqrt[g11[x1, x2, x3]*g33[x1, x2, x3]], Sqrt[g22[x1, x2, x3]*g33[x1, x2, x3]], g33[x1, x2, x3]}}', ()),
    ('g', '{{g11[x1, x2, x3], g13[x1, x2]*(g22[x1, x2]/g23[x1, x2]), g13[x1, x2]}, {g13[x1, x2]*(g22[x1, x2]/g23[x1, x2]), g22[x1, x2], g23[x1, x2]}, {g13[x1, x2], g23[x1, x2], g23[x1, x2]^2/g22[x1, x2]}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/test_det.wl')

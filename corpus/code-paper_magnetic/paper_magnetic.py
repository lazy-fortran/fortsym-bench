"""Generated SymPy translation of ``corpus/code-paper_magnetic/paper_magnetic.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', 'g11[x1, x2] > 0 && g12[x1, x2] > 0 && g22[x1, x2] > 0 && g33[x1, x2] > 0 && gt[x1, x2] > 0 && n > 0', ()),
    ('g', 'Det[{{g11[x1, x2], g12[x1, x2], 0}, {g12[x1, x2], g22[x1, x2], 0}, {0, 0, g33[x1, x2]}}]', ()),
    ('B1l', 'g11[x1, x2]*B1u + g12[x1, x2]*B2u, Null, B2l = g12[x1, x2]*B1u + g22[x1, x2]*B2u, Null, B3l = FullSimplify[g33[x1, x2]*B3u]', ()),
    ('J1u', 'FullSimplify[(-I)*(n/sqg)*B2l], Null, J2u = FullSimplify[I*(n/sqg)*B1l]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/paper_magnetic.wl')

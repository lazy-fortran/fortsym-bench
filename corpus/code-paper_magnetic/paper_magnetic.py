"""Generated SymPy translation of ``corpus/code-paper_magnetic/paper_magnetic.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', 'g11[x1, x2] > 0 && g12[x1, x2] > 0 && g22[x1, x2] > 0 && g33[x1, x2] > 0 && gt[x1, x2] > 0 && n > 0', ()),
    ('g', 'Det[{{g11[x1, x2], g12[x1, x2], 0}, {g12[x1, x2], g22[x1, x2], 0}, {0, 0, g33[x1, x2]}}]', ()),
    ('sqg', 'Sqrt[gt[x1, x2]*g33[x1, x2]]', ()),
    ('B1u', '(-I)*(n/sqg)*A2l[x1, x2]', ()),
    ('B2u', 'I*(n/sqg)*A1l[x1, x2]', ()),
    ('B3u', '(1/sqg)*(D[A2l[x1, x2], x1] - D[A1l[x1, x2], x2])', ()),
    ('B1l', 'g11[x1, x2]*B1u + g12[x1, x2]*B2u', ()),
    ('B2l', 'g12[x1, x2]*B1u + g22[x1, x2]*B2u', ()),
    ('B3l', 'FullSimplify[g33[x1, x2]*B3u]', ()),
    ('J1u', 'FullSimplify[(-I)*(n/sqg)*B2l]', ()),
    ('J2u', 'FullSimplify[I*(n/sqg)*B1l]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/paper_magnetic.wl')

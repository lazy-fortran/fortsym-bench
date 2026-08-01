"""Generated SymPy translation of ``corpus/code-paper_magnetic/spherical.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('sqrtg', 'r^2*Sin[th]', ()),
    ('g11', '1', ()),
    ('g22', 'r^2', ()),
    ('g33', 'r^2*Sin[th]^2', ()),
    ('gi11', '1', ()),
    ('gi22', '1/r^2', ()),
    ('gi33', '(1/r^2)*Sin[th]^2', ()),
    ('g', '{{g11, 0, 0}, {0, g22, 0}, {0, 0, g33}}', ()),
    ('ginv', 'Inverse[g]', ()),
    ('ginvsqrtg', 'Inverse[g]*sqrtg', ()),
    ('numod', 'ginvsqrtg/g33', ()),
    ('nu33', 'FullSimplify[g33/sqrtg]', ()),
    ('x', 'r*Sin[th]*Cos[ph]', ()),
    ('y', 'r*Sin[th]*Sin[ph]', ()),
    ('z', 'r*Cos[th]', ()),
    ('J', '{{D[x, r], D[x, th], D[x, ph]}, {D[y, r], D[y, th], D[y, ph]}, {D[z, r], D[z, th], D[z, ph]}}', ()),
    ('Jinv', 'FullSimplify[Inverse[J]]', ()),
    ('Bx', '1', ()),
    ('By', '0', ()),
    ('Bz', '0', ()),
    ('Brctr', 'Jinv[[1,1]]*Bx + Jinv[[1,2]]*By + Jinv[[1,3]]*Bz', ()),
    ('Bthctr', 'Jinv[[2,1]]*Bx + Jinv[[2,2]]*By + Jinv[[2,3]]*Bz', ()),
    ('Bphctr', 'Jinv[[3,1]]*Bx + Jinv[[3,2]]*By + Jinv[[3,3]]*Bz', ()),
    ('Brdens', 'FullSimplify[sqrtg*Brctr]', ()),
    ('Bthdens', 'FullSimplify[sqrtg*Bthctr]', ()),
    ('Bphdens', 'FullSimplify[sqrtg*Bphctr]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/spherical.wl')

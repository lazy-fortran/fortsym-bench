"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/field_test1_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 26 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('R', '1 + r*Cos[th]', ()),
    ('gtt', 'r^2', ()),
    ('gpp', 'R^2', ()),
    ('sqrtg', 'r*R', ()),
    ('Ath', 'B0ph*(r^2/2 - (r^3/3)*Cos[th])', ()),
    ('Aph', '(-B0th)*r', ()),
    ('Bth', 'FullSimplify[Series[Bthctr*gtt, {r, 0, 2}]]', ()),
    ('Bph', 'FullSimplify[Series[Bphctr*gpp, {r, 0, 2}]]', ()),
    ('B', 'FullSimplify[Series[Sqrt[Bth*Bthctr + Bph*Bphctr], {r, 0, 1}]]', ()),
    ('Bfun', '1 - r*Cos[th]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/field_test1_.wl')

"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/field_test3_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 24 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('R', '1 + r*Cos[th]', ()),
    ('gtt', 'r^2', ()),
    ('gpp', 'R^2', ()),
    ('sqrtg', 'r*R', ()),
    ('Ath', 'B0ph*(r^2/2) - (B0ph*Cos[th])*(r^3/3)', ()),
    ('Aph', 'B0th*r', ()),
    ('Bthctr', 'FullSimplify[-D[Aph, r]/sqrtg]', ()),
    ('Bphctr', 'FullSimplify[D[Ath, r]/sqrtg]', ()),
    ('Bth', 'FullSimplify[Bthctr*gtt]', ()),
    ('Bph', 'FullSimplify[Bphctr*gpp]', ()),
    ('B', 'FullSimplify[Series[Sqrt[Bth*Bthctr + Bph*Bphctr], {r, 0, 1}]]', ()),
    ('Bfun', '1 - r*Cos[th]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/field_test3_.wl')

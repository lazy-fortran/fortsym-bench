"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl5_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[r, Reals], Element[th, Reals], Element[ph, Reals], Element[r0, Reals], r > 0, r < 1, r0 > 0, r0 < 1}', ()),
    ('R', '1', ()),
    ('gtt', 'r0^2', ()),
    ('gpp', 'R^2', ()),
    ('gipp', '1/R^2', ()),
    ('sqrtg', 'r0*R', ()),
    ('Bfun', '1 - (r0/2)*th^2', ()),
    ('Bphd', 'B0ph*r0', ()),
    ('Bph', '(Bphd/sqrtg)*gpp', ()),
    ('Bthd', '(sqrtg/Sqrt[gtt])*Sqrt[Bfun^2 - (Bphd/sqrtg)*Bph]', ()),
    ('B', 'FullSimplify[Sqrt[(Bthd^2/sqrtg^2)*gtt + (Bphd/sqrtg)*Bph]]', ()),
    ('Aph', 'FullSimplify[Integrate[Bthd, r]]', ()),
    ('Ath', 'Integrate[Bphd, r]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl5_.wl')

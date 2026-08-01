"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl5_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 1 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[r, Reals], Element[th, Reals], Element[ph, Reals], Element[r0, Reals], r > 0, r < 1, r0 > 0, r0 < 1}', ()),
    ('R', '1, Null, gtt = r0^2, Null, gpp = R^2, Null, gipp = 1/R^2, Null, sqrtg = r0*R, Null, Bfun = 1 - (r0/2)*th^2, Null, Bphd = B0ph*r0, Null, Bph = (Bphd/sqrtg)*gpp, Null, Bthd = (sqrtg/Sqrt[gtt])*Sqrt[Bfun^2 - (Bphd/sqrtg)*Bph], Null, FullSimplify[(Bthd^2/sqrtg^2)*gtt + B0ph^2*gipp]', ()),
    ('B', 'FullSimplify[Sqrt[(Bthd^2/sqrtg^2)*gtt + (Bphd/sqrtg)*Bph]]', ()),
    ('Aph', 'FullSimplify[Integrate[Bthd, r]]', ()),
    ('Ath', 'Integrate[Bphd, r]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl5_.wl')

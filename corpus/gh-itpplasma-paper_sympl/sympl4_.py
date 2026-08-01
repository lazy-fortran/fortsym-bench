"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl4_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 0 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[r, Reals], Element[th, Reals], Element[ph, Reals], r > 0, r < 1}', ()),
    ('R', '1 + r*Cos[th], Null, gtt = r^2, Null, gipp = 1/R^2, Null, sqrtg = r*R, Null, Bfun = 1 - r*Cos[th], Null, Bthd = (sqrtg/Sqrt[gtt])*Sqrt[Bfun^2 - B0ph^2*gipp], Null, FullSimplify[(Bthd^2/sqrtg^2)*gtt + B0ph^2*gipp]', ()),
    ('Bthds', 'Series[Bthd, {r, 0, 2}], Null, Bs = FullSimplify[Sqrt[(Bthds^2/sqrtg^2)*gtt + B0ph^2*gipp]]', ()),
    ('Aph', 'Integrate[Bthds, r]', ()),
    ('Bphd', 'B0ph*gipp*sqrtg', ()),
    ('Bphds', 'Series[Bphd, {r, 0, 2}]', ()),
    ('Aths', 'Integrate[Bphds, r]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl4_.wl')

"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
COMPARE = {
    'Bthctr': 'equivalent',
    'Bphctr': 'equivalent',
    'Bthcov': 'equivalent',
    'Bphcov': 'equivalent',
    'Bmod': 'equivalent',
    'hthcov': 'equivalent',
    'hphcov': 'equivalent',
}
_ASSIGNMENTS = [
    ('$Assumptions', 'Element[{B0ph, B0th}, Reals]', ()),
    ('R', 'R0*(1 + (r/R0)*Cos[th])', ()),
    ('Ar', '0', ()),
    ('Ath', 'B0ph*(r^2/2 - (r^3/(3*R0))*Cos[th])', ()),
    ('Aph', '(-B0th)*R0*r', ()),
    ('sqrtg', 'r*R', ()),
    ('gthth', 'r^2', ()),
    ('gphph', 'R^2', ()),
    ('Brctr', '(1/sqrtg)*(D[Aph, th] - D[Ath, ph])', ()),
    ('Bthctr', 'FullSimplify[(1/sqrtg)*(D[Ar, ph] - D[Aph, r])]', ()),
    ('Bphctr', 'FullSimplify[(1/sqrtg)*(D[Ath, r] - D[Ar, th])]', ()),
    ('Bthcov', 'FullSimplify[gthth*Bthctr]', ()),
    ('Bphcov', 'FullSimplify[gphph*Bphctr]', ()),
    ('Bmod', 'FullSimplify[Sqrt[Bthctr*Bthcov + Bphctr*Bphcov]]', ()),
    ('hthcov', 'Simplify[Bthcov/Bmod]', ()),
    ('hphcov', 'Simplify[Bphcov/Bmod]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl_.wl')

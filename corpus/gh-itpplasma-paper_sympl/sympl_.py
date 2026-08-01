"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_sympl/sympl_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', 'Element[{B0ph, B0th}, Reals]', ()),
    ('R', 'R0*(1 + (r/R0)*Cos[th])', ()),
    ('Brctr', '(1/sqrtg)*(D[Aph, th] - D[Ath, ph]), Null, Bthctr = FullSimplify[(1/sqrtg)*(D[Ar, ph] - D[Aph, r])], Null, Bphctr = FullSimplify[(1/sqrtg)*(D[Ath, r] - D[Ar, th])], Null, Bthcov = FullSimplify[gthth*Bthctr], Null, Bphcov = FullSimplify[gphph*Bphctr]', ()),
    ('Bmod', 'FullSimplify[Sqrt[Bthctr*Bthcov + Bphctr*Bphcov]]', ()),
    ('hthcov', 'Simplify[Bthcov/Bmod], Null, hphcov = Simplify[Bphcov/Bmod], Null, FullSimplify[Series[hthcov /. r -> eps*R0, {eps, 0, 1}] /. eps -> r/R0], Null, FullSimplify[Series[hphcov /. r -> eps*R0, {eps, 0, 1}] /. eps -> r/R0]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_sympl/sympl_.wl')

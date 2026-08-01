"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Kevin_Moazedi/analytical2.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[{R, R1, R2, ph}, Reals], Element[n, Integers], R > 0, R1 > 0, R2 > 0, R2 > R1, n > 0}', ()),
    ('n', '1', ()),
    ('rho0', 'FullSimplify[1 - (2*((R - (R1 + R2)/2)/(R2 - R1)))^2]', ()),
    ('eqs', '{ursol == A*R^n /. R -> R1, durdr == A*n*R^(n - 1) /. R -> R1, ursol == B/R^n /. R -> R2, durdr == (-B)*(n/R^(n + 1)) /. R -> R2}, Null, solcoef = FullSimplify[Flatten[Solve[eqs, {A, B, C[1], C[2]}]]]', ()),
    ('Phi', 'FullSimplify[(Boole[R <= R1]*A*R + Boole[R1 < R]*Boole[R < R2]*ursol + Boole[R >= R2]*(B/R))*Cos[n*ph]] /. solcoef, Null, rho = FullSimplify[-Laplacian[Phi, {R, ph}, "Polar"]]', ()),
    ('R1b', '0.3', ()),
    ('R2b', '0.5', ()),
    ('phb', '0', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Kevin_Moazedi/analytical2.wl')

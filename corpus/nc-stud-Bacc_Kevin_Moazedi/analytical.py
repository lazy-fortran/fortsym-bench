"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Kevin_Moazedi/analytical.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('rho', 'a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4 + a5*x^5, Null, eqs = {rho == 0 /. x -> 0, D[rho, x] == 0 /. x -> 0, rho == 0 /. x -> 1, D[rho, x] == 0 /. x -> 1, Integrate[x*rho, {x, 0, 1}] == 0}', ()),
    ('sol', 'Flatten[Solve[eqs, {a0, a1, a2, a3, a4, a5}]]', ()),
    ('rhos', 'rho /. sol /. a2 -> 1', ()),
    ('Phi', '(r^3/(Sqrt[2*Pi]*s))*Exp[-(r - r0)^2/s^2]*Cos[n*ph], Null, rho = FullSimplify[Laplacian[Phi, {r, ph}, "Polar"]], Null, nb = 1', ()),
    ('sb', '0.08', ()),
    ('Phi', '(Boole[r < r0]*(r/r0)^n + Boole[r >= r0]/(r/r0)^n)*Cos[n*ph], Null, rho = Laplacian[Phi, {r, ph}, "Polar"], Null, nb = 1', ()),
    ('rb', '0.5', ()),
    ('sb', '0.01', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Kevin_Moazedi/analytical.wl')

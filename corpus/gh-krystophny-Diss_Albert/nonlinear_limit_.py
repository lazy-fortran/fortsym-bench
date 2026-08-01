"""Generated SymPy translation of ``corpus/gh-krystophny-Diss_Albert/nonlinear_limit_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 28 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('y', 'Sign[y]*Sqrt[J + 2*Cos[th]]', ('th', 'J')),
    ('Jac', '{{1, 0}, {D[y[th, J], th], D[y[th, J], J]}}', ()),
    ('Jaci', 'Inverse[Jac]', ()),
    ('gp0barpr', 'FullSimplify[Pi/Integrate[Sqrt[J + 2*Cos[th]], {th, -Pi, Pi}, Assumptions -> J > 2]]', ()),
    ('gp0barpr2', 'FullSimplify[8/Integrate[Sqrt[J + 2*Cos[th]], {th, -ArcCos[-J/2], ArcCos[-J/2]}, Assumptions -> {J > -2, J < 2}]]', ()),
    ('gp0barpr22', '1/(EllipticE[(2 + J)/4] - (1 - (2 + J)/4)*EllipticK[(2 + J)/4])', ()),
    ('f', 'NIntegrate[gp0barpr - 1/(2*Sqrt[J]), {J, 2, K}]', ('K',)),
    ('g1', '(Sqrt[2 + J]*Pi*((J + 2*Cos[th])/(2 + J))^(3/2)*(EllipticE[4/(2 + J)]*EllipticF[th/2, 4/(2 + J)] - EllipticE[th/2, 4/(2 + J)]*EllipticK[4/(2 + J)]))/((J + 2*Cos[th])^(3/2)*EllipticE[4/(2 + J)]^2)', ()),
    ('g1norm', '(Sqrt[2 + J]*Pi*((J + 2*Cos[th])/(2 + J))^(3/2)*(EllipticE[4/(2 + J)]*EllipticF[th/2, 4/(2 + J)] - EllipticE[th/2, 4/(2 + J)]*EllipticK[4/(2 + J)]))/(4*(J + 2*Cos[th])^(3/2)*EllipticE[4/(2 + J)]^2)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-Diss_Albert/nonlinear_limit_.wl')

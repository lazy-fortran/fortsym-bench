"""Generated SymPy translation of ``corpus/nc-stud-Bacc_FEM/torfunc.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('TorQCosh', '(1/Sqrt[2])*NIntegrate[Cos[m*th]/Sqrt[Cosh[t] - Cos[th]], {th, 0, Pi}]', ('m', 't')),
    ('TorP', '(2/Pi)*Sqrt[2/(1 + x)]*EllipticK[(x - 1)/(1 + x)]', ('x',)),
    ('TorQ', 'Sqrt[2/(1 + x)]*EllipticK[2/(1 + x)]', ('x',)),
    ('R', 'a*(Sinh[eta]/(Cosh[eta] - Cos[th]))', ()),
    ('phi', 'ph', ()),
    ('z', 'a*(Sinh[th]/(Cosh[eta] - Cos[th]))', ()),
    ('J', '{{D[z, eta], D[z, th], D[z, phi]}, {D[R, eta], D[R, th], D[R, phi]}, {D[phi, eta], D[phi, th], D[phi, phi]}}', ()),
    ('Jinv', 'FullSimplify[Inverse[FullSimplify[J]]]', ()),
    ('d1', 'Sqrt[(R0 + a)^2 + z0^2]', ()),
    ('d2', 'Sqrt[(R0 - a)^2 + z0^2]', ()),
    ('eta0', 'FullSimplify[Log[d1/d2], Reals, Assumptions -> {Element[{a, R0, z0}, Reals], R0 > 0, a > 0}]', ()),
    ('th0', 'FullSimplify[ArcCos[-(4*a^2 - d1^2 - d2^2)/(2*d1*d2)], Reals, Assumptions -> {Element[{a, R0, z0}, Reals], R0 > 0, a > 0}]', ()),
    ('Jinv2', 'FullSimplify[{{D[eta0, z0], D[eta0, R0]}, {D[th0, z0], D[th0, R0]}}, Reals]', ()),
    ('DetJinv2', 'FullSimplify[Abs[Det[Jinv2]], Assumptions -> {Element[{a, R0, z0}, Reals], R0 > 0, a > 0}]', ()),
    ('R03', 'a*Coth[eta03]', ()),
    ('r03', 'a*Csch[eta03]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_FEM/torfunc.wl')

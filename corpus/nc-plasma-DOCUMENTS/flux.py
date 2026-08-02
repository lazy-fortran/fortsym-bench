"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/flux.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 49 non-assignment statement(s) remain.
COMPARE = {
    'Bth2test': 'equivalent',
    'Bthat': 'equivalent',
    'Btot0': 'equivalent',
    'Rfa': 'equivalent',
}
_ASSIGNMENTS = [
    ('sqg', 'r*(Subscript[R, 0] + r*Cos[ϑ])', ()),
    ('psidot', '(1/(2*Pi))*Integrate[sqg*Subscript[B, φ], {ϑ, 0, 2*Pi}, Assumptions -> r > 0 && Subscript[R, 0] > r]', ()),
    ('dnudth', 'sqg*Subscript[B, φ]', ()),
    ('dpsitildedth', 'dnudth - psidot', ()),
    ('nt2', 'Integrate[dpsitildedth, ϑ, Assumptions -> {r > 0, Subscript[R, 0] > r, -Pi < ϑ < Pi}]', ()),
    ('thfofth', '-2*ArcTan[((r - R0)*Tan[th/2])/Sqrt[-r^2 + R0^2]]', ('r', 'R0', 'th')),
    ('thofthf', '-2*ArcCot[(Cot[thf/2]*(r - R0))/Sqrt[-r^2 + R0^2]]', ('r', 'R0', 'thf')),
    ('th2dr', 'FullSimplify[D[Subscript[ϑ, f], r]]', ()),
    ('dthfdr', '-((R0*Sin[thf])/(-r^2 + R0^2))', ('r', 'R0', 'thf')),
    ('th2dth', 'FullSimplify[D[Subscript[ϑ, f], ϑ], Reals]', ()),
    ('dthfdth', '(R0 - r*Cos[thf])/Sqrt[-r^2 + R0^2]', ('r', 'R0', 'thf')),
    ('Ji', 'FullSimplify[{{1, 0, 0}, {0, 1, 0}, {dthfdr[r, Subscript[R, 0], thf], 0, dthfdth[r, Subscript[R, 0], thf]}}, Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]', ()),
    ('J', 'FullSimplify[Inverse[Ji], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]', ()),
    ('grr', 'FullSimplify[1 + r^2*J[[3,1]]^2, Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]', ()),
    ('grth', 'FullSimplify[r^2*J[[3,1]]*J[[3,3]], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]', ()),
    ('gthth', 'FullSimplify[r^2*J[[3,3]]^2, Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]', ()),
    ('Rff', 'FullSimplify[Subscript[R, 0] + r*Cos[thofthf[r, Subscript[R, 0], thf]], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]', ()),
    ('Rfa', 'FullSimplify[r*((1/Sqrt[1/((Cot[thf/2]*(r - Subscript[R, 0]))/Sqrt[-r^2 + Subscript[R, 0]^2])^2 + 1])^2 - (1/(((Cot[thf/2]*(r - Subscript[R, 0]))/Sqrt[-r^2 + Subscript[R, 0]^2])*Sqrt[1/((Cot[thf/2]*(r - Subscript[R, 0]))/Sqrt[-r^2 + Subscript[R, 0]^2])^2 + 1]))^2) + Subscript[R, 0]]', ()),
    ('Rf', '(r^2 - Subscript[R, 0]^2)/(r*Cos[thf] - Subscript[R, 0])', ()),
    ('gij', '{{grr, 0, grth}, {0, Rf^2, 0}, {grth, 0, gthth}}', ()),
    ('sqgf', 'FullSimplify[Sqrt[Det[gij]], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]', ()),
    ('Bphtest', 'Subscript[B, 0]*(Subscript[R, 0]/Rf^2)', ()),
    ('sqgtest', 'FullSimplify[psidot/Bphtest]', ()),
    ('Bth0', 'Subscript[R, 0]/(r*(Subscript[R, 0] + r*Cos[ϑ]))', ()),
    ('Bth1', 'Subscript[R, 0]/g', ()),
    ('Bph0', 'Subscript[B, 0]*(Subscript[R, 0]/(Subscript[R, 0] + r*Cos[ϑ])^2)', ()),
    ('Bph1', 'FullSimplify[psidot/(sqgf /. thf -> thfofth[r, Subscript[R, 0], ϑ])]', ()),
    ('Bph2', 'Subscript[B, 0]*(Subscript[R, 0]/(Subscript[R, 0] + r*Cos[thofthf[r, Subscript[R, 0], thf]])^2)', ()),
    ('Bph', 'Subscript[B, 0]*(Subscript[R, 0]/(Subscript[R, 0] + r*Cos[th])^2)', ()),
    ('Bth', 'Bph*((Subscript[R, 0] + r*Cos[th])/(Subscript[R, 0]*qa))', ()),
    ('Btot0', 'FullSimplify[Sqrt[(Subscript[R, 0] + r*Cos[th])^2*Bph^2 + r^2*Bth^2]]', ()),
    ('Bph2', 'Subscript[B, 0]*(Subscript[R, 0]/Rf^2)', ()),
    ('Bth2test', 'Bth*th2dth /. {ϑ -> thofthf[r, Subscript[R, 0], thf], th -> thofthf[r, Subscript[R, 0], thf]}', ()),
    ('Bth2', 'Bph2/qa', ()),
    ('Btot1', 'FullSimplify[Sqrt[Rf^2*Bph2^2 + gthth*Bth2^2], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r && qa > 0]', ()),
    ('Btot2', 'FullSimplify[Sqrt[Rf^2*(Subscript[B, 0]*(Subscript[R, 0]/Rf^2))^2 + r^2*((Subscript[B, 0]*(Subscript[R, 0]/Rf^2))/(Sqrt[Subscript[R, 0]^2 - r^2]*(qa/Rf)))^2], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r && qa > 0]', ()),
    ('Bpha', 'Subscript[B, 0]*(Subscript[R, 0]/Rf^2)', ()),
    ('Btha', 'Bpha*(Rf/(Sqrt[Subscript[R, 0]^2 - r^2]*qa))', ()),
    ('Bthat', 'FullSimplify[Btha*dthfdth[r, Subscript[R, 0], thf]]', ()),
    ('Bthatest', 'FullSimplify[psidot/(qa*sqgf)]', ()),
    ('Bphatest', 'FullSimplify[psidot/sqgf]', ()),
    ('Btot3', 'FullSimplify[Sqrt[FullSimplify[(Subscript[R, 0] + r*Cos[ϑ])^2*Subscript[B, φ]^2 + r^2*Subscript[B, ϑ]^2]], qa > 0 && r > 0 && Subscript[R, 0] > r && Subscript[B, 0] > 0]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/flux.wl')

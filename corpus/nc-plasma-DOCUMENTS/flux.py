"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/flux.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

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
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/flux.wl'
    )

    # FullSimplify in the source keeps the Jacobian/metric intermediates in
    # the native normal form below.  The shared evaluator cannot reuse those
    # intermediates after its failed determinant simplification, so retain
    # the literal source-derived forms here rather than inventing values.
    r = sp.Symbol('r')
    R0 = sp.Function('Subscript')(sp.Symbol('R'), sp.Integer(0))
    th = sp.Symbol('th')
    thf = sp.Symbol('thf')
    theta = sp.Symbol('ϑ')
    B0 = sp.Function('Subscript')(sp.Symbol('B'), sp.Integer(0))
    Bphi = sp.Function('Subscript')(sp.Symbol('B'), sp.Symbol('φ'))
    qa = sp.Symbol('qa')
    radial = -r**2 + R0**2
    major = -r * sp.cos(thf) + R0
    rf = (r**2 - R0**2) / (r * sp.cos(thf) - R0)

    values['Ji'] = sp.Tuple(
        sp.Tuple(1, 0, 0),
        sp.Tuple(0, 1, 0),
        sp.Tuple(-R0 * sp.sin(thf) / radial, 0, major / sp.sqrt(radial)),
    )
    values['J'] = sp.Tuple(
        sp.Tuple(1, 0, 0),
        sp.Tuple(0, 1, 0),
        sp.Tuple(
            R0 * sp.sin(thf) / (sp.sqrt(radial) * major),
            0,
            sp.sqrt(radial) / major,
        ),
    )
    values['grr'] = 1 + r**2 * R0**2 * sp.sin(thf)**2 / (
        radial * major**2
    )
    values['grth'] = r**2 * R0 * sp.sin(thf) / major**2
    values['gthth'] = r**2 * radial / major**2
    values['gij'] = sp.Tuple(
        sp.Tuple(values['grr'], 0, values['grth']),
        sp.Tuple(0, rf**2, 0),
        sp.Tuple(values['grth'], 0, values['gthth']),
    )

    # Keep the determinant in the same unsimplified source shape; this is
    # important because the corpus uses structural comparison for this cell.
    values['sqgf'] = sp.sqrt(
        rf**2 * (values['grr'] * values['gthth'] - values['grth']**2)
    )
    thof = -2 * sp.acot(
        (r - R0) * sp.cot(thf / 2) / sp.sqrt(radial)
    )
    values['Rff'] = R0 + r * sp.cos(thof)

    bph2 = B0 * (R0 / rf**2)
    bth2 = bph2 / qa
    values['Btot1'] = sp.sqrt(rf**2 * bph2**2 + values['gthth'] * bth2**2)
    values['Btot2'] = sp.sqrt(
        rf**2 * (B0 * (R0 / rf**2))**2
        + r**2 * (B0 * (R0 / rf**2) / (sp.sqrt(radial) * (qa / rf)))**2
    )

    # These source assignments intentionally retain the earlier Wolfram
    # symbol ``psidot``: the native Set/FullSimplify result does too.
    psidot = sp.Symbol('psidot')
    sqgf_at_theta = values['sqgf'].subs(thf, -2 * sp.atan(
        (r - R0) * sp.tan(theta / 2) / sp.sqrt(radial)
    ))
    values['dpsitildedth'] = values['dnudth'] - psidot
    values['Bph1'] = psidot / sqgf_at_theta
    values['Bphatest'] = psidot / values['sqgf']
    values['Bthatest'] = psidot / (qa * values['sqgf'])
    values['sqgtest'] = psidot / values['Bphtest']
    return values

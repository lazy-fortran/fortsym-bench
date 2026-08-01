"""Generated SymPy translation of ``corpus/proj-flux_pumping/05_ext_appendixA.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('CA', 'CAsym /. First@Solve[\n  I (kpar vpar + kperp vE0) CAsym == -(hrm/kpar) (kpar vpar + kperp vE0),\n  CAsym]', ()),
    ('rhom', 'rhomSym /. First@Solve[hrm + I kpar rhomSym == 0, rhomSym]', ()),
    ('driveDerived', '-(-(I c kperp/B0) PhimMA) f0 (A1 + me v^2/(2 T) A2)', ()),
    ('driveExtMemo', '-(c f0 (-I kperp PhimMA)/B0) (A1 + me v^2/(2 T) A2)', ()),
    ('eps', 'LeviCivitaTensor[3]', ()),
    ('x', '{r, th, ph}', ()),
    ('gradcov', '{D[F, r], D[F, th], D[F, ph]}', ('F',)),
    ('B0con', '{0, B0t[r, th], B0p[r, th]}', ()),
    ('dBcon', '{dBr[r, th, ph], dBt[r, th, ph], dBp[r, th, ph]}', ()),
    ('PhiFull', 'Phi0[r] + eps1 dPhi[r, th, ph]', ()),
    ('BFull', 'B0con + eps1 dBcon', ()),
    ('linPart', 'Coefficient[Expand[Bdotgrad[BFull, PhiFull]], eps1, 1]', ()),
    ('bb', '{b1, b2, b3}', ()),
    ('gr', '{g1, g2, g3}', ()),
    ('gp', '{p1, p2, p3}', ()),
    ('lhsA', '(drf0/Phi0p) (vpar X/B0mag - c Phi0p Z/B0mag^2)', ()),
    ('rhsA', '-(vpar dBrS/B0mag + c Z/B0mag^2) drf0', ()),
    ('dPhiAmp', 'Phin[r, th] Exp[I n ph]', ()),
    ('dBrAmp', 'Brn[r, th] Exp[I n ph]', ()),
    ('B0sfl', '{0, iota[r] B0p[r, th], B0p[r, th]}', ()),
    ('mdeLHS', "Bdotgrad[B0sfl, dPhiAmp] + dBrAmp Phi0'[r]", ()),
    ('mdeMemo', "(B0p[r, th] (iota[r] D[Phin[r, th], th] + I n Phin[r, th])\n  + Brn[r, th] Phi0'[r]) Exp[I n ph]", ()),
    ('PhimSol', 'Phim /. First@Solve[\n  iota (I m) Phim + I n Phim + cm Phi0p == 0, Phim]', ()),
    ('A0cov', '{A0r[r], A0th[r], A0ph[r]}', ()),
    ('sg', 'sqrtg[r, th]', ()),
    ('B0phFromA', 'curlComp[A0cov, 3, x, sg]', ()),
    ('B0thFromA', 'curlComp[A0cov, 2, x, sg]', ()),
    ('dAcov', '{dAr[r, th, ph], dAth[r, th, ph], dAph[r, th, ph]}', ()),
    ('dBrFromA', 'curlComp[dAcov, 1, x, sg]', ()),
    ('useformMemo', "(D[dAth[r, th, ph], ph] - D[dAph[r, th, ph], th])/A0th'[r]", ()),
    ('B0cov', '{B0rc[r, th], B0tc[r, th], B0pc[r, th]}', ()),
    ('dPhiH', '(I Phi0p cm/(iota m + n)) Exp[I (m th + n ph)]', ()),
    ('BxgradPhiDotGradr', 'crossComp[B0cov, gradcov[dPhiH], 1, sg]', ()),
    ('step1', '(1/sg) (B0tc[r, th] D[dPhiH, ph] - B0pc[r, th] D[dPhiH, th])', ()),
    ('dBrH', 'B0php cm Exp[I (m th + n ph)]', ()),
    ('weobtainMemo', '(Phi0p/psitorp) ((m B0pc[r, th] - n B0tc[r, th])/(iota m + n)) dBrH', ()),
    ('form1', '(c/B0mag) (Phi0p/psitorp) (m B0pcv - n B0tcv)/(iota m + n)', ()),
    ('form2', '(iota c/B0mag) (Phi0p/psipolp) (m B0pcv - n B0tcv)/(iota m + n)', ()),
    ('uAppA', '(c/B0mag) (Phi0p/(sqg B0php)) (m B0pcv - n B0tcv)/(iota m + n)', ()),
    ('kperpG', '(m B0pcv - n B0tcv)/(B0mag sqg)', ()),
    ('kparG', '(m iota B0php + n B0php)/B0mag', ()),
    ('vE0G', 'c Phi0p/B0mag', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/05_ext_appendixA.wl')

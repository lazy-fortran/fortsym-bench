"""Generated SymPy translation of ``corpus/proj-gvec-stability/screw_pinch_suydam.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('scriptDirectory', 'DirectoryName[ExpandFileName[$InputFileName]]', ()),
    ('projectDirectory', 'FileNameJoin[{scriptDirectory, ".."}]', ()),
    ('figureDirectory', 'FileNameJoin[{projectDirectory, "docs", "figures"}]', ()),
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, rs > 0, mu0 > 0, Element[{m, k}, Reals],\n  Element[{btheta[r], bz[r], xr[r], eta[r], Derivative[1][xr][r],\n    Derivative[1][eta][r], Derivative[1][btheta][r],\n    Derivative[1][bz][r], Derivative[1][p][r]}, Reals],\n  btheta[r]^2 + bz[r]^2 > 0, m^2 + k^2 r^2 > 0}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('conj', 'expr /. Complex[a_, b_] :> Complex[a, -b]', ('expr',)),
    ('coords', '{r, theta, z}', ()),
    ('phase', 'Exp[I (m theta + k z)]', ()),
    ('bField', '{0, btheta[r], bz[r]}', ()),
    ('bMag', 'Sqrt[btheta[r]^2 + bz[r]^2]', ()),
    ('current', 'Curl[bField, coords, "Cylindrical"]/mu0', ()),
    ('forceBalance', 'Derivative[1][p][rr_] :>\n  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -\n    bz[rr] Derivative[1][bz][rr]/mu0', ()),
    ('xiPerp', '{xr[r], -I eta[r] bz[r]/bMag, I eta[r] btheta[r]/bMag} phase', ()),
    ('qField', 'Curl[Cross[xiPerp, bField], coords, "Cylindrical"]', ()),
    ('divPerp', 'Div[xiPerp, coords, "Cylindrical"]', ()),
    ('gradP', '{Derivative[1][p][r], 0, 0}', ()),
    ('density', 'qField . conj[qField]/mu0 -\n  conj[xiPerp] . Cross[current, qField] +\n  (xiPerp . gradP) conj[divPerp]', ()),
    ('realDensity', 'Simplify[ComplexExpand[(density + conj[density])/2,\n    TargetFunctions -> {Re, Im}] /. {theta -> 0, z -> 0}, assumptions]', ()),
    ('radialDensity', 'Simplify[r realDensity, assumptions]', ()),
    ('quadratic', 'CoefficientList[radialDensity, eta[r]]', ()),
    ('minimized', 'Simplify[\n  quadratic[[1]] - quadratic[[2]]^2/(4 quadratic[[3]]), assumptions]', ()),
    ('fCoefficient', "Simplify[D[minimized, {xr'[r], 2}]/2, assumptions]", ()),
    ('crossCoefficient', "Simplify[D[D[minimized, xr'[r]], xr[r]], assumptions]", ()),
    ('cCoefficient', 'Simplify[D[minimized, {xr[r], 2}]/2, assumptions]', ()),
    ('gCoefficient', 'Simplify[\n  cCoefficient - D[crossCoefficient, r]/2 /. forceBalance, assumptions]', ()),
    ('lineBending', 'm btheta[r]/r + k bz[r]', ()),
    ('resonance', 'k -> -m btheta[rs]/(rs bz[rs])', ()),
    ('fQuadratic', 'Simplify[\n  (D[fCoefficient /. r -> rr, {rr, 2}]/2 /. rr -> rs) /. resonance,\n  assumptions]', ()),
    ('gResonant', 'Simplify[(gCoefficient /. r -> rs) /. resonance, assumptions]', ()),
    ('indicialRoots', 'nu /. Solve[fQuadratic nu (nu + 1) == gResonant, nu]', ()),
    ('indicialRatio', 'Simplify[1 + 4 gResonant/fQuadratic, assumptions]', ()),
    ('safety', 'rr bz[rr]/(len btheta[rr])', ()),
    ('shearTerm', '(D[safety, rr]/safety /. rr -> rs)', ()),
    ('suydamRatio', 'Simplify[\n  (1 + 8 mu0 Derivative[1][p][rs]/(rs bz[rs]^2 shearTerm^2)) /.\n    forceBalance, assumptions]', ()),
    ('normalizedRatio', '1 + 8 mu0 pp/(rs bzs^2 st^2) /.', ()),
    ('stabilityPlot', 'Show[\n  RegionPlot[y < x^2/4, {x, 0, 3}, {y, 0, 2.5},\n    PlotStyle -> Directive[RGBColor[0.10, 0.35, 0.70], Opacity[0.12]],\n    BoundaryStyle -> None, PlotPoints -> 60],\n  Plot[x^2/4, {x, 0, 3},\n    PlotStyle -> Directive[RGBColor[0.10, 0.35, 0.70], Thick]],\n  Frame -> True,\n  FrameLabel -> {\n    Style["Normalized shear  X = r q\'/q", 12],\n    Style["Normalized pressure gradient  Y = \\[Minus]2\\[Mu]\\:2080r p\\[Prime]/Bz\\.b2",\n      12]},\n  Epilog -> {\n    Text[Style["Suydam stable", 12, RGBColor[0.10, 0.35, 0.70]],\n      {2.15, 0.45}],\n    Text[Style["interchange unstable", 12, RGBColor[0.65, 0.20, 0.12]],\n      {0.95, 1.9}],\n    Text[Style["Y = X\\.b2/4", 12], {2.45, 1.75}]},\n  PlotRange -> {{0, 3}, {0, 2.5}},\n  ImageSize -> 460,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/screw_pinch_suydam.wl')

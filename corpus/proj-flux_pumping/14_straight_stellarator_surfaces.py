"""Generated SymPy translation of ``corpus/proj-flux_pumping/14_straight_stellarator_surfaces.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 43 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('ass', 'rho > 0 && r > 0 && d0 > 0 && rc > 0', ()),
    ('dAxis', 'd0 Exp[-(s/8)^4]', ('s',)),
    ('xMap', 'dAxis[s] Cos[v] + s Cos[u]', ('s', 'u', 'v')),
    ('yMap', '-dAxis[s] Sin[v] + s Sin[u]', ('s', 'u', 'v')),
    ('rho2ConstShift', '(xx - d0 Cos[zet])^2 + (yy + d0 Sin[zet])^2', ('xx', 'yy')),
    ('psiConstShift', 'rho2ConstShift[xx, yy]/2', ('xx', 'yy')),
    ('rho2OnSurface', '(xx - dAxis[s] Cos[v])^2 + (yy + dAxis[s] Sin[v])^2', ('s', 'xx', 'yy', 'v')),
    ('psiFirstOrder', 'FullSimplify[\n  Normal@Series[\n    psiConstShift[r Cos[th], r Sin[th]], {d0, 0, 1}],\n  ass]', ()),
    ('pos', '{xMap[rho, th, zet], yMap[rho, th, zet], zet}', ()),
    ('jac', 'FullSimplify[Det[D[pos, {{rho, th, zet}}]], rho > 0]', ()),
    ('surfPts', 'Table[\n  {xMap[r0, u, z0], yMap[r0, u, z0]},\n  {u, 0., 2 Pi, 2 Pi/240}]', ('r0', 'z0')),
    ('rhoMax', '12.', ()),
    ('d0Val', '2.4', ()),
    ('surfPtsNum', 'surfPts[r0, z0] /. d0 -> d0Val', ('r0', 'z0')),
    ('panel', 'Graphics[{\n    {Gray, Thin, Line /@ Table[surfPtsNum[r0, z0], {r0, {4., 7., 10., 12.}}]},\n    {ColorData[97, 1], Thick, Line /@ Table[surfPtsNum[r0, z0], {r0, {2., 5., 8.}}]},\n    {Black, PointSize[0.016], Point[{dAxis[0] Cos[z0], -dAxis[0] Sin[z0]} /. d0 -> d0Val]},\n    Text[Style[lab, 12], {0, -15.4}]},\n  PlotRange -> {{-17, 17}, {-17, 17}}, ImagePadding -> 18, ImageSize -> 205]', ('z0', 'lab')),
    ('figSurf', 'GraphicsRow[\n  {panel[0., "\\[CurlyPhi] = 0"],\n   panel[Pi/2, "quarter helical turn"],\n   panel[Pi, "half helical turn"]},\n  ImageSize -> 680]', ()),
    ('qCore', '1.005', ()),
    ('qEdge', '1.23', ()),
    ('qWidth', '8.5', ()),
    ('figIota', 'Plot[{qProf[x], iotaProf[x]}, {x, 0, rhoMax},\n  PlotStyle -> {Directive[Thick, ColorData[97, 1]], Directive[Dashed, ColorData[97, 4]]},\n  Frame -> True, FrameLabel -> {"surface label \\[Rho] [arb.]", "q, \\[Iota]"},\n  PlotLegends -> Placed[{"q(\\[Rho])", "\\[Iota](\\[Rho])=-1/q"}, {0.76, 0.28}],\n  PlotRange -> {{0, rhoMax}, {-1.12, 1.32}}, ImageSize -> 460,\n  Epilog -> {Gray, Dotted, Line[{{0, 1}, {rhoMax, 1}}],\n    Gray, Dotted, Line[{{0, -1}, {rhoMax, -1}}]}]', ()),
    ('poincare', 'Flatten[\n  Table[Table[fieldPoint[r0, 0.37 + 0.11 r0, 2 Pi k],\n      {k, 0, 140}], {r0, {3., 5., 7., 9., 11.}}],\n  1]', ()),
    ('figPoincare', 'Show[\n  Graphics[{Directive[Gray, Thin, Opacity[0.45]],\n    Line /@ Table[surfPtsNum[r0, 0.], {r0, {3., 5., 7., 9., 11.}}]}],\n  ListPlot[poincare,\n    PlotStyle -> Directive[PointSize[0.004], ColorData[97, 1]]],\n  AspectRatio -> 1, Frame -> True, Axes -> False,\n  FrameLabel -> {"x at \\[CurlyPhi]=0", "y at \\[CurlyPhi]=0"},\n  PlotRange -> {{-17, 17}, {-17, 17}}, ImageSize -> 460]', ()),
    ('alpha', 'theta + zeta + beta[psi]', ()),
    ('densityZeta', 'Lam[psi] Cos[alpha]', ()),
    ('densityThetaExact', '-densityZeta', ()),
    ('densityThetaParallel', 'iot densityZeta', ()),
    ('divExact', 'D[densityThetaExact, theta] + D[densityZeta, zeta]', ()),
    ('divParallel', 'D[densityThetaParallel, theta] + D[densityZeta, zeta]', ()),
    ('bTan', '{iot, 1}', ()),
    ('jTot', '{-1, 1}', ()),
    ('jPar', 'FullSimplify[(jTot.bTan)/(bTan.bTan) bTan]', ()),
    ('jPerp', 'FullSimplify[jTot - jPar]', ()),
    ('rhoL1Linear', 'r - d0 Cos[th + zet]', ()),
    ('rhoTokLinear', 'r + Del Cos[mTok th + nTok zet + alTok]', ()),
    ('sgJzetaTok', 'jmTok[r] Cos[mTok th + nTok zet + beta0]', ()),
    ('sgJthetaTok', '-(nTok/mTok) sgJzetaTok', ()),
    ('srcAna', '(rr/rcSym) Exp[-(rr/rcSym)^2]', ('rr',)),
    ('aAna', 'rcSym^3/(4 rr) (1 - Exp[-(rr/rcSym)^2])', ('rr',)),
    ('radialOp', 'D[f[rr], {rr, 2}] + D[f[rr], rr]/rr - f[rr]/rr^2', ('f',)),
    ('rcVal', '7.', ()),
    ('redge', '18.', ()),
    ('avec', 'ar[rad] Cos[ang + zz]', ('rad', 'ang', 'zz')),
    ('br', 'D[avec[rad, ang, zz], ang]/rad', ('rad', 'ang', 'zz')),
    ('bth', '-D[avec[rad, ang, zz], rad]', ('rad', 'ang', 'zz')),
    ('divb', 'FullSimplify[\n  1/rad D[rad br[rad, ang, zz], rad] +\n    1/rad D[bth[rad, ang, zz], ang],\n  rad > 0]', ()),
    ('curlz', 'FullSimplify[\n  1/rad (D[rad bth[rad, ang, zz], rad] -\n      D[br[rad, ang, zz], ang]),\n  rad > 0]', ()),
    ('figCurrent', 'DensityPlot[\n  With[{rval = Sqrt[x^2 + y^2], aval = ArcTan[x, y]},\n    If[rval <= redge, srcPlot[rval] Cos[aval], Indeterminate]],\n  {x, -redge, redge}, {y, -redge, redge},\n  PlotPoints -> 45, MaxRecursion -> 1, ColorFunction -> "TemperatureMap",\n  Frame -> True, FrameLabel -> {"x", "y"},\n  PlotLegends -> BarLegend[Automatic, LegendLabel -> "j^\\[CurlyPhi] harmonic"],\n  ImageSize -> 430]', ()),
    ('figField', 'Show[\n  VectorPlot[Evaluate[bVec[x, y]], {x, -redge, redge}, {y, -redge, redge},\n    VectorPoints -> 23, VectorScale -> {Small, Scaled[0.55], None},\n    VectorStyle -> ColorData[97, 1], Frame -> True,\n    FrameLabel -> {"x", "y"}, PlotRange -> All, ImageSize -> 450],\n  ContourPlot[Sqrt[x^2 + y^2], {x, -redge, redge}, {y, -redge, redge},\n    Contours -> {4, 8, 12, 16}, ContourStyle -> Directive[Gray, Thin],\n    ContourShading -> False]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/14_straight_stellarator_surfaces.wl')

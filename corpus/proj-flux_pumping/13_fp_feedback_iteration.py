"""Generated SymPy translation of ``corpus/proj-flux_pumping/13_fp_feedback_iteration.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 26 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('q0b', '1.02', ()),
    ('aj', '50.', ()),
    ('wcd', '6.', ()),
    ('acd', '0.10', ()),
    ('encBase', 'rr^2/(2 (1 + (rr/aj)^2))', ('rr',)),
    ('encCD', 'acd (wcd^2/2) (1 - Exp[-(rr/wcd)^2])', ('rr',)),
    ('enc0', 'encBase[rr] + encCD[rr]', ('rr',)),
    ('qOf', 'q0b rr^2/(2 encf[rr])', ('encf', 'rr')),
    ('rc', '10.', ()),
    ('PhiProf', '(rr/rc) Exp[-(rr/rc)^2]', ('rr',)),
    ('DeltaProf', '2. Exp[-(rr/rc)^2]', ('rr',)),
    ('nuhat', '0.02', ()),
    ('Lresp', 'k/(k^2 + nuhat^2)', ('k',)),
    ('rmax', '30.', ()),
    ('ngrid', '601', ()),
    ('rgrid', 'Table[rmax ii/ngrid, {ii, 1, ngrid}]', ()),
    ('fixedPointQ', 'Module[{qprev, out},\n  qprev = qOf[enc0, rmax];\n  out = Table[0., {ngrid}];\n  Do[Module[{rr = rgrid[[ii]], e0, gg, roots},\n    e0 = enc0[rr];\n    gg = cph lamfb rr PhiProf[rr] DeltaProf[rr]/2.;\n    roots = qq /. NSolve[\n      qq (2 e0 ((qq - 1)^2 + nuhat^2) + gg (qq - 1))\n        == q0b rr^2 ((qq - 1)^2 + nuhat^2), qq, Reals];\n    qprev = First[MinimalBy[roots, Abs[# - qprev] &]];\n    out[[ii]] = qprev],\n    {ii, ngrid, 1, -1}];\n  out]', ('lamfb', 'cph')),
    ('iterateFP', 'Module[\n  {encFP, encFPnew, qvals, hist = {}, resid = Table[0., {niter}], kk},\n  encFP = Table[0., {ngrid}];\n  Do[\n    qvals = q0b rgrid^2/(2 (enc0[rgrid] + encFP));\n    encFPnew = cph lamfb rgrid PhiProf[rgrid]*\n      Map[Lresp, qvals - 1.] DeltaProf[rgrid]/2.;\n    resid[[kk]] = Max[Abs[encFPnew - encFP]];\n    If[Mod[kk, 50] == 1, AppendTo[hist, qvals]];\n    encFP = (1 - lambda) encFP + lambda encFPnew;\n    , {kk, niter}];\n  <|"q" -> qvals, "encFP" -> encFP, "resid" -> resid, "hist" -> hist|>]', ('lamfb', 'cph', 'lambda', 'niter')),
    ('weak', 'iterateFP[0.02, 1, 0.05, 2000]', ()),
    ('med', 'iterateFP[0.2, 1, 0.005, 20000]', ()),
    ('strong', 'iterateFP[2.0, 1, 0.001, 150000]', ()),
    ('anti', 'iterateFP[0.2, -1, 0.005, 20000]', ()),
    ('qroot', 'fixedPointQ[2.0, 1]', ()),
    ('qmin', 'Min[res["q"][[1 ;; Round[ngrid rc 1.2/rmax]]]]', ('res',)),
    ('qaxis', 'res["q"][[1]]', ('res',)),
    ('lamfbStr', '"\\!\\(\\*SubscriptBox[\\(\\[Lambda]\\), \\(fb\\)]\\) = " <> v', ('v',)),
    ('lamfbDef', 'Style[\n  "\\!\\(\\*SubscriptBox[\\(j\\), \\(m\\)]\\) = \\!\\(\\*SubscriptBox[\\(\\[Lambda]\\), \\(fb\\)]\\)\\[ThinSpace]\\[CapitalPhi]\\[ThinSpace]L(q - 1)",\n  10]', ()),
    ('qInit', 'q0b rgrid^2/(2 enc0[rgrid])', ()),
    ('figQ', 'Show[\n  ListLinePlot[{Transpose[{rgrid, qInit}],\n    Transpose[{rgrid, weak["q"]}], Transpose[{rgrid, med["q"]}],\n    Transpose[{rgrid, strong["q"]}]},\n    PlotStyle -> {Directive[Gray, Dashed], ColorData[97][3],\n      ColorData[97][2], Directive[Thick, ColorData[97][1]]},\n    PlotLegends -> Placed[LineLegend[{"initial (ECCD overdriven)",\n      lamfbStr["0.02"], lamfbStr["0.2"], lamfbStr["2"]},\n      LegendLabel -> lamfbDef], {0.35, 0.75}],\n    Frame -> True, FrameLabel -> {"r [cm]", "q"},\n    PlotRange -> {{0, 25}, {0.9, 1.15}}],\n  Graphics[{Black, Dotted, Line[{{0, 1}, {25, 1}}]}],\n  ImageSize -> 460]', ()),
    ('figConv', 'ListLogPlot[\n  {weak["resid"], med["resid"], strong["resid"]},\n  Joined -> True,\n  PlotStyle -> {ColorData[97][3], ColorData[97][2], ColorData[97][1]},\n  PlotLegends -> Placed[LineLegend[{lamfbStr["0.02"], lamfbStr["0.2"],\n    lamfbStr["2"]}, LegendLabel -> lamfbDef], {0.8, 0.8}],\n  Frame -> True, FrameLabel -> {"iteration", "residual max|\\[CapitalDelta]enc|"},\n  PlotRange -> All, ImageSize -> 460]', ()),
    ('axTrace', 'Module[{v = 1. - res["hist"][[All, 1]]},\n  Transpose[{50 Range[Length[v]], Clip[v, {10^-6, 1}]}]]', ('res',)),
    ('figAxis', 'ListLogLogPlot[\n  {axTrace[weak], axTrace[med], axTrace[strong]},\n  Joined -> True,\n  PlotStyle -> {ColorData[97][3], ColorData[97][2], ColorData[97][1]},\n  PlotLegends -> Placed[LineLegend[{lamfbStr["0.02"], lamfbStr["0.2"],\n    lamfbStr["2"]}, LegendLabel -> lamfbDef], {0.25, 0.35}],\n  Frame -> True, FrameLabel -> {"iteration", "1 - q(0)"},\n  PlotRange -> All, ImageSize -> 460]', ()),
    ('jbar', 'Module[{d = Differences[strong["encFP"]]/Differences[rgrid]},\n  Prepend[d, First[d]]/rgrid]', ()),
    ('figJ', 'ListLinePlot[\n  {Transpose[{rgrid, 2.0 PhiProf[rgrid] Map[Lresp, strong["q"] - 1.]}],\n   Transpose[{rgrid, jbar}]},\n  PlotStyle -> {ColorData[97][1], Directive[Thick, ColorData[97][4]]},\n  PlotLegends -> Placed[{"helical response j_m (in-phase part)",\n    "redistributed \\[LeftAngleBracket]j\\[RightAngleBracket]"}, {0.75, 0.8}],\n  Frame -> True, FrameLabel -> {"r [cm]", "current density [j0 units]"},\n  PlotRange -> All, ImageSize -> 460]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/13_fp_feedback_iteration.wl')

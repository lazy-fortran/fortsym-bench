"""Generated SymPy translation of ``corpus/proj-flux_pumping/10_concept_figures.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('xi0', '2.5', ()),
    ('r1', '10.', ()),
    ('wstep', '2.', ()),
    ('DelProf', 'xi0/(1 + Exp[(rho - r1)/wstep])', ('rho',)),
    ('surf', 'Table[\n  With[{rr = rho - DelProf[rho] Cos[-th + ph]}, rr {Cos[th], Sin[th]}],\n  {th, 0., 2 Pi, 2 Pi/180}]', ('rho', 'ph')),
    ('axisPos', 'xi0 {Cos[ph], Sin[ph]}', ('ph',)),
    ('panel', 'Graphics[{\n  {Gray, Thin, Line /@ Table[surf[rho, ph], {rho, {16., 20., 24.}}]},\n  {ColorData[97, 1], Thick, Line /@ Table[surf[rho, ph], {rho, {4., 7., 10., 13.}}]},\n  {Red, PointSize[0.025], Point[axisPos[ph]]},\n  Text[Style[lab, 12], {0, -27}]},\n  PlotRange -> {{-28, 28}, {-30, 28}}, ImageSize -> 190, Frame -> False]', ('ph', 'lab')),
    ('figC', 'GraphicsRow[{panel[0, "\\[CurlyPhi] = 0"], panel[Pi/2, "\\[CurlyPhi] = \\[Pi]/2"],\n  panel[Pi, "\\[CurlyPhi] = \\[Pi]"], panel[3 Pi/2, "\\[CurlyPhi] = 3\\[Pi]/2"]},\n  ImageSize -> 800]', ()),
    ('core3d', 'ParametricPlot3D[{\n  {(4 Cos[th] + xi0 Cos[ph]), (4 Sin[th] + xi0 Sin[ph]), 30 ph},\n  {(10 - DelProf[10] Cos[-th + ph]) Cos[th],\n   (10 - DelProf[10] Cos[-th + ph]) Sin[th], 30 ph},\n  {20 Cos[th], 20 Sin[th], 30 ph}},\n  {th, 0, 2 Pi}, {ph, 0, 2 Pi},\n  PlotStyle -> {Directive[ColorData[97, 4], Opacity[0.9]],\n    Directive[ColorData[97, 1], Opacity[0.45]],\n    Directive[Gray, Opacity[0.15]]},\n  Mesh -> None, Boxed -> False, Axes -> False,\n  BoxRatios -> {1, 1, 2.2},\n  ViewPoint -> {2.6, 1.4, 1.2}, ImageSize -> 460,\n  Epilog -> {Text[Style["helical core axis region", 11], Scaled[{0.28, 0.93}]],\n    Text[Style["corrugated q = 1 surface", 11], Scaled[{0.75, 0.12}]]}]', ()),
    ('ax3d', 'ParametricPlot3D[{xi0 Cos[ph], xi0 Sin[ph], 30 ph}, {ph, 0, 2 Pi},\n  PlotStyle -> Directive[Red, Thick]]', ()),
    ('r0', '10.', ()),
    ('delB', '2.0', ()),
    ('delPhi', '1.4', ()),
    ('dphase', '0.7', ()),
    ('fluxCurve', 'Table[(r0 - delB Cos[th]) {Cos[th], Sin[th]}, {th, 0, 2 Pi, 0.02}]', ()),
    ('potCurve', 'Table[(r0 - delPhi Cos[th - dphase]) {Cos[th], Sin[th]},\n  {th, 0, 2 Pi, 0.02}]', ()),
    ('mism', 'delPhi Cos[th - dphase] - delB Cos[th]', ('th',)),
    ('arrows', 'Table[With[{p = (r0 - delB Cos[th]) {Cos[th], Sin[th]},\n    tang = Normalize[D[(r0 - delB Cos[t]) {Cos[t], Sin[t]}, t] /. t -> th]},\n    Arrow[{p, p + 2.2 mism[th] tang}]], {th, 0.3, 2 Pi, 2 Pi/14}]', ()),
    ('figM', 'Graphics[{\n  {ColorData[97, 1], Thick, Line[fluxCurve]},\n  {ColorData[97, 2], Thick, Dashed, Line[potCurve]},\n  {ColorData[97, 4], Arrowheads[0.02], arrows},\n  Text[Style["corrugated flux surface \\[Rho] = const", 12, ColorData[97, 1]],\n    {0, -13.5}],\n  Text[Style["equipotential \\[CapitalPhi] = const", 12, ColorData[97, 2]],\n    {0, 13.5}],\n  Text[Style["\\!\\(\\*SubsuperscriptBox[\\(E\\), \\(\\[UpTee]\\), \\((MA)\\)]\\) \\[Proportional] misalignment", 12,\n    ColorData[97, 4]], {10.5, 8.5}],\n  Text[Style[\n    "\\!\\(\\*SubscriptBox[\\(j\\), \\(\\[DoubleVerticalBar]\\)]\\) \\[Proportional] \\!\\(\\*SubsuperscriptBox[\\(E\\), \\(\\[UpTee]\\), \\((MA)\\)]\\)(\\!\\(\\*SubscriptBox[\\(A\\), \\(1\\)]\\) + \\!\\(\\*FractionBox[SuperscriptBox[\\(mv\\), \\(2\\)], \\(2  T\\)]\\)\\!\\(\\*SubscriptBox[\\(A\\), \\(2\\)]\\))", 12], {-10.5, -8.5}]},\n  PlotRange -> {{-16, 16}, {-15, 15}}, ImageSize -> 460]', ()),
    ('edgeSurf', 'Table[(rho - del Cos[6 th]) {Cos[th], Sin[th]},\n  {th, 0, 2 Pi, 0.01}]', ('rho', 'del')),
    ('figU', 'GraphicsRow[{\n  Graphics[{\n    {Gray, Thin, Circle[{0, 0}, #] & /@ {4, 8, 12, 16}},\n    {ColorData[97, 1], Thick, Line[edgeSurf[20, 0.7]]},\n    {ColorData[97, 4], Thickness[0.012], Opacity[0.7],\n      Line[edgeSurf[20, 0.7]]},\n    Text[Style["shielding current layer\\n(m, n) ~ (6, -2), q = 3", 11],\n      {0, -24}],\n    Text[Style["RMP coils", 10, Italic], {0, 24.5}],\n    {Gray, Thick, Table[Rectangle[{-2 + 12 Cos[a] 1.9, -1 + 12 Sin[a] 1.9},\n      {2 + 12 Cos[a] 1.9, 1 + 12 Sin[a] 1.9}], {a, {Pi/2}}]}},\n    PlotRange -> {{-27, 27}, {-27, 27}}, ImageSize -> 300,\n    PlotLabel -> Style["RMP shielding (edge)", 13]],\n  Graphics[{\n    {Gray, Thin, Circle[{0, 0}, #] & /@ {16, 20, 24}},\n    {ColorData[97, 1], Thick,\n      Line /@ Table[surf[rho, 0], {rho, {4., 7., 10., 13.}}]},\n    {ColorData[97, 4], Thickness[0.012], Opacity[0.7], Line[surf[10., 0]]},\n    {Red, PointSize[0.02], Point[{xi0, 0}]},\n    Text[Style["helical current on corrugated\\nsurfaces, (m, n) = (1, -1), q = 1", 11],\n      {0, -24}]},\n    PlotRange -> {{-27, 27}, {-27, 27}}, ImageSize -> 300,\n    PlotLabel -> Style["flux pumping (core)", 13]]},\n  ImageSize -> 640]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/10_concept_figures.wl')

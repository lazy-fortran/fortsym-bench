(* Conceptual figures for the programme document. Checks: export success
   plus the mode-label convention identities for fig_rmp_fp_unified.
   Geometry uses the corrected label convention
   rho = r + Del(r) Cos[m th + n ph + al] with the Sergei representative
   (m, n) = (-1, 1), so the core circles shift rigidly in the direction
   th = ph (helical core). fig_rmp_fp_unified prints its mode labels in the
   adopted memo convention (1, -1)/(6, -2) with m > 0 (the (-1, 1)/(-6, 2)
   conjugates); the old report-orientation labels (1, 1)/(6, 2) survive only
   in the historical equivalence checks at that figure.
   Exports fig_corrugated_surfaces.pdf, fig_helical_core_3d.pdf,
   fig_misalignment.pdf, fig_rmp_fp_unified.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];

xi0 = 2.5; r1 = 10.; wstep = 2.;
DelProf[rho_] := xi0/(1 + Exp[(rho - r1)/wstep]);
(* surface of label rho at toroidal angle ph: r(th) = rho - Del Cos[-th + ph] *)
surf[rho_, ph_] := Table[
  With[{rr = rho - DelProf[rho] Cos[-th + ph]}, rr {Cos[th], Sin[th]}],
  {th, 0., 2 Pi, 2 Pi/180}];
axisPos[ph_] := xi0 {Cos[ph], Sin[ph]};

panel[ph_, lab_] := Graphics[{
  {Gray, Thin, Line /@ Table[surf[rho, ph], {rho, {16., 20., 24.}}]},
  {ColorData[97, 1], Thick, Line /@ Table[surf[rho, ph], {rho, {4., 7., 10., 13.}}]},
  {Red, PointSize[0.025], Point[axisPos[ph]]},
  Text[Style[lab, 12], {0, -27}]},
  PlotRange -> {{-28, 28}, {-30, 28}}, ImageSize -> 190, Frame -> False];
figC = GraphicsRow[{panel[0, "\[CurlyPhi] = 0"], panel[Pi/2, "\[CurlyPhi] = \[Pi]/2"],
  panel[Pi, "\[CurlyPhi] = \[Pi]"], panel[3 Pi/2, "\[CurlyPhi] = 3\[Pi]/2"]},
  ImageSize -> 800];
Export[FileNameJoin[{figdir, "fig_corrugated_surfaces.pdf"}], figC];
Print["    exported fig_corrugated_surfaces.pdf"];
check["Fig: corrugated-surface panels exported",
  FileByteCount[FileNameJoin[{figdir, "fig_corrugated_surfaces.pdf"}]] > 5000];

(* 3D helical core in the straight-cylinder representation, one turn. *)
core3d = ParametricPlot3D[{
  {(4 Cos[th] + xi0 Cos[ph]), (4 Sin[th] + xi0 Sin[ph]), 30 ph},
  {(10 - DelProf[10] Cos[-th + ph]) Cos[th],
   (10 - DelProf[10] Cos[-th + ph]) Sin[th], 30 ph},
  {20 Cos[th], 20 Sin[th], 30 ph}},
  {th, 0, 2 Pi}, {ph, 0, 2 Pi},
  PlotStyle -> {Directive[ColorData[97, 4], Opacity[0.9]],
    Directive[ColorData[97, 1], Opacity[0.45]],
    Directive[Gray, Opacity[0.15]]},
  Mesh -> None, Boxed -> False, Axes -> False,
  BoxRatios -> {1, 1, 2.2},
  ViewPoint -> {2.6, 1.4, 1.2}, ImageSize -> 460,
  Epilog -> {Text[Style["helical core axis region", 11], Scaled[{0.28, 0.93}]],
    Text[Style["corrugated q = 1 surface", 11], Scaled[{0.75, 0.12}]]}];
ax3d = ParametricPlot3D[{xi0 Cos[ph], xi0 Sin[ph], 30 ph}, {ph, 0, 2 Pi},
  PlotStyle -> Directive[Red, Thick]];
Export[FileNameJoin[{figdir, "fig_helical_core_3d.pdf"}], Show[core3d, ax3d]];
Print["    exported fig_helical_core_3d.pdf"];
check["Fig: 3D helical core exported",
  FileByteCount[FileNameJoin[{figdir, "fig_helical_core_3d.pdf"}]] > 5000];

(* Misalignment: flux surface vs equipotential in one poloidal cut,
   E_perp^(MA) arrows tangent to the flux surface, length ~ mismatch. *)
r0 = 10.; delB = 2.0; delPhi = 1.4; dphase = 0.7;
fluxCurve = Table[(r0 - delB Cos[th]) {Cos[th], Sin[th]}, {th, 0, 2 Pi, 0.02}];
potCurve = Table[(r0 - delPhi Cos[th - dphase]) {Cos[th], Sin[th]},
  {th, 0, 2 Pi, 0.02}];
mism[th_] := delPhi Cos[th - dphase] - delB Cos[th];
arrows = Table[With[{p = (r0 - delB Cos[th]) {Cos[th], Sin[th]},
    tang = Normalize[D[(r0 - delB Cos[t]) {Cos[t], Sin[t]}, t] /. t -> th]},
    Arrow[{p, p + 2.2 mism[th] tang}]], {th, 0.3, 2 Pi, 2 Pi/14}];
figM = Graphics[{
  {ColorData[97, 1], Thick, Line[fluxCurve]},
  {ColorData[97, 2], Thick, Dashed, Line[potCurve]},
  {ColorData[97, 4], Arrowheads[0.02], arrows},
  Text[Style["corrugated flux surface \[Rho] = const", 12, ColorData[97, 1]],
    {0, -13.5}],
  Text[Style["equipotential \[CapitalPhi] = const", 12, ColorData[97, 2]],
    {0, 13.5}],
  Text[Style["\!\(\*SubsuperscriptBox[\(E\), \(\[UpTee]\), \((MA)\)]\) \[Proportional] misalignment", 12,
    ColorData[97, 4]], {10.5, 8.5}],
  Text[Style[
    "\!\(\*SubscriptBox[\(j\), \(\[DoubleVerticalBar]\)]\) \[Proportional] \!\(\*SubsuperscriptBox[\(E\), \(\[UpTee]\), \((MA)\)]\)(\!\(\*SubscriptBox[\(A\), \(1\)]\) + \!\(\*FractionBox[SuperscriptBox[\(mv\), \(2\)], \(2  T\)]\)\!\(\*SubscriptBox[\(A\), \(2\)]\))", 12], {-10.5, -8.5}]},
  PlotRange -> {{-16, 16}, {-15, 15}}, ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_misalignment.pdf"}], figM];
Print["    exported fig_misalignment.pdf"];
check["Fig: misalignment geometry exported",
  FileByteCount[FileNameJoin[{figdir, "fig_misalignment.pdf"}]] > 5000];

(* RMP shielding vs flux pumping: same mechanism, different location.
   Mode labels are in the ADOPTED memo convention (2026-07-18): chi =
   m th + n ph with Sergei's toroidal angle, iota = +1/q > 0, and the m > 0
   members (1, -1) and (6, -2) of the real harmonics whose (-1, 1)/(-6, 2)
   conjugates are Sergei's representatives. The real cosine harmonics are
   identical across conventions, so the geometry drawn below (evaluated at
   the ph = 0 cut shared by all conventions) is unchanged by relabelling.
   The pre-2026-07-18 report orientation (reversed toroidal angle,
   conjugate labels (1, 1)/(6, 2), iota = -1/q) is kept below as verified
   history. *)
check["Fig: old report (1,1) harmonic equals Sergei (-1,1) harmonic under toroidal reversal (historical)",
  FullSimplify[(Cos[th + phRep] /. phRep -> -phS) == Cos[-th + phS]]];
check["Fig: old report (6,2) harmonic equals Sergei (-6,2) harmonic under toroidal reversal (historical)",
  FullSimplify[(Cos[6 th + 2 phRep] /. phRep -> -phS) == Cos[-6 th + 2 phS]]];
check["Fig: old report modes (1,1) and (6,2) resonant at q = 1 and q = 3 under the old iota = -1/q (historical)",
  1 (-1/1) + 1 == 0 && 6 (-1/3) + 2 == 0];
check["Fig: adopted labels (1,-1) and (6,-2) resonant at q = 1 and q = 3 (m iota + n = 0, iota = +1/q)",
  1 (1/1) - 1 == 0 && 6 (1/3) - 2 == 0];
edgeSurf[rho_, del_] := Table[(rho - del Cos[6 th]) {Cos[th], Sin[th]},
  {th, 0, 2 Pi, 0.01}];
figU = GraphicsRow[{
  Graphics[{
    {Gray, Thin, Circle[{0, 0}, #] & /@ {4, 8, 12, 16}},
    {ColorData[97, 1], Thick, Line[edgeSurf[20, 0.7]]},
    {ColorData[97, 4], Thickness[0.012], Opacity[0.7],
      Line[edgeSurf[20, 0.7]]},
    Text[Style["shielding current layer\n(m, n) ~ (6, -2), q = 3", 11],
      {0, -24}],
    Text[Style["RMP coils", 10, Italic], {0, 24.5}],
    {Gray, Thick, Table[Rectangle[{-2 + 12 Cos[a] 1.9, -1 + 12 Sin[a] 1.9},
      {2 + 12 Cos[a] 1.9, 1 + 12 Sin[a] 1.9}], {a, {Pi/2}}]}},
    PlotRange -> {{-27, 27}, {-27, 27}}, ImageSize -> 300,
    PlotLabel -> Style["RMP shielding (edge)", 13]],
  Graphics[{
    {Gray, Thin, Circle[{0, 0}, #] & /@ {16, 20, 24}},
    {ColorData[97, 1], Thick,
      Line /@ Table[surf[rho, 0], {rho, {4., 7., 10., 13.}}]},
    {ColorData[97, 4], Thickness[0.012], Opacity[0.7], Line[surf[10., 0]]},
    {Red, PointSize[0.02], Point[{xi0, 0}]},
    Text[Style["helical current on corrugated\nsurfaces, (m, n) = (1, -1), q = 1", 11],
      {0, -24}]},
    PlotRange -> {{-27, 27}, {-27, 27}}, ImageSize -> 300,
    PlotLabel -> Style["flux pumping (core)", 13]]},
  ImageSize -> 640];
Export[FileNameJoin[{figdir, "fig_rmp_fp_unified.pdf"}], figU];
Print["    exported fig_rmp_fp_unified.pdf"];
check["Fig: RMP/FP unification panel exported",
  FileByteCount[FileNameJoin[{figdir, "fig_rmp_fp_unified.pdf"}]] > 5000];

reportAndExit[];

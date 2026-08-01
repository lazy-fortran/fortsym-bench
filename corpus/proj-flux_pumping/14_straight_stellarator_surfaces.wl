(* Straight l=1 helical-core model after SK mail 2026-07-07:
   helical displacement of circular flux surfaces, exact divergence-free
   surface current, and analytic field-line and m=1 Ampere solutions. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];

ClearAll[rho, th, zet, r, x, y, d0, lhel, psi, iot, qtok, Jamp, beta,
  rc, aRad, src, rad, ang, zz, ar];

ass = rho > 0 && r > 0 && d0 > 0 && rc > 0;

(* ==== 1. l=1 helical displacement surfaces ==== *)

dAxis[s_] := d0 Exp[-(s/8)^4];
xMap[s_, u_, v_] := dAxis[s] Cos[v] + s Cos[u];
yMap[s_, u_, v_] := -dAxis[s] Sin[v] + s Sin[u];

rho2ConstShift[xx_, yy_] :=
  (xx - d0 Cos[zet])^2 + (yy + d0 Sin[zet])^2;
psiConstShift[xx_, yy_] := rho2ConstShift[xx, yy]/2;
rho2OnSurface[s_, xx_, yy_, v_] :=
  (xx - dAxis[s] Cos[v])^2 + (yy + dAxis[s] Sin[v])^2;

check["Hel1: l=1 constant-shift flux label returns rho^2",
  FullSimplify[
    rho2ConstShift[d0 Cos[zet] + rho Cos[th],
      -d0 Sin[zet] + rho Sin[th]] == rho^2, ass]];

psiFirstOrder = FullSimplify[
  Normal@Series[
    psiConstShift[r Cos[th], r Sin[th]], {d0, 0, 1}],
  ass];
check["Hel1: l=1 first-order flux function is a helical displacement",
  FullSimplify[
    psiFirstOrder == r^2/2 - r d0 Cos[th + zet], ass]];

pos = {xMap[rho, th, zet], yMap[rho, th, zet], zet};
jac = FullSimplify[Det[D[pos, {{rho, th, zet}}]], rho > 0];
check["Hel1: shifted-surface Jacobian is regular for small displacement shear",
  FullSimplify[jac == rho (1 + dAxis'[rho] Cos[th + zet]), rho > 0]];

surfPts[r0_, z0_] := Table[
  {xMap[r0, u, z0], yMap[r0, u, z0]},
  {u, 0., 2 Pi, 2 Pi/240}];

rhoMax = 12.;
d0Val = 2.4;
surfPtsNum[r0_, z0_] := surfPts[r0, z0] /. d0 -> d0Val;
panel[z0_, lab_] := Graphics[{
    {Gray, Thin, Line /@ Table[surfPtsNum[r0, z0], {r0, {4., 7., 10., 12.}}]},
    {ColorData[97, 1], Thick, Line /@ Table[surfPtsNum[r0, z0], {r0, {2., 5., 8.}}]},
    {Black, PointSize[0.016], Point[{dAxis[0] Cos[z0], -dAxis[0] Sin[z0]} /. d0 -> d0Val]},
    Text[Style[lab, 12], {0, -15.4}]},
  PlotRange -> {{-17, 17}, {-17, 17}}, ImagePadding -> 18, ImageSize -> 205];

(* Figure labels use the report's coordinate naming: the axial angle is
   phi = z/R (flux_pumping.tex Sec. 1.1), not zeta. *)
figSurf = GraphicsRow[
  {panel[0., "\[CurlyPhi] = 0"],
   panel[Pi/2, "quarter helical turn"],
   panel[Pi, "half helical turn"]},
  ImageSize -> 680];
Export[FileNameJoin[{figdir, "fig_stell_surfaces.pdf"}], figSurf];
check["Hel1: l=1 displaced-surface figure exported",
  FileByteCount[FileNameJoin[{figdir, "fig_stell_surfaces.pdf"}]] > 5000];

(* ==== 2. q profile belongs to tokamak closure, not to this surface model ==== *)

qCore = 1.005;
qEdge = 1.23;
qWidth = 8.5;
qProf[x_?NumericQ] := qCore + (qEdge - qCore) (1 - Exp[-(x/qWidth)^4]);
iotaProf[x_?NumericQ] := -1/qProf[x];

check["Hel2: q profile is clamped just above one on axis",
  Abs[qProf[0.] - qCore] < 10^-12 && Abs[iotaProf[0.] + 1/qCore] < 10^-12];
check["Hel2: q profile shears upward outside the core",
  qProf[0.] < qProf[8.] < qProf[12.]];

figIota = Plot[{qProf[x], iotaProf[x]}, {x, 0, rhoMax},
  PlotStyle -> {Directive[Thick, ColorData[97, 1]], Directive[Dashed, ColorData[97, 4]]},
  Frame -> True, FrameLabel -> {"surface label \[Rho] [arb.]", "q, \[Iota]"},
  PlotLegends -> Placed[{"q(\[Rho])", "\[Iota](\[Rho])=-1/q"}, {0.76, 0.28}],
  PlotRange -> {{0, rhoMax}, {-1.12, 1.32}}, ImageSize -> 460,
  Epilog -> {Gray, Dotted, Line[{{0, 1}, {rhoMax, 1}}],
    Gray, Dotted, Line[{{0, -1}, {rhoMax, -1}}]}];
Export[FileNameJoin[{figdir, "fig_stell_iota.pdf"}], figIota];
check["Hel2: q/iota profile figure exported",
  FileByteCount[FileNameJoin[{figdir, "fig_stell_iota.pdf"}]] > 5000];

(* ==== 3. Analytic field-line map ==== *)

fieldPoint[r0_?NumericQ, th0_?NumericQ, z0_?NumericQ] :=
  {xMap[r0, th0 + iotaProf[r0] z0, z0],
   yMap[r0, th0 + iotaProf[r0] z0, z0]} /. d0 -> d0Val;

check["Hel3: analytic field-line map preserves the shifted flux label",
  Max@Table[
      Abs[(rho2OnSurface[5., Sequence @@ fieldPoint[5., 0.31, z0], z0] /.
          d0 -> d0Val) - 25.],
      {z0, 0., 6 Pi, Pi/9}] < 10^-11];

poincare = Flatten[
  Table[Table[fieldPoint[r0, 0.37 + 0.11 r0, 2 Pi k],
      {k, 0, 140}], {r0, {3., 5., 7., 9., 11.}}],
  1];

figPoincare = Show[
  Graphics[{Directive[Gray, Thin, Opacity[0.45]],
    Line /@ Table[surfPtsNum[r0, 0.], {r0, {3., 5., 7., 9., 11.}}]}],
  ListPlot[poincare,
    PlotStyle -> Directive[PointSize[0.004], ColorData[97, 1]]],
  AspectRatio -> 1, Frame -> True, Axes -> False,
  FrameLabel -> {"x at \[CurlyPhi]=0", "y at \[CurlyPhi]=0"},
  PlotRange -> {{-17, 17}, {-17, 17}}, ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_stell_poincare.pdf"}], figPoincare];
check["Hel3: analytic Poincare figure exported",
  FileByteCount[FileNameJoin[{figdir, "fig_stell_poincare.pdf"}]] > 5000];

(* ==== 4. Exact current continuity with small tangential perpendicular current ==== *)

ClearAll[psi, theta, zeta, iot, Bzeta, Lam, beta, sqrtg];
alpha = theta + zeta + beta[psi];
densityZeta = Lam[psi] Cos[alpha];
densityThetaExact = -densityZeta;
densityThetaParallel = iot densityZeta;

divExact = D[densityThetaExact, theta] + D[densityZeta, zeta];
divParallel = D[densityThetaParallel, theta] + D[densityZeta, zeta];

check["Hel4: j^theta/j^zeta=-1 gives exact surface-current continuity",
  FullSimplify[divExact == 0]];
check["Hel4: pure parallel current leaves O(iota+1) divergence",
  FullSimplify[divParallel == -(1 + iot) Lam[psi] Sin[alpha]]];

bTan = {iot, 1};
jTot = {-1, 1};
jPar = FullSimplify[(jTot.bTan)/(bTan.bTan) bTan];
jPerp = FullSimplify[jTot - jPar];

check["Hel4: added tangential current is perpendicular to B in orthonormal tangent metric",
  FullSimplify[jPerp.bTan == 0, Element[iot, Reals]]];
check["Hel4: perpendicular correction vanishes at the q=1 plateau",
  FullSimplify[jPerp /. iot -> -1] == {0, 0}];
check["Hel4: perpendicular correction is first order in iota+1",
  FullSimplify[D[jPerp, iot] /. iot -> -1] == {-1/2, -1/2}];

(* ==== 5. Agreement with the initial cylinder model ==== *)

ClearAll[Del, mTok, nTok, alTok, beta0, jmTok];
rhoL1Linear = r - d0 Cos[th + zet];
rhoTokLinear = r + Del Cos[mTok th + nTok zet + alTok];

check["Hel5: l=1 label is the initial cylinder corrugation for the unit helical phase",
  FullSimplify[(rhoTokLinear /. {mTok -> 1, nTok -> 1,
       alTok -> Pi, Del -> d0}) == rhoL1Linear, ass]];

sgJzetaTok = jmTok[r] Cos[mTok th + nTok zet + beta0];
sgJthetaTok = -(nTok/mTok) sgJzetaTok;
check["Hel5: initial cylinder current rule gives Sergei ratio -1 for the unit helical phase",
  FullSimplify[(sgJthetaTok/sgJzetaTok /. {mTok -> 1, nTok -> 1}) == -1]];
check["Hel5: initial cylinder current rule is exactly divergence-free for the same phase",
  FullSimplify[
    D[sgJthetaTok, th] + D[sgJzetaTok, zet] == 0 /. {mTok -> 1, nTok -> 1}]];

(* ==== 6. Analytic Ampere solution for a regular m=1 current harmonic ==== *)

ClearAll[rr, rcSym];
srcAna[rr_] := (rr/rcSym) Exp[-(rr/rcSym)^2];
aAna[rr_] := rcSym^3/(4 rr) (1 - Exp[-(rr/rcSym)^2]);
radialOp[f_] := D[f[rr], {rr, 2}] + D[f[rr], rr]/rr - f[rr]/rr^2;

check["Hel6: analytic Green-function Ampere solve satisfies the radial ODE",
  FullSimplify[radialOp[aAna] == -srcAna[rr], rr > 0 && rcSym > 0]];
check["Hel6: analytic Ampere solution is regular on axis",
  FullSimplify[Limit[aAna[rr], rr -> 0, Direction -> "FromAbove"] == 0,
    rcSym > 0]];
check["Hel6: analytic Ampere solution has the exterior 1/r tail",
  FullSimplify[Limit[rr aAna[rr], rr -> Infinity] == rcSym^3/4,
    rcSym > 0]];

rcVal = 7.;
aPlot[x_?NumericQ] := aAna[x] /. rcSym -> rcVal;
srcPlot[x_?NumericQ] := srcAna[x] /. rcSym -> rcVal;
redge = 18.;

ClearAll[avec, br, bth, divb, curlz];
avec[rad_, ang_, zz_] := ar[rad] Cos[ang + zz];
br[rad_, ang_, zz_] := D[avec[rad, ang, zz], ang]/rad;
bth[rad_, ang_, zz_] := -D[avec[rad, ang, zz], rad];
divb = FullSimplify[
  1/rad D[rad br[rad, ang, zz], rad] +
    1/rad D[bth[rad, ang, zz], ang],
  rad > 0];
curlz = FullSimplify[
  1/rad (D[rad bth[rad, ang, zz], rad] -
      D[br[rad, ang, zz], ang]),
  rad > 0];

check["Hel6: B from analytic A_z is exactly solenoidal",
  divb == 0];
check["Hel6: curl B recovers the m=1 current operator",
  FullSimplify[
    curlz == -(ar''[rad] + ar'[rad]/rad - ar[rad]/rad^2)
      Cos[ang + zz], rad > 0]];

figCurrent = DensityPlot[
  With[{rval = Sqrt[x^2 + y^2], aval = ArcTan[x, y]},
    If[rval <= redge, srcPlot[rval] Cos[aval], Indeterminate]],
  {x, -redge, redge}, {y, -redge, redge},
  PlotPoints -> 45, MaxRecursion -> 1, ColorFunction -> "TemperatureMap",
  Frame -> True, FrameLabel -> {"x", "y"},
  PlotLegends -> BarLegend[Automatic, LegendLabel -> "j^\[CurlyPhi] harmonic"],
  ImageSize -> 430];
Export[FileNameJoin[{figdir, "fig_stell_current_source.pdf"}], figCurrent];
check["Hel6: helical current source figure exported",
  FileByteCount[FileNameJoin[{figdir, "fig_stell_current_source.pdf"}]] > 5000];

bVec[x_?NumericQ, y_?NumericQ] := Module[
  {rval = Sqrt[x^2 + y^2], aval, brv, btv},
  If[rval < 0.25 || rval > redge, {0, 0},
    aval = ArcTan[x, y];
    brv = -aPlot[rval] Sin[aval]/rval;
    btv = -Evaluate[D[aAna[rr], rr] /. {rr -> rval, rcSym -> rcVal}] Cos[aval];
    brv {Cos[aval], Sin[aval]} + btv {-Sin[aval], Cos[aval]}]];

figField = Show[
  VectorPlot[Evaluate[bVec[x, y]], {x, -redge, redge}, {y, -redge, redge},
    VectorPoints -> 23, VectorScale -> {Small, Scaled[0.55], None},
    VectorStyle -> ColorData[97, 1], Frame -> True,
    FrameLabel -> {"x", "y"}, PlotRange -> All, ImageSize -> 450],
  ContourPlot[Sqrt[x^2 + y^2], {x, -redge, redge}, {y, -redge, redge},
    Contours -> {4, 8, 12, 16}, ContourStyle -> Directive[Gray, Thin],
    ContourShading -> False]];
Export[FileNameJoin[{figdir, "fig_stell_current_field.pdf"}], figField];
check["Hel6: analytic helical-current magnetic field figure exported",
  FileByteCount[FileNameJoin[{figdir, "fig_stell_current_field.pdf"}]] > 5000];

reportAndExit[];

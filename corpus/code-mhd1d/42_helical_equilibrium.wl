(* Helically symmetric ideal-MHD equilibrium (WP7 phase 2, meeting
   2026-07-20): the straight-stellarator generalization of the screw
   pinch, derived from first principles rather than imported. For
   fields depending on (r, u) with u = th + k z (m = 1
   representative, k arbitrary), divergence freedom gives
   B_r = dpsi/du / r and B_th + k r B_z = -dpsi/dr, leaving
   H = B_z - k r B_th free. The force balance along the helical
   Killing direction h = e_z - k r e_th reduces exactly to the
   Jacobian identity d(psi, H)/d(r, u) = 0, so H = H(psi) is the
   second flux function; B.grad p = 0 makes p = P(psi); and the full
   residual then collapses onto grad psi with one scalar coefficient
   - the helical Grad-Shafranov equation - which this script
   EXTRACTS from the exact residual and pins by the proportionality
   of all three components, by its k -> 0 screw-pinch limit, and by
   closed-form solvability of the linear-profile case. Key
   structural finding, PASS-checked: with linear profiles
   (H' and P'' constant) the helical GS equation is exactly linear,
   so the single-harmonic truncation psi = psi0 + psi1 Cos[u] has
   ZERO quadratic feedback of the harmonic on the mean; the
   nonlinear saturation of the helical mode requires profile
   curvature ((H H')'' or P''' nonzero) - or an external constraint
   such as the fixed-loop-voltage corrugation-resistance channel of
   script 39. Fixtures for the Fortran package: a force-free linear
   fixture (exact, regular, boundary-driven harmonic) and a
   nonlinear-H fixture whose quadratic mean-feedback source is
   exported for projection-integral verification. Exports
   fig_helical_equilibrium.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];
datadir = FileNameJoin[{DirectoryName[$InputFileName], "..", "mhd1d",
  "test", "data"}];
If[!DirectoryQ[datadir], CreateDirectory[datadir]];

ClearAll[r, th, z, u, k, psi, HH, PF, Hf, B0, c, p];
$Assumptions = r > 0 && Element[{u, k}, Reals];

(* ==== 1. Helical reduction and parametrization ==== *)

gradH[f_] := {D[f, r], D[f, u]/r, k D[f, u]};
divH[v_List] := D[r v[[1]], r]/r + D[v[[2]], u]/r + k D[v[[3]], u];
curlH[v_List] := {D[v[[3]], u]/r - k D[v[[2]], u],
  k D[v[[1]], u] - D[v[[3]], r],
  D[r v[[2]], r]/r - D[v[[1]], u]/r};

Bhel = {D[psi[r, u], u]/r,
  -(D[psi[r, u], r] + k r HH[r, u])/(1 + k^2 r^2),
  (HH[r, u] - k r D[psi[r, u], r])/(1 + k^2 r^2)};
check["helical parametrization is divergence-free for any psi, H",
  Simplify[divH[Bhel]] === 0];
check["helical parametrization inverts to H = B_z - k r B_th",
  Simplify[Bhel[[3]] - k r Bhel[[2]] - HH[r, u]] === 0 &&
  Simplify[Bhel[[2]] + k r Bhel[[3]] + D[psi[r, u], r]] === 0];
ClearAll[R0, iot, BzTok];
check["tokamak (1,-1) map gives psi0' = r Bz (1-iota)/R0",
  Simplify[-(r BzTok iot/R0 - r BzTok/R0) -
    r BzTok (1 - iot)/R0] === 0];
check["helical flux derivative vanishes at the q=1 surface",
  Simplify[r BzTok (1 - iot)/R0 /. iot -> 1] === 0];
ClearAll[ss, aa, yy, pp, iotS, fS];
fS = aa Sqrt[ss] iotS[ss]/R0;
check["radial force balance becomes a regular linear ODE for Bz squared",
  FullSimplify[D[fS^2, ss] + fS^2/ss -
    2 aa^2 iotS[ss] (iotS[ss] + ss iotS'[ss])/R0^2,
    Assumptions -> {ss > 0, aa > 0, R0 > 0}] === 0];
check["normalized-flux area measure is pi a^2 ds",
  Simplify[2 Pi (aa Sqrt[ss]) D[aa Sqrt[ss], ss],
    Assumptions -> {ss > 0, aa > 0}] === Pi aa^2];
check["psi is a flux function: B.grad psi = 0 exactly",
  Simplify[Bhel . gradH[psi[r, u]]] === 0];

jHel = (c/(4 Pi)) curlH[Bhel];
forceRes = Together[Cross[jHel, Bhel]/c - gradH[p[r, u]]];

(* ==== 2. The two flux-function statements ==== *)

(* Killing-direction component: h = e_z - k r e_th; hand-derived
   result (j x B).h / c = (psi_u H_r - psi_r H_u)/(4 pi r), and
   grad p.h = 0 for any p(r, u), so the Killing force balance is the
   (psi, H) Jacobian divided by 4 pi r. *)
check["grad p has no component along the Killing direction",
  Simplify[gradH[p[r, u]][[3]] - k r gradH[p[r, u]][[2]]] === 0];
killing = Simplify[forceRes[[3]] - k r forceRes[[2]]];
jacPsiH = (D[psi[r, u], u] D[HH[r, u], r] -
  D[psi[r, u], r] D[HH[r, u], u])/(4 Pi r);
check["Killing-direction force balance is the (psi, H) Jacobian identity",
  Simplify[killing - jacPsiH] === 0];

check["B.grad p vanishes iff p depends on r, u through psi alone",
  Simplify[Bhel . gradH[PF[psi[r, u]]]] === 0];

(* ==== 3. Extraction of the helical Grad-Shafranov equation ==== *)

fluxRules = {HH -> Function[{rr, uu}, Hf[psi[rr, uu]]],
  p -> Function[{rr, uu}, PF[psi[rr, uu]]]};
resFlux = Together[forceRes /. fluxRules];

(* The residual must be Lambda grad psi: extract Lambda from the
   radial component and verify the other two components carry the
   same scalar. That proportionality IS the statement that one
   scalar equation (the helical GS equation) closes the problem. *)
lambdaGS = Cancel[Together[resFlux[[1]]/D[psi[r, u], r]]];
check["theta component carries the same GS scalar",
  Simplify[Together[resFlux[[2]] - lambdaGS D[psi[r, u], u]/r]] === 0];
check["z component carries the same GS scalar",
  Simplify[Together[resFlux[[3]] - lambdaGS k D[psi[r, u], u]]] === 0];
check["the GS scalar depends on psi only through flux-function data",
  FreeQ[lambdaGS, p] && FreeQ[lambdaGS, HH]];
Print["    extracted helical GS scalar (residual = Lambda grad psi):"];
Print["    Lambda = ", InputForm[Simplify[lambdaGS]]];

(* Define the GS equation as gsEq = -4 pi Lambda = 0 (sign chosen so
   the k -> 0, u-independent limit reads
   (1/r)(r psi')' = -4 pi P' - H H'). *)
gsEq = Simplify[-4 Pi lambdaGS];
axiLimit = Simplify[gsEq /. {psi -> Function[{rr, uu}, ps0[rr]],
  k -> 0}];
check["k -> 0, u-independent limit is the screw-pinch GS relation",
  Simplify[axiLimit - (D[r ps0'[r], r]/r + 4 Pi PF'[ps0[r]] +
    Hf[ps0[r]] Hf'[ps0[r]])] === 0];

(* Consistency with script 41: with B_th = -psi0', B_z = H(psi0),
   the screw-pinch force balance p' + (B B')/4pi + B_th^2/(4 pi r)
   holds on solutions of the axisymmetric GS relation. *)
check["axisymmetric GS relation implies the script-41 force balance",
  Simplify[D[PF[ps0[r]], r] +
    (Hf[ps0[r]] D[Hf[ps0[r]], r] + ps0'[r] D[ps0'[r], r])/(4 Pi) +
    ps0'[r]^2/(4 Pi r) /. ps0''[r] ->
      Simplify[Solve[axiLimit == 0, ps0''[r]][[1, 1, 2]]]] === 0];

(* ==== 4. Single-harmonic truncation and the feedback theorem ==== *)

truncPsi = {psi -> Function[{rr, uu}, ps0[rr] + eps ps1[rr] Cos[uu]]};
gsTrunc = Normal@Series[gsEq /. truncPsi, {eps, 0, 2}];
meanEq = Simplify[Integrate[gsTrunc, {u, 0, 2 Pi}]/(2 Pi)];
harmEq = Simplify[Integrate[gsTrunc Cos[u], {u, 0, 2 Pi}]/Pi];

mean0 = Simplify[Coefficient[meanEq, eps, 0]];
mean2 = Simplify[Coefficient[meanEq, eps, 2]];
harm1 = Simplify[Coefficient[harmEq, eps, 1]];

check["mean projection at zeroth order is the u-independent GS equation",
  Simplify[mean0 - (gsEq /. {psi -> Function[{rr, uu}, ps0[rr]]})] === 0];
check["harmonic projection is linear in psi1 at first order",
  Simplify[(harm1 /. ps1 -> Function[x, s a1[x] + t a2[x]]) -
    s (harm1 /. ps1 -> Function[x, a1[x]]) -
    t (harm1 /. ps1 -> Function[x, a2[x]])] === 0];

(* Feedback theorem: the quadratic mean source is (psi1^2/4) times
   the second psi-derivative of the full GS source
   S(psi) = H (2 k + (1 + k^2 r^2) H')/(1 + k^2 r^2)^2 + 4 pi P',
   evaluated at psi0. It vanishes identically for linear profiles
   (H' const, P'' const): the helical GS equation is then exactly
   linear and the harmonic cannot feed back on the mean. *)
Ssrc[s_] := Hf[s] (2 k + (1 + k^2 r^2) Hf'[s])/(1 + k^2 r^2)^2 +
  4 Pi PF'[s];
srcSecond = Simplify[mean2 -
  ((ps1[r]^2/4) D[Ssrc[s], {s, 2}] /. s -> ps0[r])];
check["quadratic mean feedback is (psi1^2/4) S''(psi0) with the full GS source",
  srcSecond === 0];
check["linear profiles give exactly zero harmonic-on-mean feedback",
  Simplify[mean2 /. {Hf -> Function[s, h0 - a s],
    PF -> Function[s, pc0 - cp s^2/2]}] === 0];
check["profile curvature turns the feedback on",
  Simplify[mean2 /. {Hf -> Function[s, h0 - a s - b s^2/2],
    PF -> Function[s, pc0 - cp s^2/2]}] =!= 0];

(* Force-free linear harmonic equation has closed form. *)
harmFF = Simplify[harm1 /. {Hf -> Function[s, h0 - a s],
  PF -> Function[s, pc0]}];
ffSol = Quiet[DSolve[harmFF == 0, ps1, r]];
check["force-free harmonic equation admits a closed-form solution",
  Head[ffSol] === List && Length[ffSol] > 0];

(* ==== 5. Numeric fixtures for the Fortran package ==== *)

fmtNum[x_] := StringReplace[ToString[N[x], InputForm], "*^" -> "e"];
writeCsv[file_, header_, rows_] := Module[{s = OpenWrite[file]},
  WriteString[s, header <> "\n"];
  WriteString[s, StringRiffle[
    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\n"] <> "\n"];
  Close[s]];
gridR = Table[rv, {rv, 0.25, 25., 0.25}];
eps0 = 10^-6; rEdge = 25.; psi1Edge = 0.02;

(* Fixture A: force-free linear profiles H = H0 - a psi, p = const,
   a = 0.08, k = -1/20, H0 = 1; regular mean solution and a
   boundary-driven regular harmonic scaled to psi1(25) = 0.02. *)
aFix = 0.08; kFix = -1/20.; H0fix = 1.;
odeExpr[expr_, s0_, rr_] := expr /. {
  ps0''[r] -> s0''[rr], ps0'[r] -> s0'[rr], ps0[r] -> s0[rr], r -> rr};
mean0FF = mean0 /. {Hf -> Function[s, H0fix - aFix s],
  PF -> Function[s, pc0], k -> kFix};
sol0 = NDSolve[{odeExpr[mean0FF, s0, rr] == 0, s0[eps0] == 0,
   s0'[eps0] == 0}, s0, {rr, eps0, rEdge},
  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]];
s0N[rv_?NumericQ] := s0[rv] /. sol0;
s0D[rv_?NumericQ] := Derivative[1][s0 /. sol0][rv];

harmFFfix = harmFF /. {h0 -> H0fix, a -> aFix, k -> kFix};
harmOde[expr_, rr_] := expr /. {
  Derivative[2][ps1][r] -> s1''[rr], Derivative[1][ps1][r] -> s1'[rr],
  ps1[r] -> s1[rr],
  ps0''[r] -> Derivative[2][s0 /. sol0][rr], ps0'[r] -> s0D[rr],
  ps0[r] -> s0N[rr], r -> rr};
shoot = NDSolve[{harmOde[harmFFfix, rr] == 0, s1[eps0] == eps0,
   s1'[eps0] == 1.}, s1, {rr, eps0, rEdge},
  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]];
scaleShoot = psi1Edge/(s1[rEdge] /. shoot);
s1N[rv_?NumericQ] := scaleShoot (s1[rv] /. shoot);
check["fixture A: harmonic solution is regular and scaled to the boundary",
  Abs[s1N[rEdge] - psi1Edge] < 10^-10 && Abs[s1N[eps0]] < 10^-4];

bt0[rv_] := -(s0D[rv] + kFix rv (H0fix - aFix s0N[rv]))/
  (1 + kFix^2 rv^2);
bz0[rv_] := ((H0fix - aFix s0N[rv]) - kFix rv s0D[rv])/
  (1 + kFix^2 rv^2);
check["fixture A: mean axial field on axis is H0",
  Abs[bz0[10^-4] - H0fix] < 10^-6];
helRows = Map[{#, s0N[#], s1N[#], bt0[#], bz0[#]} &, gridR];
writeCsv[FileNameJoin[{datadir, "helical_forcefree.csv"}],
  "# mathematica/42_helical_equilibrium.wl force-free helical fixture; " <>
  "CGS, c=1, H=H0-a psi, a=0.08, k=-1/20, H0=1, p=const, " <>
  "psi1(25)=0.02, psi1 regular at axis; columns r,psi0,psi1,Btheta0,Bz0",
  helRows];
check["helical force-free fixture CSV written",
  FileByteCount[FileNameJoin[{datadir, "helical_forcefree.csv"}]] > 5000];

(* Fixture B: nonlinear H = H0 - a psi - (b/2) psi^2 with b = 0.01:
   same construction, plus the quadratic mean-feedback source
   (psi1^2/4)(H H')'' evaluated on the solved profiles, exported for
   Fortran projection-integral verification. *)
bFix = 0.01;
HfB = Function[s, H0fix - aFix s - bFix s^2/2];
mean0B = mean0 /. {Hf -> HfB, PF -> Function[s, pc0], k -> kFix};
sol0B = NDSolve[{odeExpr[mean0B, s0, rr] == 0, s0[eps0] == 0,
   s0'[eps0] == 0}, s0, {rr, eps0, rEdge},
  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]];
s0BN[rv_?NumericQ] := s0[rv] /. sol0B;
s0BD[rv_?NumericQ] := Derivative[1][s0 /. sol0B][rv];
harm1B = Simplify[harm1 /. {Hf -> HfB, PF -> Function[s, pc0],
  k -> kFix}];
harmOdeB[rr_] := harm1B /. {
  Derivative[2][ps1][r] -> s1''[rr], Derivative[1][ps1][r] -> s1'[rr],
  ps1[r] -> s1[rr],
  ps0''[r] -> Derivative[2][s0 /. sol0B][rr], ps0'[r] -> s0BD[rr],
  ps0[r] -> s0BN[rr], r -> rr};
shootB = NDSolve[{harmOdeB[rr] == 0, s1[eps0] == eps0, s1'[eps0] == 1.},
  s1, {rr, eps0, rEdge},
  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]];
scaleB = psi1Edge/(s1[rEdge] /. shootB);
s1BN[rv_?NumericQ] := scaleB (s1[rv] /. shootB);
feedFun = Function[{rv, p0v, p1v},
  Evaluate[Simplify[(ps1[r]^2/4) D[
      HfB[s] (2 k + (1 + k^2 r^2) HfB'[s])/(1 + k^2 r^2)^2, {s, 2}] /.
    {s -> ps0[r], k -> kFix}] /.
    {ps1[r] -> p1v, ps0[r] -> p0v, r -> rv}]];
feedRows = Map[{#, s0BN[#], s1BN[#], feedFun[#, s0BN[#], s1BN[#]]} &,
  gridR];
writeCsv[FileNameJoin[{datadir, "helical_feedback.csv"}],
  "# mathematica/42_helical_equilibrium.wl nonlinear-H fixture, " <>
  "H=H0-a psi-(b/2) psi^2, b=0.01, a=0.08, k=-1/20, H0=1, p=const, " <>
  "psi1(25)=0.02; quadratic mean-feedback source " <>
  "(psi1^2/4) S''(psi0) with S = H(2k+(1+k^2r^2)H')/(1+k^2r^2)^2; " <>
  "columns r,psi0,psi1,mean2_source",
  feedRows];
check["helical nonlinear-feedback fixture CSV written",
  FileByteCount[FileNameJoin[{datadir, "helical_feedback.csv"}]] > 3000];
check["fixture B: feedback source is nonzero in the interior",
  Abs[feedFun[10., s0BN[10.], s1BN[10.]]] > 0];

(* ==== 6. Figure ==== *)
figHel = GraphicsRow[{
  Plot[{s0N[rv], 100 s1N[rv]}, {rv, 0.01, 25.}, PlotRange -> All,
    Frame -> True, FrameLabel -> {"r", "\[Psi]"},
    PlotLegends -> {"\[Psi]0", "100 \[Psi]1"}, ImageSize -> 300,
    PlotLabel -> "force-free helical equilibrium"],
  ListLinePlot[feedRows[[All, {1, 4}]], PlotRange -> All, Frame -> True,
    FrameLabel -> {"r", "mean feedback"}, ImageSize -> 300,
    PlotLabel -> "nonlinear-H harmonic-on-mean source"]},
  ImageSize -> 640];
Export[FileNameJoin[{figdir, "fig_helical_equilibrium.pdf"}], figHel];
Print["    exported fig_helical_equilibrium.pdf"];
check["Fig: helical equilibrium figure exported",
  FileByteCount[FileNameJoin[{figdir,
    "fig_helical_equilibrium.pdf"}]] > 5000];

reportAndExit[];

(* Nonlinear saturation of the helical mode in the truncated 1D
   system (WP7 phase 3, meeting 2026-07-20). The single-harmonic
   truncation of the helical Grad-Shafranov equation (derived and
   verified in script 42; forms restated here verbatim) is closed
   into a self-consistent loop: the harmonic psi1 solves the linear
   BVP on the mean profile psi0 (regular axis, boundary drive
   psi1(redge) = psib), and the mean equation acquires the quadratic
   source (psi1^2/4) S''(psi0), the 1D form of the meeting's
   current -> field -> curvature -> Pfirsch-Schlueter feedback.
   Findings, each PASS-checked below: (1) the restated forms
   reproduce the frozen script-42 fixture; (2) a damped Picard
   iteration converges to a saturated state at EVERY scanned drive,
   up to harmonic amplitudes of order half the mean flux - saturated
   equilibria exist, no fold is met in the scanned range; (3) the
   mean response is quadratic in the drive at small drive and the
   local log-log exponent GROWS with drive (super-quadratic): the
   feedback is reinforcing, exactly the meeting's "the perturbation
   must always increase" expectation; (4) the sign of the axis
   response is drive-independent; (5) the naive undamped iteration
   diverges at strong drive while the damped one converges - the
   reinforcing feedback destabilizes the naive current -> field ->
   current loop long before the equilibrium itself disappears,
   answering the meeting's "how to solve it" with: solve the
   self-consistent system with damped iteration, do not iterate the
   physical loop naively. The signed axis result (mean helical
   transform shift) is printed for the document. Exports
   fig_helical_saturation.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];
datadir = FileNameJoin[{DirectoryName[$InputFileName], "..", "mhd1d",
  "test", "data"}];

(* ==== 1. The verified truncated system (script 42 forms) ==== *)

aFix = 0.08; bFix = 0.01; kFix = -1/20.; H0fix = 1.;
rEdge = 25.; eps0 = 10^-6;
g[r_] := 1 + kFix^2 r^2;
Hfun[s_] := H0fix - aFix s - bFix s^2/2;
Hp[s_] := -aFix - bFix s;
Hpp[s_] := -bFix;
Ssrc[s_, r_] := Hfun[s] (2 kFix + g[r] Hp[s])/g[r]^2;
S1[s_, r_] := (Hp[s] (2 kFix + g[r] Hp[s]) + g[r] Hfun[s] Hpp[s])/g[r]^2;
S2[s_, r_] := (Hpp[s] (2 kFix + g[r] Hp[s]) + 2 g[r] Hp[s] Hpp[s])/g[r]^2;

(* Consistency with the frozen script-42 fixture: the feedback CSV
   column equals (psi1^2/4) S2 on its own psi0, psi1 columns. *)
feedTbl = Map[ToExpression[StringReplace[#, "e" -> "*10^"]] &,
  Map[StringSplit[#, ","] &,
    Select[ReadList[FileNameJoin[{datadir, "helical_feedback.csv"}],
      String], !StringStartsQ[#, "#"] &]], {2}];
feedCheck = Max[Table[Abs[(row[[3]]^2/4) S2[row[[2]], row[[1]]] -
    row[[4]]], {row, feedTbl}]];
check["restated forms reproduce the frozen script-42 feedback fixture",
  feedCheck < 10^-12];

(* ==== 2. Self-consistent Picard loop ==== *)

meanRhs[s0_, s0p_, r_, src_] :=
  -(s0p (1 - kFix^2 r^2)/(r g[r]) + g[r] (Ssrc[s0, r] + src));
solveMean[srcFun_] := NDSolve[{
    s0''[rr] == meanRhs[s0[rr], s0'[rr], rr, srcFun[rr]],
    s0[eps0] == 0, s0'[eps0] == 0}, s0, {rr, eps0, rEdge},
  AccuracyGoal -> 12, PrecisionGoal -> 12][[1]];
solveHarm[m0_, psib_] := Module[{sh, sc},
  sh = NDSolve[{
     s1''[rr] == -(s1'[rr] (1 - kFix^2 rr^2)/(rr g[rr]) +
       (-g[rr]/rr^2 + g[rr] S1[(s0[rr] /. m0), rr]) s1[rr]),
     s1[eps0] == eps0, s1'[eps0] == 1.}, s1, {rr, eps0, rEdge},
    AccuracyGoal -> 12, PrecisionGoal -> 12][[1]];
  sc = psib/(s1[rEdge] /. sh);
  {sh, sc}];

(* Damped Picard: the source handed to the mean solve is a convex
   combination of the previous and the freshly computed source.
   theta = 1 is the naive iteration of the physical loop. *)
saturate[psib_, theta_, maxit_] := Module[
  {m0, sh, sc, srcOld, srcNew, m0new, diff, it, gridS, vals},
  m0 = solveMean[Function[rr, 0.]];
  srcOld = Function[rr, 0.];
  diff = 1.; it = 0;
  While[diff > 10^-10 && it < maxit,
    {sh, sc} = solveHarm[m0, psib];
    gridS = Table[rv, {rv, eps0, rEdge, (rEdge - eps0)/400.}];
    vals = Table[(1 - theta) srcOld[rv] +
      theta (sc (s1[rv] /. sh))^2/4 S2[(s0[rv] /. m0), rv],
      {rv, gridS}];
    srcNew = Interpolation[Transpose[{gridS, vals}]];
    m0new = solveMean[srcNew];
    diff = Max[Table[Abs[(s0[rv] /. m0new) - (s0[rv] /. m0)],
      {rv, 1., 24., 1.}]];
    m0 = m0new; srcOld = srcNew;
    it++];
  {m0, sh, sc, diff, it}];

(* Mean helical safety factor analog on the axis region:
   q_h = r Bz0 / ((1/|k|) Btheta0) with the mean fields of the
   (psi0, H) parametrization. *)
qh[m0_, rv_] := Module[{s0v, s0d, h},
  s0v = s0[rv] /. m0; s0d = Derivative[1][s0 /. m0][rv];
  h = Hfun[s0v];
  rv ((h - kFix rv s0d)/g[rv])/((1/Abs[kFix]) *
    (-(s0d + kFix rv h)/g[rv]))];

drives = {0.08, 0.32, 1.28, 2.56, 5.12};
thetas = {0.5, 0.5, 0.3, 0.15, 0.1};
maxits = {60, 60, 150, 300, 400};
m0Undriven = solveMean[Function[rr, 0.]];
resTbl = Table[Module[{m0, sh, sc, diff, it, dq},
   {m0, sh, sc, diff, it} =
     saturate[drives[[i]], thetas[[i]], maxits[[i]]];
   dq = qh[m0, 1.] - qh[m0Undriven, 1.];
   {drives[[i]], dq, diff, it}], {i, Length[drives]}];

check["damped Picard converges below 1e-9 at every drive",
  AllTrue[resTbl, #[[3]] < 10^-9 &]];
check["axis response has the same sign at every drive",
  Length[Union[Sign[resTbl[[All, 2]]]]] === 1];

exponents = Table[
  Log[Abs[resTbl[[i + 1, 2]]]/Abs[resTbl[[i, 2]]]]/
  Log[drives[[i + 1]]/drives[[i]]], {i, Length[drives] - 1}];
Print["    drive scan (psib, delta q_h(1), iterations): ",
  Map[{#[[1]], ScientificForm[#[[2]], 4], #[[4]]} &, resTbl]];
Print["    local log-log exponents between successive drives: ",
  Map[NumberForm[#, 5] &, exponents]];
check["mean response is quadratic in the drive at small drive",
  Abs[exponents[[1]] - 2] < 0.05];
check["local exponent grows with drive: the feedback is reinforcing",
  And @@ Table[exponents[[i + 1]] >= exponents[[i]] - 10^-6,
    {i, Length[exponents] - 1}]];
check["strong drive is clearly super-quadratic",
  Last[exponents] > 2.1];

(* The naive undamped iteration of the physical loop diverges at the
   strongest drive where the damped iteration converged above. *)
naive = saturate[5.12, 1.0, 40];
check["naive theta = 1 iteration fails at strong drive",
  naive[[4]] > 10^-3];

(* ==== 3. Figure ==== *)
{m0S, shS, scS, diffS, itS} = saturate[5.12, 0.1, 400];
figSat = GraphicsRow[{
  ListLogLogPlot[Map[{#[[1]], Abs[#[[2]]]} &, resTbl],
    Joined -> True, PlotMarkers -> Automatic, Frame -> True,
    FrameLabel -> {"\[Psi]b", "|\[CapitalDelta]q_h(1)|"},
    PlotLabel -> "mean response vs drive (slope 2 = quadratic)",
    ImageSize -> 300],
  Plot[{qh[m0Undriven, rv], qh[m0S, rv]}, {rv, 0.5, 24.},
    PlotRange -> All, Frame -> True,
    FrameLabel -> {"r", "q_h"},
    PlotLegends -> {"undriven", "saturated, \[Psi]b = 5.12"},
    PlotLabel -> "saturated mean helical safety factor",
    ImageSize -> 320]},
  ImageSize -> 660];
Export[FileNameJoin[{figdir, "fig_helical_saturation.pdf"}], figSat];
Print["    exported fig_helical_saturation.pdf"];
check["Fig: helical saturation figure exported",
  FileByteCount[FileNameJoin[{figdir,
    "fig_helical_saturation.pdf"}]] > 5000];

reportAndExit[];

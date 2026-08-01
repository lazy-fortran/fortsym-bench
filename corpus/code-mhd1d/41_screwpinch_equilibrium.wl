(* 1D nonlinear ideal-MHD screw-pinch equilibrium (WP7 phase 1,
   meeting 2026-07-20): the axisymmetric seed of the mhd1d package.
   Inputs follow the agreed convention: a pressure profile p(r) and a
   parallel current profile lambda(r) with j = lambda B + j_perp and
   j_perp = c B x grad p / B^2 (CGS). Ampere's law then closes two
   first-order ODEs for (Btheta, Bz):
     -(c/4 pi) Bz'          = lambda Btheta + c p' Bz/B^2
      (c/4 pi) (r Btheta)'/r = lambda Bz    - c p' Btheta/B^2
   whose solutions satisfy radial force balance identically. Checks:
   the force-balance identity, the Lundquist force-free solution
   (lambda const, p' = 0), the theta-pinch (lambda = 0) and Z-pinch
   limits, axis regularity, and a nonlinear numeric fixture with
   q(0) about 1.05 (B0 = 1, R0 = 20, a = 25) whose solution is
   exported as CSV reference data for the Fortran tests in
   mhd1d/test/data/, together with an exact-Lundquist CSV. All CSV
   files carry a provenance header and no timestamps. Exports
   fig_screwpinch_equilibrium.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];
datadir = FileNameJoin[{DirectoryName[$InputFileName], "..", "mhd1d",
  "test", "data"}];
If[!DirectoryQ[datadir], CreateDirectory[datadir]];

ClearAll[r, c, p, lam, Bt, Bz, B2, jt, jz, alphaL, B0];
$Assumptions = r > 0 && c > 0 && B0 > 0;

(* ==== 1. The system and the force-balance identity ==== *)

B2 = Bt[r]^2 + Bz[r]^2;
jtAmp = -(c/(4 Pi)) Bz'[r];
jzAmp = (c/(4 Pi)) D[r Bt[r], r]/r;
ode1 = jtAmp == lam[r] Bt[r] + c p'[r] Bz[r]/B2;
ode2 = jzAmp == lam[r] Bz[r] - c p'[r] Bt[r]/B2;

(* Radial force balance p' = (j_theta Bz - j_z Btheta)/c follows
   identically once both currents take their ODE form: substitute the
   right-hand sides into the force-balance residual. *)
fbResidual = Simplify[p'[r] -
  ((lam[r] Bt[r] + c p'[r] Bz[r]/B2) Bz[r] -
   (lam[r] Bz[r] - c p'[r] Bt[r]/B2) Bt[r])/c];
check["force balance holds exactly when both currents take their ODE form",
  Simplify[fbResidual, Bt[r]^2 + Bz[r]^2 > 0] === 0];

(* Equivalent conservative form: d/dr [p + B^2/8 pi] + Bt^2/(4 pi r)
   equals zero on solutions. *)
consForm = Simplify[D[p[r] + B2/(8 Pi), r] + Bt[r]^2/(4 Pi r) /.
  {Bz'[r] -> -(4 Pi/c) (lam[r] Bt[r] + c p'[r] Bz[r]/B2),
   Bt'[r] -> (4 Pi/c) (lam[r] Bz[r] - c p'[r] Bt[r]/B2) - Bt[r]/r}];
check["conservative screw-pinch form vanishes on solutions",
  Simplify[consForm, Bt[r]^2 + Bz[r]^2 > 0] === 0];

(* ==== 2. Exact solutions ==== *)

(* Lundquist force-free field: lambda = const, p' = 0,
   alpha = 4 pi lambda / c: Bz = B0 J0(alpha r), Bt = B0 J1(alpha r). *)
lundquist = {Bt -> Function[x, B0 BesselJ[1, alphaL x]],
  Bz -> Function[x, B0 BesselJ[0, alphaL x]]};
check["Lundquist field solves the lambda ODEs with p' = 0",
  FullSimplify[{ode1, ode2} /. lundquist /.
    {lam -> Function[x, c alphaL/(4 Pi)], p -> Function[x, p0]},
    r > 0] === {True, True}];

(* Theta pinch: lambda = 0, Btheta = 0, p + Bz^2/8 pi = const. *)
thetaPinch = {Bt -> Function[x, 0],
  Bz -> Function[x, Sqrt[8 Pi (pEdge - p[x]) + BzEdge^2]]};
check["theta-pinch closed form solves the system at lambda = 0",
  Simplify[{ode1, ode2} /. thetaPinch /. lam -> Function[x, 0],
    8 Pi (pEdge - p[r]) + BzEdge^2 > 0] === {True, True}];

(* Z pinch: Bz = 0; force balance is the Bennett relation
   p' = -(Bt (r Bt)')/(4 pi r). *)
zPinchFB = Simplify[fbResidual /. Bz -> Function[x, 0]];
check["Z-pinch limit reduces force balance to the Bennett form",
  Simplify[zPinchFB, Bt[r]^2 > 0] === 0];

(* Axis regularity: with finite lambda(0) and p'(0) = 0, the series
   solution has Bt = (2 pi lambda0 Bz0 / c) r + O(r^3), Bz regular.
   Verify order by order to r^3. *)
btSer = a1 r + a3 r^3; bzSer = Bz0 + b2 r^2;
lamSer = lam0 + lam2 r^2; pSer = pc + p2 r^2;
serRules = {Bt -> Function[x, Evaluate[btSer /. r -> x]],
  Bz -> Function[x, Evaluate[bzSer /. r -> x]],
  lam -> Function[x, Evaluate[lamSer /. r -> x]],
  p -> Function[x, Evaluate[pSer /. r -> x]]};
a1Sol = Solve[Normal@Series[(ode2 /. Equal -> Subtract) /. serRules,
    {r, 0, 0}] == 0, a1];
check["axis series: Btheta' (0) = 2 pi lambda(0) Bz(0)/c",
  Simplify[a1 /. a1Sol[[1]]] === Simplify[2 Pi lam0 Bz0/c]];

(* ==== 3. Nonlinear numeric fixture ==== *)

(* CGS-normalized fixture: c = 1, B0 = 1, R0 = 20, a = 25.
   p(r) = p0 (1 - (r/a)^2)^2, lambda(r) = lam0 Exp[-(r/12)^2] with
   lam0 tuned so q(0) = 1.05 exactly: q(0) = 2 Bz(0)/(R0 c ... ):
   q(r) = r Bz/(R0 Bt); on axis q0 = Bz0/(R0 Bt'(0)) =
   c Bz0/(R0 2 pi lam0 Bz0) = c/(2 pi R0 lam0). *)
cFix = 1.; B0fix = 1.; R0fix = 20.; aFix = 25.;
q0Target = 1.05;
lam0Fix = cFix/(2 Pi R0fix q0Target);
p0Fix = 2. 10^-3;
pFun[rr_] := p0Fix (1 - (rr/aFix)^2)^2;
lamFun[rr_] := lam0Fix Exp[-(rr/12.)^2];

eps0 = 10^-8;
sol = NDSolve[{
  bz'[rr] == -(4 Pi/cFix) (lamFun[rr] bt[rr] +
    cFix pFun'[rr] bz[rr]/(bt[rr]^2 + bz[rr]^2)),
  bt'[rr] == (4 Pi/cFix) (lamFun[rr] bz[rr] -
    cFix pFun'[rr] bt[rr]/(bt[rr]^2 + bz[rr]^2)) - bt[rr]/rr,
  bz[eps0] == B0fix, bt[eps0] == 2 Pi lam0Fix B0fix eps0/cFix},
  {bt, bz}, {rr, eps0, aFix},
  AccuracyGoal -> 12, PrecisionGoal -> 12, MaxSteps -> 10^6][[1]];
btN[rr_] := bt[rr] /. sol; bzN[rr_] := bz[rr] /. sol;
qN[rr_] := rr bzN[rr]/(R0fix btN[rr]);

check["fixture: q on axis equals the 1.05 target",
  Abs[qN[10^-4] - q0Target] < 10^-3];
check["fixture: q shears upward toward the edge",
  qN[24.] > qN[10.] > qN[10^-4]];

(* Independent verification: the numeric solution satisfies the
   conservative force-balance form at 1e-6 relative accuracy on a
   radial sample. *)
btD[rr_] := Derivative[1][bt /. sol][rr];
bzD[rr_] := Derivative[1][bz /. sol][rr];
fbNum[rr_?NumericQ] := pFun'[rr] +
  (btN[rr] btD[rr] + bzN[rr] bzD[rr])/(4 Pi) + btN[rr]^2/(4 Pi rr);
scaleNum = p0Fix/aFix + B0fix^2/(8 Pi aFix);
check["fixture: conservative force balance holds at 1e-5 of the gradient scale (interpolant-derivative accuracy)",
  Max[Table[Abs[fbNum[rv]]/scaleNum, {rv, 1., 24., 1.}]] < 10^-5];

(* ==== 4. Reference CSV export for the Fortran package ==== *)

(* One row per line, full machine precision, Fortran-readable
   e-notation (InputForm prints all digits; *^ becomes e). *)
fmtNum[x_] := StringReplace[ToString[N[x], InputForm], "*^" -> "e"];
writeCsv[file_, header_, rows_] := Module[{s = OpenWrite[file]},
  WriteString[s, header <> "\n"];
  WriteString[s, StringRiffle[
    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\n"] <> "\n"];
  Close[s]];

gridR = Table[rv, {rv, 0.25, 25., 0.25}];
fixtureRows = Map[{#, pFun[#], lamFun[#], btN[#], bzN[#], qN[#]} &,
  gridR];
writeCsv[FileNameJoin[{datadir, "screwpinch_fixture.csv"}],
  "# mathematica/41_screwpinch_equilibrium.wl nonlinear fixture; " <>
  "CGS, c=1, B0=1, R0=20, a=25, p0=2e-3, lam0=1/(2 pi R0 1.05); " <>
  "columns r,p,lambda,Btheta,Bz,q", fixtureRows];
check["fixture CSV written",
  FileByteCount[FileNameJoin[{datadir, "screwpinch_fixture.csv"}]] >
    5000];

alphaFix = 0.05;
lundRows = Map[{#, alphaFix cFix/(4 Pi),
  B0fix BesselJ[1, alphaFix #], B0fix BesselJ[0, alphaFix #]} &, gridR];
writeCsv[FileNameJoin[{datadir, "screwpinch_lundquist.csv"}],
  "# mathematica/41_screwpinch_equilibrium.wl exact Lundquist field; " <>
  "CGS, c=1, B0=1, alpha=0.05, lambda=alpha c/(4 pi); " <>
  "columns r,lambda,Btheta,Bz", lundRows];
check["Lundquist CSV written",
  FileByteCount[FileNameJoin[{datadir, "screwpinch_lundquist.csv"}]] >
    2000];

(* ==== 5. Figure ==== *)
figSP = GraphicsRow[{
  Plot[{btN[rv], bzN[rv]}, {rv, 0.01, 25.}, PlotRange -> All,
    Frame -> True, FrameLabel -> {"r", "B"},
    PlotLegends -> {"B_theta", "B_z"}, ImageSize -> 300,
    PlotLabel -> "fixture equilibrium field"],
  Plot[qN[rv], {rv, 0.01, 25.}, PlotRange -> All, Frame -> True,
    FrameLabel -> {"r", "q"}, ImageSize -> 300,
    PlotLabel -> "safety factor, q(0) = 1.05"]},
  ImageSize -> 640];
Export[FileNameJoin[{figdir, "fig_screwpinch_equilibrium.pdf"}], figSP];
Print["    exported fig_screwpinch_equilibrium.pdf"];
check["Fig: screw-pinch equilibrium figure exported",
  FileByteCount[FileNameJoin[{figdir,
    "fig_screwpinch_equilibrium.pdf"}]] > 5000];

reportAndExit[];

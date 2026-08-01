ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];
zeroQ[expr_] := SameQ[Together[expr], 0];
zeroTrigQ[expr_] := SameQ[Simplify[TrigReduce[expr]], 0];

(* GPEC sol.f Solov'ev (eq_type "soloviev", sol_run):
     psi(R,Z) = psio - psifac ((R Z / e)^2 + (R^2 - r0^2)^2 / 4),
     psifac = psio / (a r0)^2,  F = f0 = r0 b0fac constant (FF' = 0),
     psio = e f0 a^2 / (2 q0 r0),  sq_in fs2 = pfac (p0fac - psin),
     pfac = 2 psio^2 (e^2 + 1) / (a r0 e)^2.
   DCON absorbs mu0 into p, so fs2 is mu0 p.  This gate certifies the
   construction, pins the psin orientation (axis 0) through the
   Grad-Shafranov residual, and freezes the q0-independent shape data
   needed to rebuild the same equilibrium in GVEC for the marginal-q0
   fixed-boundary comparison against DCON: the boundary Fourier curve,
   the safety-factor shape Q(sigma) = q/q0, and the map from sigma
   (psin = sigma^2) to s = normalized toroidal flux. *)

$Assumptions = e > 0 && a > 0 && r0 > a && psio > 0 && q0 > 0 &&
   f0 > 0 && 0 < sig < 1 && w \[Element] Reals;

psifac = psio/(a r0)^2;
pfac = 2 psio^2 (e^2 + 1)/(a r0 e)^2;
psi[R_, Z_] := psio - psifac ((R Z/e)^2 + (R^2 - r0^2)^2/4);

(* 1. Grad-Shafranov residual with F constant and mu0 p = pfac psi/psio
      (psin = 1 - psi/psio, axis 0): Delta* psi + R^2 mu0 p'(psi) = 0.
      The opposite psin orientation flips the sign of p' and cannot
      cancel the strictly negative Delta* psi, so this residual pins
      the orientation of sol.f's sq_in%xs. *)
deltaStar = R D[D[psi[R, Z], R]/R, R] + D[psi[R, Z], {Z, 2}];
mu0pPrime = pfac/psio;
check["gs_residual_exact", zeroQ[deltaStar + R^2 mu0pPrime]];

(* 2-3. magnetic axis at (r0, 0): critical point with value psio, and
      the local flux ellipse has vertical elongation e. *)
psiRR = D[psi[R, Z], {R, 2}] /. {R -> r0, Z -> 0};
psiZZ = D[psi[R, Z], {Z, 2}] /. {R -> r0, Z -> 0};
check["axis_critical_point",
  zeroQ[(D[psi[R, Z], R] /. {R -> r0, Z -> 0})] &&
   zeroQ[(D[psi[R, Z], Z] /. {R -> r0, Z -> 0})] &&
   zeroQ[psi[r0, 0] - psio]];
check["axis_ellipse_elongation", zeroQ[psiZZ e^2 - psiRR]];

(* 4-5. q on the axis: for a quadratic flux function the field-line
      integrand is constant in the ellipse angle (lemma), so
      q_axis = f0/(r0 Sqrt[|psiRR| |psiZZ|]), which must reproduce the
      sol.f normalization q_axis = e f0 a^2/(2 psio r0) == q0. *)
check["constant_integrand_lemma",
  zeroTrigQ[(Sin[t]^2 pZZ + Cos[t]^2 pRR) -
    (pRR Cos[t]^2 + pZZ Sin[t]^2)]];
qAxis = f0/(r0 Sqrt[psiRR psiZZ]) // Simplify;
check["q_axis_matches_sol_psio_relation",
  zeroQ[Simplify[qAxis - e f0 a^2/(2 psio r0)]]];

(* 6. exact surface family: psin = sigma^2 with
      R(w)^2 = r0^2 + 2 a r0 sigma cos w, Z(w) = e a r0 sigma sin w/R. *)
rSq = r0^2 + 2 a r0 sig Cos[w];
rW = Sqrt[rSq];
zW = e a r0 sig Sin[w]/rW;
check["surface_parametrization_exact",
  zeroTrigQ[psi[rW, zW] - psio (1 - sig^2)]];

(* 7-8. the q integrand squared, scaled by psifac^2, is free of psio
      and q0: hence q(sigma; q0) = q0 Q(sigma) with Q independent of
      q0, and s(sigma) (normalized toroidal flux) is q0-independent. *)
dlSq = D[rW, w]^2 + D[zW, w]^2 // Simplify;
gradPsiSq = (D[psi[R, Z], R]^2 + D[psi[R, Z], Z]^2) /.
    {R -> rW, Z -> zW} // Simplify;
integrandSq = dlSq/(rSq gradPsiSq) // Simplify;
check["q_scaling_q0_free",
  FreeQ[Simplify[integrandSq psifac^2], psio] &&
   FreeQ[Simplify[integrandSq psifac^2], q0]];

(* ---- numeric leg at the GPEC example values ---- *)
eV = 8/5; aV = 33/100; r0V = 1; f0V = 1; q0V = 19/10;
values = {e -> eV, a -> aV, r0 -> r0V, f0 -> f0V,
   psio -> eV f0V aV^2/(2 q0V r0V)};
intSqValues = Simplify[integrandSq /. values];
integrandSqV[sigN_?NumericQ, wN_?NumericQ] :=
  intSqValues /. {sig -> sigN, w -> wN};

gradOnBoundary = Table[
   N[(rSq gradPsiSq /. values) /. {sig -> 1, w -> wS}, 20],
   {wS, Range[0, 2 Pi, Pi/36]}];
check["gradpsi_nonzero_on_boundary", Min[gradOnBoundary] > 0];

qOf[sigN_?NumericQ] := qOf[sigN] = (f0V/(2 Pi)) NIntegrate[
    Sqrt[integrandSqV[sigN, wN]], {wN, 0, 2 Pi},
    WorkingPrecision -> 30, PrecisionGoal -> 22, MaxRecursion -> 14];
bigQ[sigN_?NumericQ] := If[sigN < 10^-8, 1, qOf[sigN]/q0V];

(* 9. axis limit Q -> 1; 10. edge q against the archived DCON run
      ("q from 1.9 to 3.263", psihigh = 0.99999, mpsi = 128). *)
check["q_axis_limit_numeric", Abs[bigQ[10^-4] - 1] < 10^-6];
qEdge = q0V bigQ[1];
check["q_edge_matches_dcon", Abs[qEdge - 3.263] < 2 10^-3];

(* 11. toroidal flux two ways: line route Phi = 2 pi Integral q dpsi
      (psi is per-radian poloidal flux, the Delta* convention) with
      dpsi = -2 psio sigma dsigma, and area route
      Phi = Integral (f0/R) dA over the surface interior. *)
psioV = psio /. values;
phiLine = NDSolveValue[
   {phi'[u] == 4 Pi psioV q0V bigQ[u] u, phi[0] == 0}, phi, {u, 0, 1},
   WorkingPrecision -> 25, PrecisionGoal -> 15, AccuracyGoal -> 20,
   MaxStepSize -> 1/64];
jacobianRZ = Simplify[(D[rW, sig] D[zW, w] - D[rW, w] D[zW, sig]) /.
    values];
areaIntegrand[sigN_?NumericQ, wN_?NumericQ] :=
  ((f0V/(rW /. values)) Abs[jacobianRZ]) /. {sig -> sigN, w -> wN};
phiArea[sigTop_?NumericQ] := NIntegrate[
   areaIntegrand[sigS, wS], {sigS, 0, sigTop}, {wS, 0, 2 Pi},
   WorkingPrecision -> 25, PrecisionGoal -> 12, MaxRecursion -> 12];
check["toroidal_flux_line_vs_area",
  Abs[phiLine[1]/phiArea[1] - 1] < 10^-8 &&
   Abs[phiLine[1/2]/phiArea[1/2] - 1] < 10^-8];

sOf[sigN_?NumericQ] := phiLine[sigN]/phiLine[1];
sGrid = Table[j/128, {j, 0, 128}];
sValues = sOf /@ sGrid;
check["s_profile_monotone",
  Min[Differences[sValues]] > 0 && Abs[sValues[[-1]] - 1] < 10^-12 &&
   Abs[sValues[[1]]] < 10^-12];

(* 12. boundary Fourier series in the parameter w (R even, Z odd);
      the nearest complex singularity gives coefficient decay
      rho^-m with rho = 1/(2 a) + Sqrt[1/(2 a)^2 - 1] ~ 2.65, so
      m <= 36 reaches the 1e-12 window; trapezoidal quadrature is
      spectrally exact for the periodic integrand. *)
mMax = 36;
boundaryR[wN_] := (rW /. values /. sig -> 1) /. w -> wN;
boundaryZ[wN_] := (zW /. values /. sig -> 1) /. w -> wN;
periodicIntegral[expr_] := NIntegrate[expr, {wN, 0, 2 Pi},
   Method -> "Trapezoidal", WorkingPrecision -> 30,
   PrecisionGoal -> 22, MaxRecursion -> 16];
fourierR = Join[{periodicIntegral[boundaryR[wN]]/(2 Pi)},
   Table[periodicIntegral[boundaryR[wN] Cos[m wN]]/Pi, {m, 1, mMax}]];
fourierZ = Table[periodicIntegral[boundaryZ[wN] Sin[m wN]]/Pi,
   {m, 1, mMax}];
seriesR[wN_] := fourierR[[1]] +
   Sum[fourierR[[m + 1]] Cos[m wN], {m, 1, mMax}];
seriesZ[wN_] := Sum[fourierZ[[m]] Sin[m wN], {m, 1, mMax}];
truncation = Max[Table[
    Max[Abs[seriesR[wS] - boundaryR[wS]],
     Abs[seriesZ[wS] - boundaryZ[wS]]],
    {wS, Range[0.1, 2 Pi, 0.1]}]];
check["boundary_fourier_truncation", truncation < 10^-12];

(* ---- frozen manifests (q0-independent shape data), machine
   doubles so the Python-side GVEC generator parses them directly.
   psio q0 and pfac q0^2 are exact rationals, so any scan q0 recovers
   psio, pfac, mu0 p(sigma) = pfac (1 - sigma^2), and
   iota(s) = 1/(q0 Q(sigma(s))). *)
psioTimesQ0 = eV f0V aV^2/(2 r0V);
pfacTimesQ0Sq = 2 psioTimesQ0^2 (eV^2 + 1)/(aV r0V eV)^2;
phiEdge = phiLine[1];

dataDirectory = FileNameJoin[{DirectoryName[$InputFileName],
    "..", "validation", "data"}];
profileRows = Table[N[{sGrid[[j]], sGrid[[j]]^2, sValues[[j]],
     bigQ[sGrid[[j]]], 1 - sGrid[[j]]^2}], {j, Length[sGrid]}];
profilePath = FileNameJoin[{dataDirectory,
    "solovev_profile_manifest.csv"}];
Export[profilePath,
  Join[{{"sigma", "psin", "s_toroidal", "q_over_q0",
     "mu0_p_over_pfac"}}, profileRows], "CSV"];

boundaryRows = Table[
   {m, N[fourierR[[m + 1]]], N[If[m == 0, 0, fourierZ[[m]]]]},
   {m, 0, mMax}];
boundaryPath = FileNameJoin[{dataDirectory,
    "solovev_boundary_manifest.csv"}];
Export[boundaryPath,
  Join[{{"m", "R_cos", "Z_sin"}}, boundaryRows], "CSV"];

scalarRows = {
   {"e", N[eV]}, {"a", N[aV]}, {"r0", N[r0V]}, {"f0", N[f0V]},
   {"psio_times_q0", N[psioTimesQ0]},
   {"pfac_times_q0sq", N[pfacTimesQ0Sq]},
   {"phi_edge", N[phiEdge]},
   {"q_edge_over_q0", N[bigQ[1]]}};
scalarPath = FileNameJoin[{dataDirectory,
    "solovev_scalars_manifest.csv"}];
Export[scalarPath, Join[{{"name", "value"}}, scalarRows], "CSV"];

(* 13. manifest roundtrip at double precision *)
reProfile = Import[profilePath, "CSV"];
reBack = reProfile[[2 ;;, 4]];
check["manifest_roundtrip",
  Length[reProfile] == 130 &&
   Max[Abs[reBack - profileRows[[All, 4]]]] < 10^-13];

Print["REF q_edge                    ", N[qEdge, 16]];
Print["REF Q_edge_over_q0            ", N[bigQ[1], 16]];
Print["REF psio_at_q0_1.9            ", N[psioV, 16]];
Print["REF pfac_at_q0_1.9            ", N[pfacTimesQ0Sq/q0V^2, 16]];
Print["REF phi_edge                  ", N[phiEdge, 16]];
Print["REF s_at_sigma_half           ", N[sOf[1/2], 16]];
Print["REF boundary_R0_R1_R2         ", N[fourierR[[1 ;; 3]], 16]];
Print["REF boundary_Z1_Z2            ", N[fourierZ[[1 ;; 2]], 16]];
Print["SUMMARY ", pass, " passed, ", fail, " failed"];
If[fail > 0, Exit[1]];

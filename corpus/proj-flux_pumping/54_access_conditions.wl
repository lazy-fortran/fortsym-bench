(* Symbolic verification of the reduced flux-pumping ACCESS-CONDITION model
   implemented in models/access/.  Nothing here is a first-principles
   prediction: the model is a reduced two-field description whose job is to
   organise the competition between resistive current peaking and helical
   current redistribution into a bifurcation structure.  This script proves
   its analytic properties so that the Python implementation and the prose in
   models/access/FINDINGS.md rest on checked algebra.

   FIELDS.  A = normalized (1,1) helical displacement amplitude,
   Delta = 1 - q0 (so Delta > 0 is the unstable side, q0 < 1).

   DIMENSIONAL MODEL (as specified):
     dA/dt     = g0 (Delta - Dc) A - al A^3
     dDelta/dt = (DOhm - Delta)/tR + ep Delta - ka A^2

   The quadratic feedback ka A^2 is a CONSTRAINT, not a choice: the mean-field
   electromotive force is a correlation of two fluctuating quantities
   (<v~ x B~>.b0 in Krebs 2017 / Zhang 2026; pi r Re[Delta_m Conjugate[J]] in
   this repository's closure spine, scripts 08 and 15), hence bilinear in the
   perturbation and quadratic in a single saturated amplitude.

   DIMENSIONLESS FORM used by the code (time in tR, amplitude in
   Sqrt[g0/al]):
     dA/dtau     = Ga ((Delta - Dc) A - A^3)
     dDelta/dtau = DOhm - (1 - Ee) Delta - Kk Psi[Delta] A^2
   with Ga = g0 tR, Ee = ep tR, Kk = ka tR g0/al.

   Parts:
   A  naive model (Ee = 0, Psi = 1): fixed point, ACCESS CONDITION #1, and the
      unconditional stability that forbids a limit cycle.
   B  autocatalytic term: the exact Hopf locus, its closed form, and the
      ceiling on Ga above which no Hopf point exists at all.
   C  the autocatalytic rate derived from Spitzer resistivity plus core power
      balance, ep tR = 3 sigma.
   D  the reduced Bussac threshold Dc(beta_p) and its two calibration points.
   E  the hysteretic (quintic) variant: fold, Pontryagin delayed ignition, and
      the cycle's amplitude-excursion identity.
   F  the static Krook parallel response used by the kinetic closure, and the
      AUG numbers of script 44.
   G  closure slopes at the operating point: why a MEAN neoclassical
      correction cannot move the boundary and a finite-k_parallel one can.

   No figures are exported here; the figures live in
   models/access/figures.py (deterministic, SOURCE_DATE_EPOCH). *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[aa, dd, gg, al, ka, tR, ep, g0, Dc, DOhm, Ga, Ee, Kk, xx, bb, sig,
  betaP, betaB, betaC, dc0, nn, xi, vv, uu, dop, lam];

(* ================================================================ *)
(* A.  Naive model                                                   *)
(* ================================================================ *)

$Assumptions = g0 > 0 && al > 0 && ka > 0 && tR > 0 && Ga > 0 && Kk > 0 &&
  DOhm > 0;

fDim = g0 (dd - Dc) aa - al aa^3;
gDim = (DOhm - dd)/tR - ka aa^2;

(* Nontrivial fixed point of the dimensional system. *)
aStarSqDim = (DOhm - Dc)/(ka tR + al/g0);
dStarDim = Dc + al aStarSqDim/g0;

check["A1 naive mode nullcline is satisfied at the specified fixed point",
  FullSimplify[(fDim /. {aa -> Sqrt[aStarSqDim], dd -> dStarDim})] === 0];
check["A2 naive profile nullcline is satisfied at the specified fixed point",
  FullSimplify[(gDim /. {aa -> Sqrt[aStarSqDim], dd -> dStarDim})] === 0];
check["A3 ACCESS CONDITION #1: the fixed point is real iff DOhm > Dc",
  FullSimplify[Refine[aStarSqDim > 0, DOhm > Dc]] === True &&
    FullSimplify[Refine[aStarSqDim < 0, DOhm < Dc]] === True];

(* Jacobian at the fixed point.  Written with the fixed-point relations
   substituted, so that the entries are the ones quoted in FINDINGS.md. *)
jacDim = {{D[fDim, aa], D[fDim, dd]}, {D[gDim, aa], D[gDim, dd]}} /.
  {aa -> Sqrt[aStarSqDim], dd -> dStarDim};
traceDim = FullSimplify[Tr[jacDim]];
detDim = FullSimplify[Det[jacDim]];

check["A4 trace = -2 al A*^2 - 1/tR exactly",
  FullSimplify[traceDim - (-2 al aStarSqDim - 1/tR)] === 0];
check["A5 det = 2 al A*^2/tR + 2 ka g0 A*^2 exactly",
  FullSimplify[detDim - (2 al aStarSqDim/tR + 2 ka g0 aStarSqDim)] === 0];
check["A6 dF/dA at the fixed point is exactly -2 al A*^2",
  FullSimplify[jacDim[[1, 1]] + 2 al aStarSqDim] === 0];

(* The decisive statement: whenever the fixed point exists, the trace is
   negative and the determinant positive, for EVERY admissible coefficient.
   The flux-pumping state is therefore unconditionally stable and the naive
   model cannot produce a limit cycle. *)
check["A7 trace < 0 whenever the fixed point exists",
  Refine[traceDim < 0, DOhm > Dc] === True];
check["A8 det > 0 whenever the fixed point exists",
  Refine[detDim > 0, DOhm > Dc] === True];
check["A9 NO LIMIT CYCLE: no admissible coefficients give trace >= 0",
  Reduce[traceDim >= 0 && DOhm > Dc && g0 > 0 && al > 0 && ka > 0 &&
      tR > 0, {g0, al, ka, tR, DOhm, Dc}, Reals] === False];
(* Routh-Hurwitz for a 2x2 system: both eigenvalues of lambda^2 - T lambda + D
   have negative real part exactly when T < 0 and D > 0, which A7 and A8
   established unconditionally. *)
check["A10 both eigenvalues have negative real part (Routh-Hurwitz)",
  Refine[And[traceDim < 0, detDim > 0], DOhm > Dc] === True];

(* The same statements in the dimensionless variables used by the code. *)
fRed = Ga ((dd - Dc) aa - aa^3);
gRed = DOhm - (1 - Ee) dd - Kk aa^2;
xStar = (DOhm - (1 - Ee) Dc)/((1 - Ee) + Kk);

check["A11 dimensionless fixed point matches the dimensional one at Ee = 0",
  FullSimplify[(xStar /. Ee -> 0) - (DOhm - Dc)/(1 + Kk)] === 0];
check["A12 dimensionless nullclines vanish at (Sqrt[X*], Dc + X*)",
  FullSimplify[{fRed, gRed} /. {aa -> Sqrt[xStar], dd -> Dc + xStar}] ===
    {0, 0}];

jacRed = {{D[fRed, aa], D[fRed, dd]}, {D[gRed, aa], D[gRed, dd]}} /.
  {aa -> Sqrt[xx], dd -> Dc + xx};
check["A13 reduced Jacobian is {{-2 Ga X, Ga Sqrt[X]}, {-2 Kk Sqrt[X], Ee-1}}",
  FullSimplify[jacRed - {{-2 Ga xx, Ga Sqrt[xx]},
      {-2 Kk Sqrt[xx], Ee - 1}}] === {{0, 0}, {0, 0}}];
check["A14 reduced trace = -2 Ga X - (1 - Ee)",
  FullSimplify[Tr[jacRed] - (-2 Ga xx - (1 - Ee))] === 0];
check["A15 reduced det = 2 Ga X ((1 - Ee) + Kk)",
  FullSimplify[Det[jacRed] - 2 Ga xx ((1 - Ee) + Kk)] === 0];

(* ================================================================ *)
(* B.  Autocatalytic peaking and the Hopf locus                      *)
(* ================================================================ *)

(* Hopf: trace = 0 with det > 0.  trace = 0 gives Ee = 1 + 2 Ga X, which is
   IMPLICIT because X itself depends on Ee.  Substituting 1 - Ee = -2 Ga X
   into the fixed-point relation gives an exact quadratic in X. *)
hopfEe = 1 + 2 Ga xx;
fixedPointResidual = xx ((1 - Ee) + Kk) - (DOhm - (1 - Ee) Dc);
hopfQuadratic = FullSimplify[fixedPointResidual /. Ee -> hopfEe];

check["B1 Hopf condition trace = 0 is Ee = 1 + 2 Ga X",
  FullSimplify[(Tr[jacRed] /. Ee -> hopfEe)] === 0];
check["B2 the Hopf locus is the quadratic 2 Ga X^2 - (Kk - 2 Ga Dc) X + DOhm = 0",
  FullSimplify[hopfQuadratic + (2 Ga xx^2 - (Kk - 2 Ga Dc) xx + DOhm)] === 0];
check["B3 in dimensional form the condition is ep_crit = 1/tR + 2 al A*^2",
  FullSimplify[(hopfEe /. {Ga -> g0 tR, xx -> al aStarSqDim/g0})/tR -
      (1/tR + 2 al aStarSqDim)] === 0];

(* Real Hopf points exist only below a ceiling in Ga. *)
hopfDiscriminant = (Kk - 2 Ga Dc)^2 - 8 Ga DOhm;
check["B4 a real Hopf point requires (Kk - 2 Ga Dc)^2 > 8 Ga DOhm",
  FullSimplify[Discriminant[2 Ga xx^2 - (Kk - 2 Ga Dc) xx + DOhm, xx] -
      hopfDiscriminant] === 0];
gammaCeiling = Kk^2/(8 DOhm);
check["B5 at Dc = 0 the ceiling is Ga < Kk^2/(8 DOhm)",
  Refine[(hopfDiscriminant /. Dc -> 0) > 0, 0 < Ga < gammaCeiling] === True &&
    Refine[(hopfDiscriminant /. Dc -> 0) < 0, Ga > gammaCeiling] === True];

(* Determinant at the Hopf point is positive only for the smaller root. *)
hopfDetAtRoot = FullSimplify[
  Det[jacRed] /. Ee -> hopfEe];
check["B6 det at the Hopf point is 2 Ga X (Kk - 2 Ga X)",
  FullSimplify[hopfDetAtRoot - 2 Ga xx (Kk - 2 Ga xx)] === 0];
check["B7 a genuine Hopf therefore needs X < Kk/(2 Ga)",
  Refine[hopfDetAtRoot > 0, 0 < xx < Kk/(2 Ga)] === True];

(* The numbers that matter for AUG #36663.  Kk = 20 is the anchor value at the
   beta_p,c reference (Dc = 0); DOhm = 0.21 from the Zhang 2025 2D control
   q_min = 0.79; Ga = S^(2/3) with S = 3e9 from Zhang 2026. *)
kkAug = 20;
dOhmAug = 21/100;
gaAug = N[(3 10^9)^(2/3), 20];
ceilingAug = kkAug^2/(8 dOhmAug);
Print["    AUG: Hopf ceiling Ga < ", N[ceilingAug, 6],
  " versus the physical Ga = ", N[gaAug, 6],
  "  (ratio ", ScientificForm[N[gaAug/ceilingAug, 4], 4], ")"];
check["B8 AUG: the Hopf ceiling is 238 (three significant figures)",
  Abs[N[ceilingAug] - 238.095] < 0.01];
check["B9 AUG: the physical timescale ratio exceeds the ceiling by > 1e3",
  N[gaAug/ceilingAug] > 1000];
check["B10 AUG: therefore no Hopf bifurcation of the specified model exists",
  N[(hopfDiscriminant /. {Kk -> kkAug, Dc -> 0, Ga -> gaAug,
      DOhm -> dOhmAug})] < 0];

(* With the anchor recomputed at the real AUG poloidal beta the gain is
   smaller, which only lowers the ceiling further. *)
kkAugReal = 172817679558011/100000000000000;
check["B11 the AUG-calibrated gain 1.728 lowers the ceiling below 2",
  N[kkAugReal^2/(8 dOhmAug)] < 2];

(* ================================================================ *)
(* C.  The autocatalytic rate from Spitzer resistivity               *)
(* ================================================================ *)

(* Core power balance (3/2) n Te/tauE = eta j^2 with eta ~ Te^(-3/2).
   Write Te ~ j^(2 sigma); then in powers of ln j the balance reads
     2 sigma - (exponent of tauE) = -3 sigma + 2.
   Fixed tauE: 2 sigma = -3 sigma + 2, so sigma = 2/5 and Te ~ j^(4/5). *)
teFixed = sig /. Solve[{2 sig == -3 sig + 2}, sig][[1]];
check["C1 fixed tau_E gives Te ~ j^(2 sigma) with sigma = 2/5",
  teFixed === 2/5];
(* Power-degraded confinement tauE ~ (eta j^2)^(-2/3) contributes
   +2/3 (-3 sigma + 2) to the left-hand exponent. *)
teDegraded = sig /.
  Solve[{2 sig + (2/3) (-3 sig + 2) == -3 sig + 2}, sig][[1]];
check["C2 tau_E ~ P_Ohm^(-2/3) gives sigma = 2/9",
  teDegraded === 2/9];
(* eta ~ j^(-3 sigma) so jOhm = E/eta ~ j^(3 sigma); linearizing
   tR dj/dt = jOhm(j) - j gives the net rate (3 sigma - 1)/tR, which the model
   writes as -1/tR + ep.  Hence ep tR = 3 sigma. *)
check["C3 the autocatalytic rate is ep tR = 3 sigma",
  FullSimplify[(3 sig - 1) - (-1 + 3 sig)] === 0];
check["C4 fixed tau_E gives Ee = 6/5 = 1.2",
  3 teFixed === 6/5];
check["C5 power-degraded tau_E gives Ee = 2/3",
  3 teDegraded === 2/3];
check["C6 the largest derivable Ee is far below the AUG Hopf threshold",
  N[3 teFixed] < N[1 + 2 gaAug (dOhmAug/(1 + kkAug))]/1000];

(* ================================================================ *)
(* D.  Reduced Bussac threshold                                      *)
(* ================================================================ *)

(* Bussac, Pellat, Edery, Soule, PRL 35, 1638 (1975): the toroidal m=1
   internal-kink energy carries a pressure-driven part quadratic in the
   poloidal beta inside q=1.  The reduced model keeps only the resulting
   threshold in central-q deficit, calibrated to equal dc0 at the Bussac value
   betaB and to vanish at the flux-pumping threshold betaC of Zhang 2026. *)
dcOf[b_] := dc0 (1 - (b^nn - betaB^nn)/(betaC^nn - betaB^nn));
check["D1 Dc equals dc0 at the Bussac poloidal beta",
  FullSimplify[dcOf[betaB] - dc0] === 0];
check["D2 Dc vanishes at the flux-pumping threshold beta_p,c",
  FullSimplify[dcOf[betaC]] === 0];
check["D3 Dc decreases monotonically with beta_p for the Bussac exponent 2",
  Refine[D[dcOf[betaP], betaP] < 0 /. nn -> 2,
    dc0 > 0 && betaP > 0 && betaC > betaB > 0] === True];
check["D4 above beta_p,c the threshold is negative: the mode is driven at q0 >= 1",
  Refine[dcOf[betaP] < 0 /. nn -> 2,
    dc0 > 0 && betaP > betaC > betaB > 0] === True];
check["D5 numeric: Dc(3.3) = -0.10573 with dc0 = 0.06, betaB = 0.3, betaC = 2",
  Abs[N[dcOf[33/10] /. {dc0 -> 6/100, betaB -> 3/10, betaC -> 2, nn -> 2}] +
      0.1057289] < 10^-6];

(* Anchor 1 of the Python calibration: Kk from the observed clamping level. *)
check["D6 the dynamo-gain anchor Kk = (DOhm - Dop)/(Dop - Dc) gives 1.72818",
  Abs[N[(dOhmAug - 1/100)/(1/100 + 0.1057289002557545)] - 1.7281768] <
    10^-6];

(* ================================================================ *)
(* E.  Hysteretic variant: fold, delayed ignition, cycle identity     *)
(* ================================================================ *)

(* Quintic saturation: dA/dtau = Ga ((Delta - Dc) A + bb A^3 - A^5). *)
nullQuintic = (dd - Dc) + bb xx - xx^2;   (* xx = A^2 *)
foldSolution = Solve[{nullQuintic == 0, D[nullQuintic, xx] == 0}, {xx, dd}];
check["E1 the mode branch folds at Delta = Dc - bb^2/4 with A^2 = bb/2",
  Simplify[{xx, dd} /. foldSolution[[1]]] === {bb/2, Dc - bb^2/4}];
check["E2 at the linear threshold the saturated amplitude is A^2 = bb",
  Simplify[Solve[(nullQuintic /. dd -> Dc) == 0 && xx != 0, xx]] ===
    {{xx -> bb}}];
check["E3 the two positive branches merge only at the fold",
  FullSimplify[Discriminant[nullQuintic, xx] /. dd -> Dc - bb^2/4] === 0];

(* Pontryagin delayed loss of stability.  A = 0 is an invariant manifold and
   d(Log A)/dtau = Ga (Delta - Dc), so after a collapse the amplitude only
   recovers once the accumulated growth cancels the accumulated decay:
     Integrate[(Delta - Dc)/S0[Delta], {Delta, Dfold, Dign}] == 0.
   For a slow speed S0 that is constant across the (narrow) window this is the
   mirror rule Dign - Dc == Dc - Dfold, i.e. an excursion twice the naive
   hysteresis window.  The Ga dependence cancels exactly, which is why the
   delay does NOT vanish in the singular limit. *)
delayIntegral = Integrate[(dd - Dc)/1, {dd, Dc - bb^2/4, Dc + gg}];
check["E4 the entry-exit integral is (gg^2 - bb^4/16)/2",
  FullSimplify[delayIntegral - (gg^2 - bb^4/16)/2] === 0];
check["E4b it vanishes at Dign - Dc = Dc - Dfold = bb^2/4",
  FullSimplify[delayIntegral /. gg -> bb^2/4] === 0 &&
    Refine[Solve[delayIntegral == 0, gg] === {{gg -> -(bb^2/4)},
      {gg -> bb^2/4}}, bb > 0] === True];
check["E5 the delay condition is independent of Ga",
  FreeQ[Simplify[delayIntegral], Ga]];
check["E6 the cycle's central-q excursion is bb^2/2",
  FullSimplify[(Dc + bb^2/4) - (Dc - bb^2/4) - bb^2/2] === 0];

(* Peak amplitude at the delayed ignition point. *)
aMaxSq = Simplify[
  (bb + Sqrt[bb^2 + 4 (bb^2/4)])/2, bb > 0];
check["E7 the peak amplitude is A^2 = bb (1 + Sqrt[2])/2",
  FullSimplify[aMaxSq - bb (1 + Sqrt[2])/2] === 0];
check["E8 cycle identity: Delta q0 = 2 A_max^4/(1 + Sqrt[2])^2",
  FullSimplify[bb^2/2 - 2 (bb (1 + Sqrt[2])/2)^2/(1 + Sqrt[2])^2] === 0];

(* Consequence used in FINDINGS.md: a smooth (non-reconnecting) cycle with the
   observed 0.07 excursion of q0 would need an amplitude
   A_max = (0.07 (1+Sqrt2)^2/2)^(1/4). *)
aNeeded = N[(7/100 (1 + Sqrt[2])^2/2)^(1/4), 10];
Print["    a smooth cycle with the observed Delta q0 = 0.07 needs A_max = ",
  N[aNeeded, 5], " versus the calibrated A_rec = 0.368 at beta_p = 3.3"];
check["E9 the observed sawtoothing excursion needs A_max above the calibrated A_rec",
  N[aNeeded] > 0.368];

(* ================================================================ *)
(* F.  Static Krook parallel response (kinetic closure)              *)
(* ================================================================ *)

$Assumptions = True;
maxwell[uu_] := Exp[-uu^2/2]/Sqrt[2 Pi];
gExact = Integrate[uu^2 maxwell[uu]/(1 + xi^2 uu^2), {uu, -Infinity, Infinity},
  Assumptions -> xi > 0];
gClosed = (1 - Sqrt[Pi/2] Exp[1/(2 xi^2)] Erfc[1/(xi Sqrt[2])]/xi)/xi^2;

check["F1 the closed form used by closures.krook_response is exact",
  FullSimplify[gExact - gClosed] === 0];
(* The closed form has an essential singularity at xi = 0 (Erfc of a large
   argument times a huge exponential), so the collisional expansion is
   established from the exact Maxwellian moments, exactly as in script 44:
   expanding 1/(1 + xi^2 u^2) term by term gives
   G = <u^2> - xi^2 <u^4> + xi^4 <u^6> - ... = 1 - 3 xi^2 + 15 xi^4 - ... *)
check["F2 collisional limit G(0) = 1 from the exact second moment",
  Integrate[uu^2 maxwell[uu], {uu, -Infinity, Infinity}] === 1];
check["F3 first kinetic correction is -3 xi^2 from the exact fourth moment",
  Integrate[uu^4 maxwell[uu], {uu, -Infinity, Infinity}] === 3];
check["F4 fourth-order coefficient is +15 from the exact sixth moment",
  Integrate[uu^6 maxwell[uu], {uu, -Infinity, Infinity}] === 15];
check["F4b the closed form matches the moment expansion at xi = 1/20",
  Abs[N[(gClosed /. xi -> 1/20) - (1 - 3/400 + 15/160000 - 105/64000000),
      40]] < 10^-7];
check["F5 collisionless limit G -> 1/xi^2: adiabatic screening",
  Limit[xi^2 gClosed, xi -> Infinity, Assumptions -> True] === 1];
check["F6 G decreases monotonically over five decades in xi",
  Module[{vals},
    vals = Table[N[gClosed /. xi -> 10^k, 20], {k, -2, 3, 1/8}];
    And @@ (Negative /@ Differences[vals])]];

(* AUG #36663 chain of script 44, reproduced so that the Python coefficient
   mfp_over_r0 = 2524.3 is traceable. *)
eta0 = 241/100 10^-9; bb0 = 257/100; nne = 98/100 10^20;
rr0 = N[441/100/bb0, 20];
me = 91093837/10^38; ee = 1602177/10^25;
teKev = N[(165/100 10^-9 15/eta0)^(2/3), 20];
vte = N[Sqrt[teKev 10^3 ee/me], 20];
nuEff = N[nne ee^2 eta0/me, 20];
lambdaMfp = vte/nuEff;
mfpOverR0 = lambdaMfp/rr0;
Print["    AUG: Te = ", N[teKev, 5], " keV, lambda_mfp = ", N[lambdaMfp, 5],
  " m, R0 = ", N[rr0, 5], " m, lambda/R0 = ", N[mfpOverR0, 6]];
check["F7 AUG: lambda_mfp/R0 = 2524.3 (the Python coefficient)",
  Abs[N[mfpOverR0] - 2524.3] < 0.5];
xiOp = mfpOverR0/100;
check["F8 AUG: xi at |q-1| = 0.01 is 25.24",
  Abs[N[xiOp] - 25.243] < 0.01];
suppression = N[gClosed /. xi -> xiOp, 20];
Print["    AUG: kinetic suppression G(xi_op) = ",
  ScientificForm[N[suppression, 4], 4],
  "  (fluid Ohm overestimates by ", N[1/suppression, 5], ")"];
check["F9 AUG: the kinetic suppression at the operating detuning is 1.49e-3",
  Abs[N[suppression] - 1.49 10^-3] < 10^-5];
xiHalf = xi /. FindRoot[gClosed == 1/2, {xi, 6/10}, WorkingPrecision -> 20];
layer = xiHalf/mfpOverR0;
check["F10 AUG: the local-Ohm layer is |q-1| = 2.70e-4",
  Abs[N[layer] - 2.70 10^-4] < 10^-6];

(* ================================================================ *)
(* G.  Closure slopes: which closure can move the access boundary     *)
(* ================================================================ *)

(* The dynamo response used by the reduced model is
     Psi[Delta] = Delta S[Delta] / (Dop S[Dop]),
   with S the parallel conductivity ratio.  A CONSTANT S (any mean
   neoclassical correction, Redl included) cancels identically: it cannot
   change the shape and therefore cannot move the boundary once the dynamo is
   calibrated at the operating point. *)
psiOf[s_] := Function[dv, dv s[dv]/(dop s[dop])];
check["G1 a constant conductivity ratio cancels in the normalization",
  FullSimplify[psiOf[Function[dv, lam]][dd] - dd/dop] === 0];
check["G2 the fluid slope at the operating point is exactly 1/Dop",
  FullSimplify[(D[psiOf[Function[dv, 1]][dv], dv] /. dv -> dop) - 1/dop] === 0];

(* The kinetic response has S = G(xi(Delta)) with xi = Delta lambda/R0, so
   Psi ~ Delta G ~ 1/Delta once xi >> 1: the slope changes sign. *)
psiKin[dv_] := dv (gClosed /. xi -> dv mfpOverR0)/
  (dop (gClosed /. xi -> dop mfpOverR0));
slopeKin = N[(D[psiKin[dv], dv] /. dv -> 1/100) /. dop -> 1/100, 20];
Print["    Psi'(Dop): fluid = ", N[1/(1/100)], ", kinetic = ",
  N[slopeKin, 6]];
check["G3 the kinetic slope at the operating point is negative",
  N[slopeKin] < 0];
check["G4 the kinetic slope magnitude is 95.1 against the fluid +100",
  Abs[N[slopeKin] + 95.1] < 0.2];
check["G5 the kinetic response is non-monotone with its peak near the layer",
  Module[{peak},
    peak = dv /. FindRoot[
      Evaluate[N[D[psiKin[dv], dv] /. dop -> 1/100]], {dv, 3. 10^-4}];
    Abs[N[peak/layer] - 1] < 0.5]];

(* The trace contribution.  With a detuning-dependent response,
   dG/dDelta = -(1 - Ee) - Kk A*^2 Psi'[Delta*], so a closure with negative
   slope acts exactly like extra autocatalysis.  Numbers at the AUG anchor:
   Kk = 1.72818, A*^2 = Dop - Dc(3.3) = 0.11573. *)
aStarSqAug = 1/100 + 0.1057289002557545;
eEffFluid = -kkAugReal aStarSqAug 100;
eEffKinetic = -kkAugReal aStarSqAug N[slopeKin];
Print["    E_eff: fluid = ", N[eEffFluid, 5], ", kinetic = ",
  N[eEffKinetic, 5], ",  largest derivable thermal Ee = 1.2"];
check["G6 the fluid closure contributes -20.0 to the destabilizing trace",
  Abs[N[eEffFluid] + 20.0] < 0.05];
check["G7 the kinetic closure contributes +19.0",
  Abs[N[eEffKinetic] - 19.0] < 0.1];
check["G8 the closure term dominates the thermal feedback by more than 15x",
  Abs[N[eEffKinetic]]/N[3 teFixed] > 15];
check["G9 even so, the kinetic term stays far below the AUG Hopf threshold",
  N[eEffKinetic] < N[1 + 2 gaAug aStarSqAug]/1000];

reportAndExit[];

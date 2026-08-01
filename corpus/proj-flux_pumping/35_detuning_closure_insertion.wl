(* Parametric detuning-law insertion into the spectral Maxwell closure chain.

   MACHINERY WITH A PARAMETRIC LAW, NOT A KINETIC RESULT.  This script wires
   the pipeline  J(D) -> delta B -> Delta -> delta iota  end to end for the
   two-sided parametric law

     J(D) = A_side |D|^p exp(i phi_side),   side = sign(D),

   whose (amplitude, power, phase_rad) fields are exactly what
   runs/wp2_neo2/helical_core_l1/fit_detuning_law.py reports per side once a
   NEO-2 detuning scan exists (map amplitude -> ampPlus/ampMinus, power ->
   lawExponent, phase_rad -> phasePlus/phaseMinus below).  No constitutive
   kinetic J(D) has been accepted; the numbers below demonstrate the
   machinery only.  The fit itself is additionally conditional on the
   quasineutrality closure for the misalignment potential Phi^(MA), because
   J is linear in Phi^(MA); see the fit_detuning_law.py docstring.

   Chain and provenance:
   - Maxwell solve: the script-32 spectral Green construction
     u = K_m(kr) Int_0^r s^2 (k I_m'(ks)) S ds
       + I_m(kr) Int_r^inf s^2 (k K_m'(ks)) S ds,
     radial field f = (u' - r S)/m, for the helical current harmonic
     j_z = S(r) cos(chi), chi = m theta + k z (+ phase), k = n/R0.  The
     potential is refitted as an exact-coefficient Chebyshev polynomial on
     the analysis window so the field-line traces run in exact arithmetic;
     the fit is validated against the radial ODE and against the direct
     script-32 Green field.
   - Surface and transform: the script-33 second-order decomposition
     (corrugated-path term = delta_iota_geom, mean-current pullback =
     delta_iota_mean) and the direct full-field trace with the helical-flux
     invariant (delta_iota_full).
   - Model: straight periodic cylinder, report convention
     exp(+i(m theta + n phi)), (m,n) = (1,1), z = R0 phi, CGS/Gaussian in
     normalized units (bz0 = 1, lengths in source-scale units).  The mean
     axial field of the quadratic pullback vanishes here (single-helicity
     current tangency gives a poloidal mean field only); the general
     meanBz formula is verified in script 33.

   Scaling of the inserted law (verified below): f, g, h scale as |D0|^p,
   Delta as |D0|^(p-1), and the mean-current (axisymmetric) feedback as
   |D0|^(2p-1) exactly.  With constant detuning across the window the
   corrugated-path term is 1/D-enhanced and also enters at leading order
   |D0|^(2p-1).

   Traces exploit that iota is exactly even in the corrugation amplitude t
   (t -> -t is the phase shift chi -> chi + pi; checked below), so
   delta_iota_full = trace(t=1) - iota0 carries quadratic plus quartic and
   higher even orders.  A Richardson split of traces at t = 1 and t = 1/2
   isolates the quadratic part for the required decomposition check and
   measures the quartic remainder explicitly. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];
figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];

ClearAll[x, s, amp, d0sym, dAbsSym];
mMode = 1;
nMode = 1;
capR = 5;
kWave = nMode/capR;
bz0 = 1;

(* Parametric law parameters (placeholders for fit_detuning_law.py output). *)
lawExponent = 2;
ampPlus = 1/5;
ampMinus = 3/10;
phasePlus = 3/10;
phaseMinus = -2/5;

envExpr = Sqrt[2 E] x Exp[-x^2];
check["source envelope has unit peak amplitude",
  FullSimplify[(envExpr /. x -> 1/Sqrt[2]) == 1 &&
    (D[envExpr, x] /. x -> 1/Sqrt[2]) == 0]];

(* ---- generic second-order decomposition (script-33 machinery) ---- *)
ClearAll[decomposition];
decomposition[uE_, sE_, dE_] := Module[
  {fE, gE, hE, phaseE, deltaE, gammaE, a0E, a1E, a2E, hSeriesE},
  fE = (D[uE, x] - x sE)/mMode;
  gE = uE/x;
  hE = kWave uE/mMode;
  phaseE = mMode gE/x + kWave hE;
  deltaE = fE/dE;
  gammaE = deltaE D[deltaE, x] +
    deltaE^2 (1 + x D[dE, x]/dE)/(2 x);
  a0E = bz0/(capR dE);
  a1E = (hE dE - bz0 phaseE)/(capR dE^2);
  a2E = bz0 phaseE^2/(capR dE^3) - hE phaseE/(capR dE^2);
  hSeriesE = gammaE D[a0E, x] + deltaE^2 D[a0E, {x, 2}]/2 -
    deltaE D[a1E, x] + a2E;
  <|"f" -> fE, "g" -> gE, "h" -> hE, "delta" -> deltaE,
    "btheta0" -> x (dE - kWave bz0)/mMode,
    "iota0" -> capR (dE - kWave bz0)/(mMode bz0),
    "cHelical" -> -hSeriesE/(2 mMode a0E^2),
    "bthetaMean" -> sE deltaE/2,
    "cMean" -> capR sE deltaE/(2 x bz0),
    "meanSource" -> D[x sE deltaE, x]/(2 x),
    "deltaI" -> Pi x sE deltaE|>];

(* Cross-check the generic machinery against the script-33 analytic fixture
   (same m, k, R0, bz0): inserting its u, S, D here must reproduce the
   directly transcribed script-33 coefficient expressions. *)
Module[{iota33, u33, s33, d33, generic, f33, g33, h33, phase33, delta33,
    gamma33, a033, a133, a233, hSeries33, cHel33, cMean33},
  iota33 = -3/4 + 3 x^2/100;
  u33 = x^3/100;
  s33 = (8 x/3 - kWave^2 x^3/5)/100;
  d33 = (iota33 + 1)/capR;
  generic = decomposition[u33, s33, d33];
  f33 = (D[u33, x] - x s33)/mMode;
  g33 = u33/x;
  h33 = kWave u33/mMode;
  phase33 = mMode g33/x + kWave h33;
  delta33 = f33/d33;
  gamma33 = delta33 D[delta33, x] +
    delta33^2 (1 + x D[d33, x]/d33)/(2 x);
  a033 = bz0/(capR d33);
  a133 = (h33 d33 - bz0 phase33)/(capR d33^2);
  a233 = bz0 phase33^2/(capR d33^3) - h33 phase33/(capR d33^2);
  hSeries33 = gamma33 D[a033, x] + delta33^2 D[a033, {x, 2}]/2 -
    delta33 D[a133, x] + a233;
  cHel33 = -hSeries33/(2 mMode a033^2);
  cMean33 = capR s33 delta33/(2 x bz0);
  check["generic machinery reproduces the script-33 corrugated-path term",
    Together[generic["cHelical"] - cHel33] === 0];
  check["generic machinery reproduces the script-33 mean-current pullback term",
    Together[generic["cMean"] - cMean33] === 0];
  check["generic machinery reproduces the script-33 fixture total at rho=1",
    Abs[N[(generic["cHelical"] + generic["cMean"]) /. x -> 1, 20] -
      N[(cHel33 + cMean33) /. x -> 1, 20]] < 10^-18];
  ];

(* ---- script-32 Green construction for an arbitrary source ---- *)
ClearAll[regularPrimeAt, decayingPrimeAt, greenPair, greenFieldAt];
regularPrimeAt[y_?NumericQ] := kWave (BesselI[mMode - 1, kWave y] +
    BesselI[mMode + 1, kWave y])/2;
decayingPrimeAt[y_?NumericQ] := -kWave (BesselK[mMode - 1, kWave y] +
    BesselK[mMode + 1, kWave y])/2;
greenPair[srcExpr_, y_?NumericQ] := Module[{lower, upper},
  lower = NIntegrate[s^2 regularPrimeAt[s] (srcExpr /. x -> s),
    {s, 0, y}, WorkingPrecision -> 20, AccuracyGoal -> 16,
    PrecisionGoal -> 16, MaxRecursion -> 14];
  upper = NIntegrate[s^2 decayingPrimeAt[s] (srcExpr /. x -> s),
    {s, y, Infinity}, WorkingPrecision -> 20, AccuracyGoal -> 16,
    PrecisionGoal -> 16, MaxRecursion -> 14];
  {lower, upper}];
greenFieldAt[srcExpr_, y_?NumericQ] := Module[{pair = greenPair[srcExpr, y]},
  (decayingPrimeAt[y] pair[[1]] + regularPrimeAt[y] pair[[2]])/mMode];

(* Exact-coefficient Chebyshev refit of the Green potential on the fit
   window, so the WP-35+ traces run in exact arithmetic. *)
fitLo = 22/100;
fitHi = 15/8;
nCheb = 40;
chebAngles = Table[Pi (2 j - 1)/(2 nCheb), {j, nCheb}];
chebNodes = N[(fitLo + fitHi)/2 + (fitHi - fitLo)/2 Cos[chebAngles], 25];

ClearAll[chebSeriesFromValues, chebFit, chebAntiderivative];
chebSeriesFromValues[values_List] := Module[
  {coeffs, maxCoeff, keepOrders, fit, tailRatio},
  coeffs = Table[2/nCheb Sum[values[[j]] Cos[degree chebAngles[[j]]],
      {j, nCheb}], {degree, 0, nCheb - 1}];
  maxCoeff = Max[Abs[coeffs]];
  tailRatio = Max[Abs[coeffs[[-5 ;;]]]]/maxCoeff;
  keepOrders = Select[Range[nCheb - 1],
    Abs[coeffs[[# + 1]]] > 10^-19 maxCoeff &];
  fit = Rationalize[coeffs[[1]], 0]/2 +
    Sum[Rationalize[coeffs[[degree + 1]], 0] ChebyshevT[degree,
        (2 x - fitLo - fitHi)/(fitHi - fitLo)],
      {degree, keepOrders}];
  <|"fit" -> fit, "tailRatio" -> tailRatio|>];
chebFit[srcExpr_] := Module[
  {order, nodesAscending, lowSegs, lowAcc, tail, upSegs, upAcc, lowerVals,
    upperVals, potentials},
  order = Ordering[chebNodes];
  nodesAscending = chebNodes[[order]];
  lowSegs = Table[NIntegrate[s^2 regularPrimeAt[s] (srcExpr /. x -> s),
      {s, If[j == 1, 0, nodesAscending[[j - 1]]], nodesAscending[[j]]},
      WorkingPrecision -> 20, AccuracyGoal -> 16, PrecisionGoal -> 16,
      MaxRecursion -> 14],
    {j, nCheb}];
  lowAcc = Accumulate[lowSegs];
  tail = NIntegrate[s^2 decayingPrimeAt[s] (srcExpr /. x -> s),
    {s, Last[nodesAscending], Infinity}, WorkingPrecision -> 20,
    AccuracyGoal -> 16, PrecisionGoal -> 16, MaxRecursion -> 14];
  upSegs = Table[NIntegrate[s^2 decayingPrimeAt[s] (srcExpr /. x -> s),
      {s, nodesAscending[[j]], nodesAscending[[j + 1]]},
      WorkingPrecision -> 20, AccuracyGoal -> 16, PrecisionGoal -> 16,
      MaxRecursion -> 14],
    {j, nCheb - 1}];
  upAcc = Reverse[Accumulate[Reverse[Append[upSegs, 0]]]] + tail;
  lowerVals = ConstantArray[0, nCheb];
  upperVals = ConstantArray[0, nCheb];
  lowerVals[[order]] = lowAcc;
  upperVals[[order]] = upAcc;
  potentials = Table[BesselK[mMode, kWave chebNodes[[j]]] lowerVals[[j]] +
      BesselI[mMode, kWave chebNodes[[j]]] upperVals[[j]],
    {j, nCheb}];
  chebSeriesFromValues[potentials]];
(* Antiderivatives of gaussian-polynomial integrands are represented as
   Chebyshev fits of segmentwise NIntegrate values, NOT as closed-form
   Integrate results: the closed forms combine astronomically large
   Erf/exponential terms whose cancellation exceeds $MaxExtraPrecision, so
   they evaluate as noise inside the high-precision traces (this was
   caught by the sheared decomposition check). *)
chebAntiderivative[integrandExpr_] := Module[
  {order, nodesAscending, segs, acc, values},
  order = Ordering[chebNodes];
  nodesAscending = chebNodes[[order]];
  segs = Table[NIntegrate[integrandExpr /. x -> s,
      {s, If[j == 1, fitLo, nodesAscending[[j - 1]]], nodesAscending[[j]]},
      WorkingPrecision -> 35, AccuracyGoal -> 25, PrecisionGoal -> 25,
      MaxRecursion -> 14],
    {j, nCheb}];
  acc = Accumulate[segs];
  values = ConstantArray[0, nCheb];
  values[[order]] = acc;
  chebSeriesFromValues[values]];

uUnit = chebFit[envExpr];
check["Chebyshev fit of the unit-source Green potential is resolved (tail below 1e-13)",
  uUnit["tailRatio"] < 10^-13];

shearD0 = 1/10;
shearCoef = 3/100;
shearDetExpr = shearD0 + shearCoef (x^2 - 1)/capR;
shearSourceExpr = ampPlus shearDetExpr^2 envExpr;
uShear = chebFit[shearSourceExpr];
check["Chebyshev fit of the sheared-source Green potential is resolved (tail below 1e-13)",
  uShear["tailRatio"] < 10^-13];

(* Maxwell fidelity of the refit: the potential must solve the radial ODE
   L[u] = x S' + 2 S on the analysis interval and its field (u'-xS)/m must
   match the direct script-32 Green field at off-node radii. *)
analysisGrid = Range[0.30, 1.60, 0.05];
ClearAll[odeResidualScale, fieldMismatch];
odeResidualScale[uFitExpr_, srcExpr_] := Module[
  {rhsExpr, residExpr, residMax, rhsMax},
  rhsExpr = x D[srcExpr, x] + 2 srcExpr;
  residExpr = D[uFitExpr, {x, 2}] + D[uFitExpr, x]/x -
    (mMode^2/x^2 + kWave^2) uFitExpr - rhsExpr;
  residMax = Max[Abs[(residExpr /. x -> #) & /@ analysisGrid]];
  rhsMax = Max[Abs[(rhsExpr /. x -> #) & /@ analysisGrid]];
  residMax/rhsMax];
unitResidual = odeResidualScale[uUnit["fit"], envExpr];
shearResidual = odeResidualScale[uShear["fit"], shearSourceExpr];
Print["    ODE residual (relative): unit source ", N[unitResidual, 3],
  ", sheared source ", N[shearResidual, 3]];
check["fitted unit-source potential solves the radial Maxwell ODE (rel tol 1e-8)",
  unitResidual < 10^-8];
check["fitted sheared-source potential solves the radial Maxwell ODE (rel tol 1e-8)",
  shearResidual < 10^-8];

fieldCheckRadii = {0.35, 0.7, 1.0, 1.3, 1.55};
fieldMismatch[uFitExpr_, srcExpr_] := Module[{fFitExpr, fitted, direct},
  fFitExpr = (D[uFitExpr, x] - x srcExpr)/mMode;
  fitted = (N[fFitExpr /. x -> Rationalize[#, 0], 20] &) /@ fieldCheckRadii;
  direct = (greenFieldAt[srcExpr, #] &) /@ fieldCheckRadii;
  Max[Abs[fitted - direct]]/Max[Abs[direct]]];
unitFieldMismatch = fieldMismatch[uUnit["fit"], envExpr];
shearFieldMismatch = fieldMismatch[uShear["fit"], shearSourceExpr];
Print["    field vs direct script-32 Green field (relative): unit ",
  N[unitFieldMismatch, 3], ", sheared ", N[shearFieldMismatch, 3]];
check["fitted field matches the script-32 Green radial field, unit source (rel tol 1e-9)",
  unitFieldMismatch < 10^-9];
check["fitted field matches the script-32 Green radial field, sheared source (rel tol 1e-9)",
  shearFieldMismatch < 10^-9];

(* ---- one-parameter family of unsheared configurations ----
   D(x) = D0 (signed constant), S = amp env, u = amp uUnit,
   amp = A_side |D0|^p.  amp and D0 stay symbolic so scan points and
   scaling checks substitute exact rationals. *)
decompFamily = decomposition[amp uUnit["fit"], amp envExpr, d0sym];
ClearAll[antiderivativeMismatch];
antiderivativeMismatch[fitExpr_, integrandExpr_] := Module[
  {derivExpr, derivVals, integrandVals},
  derivExpr = D[fitExpr, x];
  derivVals = (N[derivExpr /. x -> Rationalize[#, 0], 20] &) /@ analysisGrid;
  integrandVals = (N[integrandExpr /. x -> Rationalize[#, 0], 20] &) /@
    analysisGrid;
  Max[Abs[derivVals - integrandVals]]/Max[Abs[integrandVals]]];
familyMeanIntegrand = envExpr (D[uUnit["fit"], x] - x envExpr)/mMode;
meanFluxUnit = chebAntiderivative[familyMeanIntegrand];
familyMeanFlux = -mMode amp^2 meanFluxUnit["fit"]/(2 d0sym);
check["fitted family mean-flux antiderivative matches -m bthetaMean (rel tol 1e-8)",
  meanFluxUnit["tailRatio"] < 10^-10 &&
    antiderivativeMismatch[-mMode meanFluxUnit["fit"]/2,
      -mMode familyMeanIntegrand/2] < 10^-8];
familyPsi0 = -d0sym x^2/2;

(* Sheared configuration: exercises D'(x) != 0 in every term. *)
decompShear = decomposition[uShear["fit"], shearSourceExpr, shearDetExpr];
shearMeanFit = chebAntiderivative[decompShear["bthetaMean"]];
shearMeanFlux = -mMode shearMeanFit["fit"];
check["fitted sheared mean-flux antiderivative matches -m bthetaMean (rel tol 1e-8)",
  shearMeanFit["tailRatio"] < 10^-10 &&
    antiderivativeMismatch[shearMeanFlux,
      -mMode decompShear["bthetaMean"]] < 10^-8];
shearPsi0 = -(shearD0 - shearCoef/capR) x^2/2 - shearCoef x^4/(4 capR);
check["background flux derivatives are -x D (family and sheared)",
  Simplify[D[familyPsi0, x] + x d0sym] === 0 &&
    Simplify[D[shearPsi0, x] + x shearDetExpr] === 0];

(* ---- direct full-field trace (script-33 protocol) ---- *)
ClearAll[traceIota, configFor, shearConfig];
configFor[side_Integer, dAbs_Rational, p_Integer] := Module[{ampValue, rules},
  ampValue = If[side > 0, ampPlus, ampMinus] dAbs^p;
  rules = {amp -> ampValue, d0sym -> side dAbs};
  Join[decompFamily /. rules,
    <|"psi0" -> familyPsi0 /. rules, "meanFlux" -> familyMeanFlux /. rules|>]];
shearConfig = Join[decompShear,
  <|"psi0" -> shearPsi0, "meanFlux" -> shearMeanFlux|>];

traceIota[cfg_, rhoValue_, t_, phase0_] := Module[
  {backgroundFlux, invariant, qValue, radiusOnSurface, zetaAdvance, phase,
    radius},
  backgroundFlux[y_?NumericQ] := (cfg["psi0"] /. x -> y) +
    t^2 (cfg["meanFlux"] /. x -> y);
  invariant[y_?NumericQ, ph_?NumericQ] := backgroundFlux[y] -
    t y (cfg["f"] /. x -> y) Cos[ph + phase0];
  qValue[y_?NumericQ, ph_?NumericQ] :=
    mMode ((cfg["btheta0"] /. x -> y) +
        t (cfg["g"] /. x -> y) Cos[ph + phase0] +
        t^2 (cfg["bthetaMean"] /. x -> y))/y +
      kWave (bz0 + t (cfg["h"] /. x -> y) Cos[ph + phase0]);
  radiusOnSurface[ph_?NumericQ] := radius /. FindRoot[
      invariant[radius, ph] == backgroundFlux[rhoValue],
      {radius, rhoValue}, WorkingPrecision -> 40,
      AccuracyGoal -> 26, PrecisionGoal -> 26];
  (* The phase integrand is analytic and periodic, so the trapezoidal
     rule converges geometrically; it agrees with the default rule at
     WorkingPrecision 40 to 25 digits and is orders of magnitude
     cheaper. *)
  zetaAdvance = NIntegrate[
    With[{y = radiusOnSurface[phase]},
      (bz0 + t (cfg["h"] /. x -> y) Cos[phase + phase0])/
        (capR qValue[y, phase])], {phase, 0, 2 Pi},
    Method -> "Trapezoidal", WorkingPrecision -> 35,
    AccuracyGoal -> 24, PrecisionGoal -> 22, MaxRecursion -> 18];
  2 Pi/(mMode zetaAdvance) - nMode/mMode];

(* Trace harness sanity: zero insertion returns the background transform. *)
sanityConfig = configFor[1, 4/25, lawExponent];
sanityIotaZero = traceIota[sanityConfig, 1, 0, 0];
check["trace harness: zero-amplitude trace returns the background transform",
  Abs[sanityIotaZero - N[sanityConfig["iota0"] /. x -> 1, 30]] < 10^-18];

(* Phase gauge: the law phase phi_side rotates the corrugation rigidly and
   cannot change any single-helicity pipeline observable; it becomes
   physical only relative to the imposed drive.  Evenness in t is the
   special case phase0 = pi.  This justifies inserting |J| only. *)
sanityIotaBase = traceIota[sanityConfig, 1, 1, 0];
check["phase gauge: trace with law phase phi_+ equals the phase-zero trace",
  Abs[traceIota[sanityConfig, 1, 1, phasePlus] - sanityIotaBase] < 10^-14];
check["phase gauge: trace is even in the corrugation amplitude t",
  Abs[traceIota[sanityConfig, 1, -1, 0] - sanityIotaBase] < 10^-14];

(* ---- REQUIRED protocol (ROADMAP): delta_iota_full = delta_iota_geom +
   delta_iota_mean at the traced configurations.  The Richardson split of
   traces at t = 1 and t = 1/2 isolates the quadratic part
   c2 = (16 full(1/2) - full(1))/3 and measures the quartic remainder
   c4 = full(1) - c2 explicitly. ---- *)
ClearAll[decompositionCheck];
decompositionCheck[name_String, cfg_, rhoValue_] := Module[
  {geom, mean, sum, iotaZero, fullOne, fullHalf, quadratic, quartic,
    tolerance},
  geom = N[cfg["cHelical"] /. x -> rhoValue, 30];
  mean = N[cfg["cMean"] /. x -> rhoValue, 30];
  sum = geom + mean;
  iotaZero = N[cfg["iota0"] /. x -> rhoValue, 30];
  fullOne = traceIota[cfg, rhoValue, 1, 0] - iotaZero;
  fullHalf = traceIota[cfg, rhoValue, 1/2, 0] - iotaZero;
  quadratic = (16 fullHalf - fullOne)/3;
  quartic = fullOne - quadratic;
  tolerance = 10^-3 Abs[sum] + 5 10^-11;
  Print["    ", name, ": geom ", N[geom, 8], ", mean ", N[mean, 8],
    ", geom+mean ", N[sum, 8]];
  Print["      full(t=1) ", N[fullOne, 8], ", quadratic part ",
    N[quadratic, 8], ", quartic remainder ", N[quartic, 3],
    ", |quad - sum| ", N[Abs[quadratic - sum], 3], ", tol ",
    N[tolerance, 3]];
  check[name <>
    ": delta_iota_full (quadratic part of the direct trace) equals delta_iota_geom + delta_iota_mean (rel tol 1e-3)",
    Abs[quadratic - sum] < tolerance];
  <|"geom" -> geom, "mean" -> mean, "full" -> fullOne,
    "quadratic" -> quadratic, "quartic" -> quartic|>];

tracedFamily = {
  {"insertion + side, |D0| = 1/50", configFor[1, 1/50, lawExponent], 1/50},
  {"insertion + side, |D0| = 243/1600",
    configFor[1, 243/1600, lawExponent], 243/1600},
  {"insertion - side, |D0| = 1/50", configFor[-1, 1/50, lawExponent], 1/50},
  {"insertion - side, |D0| = 243/1600",
    configFor[-1, 243/1600, lawExponent], 243/1600}};
tracedResults = (decompositionCheck[#[[1]], #[[2]], 1] &) /@ tracedFamily;

shearRadii = {3/5, 1, 7/5};
shearResults = (decompositionCheck[
    "sheared insertion at rho = " <> ToString[#, InputForm], shearConfig,
    #] &) /@ shearRadii;

check["quartic remainders stay below 5% of the quadratic decomposition",
  Max[(Abs[#["quartic"]]/Abs[#["geom"] + #["mean"]] &) /@
    Join[tracedResults, shearResults]] < 1/20];

(* ---- feedback scaling against the script-33 series machinery ----
   Exact statements for the inserted family (constant D0 on the window):
   f, g, h ~ |D0|^p, Delta ~ |D0|^(p-1), mean feedback ~ |D0|^(2p-1)
   exactly; the corrugated-path term is 1/D-enhanced and enters at the same
   leading order |D0|^(2p-1). *)
cHelAt1 = decompFamily["cHelical"] /. x -> 1;
cMeanAt1 = decompFamily["cMean"] /. x -> 1;
deltaAt1 = decompFamily["delta"] /. x -> 1;
fAt1 = decompFamily["f"] /. x -> 1;

Do[
  Module[{subs, meanScaled, deltaScaled, fScaled, geomScaled, geomLeading,
      sideName},
    sideName = If[side > 0, "+", "-"];
    subs = {amp -> If[side > 0, ampPlus, ampMinus] dAbsSym^p,
      d0sym -> side dAbsSym};
    meanScaled = cMeanAt1 /. subs;
    deltaScaled = deltaAt1 /. subs;
    fScaled = fAt1 /. subs;
    geomScaled = cHelAt1 /. subs;
    check["symbolic scaling, p = " <> ToString[p] <> ", side " <> sideName <>
      ": mean feedback is |D0|^(2p-1), Delta is |D0|^(p-1), field is |D0|^p",
      FullSimplify[{meanScaled/(meanScaled /. dAbsSym -> 1),
          deltaScaled/(deltaScaled /. dAbsSym -> 1),
          fScaled/(fScaled /. dAbsSym -> 1)} ==
        {dAbsSym^(2 p - 1), dAbsSym^(p - 1), dAbsSym^p},
        dAbsSym > 0]];
    geomLeading = Limit[geomScaled/dAbsSym^(2 p - 1), dAbsSym -> 0];
    check["symbolic scaling, p = " <> ToString[p] <> ", side " <> sideName <>
      ": corrugated-path term enters at leading order |D0|^(2p-1)",
      NumericQ[geomLeading] && Abs[N[geomLeading, 20]] > 0];
    ],
  {p, {1, 2}}, {side, {1, -1}}];

scanAbsD = Table[1/50 (3/2)^j, {j, 0, 5}];
ClearAll[scanTable, logSlope];
scanTable[side_, p_] := Table[
  Module[{subs = {amp -> If[side > 0, ampPlus, ampMinus] dAbs^p,
      d0sym -> side dAbs}},
    <|"absD" -> dAbs,
      "f" -> N[fAt1 /. subs, 30],
      "delta" -> N[deltaAt1 /. subs, 30],
      "geom" -> N[cHelAt1 /. subs, 30],
      "mean" -> N[cMeanAt1 /. subs, 30],
      "total" -> N[(cHelAt1 + cMeanAt1) /. subs, 30]|>],
  {dAbs, scanAbsD}];
scanPlusP2 = scanTable[1, 2];
scanMinusP2 = scanTable[-1, 2];
scanPlusP1 = scanTable[1, 1];

logSlope[table_, key_] := Module[{pts},
  pts = ({Log[N[#["absD"], 30]], Log[Abs[#[key]]]} &) /@ table;
  (Length[pts] Total[Times @@@ pts] -
      Total[pts[[All, 1]]] Total[pts[[All, 2]]])/
    (Length[pts] Total[pts[[All, 1]]^2] - Total[pts[[All, 1]]]^2)];

Print["    numerical scan slopes (p=2, + side): mean ",
  N[logSlope[scanPlusP2, "mean"], 12], ", geom ",
  N[logSlope[scanPlusP2, "geom"], 12]];
check["numerical scaling, p = 2, + side: mean-feedback slope is 2p-1 = 3",
  Abs[logSlope[scanPlusP2, "mean"] - 3] < 10^-10];
check["numerical scaling, p = 2, - side: mean-feedback slope is 2p-1 = 3",
  Abs[logSlope[scanMinusP2, "mean"] - 3] < 10^-10];
check["numerical scaling, p = 1, + side: mean-feedback slope is 2p-1 = 1",
  Abs[logSlope[scanPlusP1, "mean"] - 1] < 10^-10];

check["mean feedback flips sign across resonance",
  And @@ Table[scanPlusP2[[j]]["mean"] scanMinusP2[[j]]["mean"] < 0,
    {j, Length[scanAbsD]}]];
check["side asymmetry of the mean feedback is (A+/A-)^2",
  Max[Table[Abs[Abs[scanPlusP2[[j]]["mean"]/scanMinusP2[[j]]["mean"]] -
      (ampPlus/ampMinus)^2], {j, Length[scanAbsD]}]] < 10^-15];

(* ---- conservation and nested surfaces ---- *)
largestConfig = tracedFamily[[2, 2]];
ClearAll[conservationCheck, nestedMargin];
conservationCheck[name_String, cfg_, srcExpr_, detExpr_] := Module[
  {deltaIGrid, peak, deltaIFar, meanGrid},
  deltaIGrid = ((cfg["deltaI"] /. x -> #) &) /@ analysisGrid;
  peak = Max[Abs[deltaIGrid]];
  deltaIFar = Pi 5 (srcExpr /. x -> 5) greenFieldAt[srcExpr, 5]/
    (detExpr /. x -> 5);
  Print["    ", name, ": peak |deltaI| ", N[peak, 3],
    ", |deltaI(x=5)| ", N[Abs[deltaIFar], 3]];
  check[name <>
    ": total current is preserved (enclosed-current change dies off, rel 1e-8)",
    Abs[deltaIFar] < 10^-8 peak];
  meanGrid = ((cfg["meanSource"] /. x -> #) &) /@ analysisGrid;
  check[name <> ": mean current is redistributed (delta<j_z> changes sign)",
    Min[meanGrid] < 0 < Max[meanGrid]];
  ];
conservationCheck["insertion + side, |D0| = 243/1600", largestConfig,
  ampPlus (243/1600)^lawExponent envExpr, 243/1600];
conservationCheck["sheared insertion", shearConfig, shearSourceExpr,
  shearDetExpr];

nestedMargin[cfg_] := Max[Abs[(D[cfg["delta"], x] /. x -> #) & /@
    analysisGrid]];
nestedLargest = nestedMargin[largestConfig];
nestedShear = nestedMargin[shearConfig];
Print["    nested-surface margin max|Delta'|: largest unsheared ",
  N[nestedLargest, 3], ", sheared ", N[nestedShear, 3]];
check["nested surfaces: max |Delta'| stays far below 1 (radial map monotone)",
  Max[nestedLargest, nestedShear] < 1/10];

(* ---- pipeline grid table (sheared configuration) ---- *)
Print["    pipeline outputs on one radial grid (sheared configuration,"];
Print["      parametric law - NOT a kinetic result):"];
Print["      x, J=S, dB_r=f, dB_theta=g, dB_z=h, Delta, diota_geom,",
  " diota_mean, d<j_z>"];
Do[Module[{row},
    row = N[{xv, shearSourceExpr, decompShear["f"], decompShear["g"],
        decompShear["h"], decompShear["delta"], decompShear["cHelical"],
        decompShear["cMean"], decompShear["meanSource"]} /. x -> xv];
    Print["      ", StringRiffle[(ToString[#, InputForm] &) /@ row, ", "]]],
  {xv, Range[3/10, 16/10, 1/10]}];
Print["    delta_iota_full (direct trace, t=1) at rho = 3/5, 1, 7/5: ",
  N[(#["full"] &) /@ shearResults, 8]];

(* ---- figure ---- *)
styles = {
  Directive[Thick, ColorData[97][1]],
  Directive[Thick, Dashed, ColorData[97][2]],
  Directive[Thick, DotDashed, ColorData[97][4]]};
ClearAll[curve];
curve[table_, key_] := ({N[#["absD"]], N[Abs[#[key]]]} &) /@ table;
amplitudePanel = ListLogLogPlot[
  {curve[scanPlusP2, "f"], curve[scanMinusP2, "f"],
    curve[scanPlusP2, "delta"], curve[scanMinusP2, "delta"]},
  Joined -> True,
  PlotStyle -> {styles[[1]], Directive[Thick, Dashed, ColorData[97][1]],
    styles[[2]], Directive[Thick, Dashed, ColorData[97][2]]},
  PlotMarkers -> {Automatic, 7},
  Frame -> True, FrameLabel -> {"|D0|", "amplitude at rho = 1"},
  PlotLegends -> Placed[{"|\[Delta]B_r|, D0 > 0 (slope p)",
    "|\[Delta]B_r|, D0 < 0", "|\[CapitalDelta]|, D0 > 0 (slope p-1)",
    "|\[CapitalDelta]|, D0 < 0"}, {0.34, 0.76}],
  ImageSize -> 340];
feedbackPanel = Show[
  ListLogLogPlot[
    {curve[scanPlusP2, "geom"], curve[scanMinusP2, "geom"],
      curve[scanPlusP2, "mean"], curve[scanMinusP2, "mean"],
      curve[scanPlusP2, "total"], curve[scanMinusP2, "total"]},
    Joined -> True,
    PlotStyle -> {styles[[3]],
      Directive[Thick, DotDashed, ColorData[97][4]],
      styles[[1]], Directive[Thick, Dashed, ColorData[97][1]],
      Directive[Gray], Directive[Gray, Dashed]},
    PlotMarkers -> {Automatic, 7},
    Frame -> True,
    FrameLabel -> {"|D0|", "|\[Delta]\[Iota]| at rho = 1"},
    PlotLegends -> Placed[{"corrugated path, D0 > 0",
      "corrugated path, D0 < 0", "mean, D0 > 0 (slope 2p-1)",
      "mean, D0 < 0", "sum, D0 > 0", "sum, D0 < 0"}, Below],
    ImageSize -> 340],
  ListLogLogPlot[
    Table[{N[tracedFamily[[j, 3]]],
      N[Abs[tracedResults[[j]]["full"]]]}, {j, Length[tracedFamily]}],
    PlotStyle -> Directive[Black, PointSize[0.02]]]];
insertionFigure = Column[{
  Style["parametric law J(D) = A|D|^p exp(i phi) per side, p = 2: " <>
    "machinery test, not a kinetic result; black: direct full-field trace",
    Italic, 11],
  GraphicsRow[{amplitudePanel, feedbackPanel}, Spacings -> 10,
    ImageSize -> 720]}, Alignment -> Center];
Export[FileNameJoin[{figdir, "fig_closure_insertion.pdf"}], insertionFigure];
check["fig_closure_insertion exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_closure_insertion.pdf"}]]];

reportAndExit[];

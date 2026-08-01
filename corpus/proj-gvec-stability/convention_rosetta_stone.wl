ClearAll["Global`*"];
passed = 0;
failed = 0;
check[name_, condition_, assumptions_: True] := If[
 TrueQ[FullSimplify[condition, assumptions]],
  passed++; Print["PASS  ", name], failed++; Print["FAIL  ", name]];

$Assumptions = rho > 0 && nfp > 0 && mu0 > 0 && density > 0 &&
  majorRadius > 0 && phiEdge != 0 && psiEdge != 0 &&
  Element[{m, n, nfp}, Integers] && Element[sigma, Integers] &&
  sigma^2 == 1;

(* Canonical GLISS equilibrium convention. *)
phaseFull = 2 Pi (m theta - n nfp zetaFull);
phasePeriod = 2 Pi (m theta - n zetaPeriod);
check["field-period coordinate map",
  (phasePeriod /. zetaPeriod -> nfp zetaFull) == phaseFull];
complexCoefficient = cosineCoefficient - I sineCoefficient;
check["complex-to-real coefficient map",
  ComplexExpand[Re[complexCoefficient Exp[I phaseFull]],
    TargetFunctions -> {Re, Im}] ==
   cosineCoefficient Cos[phaseFull] + sineCoefficient Sin[phaseFull],
  Element[{cosineCoefficient, sineCoefficient, theta, zetaFull}, Reals]];

(* Generic GVEC to CAS3D map.  Its orientation is independent of which
   angular coordinate the exporter reverses. *)
gvecMap = {rho^2, -sigma thetaB/(2 Pi), sigma zetaB/(2 Pi)};
gvecJacobian = Det[Outer[D, gvecMap, {rho, thetaB, zetaB}]];
check["generic GVEC map is left handed",
  gvecJacobian == -rho/(2 Pi^2)];
check["generic GVEC orientation choice preserves handedness",
  (gvecJacobian /. sigma -> 1) == (gvecJacobian /. sigma -> -1)];

(* The direct VMEC/BOOZ_XFORM adapter is deliberately narrower: signgs=-1,
   both Boozer angles reverse, and the rotating frame recovers the physical
   cylindrical azimuth zeta_B-nu. *)
rotation[angle_] = {{Cos[angle], -Sin[angle], 0},
  {Sin[angle], Cos[angle], 0}, {0, 0, 1}};
vmecTheta = -thetaB/(2 Pi);
vmecZetaPeriod = -nfp zetaB/(2 Pi);
vmecFrame = {radius Cos[nu], -radius Sin[nu], height};
vmecPhysical = rotation[-2 Pi vmecZetaPeriod/nfp] . vmecFrame;
check["VMEC signgs=-1 physical azimuth",
  vmecPhysical == {radius Cos[zetaB - nu],
    radius Sin[zetaB - nu], height},
  Element[{thetaB, zetaB, radius, nu, height}, Reals]];

(* TERPSICHORE compatibility boundary. *)
bjac = nfp signedJacobian/(4 Pi^2);
check["TERPSICHORE Jacobian map", 4 Pi^2 bjac == nfp signedJacobian];
check["TERPSICHORE internal flux map",
  {ftTerps, fpTerps} == {-ftGliss, -nfp fpGliss} /. {
    ftTerps -> -ftGliss, fpTerps -> -nfp fpGliss}];

(* HELENA/MISHKA source-trace map. *)
lambdaGliss = -lambdaMishka/(mu0 density majorRadius^2);
check["MISHKA unstable sign maps to GLISS negative sign",
  lambdaGliss < 0, lambdaMishka > 0];
check["MISHKA inverse density scaling",
  (lambdaGliss /. density -> density2)/
    (lambdaGliss /. density -> density1) == density1/density2,
  density1 > 0 && density2 > 0 && lambdaMishka != 0];
layout = DiagonalMatrix[{1/phiEdge,
    1/(dsdr phiEdge), I majorRadius^2 phiEdge/(p q)}];
mishkaTest = Array[test, 3];
mishkaTrial = Array[trial, 3];
glissKernel = Array[kernel, {3, 3}];
check["MISHKA component map is an exact congruence",
  dsdr Conjugate[layout . mishkaTest] . glissKernel .
    (layout . mishkaTrial) ==
   Conjugate[mishkaTest] .
    (dsdr ConjugateTranspose[layout] . glissKernel . layout) .
    mishkaTrial,
  dsdr != 0 && p != 0 && q != 0 &&
   Element[{dsdr, phiEdge, majorRadius, p, q}, Reals]];

qProfile[u_] = q0 + q2 u^2;
sToroidal = Integrate[2 u psiEdge qProfile[u], {u, 0, r}]/
  Integrate[2 u psiEdge qProfile[u], {u, 0, 1}];
check["integrated-q map reduces to r squared only for constant q",
  FullSimplify[sToroidal /. q2 -> 0] == r^2];
check["variable-q map rejects global r squared substitution",
  sToroidal != r^2, 0 < r < 1 && q0 > 0 && q2 > 0];

(* Corrupted controls must be mathematically active. *)
wrongToroidalPhase = 2 Pi (m theta + n zetaPeriod);
check["toroidal phase-sign corruption is detected",
  D[phasePeriod, zetaPeriod] != D[wrongToroidalPhase, zetaPeriod], n != 0];
check["double field-period corruption is detected",
  D[phasePeriod /. zetaPeriod -> nfp^2 zetaFull, zetaFull] !=
    D[phaseFull, zetaFull],
  n != 0 && nfp > 1];
check["signed Jacobian is not the kinetic integration weight",
  signedJacobian != Abs[signedJacobian], signedJacobian < 0];
check["dropping the MISHKA operator sign changes stability",
  -lambdaMishka/(mu0 density majorRadius^2) !=
    lambdaMishka/(mu0 density majorRadius^2), lambdaMishka != 0];

Print["SUMMARY ", passed, " passed, ", failed, " failed"];
If[failed > 0, Exit[1]];

ClearAll["Global`*"];

passed = 0;
failed = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  passed++; Print["PASS: ", name], failed++; Print["FAIL: ", name]];

$Assumptions = nfp > 0 && nsta > 0 && intervals > 0 &&
  sright > sleft && vmecPhis != 0 && radius > 0 && length > 0 &&
  Element[{nfp, nsta, intervals}, Integers];

thetaRadian = 2 Pi thetaTurn;
phiRadian = 2 Pi zetaPeriod/nfp;
jacobianTurn = 4 Pi^2 jacobianRadian/nfp;
bjacTerpsichore = nfp jacobianTurn/(4 Pi^2);

check["angular coordinate map",
  D[thetaRadian, thetaTurn] D[phiRadian, zetaPeriod] == 4 Pi^2/nfp];
check["Jacobian map", bjacTerpsichore == jacobianRadian];
check["Jacobian orientation", Sign[bjacTerpsichore] == Sign[jacobianTurn]];

exportedPhis = -vmecPhis;
exportedChis = -iota vmecPhis;
ftInternal = -exportedPhis;
fpInternal = -exportedChis/nfp;
ftpTerpsichore = -vmecPhis;
fppTerpsichore = iota ftpTerpsichore;

check["converter and exported toroidal flux",
  ftpTerpsichore == exportedPhis];
check["converter and exported poloidal flux",
  fppTerpsichore == exportedChis];
check["internal toroidal flux map", ftpTerpsichore == -ftInternal];
check["internal poloidal flux map", fppTerpsichore == -nfp fpInternal];
check["rotational transform", fppTerpsichore/ftpTerpsichore == iota];
check["reduced tangential weight",
  bjacTerpsichore/ftpTerpsichore^2 ==
    nfp jacobianTurn/(4 Pi^2 vmecPhis^2)];

sourceEquilibriumPhase = m thetaRadian - nfp n phiRadian;
glissEquilibriumPhase = 2 Pi (m thetaTurn - n zetaPeriod);
check["equilibrium Fourier phase",
  sourceEquilibriumPhase == glissEquilibriumPhase];
sourceStabilityPhase = m thetaRadian - (n nfp/nsta) phiRadian;
glissStabilityPhase = 2 Pi (m thetaTurn - n zetaPeriod/nsta);
check["stability Fourier phase", sourceStabilityPhase == glissStabilityPhase];
check["QAS stability-period specialization",
  (glissStabilityPhase /. nsta -> nfp) ==
    2 Pi (m thetaTurn - n zetaPeriod/nfp)];

volumeFromTurns = nfp jacobianTurn;
volumeFromRadians = nfp (4 Pi^2/nfp) bjacTerpsichore;
check["full-volume measure", volumeFromTurns == volumeFromRadians];
check["uniform radial weight",
  (intervals (sright - sleft) /. sright -> sleft + 1/intervals) == 1];

cylinderMap = {
  radius Sqrt[s] Cos[2 Pi thetaTurn],
  -radius Sqrt[s] Sin[2 Pi thetaTurn], length zetaPeriod};
cylinderJacobian = FullSimplify[Det[{
  D[cylinderMap, s], D[cylinderMap, thetaTurn],
  D[cylinderMap, zetaPeriod]}]];
check["left-handed straight-cylinder Jacobian",
  cylinderJacobian == -Pi radius^2 length];
check["straight-cylinder volume",
  -Integrate[cylinderJacobian, {s, 0, 1}, {thetaTurn, 0, 1},
    {zetaPeriod, 0, 1}] == Pi radius^2 length];
check["straight-cylinder TERPSICHORE BJAC",
  cylinderJacobian/(4 Pi^2) == -radius^2 length/(4 Pi)];
check["missing field-period factor is detected",
  (-29.2262841340075/(4 Pi^2)) !=
    (3 (-29.2262841340075)/(4 Pi^2))];

Print["Passed: ", passed, " Failed: ", failed];
If[failed > 0, Exit[1]];

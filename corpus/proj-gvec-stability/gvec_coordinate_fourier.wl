ClearAll["Global`*"];
passCount = 0;
failCount = 0;
expect[name_, condition_] := If[TrueQ[condition],
  passCount += 1; Print["PASS  ", name],
  failCount += 1; Print["FAIL  ", name]];

s = rho^2;
theta = -sigma thetaB/(2 Pi);
zetaFull = sigma zetaB/(2 Pi);
zetaPeriod = nfp zetaFull;
coordinateJacobian =
  Det[Outer[D, {s, theta, zetaFull}, {rho, thetaB, zetaB}]];

expect["radial flux map", (s /. rho -> 1/2) == 1/4];
expect["coordinate handedness",
  FullSimplify[coordinateJacobian == -rho/(2 Pi^2),
    Assumptions -> {rho > 0, Element[sigma, Integers], sigma^2 == 1}]];
expect["orientation independence",
  FullSimplify[
    (coordinateJacobian /. sigma -> 1) ==
      (coordinateJacobian /. sigma -> -1)]];
expect["one-period coordinate conversion",
  FullSimplify[zetaPeriod/nfp == zetaFull, Assumptions -> nfp > 0]];

phase = 2 Pi (m thetaC - n nfp zetaC);
periodPhase = 2 Pi (m thetaC - n zetaPeriodC);
basis = cosineCoefficient Cos[phase] + sineCoefficient Sin[phase];
phaseDerivative =
  -cosineCoefficient Sin[phase] + sineCoefficient Cos[phase];
expect["poloidal derivative",
  FullSimplify[D[basis, thetaC] == 2 Pi m phaseDerivative]];
expect["toroidal derivative",
  FullSimplify[D[basis, zetaC] == -2 Pi n nfp phaseDerivative]];
expect["field-period periodicity",
  FullSimplify[
    TrigExpand[(basis /. zetaC -> zetaC + 1/nfp) - basis] == 0,
    Assumptions -> {Element[n, Integers], nfp > 0}]];
expect["export-period Fourier equivalence",
  FullSimplify[
    (periodPhase /. zetaPeriodC -> nfp zetaC) == phase]];

sHalf[k_, ns_] = (2 k + 1)/(2 ns);
expect["half-mesh first point",
  FullSimplify[sHalf[0, ns] == 1/(2 ns), Assumptions -> ns > 0]];
expect["half-mesh last point",
  FullSimplify[sHalf[ns - 1, ns] == 1 - 1/(2 ns),
    Assumptions -> ns > 0]];
expect["half-mesh spacing",
  FullSimplify[sHalf[k + 1, ns] - sHalf[k, ns] == 1/ns,
    Assumptions -> ns > 0]];

fixture = {
  {m -> 0, n -> 0, cosineCoefficient -> 2,
    sineCoefficient -> 0},
  {m -> 1, n -> 1, cosineCoefficient -> 3,
    sineCoefficient -> 5},
  {m -> 2, n -> -1, cosineCoefficient -> 4,
    sineCoefficient -> 6}};
fixtureBasis = Total[basis /. fixture] /.
  {thetaC -> 1/8, zetaC -> 1/40, nfp -> 5};
expect["analytical Fourier fixture",
  FullSimplify[fixtureBasis == 5 + Sqrt[2]]];

Print["SUMMARY ", passCount, " passed, ", failCount, " failed"];
If[failCount > 0, Quit[1], Quit[0]];

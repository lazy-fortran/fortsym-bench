ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

k = {kx, ky, kz};
b = {bx, by, bz};
n = {nx, ny, nz};
induction = (b.k) IdentityMatrix[3] - Outer[Times, b, k];
stiffness = Transpose[induction].induction/mu0 +
  gamma pressure Outer[Times, k, k] - drive Outer[Times, n, n];

check["stiffness is symmetric", stiffness == Transpose[stiffness]];
xi = {x1, x2, x3};
qFromCross = Cross[k, Cross[xi, b]];
check["plane-wave induction identity", qFromCross == induction.xi];

special = FullSimplify[stiffness /. {
    kx -> 0, ky -> 0, kz -> kpar,
    bx -> 0, by -> 0, bz -> b0,
    nx -> 1, ny -> 0, nz -> 0}];
expected = DiagonalMatrix[{
    b0^2 kpar^2/mu0 - drive,
    b0^2 kpar^2/mu0,
    gamma pressure kpar^2}];
check["field-aligned stiffness", special == expected];

characteristic = Factor[Det[special - density omega2 IdentityMatrix[3]]];
expectedCharacteristic = Product[expected[[i, i]] - density omega2, {i, 3}];
check["analytic generalized spectrum",
  characteristic == expectedCharacteristic];
check["normal mode is marginal at magnetic tension",
  Det[special /. drive -> b0^2 kpar^2/mu0] == 0];
check["drive above magnetic tension is unstable",
  FullSimplify[
    (special[[1, 1]] /. drive -> b0^2 kpar^2/mu0 + delta)/density < 0,
    {b0 > 0, kpar > 0, mu0 > 0, density > 0, delta > 0}]];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

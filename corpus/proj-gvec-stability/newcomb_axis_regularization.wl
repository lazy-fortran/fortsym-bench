ClearAll["Global`*"];

passed = 0;
failed = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  passed++; Print["PASS: ", name], failed++; Print["FAIL: ", name]];

$Assumptions = radius > 0 && coefficient > 0 &&
  Element[mode, Integers] && mode >= 0;

cartesianPlusPower[mode_] := Abs[mode + 1];
cartesianMinusPower[mode_] := Abs[mode - 1];
radialPower[mode_] := Min[cartesianPlusPower[mode],
  cartesianMinusPower[mode]];

check["axisymmetric radial displacement vanishes linearly",
  radialPower[0] == 1];
check["unit harmonic admits finite radial displacement",
  radialPower[1] == 0];
check["higher harmonics vanish with Cartesian power",
  And @@ Table[radialPower[m] == m - 1, {m, 2, 8}]];

fNonzeroMode = coefficient radius^3;
gNonzeroMode = coefficient (mode^2 - 1) radius;
nonzeroIndicial = Factor[
  -D[fNonzeroMode D[radius^nu, radius], radius] +
    gNonzeroMode radius^nu];
check["nonzero-mode indicial polynomial",
  nonzeroIndicial/(coefficient radius^(nu + 1)) ==
    mode^2 - 1 - nu (nu + 2)];
check["nonzero-mode Newcomb roots",
  And @@ Thread[(mode^2 - 1 - nu (nu + 2) /.
      nu -> {-1 - mode, -1 + mode}) == 0]];
check["unit-harmonic regular root is constant",
  (-1 + mode /. mode -> 1) == 0];
check["higher-harmonic regular root matches Cartesian power",
  And @@ Table[(-1 + m) == radialPower[m], {m, 2, 8}]];
check["nonzero-mode coefficient ratio",
  radius^2 gNonzeroMode/fNonzeroMode == mode^2 - 1];

fAxisymmetric = coefficient radius;
gAxisymmetric = coefficient/radius;
axisymmetricIndicial = Factor[
  -D[fAxisymmetric D[radius^nu, radius], radius] +
    gAxisymmetric radius^nu];
axisymmetricRoots = nu /. Solve[axisymmetricIndicial == 0, nu, Reals];
check["axisymmetric Newcomb roots", Sort[axisymmetricRoots] == {-1, 1}];
check["axisymmetric coefficient ratio",
  radius^2 gAxisymmetric/fAxisymmetric == 1];

regularUnitMode = axisValue + curvature radius^2;
rawTraction = coefficient radius^3 D[regularUnitMode, radius] +
  crossCoefficient radius^2 regularUnitMode;
check["unit-harmonic natural traction vanishes",
  Block[{$Assumptions = True},
    Limit[rawTraction, radius -> 0, Direction -> "FromAbove"]] == 0];
check["axis Dirichlet would suppress the regular unit harmonic",
  (Block[{$Assumptions = True}, Limit[regularUnitMode, radius -> 0]] /.
      axisValue -> 1) != 0];

integrand = a[radius] xi[radius]^2 +
  2 b[radius] xi[radius] xi'[radius] +
  c[radius] xi'[radius]^2;
newcombIntegrand = (a[radius] - b'[radius]) xi[radius]^2 +
  c[radius] xi'[radius]^2;
check["cross-term integration by parts",
  Expand[integrand - newcombIntegrand - D[b[radius] xi[radius]^2, radius]] == 0];

thetaPinchC[r_] := 2 Pi^2 r^3/(1 + r^2);
manufacturedXi[r_] := 1 - r^2;
exactBendingEnergy = Integrate[
  thetaPinchC[r] manufacturedXi'[r]^2, {r, 0, 1}];
check["theta-pinch manufactured bending energy",
  exactBendingEnergy == 4 Pi^2 (-1/2 + Log[2])];

midpointEnergy[intervals_] := Sum[With[{
    left = (cell - 1)/intervals,
    right = cell/intervals,
    midpoint = (cell - 1/2)/intervals},
  thetaPinchC[midpoint]
    ((manufacturedXi[right] - manufacturedXi[left]) intervals)^2/intervals],
  {cell, 1, intervals}];
midpointErrors = N[Abs[midpointEnergy[#] - exactBendingEnergy] & /@
    {16, 32, 64}, 30];
check["theta-pinch midpoint error decreases",
  And @@ Thread[Rest[midpointErrors] < Most[midpointErrors]]];
check["theta-pinch midpoint rule is second order",
  And @@ Thread[Most[midpointErrors]/Rest[midpointErrors] > 3.8]];
check["corrupted line-bending denominator is detected",
  Integrate[2 Pi^2 r^3 manufacturedXi'[r]^2, {r, 0, 1}] !=
    exactBendingEnergy];

Print["Passed: ", passed, " Failed: ", failed];
If[failed > 0, Exit[1]];

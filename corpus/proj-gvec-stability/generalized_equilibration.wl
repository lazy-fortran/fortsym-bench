ClearAll["Global`*"];
$Assumptions = Element[{k11, k12, k22, m11, m12, m22, lambda,
    d1, d2, e1, e2, y1, y2}, Reals] && d1 > 0 && d2 > 0 &&
  e1 > 0 && e2 > 0 && k11 != 0 && m11 > 0 &&
  m11 m22 - m12^2 > 0;
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

stiffness = {{k11, k12}, {k12, k22}};
mass = {{m11, m12}, {m12, m22}};
scale = DiagonalMatrix[{d1, d2}];
balancedStiffness = scale.stiffness.scale;
balancedMass = scale.mass.scale;

check["stiffness congruence remains symmetric",
  balancedStiffness == Transpose[balancedStiffness]];
check["mass congruence remains symmetric",
  balancedMass == Transpose[balancedMass]];
check["generalized characteristic polynomial changes only by det(D)^2",
  Det[balancedStiffness - lambda balancedMass] ==
    Det[scale]^2 Det[stiffness - lambda mass]];

stiffnessPivots = {stiffness[[1, 1]],
  Det[stiffness]/stiffness[[1, 1]]};
balancedStiffnessPivots = {balancedStiffness[[1, 1]],
  Det[balancedStiffness]/balancedStiffness[[1, 1]]};
check["LDL pivots scale by positive squares",
  balancedStiffnessPivots ==
    {d1^2 stiffnessPivots[[1]], d2^2 stiffnessPivots[[2]]}];
check["LDL pivot signs and nonsingular inertia are invariant",
  Sign[balancedStiffnessPivots] == Sign[stiffnessPivots]];

check["positive mass first principal minor remains positive",
  balancedMass[[1, 1]] > 0];
check["positive mass determinant remains positive",
  Det[balancedMass] > 0];

balancedVector = {y1, y2};
originalVector = scale.balancedVector;
check["balanced residual is the scaled original residual",
  balancedStiffness.balancedVector -
    lambda balancedMass.balancedVector ==
    scale.(stiffness.originalVector - lambda mass.originalVector)];
check["back transformation recovers the original residual",
  Inverse[scale].(balancedStiffness.balancedVector -
      lambda balancedMass.balancedVector) ==
    stiffness.originalVector - lambda mass.originalVector];
check["mass norm is invariant under back transformation",
  balancedVector.balancedMass.balancedVector ==
    originalVector.mass.originalVector];
check["Rayleigh quotient is invariant under back transformation",
  (balancedVector.balancedStiffness.balancedVector)/
      (balancedVector.balancedMass.balancedVector) ==
    (originalVector.stiffness.originalVector)/
      (originalVector.mass.originalVector)];

nextScale = DiagonalMatrix[{e1, e2}];
check["successive diagonal congruences compose elementwise",
  nextScale.balancedStiffness.nextScale ==
    (scale.nextScale).stiffness.(scale.nextScale)];

tridiagonal = {{k11, k12, 0}, {k12, k22, m12}, {0, m12, m22}};
tridiagonalScale = DiagonalMatrix[{d1, d2, e1}];
check["diagonal congruence preserves a structural zero",
  (tridiagonalScale.tridiagonal.tridiagonalScale)[[1, 3]] == 0];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

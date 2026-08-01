ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

$Assumptions = Element[{x1, x2, x3, scale, c, epsilon}, Reals] &&
  scale > 0 && c != 0 && epsilon > 0;

values = {x1, x2, x3};
scaled = values/scale;
check["scaled norm is the original Euclidean norm",
  scale Sqrt[scaled.scaled] == Sqrt[values.values]];
check["scaled norm is homogeneous",
  Abs[c] Sqrt[values.values] == Sqrt[(c values).(c values)]];
check["three-four-five fixture is exact",
  Sqrt[{3/5, 4/5}.{3/5, 4/5}] == 1];

updated = first + term;
firstCorrection = (first - updated) + term;
secondCorrection = (term - updated) + first;
check["Neumaier first branch restores the exact sum algebraically",
  updated + firstCorrection == first + term];
check["Neumaier second branch restores the exact sum algebraically",
  updated + secondCorrection == first + term];

$Assumptions = Element[{terms, dimension}, Integers] && terms >= 1 &&
  dimension >= 1 && epsilon > 0;
firstOrderBudget = (6 terms + 48) epsilon;
secondOrderBudget = 16 dimension epsilon^2;
rawBound = firstOrderBudget + secondOrderBudget;
resolutionFactor = rawBound/(1 - rawBound);

check["operation budget covers shifted action and mass action",
  6 terms + 48 >= 4 terms + 32];
check["second-order compensated reduction allowance is positive",
  secondOrderBudget > 0];
check["raw bound grows with row term count",
  FullSimplify[D[(6 t + 48) epsilon + 16 n epsilon^2, t] > 0,
    Assumptions -> t >= 1 && n >= 1]];
check["raw bound grows with vector dimension",
  FullSimplify[D[(6 t + 48) epsilon + 16 n epsilon^2, n] > 0,
    Assumptions -> t >= 1 && n >= 1]];
check["denominator correction exceeds the raw bound",
  FullSimplify[resolutionFactor >= rawBound,
    Assumptions -> rawBound < 1]];
check["resolution factor is finite in the admitted range",
  FullSimplify[0 < resolutionFactor < Infinity,
    Assumptions -> rawBound < 1]];

$Assumptions = Element[{k11, k12, k22, m11, m12, m22, lambda,
     y1, y2, c, epsilon}, Reals] && Element[{terms, dimension}, Integers] &&
  terms >= 1 && dimension >= 1 && epsilon > 0 && rawBound < 1 &&
  k11 >= 0 && k12 >= 0 && k22 >= 0 &&
  m11 > 0 && m12 >= 0 && m22 > 0 && lambda >= 0 && y1 > 0 &&
  y2 > 0 && c > 0;
absolutePencil = {{k11, k12}, {k12, k22}} +
  lambda {{m11, m12}, {m12, m22}};
mass = {{m11, m12}, {m12, m22}};
vector = {y1, y2};
ratio[v_] := Sqrt[(absolutePencil.v).(absolutePencil.v)]/
  Sqrt[(mass.v).(mass.v)];
check["absolute-action to mass-action ratio is vector-scale invariant",
  ratio[c vector] == ratio[vector]];
check["resolution is nonnegative",
  resolutionFactor ratio[vector] >= 0];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

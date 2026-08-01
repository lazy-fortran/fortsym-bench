ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

knots = {0, 0, 0, 1/2, 1, 1, 1};
basis = Table[BSplineBasis[{2, knots}, index, x], {index, 0, 3}];
derivative = D[basis, x];

check["quadratic basis fixture",
  (basis /. x -> 1/4) == {1/4, 5/8, 1/8, 0}];
check["quadratic derivative fixture",
  (derivative /. x -> 1/4) == {-2, 1, 1, 0}];
check["partition of unity",
  FullSimplify[Total[basis] == 1, 0 < x < 1]];
check["derivative partition",
  FullSimplify[Total[derivative] == 0, 0 < x < 1]];
check["axis endpoint interpolation",
  (basis /. x -> 0) == {1, 0, 0, 0}];
check["boundary endpoint interpolation",
  (basis /. x -> 1) == {0, 0, 0, 1}];
check["boundary derivative from plasma side",
  Limit[derivative, x -> 1, Direction -> "FromBelow"] == {0, 0, -4, 4}];
check["fixed-boundary elimination",
  Most[basis /. x -> 1] == {0, 0, 0}];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

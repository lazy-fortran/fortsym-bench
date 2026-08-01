ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

segment[x_, xLeft_, xRight_, yLeft_, yRight_, mLeft_, mRight_] :=
  Module[{h = xRight - xLeft, left = x - xLeft,
    right = xRight - x},
   mLeft right^3/(6 h) + mRight left^3/(6 h) +
    (yLeft - mLeft h^2/6) right/h +
    (yRight - mRight h^2/6) left/h];

assumptions = h1 > 0 && h2 > 0 && h3 > 0;
x0 = 0; x1 = h1; x2 = h1 + h2; x3 = h1 + h2 + h3;
left = segment[x, x0, x1, y0, y1, m0, m1];
right = segment[x, x1, x2, y1, y2, m1, m2];

check["left endpoint interpolation",
 FullSimplify[(left /. x -> x0) == y0, assumptions]];
check["right endpoint interpolation",
 FullSimplify[(left /. x -> x1) == y1, assumptions]];
check["left endpoint second derivative",
 FullSimplify[(D[left, {x, 2}] /. x -> x0) == m0, assumptions]];
check["right endpoint second derivative",
 FullSimplify[(D[left, {x, 2}] /. x -> x1) == m1, assumptions]];
check["second derivative evaluator",
 FullSimplify[D[left, {x, 2}] ==
   (m0 (x1 - x) + m1 (x - x0))/h1, assumptions]];
check["second derivative continuity",
 FullSimplify[(D[left, {x, 2}] - D[right, {x, 2}] /. x -> x1) == 0,
  assumptions]];

interiorEquation =
  h1 m0 + 2 (h1 + h2) m1 + h2 m2 ==
   6 ((y2 - y1)/h2 - (y1 - y0)/h1);
check["first derivative continuity equation",
 FullSimplify[(D[left, x] - D[right, x] /. x -> x1) == 0,
  assumptions && interiorEquation]];

notAKnotResidual = -h2 m0 + (h1 + h2) m1 - h1 m2;
check["not-a-knot is third derivative continuity",
 FullSimplify[(D[left, {x, 3}] - D[right, {x, 3}] /. x -> x1) ==
   notAKnotResidual/(h1 h2), assumptions]];

m0Eliminated = ((h1 + h2) m1 - h1 m2)/h2;
reducedFirst = (h1 + h2) (2 + h1/h2) m1 +
  (h2 - h1^2/h2) m2;
check["left not-a-knot elimination",
 FullSimplify[(notAKnotResidual /. m0 -> m0Eliminated) == 0,
  assumptions]];
check["first reduced spline row",
 FullSimplify[(h1 m0 + 2 (h1 + h2) m1 + h2 m2 /. m0 ->
      m0Eliminated) == reducedFirst, assumptions]];

m3Eliminated = ((h2 + h3) m2 - h3 m1)/h2;
reducedLast = (h2 - h3^2/h2) m1 +
  (h2 + h3) (2 + h3/h2) m2;
check["right not-a-knot elimination",
 FullSimplify[(-h3 m1 + (h2 + h3) m2 - h2 m3 /. m3 ->
     m3Eliminated) == 0, assumptions]];
check["last reduced spline row",
 FullSimplify[(h2 m1 + 2 (h2 + h3) m2 + h3 m3 /. m3 ->
      m3Eliminated) == reducedLast, assumptions]];

polynomial[t_] = a0 + a1 t + a2 t^2 + a3 t^3;
points = {x0, x1, x2, x3};
values = polynomial /@ points;
second = (D[polynomial[t], {t, 2}] /. t -> #) & /@ points;
pieces = Table[
   segment[x, points[[i]], points[[i + 1]], values[[i]],
    values[[i + 1]], second[[i]], second[[i + 1]]], {i, 1, 3}];
check["all cubic pieces reproduce the polynomial",
 FullSimplify[And @@ Thread[pieces == polynomial[x]], assumptions]];
check["cubic data satisfy interior equations",
 FullSimplify[
  And @@ Table[
    (points[[i]] - points[[i - 1]]) second[[i - 1]] +
      2 (points[[i + 1]] - points[[i - 1]]) second[[i]] +
      (points[[i + 1]] - points[[i]]) second[[i + 1]] ==
     6 ((values[[i + 1]] - values[[i]])/
         (points[[i + 1]] - points[[i]]) -
       (values[[i]] - values[[i - 1]])/
         (points[[i]] - points[[i - 1]])), {i, 2, 3}], assumptions]];
check["cubic data satisfy both not-a-knot constraints",
 FullSimplify[
  (second[[2]] - second[[1]])/h1 ==
    (second[[3]] - second[[2]])/h2 &&
   (second[[3]] - second[[2]])/h2 ==
    (second[[4]] - second[[3]])/h3, assumptions]];
check["half-grid extrapolation retains cubic value and slope",
 FullSimplify[
  pieces[[1]] == polynomial[x] && D[pieces[[1]], x] == D[polynomial[x], x] &&
   pieces[[-1]] == polynomial[x] && D[pieces[[-1]], x] == D[polynomial[x], x],
  assumptions]];

fixtureNodes = {1/25, 17/100, 9/25, 29/50, 79/100, 24/25};
fixtureValues = {1, -2, 3, 1/2, -1, 2};
fixtureIntervals = Differences[fixtureNodes];
fixtureSecond = Array[fixtureM, Length[fixtureNodes]];
fixtureInterior = Table[
   fixtureIntervals[[i - 1]] fixtureSecond[[i - 1]] +
     2 (fixtureIntervals[[i - 1]] + fixtureIntervals[[i]])
       fixtureSecond[[i]] + fixtureIntervals[[i]] fixtureSecond[[i + 1]] ==
    6 ((fixtureValues[[i + 1]] - fixtureValues[[i]])/
        fixtureIntervals[[i]] -
      (fixtureValues[[i]] - fixtureValues[[i - 1]])/
        fixtureIntervals[[i - 1]]),
   {i, 2, Length[fixtureNodes] - 1}];
fixtureNotAKnot = {
   (fixtureSecond[[2]] - fixtureSecond[[1]])/fixtureIntervals[[1]] ==
    (fixtureSecond[[3]] - fixtureSecond[[2]])/fixtureIntervals[[2]],
   (fixtureSecond[[-2]] - fixtureSecond[[-3]])/fixtureIntervals[[-2]] ==
    (fixtureSecond[[-1]] - fixtureSecond[[-2]])/fixtureIntervals[[-1]]};
fixtureSolution = First[Solve[Join[fixtureInterior, fixtureNotAKnot],
    fixtureSecond]];
fixtureSegment[t_, interval_Integer] := segment[t,
   fixtureNodes[[interval]], fixtureNodes[[interval + 1]],
   fixtureValues[[interval]], fixtureValues[[interval + 1]],
   fixtureSecond[[interval]], fixtureSecond[[interval + 1]]] /.
  fixtureSolution;
fixtureResults = {
   {fixtureSegment[0, 1], D[fixtureSegment[t, 1], t] /. t -> 0},
   {fixtureSegment[1/2, 3], D[fixtureSegment[t, 3], t] /. t -> 1/2},
   {fixtureSegment[1, 5], D[fixtureSegment[t, 5], t] /. t -> 1}};
check["rational nonpolynomial fixture solves every spline equation",
 And @@ (Join[fixtureInterior, fixtureNotAKnot] /. fixtureSolution)];
Print["fixture results = ", N[fixtureResults, 18]];

lower2 = sub2/diag1;
factored2 = diag2 - lower2 super1;
lower3 = sub3/factored2;
factored3 = diag3 - lower3 super2;
lowerMatrix = {{1, 0, 0}, {lower2, 1, 0}, {0, lower3, 1}};
upperMatrix = {{diag1, super1, 0}, {0, factored2, super2},
  {0, 0, factored3}};
tridiagonal = {{diag1, super1, 0}, {sub2, diag2, super2},
  {0, sub3, diag3}};
check["Thomas factorization reconstructs the tridiagonal system",
 FullSimplify[lowerMatrix . upperMatrix == tridiagonal,
  diag1 != 0 && factored2 != 0]];

solveFactored[rhs_] := LinearSolve[upperMatrix,
  LinearSolve[lowerMatrix, rhs]];
rhsA = {rA1, rA2, rA3};
rhsB = {rB1, rB2, rB3};
check["factored solve is linear across right-hand sides",
 FullSimplify[
  solveFactored[alpha rhsA + beta rhsB] ==
   alpha solveFactored[rhsA] + beta solveFactored[rhsB],
  diag1 != 0 && factored2 != 0 && factored3 != 0]];

segmentJet[yLeft_, yRight_, mLeft_, mRight_] :=
  {segment[x, x0, x1, yLeft, yRight, mLeft, mRight],
   D[segment[x, x0, x1, yLeft, yRight, mLeft, mRight], x],
   D[segment[x, x0, x1, yLeft, yRight, mLeft, mRight], {x, 2}]};
jetA = segmentJet[yA0, yA1, mA0, mA1];
jetB = segmentJet[yB0, yB1, mB0, mB1];
check["value and derivative evaluation are linear across fields",
 FullSimplify[
  segmentJet[alpha yA0 + beta yB0, alpha yA1 + beta yB1,
    alpha mA0 + beta mB0, alpha mA1 + beta mB1] ==
   alpha jetA + beta jetB, h1 > 0]];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

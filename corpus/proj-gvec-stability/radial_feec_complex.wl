ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

openKnots[breaks_, degree_] := Join[
  ConstantArray[First[breaks], degree + 1],
  Flatten[ConstantArray[#, degree] & /@ Rest[Most[breaks]]],
  ConstantArray[Last[breaks], degree + 1]];

incidence[knots_, degree_] := Module[
  {h1Count = Length[knots] - degree - 1, map, column, denominator},
  map = ConstantArray[0, {h1Count - 1, h1Count}];
  Do[
   If[column > 1,
    denominator = knots[[column + degree]] - knots[[column]];
    map[[column - 1, column]] = degree/denominator];
   If[column < h1Count,
    denominator = knots[[column + degree + 1]] - knots[[column + 1]];
    map[[column, column]] = -degree/denominator],
   {column, 1, h1Count}];
  map];

breaks = {0, 1/4, 2/3, 1};
Do[
 h1Knots = openKnots[breaks, degree];
 l2Knots = Rest[Most[h1Knots]];
 h1Count = Length[h1Knots] - degree - 1;
 l2Count = Length[l2Knots] - (degree - 1) - 1;
 h1Basis = Table[BSplineBasis[{degree, h1Knots}, i, x],
   {i, 0, h1Count - 1}];
 l2Basis = Table[BSplineBasis[{degree - 1, l2Knots}, i, x],
   {i, 0, l2Count - 1}];
 derivativeMap = incidence[h1Knots, degree];
 check["degree " <> ToString[degree] <> " C0 H1 dimension",
  h1Count == degree (Length[breaks] - 1) + 1];
 check["degree " <> ToString[degree] <> " discontinuous L2 dimension",
  l2Count == degree (Length[breaks] - 1)];
 derivativeSamples = Flatten[Table[
    breaks[[span]] + sample (breaks[[span + 1]] - breaks[[span]])/
      (degree + 1), {span, 1, Length[breaks] - 1},
    {sample, 1, degree}]];
 partitionSamples = Flatten[Table[
    breaks[[span]] + sample (breaks[[span + 1]] - breaks[[span]])/
      (degree + 2), {span, 1, Length[breaks] - 1},
    {sample, 1, degree + 1}]];
 derivativeRepresentation = Transpose[derivativeMap] . l2Basis;
 check["degree " <> ToString[degree] <> " derivative commutation",
  And @@ Flatten[Table[
     FullSimplify[(D[h1Basis[[basis]], x] -
          derivativeRepresentation[[basis]]) /. x -> point] == 0,
     {basis, 1, h1Count}, {point, derivativeSamples}]]];
 check["degree " <> ToString[degree] <> " H1 partition",
  And @@ Table[FullSimplify[Total[h1Basis] /. x -> point] == 1,
    {point, partitionSamples}]];
 check["degree " <> ToString[degree] <> " L2 partition",
  And @@ Table[FullSimplify[Total[l2Basis] /. x -> point] == 1,
    {point, partitionSamples}]];
 check["degree " <> ToString[degree] <> " exact sequence rank",
  MatrixRank[derivativeMap] == l2Count &&
   derivativeMap . ConstantArray[1, h1Count] ==
    ConstantArray[0, l2Count] && Length[NullSpace[derivativeMap]] == 1];
 fixedMap = derivativeMap[[All, 2 ;; h1Count - 1]];
 check["degree " <> ToString[degree] <> " fixed-trace rank",
  MatrixRank[fixedMap] == h1Count - 2 &&
   Length[NullSpace[fixedMap]] == 0];
 leftTrace = h1Basis /. x -> First[breaks];
 rightTrace = h1Basis /. x -> Last[breaks];
 check["degree " <> ToString[degree] <> " endpoint traces",
  leftTrace == UnitVector[h1Count, 1] &&
   rightTrace == UnitVector[h1Count, h1Count]];
 l2IntegralWeights = Table[
   (l2Knots[[basis + degree]] - l2Knots[[basis]])/degree,
   {basis, 1, l2Count}];
 check["degree " <> ToString[degree] <> " discrete fundamental theorem",
  FullSimplify[l2IntegralWeights . derivativeMap == rightTrace - leftTrace]];
 gaussNodesLocal =
  Sort[x /. Solve[LegendreP[degree, x] == 0, x, Reals]];
 mappedNodes = (breaks[[2]] - breaks[[1]]) (gaussNodesLocal + 1)/2 +
   breaks[[1]];
 midpoint = (breaks[[1]] + breaks[[2]])/2;
 activeL2 = Select[Range[l2Count],
   FullSimplify[l2Basis[[#]] /. x -> midpoint] != 0 &];
 collocation = Table[l2Basis[[basis]] /. x -> point,
   {point, mappedNodes}, {basis, activeL2}];
 check["degree " <> ToString[degree] <> " local DG basis count",
  Length[activeL2] == degree];
 check["degree " <> ToString[degree] <> " Gauss-node DG unisolvence",
  Abs[N[Det[collocation], 50]] > 10^-40],
 {degree, 1, 4}];

check["polynomial unisolvence justifies derivative identity",
 And @@ Table[
   samplePoints = Table[j/(degree + 1), {j, 1, degree}];
   Det[Table[samplePoints[[row]]^(column - 1),
      {row, 1, degree}, {column, 1, degree}]] != 0,
   {degree, 1, 4}]];

check["matched constraint quadrature is locally cancellable",
 And @@ Table[
   nodes = Sort[x /. Solve[LegendreP[degree, x] == 0, x, Reals]];
   values = Array[source, degree];
   vandermonde = Table[If[column == 1, 1, nodes[[row]]^(column - 1)],
     {row, 1, degree}, {column, 1, degree}];
   FullSimplify[vandermonde . LinearSolve[vandermonde, -values] +
      values == ConstantArray[0, degree]],
   {degree, 1, 4}]];

$Assumptions = Element[{s, power}, Reals] && s > 0;
storedField = s^-power field[s];
check["stored normal-power pullback derivative",
 FullSimplify[D[storedField, s] ==
   s^-power (field'[s] - power field[s]/s)]];

storedAxisField = s axisAmplitude[s];
physicalAxisField = s^-(1 - m/2) storedAxisField;
check["stored axis trace reconstructs Cartesian harmonic power",
 FullSimplify[physicalAxisField == s^(m/2) axisAmplitude[s],
  Element[m, Integers] && m >= 0]];
check["m one physical normal derivative has the expected singular power",
 FullSimplify[D[physicalAxisField /. m -> 1, s] ==
   axisAmplitude[s]/(2 Sqrt[s]) + Sqrt[s] axisAmplitude'[s], s > 0]];

gaussNodes = x /. Solve[LegendreP[5, x] == 0, x, Reals];
gaussWeights = Table[
  2/((1 - node^2) (D[LegendreP[5, x], x] /. x -> node)^2),
  {node, gaussNodes}];
powerValues[0] := ConstantArray[1, Length[gaussNodes]];
powerValues[order_Integer?Positive] := gaussNodes^order;
check["five-point Gauss weights are positive",
 And @@ Thread[gaussWeights > 0]];
check["five-point Gauss rule is exact through degree nine",
 And @@ Table[FullSimplify[gaussWeights . powerValues[order] ==
     Integrate[x^order, {x, -1, 1}]], {order, 0, 9}]];
check["degree-four H1 products fit the Gauss exactness degree",
 2 4 <= 9];
check["degree-three L2 products fit the Gauss exactness degree",
 2 3 <= 9];

kernelRows = Array[row, {4, 5}];
energySigns = DiagonalMatrix[{1, 1, 1, -drive}];
pointMatrix = Transpose[kernelRows] . energySigns . kernelRows;
check["generic point stiffness is self-adjoint",
 Transpose[pointMatrix] == pointMatrix];
normalValues = Array[h, 3];
tangentialValues = Array[l, 2];
normalCoefficients = Array[u, 3];
tangentialCoefficients = Array[v, 2];
massDensity = (normalValues . normalCoefficients)^2 +
  (tangentialValues . tangentialCoefficients)^2;
check["compatible artificial mass density is nonnegative",
 FullSimplify[massDensity >= 0,
  Element[Join[normalValues, tangentialValues, normalCoefficients,
    tangentialCoefficients], Reals]]];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

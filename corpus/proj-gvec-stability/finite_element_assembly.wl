ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

basis = {1 - x/h, x/h};
elementMass = Table[Integrate[basis[[i]] basis[[j]], {x, 0, h}], {i, 2}, {j, 2}];
elementStiffness = Table[
  Integrate[D[basis[[i]], x] D[basis[[j]], x], {x, 0, h}],
  {i, 2}, {j, 2}];

check["element mass formula",
  elementMass == h {{2, 1}, {1, 2}}/6];
check["element stiffness formula",
  elementStiffness == {{1, -1}, {-1, 1}}/h];
check["element matrices are symmetric",
  elementMass == Transpose[elementMass] &&
    elementStiffness == Transpose[elementStiffness]];
check["element mass is positive definite",
  FullSimplify[And @@ Thread[Eigenvalues[elementMass] > 0], h > 0]];

globalMass = ConstantArray[0, {3, 3}];
globalStiffness = ConstantArray[0, {3, 3}];
Do[
  nodes = {element, element + 1};
  Do[
    globalMass[[nodes[[i]], nodes[[j]]]] += elementMass[[i, j]];
    globalStiffness[[nodes[[i]], nodes[[j]]]] += elementStiffness[[i, j]],
    {i, 2}, {j, 2}],
  {element, 2}];

fixedMass = globalMass[[{2}, {2}]];
fixedStiffness = globalStiffness[[{2}, {2}]];
check["assembled matrices are symmetric",
  globalMass == Transpose[globalMass] &&
    globalStiffness == Transpose[globalStiffness]];
check["fixed-boundary mass is positive",
  FullSimplify[fixedMass[[1, 1]] > 0, h > 0]];
check["fixed-boundary stiffness is positive",
  FullSimplify[fixedStiffness[[1, 1]] > 0, h > 0]];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

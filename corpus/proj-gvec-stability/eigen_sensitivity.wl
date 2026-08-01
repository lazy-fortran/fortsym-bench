ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];
checkApprox[name_, left_, right_, tolerance_: 10^-8] :=
  If[Abs[N[left - right]] < tolerance,
    pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

stiffness[p_] := {{2 + p, 1/5}, {1/5, 4 - p}};
mass[p_] := {{2 + p/10, 0}, {0, 3}};
eigensystem[p_?NumericQ] := Module[{values, vectors, order, vector},
  {values, vectors} = Eigensystem[{N[stiffness[p]], N[mass[p]]}];
  order = Ordering[values];
  vector = vectors[[order[[1]]]];
  vector = vector/Sqrt[vector.N[mass[p]].vector];
  {values[[order[[1]]]], vector}];

p0 = 1/3;
{lambda0, vector0} = eigensystem[N[p0]];
stiffnessDerivative = D[stiffness[p], p] /. p -> p0;
massDerivative = D[mass[p], p] /. p -> p0;
analytic = vector0.(stiffnessDerivative - lambda0 massDerivative).vector0;
step = 10^-5;
finiteDifference = (First[eigensystem[N[p0 + step]]] -
    First[eigensystem[N[p0 - step]]])/(2 step);

checkApprox["simple eigenvalue derivative", analytic, finiteDifference, 10^-8];
checkApprox["mass normalization", vector0.N[mass[p0]].vector0, 1, 10^-12];
check["eigenvalue is simple",
  Abs[Subtract @@ Eigenvalues[{stiffness[p0], mass[p0]}]] > 0];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

plasma = {{p11, p12}, {p12, p22}};
vacuum = {{v11, v12}, {v12, v22}};
coupling = {{c11, c12}, {c21, c22}};
xp = {x1, x2};
xv = {y1, y2};
energy = 1/2 xp.plasma.xp + xp.coupling.xv + 1/2 xv.vacuum.xv;
stationaryVacuum = -Inverse[vacuum].Transpose[coupling].xp;
reducedEnergy = FullSimplify[energy /. Thread[xv -> stationaryVacuum]];
effective = FullSimplify[plasma - coupling.Inverse[vacuum].Transpose[coupling]];

check["vacuum stationary point",
  FullSimplify[D[energy, {xv}] /. Thread[xv -> stationaryVacuum]] == {0, 0}];
check["Schur energy",
  reducedEnergy == FullSimplify[1/2 xp.effective.xp]];
check["effective plasma operator is symmetric",
  effective == Transpose[effective]];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

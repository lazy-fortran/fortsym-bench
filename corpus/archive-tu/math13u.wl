steps1[x_] := Mod[Floor[x + 1], 2]; 

Plot[steps1[x], {x, -5, 5}]

steps2[x_] := steps1[x/Pi + 1/2]; , Null, Plot[steps2[x], {x, -5*Pi, 5*Pi}, Ticks -> {Pi*Range[-5, 5], 0.2*Range[0, 5]}]

arcot[x_, k_] := Pi/2 - (Log[1 + I*x] - Log[1 - I*x] - 2*Pi*I*k)/(2*I); , Null, Plot[(arcot[x, #1] & ) /@ {-1, 0, 1}, {x, -5, 5}]

p1 = Plot3D[(Re[arcot[x + I*y, #1]] & ) /@ {-1, 0, 1}, {x, -5, 5}, {y, -5, 5}, PlotLabel -> "Re arcot[z]"]; , Null, p2 = Plot3D[(Im[arcot[x + I*y, #1]] & ) /@ {-1, 0, 1}, {x, -5, 5}, {y, -5, 5}, PlotLabel -> "Im arcot[z]"]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

Clear[RS, om, LS, CS]; , Null, ZS = RS + 1/(I*om*CS); , Null, ZP = 1/(1/RS + I*om*CS); , Null, Reduce[ZS == ZP, {RS, CS}]

DegConvert[a_] := {IntegerPart[a], IntegerPart[Mod[(3600*a - Mod[3600*a, 60])/60, 60]], Mod[3600*a, 60]}

DegConvert[13.133]

Clear[f, x], Null, f[x_] := Abs[x - 1] + Abs[x + 3] - 4; , Null, Plot[f[x], {x, -10, 10}]

Reduce[f[x] > 0, x, Reals]

Reduce[f[x] == 0, x, Reals]

Reduce[f[x] < 0, x, Reals]

TODO

IsPrimePower[k_] := (If[k > 1 && Length[#1] <= 1, {True, #1}, {False, #1}] & )[FactorInteger[k]]; , Null, IsPrime[k_] := (If[#1[[1]] && #1[[2]][[1]][[2]] == 1, {True, #1[[2]]}, {False, #1[[2]]}] & )[IsPrimePower[k]]; , Null, FermatNumber[n_] := 2^2^n + 1; , Null, (IsPrime[FermatNumber[#1]] & ) /@ Range[1, 7]

IsPrime[2^67 - 1]

FactorInteger[11244102684192486488811361002585612418726608312031552683325339048893]

Null

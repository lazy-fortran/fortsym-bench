$Assumptions = {pt > 0, m > 0, nu > 0}

L[f_] := nu*D[pt*D[f, p] + (p/pt)*f, p], Null, lhs[f_] := (p/m)*D[f, x] - D[U[x], x]*D[f, p]

fm = Exp[-(p^2 + 2*m*U[x])/(2*pt^2)]/(pt*Sqrt[2*Pi]); , Null, FullSimplify[L[fm]], Null, FullSimplify[lhs[fm]], Null, Integrate[fm, {p, -Infinity, Infinity}]

FullSimplify[L[fm] /. p -> pt]

fmc = fm /. {U[x] -> 1 - Cos[x]}, Null, fmc = fmc/Integrate[fmc, {x, -Pi, Pi}, {p, -Infinity, Infinity}]

Plot[fmc /. p -> pt /. pt -> 0.6, {x, -2*Pi, 2*Pi}]

Plot[fmc /. {x -> 0}, {p, -3, 3}]

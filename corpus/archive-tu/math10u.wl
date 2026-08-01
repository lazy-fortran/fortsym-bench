(Limit[(Sin[x] - x*Cos[x])/x^#1, x -> 0] & ) /@ {1, 2, 3, 4}

Limit[Log[x]/(1 - x), x -> 1]

(Limit[(Sqrt[x^2 - 3] - x)*x^#1, x -> Infinity] & ) /@ {0, 1}

Limit[BesselJ[n, x]/x^n, x -> 0, Assumptions -> n > 0]

% /. n -> {1, 2}

Limit[BesselY[n, x]*x^n /. n -> {1, 2}, x -> 0]

Limit[BesselY[n, x]*x^n, x -> 0, Assumptions -> n > 0]

F = {Sin[x]^2, Sin[Sqrt[x]], Sin[x]^(-2), Exp[-x^2], 1/Tan[x]^3, Sin[Sqrt[a*x + b]]}

TableForm[(Series[#1, {x, 0, 10}] & ) /@ F]

Null

F = {Exp[x^2]/x^2, Exp[-4*I*x]/x^3, BesselJ[n, x]/x^(n + 1), (x^2 + 3*x - 1)/Sin[x]^2}, Null, (Residue[#1, {x, 0}, Assumptions -> Element[n, Integers]] & ) /@ F

(Residue[#1, {x, 2*Pi}, Assumptions -> Element[n, Integers]] & ) /@ F

F = {(3*x + 1)/((x + 1)^2*(x - 2)), Sin[5*x]*Cos[3*x]}, Null, F2 = {x*(y/r^2), x*(y/r)} /. r -> Sqrt[x^2 + y^2 + z^2]

(Integrate[#1, x] & ) /@ F

(Integrate[#1, x, y] & ) /@ F2

elli[x_, y_, z_, a_, b_, c_] := (x/a)^2 + (y/b)^2 + (z/c)^2; , Null, RegionPlot3D[elli[x, y, z, 1, 1, 1] <= 1, {x, -2, 2}, {y, -2, 2}, {z, -2, 2}]

Null

TODO*halb

data = Sin[{0, Pi/2, Pi}]

Clear[p, x]; , Null, p[x_] := a0 + a1*x + a2*x^2 + a3*x^3

sol = Solve[p[0] == 0 && p[Pi/2] == 1 && p[Pi] == 0 && Derivative[1][p][Pi/2] == 0]

Plot[{Sin[x], p[x] /. sol}, {x, 0, Pi}]

(Integrate[#1, {x, 0, Pi}] & )[{p[x] /. sol[[1]], Sin[x]}]

Clear[a, b, al, h, res, al0, al1]; , Null, res[a_, b_] = 2*(b/al)*Sin[al/2] - a

al0 = Pi/2; , Null, al1[a_, b_] := al0 - res[a, b]/D[res[a, b], al] /. al -> al0

al1[1, 1.4]

aln[a_, b_] := NSolve[res[a, b] == 0 && 0 < al < Pi, al, Reals]; , Null, aln[1, 1.4]

Plot[{al1[1, b], al /. aln[1, b]}, {b, 1, 1.5}]

f = (1 - t^4)^(1/2); , Null, fs = Normal[Series[f, {t, 0, 10}]]

Plot[{f, fs}, {t, 0, 0.8}]

Integrate[fs, {t, 0, 0.8}]

NIntegrate[f, {t, 0, 0.8}]

Clear[f, fs, t]; , Null, f = 1/(t^2^(-1)*(t - 1/2)^2^(-1)*(1 - t + t^2/2)^2^(-1)); , Null, fs = Normal[Series[f, {t, 0, 10}]]

Plot[Im[{f, fs}], {t, 0, 0.2}]

Integrate[fs, {t, 0, 0.2}]

NIntegrate[f, {t, 0, 0.2}]

TODO

f = (x - 1)/(x^7 + x^3 + 1)

Plot[f, {x, -1, 1}]

Expand[f]

sing = Solve[1 + x^3 + x^7 == 0, x, Reals]

N[sing]

N[Integrate[f, {x, -1, 1}, PrincipalValue -> True]]

f = (1/2)*z*Exp[z] - 1; , Null, Reduce[f == 0 && -50 < Re[z] < 50 && -50 < Im[z] < 50, z]

N[%], Null, Length[%]

(1/(2*Pi*I))*(NIntegrate[D[f, z]/f, {z, -50 - 50*I, 50 - 50*I}] - NIntegrate[D[f, z]/f, {z, -50 + 50*I, 50 + 50*I}] + NIntegrate[D[f, z]/f, {z, 50 - 50*I, 50 + 50*I}] + NIntegrate[D[f, z]/f, {z, -50 - 50*I, -50 + 50*I}])

Clear[x, y]; , Null, Integrate[x^2 + y^2, {x, 1, 2}, {y, 1, x^2}]

N[%]

NIntegrate[x^2 + y^2, {x, 1, 2}, {y, 1, x^2}]

TODO

Wronsky[f_, x_] := FullSimplify[Det[Table[D[f, {x, i}], {i, Range[0, Length[f] - 1]}]]]; , Null, f = {Sin[x], Sin[2*x], Sin[3*x]}; , Null, Wronsky[f, x]

Wronskian[f, x]

Null

Integrate[Abs[x], x]

Clear[F, x, x0]; , Null, F[x0_] := If[x0 < 0, Integrate[-x, {x, 0, x0}], Integrate[x, {x, 0, x0}]]; 

Plot[F[t], {t, -10, 10}]

f = 1 - (2/(b - a))*Abs[t - (a + b)/2]; , Null, Plot[f /. {a -> 0, b -> 3}, {t, 0, 3}]

FullSimplify[Integrate[Exp[(-s)*t]*f, {t, a, b}, Assumptions -> {b > a > 0}]]

F = {t^a*Exp[b*t], (1 - Exp[-t])/t, Log[t], Exp[-t^2/4], Cos[x*Sqrt[t]]/Sqrt[t], Sin[x*Sqrt[t]], Cosh[x*Sqrt[t]]/Sqrt[t], Sinh[x*Sqrt[t]], Exp[-x^2/(4*t)]/Sqrt[t], Exp[-x^2/(4*t)]/Sqrt[t^3]}

(LaplaceTransform[#1, t, s] & ) /@ F

Clear[F, s, om, a]; , Null, F = Flatten[{(s^#1/(s^3 + om^3) & ) /@ {0, 1, 2}, (s^#1/(s^4 + 4*om^4) & ) /@ Range[0, 3], (s^#1/(s^4 - om^4) & ) /@ Range[0, 3], Exp[(-a)*Sqrt[s]]/s}]

FullSimplify[(InverseLaplaceTransform[#1, s, t] & ) /@ F]

f = Exp[s^2]; , Null, Limit[Integral[Exp[s*t]*f, {s, (-I)*T, I*T}], {T -> Infinity}]

Null

Null

dgl = LS*CS*Derivative[2][i][t] + RS*CS*Derivative[1][i][t] + i[t] == 0; sol = DSolve[{dgl, i[0] == 0, Derivative[1][i][0] == U0/LS}, i[t], t], Null, sol1 = sol /. {LS -> 1, CS -> 1, RS -> 1, U0 -> 10}, Null, Plot[i[t] /. sol1, {t, 0, 10}]

TODO*halb

Null

FourierTransform[Cos[om0*t], t, om]

Clear[n]; , Null, Limit[(Product[i - 1/2, {i, 1, n}]/n!)*Sqrt[Pi*n], n -> Infinity]

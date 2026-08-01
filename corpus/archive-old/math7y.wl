$Version

Sum[k^2, {k, 4}]

f = Sum[1/(i + 1), {i, 0, 4}]

Sum[k^2, {k, n}]

f = Sum[q^n, {n, 0, Infinity}]

f = Sum[0.9^n, {n, 0, Infinity}]

f = Sum[1/n, {n, 0, Infinity}]

Sum[(-1)^n/n, {n, Infinity}]

Sum[(n - 2*k)^2*Binomial[n, k], {k, 0, n}]

Sum[1/k^4, {k, Infinity}]

Sum[x^k/k!, {k, Infinity}]

Sum[1/k^3, {k, Infinity}]

Information["Zeta", LongForm -> False]

N[Zeta[3]]

NSum[1/k^3, {k, Infinity}]

Sum[x^k/(k!*k), {k, Infinity}]

Chop[N[% /. x -> 1.37]]

NSum[1.37^k/(k!*k), {k, Infinity}]

Clear[s1], Null, s1[n_, x_] = Expand[Sum[Sin[(2*i - 1)*x]/i, {i, n}]]

Information["LerchPhi", LongForm -> False]

ExpToTrig[Expand[Simplify[s1[5, x]]]]

Chop[s1[n, x] /. {x -> 27.31, n -> 5}]

Chop[s1[n, x] /. {x -> 27.31, n -> 5.5}]

s2[n_, x_] = Expand[Sum[Sin[i*x]/i, {i, 1, n, 2}]]

Chop[s2[7, 0.33]]

ExpToTrig[Expand[Simplify[s2[7, x]]]]

Chop[% /. x -> 0.33]

Sum[Sin[k*x]/k, {k, Infinity}]

Apart[Simplify[Sum[Sinh[k*x]*(z^k/k), {k, Infinity}]]]

f = NSum[(-1)^k/k, {k, 1, Infinity}]

-Log[2.]

f = NSum[(-1)^k/(2*k + 1), {k, 0, Infinity}]

N[Pi/4]

NSum[1/Log[k], {k, 2, Infinity}]

NSum[(-1)^k/Log[k], {k, 2, Infinity}]

fc[n_, x_] = (-(-1)^n)*(Cos[n*x]/n)

sn[x_] := NSum[fc[n, N[x]], {n, Infinity}]

fe[x_] = Log[2*Cos[x/2]]; 

N[fe[0]]

sn[0]

N[fe[Pi/2]]

sn[N[Pi/2]]

fe[0.15]

sn[0.15]

Sum[(-1)^n, {n, Infinity}]

NSum[(-1)^n, {n, Infinity}]

NSum[(-1)^n, {n, 0, Infinity}]

r[n] = (-1)^n; , Null, s[n] = Sum[r[n], {n, N}]

hs[N] = Sum[s[n]/N, {n, N}]

hos = ExpandAll[Sum[hs[N], {N, NN}]/NN]

Limit[hos, NN -> Infinity]

f = Sum[q^n, {n, Infinity}]

f /. q -> -1

me = {{-Pi, 0}, {-Pi, -1}, {0, -1}, {0, 1}, {Pi, 1}, {Pi, 0}}; p1 = ListPlot[me, Joined -> True, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> Hue[0]]; 

Clear[n, x]; pb = Black; yf[n_, x_] = (4/Pi)*(Sin[n*x]/n); sf[n_, x_] := Sum[yf[i, x], {i, 1, n, 2}]; ssf = Plot[{sf[2, x], yf[3, x], sf[3, x]}, {x, Pi, -Pi}, PlotStyle -> {{pb, Dashing[{0.02}]}, {pb, Dashing[{0.01}]}, {pb, Dashing[{}]}}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}]; 

p2 = Show[p1, ssf]; Show[GraphicsRow[{p1, p2}]]

p3 = Plot[sf[30, x], {x, -Pi, Pi}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> pb]; , Null, Show[p1, p3, ImageSize -> 200]

sff[n_, x_] := Sum[sf[i, x], {i, n}]/n; Plot[Evaluate[{sff[2, x], sf[3, x], sff[3, x]}], {x, Pi, -Pi}, PlotStyle -> {{pb, Dashing[{0.02}], pb}, {pb, Dashing[{0.01}]}, {pb, Dashing[{}]}}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}]; 

ss3 = Show[%, p1]; 

p4 = Plot[Evaluate[sff[20, x]], {x, Pi, -Pi}, PlotStyle -> pb]; , Null, ss0 = Show[p1, p4, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}]; GraphicsRow[{ss3, ss0}]

s1 = Sum[Sin[n*x]/n, {n, 1, Infinity}]

c1 = ExpandAll[Sum[Cos[n*x]/n, {n, 1, Infinity}]]

pb = Black; 

p1 = Plot[s1, {x, -3*Pi, 3*Pi}, Ticks -> Pi*{Range[-3, 3], Range[-1, 1]/2}, PlotStyle -> pb]; , Null, p2 = Plot[c1, {x, -3*Pi, 3*Pi}, Ticks -> {Pi*Range[-3, 3], Range[1, 5]}, PlotStyle -> pb]; , Null, GraphicsRow[{p1, p2}, ImageSize -> 450]

ps = Plot[N[(Pi - x)/2 + Pi*Floor[(x*0.5)/Pi]], {x, -4*Pi, 4*Pi}, Ticks -> Pi*{Range[-3, 3], Range[-1, 1]/2}]; pc = Plot[-Log[2*Abs[Sin[x/2]]], {x, -4*Pi, 4*Pi}, Ticks -> {Pi*Range[-3, 3], Range[1, 5]}]; , Null, GraphicsRow[{ps, pc}, ImageSize -> 450]

Clear[su]

su[NN_] = 4*Sum[(-1)^(k - 1)/(2*k - 1), {k, 1, NN}]

Timing[SetPrecision[su[10^5], 10]]

SetPrecision[%[[2]], 20]

SetPrecision[Pi, 20]

% - %%

4*(Pi/4 - (1/4)*(-1)^NN*(-PolyGamma[0, 1/4 + NN/2] + PolyGamma[0, 3/4 + NN/2])) /. NN -> 10^8; 

SetPrecision[%, 20]

SetPrecision[Pi, 20]

% - %%

SetPrecision[4*NSum[(-1)^(k - 1)/(2*k - 1), {k, Infinity}], 19], Null, % - Pi

as = Sum[(1/16^k)*(-(2/(8*k + 4)) - 1/(8*k + 5) - 1/(8*k + 6) + 4/(8*k + 1)), {k, 0, 7}], Null, N[as - Pi]

SetPrecision[Pi, 65]

fact[n_] = Product[i, {i, n}]

Information["Gamma", LongForm -> False]

fact[0.5]

0.5!

Gamma[1.5]

fact[n_] := Product[i, {i, n}]

fact[0.5]

fact[2.5]

2.5!

fact2[n_] = Product[i, {i, n, 1, -2}]

fact2[5]

5!!

fact2[4]

4!!

5.5!!

fact2[5.5]

Product[4*k*((1 + k)/(1 + 2*k)^2), {k, 1, Infinity}]

Product[1 - 1/(k + 5)^2, {k, 0, n}]

Product[1 - 1/(k + 5)^(5/2), {k, 0, n}]

NProduct[1 - 1/(k + 5)^(5/2), {k, 0, 10}]

NProduct[1 - 1/(k + 5)^(5/2), {k, 0, Infinity}]

Product[1 - 1/(k + 5)^3, {k, 0, n}]

Product[1 - x^2/n^2, {n, Infinity}]

piu[n_] = (Product[2*k, {k, n}]/Product[2*k - 1, {k, n}])^2/n

piu[10]

N[%]

N[piu[100000]]

F11[a_, b_, z_, n_] := 1 + Sum[Product[((a + i - 1)/(b + i - 1))*(z/i), {i, k}], {k, n}]

F11[-5, b, z, 9]

Hypergeometric1F1[-5, b, z]

Do[Print[i^2], {i, 4}]

Do[Print[{i, i^3}], {i, 3, 12, 4}]

Do[Print[{i, j}], {i, 4}, {j, i - 1}]

t = x; Do[t = 1/(1 + t), {3}]; t

% /. x -> 5

Do[t = k^2; Print[t]; If[t > 10, Break[]], {k, 7}]

Do[t = k^2; If[t > 10, Break[], Print[t]], {k, 7}]

Do[t = k^2; If[t > 25, Return[t]], {k, 9}]

Do[t = k^2; Print[{k, t}]; If[t < 17, Continue[], Break[]], {k, 9}]

myFindRoot[f_, init_] := FixedPoint[#1 - f[#1]/Derivative[1][f][#1] & , init]; 

Clear[x, g]; g[x_] = Sin[x] + Cos[2*x]/2; 

Plot[g[t], {t, -1, 4}]

myFindRoot[g, 3.]

theta[x_] = If[x > 0, 1, 0]

theta[1]

theta[0]

theta[-1]

thetag[x_] = If[x >= 0, 1, 0]

thetag[1]

thetag[0]

thetag[-1]

thetal[x_] = If[x <= 0, 0, 1]

thetal[1]

thetal[0]

thetal[-1]

Remove[n, k]*krodel[n_, k_] = If[k == n, 1, 0]

krodel[3, 4]

krodel[3, 3]

krodel[a, a]

Remove[n, k]*krodel[n_, k_] = If[k != n, 0, 1]

krodel[3, 4]

krodel[a, a]

k = 1; , Null, If[k == 1, Print["yes"]]

If[k != 1, Print["yes"]]

theta[x_] = Which[x > 0, 1, x == 0, 1/2, x < 0, 0]

theta[1]

theta[0]

theta[-1]

Clear[x], Null, h[x_] = Which[x^2 < 1, Sqrt[1 - x^2], True, 0]

Plot[h[x], {x, -1.5, 1.5}]

theta[x_] = Which[x > 0, 1, x = 0, 1/2, x < 0, 0]

theta[1]

theta[0]

theta2[x_, y_] = If[x > 0 && y > 0, 1, 0]

theta2[1, 1]

theta2[-1, 1]

theta2[1, -1]

theta2[-1, -1]

theta2[x_, y_] = If[x > 0 || y > 0, 1, 0]

theta2[1, 1]

theta2[-1, 1]

theta2[1, -1]

theta2[-1, -1]

Clear[f, g, x, y]*g[x_, y_] = Abs[Exp[(x + I*y)^(-1)]]; f[x_, y_] = Which[x < 0 && y < 0, 0, True, g[x, y]]; re = Plot3D[f[x, y], {x, -2, 2}, {y, -Pi, Pi}, PlotPoints -> 50]; li = Show[re, PlotRange -> {0, 5}, ViewPoint -> {-4, -4, 3}, Axes -> None, Boxed -> False]; GraphicsRow[{re, li}, ImageSize -> 500]

f1[x_] := Which[x < 0, 0, x < 1, 1, x < 2, 2]

SetAttributes[f1, Listable]

f1[{-0.5, 0., 0.75, 1., 1.5, 2, 3}]

f2[x_] := Which[x < 0, 0, x < 1, 1, x < 2, 2, True, 2.5]

SetAttributes[f2, Listable]

f2[{-0.5, 0., 0.75, 1., 1.5, 2, 3}]

p1 = Plot[f1[x], {x, -1, 3}, PlotStyle -> Hue[0], PlotRange -> {0, 3}]; , Null, p2 = Plot[f2[x], {x, -1, 3}, PlotStyle -> Hue[0], PlotRange -> {0, 3}]; , Null, GraphicsRow[{p1, p2}]

NumberQ[x]

NumberQ[Pi]

NumberQ[3.14]

IntegerQ[3.14]

PrimeQ[5679]

PrimeQ[23]

fact[x_] = If[IntegerQ[x], Product[k, {k, x}], Gamma[x + 1]]; 

fact[x]

fact[5]

fact[4.5]

4.5!

fact2[x_] := If[IntegerQ[x], Print[Product[k, {k, x, 1, -2}]], Print[x!!]]; 

fact2[4.5]

fact2[5]

fact2[x_] = If[IntegerQ[x], Print[Product[k, {k, x, 1, -2}]], Print[x!!]]; 

fact2[4.5]

fact2[5]

fact2[x_] = If[IntegerQ[x], Return[Product[k, {k, x, 1, -2}]], Return[x!!]]; 

Clear[a, b, c, c, s, ma], Null, ma = {{a + b, 0, c - 1, 0}, {0, d*5, 0, 12*b}, {s + 1, 0, a - d, 0}, {0, 1, 0, 4}}; MatrixForm[ma]

MatrixForm[Table[If[ma[[i,j]] === 0, 0, x], {i, Length[ma]}, {j, Length[ma]}]]

d = {1, 2, 3, 6, 11, 7, 6, 4, 6, 8, 11, 17, 12, 10, 8, 6, 3, 3};

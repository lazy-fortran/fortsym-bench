$Version

f = Sin[a*x]

g = D[f, x]

h = D[f, {x, 4}]

f = Exp[a*x + b*y + c*z]

g = D[f, {x, 2}, {y, 3}, {z, 2}]

Clear[f], Null, g = D[f, x]

D[Log[x]^2, x]

legpoly[n_, x_] := D[1/Sqrt[1 - 2*a*x + a^2], {a, n}]/n! /. a -> 0

legpoly[2, x]

f = Apart[legpoly[10, x]]

Apart[LegendreP[10, x]]

f /. x -> 1

f = LegendreP[3, Cos[th]]

g = Expand[f, Trig -> True]

TrigReduce[g]

Clear[f]

D[f[x]^2, x]

D[x*f[x]^2, x]

D[%, x]

Clear[g]; , Null, D[g[x, y], x]

D[g[x, y], y]

D[g[x, y], x, y]

D[g[x^2, y^3], x]

D[g[x^2, y^3], y]

D[g[x^2, y^3], {x, 2}]

% /. x -> 0

D[x^2 + y^2, x]

Dt[x^2 + y^2, x]

% /. Dt[y, x] -> D[y[x], x]

D[x^2 + y[x]^2, x]

y /: Dt[y, x] = 0

Dt[x^2 + y^2 + z^2, x]

Clear[y]; , Null, Dt[x^2 + y^2 + z^2, x]

Dt[x^2 + y^2 + z^2, x, Constants -> {z}]

SetAttributes[c, Constant]

Dt[a^2 + c*x^2, x]

Dt[a^2 + c[x]*x^2, x]

Dt[x^2 + c*y^2]

% /. Dt[y] -> dy

Clear[x, R, V, f0, f1, f2]

f0 = y = z/v^4^(-1)

f1 = Dt[f0, x]

f2 = Dt[f1, x]

ft0 = (Dt[v, {x, 2}]/4)*f0

ft1 = Expand[(Dt[v, x]/2)*f1]

ft2 = Expand[v*f2]

ft0 + ft1 + ft2

Apart[Cancel[(ft0 + ft1 + ft2)/v^(3/4)]]

% /. v -> x

Expand[%%*x^2 /. v -> x^4]

f = Series[Exp[x], {x, 0, 4}]

g = f + Exp[2*x]

Normal[f] + Exp[2*x]

Series[Sin[x], {x, 0, 4}]

h = Series[Exp[x], {x, 1, 2}]

Series[Log[1 + x], {x, 0, 5}]

t = g^2

Series[Exp[x]/x^2, {x, 0, 4}]

Series[Sin[x]/x^2, {x, 0, 3}]

Series[Exp[Sqrt[x]], {x, 0, 2}]

Series[Log[x], {x, 0, 3}]

Series[Exp[2*x]*Log[x], {x, 0, 2}]

Series[Exp[1/x], {x, 0, 2}]

Series[Exp[1/x], {x, Infinity, 3}]

Series[(a + x)^n, {x, 0, 2}]

Clear[f, g]; , Null, Series[f[x], {x, 0, 3}]

Series[g[x, y], {x, 0, 3}, {y, 1, 2}]

f = Series[Exp[a*x + b*y], {x, 0, 3}, {y, 0, 3}]

g = Series[Exp[a*x + b*y], {y, 0, 3}, {x, 0, 3}]

Simplify[f - g]

f = Series[Exp[x], {x, 0, 4}]

g = f^2

h = Log[g]

g = 1/(1 - f)

f = Series[Cos[x], {x, 0, 5}]

g = D[f, x]

h = Integrate[g, x]

f - h

k = 1/f

f = Series[Sin[x], {x, 0, 5}]

g = f + Sin[x]

g = Normal[f]

g + Sin[x]

Plot[{f, Sin[x]}, {x, 0, Pi}, Ticks -> {{0, Pi/2, Pi}, Automatic}, ImageSize -> 200]

ps = Plot[{g, Sin[x]}, {x, 0, Pi}, DisplayFunction -> Identity, Ticks -> {{0, Pi/2, Pi}, Automatic}]; , Null, pa = Plot[g - Sin[x], {x, 0, Pi}, DisplayFunction -> Identity, Ticks -> {{0, Pi/2, Pi}, Automatic}]; , Null, Show[GraphicsRow[{ps, pa}], ImageSize -> 350]

Solve[f == 0, x]

Solve[g == 0, x]

Series[Sin[x], {x, 0, 5}]

% /. x -> Series[Sin[x], {x, 0, 5}]

Series[Sin[Sin[x]], {x, 0, 5}]

f = Series[Sin[y], {y, 0, 5}]

g = InverseSeries[f]

k = Series[ArcSin[x], {x, 0, 5}]

1/f

g /. y -> f

f = Series[Cot[x], {x, 0, 5}]

g = InverseSeries[f]

h = f /. x -> g

f = Series[1 - Cos[x], {x, 0, 8}]

g = InverseSeries[f]

f /. x -> g

ExpandAll[%]

f = Series[Cos[x], {x, 0, 5}]

g = InverseSeries[f]

f = Series[Cos[x], {x, Pi/2, 5}]

f = Series[BesselJ[3, x], {x, 0, 5}]

f = Series[BesselJ[n, x], {x, 0, 5}]

f = Series[BesselY[n, x], {x, 0, 5}]

g = f /. n -> 3

Series[BesselY[3, x], {x, 0, 8}]

Residue[1/x, {x, 0}]

Residue[1/x^2, {x, 0}]

Residue[Exp[I*2*x]/x^4, {x, 0}]

Residue[Cos[x]/x^3 - Sin[x]^2/x^3, {x, 0}]

Residue[Gamma[x], {x, -2}]

Limit[(x + 2)*Gamma[x], x -> -2]

Limit[(x + 3)*Gamma[x], x -> -3]

Residue[BesselJ[2, x]/x^3, {x, 0}]

LegendreP[2, x]

Residue[LegendreP[2, x]/x^3, {x, 0}]

Residue[LegendreP[n, x]/x^(n + 1), {x, 0}, Assumptions -> Element[n, Integers]]

LegendreQ[2, x]

f = Series[LegendreQ[2, x], {x, Infinity, 5}]

Residue[LegendreQ[2, x], {x, Infinity}]

Residue[LegendreQ[2, x]*x^2, {x, Infinity}]

Residue[BesselY[1, x], {x, 0}]

Limit[BesselY[1, x]*x, x -> 0]

Limit[Sin[2*x]/x, x -> 0]

Limit[(Sin[2*x]/x)^2, x -> 0]

Limit[Sin[2*x]^2/x, x -> 0]

Limit[Sin[2*x]/x^2, x -> 0]

Limit[1/Sin[x] - Coth[x], x -> 0]

Limit[x/Sin[Pi - x], x -> 0]

Limit[1/x, x -> Infinity]

Clear[g]; , Null, g[x_] = Sqrt[x^2 - 4*x] - x; 

Limit[g[x], x -> Infinity]

f = (q^a - q^(-a))/(q - q^(-1))

Limit[f, q -> 1]

theta[x_] = Which[x > 0, 1, x == 0, 1/2, x < 0, 0]

Limit[theta[x], x -> 0]

Sign[0.1]

Sign[0]

Sign[-1]

Limit[Sign[x], x -> 0]

Limit[Sign[x], x -> 0.1]

Clear[f]; , Null, f[x_] = 1/x

Limit[f[x], x -> 0, Direction -> -1]

Limit[f[x], x -> 0, Direction -> 1]

Limit[Sign[x], x -> 0, Direction -> -1]

Limit[Sign[x], x -> 0, Direction -> 1]

theta[x_] = Which[x > 0, 1, x == 0, 1/2, x < 0, 0]

Limit[theta[x], x -> 0, Direction -> 1]

Limit[Exp[Tan[x]/Log[Cos[x]]], x -> Pi/2, Direction -> -1]

Limit[Exp[Tan[x]/Log[Cos[x]]], x -> Pi/2, Direction -> 1]

Clear[a, r, it], Null, it = Integrate[r^2*Exp[(-a)*r^2], {r, 0, r}]

Limit[it, r -> Infinity]

a = 3; 

N[it[[1]] /. r -> 5]

Erf[Sqrt[a]*Infinity]

N[it[[2]] /. r -> 5]

0.08527722566220737

N[Sqrt[Pi]/4/a^(3/2)]

g = Integrate[Sqrt[x], x]

D[g, x]

f = ((x - 1)^2*(x^2 + 1)^2)^(-1)

g = Integrate[f, x]

h = D[g, x]

Together[h]

Table[h[[k]], {k, Length[h]}]

Clear[x, f]

f = (x^3 - 7)^(-1)

Integrate[f, x]

f = (x^3 + x^2 - 7)^(-1)

Integrate[f, x]

ni = N[%]

ComplexExpand[ni]

ni[[2]]

so = Solve[1/f == 0, x]

g = Integrate[x^3*Log[x], x]

D[g, x]

g = Integrate[x^2/Sqrt[x^2 - 9], x]

D[g, x]

Together[%]

Clear[a, b, f, g, x], Null, f = Sqrt[(a^2 - x^2)*(b^2 - x^2)]/x

g = Integrate[f, x]

FullSimplify[g]

D[g, x]; 

FullSimplify[%]

go = (1/2)*Sqrt[a^2 - x^2]*Sqrt[b^2 - x^2] + (1/4)*(a^2 + b^2)*Log[(Sqrt[a^2 - x^2] + Sqrt[b^2 - x^2])/(-Sqrt[a^2 - x^2] + Sqrt[b^2 - x^2])] - (1/2)*a*b*Log[(b*Sqrt[a^2 - x^2] + a*Sqrt[b^2 - x^2])/((-b)*Sqrt[a^2 - x^2] + a*Sqrt[b^2 - x^2])]; 

dg = D[go, x]

Timing[FullSimplify[dg]]

f = Sin[3*x]*Cos[x]^2

g = Integrate[f, x]

h = D[g, x]

k = h - f

Simplify[k]

Clear[x, y, z, r], Null, r = Sqrt[x^2 + y^2 + z^2]

gxy = Integrate[x^2/r, x, y]

gyx = Integrate[x^2/r, y, x]

dg = gxy - gyx

Simplify[dg]

Together[D[dg, x, y]]

g = x*y*(r/6) + z^3*(ArcTan[x*(y/(z*r))]/3) - (y^3 + 3*y*z^2)*(Log[x + r]/6) + x^3*(Log[y + r]/3)

f = Together[D[g, x, y]]

gxy = Integrate[x^2/r^2, x, y]

rr = Sqrt[x^2 + y^2]

k = Integrate[rr^(-3), x, y]

Together[D[k, x, y]]

f = Sqrt[1 + x^6]/x

Integrate[f, x]

Clear[a, x]; , Null, f = ArcSinh[a/x]; , Null, g = PowerExpand[ExpandAll[Integrate[f, x]]]

h = FullSimplify[D[g, x]]

g1 = x*ArcSinh[a/x] + a*ArcSinh[x/a]; , Null, h1 = D[g1, x]

Simplify[h1, x >= 0 && a >= 0]

Integrate[Abs[x], x]

Integrate[2*x*UnitStep[x] - x, x]

Show[GraphicsRow[{Plot[Abs[x], {x, -1, 1}, AxesLabel -> {"x", "Abs[x]"}], Plot[2*x*UnitStep[x] - x, {x, -1, 1}, AxesLabel -> {"x", "2 x UnitStep[x] - x"}]}], ImageSize -> 400]

NIntegrate[Abs[x], {x, -1, 2}]

Integrate[2*x*UnitStep[x] - x, {x, -1, 2}]

g = Integrate[Sin[x], x]

gt = g /. x -> Pi/2 - g /. x -> 0

gt = (g /. x -> Pi/2) - (g /. x -> 0)

Integrate[Sin[x], {x, 0, Pi/2}]

Integrate[Sin[0.1*x], {x, 0, Pi/2}]

f = x^3*y^2*z

Integrate[f, {x, a, b}, {y, c, d}, {z, e, m}]

Integrate[Sin[x]/x, {x, 0, b}]

Integrate[((x - 1)/Log[x] - x)/Log[x], {x, 0, 1}]

Integrate[1/Log[x]^2 - x/(1 - x)^2, {x, 0, 1}]

N[%] - NIntegrate[1/Log[x]^2 - x/(1 - x)^2, {x, 0, 1}]

vz = Integrate[1, {z, 0, c*Sqrt[1 - (x/a)^2 - (y/b)^2]}]

vy = Integrate[vz, {y, 0, b*Sqrt[1 - (x/a)^2]}, Assumptions -> a > 0 && b > 0 && c > 0 && a > x > 0]

v = Integrate[%, {x, 0, a}]

sy = y -> b*(1 - x^2/a^2)^(1/2)*Sin[ϕ]; 

vvy = vz /. sy

dy = D[y /. sy, ϕ]

vy = Integrate[vvy*dy, {ϕ, 0, Pi/2}]

Integrate[vy, {x, 0, a}]

Integrate[1/x^2, {x, 2, Infinity}]

Integrate[1/x, {x, 2, Infinity}]

Integrate[Sin[x]/x, {x, 0, Infinity}]

Integrate[(Sin[x]/x)^2, {x, 0, Infinity}]

Integrate[Sin[x]^3/x, {x, 0, Infinity}]

Integrate[Sin[x]/x^2, {x, 0, Infinity}]

Clear[x, b, f], Null, f[x_, b_] = (x^2*b*E^(b*x))/(E^(b*x) + 1)^2; 

Integrate[f[x, b], {x, 0, Infinity}]

Simplify[%, b > 0]

Integrate[f[x, b], {x, 0, Infinity}, Assumptions -> {b > 0}]

Integrate[f[x, b], {x, 0, Infinity}, Assumptions -> {Re[b] > 0}]

Integrate[1/2 + (1/2)*Erf[z], {z, -Infinity, 0}]

ic = Integrate[(Cos[a*x]*Sin[b*x]*Sinh[(-c + d)*x])/(x*Sinh[d*x]), {x, 0, Infinity}]

Clear[a, b, x, fx], Null, fx = Cos[a*x]*Sin[b*x]

fxd = Expand[TrigReduce[fx]]

α1 = Cancel[fxd[[2,2,1]]/x]

α2 = Cancel[fxd[[1,2,1]]/x]

fi = Cos[x*α]*(Sinh[β*x]/Sinh[d*x])

in = Integrate[fi, {x, 0, Infinity}, Assumptions -> d > β > 0 && Element[α, Reals]]

ia = Integrate[fi, {α, 0, α}] /. {β -> d - c}

iaf = Simplify[Together[(1/2)*(ia /. α -> α1) - (1/2)*(ia /. α -> α2)]]

ir = Integrate[in, {α, 0, α}, Assumptions -> α > 0 && β > 0 && d > 0]

irr = ir /. {β -> d - c}

irf = Simplify[Together[(1/2)*(irr /. α -> α1) - (1/2)*(irr /. α -> α2)]]

ExpToTrig[irf]

irs = FullSimplify[%, Sin[(c*Pi)/d] > 0]

su = {a -> 0.37, b -> 1.23, c -> 0.79, d -> 3.21}; 

Sin[c*(Pi/d)] /. su

NIntegrate[(Cos[a*x]*Sin[b*x]*Sinh[(-c + d)*x])/(x*Sinh[d*x]) /. su, {x, 0, Infinity}]

irf /. su

irs /. su

Integrate[1/z, {z, -1, I, 1/2}]

N[%]

Chop[NIntegrate[1/z, {z, -1, I, 1/2}]]

Integrate[1/z, {z, -1, -I, 1/2}]

N[%]

NIntegrate[1/z, {z, -1, -I, 1/2}]

Integrate[1/z, {z, -1, I, 1}]

N[%]

Chop[NIntegrate[1/z, {z, -1, I, 1}]]

NIntegrate[1/z, {z, -1, I, 2}]

ia = Integrate[1/z, {z, -1, -I, 1, I, -1}]

Chop[N[%]]

in = Chop[NIntegrate[1/z, {z, -1, -I, 1, I, -1}]]

Information["Integrate", LongForm -> True]

Integrate[Sin[a*x]/x, {x, 0, Infinity}]

Integrate[Sin[a*x]/x, {x, 0, Infinity}, Assumptions -> {a > 0}]

Information["GenerateConditions", LongForm -> True]

Integrate[Sin[a*x]/x, {x, 0, Infinity}, GenerateConditions -> False]

Integrate[Cos[x]/x, {x, -1, 2}]

Information["PrincipalValue", LongForm -> True]

Integrate[1/x, {x, -1, 2}, PrincipalValue -> True]

Integrate[Cos[x]/x, {x, -1, 2}, PrincipalValue -> True]

Chop[N[%]]

Clear[t]

Integrate[Sin[t]/t^2, {t, -1, 2}, PrincipalValue -> True]

Chop[N[%]]

Information["Assumptions", LongForm -> True]

Integrate[E^((-a)*x^2), {x, 0, Infinity}]

Integrate[E^((-a)*x^2), {x, 0, Infinity}, Assumptions -> {a > 0}]

Integrate[Sin[t*u - x]*Exp[(-a)*u^2], {u, -Infinity, Infinity}]

Integrate[Sin[t*u - x]*Exp[(-a)*u^2], {u, -Infinity, Infinity}, Assumptions -> {Element[t, Reals], a > 0}]

NIntegrate[Sin[x], {x, 0, Pi/2}]

NIntegrate[Sin[20*x], {x, 0, Pi/2}]

Integrate[Sin[20*x], {x, 0, Pi/2}]

NIntegrate[Sin[x]/x, {x, 0, Infinity}]

N[Pi/2]

NIntegrate[1/Sqrt[x], {x, 0, 1}]

Integrate[1/Sqrt[x], {x, 0, 1}]

NIntegrate[1/Sqrt[Abs[x]], {x, -1, 2}]

NIntegrate[1/Sqrt[Abs[x]], {x, -1, 0, 2}]

Clear[a]; f = ArcSinh[a/x]; fn = f /. a -> 1.37; , Null, g = Integrate[f, x]

gn = NIntegrate[fn, {x, 1, 2}]

gc = (g /. {a -> 1.37, x -> 2}) - (g /. {a -> 1.37, x -> 1})

r = Sqrt[x^2 + y^2 + z^2]; 

g = x*y*(r/6) + z^3*(ArcTan[x*(y/(r*z))]/3) + x^3*(Log[y + r]/3) - (y^3 + 3*y*z^2)*(Log[x + r]/6)

f = Simplify[Together[Simplify[D[g, x, y]]]]

fn = f /. z -> 3.31

nn = NIntegrate[fn, {x, 0.2, 0.9}, {y, 0.1, 0.7}]

gn = g /. z -> 3.31; , Null, g11 = N[gn /. {x -> 0.9, y -> 0.7}]; , Null, g01 = N[gn /. {x -> 0.2, y -> 0.7}]; , Null, g10 = N[gn /. {x -> 0.9, y -> 0.1}]; , Null, g00 = N[gn /. {x -> 0.2, y -> 0.1}]; , Null, dg = g11 - g01 - g10 + g00

Information["NIntegrate", LongForm -> True]

NIntegrate[1/x, {x, 1, 2}, WorkingPrecision -> 40]

N[Log[2], 40]

Plot[Exp[-x^2], {x, -5, 5}, PlotRange -> All]

N[NIntegrate[Exp[-x^2], {x, -1000, 1000}], 22]

in = SetPrecision[NIntegrate[N[Exp[-x^2], 44], {x, -1000, 1000}, MinRecursion -> 3, MaxRecursion -> 10], 44]

SetPrecision[NIntegrate[Exp[-x^2], {x, -1000, 1000}], 44]

% - %%

Integrate[Exp[-x^2], {x, -1000, 1000}]

ia = N[%, 44]

N[Sqrt[Pi]*Erf[Infinity], 44]

in - ia

N[Sqrt[Pi], 44]

N[1/(E^a^2*(2*a)) /. a -> 100]

Clear[f, x], Null, f[x_] := Which[x < 0, 0, x < 1, 1, x >= 2, 2 - x, x >= 1, x]; 

Plot[f[x], {x, -1, 4}, PlotStyle -> Thickness[0.01]]

NIntegrate[f[x], {x, -1, 4}]

Integrate[Sin[x]/x^2, {x, -1, 2}]

Integrate[Sin[x]/x^2, {x, -1, 2}, PrincipalValue -> True]

Chop[N[%]]

NIntegrate[Sin[x]/x^2, {x, -1, 0, 1, 2}, Method -> {"PrincipalValue", "SingularPointIntegrationRadius" -> 1/4}]

Integrate[1/(x - x^2), {x, -1, 2}, PrincipalValue -> True]

N[%]

NIntegrate[1/(x - x^2), {x, -1, 0, 1, 2}, Method -> {"PrincipalValue", "SingularPointIntegrationRadius" -> 1/4}]

LaplaceTransform[c, t, s]

LaplaceTransform[t^n, t, s]

LaplaceTransform[Sin[ω*t], t, s]

LaplaceTransform[Cos[ω*t], t, s]

LaplaceTransform[t*Sin[ω*t], t, s]

LaplaceTransform[t*Cos[ω*t], t, s]

ft1 = If[t <= a, 0, 1]; , Null, sua = a -> 1; , Null, Plot[ft1 /. sua, {t, 0, 4}, AspectRatio -> Automatic, AxesLabel -> {"t", "f(t)"}, Ticks -> {{0, {a, "a"}} /. sua, {0, 1}}, PlotStyle -> Thick]

LaplaceTransform[ft1, t, s]

Integrate[Exp[(-s)*t], {t, a, Infinity}]

Integrate[Exp[(-s)*t], {t, a, b}]

LaplaceTransform[BesselJ[0, a*t], t, s]

LaplaceTransform[BesselJ[n, a*t], t, s]

Simplify[% /. n -> 3]

Apart[%]

InverseLaplaceTransform[s/(s^2 + ω^2), s, t]

InverseLaplaceTransform[c/s, s, t]

InverseLaplaceTransform[1/(E^(a*s)*s), s, t]

InverseLaplaceTransform[c, s, t]

fi = V0/(s*R + s^2*L + C)

ti = InverseLaplaceTransform[fi, s, t]

svd = {V0 -> 10, R -> 22, L -> 110, C -> 1}; 

N[ti /. svd] /. 2.718281828459045 -> E

Plot[Evaluate[ti /. svd], {t, 0, 57}, PlotRange -> All, AxesLabel -> {"t", "I(t)"}]

svs = {V0 -> 10, R -> 22, L -> 110, C -> 19}; 

Chop[Expand[N[ti /. svs]]] /. 2.718281828459045 -> E

Plot[Evaluate[ti /. svs], {t, 0, 57}, PlotRange -> All, AxesLabel -> {"t", "I(t)"}]

ft = 1/(t^2 + a^2); , Null, fw = FourierTransform[ft, t, ω]

PowerExpand[%]

fm = (1/Sqrt[2*Pi])*Integrate[ft*Exp[I*ω*t], {t, -Infinity, Infinity}, Assumptions -> {a > 0 && Element[ω, Reals]}]

FourierCosTransform[ft, t, ω]

PowerExpand[%]

Sqrt[2/Pi]*Integrate[ft*Cos[ω*t], {t, 0, Infinity}, Assumptions -> {a > 0 && ω > 0}]

fst = UnitStep[t] + UnitStep[a - t] - 1

sa = {a -> 1}; 

Plot[fst /. sa, {t, -1, 2}, PlotRange -> {0, 1.1}, PlotStyle -> Thickness[0.009], Epilog -> Text["0", {0, -0.065}], ImageSize -> 250, PlotLabel -> "f(t) = -1+UnitStep[1-t]+UnitStep[t]\n", AxesLabel -> {"t", "f(t)"}]

fw = FourierTransform[ft, t, ω]

Simplify[fw, a > 0]

fm = (1/Sqrt[2*Pi])*Integrate[fst*Exp[I*ω*t], {t, -Infinity, Infinity}, Assumptions -> {a > 0 && Element[ω, Reals]}]

fw = InverseFourierTransform[fm, ω, t]

Plot[fw /. sa, {t, -1, 2}, PlotRange -> {0, 1.1}, PlotStyle -> Thick, ImageSize -> 250, PlotLabel -> "f(t) = [Sign(a - t) + Sign(t)]/2\n", AxesLabel -> {"t", "f(t)"}]

fss = UnitStep[a + t] + UnitStep[a - t] - 1

Plot[fss /. sa, {t, -2, 2}, PlotRange -> {0, 1.1}, PlotStyle -> Thick, PlotLabel -> "f(t) = -1 + UnitStep[1-t] + UnitStep[1 + t]\n", AxesLabel -> {"t", "f(t)"}, ImageSize -> 250]

fs = FourierCosTransform[fss, t, ω]

InverseFourierTransform[fs, ω, t]

Plot[% /. sa, {t, -2, 2}, PlotRange -> {0, 1.1}, PlotStyle -> Thick, AxesLabel -> {"t", "f(t)"}, ImageSize -> 250]; 

fi = InverseFourierCosTransform[fs, ω, t]

Simplify[fi, {a > 0 && Element[t, Reals]}]

Plot[Chop[fi /. sa], {t, -2, 2}]; 

fu = (-t)*UnitStep[-a + t] + t*UnitStep[a + t]

Plot[fu /. sa, {t, -2, 2}, PlotRange -> All, AxesLabel -> {"t", "fu(t)"}, PlotStyle -> Thick, ImageSize -> 250]

fut = FourierSinTransform[fu, t, ω]

Plot[fut /. sa, {ω, -15, 15}, AxesLabel -> {"ω", "Fu(ω)"}, PlotStyle -> Thick, ImageSize -> 300]

Integrate[Abs[x], x]

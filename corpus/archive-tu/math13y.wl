SetOptions[Plot, PlotStyle -> Thick]; , Null, p1 = Plot[Floor[x], {x, -3, 3}, AxesLabel -> {"x", "Floor[x]"}]; , Null, p2 = Plot[Ceiling[x], {x, -3, 3}, AxesLabel -> {"x", "Ceiling[x]"}]; , Null, p3 = Plot[Round[x], {x, -3, 3}, AxesLabel -> {"x", "Round[x]"}]; , Null, Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 600]

p1 = Plot[Sign[x], {x, -3, 3}, AxesLabel -> {"x", "Sign[x]"}, PlotStyle -> Thick]; , Null, p2 = Plot[Abs[x], {x, -3, 3}, AxesLabel -> {"x", "Abs[x]"}, PlotStyle -> Thick]; , Null, p3 = Plot[UnitStep[x], {x, -3, 3}, AxesLabel -> {"x", "θ[x]"}, PlotStyle -> Thick]; , Null, Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 550]

Information["FindMinimum", LongForm -> True]

f = Sin[x]

FindMinimum[f, x]

FindMinimum[f, {x, 3}]

FindMinimum[Abs[f], {x, 3}]

FindMinimum[{x*Cos[x], 1 <= x <= 15}, {x, 7}]

FindMinimum[{x*Cos[x], 15 <= x <= 30}, {x, 20}]

FindMinimum[Sin[x] + Cos[y], {x, 2}, {y, 4}]

f = Sin[x*y]

FindMinimum[f, {x, Pi/2}, {y, 0}]

FindMinimum[f, {x, Pi/2}, {y, Pi}]

FindMinimum[f, {x, 2.4, 2, 3}, {y, 2.4, 2, 3}]

FindMinimum[Abs[f], {x, 2.4, 2, 3}, {y, 2.4, 2, 3}]

FindMinimum[Abs[f], {x, 2.4, 3}, {y, 1.8, 2.2}]

Plot3D[Abs[f], {x, 2.5, 3.5}, {y, 1.8, 2.2}]

Information["FindMaximum", LongForm -> True]

FindMaximum[x*Cos[x], {x, 2}]

Plot[x*Cos[x], {x, 0, 14}, ImageSize -> 300]

FindMaximum[{x*Cos[x], 1 <= x <= 15}, {x, 7}]

FindMaximum[{x*Cos[x], 1 <= x <= 15}, {x, 12}]

FindMaximum[{-x - y, x + 2*y >= 3 && x >= 0 && y >= 0 && Element[y, Integers]}, {x, y}]

FindMaximum[{Sin[x]*Sin[2*y], x^2 + y^2 < 3}, {{x, 2}, {y, 2}}]

FindMaximum[{x + y, x^2 + y^2 <= 1 || (x + 2)^2 + (y + 2)^2 <= 1}, {x, y}]

SetPrecision[Pi, 55]

SetPrecision[BesselJ[2.5, 3.4445], 55]

N[BesselJ[5/2, 3.4445237609867234123465982342364999999999999999999999999999`31.537129184945282], 55]

fx = Together[Simplify[BesselJ[5/2, x]]]

N[fx /. x -> 3, 55]

N[fx /. x -> 3.4445237609867234123465982342364999999999999999999999999999`31.537129184945282, 55]

p = x^5 + 17.*x + 23.

so = NSolve[p == 0]

p /. so

Chop[p /. so]

Abs[x + I*y]

z = 3 + I*4

Abs[z]

Re[z]

Im[z]

Conjugate[z]

Arg[z]

N[%]

N[{Arg[-5 + 0.1*I], Arg[-5 - 0.1*I]}]

z = Exp[I*Pi]

Arg[z]

Limit[Arg[z + I*ϵ], ϵ -> 0, Direction -> Plus[1]]

Limit[Arg[z + I*ϵ], ϵ -> 0, Direction -> -1]

z = Exp[(-I)*Pi]

Arg[z]

Limit[Arg[z + I*ϵ], ϵ -> 0, Direction -> Plus[1]]

Limit[Arg[z + I*ϵ], ϵ -> 0, Direction -> -1]

z = x + I*y

Re[z]

Im[z]

ComplexExpand[Re[z]]

ComplexExpand[Im[z]]

Abs[z]

ComplexExpand[Abs[z]]

ComplexExpand[Abs[z], TargetFunctions -> {Re, Im}]

ComplexExpand[Abs[Exp[I*v]]]

ComplexExpand[Re[Sin[z]]]

ComplexExpand[Im[Tan[z]]]

E^(I*z)

ComplexExpand[%]

Z1 = I*ω*L + R

Z2 = (I*ω*CC)^(-1)

Z = Z1 + Z2

omr = Solve[ComplexExpand[Im[Z]] == 0, ω]

Z /. omr[[2]]

Y = Z1^(-1) + Z2^(-1)

Z = 1/Y

Z = ComplexExpand[Z, TargetFunctions -> {Re, Im}]

Y = FullSimplify[1/Z]

Y = ComplexExpand[Y, TargetFunctions -> {Re, Im}]

omr = Solve[ComplexExpand[Im[Y]] == 0, ω]

Yr = Y /. omr[[3]]

Yr = ExpandAll[Yr]

Zr = 1/Yr

Information["Random", LongForm -> True]

Random[]

RandomReal[{0, 1}, 3]

RandomReal[5, 6]

RandomComplex[]

RandomComplex[{0, 4 + 3*I}, WorkingPrecision -> 20]

RandomInteger[{0, 1}, 10]

RandomInteger[{100, 1000}, 10]

SeedRandom[143]; RandomReal[{0, 1}, 5]

SeedRandom[143]; RandomReal[{0, 1}, 5]

test = Sin[Cos[x]] == Cos[Sin[x]]

test /. x -> RandomReal[]

test /. x -> 3

test /. x -> 1/Sqrt[2]

N[Sin[Cos[x]] /. x -> Pi/4], Null, N[Cos[Sin[x]] /. x -> Pi/4]

Clear[x]; , Null, test = Product[N[Sin[x + 2*Pi*(k/5)]], {k, 0, 4}] == Sin[5*x]/16

test /. x -> RandomReal[]

Clear[x]; , Null, test = Product[Sin[x + 2*Pi*(k/5)], {k, 0, 4}] == Sin[5*x]/16

Simplify[ExpToTrig[Expand[TrigToExp[test[[1]]]]]]

N[100*Pi, 18]

RealDigits[%]

N[EulerGamma, 19]

RealDigits[%]

29!

FactorInteger[%]

PrimeQ[%%]

Divisors[8979]

FactorInteger[8979]

Fe[n_] = 2^2^n + 1

Table[{k, Fe[k]}, {k, 0, 7}]

Table[{k, PrimeQ[Fe[k]]}, {k, 0, 9}]

Timing[FactorInteger[Fe[7]]]

Timing[FactorInteger[Fe[8]]]

Timing[FactorInteger[Fe[9]]]

me = 2^67 - 1

FactorInteger[me]

Information["FactorInteger", LongForm -> True]

fi = Timing[FactorInteger[18402786717172645644535779054968269097752223096614652509534106463, Automatic]]

Timing[PrimeQ[fi[[2,4,1]]]]

Timing[FactorInteger[fi[[2,4,1]]]]

p1 = ListPlot[Table[Prime[n], {n, 100}]]; , Null, p2 = ListPlot[Table[PrimePi[n], {n, 100}]]; , Null, Show[GraphicsRow[{p1, p2}]]

Clear[fg, fi, fp], Null, fg[x_] = x/Log[x]; fi[x_] = LogIntegral[x]; fp[x_] = (3*x + 2*x*Log[x])/(2*Log[x]^2); 

Get["PlotLegends`"]

Plot[{PrimePi[x], fg[x], fi[x], fp[x]}, {x, 2, 10^4}, AxesLabel -> {"n", "f(n)"}, PlotStyle -> {GrayLevel[0], Hue[0.3], Hue[0.6], Hue[0]}, ImageSize -> 620, BaseStyle -> {FontSize -> 9}, LegendPosition -> {0.85, -0.45}, PlotLabel -> "π(n) and approximations to it", PlotLegend -> {"π(n)", "n/ln n", "li(n)", "fp(n)"}, ImageSize -> 600]

{nx = N[10^10], N[fg[nx]], N[fi[N[nx]]], N[fp[nx]], PrimePi[nx]}

IntegerPart[{nx = N[10^14], fg[nx], fi[nx], fp[nx], PrimePi[nx]}]

IntegerPart[{nx = N[10^15], fg[nx], fi[nx], fp[nx], PrimePi[nx]}]

Clear[x, ff], Null, (intv = Table[Point[{n, n!!}], {n, 0, 10}]; pts = 0.025; )*(ff[x_] = (2/Pi)^((1/4)*(1 - Cos[x*Pi]))*2^(x/2)*Gamma[1 + x/2]); , Null, p1 = Plot[ff[x], {x, 0, 3}, AxesLabel -> {"x", "x!!"}, PlotRange -> {0, 3.1}, Epilog -> {PointSize[pts], intv[[Range[1, 4]]]}]; 

p2 = Plot[ff[x], {x, 3, 6}, AxesLabel -> {"x", "x!!"}, PlotRange -> {0, 50}, Epilog -> {PointSize[pts], intv[[Range[4, 7]]]}]; 

p3 = Plot[ff[x], {x, 6, 10}, AxesLabel -> {"x", "x!!"}, PlotRange -> All, Epilog -> {PointSize[pts], intv[[Range[7, 11]]]}]; , Null, Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 600]

Clear[x, y, z], Null, p = Expand[(x + y + z)^5]

Coefficient[p, x^2*y^2*z]

Multinomial[2, 2, 1]

ClebschGordan[{l, m}, {1/2, 1/2}, {l + 1/2, m + 1/2}]

ThreeJSymbol[{l, m}, {1/2, 1/2}, {l + 1/2, -(m + 1/2)}]

ThreeJSymbol[{l, m}, {1/2, 1/2}, {l + 1/2, m + 1/2}]

% /. m -> 0

ThreeJSymbol[{l, m}, {1/2, 1/2}, {l + 1/2, -(m + 1/2)}]

ThreeJSymbol[{5, 0}, {2, 1}, {2, -1}]

Together[ThreeJSymbol[{4, 0}, {2, 1}, {2, -1}]]

Together[ThreeJSymbol[{4, -1}, {2, 2}, {2, -1}]]

Sqrt[(-2)^2]

Sqrt[-5]

ϵ = 10^(-10); 

Sqrt[-5 + I*ϵ]

Sqrt[-5 - I*ϵ]

Chop[N[Sqrt[-5 + I*ϵ], 5]]

Chop[N[Sqrt[-5 - I*ϵ], 5]]

cro = Plot3D[Re[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Re(z)"}]; 

cio = Plot3D[Im[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Im(z)"}]; 

sa = Plot3D[Abs[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Abs(z)"}]; 

aro = Plot3D[Arg[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Arg(z)"}]; 

Show[GraphicsGrid[{{cro, cio}, {sa, aro}}], ImageSize -> 500]

(cru = Plot3D[Re[-Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Re(z)"}]; )*(ciu = Plot3D[Im[-Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Im(z)"}]; )*(sa = Plot3D[Abs[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Abs(z)"}]; )*(aru = Plot3D[Arg[-Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Arg(z)"}]; )*Show[GraphicsGrid[{{cru, ciu}, {sa, aru}}], ImageSize -> 500]

cr = Show[cro, cru, PlotRange -> All, ViewPoint -> {1.3, -2.4, 0.13}, AxesEdge -> {{-1, -1}, {1, -1}, {-1, -1}}]; , Null, ci = Show[cio, ciu, PlotRange -> All, ViewPoint -> {1.3, -2.4, 0.13}, AxesEdge -> {{-1, -1}, {1, -1}, {1, 1}}]; , Null, GraphicsRow[{cr, ci}, ImageSize -> 500]

sr = Plot3D[Re[(x + I*y)^(1/3)], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Re(z)"}, PlotLabel -> "Re(z)"]; siu = Plot3D[Im[(x + I*y)^(1/3)], {x, -2, 2}, {y, -2, -0.001}, AxesLabel -> {"x", "y", "Im(z)"}, PlotLabel -> "Im(z)"]; sil = Plot3D[Im[(x + I*y)^(1/3)], {x, -2, 2}, {y, 0.001, 2}, AxesLabel -> {"x", "y", "Im(z)"}, PlotLabel -> "Im(z)"]; sl = Show[siu, sil, PlotRange -> All]; Show[GraphicsRow[{sr, sl}]]

sr = Plot3D[Re[Log[x + I*y]], {x, -2, 2}, {y, -2, 2}, PlotLabel -> "Re(Log(z))"]; , Null, si = Plot3D[Im[Log[x + I*y]], {x, -2, 2}, {y, -2, 2}, PlotLabel -> "Im(Log(z))"]; , Null, sa = Plot3D[Abs[Log[x + I*y]], {x, -2, 2}, {y, -2, 2}, PlotLabel -> "Abs(Log(z))"]; , Null, sg = Plot3D[Arg[Log[x + I*y]], {x, -2, 2}, {y, -2, 2}, PlotRange -> Pi*{-1, 1}, PlotLabel -> "Arg(Log(z))"]; , Null, Show[GraphicsRow[{sr, si}], ImageSize -> 500], Null, Show[GraphicsRow[{sa, sg}], ImageSize -> 500]

Table[Sin[Pi/n], {n, 16}]

ArcTan[Sqrt[3]]

ArcSin[2*(Sqrt[3]/2)]

SetOptions[Plot, DisplayFunction -> Identity]; s = Plot[ArcSin[x], {x, -1, 1}, AxesLabel -> {x, None}, PlotLabel -> "ArcSin(x)", Ticks -> {{-1, 0, 1}, {-(Pi/2), 0, Pi/2}}]; c = Plot[ArcCos[x], {x, -1, 1}, AxesLabel -> {x, None}, PlotLabel -> "ArcCos(x)", Ticks -> {{-1, 0, 1}, {0, Pi/2, Pi}}]; t = Plot[ArcTan[x], {x, -10, 10}, AxesLabel -> {x, None}, PlotLabel -> "ArcTan(x)", PlotRange -> {-(Pi/2), Pi/2}, Ticks -> {{-10, 0, 10}, {-(Pi/2), 0, Pi/2}}]; o = Plot[ArcCot[x], {x, -10, 10}, AxesLabel -> {x, None}, PlotLabel -> "ArcCot(x)", Ticks -> {{-10, 0, 10}, {-(Pi/2), 0, Pi/2}}]; Show[GraphicsGrid[{{s, c, t, o}}], ImageSize -> 550]

Clear[x], Null, usualarccot[x_] := If[x < 0, Pi + ArcCot[x], ArcCot[x]]

Plot[usualarccot[x], {x, -10, 10}, Ticks -> {Range[-10, 10, 5], Pi*(Range[0, 2]/2)}, PlotRange -> {0, Pi}, AxesLabel -> {"x", "arccot(x)"}, ImageSize -> 200]

ArcTan[-2, 3]

N[%]

ArcTan[-3/2]

N[%]

p1 = Plot3D[ArcTan[x, y], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {"x", "y", ""}, PlotLabel -> "ArcTan[x,y]"]; 

p2 = Plot3D[ArcTan[y/x], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {"x", "y", ""}, PlotLabel -> "ArcTan[y/x]"]; 

Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

{ArcSin[2 + 0.1*I], ArcSin[2 - 0.1*I], ArcSin[2.]}

SetOptions[Plot3D, Boxed -> False]; sr = Plot3D[Re[ArcSin[x + I*y]], {x, -3, 3}, {y, -2, 2}, AxesLabel -> {x, y, Re}, PlotPoints -> 50]; si = Plot3D[Im[ArcSin[x + I*y]], {x, -3, 3}, {y, -2, 2}, AxesLabel -> {x, y, Im}, PlotPoints -> 50]; Print["                          ArcSin"]*Show[GraphicsRow[{sr, si}], ImageSize -> 450]

sr = Plot3D[Re[ArcTan[x + I*y]], {x, -3, 3}, {y, -2, 2}, AxesLabel -> {x, y, Re}, PlotPoints -> 50, ViewPoint -> {-4, 2, 2}]; si = Plot3D[Im[ArcTan[x + I*y]], {x, -3, 3}, {y, -2, 2}, AxesLabel -> {x, y, Im}, PlotPoints -> 50]; Print["                      ArcTan"]*Show[GraphicsRow[{sr, si}], ImageSize -> 450]

SetOptions[Plot, DisplayFunction -> Identity]; , Null, s = Plot[ArcSinh[x], {x, -3, 3}, AxesLabel -> {x, "ArSinh(x)"}]; , Null, c = Plot[ArcCosh[x], {x, 1, 3}, AxesLabel -> {x, "ArCosh(x)"}]; , Null, Show[GraphicsRow[{s, c}], ImageSize -> 450]

s = Plot[ArcTanh[x], {x, -1, 1}, AxesLabel -> {x, "ArTanh(x)"}]; , Null, c = Plot[ArcCoth[x], {x, -4, 4}, AxesLabel -> {x, "ArCoth(x)"}, PlotRange -> {-4, 4}]; , Null, Show[GraphicsRow[{s, c}], ImageSize -> 450]

SetOptions[Plot3D, PlotPoints -> 20, ViewPoint -> {-4, -2, 4}, Boxed -> False]; , Null, r = Plot3D[Re[ArcSinh[x + I*y]], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {x, y, Re}]; , Null, i = Plot3D[Im[ArcSinh[x + I*y]], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {x, y, Im}]; , Null, Print["                               ArSinh"], Null, Show[GraphicsRow[{r, i}], ImageSize -> 450]

r = Plot3D[Re[ArcCosh[x + I*y]], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {x, y, Re}]; , Null, i = Plot3D[Im[ArcCosh[x + I*y]], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {x, y, Im}]; , Null, Print["                             ArCosh"], Null, Show[GraphicsRow[{r, i}], ImageSize -> 450]

$Version

e = Expand[(1 + 3*x + 4*y^2)^2]

Coefficient[e, x]

Coefficient[e, y]

Coefficient[e, y^2]

Exponent[e, y]

pp = 17 + 2*x*y^2 + 3*x^3*y

CoefficientList[pp, x]

CoefficientList[pp, y]

CoefficientList[pp, {x, y}]

CoefficientList[pp, {y, x}]

Exponent[pp, x]

Exponent[pp, y]

e[[5]]

f = 2/3

Denominator[f]

Numerator[f]

s

Numerator[s]

Denominator[s]

p1 = x^3 - 1

p2 = x - 1

PolynomialQuotient[p1, p2, x]

PolynomialRemainder[p1, p2, x]

Factor[p1]

p1 = x^3 - 2

Factor[p1]

PolynomialQuotient[p1, p2, x]

PolynomialRemainder[p1, p2, x]

PolynomialRemainder[x^2, x + 1, x]

PolynomialQuotient[x^2, x + 1, x]

{PolynomialRemainder[x + y, x - y, x], PolynomialRemainder[x + y, x - y, y]}

p1 = (x + 2)*(x + 1)*(x + 3); p1 = Expand[p1]

p2 = (x + 3)*(x + 2)*(x - 1); p2 = Expand[p2]

Factor[PolynomialGCD[p1, p2]]

Factor[PolynomialLCM[p1, p2]]

p1 = (Sqrt[2] - x)*(x + 1)*(x + Sqrt[2])^2; p1 = Expand[p1]

Clear[a], Null, p2 = x^3 + 3*x^2 + a; p2 = Expand[p2]

Solve[p1 == 0, x]

Solve[p2 == 0, x]

Resultant[p1, p2, x]

Union[Solve[% == 0, a]]

Factor[p1], Null, Factor[p2]

Resultant[(x - y)^2 - 2, y^2 - 3, y]

Resultant[(x - y)^2 - 2, y^2 - 3, x]

Factor[x^2 - 2]

Factor[x^2 - 2, Extension -> {Sqrt[2]}]

Factor[x^2 + 2, Extension -> {I, Sqrt[2]}]

Factor[3*x^2 - 2*y^2, Extension -> {Sqrt[2], Sqrt[3]}]

ff = Factor[x^3 - 2, Extension -> {2^(1/3)}]

so = Solve[ff[[3]] == 0]

Factor[x^3 - 2, Extension -> {I, Sqrt[3], 2^(1/3)}]

Clear[α], Null, pa = α^3 - 2; 

pr = Expand[(a1 + b1*α + c1*α^2)*(a2 + b2*(α + c2*α^2))]

PolynomialRemainder[pr, pa, α] - (a + b*α + c*α^2)

Thread[CoefficientList[%, α] == Table[0, {Exponent[pa, α]}]]

sopr = Flatten[Solve[%, {a, b, c}]]

CoefficientList[PolynomialRemainder[(a1 + b1*α + c1*α^2)*(a + b*α + c*α^2), pa, α], α] == {1, 0, 0}; 

Flatten[Solve[%, {a1, b1, c1}]]

Solve[x^6 == 1, x]

p = 3 + 3*x - 7*x^2 - x^3 + 2*x^4 + 3*x^7 - 3*x^8 - x^9 + x^10

Solve[p == 0, x]

N[%, 30]

q = x^6 - 9*x^4 - 4*x^3 + 27*x^2 - 36*x - 23

Solve[q == 0, x]

Factor[q]

x1 = 2^(1/3) + 3^(1/2); N[%]

q /. x -> x1

ExpandAll[%]

RootReduce[%%]

x2 = 2^(1/3) - 3^(1/2); N[%]

Factor[q]

Factor[q, Extension -> {x1, x2}]

tr = Table[{x -> 2^(1/3)*E^(I*2*Pi*(k/3)) + Sqrt[3]*(-1)^n}, {k, 3}, {n, 2}]

FullSimplify[q /. tr]

Solve[(Sqrt[-x] - a)^2 == b^2, x]

Solve[(Sqrt[-x] - a)^2 == 1.*b^2, x]

p = x^3 + x^2 - 20*x - 9; 

Solve[p == 0, x]

Chop[N[%]]

ComplexExpand[x /. %]

eq = a*x^4 + b*x^3 + c*x^2 + d*x + e == 0

Solve[eq, x]

p = x^3 + 2*x - 2

so = Solve[p == 0]

(x /. so[[2]])*(x /. so[[3]])

RootReduce[%]

ToRadicals[%]

Clear[a, b, x, y, r], Null, eq = x^2 + 12*x + y^2 - 20*y + 15 == (x - a)^2 + (y - b)^2 - r^2; , Null, Solve[eq, {a, b, r}]

soa = SolveAlways[eq, {x, y}]

eq /. soa

FullSimplify[%]

Reduce[Abs[-3 + x] <= (x + 1)*Abs[4 + x], x, Reals]

v0 = N[Last[%]]

Plot[-Abs[-3 + x] + (x + 1)*Abs[4 + x], {x, -5, 1}, PlotRange -> {-9, 4}, AspectRatio -> 0.3, Epilog -> {Thickness[0.01], Hue[0], Line[{{v0, 0}, {1.1, 0}}]}]

Reduce[x*(x^2 - 2)*(x^2 - 3) > 0, x, Reals]

Plot[x*(x^2 - 2)*(x^2 - 3), {x, -2, 2}, PlotRange -> 3*{-1, 1}, AspectRatio -> 0.4, Epilog -> {Thickness[0.01], Hue[0], Line[{{-Sqrt[3], 0}, {-Sqrt[2], 0}}], Line[{{0, 0}, {Sqrt[2], 0}}], Line[{{Sqrt[3], 0}, {2.1, 0}}]}]

Clear[x1, x2, x3]*tx = {x1, x2, x3^2}; 

ma = {{2, 1, 3}, {4, 3, 5}}; MatrixForm[ma]

Thread[ma . tx <= {7, 9}]; sys = {ungl1, ungl2} = %

Reduce[Join[sys, {x1 == 0 || x1 == 1, x2 == 0 || x2 == 1, x3 == 0 || x3 == 1}], {x1, x2, x3}]

sos = {{x1 -> 0, x2 -> 0, x3 -> 0}, {x1 -> 0, x2 -> 0, x3 -> 1}, {x1 -> 0, x2 -> 1, x3 -> 0}, {x1 -> 0, x2 -> 1, x3 -> 1}, {x1 -> 1, x2 -> 0, x3 -> 0}, {x1 -> 1, x2 -> 0, x3 -> 1}, {x1 -> 1, x2 -> 1, x3 -> 0}}; 

sys /. sos

Solve[Cos[x] == 0, x]

Solve[Sin[x] + 3*Cos[x] == 0, x]

N[%]

FindRoot[Sin[x] + 3*Cos[x], {x, 2.1}]

f = z^2 + Conjugate[z] + 2*I

FindRoot[f, {z, 1 + 2*I}]

f /. %

Plot3D[Abs[f /. z -> x + I*y], {x, -3, 3}, {y, -3, 3}]

FindRoot[f, {z, 2 - 2*I}]

f /. %

FindRoot[f, {z, -1}]

f /. %

Clear[x, fx]

fx = Sin[x] + x - 2; 

p1 = Plot[E^Abs[x] - 2, {x, -1, 1}, PlotLabel -> "\!\(\*SuperscriptBox[\(\), \(Abs[x]\)]\) - 2\n"]; , Null, p2 = Plot[fx, {x, 0, 2}, PlotLabel -> fx]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 400], Null

FindRoot[E^Abs[x] == 2, {x, 1}]

FindRoot[fx, {x, 1}, MaxIterations -> 50, AccuracyGoal -> 24, WorkingPrecision -> 34]

fx /. %

Solve[{x^3 - y^2 == 0, x + y == 2}, {x, y}]

ContourPlot[{x^3 - y^2 == 0, x + y == 2}, {x, 0, 2}, {y, 0, 2}]

FindRoot[{x^3 - y^2, x + y - 2}, {x, 1}, {y, 2}]

FindRoot[{x^3 - y^2, x + y - 2}, {x, I}, {y, 2*I}]

Chop[%]

FindRoot[{x^3 - y^2, x + y - 2}, {x, I}, {y, -2*I}]

Chop[%]

FindRoot[{x^3 - 2*y^2, x + y - 2}, {x, I}, {y, -2*I}, AccuracyGoal -> 24, WorkingPrecision -> 34]

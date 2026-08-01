f = x

h = f^2

g = "f^2"

g

FullForm[g]

f = 2*x^3

f = Pi^5; 

f

1/2 + 1/3

%

f = %

f

Out[11]

z = 2^1000

(2/5)^5

2/5^5

0.2^5

N[z]

SetPrecision[z, 20]

N[z, 20]

N[z]

%

Out[7] + Out[8]

f = x

f^2 + 2*f

f = Pi

1.1*f

N[Pi]

Cos[Pi/6]

Cos[Pi/8]

Cos[Pi/12]

N[%, 12]

SetPrecision[%%, 25]

Cos[%]

Cos[Pi/13]

N[%]

Exp[I*(Pi/4)]

N[%]

(1 + I)/Sqrt[2]

N[%]

f = (a + b)*(a - b)

g = Expand[f]

Factor[g]

g/(a - b)

Factor[%]

g = (a^3 - b^3)/(a - b)

Simplify[g]

Factor[g]

g = (a^7 - b^7)/(a - b)

Simplify[g]

Factor[g]

h = g /. b -> 3

g

x = 3

f = (x + a)^2

Clear[x]; f = (x + a)^2

Expand[f]

(* UNCONVERTED CELL *)

f

Remove[f], Null, Null

LegendreP[5, x]

LegendreP[5, Cos[θ]]

z = 3 + 4*I

Re[z]

Im[z]

Abs[z]

Conjugate[z]

Abs[z]

Abs[z*Exp[I*(Pi/4)]]

Sin[z]

Abs[%]

z = a + b*I

Abs[z]

Plot[x^3 - x + 1, {x, -2, 2}]

ParametricPlot[{Cos[t]^2, Sin[t]^3}, {t, 0, 2*Pi}]

Plot3D[Sin[x*y], {x, -2, 2}, {y, -2, 2}]

ParametricPlot3D[{2*Cos[t]*Cos[p], 3*Cos[t]*Sin[p], 4*Sin[t]}, {t, 0, Pi}, {p, 0, 2*Pi}]

Show[%, ViewPoint -> {1, 0.5, -3}]

Clear[a, x, y]

D[Sin[a*x], x]

D[Sin[ax], x]

D[Sin[a*x], {x, 3}]

D[Sin[a*x]*Cosh[b*y], {x, 3}, {y, 5}]

Clear[a]

Integrate[Exp[a*x], x]

Integrate[Exp[(-a)*x]*Cos[b*y], x, y]

Integrate[Sin[a*x], {x, 0, Pi/2}]

Together[%]

Simplify[%]

NIntegrate[Sin[3*x], {x, 0, 0.45}]

Series[Sin[x], {x, 0, 5}]

Series[Cot[x], {x, 0, 5}]

Simplify[Series[Sqrt[1/(1 + a*x + b*x^2)], {x, 0, 3}]]

Series[Log[x], {x, 1, 5}]

f = Series[Cos[x], {x, 0, 5}]

g = Series[Sin[x], {x, 0, 5}]

f*g

f/g

Normal[f/g]

Integrate[%, x]

ma = {{12, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {12, 10, -2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2}, {0, -4, 8, -1, 0, 0, 0, -3, 1, 1, 0, 0, 0, 0}, {0, 2, 0, 12, 1, 0, 0, 0, -1, -1, 0, 0, 0, 0}, {12, 0, 0, 2, 8, -1, -1, 0, -1, -1, 0, 0, 0, 0}, {0, -2, 1, 0, -2, 6, 1, 0, 0, 2, -1, 0, 0, 0}, {0, -2, 1, 0, -2, 1, 6, 0, 2, 0, -1, 0, 0, 0}, {0, 0, -2, 0, 1, 0, 0, 6, 0, 0, 0, 0, 0, 0}, {0, -1, 1, -2, -1, 0, 1, 0, 8, 0, 0, 0, 2, -2}, {0, -1, 1, -2, -1, 1, 0, 0, 0, 8, 0, 0, 2, -2}, {0, 2, 0, 2, 0, -1, -1, 0, 0, 0, 6, -2, -4, 0}, {0, 0, 0, 0, -2, 0, 0, 0, 0, 0, -2, 4, 0, -2}, {-6, 0, 0, 0, 0, 0, 0, 0, 1, 1, -1, 0, 8, 0}, {0, 2, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 8}}; 

Timing[Det[ma]]

im = Timing[Inverse[ma]]; 

im[[1]]

im[[2,1]]

Timing[Eigenvalues[N[ma]]]

Null

b = ma - x*IdentityMatrix[14]; f = Timing[Det[b]]

Factor[f[[2]]]

sys = {5*x + 1*y == 3, 4*x - 3*y == 2}

Solve[sys, {x, y}]

sol = Flatten[%]

sys /. sol

Solve[{5*x + 1*y == 3., 4*x - 3*y == 2}, {x, y}]

ma = {{5, 1}, {4, -3}}; MatrixForm[ma]*b = {3, 2}*mx = {x, y}*ma . mx == b

Thread[ma . mx == b]

Inverse[ma] . b

Solve[{x - y == 1, 3*x - 3*y == 3}, {x, y}]

Solve[{x - y == 1, 3*x - 3*y == 2}, {x, y}]

Clear[p2, x, a, b, c]*p2 = a*x^2 + b*x + c

sol = Solve[p2 == 0, x]

p2 /. sol

Simplify[%]

Solve[x^4 - 1 == 0]

Solve[x^4 + 1 == 0]

Solve[x^4 + 1 == 0.]

p3 = x^3 + x + 1

sn = NSolve[p3 == 0]

p3 /. sn

Chop[%]

s3 = Solve[p3 == 0]

N[%]

p3 /. s3

Together[%]

p5 = x^5 - x + 1

s5 = Solve[p5 == 0]

ns5 = N[%]

p5 /. ns5

Clear[a, x, y, z]

p3 = x^3 + x + 1

s1 = FindRoot[p3, {x, 1}]

s2 = FindRoot[p3, {x, I}]

s3 = FindRoot[p3, {x, -I}]

so = {s1, s2, s3}

p3 /. so

Solve[Cos[x] == 0, x]

Information["Reduce", LongForm -> False]

Reduce[Cos[x] == 0, x]

Solve[Sin[x] + Cos[x] == 0, x]

FindRoot[Sin[x] + Cos[x], {x, 2.1}]

Solve[{x^3 - y^2 == 0, x + y == 2}, {x, y}]

ContourPlot[{x^3 - y^2 == 0, x + y == 2}, {x, -2, 2}, {y, 0, 2}]

FindRoot[{x^3 - y^2, x + y - 2}, {x, 1}, {y, 2}]

FindRoot[{x^3 - y^2, x + y - 2}, {x, I}, {y, 2*I}]

f = z^2 + Conjugate[z]

FindRoot[f, {z, 1}]

FindRoot[f, {z, 1, I}]

Clear[k, x, y]

DSolve[Derivative[1][Derivative[1][y]][x] + k*y[x] == 0, y[x], x]

DSolve[Derivative[1][Derivative[1][y]][x] + 2*(Derivative[1][y][x]/x) - l*((l + 1)/x^2)*y[x] + k^2*y[x] == 0, y[x], x]

Clear[t, x, y, g]; DSolve[{Derivative[1][Derivative[1][x]][t] == 0, Derivative[1][Derivative[1][y]][t] + g == 0, x[0] == 0, Derivative[1][x][0] == v0, y[0] == 5, Derivative[1][y][0] == 0}, {x[t], y[t]}, t]

Clear[r, v, b, t, x, y]

r[t_] = {x[t], y[t]}

v[t_] = D[r[t], t]

b[t_] = D[v[t], t]

m = 1; g = 10; a = 0.3; sys = m*b[t] == {0, (-m)*g}

sys = Thread[sys]

sysa = Thread[m*b[t] == {0, (-m)*g} - a*v[t]*Sqrt[Derivative[1][x][t]^2 + Derivative[1][y][t]^2]]

anf = {x[0] == 0, y[0] == 0, Derivative[1][x][0] == 2, Derivative[1][y][0] == 10}

sol = Flatten[NDSolve[Join[sys, anf], {x, y}, {t, 0, 4}]]

sola = Flatten[NDSolve[Join[sysa, anf], {x, y}, {t, 0, 2}]]

p = ParametricPlot[Evaluate[{x[t], y[t]} /. sol], {t, 0, 2}], Null, pa = ParametricPlot[Evaluate[{x[t], y[t]} /. sola], {t, 0, 1.35}, PlotStyle -> Dashing[{0.01}]]

Show[p, pa]

Get["VectorAnalysis`"]

SetCoordinates[Cartesian[x, y, z]]

Grad[psi[x, y, z]]

Div[{ax[x, y, z], ay[x, y, z], az[x, y, z]}]

Curl[{ax[x, y, z], ay[x, y, z], az[x, y, z]}]

SetCoordinates[Spherical[r, the, phi]]

Grad[psi[r, the, phi]]

Expand[Div[{ar[r, the, phi], ath[r, the, phi], aph[r, the, phi]}]]

Expand[Curl[{ar[r, the, phi], ath[r, the, phi], aph[r, the, phi]}]]

Expand[Laplacian[psi[r, the, phi]]]

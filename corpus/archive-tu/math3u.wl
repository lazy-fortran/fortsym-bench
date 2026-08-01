Tan[Pi/4]

Cot[Pi/3]

N[%]

Log[1]

Log[I]

N[%]

N[Log[I*Pi]]

Factor[(x^9 - a^9)/(x - a)]

Expand[%]

Factor[x^4 + 2*x^3 - 13*x^2 - 14*x + 24]

Expand[%]

Clear[y]

Expand[(x + y)^12]

z = 2 + I*Pi

Re[z]

Im[z]

N[%]

Conjugate[z]

N[%]

Abs[z]

N[%]

p = LegendreP[7, Cos[θ]]

N[p /. θ -> Pi/8]

Plot[x^2 - 5*x + 1, {x, -2, 7}]

f = {Cos[t], Cos[2*t + a]}

ParametricPlot[f /. a -> 0, {t, 0, 2*Pi}]

ParametricPlot[f /. a -> Pi/3, {t, 0, 2*Pi}]

ParametricPlot[f /. a -> Pi/2, {t, 0, 2*Pi}]

Plot3D[(x/2)^2 - (y/3)^2, {x, -5, 5}, {y, -5, 5}]

ParametricPlot3D[{(2 + Cos[t])*Cos[p], (2 + Cos[t])*Sin[p], Sin[t]}, {t, 0, Pi}, {p, 0, 2*Pi}]

D[x^2 - 5*x + 1, x]

D[{Exp[2*a*x^2]*Cos[c*x], Tan[Exp[3*x]], Sin[a*x]*Cos[b*x]}, x]

D[(x/2)^2*(y/3)^4, x]

D[(x/2)^2*(y/3)^4, y]

f = x^20*Exp[x]

NIntegrate[f, {x, 0, 1}]

fi = Integrate[f, {x, 0, 1}]

N[fi]

N[fi, 20]

fs = Series[f, {x, 0.2, 20}]

NIntegrate[Normal[fs], {x, 0, 1}]

f = Series[Sin[Sin[x]], {x, 0, 7}]

f = Series[Tan[x], {x, Pi/2, 3}]

m = {{1, 0, 4}, {0, 5, 4}, {-4, 4, 3}}

Det[m]

im = Inverse[m]

Eigenvalues[N[m]]

b = m - x*IdentityMatrix[3]

Det[b]

Clear[x, y, z, a, b, c, f]

Solve[{x + y + z == 1, x + 2*y + 3*z == 4, x + 3*y + 6*z == 10}, {x, y, z}]

Clear[x, y, z, a, b, c, d, f], Null, sys = {a*x + b*y == c, c*x + d*y == f}

Simplify[Solve[sys, {x, y}]]

ma = {{a, b}, {c, d}}; MatrixForm[mat]

v = {c, f}

mx = {x, y}

Simplify[Inverse[ma] . v]

p5 = x^5 + x - 1

sa = Solve[p5 == 0]

nsa = N[sa]

sn = NSolve[p5 == 0]

Simplify[p5 /. sa]

N[%]

p5 /. nsa

p5 /. sn

p5 = x^5 - 13*x^4 + 7

sa = Solve[p5 == 0]

nsa = N[sa]

sn = NSolve[p5 == 0]

p5 /. sa

N[%]

p5 /. nsa

p5 /. sn

f = Sin[x] - Cos[x]

{FindRoot[f == 0, {x, -0.5}], FindRoot[f == 0, {x, 0.5}]}

f /. %

g = (Tan[x] - x)/(x/3 + Cos[x])

Plot[g, {x, -3, 3}]

Plot[1/g, {x, -3, 3}]

FindRoot[1/g == 0, {x, -2}]

FindRoot[1/g == 0, {x, -1}]

FindRoot[g == 0, {x, 0}]

FindRoot[1/g == 0, {x, 1}]

FindRoot[1/g == 0, {x, 1.9}]

FindRoot[1/g == 0, {x, 3}]

Clear[x, y, t, v]

r[t_] = {x[t], y[t]}

v[t_] = D[r[t], t]

a[t_] = D[v[t], t]

m = 1; g = 10; c = 0.3; 

sys = Thread[m*a[t] == {0, (-m)*g} - c*v[t]]

anf = {x[0] == 0, y[0] == 0, Derivative[1][x][0] == 2, Derivative[1][y][0] == 10}

sol = Flatten[NDSolve[Join[sys, anf], {x, y}, {t, 0, 2}]]

ParametricPlot[{x[t], y[t]} /. sol, {t, 0, 1.83}]

Get["VectorAnalysis`"]

Clear[r, ϕ, z]

SetCoordinates[Cylindrical[r, ϕ, z]]

Grad[ψ[r, ϕ, z]]

F = {ar[r, ϕ, z], ap[r, ϕ, z], az[r, ϕ, z]}

Div[F]

Curl[F]

SetCoordinates[Cartesian[x, y, z]]

Simplify[Div[Grad[ψ[x, y, z]]]]

Simplify[Laplacian[ψ[x, y, z]]]

SetCoordinates[Spherical[r, ϕ, θ]]

Simplify[Div[Grad[ψ[r, ϕ, θ]]]]

Simplify[Laplacian[ψ[r, ϕ, θ]]]

SetCoordinates[Cylindrical[r, ϕ, z]]

Simplify[Div[Grad[ψ[r, ϕ, z]]]]

Simplify[Laplacian[ψ[r, ϕ, z]]]

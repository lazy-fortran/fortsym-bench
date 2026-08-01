FullForm[%]*(1 + x^2 + (y + z)^2)

FullForm[Sqrt[a + x]]

FullForm[a + b*I]

Hold[a != b]

FullForm[D[f[x, y, z], {x, 7}, {y, 3}, {z, 2}]]

D[Sin[a*x]*Exp[b*y], {x, 3}, {y, 2}]

FullForm[D[Sin[a*x]*Exp[b*y], {x, 3}, {y, 2}]]

FullForm[Expand[(x + y)^2]]

FullForm[Series[Sin[x], {x, 0, 3}]]

g[x_, c_] := Sin[c*x], Null, c = 0.3; , Null, FullForm[Plot[g[x, c], {x, 0, 2*Pi}, PlotPoints -> 7, PlotRange -> {0, 1}]]

FullForm[FindRoot[Sin[x] + Cos[x], {x, 1}]]

FindRoot[Sin[x] + Cos[x], {x, 1}]

FullForm[Integrate[x^2/(x^2 + y^2 + z^2), x]]

Integrate[x^2/(x^2 + y^2 + z^2), x]

eq = f1 = a + bx + (c/2)*x^2 + d*3.33*y + Pi*z^3 == 0

FullForm[%]

sig[x_] = FullForm[If[x > 0, 1, 0]]

FullForm[Which[x >= 2, 2, x > 0, 1, x <= 0, 0]]

DSolve[Derivative[1][y][x] == a*y[x], y[x], x]

FullForm[DSolve[Derivative[1][y][x] == a*y[x], y[x], x]]

FullForm[DSolve[Derivative[1][y][x] == a*y[x], y, x]]

s = NDSolve[{Derivative[1][y][x] == 2*y[x], y[0] == 1}, y, {x, 0, 3}]

FullForm[s]

sn = 1234567890

Head[sn]

FullForm[sn]

Characters[sn]

st = "1234567890"

Head[st]

FullForm[st]

sv = Characters[st]

Position[sv, 5]

sw = FullForm[sv]

s9 = "9"

Position[sv, s9]

lp = Characters[ToString[Pi]]

np = N[Pi, 17]

lp = Characters[ToString[%]]

Position[lp, s9]

f = {u[2] - 2*u[1] + u[0], u[3] - 2*u[2] + u[1]}

FullForm[f]

u[i_] := ToExpression[StringJoin["u", ToString[i]]]

f

lx = {"x1", "x2", "x3"}

FullForm[lx]

StringJoin[lx]

Characters[lx]

StringJoin[%]

D[lx, x1]

D[ToExpression[lx], x1]

Clear[f]

FullForm[N[Pi]]

FullForm[N[Pi]]

FullForm[N[Pi]]

f[Clear[f]*x + y + z]

f[x + y - z]

f[x] + y

f[x + y]

Clear[a, b, c]

{a, b, c}[[2]]

(a + b + c)[[2]]

(a + b + c)[[-1]]

(a + b + c)[[0]]

Head[a + b + c]

(a*b*c)[[1]]

(a*b*c)[[0]]

h = f[g[a], g[b]]

FullForm[h]

h[[0]]

h[[1]]

h[[2]]

h[[3]]

h[[1,1]]

h[[1,0]]

FullForm[x/y]

(x/y)[[1]]

(x/y)[[1,1]]

(x/y)[[2]]

(x/y)[[2,1]]

(x/y)[[2,0]]

(x/y)[[2,2]]

t = 1 + (3 + x)^2/y

FullForm[t]

h = TreeForm[t]

Depth[t]

(* UNCONVERTED CELL *)

Position[t, Plus]

h = TreeForm[(x + y)^2 + (a*x - z)^3]

h = TreeForm[(x + y)^2 + (a*x - z)^3]

Depth[h]

Position[h, x]

Position[h, x, {5}]

Position[h, Times]

Position[h, Power]

Position[h, Plus]

Level[h, 1]

Level[h, 2]

Level[h, 5]

Level[h, 6]

t = 1 + (3 + x)^2/y

FullForm[t]

t[[2,1,1]] = x

t

FullForm[t]

t = 1 + (3 + x)^2/y

t[[2,1,1,1]] = 4

t

t[[2,1,2]] = z

t

t[[2,2,2]]

t[[2,2,1]]

t[[2,2,1]] = w

t

{a, b, c, d, e}[[{2, 4}]]

h = a + b + c + d + e

FullForm[h]

h[[{2, 4}]]

h[[2,4]]

ReplacePart[h, aa, 5]

a + b + c + d

ReplacePart[%, x^2, 3]

ReplacePart[a + b + c + d, x^2, 3]

h = (x + y)^2 + (a*x - z)^3

Position[h, x]

h1 = ReplacePart[h, w, %[[2]]]

Position[h1, 3]

ReplacePart[h1, 4, Flatten[%]]

t = 1 + (3 + x)^2/y

FullForm[t]

ReplacePart[t, w, 2]

ReplacePart[t, w, {2, 1}]

ReplacePart[t, w, {2, 2}]

ReplacePart[t, w, {2, 2, 1}]

ReplacePart[t, w, {2, 2, 2}]

t = 1 + (3 + x)^2/y

tt = t /. {y -> w, 3 -> 4, 2 -> 7}

(* UNCONVERTED CELL *)

ttt = tt /. Plus -> Minus

ttt

Clear[x], Null, -x

FullForm[%]

t = 1 + x + x^2 + x^3

Take[t, 2]

Take[t, -2]

Take[t, {2, 3}]

Take[t, {-1, 4}]

Take[t, {-2, 4}]

h = (x + y)^2 + (a*x - z)^3

po = Position[h, a*x - z]

g = ReplacePart[h, 1, po]

f = ((1 - x)^2*(x^2 + 1)^2)^(-1)

g = Expand[Integrate[f, x]]

TreeForm[g]

g3 = Take[g, 3]

g[[3]]

g12 = Take[g, 2]

g[[{4, 5}]]

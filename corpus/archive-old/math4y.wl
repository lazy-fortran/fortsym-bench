$Version

Clear[f, x, y, c]; , Null, f[x_, y_] = x^2 + y^2 - c

f[a, b]

f[2, 5]

c = 13.3

f[2, 5]

f[a, b]

Clear[c]*f[a, b]

f[x_] = x^3 + x - 1

sf = NSolve[f[x] == 0, x]

x = 37

f[x_] = x^3 + x - 1

f[d]

Clear[p, x]*p[0, x] = 1; p[1, x] = x; p[((n_)?NonNegative)?IntegerQ, x] := p[n, x] = (((2*n - 1)/n)*x)*p[n - 1, x] + p[n - 2, x]*((n - 1)/n); 

Apart[p[5, x]]

LegendreP[5, x]

p[0.5, x]

LegendreP[0.5, x]

LegendreP[-6, x]

Clear[fib]; fib[0] = fib[1] = 1; , Null, fib[n_] := fib[n - 1] + fib[n - 2]; , Null, nt = Table[Timing[{k, fib[k]}], {k, 2, 25}]; , Null, nt[[Range[1, 14]]]

tp = Table[{nt[[k,2,1]], nt[[k,1]]}, {k, Length[nt]}]; , Null, ListPlot[tp, PlotRange -> All, AxesLabel -> {"n", "time [s]"}, PlotLabel -> "time for computing the n-th \nFibonacci number\n\n"], Null

Clear[fib]; fib[0] = fib[1] = 1; , Null, fib[n_] := fib[n] = fib[n - 1] + fib[n - 2]; , Null, dt = Timing[Table[{k, fib[k]}, {k, 2, 200}]]; dt[[1]]

dm = Timing[Table[{k, Fibonacci[k]}, {k, 2, 200}]]; dm[[1]]

Clear[a, b, c, x], Null, expr = a*x + b*x^2, Null, D[expr, x]

% /. {a -> 1, b -> 2, x -> c}

Clear[f, a, b, x], Null, f[a_, b_][x_] := a*x + b*x^2, Null, Derivative[1][f[1, 2]][c]

Clear[g]*g[x_] := x /. Plus -> Times

g[a + b + c]

p[x_] := x^2 /; x > 0; p[x_] := -x^2 /; x <= 0

{p[1], p[0.5], p[0], p[-0.5], p[-1]}

Clear[f, n]

f[((n_)?Positive)?IntegerQ] = n!, Null, f[n_] := Print["f expects a positive integer argument"]

f[3]

f[-4]

f[2.2]

(#1^2 & )[x]

(#1^2 & )[a]

(N[#1, 22] & )[Pi]

h = z

h1 = h /. z -> 44

h

h1

Clear[x, y, f]*f[x_, y_] = x^2 + y^2 - c

h = f[x, y]

h1 = h /. c -> 13.3

h

h1

h2 = h1 /. {x -> a, y -> b}

x = 4*y = 5

h

h1

h2

f[p, q]

f[x, y]

Clear[a, b, c, d, e, f, u, v, w, x, y]

u = (a + b)^2; v = (c + d)^2; w = (e + f)^2; 

uv = Expand[u + v + w]

uv /. (x_)^2 + 2*(x_)*(y_) + (y_)^2 -> (x + y)^2

uv //. (x_)^2 + 2*(x_)*(y_) + (y_)^2 -> (x + y)^2

5!

5!!

Clear[m, n, k]

Gamma[m + 3] /. Gamma[(n_) + (k_) /; OddQ[2*k]] -> ((2*k + 2*n - 2)!!*Sqrt[Pi])/2^(k - 1/2 + n)

Gamma[m + 5/2] /. Gamma[(n_) + (k_) /; OddQ[2*k]] -> ((2*k + 2*n - 2)!!*Sqrt[Pi])/2^(k - 1/2 + n)

% /. m -> 4

%% /. m -> 4.3

su = x :> t

f = x^2

f /. su

t = 5; , Null, f /. su

Clear[t], Null, f /. su

Clear[p, s, x, y]

x = 4

s = x^2

p := x^2

x = 5

Print[s]

Print[p]

Clear[x]; ex[x_] := Expand[(1 + x)^2]

Information["ex", LongForm -> False]

iex[x_] = Expand[(1 + x)^2]

Information["iex", LongForm -> False]

rd = ex[y + 2]

ri = iex[y + 2]

rd - ri

f1[x_, a_] := -Exp[(-a)*x] + x; , Null, g0[a_] := If[a > 0, 1/a, 1/(1 + a)]; , Null, g1[a_] := FindRoot[f1[x, a], {x, g0[a]}]; , Null

Plot[x /. g1[a], {a, -0.35, 15}]

(f1[x_, a_] = -Exp[(-a)*x] + x)*(g0[a_] = If[a > 0, 1/a, 1/(1 + a)])*(g1[a_] = FindRoot[f1[x, a], {x, g0[a]}])

Plot[x /. g1[a], {a, -0.35, 15}]

f = x^7 - a^7

g = Factor[f]

h = x - a

k = f/g

Simplify[k]

Cancel[k]

k = f/h

Simplify[k]

Cancel[k]

e = (x - 1)^2*((2 + x)/((1 + x)*(x - 3)^2))

Expand[e]

ExpandAll[e]

et = Together[%]

ae = Apart[%]

Factor[%]

s = Simplify[%]

n = Numerator[s]

d = Denominator[s]

d = Factor[d]

n/d

e == %

e == ae

e == et

ExpandAll[e == et]

ExpandAll[e == ae]

Simplify[e == ae]

Clear[x, y], Null, f = E^Abs[x - y]

D[f, x]

g = Simplify[f, x > y], Null, D[g, x]

g = Simplify[f, x < y], Null, D[g, x]

f = 4*x + 6*y + 10*z

g = Collect[f^3, x]

h = Collect[f^3, y]

f = Sqrt[x*y]

g = PowerExpand[f]

f - g

Simplify[%]

ExpandAll[%%]

PowerExpand[%%%]

PowerExpand[Sqrt[(-x)*y]]

Tan[ArcTan[x]]

ArcTan[Tan[x]]

PowerExpand[%]

FullSimplify[%%]

z = x + I*y

ComplexExpand[1/z^3]

ComplexExpand[Sin[x + I*y]]

Clear[n, z1, z2, z3, w]

Apart[Sqrt[-n + w]/(Sqrt[w]*Sqrt[w - z1]*Sqrt[w - z2]*Sqrt[w - z3]), w]

Clear[u]

f = -2*u + 2*u^3 + 2*ε - 2*u^2*ε

df = D[f, u]

so = Solve[df == 0, u]

f0 = f /. so

Expand[f0]

Simplify[f0]

FullSimplify[f0]

FullSimplify[Sqrt[2*Sqrt[6] + 5]]

Simplify[Sqrt[x^2]]

Simplify[Sqrt[x^2], x > 0]

Simplify[x^2 > 3, x > 2]

Simplify[Element[m^n, Integers], Element[{m, n}, Integers] && m > 0 && n > 0]

Simplify[a/b > 0, a > 0 && b > 0]

Simplify[Sqrt[b^2], a*b > 0 && a > 0]

Integrate[Sin[a*x]*(Cosh[b*x]/Sinh[x]), {x, 0, Infinity}]

Integrate[(Sin[a*x]*Cosh[b*x])/Sinh[x], {x, -Infinity, Infinity}]

Gamma[x]*Gamma[1 - x]

FunctionExpand[%]

FunctionExpand[BesselJ[n, I*x]]

FunctionExpand[BesselY[n, I*x]]

Hypergeometric2F1[1/2, 1/2, 3/2, Sin[z]^2]

PowerExpand[%]

Hypergeometric2F1[1/2, 1, 3/2, z^2]

PowerExpand[%]

Clear[n, z, t]

Hypergeometric2F1[-n/2, -(n - 1)/2, 1/2, z^2/t^2]

PowerExpand[%]

Hypergeometric2F1[1 - n, 1, 2, -z/t]

PowerExpand[%]

ExpandAll[%]

expr = Pi*(x/(x + 1 - 2*(-1)^(1/3) + I*Sqrt[3]))

expr /. x -> 0

Simplify[expr]

Clear[z], Null, s1 = Hypergeometric2F1[1/2, 1, 2, 4*z*(1 - z)]

s2 = FunctionExpand[%]

s3 = PowerExpand[s1]

s4 = Cancel[s1]

{s1, s2, s3, s4} /. z -> 1/4

Hypergeometric2F1[1/2, 1, 2, (4/4)*(1 - 1/4)]

expr = Expand[Sum[(-b + a*n)*x^(n + 0.12/n), {n, 3}]]

Collect[expr, x^(_.)]

Simplify[Log[x] + Log[y]]

FullSimplify[Log[x] + Log[y]]

CollectLogs[xx_] := Log[Simplify[E^xx]]

CollectLogs[Log[x] + Log[y]]

CollectLogs[Log[x] - Log[y]]

Simplify[Log[a] - Log[b], Element[{a, b}, Reals] && a > 0 && b > 0]

Simplify[Log[a] - Log[b], {b > 0, a > 0}]

Simplify[Log[a] - Log[b], {b < 0, a < 0}]

f = Sin[x]^3*Cos[2*x]

g = TrigExpand[f]

Expand[g /. Cos[x] -> (1 - Sin[x]^2)^(1/2)]

TrigFactor[f]

r = TrigReduce[f]

TrigExpand[r]

t = TrigToExp[f]

Expand[t]

ExpToTrig[%]

f

Simplify[f == %%]

2 + Cos[2*x] + Cos[2*y] + Cos[2*(x + y)]

% /. Cos[2*(x_)] :> 2*Cos[x]^2 - 1

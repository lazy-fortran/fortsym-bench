Clear[f, x, n, y, k]

f[x_, n_] = x^n

{f[2, 1], f[3, 2], f[4, 7], f[y, k]}

Clear[f, x, y, k1, k2]

f = Sin[k1*x]*Sin[k2*y]

g[x_, y_, a_, b_] = f /. {k1 -> a, k2 -> b}

Null

Clear[f]

f = {(x^2 + 1)/((x - 2)*(x^2 + 1)^2), (x^3 + 3*x^2 - 4*x + 3)/((x^2 - 1)*(x^2 + 1)^2), x/(x^4 - 1)}

Apart[f]

Together[%]

Expand[%]

FullSimplify[%]

Null

Clear[f]

f[x_] = Sin[x]*(1 + x^2); 

Plot[f[x], {x, 0, Pi}]

{fmax, xmax} = FindMaximum[f[x], {x, 2.}]

Null

Clear[f], Null, f[x, y] := {(x + I*y)^5, Cos[x + I*y], (x + I*y)^2*Sin[x + I*y]}

ComplexExpand[Re[f[x, y]]]

ComplexExpand[Im[f[x, y]]]

TrigReduce[f[x]]

Null

Z = ComplexExpand[R + I*w*L + 1/(I*w*C)]

Y = ComplexExpand[1/Z]

ComplexExpand[Re[Y]]

ComplexExpand[Im[Y]]

Sqrt[Pi/(2*x)]

Sqrt[Pi/(2*x)]

Clear[j, x, y, z]; 

j[0, x] = Sin[x]/x; j[-1, x] = Cos[x]/x; , Null, j[((m_)?NonNegative)?IntegerQ, x] := j[m, x] = ((2*m - 1)/x)*j[m - 1, x] - j[m - 2, x]; 

y[-1, x] = j[0, x]; y[0, x] = -j[-1, x]; , Null, y[((m_)?NonNegative)?IntegerQ, x] := y[m, x] = ((2*m - 1)/x)*y[m - 1, x] - y[m - 2, x]; 

TableForm[Simplify[{{j[1, x], y[1, x]}, {j[2, x], y[2, x]}, {j[3, x], y[3, x]}}]]

Clear[H, x], Null, H[x_] := 1 /; x >= 0; H[x_] := 0 /; x < 0; 

Plot[H[x], {x, -1, 1}]

(N[#1^2, 31] & )[E]

Clear[a, b, c, d, e, f, x, y]; , Null, (a + b)^4 + (c + d)^4 + (e + f)^4 + (x + y)^4; , Null, Expand[%]

FullSimplify[%]

Clear[p, u, e]; , Null, p = -2*u + 2*u^3 + 3*e - 2*u^2*e; 

ur = Solve[p == 0, u]

Simplify[p /. ur]

PowerExpand[Hypergeometric2F1[1/2, 1/2, 3/2, Sin[z]^2]]

PowerExpand[FullSimplify[PowerExpand[Hypergeometric2F1[1, 1, 3/2, Sin[z]^2]]]]

PowerExpand[Hypergeometric2F1[n/2, -n/2, 1/2, Sin[z]^2]]

FullSimplify[PowerExpand[Hypergeometric2F1[1/2, 1, 2, 4*z*(1 - z)]]]

Cheb[n_, x_] := Cos[n*ArcCos[x]]; , Null, TrigExpand[Cheb[{0, 1, 2, 3, 4, 5, 6}, x]]

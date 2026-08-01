FullSimplify[{Sum[1/3^k, {k, 0, Infinity}], NSum[(-1)^k/Log[k], {k, 2, Infinity}], Sum[Sin[k*x]/k, {k, 1, Infinity}] /. x -> {-Pi/2, 1.6}, Sum[(-1)^Floor[k/2]*(1/k)*(1/(k + 1)), {k, 1, Infinity, 2}]}]

p1 = ListPlot[{{-Pi, Pi/2}, {Pi, -Pi/2}}, Joined -> True, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> Hue[0]]; , Null, yf[k_, x_] = (-1)^k*(Sin[k*x]/k); , Null, sf[n_, x_] = Sum[yf[k, x], {k, 1, n}]; , Null, ssf = Plot[{sf[2, x], sf[3, x], sf[20, x]}, {x, -Pi, Pi}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> {{Black, Dashing[{0.02}]}, {Black, Dashing[{0.01}]}, {Black, Dashing[{}]}}]; , Null, sff[n_, x_] := Sum[sf[i, x], {i, n}]/n; , Null, ssff = Plot[{sff[2, x], sff[3, x], sff[20, x]}, {x, -Pi, Pi}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> {{Black, Dashing[{0.02}]}, {Black, Dashing[{0.01}]}, {Black, Dashing[{}]}}]; , Null, ss0 = Show[p1, ssf]; GraphicsRow[{ss0, Show[p1, ssff]}]

f[x_] = Pi^2/6 - x*(Pi/2) + x^2/4; , Null, yf[k_, x_] = Cos[k*x]/k^2; , Null, sf[x_] := Sum[yf[k, x], {k, 1, 100}]; , Null, Plot[{f[x], sf[x]}, {x, -Pi, 3*Pi}]

f[x_] = x*(Pi^2/6) - x^2*(Pi/4) + x^3/12; , Null, yf[k_, x_] = Sin[k*x]/k^3; , Null, sf[x_] = Sum[yf[k, x], {k, 1, 100}]; , Null, Plot[{f[x], sf[x]}, {x, -Pi, 3*Pi}]

y[k_, n_] = 1 - Exp[2*Pi*I*(k/n)]; , Null, p[n_] = Product[y[k, n], {k, 1, n - 1}]; , Null, N[p[Range[1, 9]]]

y[z_, n_] = 1 - z/(n - 1/2); , Null, p[z_] = Product[y[z, n], {n, -Infinity, Infinity}]

TODO

TODO

(d = {1, 2, 3, 6, 11, 7, 6, 4, 6, 8, 11, 17, 12, 10, 8, 6, 3, 3}; )*(triples = Partition[d, 3, 1]; )*(localmax[{a_, b_, c_}] = If[Inequality[a, LessEqual, b, GreaterEqual, c], True, False]; )*(found = localmax /@ triples; )*(maxpos = Position[found, True] + 1; )*(max = Extract[d, maxpos]; )*(Print["Positions: ", Flatten[maxpos]]; )*(Print["Values: ", max]; )

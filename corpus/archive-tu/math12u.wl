Clear[data]; , Null, data = {{2, 1}, {3, 7}, {5, 8}, {6, 11}}; TableForm[data]

Get["Splines`"]; , Null, f = SplineFit[data, Cubic]; 

p1 = ParametricPlot[f[x], {x, 0, 3}]; , Null, p2 = ListPlot[data]; , Null, Show[p1, p2]

z = Table[5*Random[Complex], {5}]

y = ({Re[#1], Im[#1]} & ) /@ z

P1 = Fit[y, {1, x}, x]

P2 = Fit[y, {1, x, x^2}, x]

P3 = Fit[y, {1, x, x^2, x^3}, x]

Sp = SplineFit[y, Cubic]; 

Pp = ListPlot[y, PlotStyle -> {Red}, PlotMarkers -> {Automatic, Medium}]; , Null, Pf = Plot[{P1, P2, P3, Sp}, {x, -1, 6}]; Show[Pp, Pf, PlotRange -> {{-1, 6}, {-1, 6}}]

Clear[x, t, ft1, ft2, cn]; , Null, cn = N[Table[NIntegrate[ChebyshevT[n, 2*x - 1]*(Sin[x/(Pi/2)]/Sqrt[x*(1 - x)]), {x, 0, 1}], {n, 0, 7}]*(2/Pi)]; , Null, cn[[1]] = cn[[1]]/2; 

cn

fc = Expand[Sum[cn[[k]]*ChebyshevT[k - 1, 2*x - 1], {k, Length[cn]}]]

ft1 = Series[Sin[x], {x, 0, 7}]

ft2 = Series[Sin[x], {x, Pi/4, 7}]

Plot[{Sin[t], Normal[ft1] /. x -> t, Null, Normal[ft2] /. x -> t, fc /. x -> (Pi/2)*t}, {t, 0, Pi/2}]

dft1 = Sin[t] - Normal[ft1] /. x -> t; , Null, dft2 = Sin[t] - Normal[ft2] /. x -> t; , Null, dfc = Sin[t] - fc /. x -> (Pi/2)*t; , Null, Plot[{dft1, dft2, dfc}, {t, 0, Pi/2}]

Clear[x, y, a, b, c, f]; , Null, data = {{0.5, -0.693147}, {1., 0.}, {2., 2.7759}, {3., 6.592}}; , Null, f[x_, y_] := 1/x - Exp[b*(y/x)], Null, data1 = ({#1[[1]], #1[[2]], 0} & ) /@ data, Null, nlm = Normal[NonlinearModelFit[data1, f[x, y], {b}, {x, y}]], Null, p1 = ContourPlot[nlm == 0, {x, 0, 4}, {y, -1, 7}]; , Null, p2 = ListPlot[data, PlotStyle -> {PointSize -> Medium}]; , Null, Show[p1, p2], Null

data = {{1., 1., 0.126}, {1., 2., 0.076}, {2., 1., 0.219}, {2., 2., 0.126}, {0.1, 0., 0.186}}; 

nlm = NonlinearModelFit[data, (θ1*θ3*x1)/(x1*θ1 + x2*θ2 + 1), {θ1, θ2, θ3}, {x1, x2}]

nnlm = Normal[nlm]

res = (#1[[3]] - nnlm /. {x1 -> #1[[1]], x2 -> #1[[2]]} & ) /@ data; , Null, resg = Table[Text[res[[i]], 1.1*data[[i]][[{1, 2, 3}]]], {i, 1, Length[data]}]; , Null, p1 = Plot3D[Normal[nlm], {x1, 0, 2}, {x2, 0, 2}, PlotStyle -> {Opacity -> 0.5}]; , Null, p2 = ListPointPlot3D[data, PlotStyle -> {PointSize -> Large, PlotMarkers -> {"1", "2", "3", "4", "5"}}]; , Null, Show[p1, p2, Graphics3D[{Red, resg}], PlotRange -> {{0, 2}, {0, 2}, {0, 0.3}}]

Clear[a, b, c, d, x, y, z]; , Null, data = {{1., 1., 0.126}, {1., 2., 0.076}, {2., 1., 0.219}, {2., 2., 0.126}, {0.1, 0., 0.186}}; , Null, LinearModelFit[data, {x, y}, {x, y}]

mz = Normal[%]

res = (#1[[3]] - mz /. {x -> #1[[1]], y -> #1[[2]]} & ) /@ data; , Null, p1 = Plot3D[mz, {x, 0, 2}, {y, 0, 2}, PlotStyle -> {Opacity -> 0.5}]; p2 = ListPointPlot3D[data, PlotStyle -> {PointSize -> Large, PlotMarkers -> {"1", "2", "3", "4", "5"}}]; , Null, Show[p1, p2, Graphics3D[{Red, resg}], PlotRange -> {{0, 2}, {0, 2}, {0, 0.3}}]

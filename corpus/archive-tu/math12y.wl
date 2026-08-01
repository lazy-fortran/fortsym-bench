Clear[data]; , Null, data = {{2, 1}, {3, 7}, {5, 8}, {6, 11}}; TableForm[data]

Clear[d, f, p], Null, d = ListPlot[data, PlotRange -> {{0, 6.1}, {0, 12}}, Prolog -> PointSize[0.015]]; , Null, c = ListPlot[data, PlotRange -> {{0, 6.1}, {0, 12}}, Joined -> True]; 

Show[GraphicsRow[{d, c}]]

f = Fit[data, {1, x}, x]

pl = Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]; 

Clear[f]; f = Fit[data, {1, x, x^2}, x]

pq = Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]; 

ppl = Show[d, pl]; ppq = Show[d, pq]; , Null, Show[GraphicsArray[{ppl, ppq}]]

Clear[f], Null, f = Fit[data, {1, Sin[x]}, x]

p = Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]; 

Show[d, p, PlotRegion -> {{0.01, 0.95}, {0.01, 0.95}}, ImageSize -> 200]

Clear[a, b, c, d, t, x, y], Null, FindFit[data, a + b*t, {a, b}, t]

data2 = Partition[Flatten[{Range[Length[data]], Transpose[data]}], 3]

Point /@ data2

fxy = a + b*x + c*y + d*x*y; , Null, con = FindFit[data2, fxy, {a, b, c, d}, {x, y}]

p1 = Plot3D[Evaluate[fxy /. con], {x, 0, 8}, {y, 0, 8}, AxesLabel -> {"x", "y", "fxy"}, PlotLabel -> Row[{"fxz = ", fxy}]]; , Null, p2 = Show[p1, Graphics3D[{PointSize[0.02], Hue[0], Point /@ data2}], ImageSize -> 450]

Clear[c, f, g, p, x, y]; , Null, data = {{2, 1}, {3, 7}, {5, 8}, {6, 11}}; TableForm[data]

poi = {AbsolutePointSize[8], Point /@ data}; 

f = Expand[InterpolatingPolynomial[data, x]]

Plot[f, {x, 0, 6}, PlotStyle -> Thickness[0.003], PlotRange -> {0, 12}, Epilog -> poi]

data1 = {{1, 2}, {2, 1}, {3, 7}, {4, 6}, {5, 8}, {5.5, 7}, {6, 11}}; , Null, {PointSize[0.03], Point /@ data1}; , Null, d = Graphics[%, Axes -> True, PlotRange -> {{0, 6.1}, {0, 12}}, AspectRatio -> 0.4]; 

g[x_] = Expand[InterpolatingPolynomial[data1, x]]

p = Plot[g[x], {x, 0, 6}, PlotRange -> {{0, 6}, {-8, 12}}, Epilog -> d[[1]]]; Show[GraphicsRow[{d, p}], ImageSize -> 500]

f = Fit[data1, {1, x}, x]

g = Fit[data1, {1, x, x^2}, x]

h = Fit[data1, {1, x, x^2, x^3}, x]

i = Fit[data1, {1, x, x^2, x^3, x^4}, x]

pf = Plot[f, {x, 0, 6}, PlotLabel -> "Linear Polynomial"]; , Null, pg = Plot[g, {x, 0, 6}, PlotLabel -> "Quadratic Polynomial"]; , Null, ph = Plot[h, {x, 0, 6}, PlotLabel -> "Cubic Polynom"]; , Null, pi = Plot[i, {x, 0, 6}, PlotLabel -> "Quartic Polynom"]; , Null, pdf = Show[pf, d]; pdq = Show[pg, d]; , Null, pdh = Show[ph, d]; pdi = Show[pi, d]; , Null, Show[GraphicsGrid[{{pdf, pdq}, {pdh, pdi}}]]

Information["Interpolation", LongForm -> True]

data = {-1, -0.5, 0, 1, 3, 6, 9}; Clear[lx, f]

f[x_] = (E^(-x) - 1)^2; 

i1 = Interpolation[d1 = Transpose[{data, f[data]}]]; , Null, epi = {Epilog -> {Hue[1], PointSize[0.025], Point /@ d1}}; 

p1 = Plot[f[x], {x, -1, 9}, Evaluate[epi], PlotStyle -> Hue[0.8]]; , Null, p2 = Plot[i1[t], {t, -1, 9}, Evaluate[epi]]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

d2 = Table[N[{{data[[k]]}, f[data[[k]]], Derivative[1][f][data[[k]]]}], {k, Length[data]}]

Clear[i2, t], Null, i2[t_] = Interpolation[d2][t]; 

p3 = Plot[i2[t], {t, -1, 9}, Evaluate[epi], PlotStyle -> Hue[0.6], ImageSize -> 250]

Show[p1, p2, p3, ImageSize -> 250]

Get["PlotLegends`"]; 

f[x_] = Exp[2*x]; 

g = FunctionInterpolation[f[x], {x, -1, 1}]; 

Plot[Evaluate[Table[D[g[x], {x, n}], {n, 0, 4}]], {x, -1, 1}, PlotRange -> All, ImageSize -> 350, PlotStyle -> Table[{Thick, Hue[n/5]}, {n, 0, 4}], PlotLegend -> {"g(x)", "g'(x)", "g''(x)", "\!\(\*SuperscriptBox[\(g\), \((3)\)]\)((x)", "\!\(\*SuperscriptBox[\(g\), \((4)\)]\)(x)"}, LegendPosition -> {-1, 0}]

h = FunctionInterpolation[{f[x], Derivative[1][f][x], Derivative[1][Derivative[1][f]][x]}, {x, -1, 1}]

Plot[Evaluate[Table[D[h[x], {x, n}], {n, 0, 4}]], {x, -1, 1}, PlotRange -> All, ImageSize -> 350, PlotStyle -> Table[{Thick, Hue[n/5]}, {n, 0, 4}], PlotLegend -> {"h(x)", "h'(x)", "h''(x)", "\!\(\*SuperscriptBox[\(h\), \((3)\)]\)(x)", "\!\(\*SuperscriptBox[\(h\), \((4)\)]\)(x)"}, LegendPosition -> {-1, 0}]

data1 = {{1, 2}, {2, 1}, {3, 7}, {4, 6}, {5, 8}, {5.5, 7}, {6, 11}}; , Null, d = Graphics[{PointSize[0.01], Point /@ data1}, Axes -> True, PlotRange -> {{0, 6}, {0, 15}}, AspectRatio -> 0.5]

Information["Spline", LongForm -> False]

Get["Splines`"], Null, sp = Show[Graphics[Spline[data1, Cubic]], AspectRatio -> 0.5]; , Null, dp = Show[d, sp]; , Null, Show[GraphicsRow[{sp, dp}], ImageSize -> 400]

Get["Splines`"]

np = 4; 

data = Table[{x + RandomReal[]*0.1, RandomReal[]}, {x, 0, 1, 1/(np - 1)}]

dp = ListPlot[data, PlotRange -> {{0, 1.1}, {0, 1.1}}, Prolog -> PointSize[0.02]]; , Null, sp = Graphics[Spline[data, Cubic]]; , Null, psd = Show[dp, sp, Axes -> True]; 

Show[GraphicsRow[{dp, psd}], ImageSize -> 450]

ip = SplineFit[data, Cubic]; 

pip = ParametricPlot[ip[u], {u, 0, np - 1}, PlotRange -> {0, 1}, ImageSize -> 200, AspectRatio -> 0.6]

ip[2.23]

ip = SplineFit[data, Cubic]; , Null, fu = FullForm[ip]

Chop[ip[[4]]]

tl = Table[t^n, {n, 0, 3}]

px = Chop[Table[ip[[4,n,1]] . tl, {n, np - 1}]]

py = Chop[Table[ip[[4,n,2]] . tl, {n, np - 1}]]

{px[[1]], py[[1]]} /. t -> 0

Table[Chop[{(px[[k + 1]] /. t -> 0) - (px[[k]] /. t -> 1), (py[[k + 1]] /. t -> 0) - (py[[k]] /. t -> 1)}], {k, np - 2}]

{px[[-1]], py[[-1]]} /. t -> 1

Chop[{D[px[[1]], t], D[py[[1]], t]} /. t -> 0]

Table[Chop[{(D[px[[k + 1]], t] /. t -> 0) - (D[px[[k]], t] /. t -> 1), (D[py[[k + 1]], t] /. t -> 0) - (D[py[[k]], t] /. t -> 1)}], {k, np - 2}]

Chop[{D[px[[-1]], t], D[py[[-1]], t]} /. t -> 1]

Chop[{D[px[[1]], {t, 2}], D[py[[1]], {t, 2}]} /. t -> 0]

Table[Chop[{(D[px[[k + 1]], {t, 2}] /. t -> 0) - (D[px[[k]], {t, 2}] /. t -> 1), (D[py[[k + 1]], {t, 2}] /. t -> 0) - (D[py[[k]], {t, 2}] /. t -> 1)}], {k, np - 2}]

Chop[{D[px[[-1]], {t, 2}], D[py[[-1]], {t, 2}]} /. t -> 1]

fr = D[py, t]/D[px, t]

fd[u_] = Which @@ Flatten[Together[ExpandAll[Table[{k - 1 <= u <= k, {px[[k]], fr[[k]]} /. t -> u - k + 1}, {k, np - 1}]]], 1]

pd = ParametricPlot[fd[u], {u, 0, np - 1}, PlotStyle -> Hue[0]]; 

Show[pip, pd, AxesLabel -> {"x", ""}, PlotRange -> {-3.5, 2.1}, Epilog -> {Text["f(x)", {0.95, 0.6}], Hue[0], Text["f'(x)", {0.5, -0.9}]}]

f = 1/(1 + x); 

f6 = Normal[Series[f, {x, 0, 6}]]

f7 = Normal[Series[f, {x, 0, 7}]]

cn = N[Table[NIntegrate[ChebyshevT[n, 2*x - 1]/((1 + x)*Sqrt[x*(1 - x)]), {x, 0, 1}], {n, 0, 6}]*(2/Pi)]; , Null, cn[[1]] = cn[[1]]/2; cn

fc = Expand[Sum[cn[[k]]*ChebyshevT[k - 1, 2*x - 1], {k, Length[cn]}]]; fc

SetOptions[Plot, DisplayFunction -> Identity]; , Null, pt = Plot[{f, fc, f6, f7}, {x, 0, 1}, AxesLabel -> {"x", "f, fc,f6,f7"}, PlotStyle -> {Dashing[{}], Dashing[{0.1}], Dashing[{0.01}], Dashing[{0.02}]}]; , Null, pc = Plot[{fc - f}, {x, 0, 1}, PlotRange -> {-1, 1}/10^5, AxesLabel -> {"x", "f - fc"}]; , Null, Show[GraphicsRow[{pt, pc}], ImageSize -> 500]

p6 = Plot[{f - f6}, {x, 0, 1}, AxesLabel -> {"x", "f - f6"}]; , Null, p7 = Plot[{f - f7}, {x, 0, 1}, AxesLabel -> {"x", "f - f7"}]; , Null, Show[GraphicsRow[{p6, p7}, Spacings -> {Scaled[0.5], Scaled[0]}]]

f80 = Normal[Series[f, {x, 0, 80}]]; , Null, SetOptions[Plot, AxesLabel -> {"x", "f - f80"}]; , Null, pt = Plot[{f - f80}, {x, 0, 1}, PlotRange -> {0, -(1/10^6)}]; , Null, pa = Plot[{f - f80}, {x, 0, 1}, PlotRange -> All]; , Null, Show[GraphicsRow[{pt, pa}, Spacings -> {Scaled[0.5], Scaled[0]}]]

Clear[p]*fc = Sqrt[2]*(1/2 + Sum[(-p)^n*ChebyshevT[n, 2*x - 1], {n, 6}]); p = 3 - 2*Sqrt[2]; N[p]*tc = Expand[N[fc]]

Chop[fc - tc, 10^(-8)]

dn = Table[Integrate[ChebyshevT[n, 2*x - 1]/((1 + x)*Sqrt[x*(1 - x)]), {x, 0, 1}], {n, 0, 6}]*(2/Pi); dn[[1]] = dn[[1]]/2; Cancel[dn]*N[dn]

Prepend[Table[Expand[Sqrt[2]*(-p)^k], {k, 6}], 1/Sqrt[2]]

Information["NonlinearModelFit", LongForm -> True]

Null

data = {{0, 1}, {1, 0}, {3, 2}, {5, 4}, {6, 4}, {7, 5}}; 

nlm = NonlinearModelFit[data, Log[a + b*x^2], {a, b}, x]

Normal[nlm]

nlm[2.3]

Show[ListPlot[data], Plot[nlm[x], {x, 0, 7}], Frame -> True]

nlm["FitResiduals"]

ListPlot[%, Filling -> Axis]

data = {{1., 1., 0.126}, {1., 2., 0.076}, {2., 1., 0.219}, {2., 2., 0.126}, {0.1, 0., 0.186}}; 

nlm = NonlinearModelFit[data, (θ1*θ3*x1)/(x1*θ1 + x2*θ2 + 1), {θ1, θ2, θ3}, {x1, x2}]

Normal[nlm]

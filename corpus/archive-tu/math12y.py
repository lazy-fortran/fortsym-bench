"""Generated SymPy translation of ``corpus/archive-tu/math12y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 90 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('f', 'Fit[data, {1, x}, x]', ()),
    ('pl', 'Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]', ()),
    ('f', 'Fit[data, {1, x, x^2}, x]', ()),
    ('pq', 'Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]', ()),
    ('ppl', 'Show[d, pl]', ()),
    ('ppq', 'Show[d, pq]', ()),
    ('p', 'Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]', ()),
    ('data2', 'Partition[Flatten[{Range[Length[data]], Transpose[data]}], 3]', ()),
    ('fxy', 'a + b*x + c*y + d*x*y', ()),
    ('p1', 'Plot3D[Evaluate[fxy /. con], {x, 0, 8}, {y, 0, 8}, AxesLabel -> {"x", "y", "fxy"}, PlotLabel -> Row[{"fxz = ", fxy}]]', ()),
    ('poi', '{AbsolutePointSize[8], Point /@ data}', ()),
    ('f', 'Expand[InterpolatingPolynomial[data, x]]', ()),
    ('data1', '{{1, 2}, {2, 1}, {3, 7}, {4, 6}, {5, 8}, {5.5, 7}, {6, 11}}', ()),
    ('p', 'Plot[g[x], {x, 0, 6}, PlotRange -> {{0, 6}, {-8, 12}}, Epilog -> d[[1]]]', ()),
    ('f', 'Fit[data1, {1, x}, x]', ()),
    ('g', 'Fit[data1, {1, x, x^2}, x]', ()),
    ('h', 'Fit[data1, {1, x, x^2, x^3}, x]', ()),
    ('i', 'Fit[data1, {1, x, x^2, x^3, x^4}, x]', ()),
    ('pf', 'Plot[f, {x, 0, 6}, PlotLabel -> "Linear Polynomial"]', ()),
    ('pdq', 'Show[pg, d]', ()),
    ('pdi', 'Show[pi, d]', ()),
    ('data', '{-1, -0.5, 0, 1, 3, 6, 9}', ()),
    ('i1', 'Interpolation[d1 = Transpose[{data, f[data]}]]', ()),
    ('p1', 'Plot[f[x], {x, -1, 9}, Evaluate[epi], PlotStyle -> Hue[0.8]]', ()),
    ('d2', 'Table[N[{{data[[k]]}, f[data[[k]]], Derivative[1][f][data[[k]]]}], {k, Length[data]}]', ()),
    ('p3', 'Plot[i2[t], {t, -1, 9}, Evaluate[epi], PlotStyle -> Hue[0.6], ImageSize -> 250]', ()),
    ('g', 'FunctionInterpolation[f[x], {x, -1, 1}]', ()),
    ('h', 'FunctionInterpolation[{f[x], Derivative[1][f][x], Derivative[1][Derivative[1][f]][x]}, {x, -1, 1}]', ()),
    ('data1', '{{1, 2}, {2, 1}, {3, 7}, {4, 6}, {5, 8}, {5.5, 7}, {6, 11}}', ()),
    ('np', '4', ()),
    ('data', 'Table[{x + RandomReal[]*0.1, RandomReal[]}, {x, 0, 1, 1/(np - 1)}]', ()),
    ('dp', 'ListPlot[data, PlotRange -> {{0, 1.1}, {0, 1.1}}, Prolog -> PointSize[0.02]]', ()),
    ('ip', 'SplineFit[data, Cubic]', ()),
    ('pip', 'ParametricPlot[ip[u], {u, 0, np - 1}, PlotRange -> {0, 1}, ImageSize -> 200, AspectRatio -> 0.6]', ()),
    ('ip', 'SplineFit[data, Cubic]', ()),
    ('tl', 'Table[t^n, {n, 0, 3}]', ()),
    ('px', 'Chop[Table[ip[[4,n,1]] . tl, {n, np - 1}]]', ()),
    ('py', 'Chop[Table[ip[[4,n,2]] . tl, {n, np - 1}]]', ()),
    ('fr', 'D[py, t]/D[px, t]', ()),
    ('pd', 'ParametricPlot[fd[u], {u, 0, np - 1}, PlotStyle -> Hue[0]]', ()),
    ('f', '1/(1 + x)', ()),
    ('f6', 'Normal[Series[f, {x, 0, 6}]]', ()),
    ('f7', 'Normal[Series[f, {x, 0, 7}]]', ()),
    ('cn', 'N[Table[NIntegrate[ChebyshevT[n, 2*x - 1]/((1 + x)*Sqrt[x*(1 - x)]), {x, 0, 1}], {n, 0, 6}]*(2/Pi)]', ()),
    ('fc', 'Expand[Sum[cn[[k]]*ChebyshevT[k - 1, 2*x - 1], {k, Length[cn]}]]', ()),
    ('p6', 'Plot[{f - f6}, {x, 0, 1}, AxesLabel -> {"x", "f - f6"}]', ()),
    ('f80', 'Normal[Series[f, {x, 0, 80}]]', ()),
    ('p', '3 - 2*Sqrt[2]', ()),
    ('dn', 'Table[Integrate[ChebyshevT[n, 2*x - 1]/((1 + x)*Sqrt[x*(1 - x)]), {x, 0, 1}], {n, 0, 6}]*(2/Pi)', ()),
    ('data', '{{0, 1}, {1, 0}, {3, 2}, {5, 4}, {6, 4}, {7, 5}}', ()),
    ('nlm', 'NonlinearModelFit[data, Log[a + b*x^2], {a, b}, x]', ()),
    ('data', '{{1., 1., 0.126}, {1., 2., 0.076}, {2., 1., 0.219}, {2., 2., 0.126}, {0.1, 0., 0.186}}', ()),
    ('nlm', 'NonlinearModelFit[data, (θ1*θ3*x1)/(x1*θ1 + x2*θ2 + 1), {θ1, θ2, θ3}, {x1, x2}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math12y.wl')

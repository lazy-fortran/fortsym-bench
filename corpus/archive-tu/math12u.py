"""Generated SymPy translation of ``corpus/archive-tu/math12u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 42 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('data', '{{2, 1}, {3, 7}, {5, 8}, {6, 11}}', ()),
    ('f', 'SplineFit[data, Cubic]', ()),
    ('p1', 'ParametricPlot[f[x], {x, 0, 3}]', ()),
    ('p2', 'ListPlot[data]', ()),
    ('z', 'Table[5*Random[Complex], {5}]', ()),
    ('y', '({Re[#1], Im[#1]} & ) /@ z', ()),
    ('P1', 'Fit[y, {1, x}, x]', ()),
    ('P2', 'Fit[y, {1, x, x^2}, x]', ()),
    ('P3', 'Fit[y, {1, x, x^2, x^3}, x]', ()),
    ('Sp', 'SplineFit[y, Cubic]', ()),
    ('Pp', 'ListPlot[y, PlotStyle -> {Red}, PlotMarkers -> {Automatic, Medium}]', ()),
    ('Pf', 'Plot[{P1, P2, P3, Sp}, {x, -1, 6}]', ()),
    ('cn', 'N[Table[NIntegrate[ChebyshevT[n, 2*x - 1]*(Sin[x/(Pi/2)]/Sqrt[x*(1 - x)]), {x, 0, 1}], {n, 0, 7}]*(2/Pi)]', ()),
    ('fc', 'Expand[Sum[cn[[k]]*ChebyshevT[k - 1, 2*x - 1], {k, Length[cn]}]]', ()),
    ('ft1', 'Series[Sin[x], {x, 0, 7}]', ()),
    ('ft2', 'Series[Sin[x], {x, Pi/4, 7}]', ()),
    ('dft1', 'Sin[t] - Normal[ft1] /. x -> t', ()),
    ('dft2', 'Sin[t] - Normal[ft2] /. x -> t', ()),
    ('dfc', 'Sin[t] - fc /. x -> (Pi/2)*t', ()),
    ('data', '{{0.5, -0.693147}, {1., 0.}, {2., 2.7759}, {3., 6.592}}', ()),
    ('f', '1/x - Exp[b*(y/x)]', ('x', 'y')),
    ('data1', '({#1[[1]], #1[[2]], 0} & ) /@ data', ()),
    ('nlm', 'Normal[NonlinearModelFit[data1, f[x, y], {b}, {x, y}]]', ()),
    ('p1', 'ContourPlot[nlm == 0, {x, 0, 4}, {y, -1, 7}]', ()),
    ('p2', 'ListPlot[data, PlotStyle -> {PointSize -> Medium}]', ()),
    ('data', '{{1., 1., 0.126}, {1., 2., 0.076}, {2., 1., 0.219}, {2., 2., 0.126}, {0.1, 0., 0.186}}', ()),
    ('nlm', 'NonlinearModelFit[data, (θ1*θ3*x1)/(x1*θ1 + x2*θ2 + 1), {θ1, θ2, θ3}, {x1, x2}]', ()),
    ('nnlm', 'Normal[nlm]', ()),
    ('res', '(#1[[3]] - nnlm /. {x1 -> #1[[1]], x2 -> #1[[2]]} & ) /@ data', ()),
    ('resg', 'Table[Text[res[[i]], 1.1*data[[i]][[{1, 2, 3}]]], {i, 1, Length[data]}]', ()),
    ('p1', 'Plot3D[Normal[nlm], {x1, 0, 2}, {x2, 0, 2}, PlotStyle -> {Opacity -> 0.5}]', ()),
    ('p2', 'ListPointPlot3D[data, PlotStyle -> {PointSize -> Large, PlotMarkers -> {"1", "2", "3", "4", "5"}}]', ()),
    ('data', '{{1., 1., 0.126}, {1., 2., 0.076}, {2., 1., 0.219}, {2., 2., 0.126}, {0.1, 0., 0.186}}', ()),
    ('mz', 'Normal[%]', ()),
    ('res', '(#1[[3]] - mz /. {x -> #1[[1]], y -> #1[[2]]} & ) /@ data', ()),
    ('p1', 'Plot3D[mz, {x, 0, 2}, {y, 0, 2}, PlotStyle -> {Opacity -> 0.5}]', ()),
    ('p2', 'ListPointPlot3D[data, PlotStyle -> {PointSize -> Large, PlotMarkers -> {"1", "2", "3", "4", "5"}}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math12u.wl')

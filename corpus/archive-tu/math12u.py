"""Generated SymPy translation of ``corpus/archive-tu/math12u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 31 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('p1', 'ParametricPlot[f[x], {x, 0, 3}]', ()),
    ('z', 'Table[5*Random[Complex], {5}]', ()),
    ('y', '({Re[#1], Im[#1]} & ) /@ z', ()),
    ('P1', 'Fit[y, {1, x}, x]', ()),
    ('P2', 'Fit[y, {1, x, x^2}, x]', ()),
    ('P3', 'Fit[y, {1, x, x^2, x^3}, x]', ()),
    ('Sp', 'SplineFit[y, Cubic]', ()),
    ('Pp', 'ListPlot[y, PlotStyle -> {Red}, PlotMarkers -> {Automatic, Medium}]', ()),
    ('fc', 'Expand[Sum[cn[[k]]*ChebyshevT[k - 1, 2*x - 1], {k, Length[cn]}]]', ()),
    ('ft1', 'Series[Sin[x], {x, 0, 7}]', ()),
    ('ft2', 'Series[Sin[x], {x, Pi/4, 7}]', ()),
    ('dft1', 'Sin[t] - Normal[ft1] /. x -> t', ()),
    ('data', '{{1., 1., 0.126}, {1., 2., 0.076}, {2., 1., 0.219}, {2., 2., 0.126}, {0.1, 0., 0.186}}', ()),
    ('nlm', 'NonlinearModelFit[data, (θ1*θ3*x1)/(x1*θ1 + x2*θ2 + 1), {θ1, θ2, θ3}, {x1, x2}]', ()),
    ('nnlm', 'Normal[nlm]', ()),
    ('res', '(#1[[3]] - nnlm /. {x1 -> #1[[1]], x2 -> #1[[2]]} & ) /@ data', ()),
    ('mz', 'Normal[%]', ()),
    ('res', '(#1[[3]] - mz /. {x -> #1[[1]], y -> #1[[2]]} & ) /@ data', ()),
    ('p2', 'ListPointPlot3D[data, PlotStyle -> {PointSize -> Large, PlotMarkers -> {"1", "2", "3", "4", "5"}}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math12u.wl')

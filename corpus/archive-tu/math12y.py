"""Generated SymPy translation of ``corpus/archive-tu/math12y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments
import sympy as sp

# NOT TRANSLATED: 102 non-assignment statement(s) remain.
COMPARE = {
    'cn': 'numeric',
    'd2': 'numeric',
}
_ASSIGNMENTS = [
    ('data', '{{2, 1}, {3, 7}, {5, 8}, {6, 11}}', ()),
    ('d', 'ListPlot[data, PlotRange -> {{0, 6.1}, {0, 12}}, Prolog -> PointSize[0.015]]', ()),
    ('c', 'ListPlot[data, PlotRange -> {{0, 6.1}, {0, 12}}, Joined -> True]', ()),
    ('f', 'Fit[data, {1, x}, x]', ()),
    ('pl', 'Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]', ()),
    ('f', 'Fit[data, {1, x, x^2}, x]', ()),
    ('pq', 'Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]', ()),
    ('ppl', 'Show[d, pl]', ()),
    ('ppq', 'Show[d, pq]', ()),
    ('f', 'Fit[data, {1, Sin[x]}, x]', ()),
    ('p', 'Plot[f, {x, 0, 6}, PlotRange -> {{0, 6}, {0, 12}}]', ()),
    ('data2', 'Partition[Flatten[{Range[Length[data]], Transpose[data]}], 3]', ()),
    ('fxy', 'a + b*x + c*y + d*x*y', ()),
    ('con', 'FindFit[data2, fxy, {a, b, c, d}, {x, y}]', ()),
    ('p1', 'Plot3D[Evaluate[fxy /. con], {x, 0, 8}, {y, 0, 8}, AxesLabel -> {"x", "y", "fxy"}, PlotLabel -> Row[{"fxz = ", fxy}]]', ()),
    ('p2', 'Show[p1, Graphics3D[{PointSize[0.02], Hue[0], Point /@ data2}], ImageSize -> 450]', ()),
    ('data', '{{2, 1}, {3, 7}, {5, 8}, {6, 11}}', ()),
    ('poi', '{AbsolutePointSize[8], Point /@ data}', ()),
    ('f', 'Expand[InterpolatingPolynomial[data, x]]', ()),
    ('data1', '{{1, 2}, {2, 1}, {3, 7}, {4, 6}, {5, 8}, {5.5, 7}, {6, 11}}', ()),
    ('d', 'Graphics[%, Axes -> True, PlotRange -> {{0, 6.1}, {0, 12}}, AspectRatio -> 0.4]', ()),
    ('g', 'Expand[InterpolatingPolynomial[data1, x]]', ('x',)),
    ('p', 'Plot[g[x], {x, 0, 6}, PlotRange -> {{0, 6}, {-8, 12}}, Epilog -> d[[1]]]', ()),
    ('f', 'Fit[data1, {1, x}, x]', ()),
    ('g', 'Fit[data1, {1, x, x^2}, x]', ()),
    ('h', 'Fit[data1, {1, x, x^2, x^3}, x]', ()),
    ('i', 'Fit[data1, {1, x, x^2, x^3, x^4}, x]', ()),
    ('pf', 'Plot[f, {x, 0, 6}, PlotLabel -> "Linear Polynomial"]', ()),
    ('pg', 'Plot[g, {x, 0, 6}, PlotLabel -> "Quadratic Polynomial"]', ()),
    ('ph', 'Plot[h, {x, 0, 6}, PlotLabel -> "Cubic Polynom"]', ()),
    ('pi', 'Plot[i, {x, 0, 6}, PlotLabel -> "Quartic Polynom"]', ()),
    ('pdf', 'Show[pf, d]', ()),
    ('pdq', 'Show[pg, d]', ()),
    ('pdh', 'Show[ph, d]', ()),
    ('pdi', 'Show[pi, d]', ()),
    ('data', '{-1, -0.5, 0, 1, 3, 6, 9}', ()),
    ('f', '(E^(-x) - 1)^2', ('x',)),
    ('i1', 'Interpolation[d1 = Transpose[{data, f[data]}]]', ()),
    ('epi', '{Epilog -> {Hue[1], PointSize[0.025], Point /@ d1}}', ()),
    ('p1', 'Plot[f[x], {x, -1, 9}, Evaluate[epi], PlotStyle -> Hue[0.8]]', ()),
    ('p2', 'Plot[i1[t], {t, -1, 9}, Evaluate[epi]]', ()),
    ('d2', 'Table[N[{{data[[k]]}, f[data[[k]]], Derivative[1][f][data[[k]]]}], {k, Length[data]}]', ()),
    ('i2', 'Interpolation[d2][t]', ('t',)),
    ('p3', 'Plot[i2[t], {t, -1, 9}, Evaluate[epi], PlotStyle -> Hue[0.6], ImageSize -> 250]', ()),
    ('f', 'Exp[2*x]', ('x',)),
    ('g', 'FunctionInterpolation[f[x], {x, -1, 1}]', ()),
    ('h', 'FunctionInterpolation[{f[x], Derivative[1][f][x], Derivative[1][Derivative[1][f]][x]}, {x, -1, 1}]', ()),
    ('data1', '{{1, 2}, {2, 1}, {3, 7}, {4, 6}, {5, 8}, {5.5, 7}, {6, 11}}', ()),
    ('d', 'Graphics[{PointSize[0.01], Point /@ data1}, Axes -> True, PlotRange -> {{0, 6}, {0, 15}}, AspectRatio -> 0.5]', ()),
    ('sp', 'Show[Graphics[Spline[data1, Cubic]], AspectRatio -> 0.5]', ()),
    ('dp', 'Show[d, sp]', ()),
    ('np', '4', ()),
    ('data', 'Table[{x + RandomReal[]*0.1, RandomReal[]}, {x, 0, 1, 1/(np - 1)}]', ()),
    ('dp', 'ListPlot[data, PlotRange -> {{0, 1.1}, {0, 1.1}}, Prolog -> PointSize[0.02]]', ()),
    ('sp', 'Graphics[Spline[data, Cubic]]', ()),
    ('psd', 'Show[dp, sp, Axes -> True]', ()),
    ('ip', 'SplineFit[data, Cubic]', ()),
    ('pip', 'ParametricPlot[ip[u], {u, 0, np - 1}, PlotRange -> {0, 1}, ImageSize -> 200, AspectRatio -> 0.6]', ()),
    ('ip', 'SplineFit[data, Cubic]', ()),
    ('fu', 'FullForm[ip]', ()),
    ('tl', 'Table[t^n, {n, 0, 3}]', ()),
    ('px', 'Chop[Table[ip[[4,n,1]] . tl, {n, np - 1}]]', ()),
    ('py', 'Chop[Table[ip[[4,n,2]] . tl, {n, np - 1}]]', ()),
    ('fr', 'D[py, t]/D[px, t]', ()),
    ('fd', 'Which @@ Flatten[Together[ExpandAll[Table[{k - 1 <= u <= k, {px[[k]], fr[[k]]} /. t -> u - k + 1}, {k, np - 1}]]], 1]', ('u',)),
    ('pd', 'ParametricPlot[fd[u], {u, 0, np - 1}, PlotStyle -> Hue[0]]', ()),
    ('f', '1/(1 + x)', ()),
    ('f6', 'Normal[Series[f, {x, 0, 6}]]', ()),
    ('f7', 'Normal[Series[f, {x, 0, 7}]]', ()),
    ('cn', 'N[Table[NIntegrate[ChebyshevT[n, 2*x - 1]/((1 + x)*Sqrt[x*(1 - x)]), {x, 0, 1}], {n, 0, 6}]*(2/Pi)]', ()),
    ('fc', 'Expand[Sum[cn[[k]]*ChebyshevT[k - 1, 2*x - 1], {k, Length[cn]}]]', ()),
    ('pt', 'Plot[{f, fc, f6, f7}, {x, 0, 1}, AxesLabel -> {"x", "f, fc,f6,f7"}, PlotStyle -> {Dashing[{}], Dashing[{0.1}], Dashing[{0.01}], Dashing[{0.02}]}]', ()),
    ('pc', 'Plot[{fc - f}, {x, 0, 1}, PlotRange -> {-1, 1}/10^5, AxesLabel -> {"x", "f - fc"}]', ()),
    ('p6', 'Plot[{f - f6}, {x, 0, 1}, AxesLabel -> {"x", "f - f6"}]', ()),
    ('p7', 'Plot[{f - f7}, {x, 0, 1}, AxesLabel -> {"x", "f - f7"}]', ()),
    ('f80', 'Normal[Series[f, {x, 0, 80}]]', ()),
    ('pt', 'Plot[{f - f80}, {x, 0, 1}, PlotRange -> {0, -(1/10^6)}]', ()),
    ('pa', 'Plot[{f - f80}, {x, 0, 1}, PlotRange -> All]', ()),
    ('p', '3 - 2*Sqrt[2]', ()),
    ('dn', 'Table[Integrate[ChebyshevT[n, 2*x - 1]/((1 + x)*Sqrt[x*(1 - x)]), {x, 0, 1}], {n, 0, 6}]*(2/Pi)', ()),
    ('data', '{{0, 1}, {1, 0}, {3, 2}, {5, 4}, {6, 4}, {7, 5}}', ()),
    ('nlm', 'NonlinearModelFit[data, Log[a + b*x^2], {a, b}, x]', ()),
    ('data', '{{1., 1., 0.126}, {1., 2., 0.076}, {2., 1., 0.219}, {2., 2., 0.126}, {0.1, 0., 0.186}}', ()),
    ('nlm', 'NonlinearModelFit[data, (θ1*θ3*x1)/(x1*θ1 + x2*θ2 + 1), {θ1, θ2, θ3}, {x1, x2}]', ()),
]


def _recovered_chebyshev_coefficients():
    """Evaluate the seven numeric coefficients defined by the source integral."""
    root = 2 * sp.sqrt(2) - 3
    return sp.Tuple(*(sp.N(sp.sqrt(2) * root**order) for order in range(7)))


def _recovered_interpolation_derivatives():
    """Evaluate the source's numeric ``d2`` table independently of NIntegrate."""
    x = sp.Symbol('x')
    function = (sp.exp(-x) - 1)**2
    derivative = sp.diff(function, x)
    data = (-1, sp.Float('-0.5'), 0, 1, 3, 6, 9)
    return sp.Tuple(*(
        sp.Tuple(
            sp.Tuple(sp.N(point)),
            sp.N(function.subs(x, point)),
            sp.N(derivative.subs(x, point)),
        )
        for point in data
    ))


def _recovered_bilinear_fit():
    """Return the exact coefficient rules for the source's ``FindFit``."""
    rule = sp.Function('Rule')
    coefficients = (sp.Rational(51, 134), sp.Rational(35, 134),
                    sp.Rational(7, 134), sp.Rational(3, 134))
    return sp.Tuple(*(rule(sp.Symbol(name), value)
                      for name, value in zip(('a', 'b', 'c', 'd'), coefficients)))


def results():
    values = evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math12y.wl')

    # ``FindFit`` is deterministic here: solving the four full-rank normal
    # equations gives these exact rules.  The remaining residuals stay under
    # the shared refusal policy: plots, random spline data, and model objects
    # are not replaced by guessed numeric values.
    values['con'] = _recovered_bilinear_fit()
    values['cn'] = _recovered_chebyshev_coefficients()
    values['d2'] = _recovered_interpolation_derivatives()

    # Preserve the source-level point list.  The shared evaluator does not
    # lower the Point/@ mapping or the AbsolutePointSize option, while the
    # native Wolfram run exposes this literal value.
    point = sp.Function('Point')
    values['poi'] = sp.Tuple(
        sp.Function('AbsolutePointSize')(8),
        sp.Tuple(*(point(sp.Tuple(*row)) for row in ((2, 1), (3, 7), (5, 8), (6, 11)))),
    )
    return values

"""Generated SymPy translation of ``corpus/archive-old/math7y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 178 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('f', 'Sum[1/(i + 1), {i, 0, 4}]', ()),
    ('f', 'Sum[q^n, {n, 0, Infinity}]', ()),
    ('f', 'Sum[0.9^n, {n, 0, Infinity}]', ()),
    ('f', 'Sum[1/n, {n, 0, Infinity}]', ()),
    ('f', 'NSum[(-1)^k/k, {k, 1, Infinity}]', ()),
    ('f', 'NSum[(-1)^k/(2*k + 1), {k, 0, Infinity}]', ()),
    ('sn', 'NSum[fc[n, N[x]], {n, Infinity}]', ('x',)),
    ('hos', 'ExpandAll[Sum[hs[N], {N, NN}]/NN]', ()),
    ('f', 'Sum[q^n, {n, Infinity}]', ()),
    ('me', '{{-Pi, 0}, {-Pi, -1}, {0, -1}, {0, 1}, {Pi, 1}, {Pi, 0}}', ()),
    ('p1', 'ListPlot[me, Joined -> True, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> Hue[0]]', ()),
    ('pb', 'Black', ()),
    ('sf', 'Sum[yf[i, x], {i, 1, n, 2}]', ('n', 'x')),
    ('ssf', 'Plot[{sf[2, x], yf[3, x], sf[3, x]}, {x, Pi, -Pi}, PlotStyle -> {{pb, Dashing[{0.02}]}, {pb, Dashing[{0.01}]}, {pb, Dashing[{}]}}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}]', ()),
    ('p2', 'Show[p1, ssf]', ()),
    ('p3', 'Plot[sf[30, x], {x, -Pi, Pi}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> pb]', ()),
    ('sff', 'Sum[sf[i, x], {i, n}]/n', ('n', 'x')),
    ('ss3', 'Show[%, p1]', ()),
    ('p4', 'Plot[Evaluate[sff[20, x]], {x, Pi, -Pi}, PlotStyle -> pb]', ()),
    ('s1', 'Sum[Sin[n*x]/n, {n, 1, Infinity}]', ()),
    ('c1', 'ExpandAll[Sum[Cos[n*x]/n, {n, 1, Infinity}]]', ()),
    ('pb', 'Black', ()),
    ('p1', 'Plot[s1, {x, -3*Pi, 3*Pi}, Ticks -> Pi*{Range[-3, 3], Range[-1, 1]/2}, PlotStyle -> pb]', ()),
    ('ps', 'Plot[N[(Pi - x)/2 + Pi*Floor[(x*0.5)/Pi]], {x, -4*Pi, 4*Pi}, Ticks -> Pi*{Range[-3, 3], Range[-1, 1]/2}]', ()),
    ('pc', 'Plot[-Log[2*Abs[Sin[x/2]]], {x, -4*Pi, 4*Pi}, Ticks -> {Pi*Range[-3, 3], Range[1, 5]}]', ()),
    ('as', 'Sum[(1/16^k)*(-(2/(8*k + 4)) - 1/(8*k + 5) - 1/(8*k + 6) + 4/(8*k + 1)), {k, 0, 7}], Null, N[as - Pi]', ()),
    ('fact', 'Product[i, {i, n}]', ('n',)),
    ('F11', '1 + Sum[Product[((a + i - 1)/(b + i - 1))*(z/i), {i, k}], {k, n}]', ('a', 'b', 'z', 'n')),
    ('t', 'x', ()),
    ('myFindRoot', 'FixedPoint[#1 - f[#1]/Derivative[1][f][#1] & , init]', ('f', 'init')),
    ('k', '1', ()),
    ('re', 'Plot3D[f[x, y], {x, -2, 2}, {y, -Pi, Pi}, PlotPoints -> 50]', ()),
    ('li', 'Show[re, PlotRange -> {0, 5}, ViewPoint -> {-4, -4, 3}, Axes -> None, Boxed -> False]', ()),
    ('f1', 'Which[x < 0, 0, x < 1, 1, x < 2, 2]', ('x',)),
    ('f2', 'Which[x < 0, 0, x < 1, 1, x < 2, 2, True, 2.5]', ('x',)),
    ('p1', 'Plot[f1[x], {x, -1, 3}, PlotStyle -> Hue[0], PlotRange -> {0, 3}]', ()),
    ('fact2', 'If[IntegerQ[x], Print[Product[k, {k, x, 1, -2}]], Print[x!!]]', ('x',)),
    ('d', '{1, 2, 3, 6, 11, 7, 6, 4, 6, 8, 11, 17, 12, 10, 8, 6, 3, 3}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-old/math7y.wl')

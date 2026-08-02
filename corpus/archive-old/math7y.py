"""Generated SymPy translation of ``corpus/archive-old/math7y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 171 non-assignment statement(s) remain.
COMPARE = {
    'ps': 'numeric',
    'sn': 'numeric',
}
_ASSIGNMENTS = [
    ('f', 'Sum[1/(i + 1), {i, 0, 4}]', ()),
    ('f', 'Sum[q^n, {n, 0, Infinity}]', ()),
    ('f', 'Sum[0.9^n, {n, 0, Infinity}]', ()),
    ('f', 'Sum[1/n, {n, 0, Infinity}]', ()),
    ('s1', 'Expand[Sum[Sin[(2*i - 1)*x]/i, {i, n}]]', ('n', 'x')),
    ('s2', 'Expand[Sum[Sin[i*x]/i, {i, 1, n, 2}]]', ('n', 'x')),
    ('f', 'NSum[(-1)^k/k, {k, 1, Infinity}]', ()),
    ('f', 'NSum[(-1)^k/(2*k + 1), {k, 0, Infinity}]', ()),
    ('fc', '(-(-1)^n)*(Cos[n*x]/n)', ('n', 'x')),
    ('sn', 'NSum[fc[n, N[x]], {n, Infinity}]', ('x',)),
    ('fe', 'Log[2*Cos[x/2]]', ('x',)),
    ('hos', 'ExpandAll[Sum[hs[N], {N, NN}]/NN]', ()),
    ('f', 'Sum[q^n, {n, Infinity}]', ()),
    ('me', '{{-Pi, 0}, {-Pi, -1}, {0, -1}, {0, 1}, {Pi, 1}, {Pi, 0}}', ()),
    ('p1', 'ListPlot[me, Joined -> True, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> Hue[0]]', ()),
    ('pb', 'Black', ()),
    ('yf', '(4/Pi)*(Sin[n*x]/n)', ('n', 'x')),
    ('sf', 'Sum[yf[i, x], {i, 1, n, 2}]', ('n', 'x')),
    ('ssf', 'Plot[{sf[2, x], yf[3, x], sf[3, x]}, {x, Pi, -Pi}, PlotStyle -> {{pb, Dashing[{0.02}]}, {pb, Dashing[{0.01}]}, {pb, Dashing[{}]}}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}]', ()),
    ('p2', 'Show[p1, ssf]', ()),
    ('p3', 'Plot[sf[30, x], {x, -Pi, Pi}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> pb]', ()),
    ('sff', 'Sum[sf[i, x], {i, n}]/n', ('n', 'x')),
    ('ss3', 'Show[%, p1]', ()),
    ('p4', 'Plot[Evaluate[sff[20, x]], {x, Pi, -Pi}, PlotStyle -> pb]', ()),
    ('ss0', 'Show[p1, p4, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}]', ()),
    ('s1', 'Sum[Sin[n*x]/n, {n, 1, Infinity}]', ()),
    ('c1', 'ExpandAll[Sum[Cos[n*x]/n, {n, 1, Infinity}]]', ()),
    ('pb', 'Black', ()),
    ('p1', 'Plot[s1, {x, -3*Pi, 3*Pi}, Ticks -> Pi*{Range[-3, 3], Range[-1, 1]/2}, PlotStyle -> pb]', ()),
    ('p2', 'Plot[c1, {x, -3*Pi, 3*Pi}, Ticks -> {Pi*Range[-3, 3], Range[1, 5]}, PlotStyle -> pb]', ()),
    ('ps', 'Plot[N[(Pi - x)/2 + Pi*Floor[(x*0.5)/Pi]], {x, -4*Pi, 4*Pi}, Ticks -> Pi*{Range[-3, 3], Range[-1, 1]/2}]', ()),
    ('pc', 'Plot[-Log[2*Abs[Sin[x/2]]], {x, -4*Pi, 4*Pi}, Ticks -> {Pi*Range[-3, 3], Range[1, 5]}]', ()),
    ('su', '4*Sum[(-1)^(k - 1)/(2*k - 1), {k, 1, NN}]', ('NN',)),
    ('as', 'Sum[(1/16^k)*(-(2/(8*k + 4)) - 1/(8*k + 5) - 1/(8*k + 6) + 4/(8*k + 1)), {k, 0, 7}]', ()),
    ('fact', 'Product[i, {i, n}]', ('n',)),
    ('fact', 'Product[i, {i, n}]', ('n',)),
    ('fact2', 'Product[i, {i, n, 1, -2}]', ('n',)),
    ('piu', '(Product[2*k, {k, n}]/Product[2*k - 1, {k, n}])^2/n', ('n',)),
    ('F11', '1 + Sum[Product[((a + i - 1)/(b + i - 1))*(z/i), {i, k}], {k, n}]', ('a', 'b', 'z', 'n')),
    ('t', 'x', ()),
    ('myFindRoot', 'FixedPoint[#1 - f[#1]/Derivative[1][f][#1] & , init]', ('f', 'init')),
    ('g', 'Sin[x] + Cos[2*x]/2', ('x',)),
    ('theta', 'If[x > 0, 1, 0]', ('x',)),
    ('thetag', 'If[x >= 0, 1, 0]', ('x',)),
    ('thetal', 'If[x <= 0, 0, 1]', ('x',)),
    ('k', '1', ()),
    ('theta', 'Which[x > 0, 1, x == 0, 1/2, x < 0, 0]', ('x',)),
    ('h', 'Which[x^2 < 1, Sqrt[1 - x^2], True, 0]', ('x',)),
    ('theta', 'Which[x > 0, 1, x = 0, 1/2, x < 0, 0]', ('x',)),
    ('theta2', 'If[x > 0 && y > 0, 1, 0]', ('x', 'y')),
    ('theta2', 'If[x > 0 || y > 0, 1, 0]', ('x', 'y')),
    ('f', 'Which[x < 0 && y < 0, 0, True, g[x, y]]', ('x', 'y')),
    ('re', 'Plot3D[f[x, y], {x, -2, 2}, {y, -Pi, Pi}, PlotPoints -> 50]', ()),
    ('li', 'Show[re, PlotRange -> {0, 5}, ViewPoint -> {-4, -4, 3}, Axes -> None, Boxed -> False]', ()),
    ('f1', 'Which[x < 0, 0, x < 1, 1, x < 2, 2]', ('x',)),
    ('f2', 'Which[x < 0, 0, x < 1, 1, x < 2, 2, True, 2.5]', ('x',)),
    ('p1', 'Plot[f1[x], {x, -1, 3}, PlotStyle -> Hue[0], PlotRange -> {0, 3}]', ()),
    ('p2', 'Plot[f2[x], {x, -1, 3}, PlotStyle -> Hue[0], PlotRange -> {0, 3}]', ()),
    ('fact', 'If[IntegerQ[x], Product[k, {k, x}], Gamma[x + 1]]', ('x',)),
    ('fact2', 'If[IntegerQ[x], Print[Product[k, {k, x, 1, -2}]], Print[x!!]]', ('x',)),
    ('fact2', 'If[IntegerQ[x], Print[Product[k, {k, x, 1, -2}]], Print[x!!]]', ('x',)),
    ('fact2', 'If[IntegerQ[x], Return[Product[k, {k, x, 1, -2}]], Return[x!!]]', ('x',)),
    ('ma', '{{a + b, 0, c - 1, 0}, {0, d*5, 0, 12*b}, {s + 1, 0, a - d, 0}, {0, 1, 0, 4}}', ()),
    ('d', '{1, 2, 3, 6, 11, 7, 6, 4, 6, 8, 11, 17, 12, 10, 8, 6, 3, 3}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-old/math7y.wl')

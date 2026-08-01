"""Generated SymPy translation of ``corpus/archive-tu/math7u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 23 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('p1', 'ListPlot[{{-Pi, Pi/2}, {Pi, -Pi/2}}, Joined -> True, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> Hue[0]]', ()),
    ('yf', '(-1)^k*(Sin[k*x]/k)', ('k', 'x')),
    ('sf', 'Sum[yf[k, x], {k, 1, n}]', ('n', 'x')),
    ('ssf', 'Plot[{sf[2, x], sf[3, x], sf[20, x]}, {x, -Pi, Pi}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> {{Black, Dashing[{0.02}]}, {Black, Dashing[{0.01}]}, {Black, Dashing[{}]}}]', ()),
    ('sff', 'Sum[sf[i, x], {i, n}]/n', ('n', 'x')),
    ('ssff', 'Plot[{sff[2, x], sff[3, x], sff[20, x]}, {x, -Pi, Pi}, Ticks -> {Pi*(Range[-2, 2]/2), Range[-1, 1]}, PlotStyle -> {{Black, Dashing[{0.02}]}, {Black, Dashing[{0.01}]}, {Black, Dashing[{}]}}]', ()),
    ('ss0', 'Show[p1, ssf]', ()),
    ('f', 'Pi^2/6 - x*(Pi/2) + x^2/4', ('x',)),
    ('yf', 'Cos[k*x]/k^2', ('k', 'x')),
    ('sf', 'Sum[yf[k, x], {k, 1, 100}]', ('x',)),
    ('f', 'x*(Pi^2/6) - x^2*(Pi/4) + x^3/12', ('x',)),
    ('yf', 'Sin[k*x]/k^3', ('k', 'x')),
    ('sf', 'Sum[yf[k, x], {k, 1, 100}]', ('x',)),
    ('y', '1 - Exp[2*Pi*I*(k/n)]', ('k', 'n')),
    ('p', 'Product[y[k, n], {k, 1, n - 1}]', ('n',)),
    ('y', '1 - z/(n - 1/2)', ('z', 'n')),
    ('p', 'Product[y[z, n], {n, -Infinity, Infinity}]', ('z',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math7u.wl')

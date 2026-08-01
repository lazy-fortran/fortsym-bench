"""Generated SymPy translation of ``corpus/archive-old/math3y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 138 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('f', 'x', ()),
    ('h', 'f^2', ()),
    ('g', '"f^2"', ()),
    ('f', '2*x^3', ()),
    ('f', 'Pi^5', ()),
    ('f', '%', ()),
    ('z', '2^1000', ()),
    ('f', 'x', ()),
    ('f', 'Pi', ()),
    ('f', '(a + b)*(a - b)', ()),
    ('g', 'Expand[f]', ()),
    ('g', '(a^3 - b^3)/(a - b)', ()),
    ('g', '(a^7 - b^7)/(a - b)', ()),
    ('h', 'g /. b -> 3', ()),
    ('x', '3', ()),
    ('f', '(x + a)^2', ()),
    ('f', '(x + a)^2', ()),
    ('z', '3 + 4*I', ()),
    ('z', 'a + b*I', ()),
    ('f', 'Series[Cos[x], {x, 0, 5}]', ()),
    ('g', 'Series[Sin[x], {x, 0, 5}]', ()),
    ('ma', '{{12, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {12, 10, -2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2}, {0, -4, 8, -1, 0, 0, 0, -3, 1, 1, 0, 0, 0, 0}, {0, 2, 0, 12, 1, 0, 0, 0, -1, -1, 0, 0, 0, 0}, {12, 0, 0, 2, 8, -1, -1, 0, -1, -1, 0, 0, 0, 0}, {0, -2, 1, 0, -2, 6, 1, 0, 0, 2, -1, 0, 0, 0}, {0, -2, 1, 0, -2, 1, 6, 0, 2, 0, -1, 0, 0, 0}, {0, 0, -2, 0, 1, 0, 0, 6, 0, 0, 0, 0, 0, 0}, {0, -1, 1, -2, -1, 0, 1, 0, 8, 0, 0, 0, 2, -2}, {0, -1, 1, -2, -1, 1, 0, 0, 0, 8, 0, 0, 2, -2}, {0, 2, 0, 2, 0, -1, -1, 0, 0, 0, 6, -2, -4, 0}, {0, 0, 0, 0, -2, 0, 0, 0, 0, 0, -2, 4, 0, -2}, {-6, 0, 0, 0, 0, 0, 0, 0, 1, 1, -1, 0, 8, 0}, {0, 2, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 8}}', ()),
    ('im', 'Timing[Inverse[ma]]', ()),
    ('b', 'ma - x*IdentityMatrix[14]', ()),
    ('f', 'Timing[Det[b]]', ()),
    ('sys', '{5*x + 1*y == 3, 4*x - 3*y == 2}', ()),
    ('sol', 'Flatten[%]', ()),
    ('ma', '{{5, 1}, {4, -3}}', ()),
    ('sol', 'Solve[p2 == 0, x]', ()),
    ('p3', 'x^3 + x + 1', ()),
    ('sn', 'NSolve[p3 == 0]', ()),
    ('s3', 'Solve[p3 == 0]', ()),
    ('p5', 'x^5 - x + 1', ()),
    ('s5', 'Solve[p5 == 0]', ()),
    ('ns5', 'N[%]', ()),
    ('p3', 'x^3 + x + 1', ()),
    ('s1', 'FindRoot[p3, {x, 1}]', ()),
    ('s2', 'FindRoot[p3, {x, I}]', ()),
    ('s3', 'FindRoot[p3, {x, -I}]', ()),
    ('so', '{s1, s2, s3}', ()),
    ('f', 'z^2 + Conjugate[z]', ()),
    ('m', '1', ()),
    ('g', '10', ()),
    ('a', '0.3', ()),
    ('sys', 'm*b[t] == {0, (-m)*g}', ()),
    ('sys', 'Thread[sys]', ()),
    ('sysa', 'Thread[m*b[t] == {0, (-m)*g} - a*v[t]*Sqrt[Derivative[1][x][t]^2 + Derivative[1][y][t]^2]]', ()),
    ('anf', '{x[0] == 0, y[0] == 0, Derivative[1][x][0] == 2, Derivative[1][y][0] == 10}', ()),
    ('sol', 'Flatten[NDSolve[Join[sys, anf], {x, y}, {t, 0, 4}]]', ()),
    ('sola', 'Flatten[NDSolve[Join[sysa, anf], {x, y}, {t, 0, 2}]]', ()),
    ('p', 'ParametricPlot[Evaluate[{x[t], y[t]} /. sol], {t, 0, 2}], Null, pa = ParametricPlot[Evaluate[{x[t], y[t]} /. sola], {t, 0, 1.35}, PlotStyle -> Dashing[{0.01}]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-old/math3y.wl')

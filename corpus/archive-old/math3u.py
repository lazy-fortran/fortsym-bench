"""Generated SymPy translation of ``corpus/archive-old/math3u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 80 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('z', '2 + I*Pi', ()),
    ('p', 'LegendreP[7, Cos[θ]]', ()),
    ('f', '{Cos[t], Cos[2*t + a]}', ()),
    ('f', 'x^20*Exp[x]', ()),
    ('fi', 'Integrate[f, {x, 0, 1}]', ()),
    ('fs', 'Series[f, {x, 0.2, 20}]', ()),
    ('f', 'Series[Sin[Sin[x]], {x, 0, 7}]', ()),
    ('f', 'Series[Tan[x], {x, Pi/2, 3}]', ()),
    ('m', '{{1, 0, 4}, {0, 5, 4}, {-4, 4, 3}}', ()),
    ('im', 'Inverse[m]', ()),
    ('b', 'm - x*IdentityMatrix[3]', ()),
    ('sys', '{a*x + b*y == c, c*x + d*y == f}', ()),
    ('ma', '{{a, b}, {c, d}}', ()),
    ('v', '{c, f}', ()),
    ('mx', '{x, y}', ()),
    ('p5', 'x^5 + x - 1', ()),
    ('sa', 'Solve[p5 == 0]', ()),
    ('nsa', 'N[sa]', ()),
    ('sn', 'NSolve[p5 == 0]', ()),
    ('p5', 'x^5 - 13*x^4 + 7', ()),
    ('sa', 'Solve[p5 == 0]', ()),
    ('nsa', 'N[sa]', ()),
    ('sn', 'NSolve[p5 == 0]', ()),
    ('f', 'Sin[x] - Cos[x]', ()),
    ('g', '(Tan[x] - x)/(x/3 + Cos[x])', ()),
    ('m', '1', ()),
    ('g', '10', ()),
    ('c', '0.3', ()),
    ('sys', 'Thread[m*a[t] == {0, (-m)*g} - c*v[t]]', ()),
    ('anf', '{x[0] == 0, y[0] == 0, Derivative[1][x][0] == 2, Derivative[1][y][0] == 10}', ()),
    ('sol', 'Flatten[NDSolve[Join[sys, anf], {x, y}, {t, 0, 2}]]', ()),
    ('F', '{ar[r, ϕ, z], ap[r, ϕ, z], az[r, ϕ, z]}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-old/math3u.wl')

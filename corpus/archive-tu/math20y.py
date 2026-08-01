"""Generated SymPy translation of ``corpus/archive-tu/math20y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 120 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('g', 'Sin[c*x], Null, c = 0.3', ('x', 'c')),
    ('eq', 'f1 = a + bx + (c/2)*x^2 + d*3.33*y + Pi*z^3 == 0', ()),
    ('s', 'NDSolve[{Derivative[1][y][x] == 2*y[x], y[0] == 1}, y, {x, 0, 3}]', ()),
    ('sn', '1234567890', ()),
    ('st', '"1234567890"', ()),
    ('sv', 'Characters[st]', ()),
    ('sw', 'FullForm[sv]', ()),
    ('s9', '"9"', ()),
    ('lp', 'Characters[ToString[Pi]]', ()),
    ('np', 'N[Pi, 17]', ()),
    ('lp', 'Characters[ToString[%]]', ()),
    ('f', '{u[2] - 2*u[1] + u[0], u[3] - 2*u[2] + u[1]}', ()),
    ('u', 'ToExpression[StringJoin["u", ToString[i]]]', ('i',)),
    ('lx', '{"x1", "x2", "x3"}', ()),
    ('h', 'f[g[a], g[b]]', ()),
    ('t', '1 + (3 + x)^2/y', ()),
    ('h', 'TreeForm[t]', ()),
    ('h', 'TreeForm[(x + y)^2 + (a*x - z)^3]', ()),
    ('h', 'TreeForm[(x + y)^2 + (a*x - z)^3]', ()),
    ('t', '1 + (3 + x)^2/y', ()),
    ('t', '1 + (3 + x)^2/y', ()),
    ('h', 'a + b + c + d + e', ()),
    ('h', '(x + y)^2 + (a*x - z)^3', ()),
    ('h1', 'ReplacePart[h, w, %[[2]]]', ()),
    ('t', '1 + (3 + x)^2/y', ()),
    ('t', '1 + (3 + x)^2/y', ()),
    ('tt', 't /. {y -> w, 3 -> 4, 2 -> 7}', ()),
    ('ttt', 'tt /. Plus -> Minus', ()),
    ('t', '1 + x + x^2 + x^3', ()),
    ('h', '(x + y)^2 + (a*x - z)^3', ()),
    ('po', 'Position[h, a*x - z]', ()),
    ('g', 'ReplacePart[h, 1, po]', ()),
    ('f', '((1 - x)^2*(x^2 + 1)^2)^(-1)', ()),
    ('g', 'Expand[Integrate[f, x]]', ()),
    ('g3', 'Take[g, 3]', ()),
    ('g12', 'Take[g, 2]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math20y.wl')

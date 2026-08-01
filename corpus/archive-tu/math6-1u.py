"""Generated SymPy translation of ``corpus/archive-tu/math6-1u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 34 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('f', 'Cos[x] - Sin[x]', ()),
    ('x0', 'FindRoot[f == 0, {x, {-6, -2, 0, 4}}]', ()),
    ('x0', 'FindRoot[x == Tan[x], {x, {-15, -9, -7, -4, 0, 4, 7, 10, 13, 19}}]', ()),
    ('x0', 'Solve[x^7 == 1, x]', ()),
    ('r', '{Re[x], Im[x]} /. x0', ()),
    ('x0', 'Solve[x^7 + 3*x^3 == 1, x]', ()),
    ('r', '{Re[x], Im[x]} /. x0', ()),
    ('x0', 'NSolve[(1/(2*x))*Exp[x] == 1, x]', ()),
    ('f', 'x^4 - 2*x^3 + x^2 + 3*x', ()),
    ('y0', 'Solve[9*x^2 - 12*y*x - 16*x + 4*y^2 + 8*y - 27 == 0, y]', ()),
    ('T', '(2/Pi)*EllipticK[Sin[a/2]^2]', ()),
    ('k1', '3', ()),
    ('k2', '2', ()),
    ('V1', 'Table[{r, r^2}, {r, 0, 1, 0.01}]', ()),
    ('f', 'Table[{Cos[p], Sin[p]}, {p, 0, 2*Pi*(4/5), 2*(Pi/5)}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math6-1u.wl')

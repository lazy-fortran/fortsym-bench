"""Generated SymPy translation of ``corpus/archive-tu/math9u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
COMPARE = {
    'a': 'numeric',
    'a1': 'numeric',
    'a2': 'numeric',
}
_ASSIGNMENTS = [
    ('F', '{{x^6 - 5*x^5 + 4*x^4 - 2*x^3 + 3*x^2 - x - 1, x^2 - x + 1}, {x^7 + x^6 - 1, x - 1}}', ()),
    ('SqTri', 'Solve[{b, a} . {s, s} == a*b && a^2 + b^2 == c^2 && a > 0 && b > 0, {a, b}, Reals]', ('s', 'c')),
    ('s', '4', ()),
    ('c', '20', ()),
    ('sol', '{a, b} /. SqTri[s, c]', ()),
    ('plots', '(ListLinePlot[{{0, 0}, {#1[[1]], 0}, {0, #1[[2]]}, {0, 0}}, PlotRange -> {{0, c}, {0, c}}] & ) /@ sol', ()),
    ('square', 'ListLinePlot[{{0, 0}, {s, 0}, {s, s}, {0, s}, {0, 0}}, Filling -> Axis]', ()),
    ('sol', 'Reduce[a + b + c == 3 && a^2 + b^2 + c^2 == 9 && a^3 + b^3 + c^3 == 24, {a, b, c}, Cubics -> True, Quartics -> True]', ()),
    ('sol', 'FullSimplify[sol]', ()),
    ('f', 'a^4 + 3*a^2*x + a*x^4 + x^5', ('a', 'x')),
    ('a1', 'N[Root[62208 - 2187*#1^2 - 972*#1^3 - 450*#1^4 - 7500*#1^5 + 3125*#1^6 + 256*#1^7 & , 1]]', ()),
    ('a2', 'N[Root[62208 - 2187*#1^2 - 972*#1^3 - 450*#1^4 - 7500*#1^5 + 3125*#1^6 + 256*#1^7 & , 1]]', ()),
    ('plots', '(Plot[f[#1, x], {x, -10, 15}] & ) /@ Range[-20, 0, 3]', ()),
    ('a', 'N[Root[62208 - 2187*#1^2 - 972*#1^3 - 450*#1^4 - 7500*#1^5 + 3125*#1^6 + 256*#1^7 & , 1], 30]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math9u.wl')

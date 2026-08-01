"""Generated SymPy translation of ``corpus/archive-old/math5y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 138 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('l0', '{3, 5, 1}', ()),
    ('l1', '{a, b, c, d}', ()),
    ('l2', 'l1^2', ()),
    ('p', 'x^4 - 1 + x', ()),
    ('sp', 'Solve[p == 0., x]', ()),
    ('l4', '{a, b, c, d, {al, be, ga}, e}', ()),
    ('l1', '{a, b, c}', ()),
    ('l2', '{{a11, a12, a13}, {a21, a22, a23}, {a31, a32, a33}}', ()),
    ('epst', '{{{0, 0, 0}, {0, 0, 1}, {0, -1, 0}}, {{0, 0, -1}, {0, 0, 0}, {1, 0, 0}}, {{0, 1, 0}, {-1, 0, 0}, {0, 0, 0}}}', ()),
    ('li', 'Reverse[Range[1, 8]]', ()),
    ('so', 'Solve[x + a == 0, x]', ()),
    ('li', '{{3, 5, 9}, 6, {2, 3, 4, 5, 9}, {1, 4, 9}, 7}', ()),
    ('pos4', 'Position[li, 4]', ()),
    ('int', 'Integrate[x*((x + 2)^2/((x - 1)*(x + 3))), x]', ()),
    ('polog', 'Position[int, Log]', ()),
    ('poly', 'c^3 + a*x^3 + 3*x*y + b^4*y^3', ()),
    ('powerPositions', 'Position[poly, (y_)^(n_)]', ()),
    ('l1', '{a, b, c, d}', ()),
    ('l2', 'ReplacePart[l1, 10, 2]', ()),
    ('lf', '(a^2 + 3*a*b*c)^2', ()),
    ('l1', '{a, b, c}', ()),
    ('l2', '{d, e, c}', ()),
    ('l3', 'Join[l1, l2]', ()),
    ('l4', 'Union[l1, l2]', ()),
    ('ll', '{{1, 2, 3, 4}, {5, 6}, {7, 8}, {9, 10}, {11, 12}}', ()),
    ('lx', '{x1, x2, x3, x4, x5}', ()),
    ('lt', 'lx == l4', ()),
    ('n', '5', ()),
    ('lt', 'lx == l4', ()),
    ('lst', 'Table[a[i], {i, 20}]', ()),
    ('le', 'lst[[Table[k, {k, 1, Length[lst], 2}]]]', ()),
    ('le', 'lst[[Table[k, {k, 2, Length[lst], 2}]]]', ()),
    ('le', 'lst[[Table[k, {k, 1, Length[lst], 3}]]]', ()),
    ('lx', '{x1, x2, x3, x4, x5}', ()),
    ('lxy', 'Transpose[{lx, ly}]', ()),
    ('li', '{r1, r2, r3, r4, r5}', ()),
    ('ls', 'FoldList[Plus, r1, Drop[li, 1]]', ()),
    ('lr', 'RandomReal[{0, 1}, 1000]', ()),
    ('l2', '{a, 2, r}', ()),
    ('l3', '{a, b, c, d}', ()),
    ('la', 'Union[l1, l2, l3]', ()),
    ('li', 'Intersection[l1, l2, l3]', ()),
    ('a', 'N[{Pi, Pi + 10^(-5), Pi - 10^(-5)}, 6]', ()),
    ('testdiff', 'If[NumericQ[#1 - #2], Abs[N[#1 - #2]] < 10^(-4), #1 == #2] &', ()),
    ('li', '{1, 2, 3, -5, a, b, d, 0.33, -0.73}', ()),
    ('ll', '{a, b, c, 1, 2, 3, 1/2, 3/4, 0.5, 0.33, 0.2 + 0.3*I, -4, -5, -0.77}', ()),
    ('li', '{1, 2, 3, 4}', ()),
    ('ex', 'c + E^(-x^2) + Exp[z^2] + w^5^x + s^2 + 1/y^2 + 1', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-old/math5y.wl')

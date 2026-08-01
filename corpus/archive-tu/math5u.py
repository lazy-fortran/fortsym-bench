"""Generated SymPy translation of ``corpus/archive-tu/math5u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('y', 'Table[{Cos[k*2*(Pi/8)], Sin[k*2*(Pi/8)]}, {k, 0, 7}]', ()),
    ('num', 'Range[0, 10, 1]', ()),
    ('y', 'Table[Cos[n*x], {n, 1, 7, 2}]', ()),
    ('num', 'Range[0, 6]', ()),
    ('num', 'MapAt[Pi^#1 & , num, {{1}, {3}, {5}, {7}}]', ()),
    ('DivideList', 'RotateLeft[#1]/#1 &', ()),
    ('list', '{a, b, c, e, b, e, f, f, a, d, b, c}', ()),
    ('l1', '{2, a, c, 4}', ()),
    ('l2', '{3, c, f, a, 5}', ()),
    ('l3', 'Flatten[{l1, l2}]', ()),
    ('xl', 'Range[1, 10]', ()),
    ('yl', 'Range[2, 20, 2]', ()),
    ('xyl', 'Transpose[{xl, yl}]', ()),
    ('lx', '{{x11, x12, x13}, {x21, x22, x33}, {x31, x32, x33}}', ()),
    ('ly', '{{y11, y12, y13}, {y21, y22, y33}, {y31, y32, y33}}', ()),
    ('lxy', 'Riffle[lx, ly]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math5u.wl')

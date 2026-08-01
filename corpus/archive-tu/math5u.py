"""Generated SymPy translation of ``corpus/archive-tu/math5u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 18 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('y', 'Table[{Cos[k*2*(Pi/8)], Sin[k*2*(Pi/8)]}, {k, 0, 7}]', ()),
    ('num', 'Range[0, 10, 1]', ()),
    ('y', 'Table[Cos[n*x], {n, 1, 7, 2}]', ()),
    ('num', 'Range[0, 6]', ()),
    ('num', 'MapAt[Pi^#1 & , num, {{1}, {3}, {5}, {7}}]', ()),
    ('DivideList', 'RotateLeft[#1]/#1 &', ()),
    ('list', '{a, b, c, e, b, e, f, f, a, d, b, c}', ()),
    ('l1', '{2, a, c, 4}', ()),
    ('xl', 'Range[1, 10]', ()),
    ('lx', '{{x11, x12, x13}, {x21, x22, x33}, {x31, x32, x33}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math5u.wl')

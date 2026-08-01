"""Generated SymPy translation of ``corpus/archive-tu/math20u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('RelFreq', '(N[(1/Length[n])*Count[n, #1]] & ) /@ Range[0, b - 1]', ('n', 'b')),
    ('num', '{2^2^11 + 1, 100!}', ()),
    ('num10', '(IntegerDigits[#1, 10] & ) /@ num', ()),
    ('num8', '(IntegerDigits[#1, 8] & ) /@ num', ()),
    ('pidigits', 'RealDigits[Pi, 10, 100]', ()),
    ('f', 'ReplacePart[f, w, Position[f, x, 3]]', ()),
    ('f', 'f /. a -> 5', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math20u.wl')

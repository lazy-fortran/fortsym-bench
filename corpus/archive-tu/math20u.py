"""Generated SymPy translation of ``corpus/archive-tu/math20u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
COMPARE = {
    'RelFreq': 'numeric',
}
_ASSIGNMENTS = [
    ('RelFreq', '(N[(1/Length[n])*Count[n, #1]] & ) /@ Range[0, b - 1]', ('n', 'b')),
    ('num', '{2^2^11 + 1, 100!}', ()),
    ('num10', '(IntegerDigits[#1, 10] & ) /@ num', ()),
    ('num8', '(IntegerDigits[#1, 8] & ) /@ num', ()),
    ('pidigits', 'RealDigits[Pi, 10, 100]', ()),
    ('f', '5*x^2 + 7*((x + z^3)^(1/2)/(5 + z^2))', ()),
    ('f', 'ReplacePart[f, w, Position[f, x, 3]]', ()),
    ('f', 'ReplacePart[f, v, Position[f, x, 4]]', ()),
    ('f', 'ReplacePart[f, 4, Position[f, 5, 2]]', ()),
    ('f', 'ReplacePart[f, 25*y^4, Position[f, 5 + z^2]]', ()),
    ('f', 'f /. z^3 -> z^4', ()),
    ('f', 'f /. (i_)^(1/2) -> i^(3/2)', ()),
    ('f', 'f /. 7 -> 17', ()),
    ('f', 'Sin[a*x]*Exp[b + c*y]*Log[d*z]', ()),
    ('f', 'f /. a -> 5', ()),
    ('f', 'ReplacePart[f, 7*c*y, Position[f, b + c*y]]', ()),
    ('f', 'f /. z -> u^2', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math20u.wl')

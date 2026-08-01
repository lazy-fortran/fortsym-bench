"""Generated SymPy translation of ``corpus/archive-tu/math21u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 28 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('GeoMean', 'Times @@ a^(1/Length[a])', ('a',)),
    ('HarmMean', 'Length[a]/Plus @@ (1/a)', ('a',)),
    ('Dop', 'Derivative[2][u][r] + (2/r)*Derivative[1][u][r] - L*((L + 1)/r^2) + k^2', ()),
    ('list1', '{{{{a, b}}, {{c, d}}}, {{{p, q}}, {{r, s}}}}', ()),
    ('list2', '{{{0.3, 0.5}}, {{0.6, 1.}}, {{0.9, 1.5}}, {{1.2, 2.}}}', ()),
    ('lx', '{x1, x2, x3, x4, x5}', ()),
    ('lxs', 'ToString[lx]', ()),
    ('lvc', 'Characters[lxs] /. "x" -> "v"', ()),
    ('lvs', 'StringJoin[lvc]', ()),
    ('lv', 'ToExpression[lvs]', ()),
    ('la', 'ToExpression[Table[{StringJoin[{"ax", ToString[i]}], StringJoin[{"ay", ToString[i]}], StringJoin[{"az", ToString[i]}]}, {i, 1, n}]]', ('n',)),
    ('lb', 'ToExpression[Table[{StringJoin[{"bx", ToString[i]}], StringJoin[{"by", ToString[i]}], StringJoin[{"bz", ToString[i]}]}, {i, 1, n}]]', ('n',)),
    ('f', 'FactorInteger[11244102684192486488811361002585612418726608312031552683325339048893]', ()),
    ('MultiplyFactors', 'Times @@@ {(#1[[1]]^#1[[2]] & ) /@ k}', ('k',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math21u.wl')

"""Generated SymPy translation of ``corpus/proj-iter_tc24/ell0_layer.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('report', 'Print[If[TrueQ[ok], "PASS ", "FAIL "], name]', ('name', 'ok')),
    ('krook', 'Assuming[{nu > 0, a > 0, L > 0},\n   Integrate[nu/((a x)^2 + nu^2), {x, -L, L}]]', ()),
    ('krookLimit', 'Assuming[{a > 0, L > 0}, Limit[krook, nu -> 0, Direction -> "FromAbove"]]', ()),
    ('krookCorrection', 'Assuming[{a > 0, L > 0},\n   Normal[Series[krook, {nu, 0, 1}]]]', ()),
    ('dupreeIntegral', 'NIntegrate[dupree[x], {x, -60, 60},\n   PrecisionGoal -> 5, MaxRecursion -> 12]', ()),
    ('ratios', 'Table[{d, plateauRatio[d]}, {d, {0.5, 1., 2., 5., 10., 30.}}]', ()),
    ('OmTE', '5233.3270632894701', ()),
    ('OmTBref', '-997.11612246418201', ()),
    ('uc', '2.7332', ()),
    ('Gmax', '-OmTE/(OmTBref uc^2)', ()),
    ('x0sq', '1.835^2', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-iter_tc24/ell0_layer.wl')

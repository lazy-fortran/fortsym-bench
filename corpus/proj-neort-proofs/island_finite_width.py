"""Generated SymPy translation of ``corpus/proj-neort-proofs/island_finite_width.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 21 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('wHalf', '2 Sqrt[Hm/Op]', ('Hm', 'Op')),
    ('Wisl', '4 Sqrt[Hm/Op]', ('Hm', 'Op')),
    ('dJisl', 'ai Sqrt[Hm]', ('Hm',)),
    ('dJlin', 'al Hm', ('Hm',)),
    ('AQLw', '(2 Pi/(kk w)/td)^3', ('w',)),
    ('keff', 'kNT kQP/(kNT + kQP)', ('kNT', 'kQP')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/island_finite_width.wl')

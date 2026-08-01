"""Generated SymPy translation of ``corpus/proj-neort-proofs/flux_coordinate_limits.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 30 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Hflux', '(mA/2) (vpar0 (1 + x)/(1 + y))^2 + muB0 (1 + x)', ()),
    ('dHx', 'D[Hflux, x] /. {x -> 0, y -> 0}', ()),
    ('dHy', 'D[Hflux, y] /. {x -> 0, y -> 0}', ()),
    ('H1gen', 'dHx xx + dHy yy', ('xx', 'yy')),
    ('kapEta', '(1 - e Ba (1 - eps))/(2 e Ba eps)', ('e',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/flux_coordinate_limits.wl')

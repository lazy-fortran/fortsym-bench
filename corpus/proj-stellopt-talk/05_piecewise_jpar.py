"""Generated SymPy translation of ``corpus/proj-stellopt-talk/05_piecewise_jpar.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('jp', 'Piecewise[{{j1, 0 < a < 1}, {j2, 1 < a < 2}}, Indeterminate]', ('a',)),
    ('djp', 'D[jp[a], a]', ('a',)),
    ('limLeft', 'Limit[jp[a], a -> 1, Direction -> "FromBelow"]', ()),
    ('limRight', 'Limit[jp[a], a -> 1, Direction -> "FromAbove"]', ()),
    ('vals', '{j1 -> 1, j2 -> 3/2}', ()),
    ('psidotP1', '-(djp[1/2])/(q taub)', ()),
    ('psidotP2', '-(djp[3/2])/(q taub)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/05_piecewise_jpar.wl')

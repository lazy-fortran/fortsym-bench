"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/04_collision_and_splitting.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('fM', 'Exp[-v^2/(2 theta)]', ()),
    ('radialFlux', 'v fM + theta D[fM, v]', ()),
    ('pitchTerm', 'D[(1 - xi^2) D[fM, xi], xi]', ()),
    ('pitchFlux', "(1 - xi^2) g'[xi]", ()),
    ('exactSeries', 'Normal[Series[Exp[dt (a + b)], {dt, 0, 1}]]', ()),
    ('splitSeries', 'Normal[Series[Exp[dt a] Exp[dt b], {dt, 0, 1}]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/04_collision_and_splitting.wl')

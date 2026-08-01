"""Generated SymPy translation of ``corpus/proj-stellopt-talk/15_subspace_costs.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('tol', '10.^-10', ()),
    ('jm', 'RandomReal[{-1, 1}, {8, 5}]', ()),
    ('sig', 'Diagonal[s]', ()),
    ('vmin', 'v[[All, -1]]', ()),
    ('sigmin', 'Last[sig]', ()),
    ('rand', 'Table[Normalize[RandomReal[{-1, 1}, 5]], {200}]', ()),
    ('minRand', 'Min[Norm[jm . #] & /@ rand]', ()),
    ('fdCost', 'nN + 1', ()),
    ('subCost', 'd + 1', ()),
    ('stochCost', '2 k', ()),
    ('inst', '{nN -> 100, d -> 7, k -> 3}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/15_subspace_costs.wl')

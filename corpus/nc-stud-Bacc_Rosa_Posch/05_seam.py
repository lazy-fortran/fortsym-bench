"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/05_seam.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('sol', "DSolve[{I OmE g[x] - nu g''[x] == 1, g[0] == 0, g'[1] == 0}, g[x], x]", ()),
    ('gx', 'Simplify[g[x] /. sol[[1]], Assumptions -> {nu > 0, OmE > 0, 0 < x < 1}]', ()),
    ('kappa', 'Sqrt[I OmE/nu]', ()),
    ('Aexact', 'Integrate[gx, {x, 0, 1}]', ()),
    ('AR', 'Re[Aexact /. {nu -> nuv, OmE -> OmEv}]', ('nuv', 'OmEv')),
    ('Aseries', 'Series[Aexact /. nu -> eps^2 OmE, {eps, 0, 1}] // Normal', ()),
    ('AseriesRe', 'Simplify[ComplexExpand[Re[Aseries]],\n  Assumptions -> {eps > 0, OmE > 0}]', ()),
    ('ratio', 'N[AR[10^-6, 1]/Sqrt[10^-6/2], 8]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/05_seam.wl')

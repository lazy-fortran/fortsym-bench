"""Generated SymPy translation of ``corpus/code-genex/equi_ref_domm.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 23 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('CWD', 'Directory[]', ()),
    ('absB', 'absBDommaschk[x, phi, z]', ()),
    ('b', 'BDommaschk[x, phi, z] / absB', ()),
    ('curlnormby', 'Simplify[b . Curl[b, {x, phi, z}, "Cylindrical"]]', ()),
    ('dabsBdx', 'D[absB, x]', ()),
    ('dabsBdy', 'b . Grad[absB, {x, phi, z}, "Cylindrical"]', ()),
    ('dabsBdz', 'D[absB, z]', ()),
    ('dgyzdx', 'D[b[[3]], x]', ()),
    ('dgyxdz', 'D[b[[1]], z]', ()),
    ('dgyzdz', 'D[b[[3]], z]', ()),
    ('dgyxdx', 'D[b[[1]], x]', ()),
    ('dgyxdy', 'b[[1]] * dgyxdx \\', ()),
    ('dgyzdy', 'b . Grad[b[[3]], {x, phi, z}, "Cylindrical"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-genex/equi_ref_domm.wl')

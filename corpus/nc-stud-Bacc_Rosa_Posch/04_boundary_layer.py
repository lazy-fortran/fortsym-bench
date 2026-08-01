"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/04_boundary_layer.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('sol', "DSolve[{I OmegaE g[eta] - nu g''[eta] == 1, g[0] == 0, g'[1] == 0},\n             g, eta] // First", ()),
    ('gsol', 'g[eta] /. sol', ('eta',)),
    ('kappa', 'Sqrt[I OmegaE/nu]', ()),
    ('reKappa', 'Sqrt[OmegaE/(2 nu)]', ()),
    ('chkKappa', 'Re[kappa] - reKappa /. {OmegaE -> 1.3, nu -> 1.0*^-4}', ()),
    ('gp', '1/(I OmegaE)', ()),
    ('Alead', '-Re[ComplexExpand[gp/kappa, TargetFunctions -> {Re, Im}]]', ()),
    ('Alead', 'Simplify[Alead, {OmegaE > 0, nu > 0}]', ()),
    ('target', 'Sqrt[nu/(2 OmegaE^3)]', ()),
    ('Anum', 'NIntegrate[Re[gsol[eta] /. {OmegaE -> oe, nu -> nuv}], {eta, 0, 1}]', ('oe', 'nuv')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/04_boundary_layer.wl')

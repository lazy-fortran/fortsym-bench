"""Generated SymPy translation of ``corpus/proj-gvec-stability/radial_bspline_basis.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('knots', '{0, 0, 0, 1/2, 1, 1, 1}', ()),
    ('basis', 'Table[BSplineBasis[{2, knots}, index, x], {index, 0, 3}]', ()),
    ('derivative', 'D[basis, x]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/radial_bspline_basis.wl')

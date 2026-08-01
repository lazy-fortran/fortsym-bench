"""Generated SymPy translation of ``corpus/proj-gvec-stability/finite_element_assembly.wl``.

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
    ('basis', '{1 - x/h, x/h}', ()),
    ('elementMass', 'Table[Integrate[basis[[i]] basis[[j]], {x, 0, h}], {i, 2}, {j, 2}]', ()),
    ('elementStiffness', 'Table[\n  Integrate[D[basis[[i]], x] D[basis[[j]], x], {x, 0, h}],\n  {i, 2}, {j, 2}]', ()),
    ('globalMass', 'ConstantArray[0, {3, 3}]', ()),
    ('globalStiffness', 'ConstantArray[0, {3, 3}]', ()),
    ('fixedMass', 'globalMass[[{2}, {2}]]', ()),
    ('fixedStiffness', 'globalStiffness[[{2}, {2}]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/finite_element_assembly.wl')

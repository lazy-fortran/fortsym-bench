"""Generated SymPy translation of ``corpus/proj-gvec-stability/compensated_norm_resolution.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 22 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('$Assumptions', 'Element[{x1, x2, x3, scale, c, epsilon}, Reals] &&', ()),
    ('values', '{x1, x2, x3}', ()),
    ('scaled', 'values/scale', ()),
    ('updated', 'first + term', ()),
    ('firstCorrection', '(first - updated) + term', ()),
    ('secondCorrection', '(term - updated) + first', ()),
    ('$Assumptions', 'Element[{terms, dimension}, Integers] && terms >= 1 &&', ()),
    ('firstOrderBudget', '(6 terms + 48) epsilon', ()),
    ('secondOrderBudget', '16 dimension epsilon^2', ()),
    ('rawBound', 'firstOrderBudget + secondOrderBudget', ()),
    ('resolutionFactor', 'rawBound/(1 - rawBound)', ()),
    ('$Assumptions', 'Element[{k11, k12, k22, m11, m12, m22, lambda,\n     y1, y2, c, epsilon}, Reals] && Element[{terms, dimension}, Integers] &&', ()),
    ('absolutePencil', '{{k11, k12}, {k12, k22}} +\n  lambda {{m11, m12}, {m12, m22}}', ()),
    ('mass', '{{m11, m12}, {m12, m22}}', ()),
    ('vector', '{y1, y2}', ()),
    ('ratio', 'Sqrt[(absolutePencil.v).(absolutePencil.v)]/\n  Sqrt[(mass.v).(mass.v)]', ('v',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/compensated_norm_resolution.wl')

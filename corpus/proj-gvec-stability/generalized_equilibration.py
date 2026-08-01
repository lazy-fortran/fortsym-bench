"""Generated SymPy translation of ``corpus/proj-gvec-stability/generalized_equilibration.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 18 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', 'Element[{k11, k12, k22, m11, m12, m22, lambda,\n    d1, d2, e1, e2, y1, y2}, Reals] && d1 > 0 && d2 > 0 &&', ()),
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('stiffness', '{{k11, k12}, {k12, k22}}', ()),
    ('mass', '{{m11, m12}, {m12, m22}}', ()),
    ('scale', 'DiagonalMatrix[{d1, d2}]', ()),
    ('balancedStiffness', 'scale.stiffness.scale', ()),
    ('balancedMass', 'scale.mass.scale', ()),
    ('stiffnessPivots', '{stiffness[[1, 1]],\n  Det[stiffness]/stiffness[[1, 1]]}', ()),
    ('balancedStiffnessPivots', '{balancedStiffness[[1, 1]],\n  Det[balancedStiffness]/balancedStiffness[[1, 1]]}', ()),
    ('balancedVector', '{y1, y2}', ()),
    ('originalVector', 'scale.balancedVector', ()),
    ('nextScale', 'DiagonalMatrix[{e1, e2}]', ()),
    ('tridiagonal', '{{k11, k12, 0}, {k12, k22, m12}, {0, m12, m22}}', ()),
    ('tridiagonalScale', 'DiagonalMatrix[{d1, d2, e1}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/generalized_equilibration.wl')

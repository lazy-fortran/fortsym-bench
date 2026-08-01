"""Generated SymPy translation of ``corpus/proj-maxent19-gp/airy.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('om', 'Sqrt[g*k*Tanh[k*h]]', ()),
    ('Phi', '(om/k)*(Cosh[k*(z + h)]/Sinh[k*h])*Sin[k*x - om*t]', ()),
    ('eta', 'Simplify[Cos[k*x - om*t]]', ()),
    ('om0', 'Sqrt[g*k]', ()),
    ('test', 'Sum[Cos[k*((x - xpr) - c*(t - tpr))]/k^2, {k, 1, 10}]', ()),
    ('K', 'Cos[k*(x - xpr)] + f[x - xpr]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-maxent19-gp/airy.wl')

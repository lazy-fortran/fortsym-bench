"""Generated SymPy translation of ``corpus/proj-gvec-stability/eigen_sensitivity.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
COMPARE = {
    'finiteDifference': 'numeric',
}
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('stiffness', '{{2 + p, 1/5}, {1/5, 4 - p}}', ('p',)),
    ('mass', '{{2 + p/10, 0}, {0, 3}}', ('p',)),
    ('p0', '1/3', ()),
    ('stiffnessDerivative', 'D[stiffness[p], p] /. p -> p0', ()),
    ('massDerivative', 'D[mass[p], p] /. p -> p0', ()),
    ('analytic', 'vector0.(stiffnessDerivative - lambda0 massDerivative).vector0', ()),
    ('step', '10^-5', ()),
    ('finiteDifference', '(First[eigensystem[N[p0 + step]]] -\n    First[eigensystem[N[p0 - step]]])/(2 step)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/eigen_sensitivity.wl')

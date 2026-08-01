"""Generated SymPy translation of ``corpus/proj-cpp-derivation/gyrocenter_lie_transform.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[cond]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('gyroAvg', '(1/(2 Pi)) Integrate[f[theta], {theta, 0, 2 Pi}]', ('f',)),
    ('psi', 'Function[th, a Cos[th] + b Sin[th] + c]', ()),
    ('Hgc', 'Hgc0', ()),
    ('mu', 'mu0', ()),
    ('reducedH', 'gyroAvg[Function[th, Hgc + epsd psi[th]]]', ('epsd',)),
    ('oscPart', 'Function[th, psi[th] - gyroAvg[psi]]', ()),
    ('S1', 'Function[th, a Sin[th] - b Cos[th]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/gyrocenter_lie_transform.wl')

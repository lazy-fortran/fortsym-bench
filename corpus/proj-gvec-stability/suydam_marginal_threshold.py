"""Generated SymPy translation of ``corpus/proj-gvec-stability/suydam_marginal_threshold.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[\n  TrueQ[condition],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('b1', '3/10', ()),
    ('b3', '2/5', ()),
    ('a', '1/2', ()),
    ('len', '6 Pi', ()),
    ('btheta', 'b1 r + b3 r^3', ('r',)),
    ('bigI', 'b1^2 r^2 + 3/2 b1 b3 r^4 + 2/3 b3^2 r^6', ('r',)),
    ('bzSq', '1 + 2 (1 - kappa) (bigI[a] - bigI[r])', ('r', 'kappa')),
    ('iota', 'len btheta[r]/(2 Pi r Sqrt[bzSq[r, kappa]])', ('r', 'kappa')),
    ('integralSlope', 'D[bigI[rr], rr] /. rr -> r', ('r',)),
    ('mu', 'btheta[r]/(r Sqrt[bzSq[r, kappa]])', ('r', 'kappa')),
    ('kappaStar', 'kappa /. FindRoot[marginal[kappa] == 0,\n  {kappa, 7/10, 1/10, 1}, WorkingPrecision -> 40]', ()),
    ('signs', 'Split[Table[Sign[marginal[k]], {k, 1/10, 1, 1/100}]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/suydam_marginal_threshold.wl')

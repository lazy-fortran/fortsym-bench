"""Generated SymPy translation of ``corpus/proj-flux_pumping/49_internal_helical_state.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
COMPARE = {
    'lambda50': 'numeric',
}
_ASSIGNMENTS = [
    ('$Assumptions', 'r > 0 && R0 > 0 && H0 > 0 && aedge > 0 &&', ()),
    ('c2Rule', 'c2 -> -H0 (2 k - aa)/4', ()),
    ('bthetaAxisCoeff', 'Simplify[-(2 c2 + k H0) /. c2Rule]', ()),
    ('bzAxis', 'H0', ()),
    ('iotaAxis', 'Simplify[R0 bthetaAxisCoeff/bzAxis]', ()),
    ('qTarget', '1.04', ()),
    ('aTarget', '-2/(20 qTarget)', ()),
    ('deltaSeries', 'Simplify[-(d1 r + O[r]^3)/(2 c2 r + O[r]^3)]', ()),
    ('deltaAxis', 'Block[{$Assumptions = c2 != 0},\n  Limit[Normal[deltaSeries], r -> 0]]', ()),
    ('rigidPsi1', '-del0 D[c2 r^2, r]', ()),
    ('y', 'BesselJ[1, lam r]', ('r',)),
    ('m1Residual', 'FullSimplify[D[y[r], {r, 2}] + D[y[r], r]/r +\n    (lam^2 - 1/r^2) y[r]]', ()),
    ('j11', 'BesselJZero[1, 1]', ()),
    ('lambda50', 'lam /. FindRoot[lam/(2 BesselJ[1, lam]) == 50,\n    {lam, 0.98 N[j11]}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/49_internal_helical_state.wl')

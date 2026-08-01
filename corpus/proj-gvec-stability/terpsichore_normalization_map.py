"""Generated SymPy translation of ``corpus/proj-gvec-stability/terpsichore_normalization_map.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 23 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('passed', '0', ()),
    ('failed', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  passed++; Print["PASS: ", name], failed++; Print["FAIL: ", name]]', ('name', 'condition')),
    ('$Assumptions', 'nfp > 0 && nsta > 0 && intervals > 0 &&', ()),
    ('thetaRadian', '2 Pi thetaTurn', ()),
    ('phiRadian', '2 Pi zetaPeriod/nfp', ()),
    ('jacobianTurn', '4 Pi^2 jacobianRadian/nfp', ()),
    ('bjacTerpsichore', 'nfp jacobianTurn/(4 Pi^2)', ()),
    ('exportedPhis', '-vmecPhis', ()),
    ('exportedChis', '-iota vmecPhis', ()),
    ('ftInternal', '-exportedPhis', ()),
    ('fpInternal', '-exportedChis/nfp', ()),
    ('ftpTerpsichore', '-vmecPhis', ()),
    ('fppTerpsichore', 'iota ftpTerpsichore', ()),
    ('sourceEquilibriumPhase', 'm thetaRadian - nfp n phiRadian', ()),
    ('glissEquilibriumPhase', '2 Pi (m thetaTurn - n zetaPeriod)', ()),
    ('sourceStabilityPhase', 'm thetaRadian - (n nfp/nsta) phiRadian', ()),
    ('glissStabilityPhase', '2 Pi (m thetaTurn - n zetaPeriod/nsta)', ()),
    ('volumeFromTurns', 'nfp jacobianTurn', ()),
    ('volumeFromRadians', 'nfp (4 Pi^2/nfp) bjacTerpsichore', ()),
    ('cylinderMap', '{\n  radius Sqrt[s] Cos[2 Pi thetaTurn],\n  -radius Sqrt[s] Sin[2 Pi thetaTurn], length zetaPeriod}', ()),
    ('cylinderJacobian', 'FullSimplify[Det[{\n  D[cylinderMap, s], D[cylinderMap, thetaTurn],\n  D[cylinderMap, zetaPeriod]}]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/terpsichore_normalization_map.wl')

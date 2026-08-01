"""Generated SymPy translation of ``corpus/proj-gvec-stability/mercier_screw_pinch.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, rzero > 0, mu0 > 0, bz[r] > 0,\n  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],\n    Derivative[2][btheta][r], Derivative[2][bz][r],\n    Derivative[1][p][r]}, Reals],\n  btheta[r]^2 + bz[r]^2 > 0}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('forceBalance', 'Derivative[1][p][rr_] :>\n  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -\n    bz[rr] Derivative[1][bz][rr]/mu0', ()),
    ('psiR', 'r bz[r]', ('r',)),
    ('iota', 'rzero btheta[r]/(r bz[r])', ('r',)),
    ('iotaPsi', "iota'[r]/psiR[r]", ('r',)),
    ('surfaceJacobian', 'r rzero', ()),
    ('gradPsi', 'r bz[r]', ()),
    ('bSquared', 'btheta[r]^2 + bz[r]^2', ()),
    ('surfaceIntegral', '(2 Pi)^2 f', ('f',)),
    ('muJdotB', "-bz'[r] btheta[r] + (D[s btheta[s], s] /. s -> r) bz[r]/r", ()),
    ('currentI', 'r btheta[r]', ('r',)),
    ('xiDotB', "muJdotB - (currentI'[r]/psiR[r]) bSquared", ()),
    ('dShear', 'iotaPsi[r]^2/(16 Pi^2)', ()),
    ('dCurrent', '-(1/(2 Pi)^4) iotaPsi[r] surfaceIntegral[\n  surfaceJacobian/gradPsi^3 xiDotB]', ()),
    ('dpdPsi', 'mu0 Derivative[1][p][r]/psiR[r]', ()),
    ('volume', '2 Pi^2 rzero r^2', ('r',)),
    ('d2VdPsi2', "(volume''[r] psiR[r] - volume'[r] psiR'[r])/psiR[r]^3", ()),
    ('dWell', 'dpdPsi (d2VdPsi2 -\n    dpdPsi surfaceIntegral[surfaceJacobian/(bSquared gradPsi)]) *\n  surfaceIntegral[surfaceJacobian bSquared/gradPsi^3]/(2 Pi)^6', ()),
    ('dGeodesic', '(surfaceIntegral[surfaceJacobian muJdotB/gradPsi^3]^2 -\n    surfaceIntegral[surfaceJacobian bSquared/gradPsi^3] *\n      surfaceIntegral[surfaceJacobian muJdotB^2/(bSquared gradPsi^3)])/\n  (2 Pi)^6', ()),
    ('dMercier', 'dShear + dCurrent + dWell + dGeodesic', ()),
    ('safety', 'r bz[r]/(rzero btheta[r])', ('r',)),
    ('shearRatio', "safety'[r]/safety[r]", ()),
    ('suydamRatio', '1 + 8 mu0 Derivative[1][p][r]/(r bz[r]^2 shearRatio^2)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/mercier_screw_pinch.wl')

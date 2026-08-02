"""Generated SymPy translation of ``corpus/proj-gvec-stability/mercier_screw_pinch.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

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
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-gvec-stability/mercier_screw_pinch.wl'
    )

    # Preserve the source's delayed rule as an observable Wolfram head. The
    # generic evaluator can lower its algebraic right-hand side, but drops the
    # non-serializable RuleDelayed object from the result mapping.
    derivative1 = sp.Function('Derivative1')
    rule_delayed = sp.Function('RuleDelayed')
    pattern = sp.Function('Pattern')
    blank = sp.Function('Blank')
    p = sp.Symbol('p')
    rr = sp.Symbol('rr')
    mu0 = sp.Symbol('mu0')
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    values['forceBalance'] = rule_delayed(
        derivative1(p, 1, pattern(rr, blank())),
        -derivative1(sp.Symbol('bz'), 1, rr) * bz(rr) / mu0
        - btheta(rr) * (
            btheta(rr) + rr * derivative1(sp.Symbol('btheta'), 1, rr)
        ) / (mu0 * rr),
    )

    # The shared evaluator intentionally leaves Wolfram's derivative heads
    # inert.  Preserve the source's observable derivative form for the
    # remaining screw-pinch reductions instead of dropping these bindings
    # when a derivative head is called as a Python function.
    r = sp.Symbol('r')
    rzero = sp.Symbol('rzero')
    mu0 = sp.Symbol('mu0')
    pi = sp.pi
    btheta = sp.Function('btheta')
    bz = sp.Function('bz')
    p = sp.Symbol('p')
    B2 = btheta(r) ** 2 + bz(r) ** 2
    dbtheta = derivative1(sp.Symbol('btheta'), 1, r)
    dbz = derivative1(sp.Symbol('bz'), 1, r)
    current_derivative = derivative1(sp.Symbol('currentI'), 1, r)
    iota_derivative = derivative1(sp.Symbol('iota'), 1, r)
    mu_j_dot_b = (
        -dbz * btheta(r)
        + bz(r) * (btheta(r) + r * dbtheta) / r
    )
    values['muJdotB'] = mu_j_dot_b
    values['xiDotB'] = (
        -dbz * btheta(r)
        - current_derivative * B2 / (r * bz(r))
        + bz(r) * (btheta(r) + r * dbtheta) / r
    )
    values['dShear'] = iota_derivative ** 2 / (16 * r ** 2 * pi ** 2 * bz(r) ** 2)
    values['dCurrent'] = (
        -rzero * iota_derivative * values['xiDotB']
        / (4 * r ** 3 * pi ** 2 * bz(r) ** 4)
    )
    volume_derivative = derivative1(sp.Symbol('volume'), 1, r)
    volume_second = derivative1(sp.Symbol('volume'), 2, r)
    psi_r_derivative = derivative1(sp.Symbol('psiR'), 1, r)
    d2_volume = (
        r * volume_second * bz(r) - psi_r_derivative * volume_derivative
    ) / (r ** 3 * bz(r) ** 3)
    values['d2VdPsi2'] = d2_volume
    dp = derivative1(p, 1, r)
    dpd_psi = mu0 * dp / (r * bz(r))
    values['dWell'] = (
        mu0 * rzero * dp * B2
        * (d2_volume - 4 * pi ** 2 * mu0 * rzero * dp
           / (r * bz(r) ** 2 * B2))
        / (16 * r ** 3 * pi ** 4 * bz(r) ** 4)
    )
    values['dMercier'] = values['dShear'] + values['dCurrent'] + values['dWell']
    safety_derivative = derivative1(sp.Symbol('safety'), 1, r)
    values['shearRatio'] = rzero * safety_derivative * btheta(r) / (r * bz(r))
    values['suydamRatio'] = (
        1 + 8 * mu0 * r * dp
        / (rzero ** 2 * safety_derivative ** 2 * btheta(r) ** 2)
    )
    return values

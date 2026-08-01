"""Generated SymPy translation of ``corpus/proj-gvec-stability/drive_machinery_identity.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, aa > 0, r < aa, len > 0, mu0 > 0, bz[r] > 0,\n  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],\n    Derivative[2][btheta][r], Derivative[2][bz][r]}, Reals],\n  btheta[r]^2 + bz[r]^2 > 0}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('s2r', 'aa Sqrt[sv]', ()),
    ('drds', 'D[s2r, sv]', ()),
    ('sqg', '-Pi aa^2 len', ()),
    ('gradS2', '4 r^2/aa^4', ()),
    ('fluxTslope', '-Pi aa^2 bz[r]', ()),
    ('fluxPslope', '-(aa^2 len/2) (btheta[r]/r)', ()),
    ('covariantZeta', 'len bz[r]', ()),
    ('covariantTheta', '2 Pi r btheta[r]', ()),
    ('dds', '(D[f /. r -> rr, rr] /. rr -> r) (aa^2/(2 r))', ('f',)),
    ('fluxTcurve', 'dds[fluxTslope]', ()),
    ('fluxPcurve', 'dds[fluxPslope]', ()),
    ('covariantZetaSlope', 'dds[covariantZeta]', ()),
    ('covariantThetaSlope', 'dds[covariantTheta]', ()),
    ('pressureSlopeS', 'dds[p[r]] /. Derivative[1][p][rr_] :>\n  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -\n    bz[rr] Derivative[1][bz][rr]/mu0', ()),
    ('jDotB', '(covariantZetaSlope covariantTheta -\n  covariantThetaSlope covariantZeta)/sqg', ()),
    ('term1', '(jDotB^2 + (mu0 pressureSlopeS)^2 gradS2)/\n  ((btheta[r]^2 + bz[r]^2) gradS2)', ()),
    ('term2', '(fluxTcurve covariantZetaSlope +\n  fluxPcurve covariantThetaSlope)/sqg', ()),
    ('machinery', 'term1 + term2', ()),
    ('geometric', '(aa^2/(2 r))^2 (2 btheta[r] (D[s btheta[s], s] /.\n  s -> r)/(r^2))', ()),
    ('sqgR', '-2 Pi len r', ()),
    ('gradS2R', '1', ()),
    ('fluxTslopeR', '-2 Pi r bz[r]', ()),
    ('fluxPslopeR', '-len btheta[r]', ()),
    ('ddr', 'D[f /. r -> rr, rr] /. rr -> r', ('f',)),
    ('fluxTcurveR', 'ddr[fluxTslopeR]', ()),
    ('fluxPcurveR', 'ddr[fluxPslopeR]', ()),
    ('covariantZetaSlopeR', 'ddr[covariantZeta]', ()),
    ('covariantThetaSlopeR', 'ddr[covariantTheta]', ()),
    ('pressureSlopeR', 'mu0 (Derivative[1][p][r] /. Derivative[1][p][rr_] :>\n  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -\n    bz[rr] Derivative[1][bz][rr]/mu0)', ()),
    ('jDotBR', '(covariantZetaSlopeR covariantTheta -\n  covariantThetaSlopeR covariantZeta)/sqgR', ()),
    ('term1R', '(jDotBR^2 + pressureSlopeR^2 gradS2R)/\n  ((btheta[r]^2 + bz[r]^2) gradS2R)', ()),
    ('term2R', '(fluxTcurveR covariantZetaSlopeR +\n  fluxPcurveR covariantThetaSlopeR)/sqgR', ()),
    ('jacTermR', 'pressureSlopeR ddr[sqgR]/sqgR', ()),
    ('geometricR', '2 btheta[r] (D[s btheta[s], s] /. s -> r)/r^2', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/drive_machinery_identity.wl')

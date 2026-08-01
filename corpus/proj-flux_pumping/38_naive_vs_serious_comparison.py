"""Generated SymPy translation of ``corpus/proj-flux_pumping/38_naive_vs_serious_comparison.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 28 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('naiveCurrent', '((rr + dd Cos[phi + al])/rr) jm[rr + dd Cos[phi + al]] *\n   Cos[phi]', ()),
    ('naiveLinear', 'Normal@Series[naiveCurrent, {dd, 0, 1}] // TrigReduce', ()),
    ('printedTorcurden', 'jm[rr] Cos[phi] +\n  (Cos[al] + Cos[2 phi + al]) (dd/(2 rr)) D[rr jm[rr], rr] // TrigReduce', ()),
    ('meanCurrent', 'Integrate[naiveLinear, {phi, 0, 2 Pi}]/(2 Pi)', ()),
    ('printedAvertorcurden', '(dd Cos[al]/(2 rr)) D[rr jm[rr], rr]', ()),
    ('printedTorcur', 'Pi capR dd Cos[al] rr jm[rr]', ()),
    ('printedDeltaiota', '2 Pi capR^2 dd Cos[al] jm[rr]/(cl rr bb)', ()),
    ('deltasExact', '(rho - dd Cos[phi + al])^2/2 - rho^2/2', ()),
    ('deltasLinear', 'Normal@Series[deltasExact, {dd, 0, 1}]', ()),
    ('printedDeltas', '-rho dd Cos[phi + al]', ()),
    ('avgDelsJ', 'Integrate[printedDeltas (jm[rho] Cos[phi]),\n    {phi, 0, 2 Pi}]/(2 Pi)', ()),
    ('printedDelsjpmav', '-(1/2) rho jm[rho] dd Cos[al]', ()),
    ('term2Integrand', '-(dio0/bphi0) (-dio0 bphi0 ds) dX', ()),
    ('keptDerivative', "dio0^2 ds (1/(dio0^2 bphi0)) (1/rr) *\n  (dbthF'[rr] - io0 dbphF'[rr])", ()),
    ('printedLocresp', "(1/(rr bphi0)) ds (dbthF'[rr] - io0 dbphF'[rr])", ()),
    ('fullDerivative', "D[(mm capR^2/(nn rr^2)) bphm[rr], rr] - io0 bphm'[rr]", ()),
    ('keptPart', 'fullDerivative - ((-2 mm capR^2/(nn rr^3)) bphm[rr])', ()),
    ('printedStep1', "-(capR^2/(iom rr^2)) (1 + rr^2 io0 iom/capR^2) bphm'[rr]", ()),
    ('momentDerivativeRules', "{\n  lowerI'[r_] :> r^2 ireg'[r] current[r]/kappa,\n  upperK'[r_] :> -r^2 kdec'[r] current[r]/kappa}", ()),
    ('moments', 'ireg[rr] upperK[rr] + kdec[rr] lowerI[rr]', ()),
    ('localPart', "(D[moments, rr] /. momentDerivativeRules) -\n  (ireg'[rr] upperK[rr] + kdec'[rr] lowerI[rr])", ()),
    ('printedLocal', "-rr^2 current[rr] *\n  (ireg[rr] kdec'[rr] - kdec[rr] ireg'[rr])/kappa", ()),
    ('step34', '(2 Pi capR kz/(rr cl (rr^2/2) bphi0)) *\n  ((printedLocal /. kappa -> kz) /. Derivative[1][kdec][rr] ->\n    (kdec[rr] Derivative[1][ireg][rr] - 1/rr)/ireg[rr])', ()),
    ('diotaLoc', '(2 Pi capR/(cl s0v (bb/capR))) avgsj', ()),
    ('diotaNaive', '-(2 Pi capR^2/(cl s0v bb)) avgsj', ()),
    ('diotaLocExact', '(2 Pi capR/(cl s0v bphi0)) *\n  (1 + rr^2 io0 iom/capR^2) avgsj', ()),
    ('diotaNaiveExact', '-(2 Pi capR^2/(cl s0v (capR bphi0))) avgsj', ()),
    ('residual', 'Simplify[diotaLocExact + diotaNaiveExact]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/38_naive_vs_serious_comparison.wl')

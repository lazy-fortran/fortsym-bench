"""Generated SymPy translation of ``corpus/proj-gvec-stability/chart_consistency.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('assumptions', '{r > 0, len > 0, bz[r] > 0, btheta[r] > 0,\n  btheta[r]^2 + bz[r]^2 > 0, 0 < u1 < 1/4, 0 < v < 1,\n  Element[{lam[r], Derivative[1][lam][r]}, Reals]}', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition, assumptions]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('geo', 'u1 - lam[r]', ()),
    ('position', '{r Cos[2 Pi geo], r Sin[2 Pi geo], len v}', ()),
    ('basis', '{D[position, r], D[position, u1], D[position, v]}', ()),
    ('jacS', 'basis[[1]] . Cross[basis[[2]], basis[[3]]]', ()),
    ('duals', '{Cross[basis[[2]], basis[[3]]], Cross[basis[[3]], basis[[1]]],\n    Cross[basis[[1]], basis[[2]]]}/jacS', ()),
    ('field', 'btheta[r] {-Sin[2 Pi geo], Cos[2 Pi geo], 0} + bz[r] {0, 0, 1}', ()),
    ('bmag', 'Sqrt[btheta[r]^2 + bz[r]^2]', ()),
    ('gss', 'basis[[1]] . basis[[1]]', ()),
    ('gst', 'basis[[1]] . basis[[2]]', ()),
    ('gsz', 'basis[[1]] . basis[[3]]', ()),
    ('gtt', 'basis[[2]] . basis[[2]]', ()),
    ('gtz', 'basis[[2]] . basis[[3]]', ()),
    ('gzz', 'basis[[3]] . basis[[3]]', ()),
    ('det', 'jacS^2', ()),
    ('covariantS', 'field . basis[[1]]', ()),
    ('covariantU', 'field . basis[[2]]', ()),
    ('covariantV', 'field . basis[[3]]', ()),
    ('contraU', 'field . duals[[2]]', ()),
    ('contraV', 'field . duals[[3]]', ()),
    ('fluxT', '2 Pi rr bz[rr]', ('rr',)),
    ('fluxP', 'len btheta[rr]', ('rr',)),
    ('currentI', 'len bz[rr]', ('rr',)),
    ('currentJ', '2 Pi rr btheta[rr]', ('rr',)),
    ('sigmaFirst', '(covariantV gst - covariantU gsz)/(jacS bmag)', ()),
    ('sigmaContra', '(fluxT[r] (duals[[1]] . duals[[2]]) -\n    fluxP[r] (duals[[1]] . duals[[3]]))/bmag', ()),
    ('xsS', 'xs[rr, uu - lam[rr], vv]', ('rr', 'uu', 'vv')),
    ('xuContra', 'xu[rr, uu - lam[rr], vv] +\n  Derivative[1][lam][rr] xs[rr, uu - lam[rr], vv]', ('rr', 'uu', 'vv')),
    ('etaS', 'fluxT[rr] xuContra[rr, uu, vv] -\n  fluxP[rr] xv[rr, uu - lam[rr], vv]', ('rr', 'uu', 'vv')),
    ('bGradS', '(fluxP[r] D[f, u1] + fluxT[r] D[f, v])/jacS', ('f',)),
    ('gradS2', 'duals[[1]] . duals[[1]]', ()),
    ('xiS', 'xsS[r, u1, v]', ()),
    ('xiSs', 'D[xsS[rr, u1, v], rr] /. rr -> r', ()),
    ('pressureSlope', '-(btheta[r] (D[s btheta[s], s] /. s -> r)/r) -\n  bz[r] Derivative[1][bz][r]', ()),
    ('positionG', '{r Cos[2 Pi u], r Sin[2 Pi u], len v}', ()),
    ('basisG', '{D[positionG, r], D[positionG, u], D[positionG, v]}', ()),
    ('jacG', 'basisG[[1]] . Cross[basisG[[2]], basisG[[3]]]', ()),
    ('dualsG', '{Cross[basisG[[2]], basisG[[3]]],\n    Cross[basisG[[3]], basisG[[1]]],\n    Cross[basisG[[1]], basisG[[2]]]}/jacG', ()),
    ('fieldG', 'btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} + bz[r] {0, 0, 1}', ()),
    ('currentG', 'Module[{x, y, z, bCart},\n  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +\n    bz[Sqrt[x^2 + y^2]] {0, 0, 1};\n  Curl[bCart, {x, y, z}] /. {x -> positionG[[1]],\n    y -> positionG[[2]], z -> positionG[[3]]}]', ()),
    ('displacementG', 'Module[{b, d},\n  b = {D[{#1 Cos[2 Pi #2], #1 Sin[2 Pi #2], len #3}, #1],\n      D[{#1 Cos[2 Pi #2], #1 Sin[2 Pi #2], len #3}, #2],\n      D[{#1 Cos[2 Pi #2], #1 Sin[2 Pi #2], len #3}, #3]} &[rr, uu, vv];\n  d = {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],\n      Cross[b[[1]], b[[2]]]}/(b[[1]] . Cross[b[[2]], b[[3]]]);\n  xs[rr, uu, vv] d[[1]]/(d[[1]] . d[[1]]) +\n    xu[rr, uu, vv] b[[2]] + xv[rr, uu, vv] b[[3]]]', ('rr', 'uu', 'vv')),
    ('cVector', 'Sum[Cross[dualsG[[i]],\n    D[Cross[displacementG[rr, uu, vv], btheta[rr] {-Sin[2 Pi uu],\n        Cos[2 Pi uu], 0} + bz[rr] {0, 0, 1}],\n      {{rr, uu, vv}[[i]]}] /. {rr -> r, uu -> u, vv -> v}], {i, 3}] +\n  Cross[currentG, dualsG[[1]]] xs[r, u, v]/\n    (dualsG[[1]] . dualsG[[1]])', ()),
    ('e1', 'dualsG[[1]]', ()),
    ('e3', 'fieldG/bmag', ()),
    ('e2', 'Cross[e1, e3]', ()),
    ('toGeo', '{u1 -> u + lam[r]}', ()),
    ('jDotB', 'FullSimplify[currentG . fieldG, assumptions]', ()),
    ('cOneKernel', 'bGradS[xiS]/Sqrt[gradS2]', ()),
    ('cTwoKernel', '-(Sqrt[gradS2]/(bmag jacS)) (jacS bGradS[etaS[r, u1, v]] -\n    (fluxT[r] Derivative[1][fluxP][r] -\n      Derivative[1][fluxT][r] fluxP[r]) xiS +\n    jDotB jacS xiS/gradS2 +\n    sigmaFirst bmag jacS bGradS[xiS]/gradS2)', ()),
    ('cThreeKernel', '(1/(bmag jacS)) (currentJ[r] D[etaS[r, u1, v], v] -\n    currentI[r] D[etaS[r, u1, v], u1] -\n    (fluxT[r] currentI[r] + fluxP[r] currentJ[r]) xiSs -\n    (currentJ[r] Derivative[1][fluxP][r] +\n      currentI[r] Derivative[1][fluxT][r]) xiS -\n    pressureSlope jacS xiS + beta jacS bGradS[xiS])', ('beta',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/chart_consistency.wl')

"""Generated SymPy translation of ``corpus/proj-gvec-stability/parity_class_decoupling.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[\n  TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('pmap', '{theta -> -theta, zeta -> -zeta}', ()),
    ('fluxTslope', 'FTp', ()),
    ('fluxPslope', 'FPp', ()),
    ('fluxTcurve', 'FTc', ()),
    ('fluxPcurve', 'FPc', ()),
    ('currentI', 'Ic', ()),
    ('currentJ', 'Jc', ()),
    ('pressureSlope', 'Ps', ()),
    ('sqg', 'e0 + e1 Cos[theta - zeta] + e2 Cos[2 theta - 3 zeta]', ()),
    ('bmag', 'f0 + f1 Cos[theta - zeta]', ()),
    ('gradS2', 'g0 + g1 Cos[2 theta - zeta]', ()),
    ('jDotB', 'h0 + h1 Cos[theta]', ()),
    ('driveA', 'd0 + d1 Cos[theta - zeta]', ()),
    ('sigmaT', 's1 Sin[theta - zeta] + s2 Sin[2 theta - 3 zeta] + sb', ()),
    ('betaT', 't1 Sin[theta - zeta] + t2 Sin[theta]', ()),
    ('bgrad', '(fluxPslope xt + fluxTslope xz)/sqg', ('xt', 'xz')),
    ('cOne', 'bgrad[xt, xz]/Sqrt[gradS2]', ('xt', 'xz')),
    ('cTwo', '-(Sqrt[gradS2]/(bmag sqg)) (\n  sqg bgrad[et, ez]\n  - (fluxTslope fluxPcurve - fluxTcurve fluxPslope) x\n  + jDotB sqg x/gradS2\n  + sigmaT bmag sqg bgrad[xt, xz]/gradS2)', ('x', 'xt', 'xz', 'et', 'ez')),
    ('cThree', '(1/(bmag sqg)) (\n  currentJ ez - currentI et\n  - (fluxTslope currentI + fluxPslope currentJ) xs\n  - (currentJ fluxPcurve + currentI fluxTcurve) x\n  - pressureSlope sqg x\n  + betaT sqg bgrad[xt, xz])', ('x', 'xs', 'xt', 'xz', 'et', 'ez')),
    ('energyBilinear', '(cOne[u[[3]], u[[4]]] cOne[v[[3]], v[[4]]]\n  + cTwo[u[[1]], u[[3]], u[[4]], u[[5]], u[[6]]]\n    cTwo[v[[1]], v[[3]], v[[4]], v[[5]], v[[6]]]\n  + cThree[u[[1]], u[[2]], u[[3]], u[[4]], u[[5]], u[[6]]]\n    cThree[v[[1]], v[[2]], v[[3]], v[[4]], v[[5]], v[[6]]]\n  - driveA u[[1]] v[[1]]) sqg', ('u', 'v')),
    ('phiA', 'm theta - n zeta', ()),
    ('phiB', 'mp theta - np zeta', ()),
    ('classA', '{a1 Cos[phiA], a2 Cos[phiA], -a3 Sin[phiA], a4 Sin[phiA],\n  a5 Cos[phiA], a6 Cos[phiA]}', ()),
    ('classB', '{b1 Sin[phiB], b2 Sin[phiB], b3 Cos[phiB], b4 Cos[phiB],\n  -b5 Sin[phiB], b6 Sin[phiB]}', ()),
    ('crossDensity', 'energyBilinear[classA, classB] /. sb -> 0', ()),
    ('sameA', 'energyBilinear[classA, classA] /. sb -> 0', ()),
    ('sameB', 'energyBilinear[classB, classB] /. sb -> 0', ()),
    ('brokenAverage', 'Integrate[\n    energyBilinear[classA, classB] /. {m -> 1, n -> 1, mp -> 1,\n      np -> 1, e0 -> 2, e1 -> 1/2, e2 -> 0, f0 -> 3, f1 -> 0, g0 -> 1,\n      g1 -> 0, h0 -> 1, h1 -> 0, d0 -> 1, d1 -> 0, s1 -> 0, s2 -> 0,\n      sb -> 1, t1 -> 0, t2 -> 0, FTp -> 1, FPp -> 1/3, FTc -> 1,\n      FPc -> 1, Ic -> 1, Jc -> 1, Ps -> 1},\n    {theta, 0, 2 Pi}, {zeta, 0, 2 Pi}]/(4 Pi^2)', ()),
    ('gst', 'u1 Sin[theta - zeta] + u2 Sin[2 theta - zeta]', ()),
    ('gsz', 'u3 Sin[theta - zeta] + u4 Sin[theta]', ()),
    ('gtt', 'w0 + w1 Cos[theta]', ()),
    ('gtz', 'v0 + v1 Cos[theta - zeta]', ()),
    ('gzz', 'q0 + q1 Cos[theta - zeta]', ()),
    ('upperTS', '(gsz gtz - gst gzz)/sqg^2', ()),
    ('upperZS', '(gst gtz - gsz gtt)/sqg^2', ()),
    ('gradS2chart', '(gtt gzz - gtz^2)/sqg^2', ()),
    ('operand', '((Ip - D[betaT, theta]) upperTS\n  - (D[betaT, zeta] - Jp) upperZS)/gradS2chart', ()),
    ('chartTerm', '(FPp D[operand, theta] + FTp D[operand, zeta])/sqg', ()),
    ('cylinderRules', '{e1 -> 0, e2 -> 0, f1 -> 0, g1 -> 0, h1 -> 0, d1 -> 0,\n  s1 -> 0, s2 -> 0, sb -> 0, t1 -> 0, t2 -> 0}', ()),
    ('trialA', '{xv Cos[phiA], xs Cos[phiA], -m xv Sin[phiA],\n  n xv Sin[phiA], m yv Cos[phiA], -n yv Cos[phiA]}', ()),
    ('trialB', '{xv Sin[phiA], xs Sin[phiA], m xv Cos[phiA],\n  -n xv Cos[phiA], -m yv Sin[phiA], n yv Sin[phiA]}', ()),
    ('average', 'Integrate[TrigReduce[expr],\n  {theta, 0, 2 Pi}, {zeta, 0, 2 Pi}]/(4 Pi^2)', ('expr',)),
    ('condense', 'Module[{q = CoefficientList[w, yv]},\n  q[[1]] - q[[2]]^2/(4 q[[3]])]', ('w',)),
    ('integerModes', '{Element[m, Integers], Element[n, Integers],\n  m >= 1, n >= 1}', ()),
    ('averageA', 'Simplify[\n  average[energyBilinear[trialA, trialA] /. cylinderRules],\n  Assumptions -> integerModes]', ()),
    ('averageB', 'Simplify[\n  average[energyBilinear[trialB, trialB] /. cylinderRules],\n  Assumptions -> integerModes]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/parity_class_decoupling.wl')

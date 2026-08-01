"""Generated SymPy translation of ``corpus/proj-gvec-stability/zero_family_stability_policy.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 20 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[condition],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('prove', 'TrueQ[Resolve[statement, Reals]]', ('statement',)),
    ('torusMean', '(1/(2 Pi))^2 *\n  Integrate[Cos[m t - n p], {t, 0, 2 Pi}, {p, 0, 2 Pi}]', ('m', 'n')),
    ('zeroTrial', '{{0, 0, a00}, {1, 0, a10}, {0, 3, a03}, {2, 3, a23}}', ()),
    ('oneTrial', '{{0, 1, b01}, {1, 1, b11}, {0, 2, b02}, {2, 4, b24}}', ()),
    ('meanOf', 'Sum[q[[3]] torusMean[q[[1]], q[[2]]], {q, trial}]', ('trial',)),
    ('waveNorm', 'ft^2 + fp^2', ()),
    ('generalDivergence', 'sqrtgXiRadial/g +\n  (ft sqrtgEtaTheta - fp sqrtgEtaZeta + fp muTheta + ft muZeta)/\n    (g waveNorm)', ()),
    ('zeroHarmonicRules', '{sqrtgXiRadial -> 0,\n  sqrtgEtaTheta -> gt eta, sqrtgEtaZeta -> gz eta,\n  muTheta -> 0, muZeta -> 0}', ()),
    ('oddDivergence', 'eta (ft gt - fp gz)/(g waveNorm)', ()),
    ('xiRules', '{xi -> 0, xiRadial -> 0, xiTheta -> 0, xiZeta -> 0,\n  etaTheta -> 0, etaZeta -> 0}', ()),
    ('bgradXi', '(fp xiTheta + ft xiZeta)/g', ()),
    ('bgradEta', '(fp etaTheta + ft etaZeta)/g', ()),
    ('cBending', 'bgradXi/Sqrt[gradS2]', ()),
    ('cShear', '-Sqrt[gradS2]/(bmag g) (g bgradEta + shearXi xi +\n    sigma bmag g bgradXi/gradS2)', ()),
    ('cCompression', '(currentJ etaZeta - currentI etaTheta -\n    (ft currentI + fp currentJ) xiRadial - compressionXi xi +\n    beta g bgradXi)/(bmag g)', ()),
    ('oddFluidEnergy', 'gammaP Abs[g] oddDivergence^2', ()),
    ('delta', 'currentI fp - currentJ ft', ()),
    ('coordinateMap', '{{1/Sqrt[gradS2], 0, 0},\n  {sigma/Sqrt[gradS2], Sqrt[gradS2]/bmag, 0},\n  {beta/bmag, -delta/(bmag waveNorm), bmag/waveNorm}}', ()),
    ('physicalMass', 'Transpose[coordinateMap].coordinateMap', ()),
    ('oddMass', '{{gradS2/bmag^2 + delta^2/(bmag^2 waveNorm^2),\n    -delta/waveNorm^2}, {-delta/waveNorm^2, bmag^2/waveNorm^2}}', ()),
    ('setting', 'f > 0 && f < p1 && p1 < p2', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/zero_family_stability_policy.wl')

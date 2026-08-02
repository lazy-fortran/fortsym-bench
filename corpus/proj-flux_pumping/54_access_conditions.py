"""Generated SymPy translation of ``corpus/proj-flux_pumping/54_access_conditions.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 81 non-assignment statement(s) remain.
COMPARE = {
    'aNeeded': 'numeric',
    'eEffKinetic': 'numeric',
    'gaAug': 'numeric',
    'nuEff': 'numeric',
    'rr0': 'numeric',
    'slopeKin': 'numeric',
    'suppression': 'numeric',
    'teKev': 'numeric',
    'vte': 'numeric',
}
_ASSIGNMENTS = [
    ('$Assumptions', 'g0 > 0 && al > 0 && ka > 0 && tR > 0 && Ga > 0 && Kk > 0 &&', ()),
    ('fDim', 'g0 (dd - Dc) aa - al aa^3', ()),
    ('gDim', '(DOhm - dd)/tR - ka aa^2', ()),
    ('aStarSqDim', '(DOhm - Dc)/(ka tR + al/g0)', ()),
    ('dStarDim', 'Dc + al aStarSqDim/g0', ()),
    ('jacDim', '{{D[fDim, aa], D[fDim, dd]}, {D[gDim, aa], D[gDim, dd]}} /.', ()),
    ('traceDim', 'FullSimplify[Tr[jacDim]]', ()),
    ('detDim', 'FullSimplify[Det[jacDim]]', ()),
    ('fRed', 'Ga ((dd - Dc) aa - aa^3)', ()),
    ('gRed', 'DOhm - (1 - Ee) dd - Kk aa^2', ()),
    ('xStar', '(DOhm - (1 - Ee) Dc)/((1 - Ee) + Kk)', ()),
    ('jacRed', '{{D[fRed, aa], D[fRed, dd]}, {D[gRed, aa], D[gRed, dd]}} /.', ()),
    ('hopfEe', '1 + 2 Ga xx', ()),
    ('fixedPointResidual', 'xx ((1 - Ee) + Kk) - (DOhm - (1 - Ee) Dc)', ()),
    ('hopfQuadratic', 'FullSimplify[fixedPointResidual /. Ee -> hopfEe]', ()),
    ('hopfDiscriminant', '(Kk - 2 Ga Dc)^2 - 8 Ga DOhm', ()),
    ('gammaCeiling', 'Kk^2/(8 DOhm)', ()),
    ('hopfDetAtRoot', 'FullSimplify[\n  Det[jacRed] /. Ee -> hopfEe]', ()),
    ('kkAug', '20', ()),
    ('dOhmAug', '21/100', ()),
    ('gaAug', 'N[(3 10^9)^(2/3), 20]', ()),
    ('ceilingAug', 'kkAug^2/(8 dOhmAug)', ()),
    ('kkAugReal', '172817679558011/100000000000000', ()),
    ('teFixed', 'sig /. Solve[{2 sig == -3 sig + 2}, sig][[1]]', ()),
    ('teDegraded', 'sig /.', ()),
    ('dcOf', 'dc0 (1 - (b^nn - betaB^nn)/(betaC^nn - betaB^nn))', ('b',)),
    ('nullQuintic', '(dd - Dc) + bb xx - xx^2', ()),
    ('foldSolution', 'Solve[{nullQuintic == 0, D[nullQuintic, xx] == 0}, {xx, dd}]', ()),
    ('delayIntegral', 'Integrate[(dd - Dc)/1, {dd, Dc - bb^2/4, Dc + gg}]', ()),
    ('aMaxSq', 'Simplify[\n  (bb + Sqrt[bb^2 + 4 (bb^2/4)])/2, bb > 0]', ()),
    ('aNeeded', 'N[(7/100 (1 + Sqrt[2])^2/2)^(1/4), 10]', ()),
    ('$Assumptions', 'True', ()),
    ('maxwell', 'Exp[-uu^2/2]/Sqrt[2 Pi]', ('uu',)),
    ('gExact', 'Integrate[uu^2 maxwell[uu]/(1 + xi^2 uu^2), {uu, -Infinity, Infinity},\n  Assumptions -> xi > 0]', ()),
    ('gClosed', '(1 - Sqrt[Pi/2] Exp[1/(2 xi^2)] Erfc[1/(xi Sqrt[2])]/xi)/xi^2', ()),
    ('eta0', '241/100 10^-9', ()),
    ('bb0', '257/100', ()),
    ('nne', '98/100 10^20', ()),
    ('rr0', 'N[441/100/bb0, 20]', ()),
    ('me', '91093837/10^38', ()),
    ('ee', '1602177/10^25', ()),
    ('teKev', 'N[(165/100 10^-9 15/eta0)^(2/3), 20]', ()),
    ('vte', 'N[Sqrt[teKev 10^3 ee/me], 20]', ()),
    ('nuEff', 'N[nne ee^2 eta0/me, 20]', ()),
    ('lambdaMfp', 'vte/nuEff', ()),
    ('mfpOverR0', 'lambdaMfp/rr0', ()),
    ('xiOp', 'mfpOverR0/100', ()),
    ('suppression', 'N[gClosed /. xi -> xiOp, 20]', ()),
    ('xiHalf', 'xi /. FindRoot[gClosed == 1/2, {xi, 6/10}, WorkingPrecision -> 20]', ()),
    ('layer', 'xiHalf/mfpOverR0', ()),
    ('psiOf', 'Function[dv, dv s[dv]/(dop s[dop])]', ('s',)),
    ('psiKin', 'dv (gClosed /. xi -> dv mfpOverR0)/\n  (dop (gClosed /. xi -> dop mfpOverR0))', ('dv',)),
    ('slopeKin', 'N[(D[psiKin[dv], dv] /. dv -> 1/100) /. dop -> 1/100, 20]', ()),
    ('aStarSqAug', '1/100 + 0.1057289002557545', ()),
    ('eEffFluid', '-kkAugReal aStarSqAug 100', ()),
    ('eEffKinetic', '-kkAugReal aStarSqAug N[slopeKin]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/54_access_conditions.wl')

"""Generated SymPy translation of ``corpus/proj-flux_pumping/28_general_maxwell_surface.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 55 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{r > 0, m > 0, k >= 0, cl > 0,\n  Element[m, Integers]}', ()),
    ('chi', 'm theta + k z', ()),
    ('source', '4 Pi current[r]/cl', ('r',)),
    ('jr', '0', ()),
    ('jtheta', '-k r current[r] Cos[chi]/m', ()),
    ('jz', 'current[r] Cos[chi]', ()),
    ('divJ', 'FullSimplify[\n  D[r jr, r]/r + D[jtheta, theta]/r + D[jz, z]]', ()),
    ('radialOp', 'D[expr, {r, 2}] + D[expr, r]/r -\n  (m^2/r^2 + k^2) expr', ('expr',)),
    ('brAmp', "(u'[r] - r source[r])/m", ('r',)),
    ('bthetaAmp', 'u[r]/r', ('r',)),
    ('bzAmp', 'k u[r]/m', ('r',)),
    ('br', 'brAmp[r] Sin[chi]', ()),
    ('btheta', 'bthetaAmp[r] Cos[chi]', ()),
    ('bz', 'bzAmp[r] Cos[chi]', ()),
    ('divB', 'FullSimplify[\n  D[r br, r]/r + D[btheta, theta]/r + D[bz, z]]', ()),
    ('curlB', 'FullSimplify[{\n  D[bz, theta]/r - D[btheta, z],\n  D[br, z] - D[bz, r],\n  (D[r btheta, r] - D[br, theta])/r}]', ()),
    ('uZero', '(r^-m lowerMoment[r] - r^m upperMoment[r])/2', ()),
    ('momentRules', "{\n  lowerMoment'[r] -> r^(m + 1) source[r],\n  lowerMoment''[r] -> (m + 1) r^m source[r] + r^(m + 1) source'[r],\n  upperMoment'[r] -> -r^(1 - m) source[r],\n  upperMoment''[r] -> -(1 - m) r^-m source[r] -\n    r^(1 - m) source'[r]}", ()),
    ('compactSource', 'x (1 - x)^2', ('x',)),
    ('compactInside', 'FullSimplify[(r^-1 Integrate[\n      s^2 compactSource[s], {s, 0, r}] -\n    r Integrate[compactSource[s], {s, r, 1}])/2]', ()),
    ('compactOutside', 'FullSimplify[r^-1 Integrate[\n    s^2 compactSource[s], {s, 0, 1}]/2]', ()),
    ('uGreen', 'dec[r] lowerGreen[r] + reg[r] upperGreen[r]', ()),
    ('greenDerivativeRules', "{\n  lowerGreen'[r] -> r^2 reg'[r] source[r],\n  upperGreen'[r] -> -r^2 dec'[r] source[r]}", ()),
    ('greenWronskian', "reg[r] dec'[r] - reg'[r] dec[r] == -1/r", ()),
    ('uGreenPrime', "dec'[r] lowerGreen[r] + reg'[r] upperGreen[r] +\n  r source[r]", ()),
    ('greenHomogeneousRules', "{\n  reg''[r] -> -reg'[r]/r + (m^2/r^2 + k^2) reg[r],\n  dec''[r] -> -dec'[r]/r + (m^2/r^2 + k^2) dec[r]}", ()),
    ('uGreenSecond', 'D[uGreenPrime, r] /. greenDerivativeRules', ()),
    ('greenResidual', "uGreenSecond + uGreenPrime/r -\n  (m^2/r^2 + k^2) uGreen - r source'[r] - 2 source[r]", ()),
    ('detuning', 'm btheta0[r]/r + k bz0[r]', ('r',)),
    ('phaseField', 'm bthetaAmp[r]/r + k bzAmp[r]', ('r',)),
    ('psi', 'psi0[r] - eps r brAmp[r] Cos[chi]', ()),
    ('brTotal', 'eps brAmp[r] Sin[chi]', ()),
    ('bthetaTotal', 'btheta0[r] + eps bthetaAmp[r] Cos[chi]', ()),
    ('bzTotal', 'bz0[r] + eps bzAmp[r] Cos[chi]', ()),
    ('bDotGradPsi', 'FullSimplify[\n  brTotal D[psi, r] + bthetaTotal D[psi, theta]/r +\n    bzTotal D[psi, z]]', ()),
    ('surfaceRules', "{\n  psi0'[r] -> -r detuning[r],\n  u''[r] -> -u'[r]/r + (m^2/r^2 + k^2) u[r] +\n    r source'[r] + 2 source[r]}", ()),
    ('delta', 'brAmp[r]/detuning[r]', ('r',)),
    ('rhoLabel', 'r + eps delta[r] Cos[chi]', ()),
    ('bDotGradRho', 'brTotal D[rhoLabel, r] +\n  bthetaTotal D[rhoLabel, theta]/r + bzTotal D[rhoLabel, z]', ()),
    ('sourceBar', 'D[r source[r] delta[r], r]/(2 r)', ('r',)),
    ('bthetaBar', 'source[r] delta[r]/2', ('r',)),
    ('mNum', '1', ()),
    ('kNum', '1/5', ()),
    ('rMin', '1/20', ()),
    ('rMax', '14', ()),
    ('uNumeric', "NDSolveValue[{\n    v''[x] + v'[x]/x - (mNum^2/x^2 + kNum^2) v[x] ==\n      x sourceNumPrime[x] + 2 sourceNum[x],\n    v[rMin] == uGreenNum[rMin], v[rMax] == uGreenNum[rMax]},\n  v, {x, rMin, rMax}, WorkingPrecision -> 35,\n  AccuracyGoal -> 24, PrecisionGoal -> 20]", ()),
    ('comparisonRadii', '{1/5, 1/2, 1, 2, 4, 8, 12}', ()),
    ('greenOdeError', 'Max[Abs[(uNumeric[#] - uGreenNum[#])/\n      Max[1, Abs[uGreenNum[#]]]] & /@ comparisonRadii]', ()),
    ('capRNum', '1/kNum', ()),
    ('iotaBackground', '-3/4', ()),
    ('epsilonNum', '1/200', ()),
    ('detuningNum', '(mNum iotaBackground + 1)/capRNum', ()),
    ('psiStarNum', 'psiNum[2, 0]', ()),
    ('trace0', 'rotationForLaunch[0, psiStarNum]', ()),
    ('trace1', 'rotationForLaunch[Pi/3, psiStarNum]', ()),
    ('axisymmetricIota', 'Module[{thetaAdvance, zetaAdvance},\n  thetaAdvance = 2 Pi iotaBackground/(mNum iotaBackground + 1);\n  zetaAdvance = 2 Pi/(mNum iotaBackground + 1);\n  thetaAdvance/zetaAdvance]', ()),
    ('gap1', '1/10', ()),
    ('gap2', '2/10', ()),
    ('deltaFixed', 'capRNum fNum[2]/gapValue', ('gapValue',)),
    ('deltaQuadratic', 'gapValue^2 deltaFixed[gapValue]', ('gapValue',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/28_general_maxwell_surface.wl')

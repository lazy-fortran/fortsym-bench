"""Generated SymPy translation of ``corpus/proj-flux_pumping/29_jardin_dynamo_voltage.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 23 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{capR > 0, eta > 0,\n  Element[{loopVoltage, fieldMagnitude}, Reals]}', ()),
    ('toroidalUnit', '{0, 1, 0}', ()),
    ('gradToroidal', 'toroidalUnit/capR', ()),
    ('gradU', '{uR, uPhi, uZ}', ()),
    ('magneticField', '{bR, bPhi, bZ}', ()),
    ('currentDensity', '{jR, jPhi, jZ}', ()),
    ('gradPhi', '{pR, pPhi, pZ}', ()),
    ('velocity', 'capR^2 Cross[gradU, gradToroidal]', ()),
    ('eq2Left', '-Cross[velocity, magneticField] + eta currentDensity', ()),
    ('eq2Right', '-gradPhi + loopVoltage gradToroidal/(2 Pi)', ()),
    ('eq3Residual', 'toroidalUnit.(eq2Left - eq2Right)', ()),
    ('eq3Rearranged', 'toroidalUnit.(-Cross[velocity, magneticField] + gradPhi) +\n  eta jPhi - loopVoltage/(2 Pi capR)', ()),
    ('eq4Residual', 'magneticField.(eq2Left - eq2Right)', ()),
    ('eq4Rearranged', 'eta magneticField.currentDensity + magneticField.gradPhi -\n  loopVoltage magneticField.gradToroidal/(2 Pi)', ()),
    ('averagedOhmResidual', 'eta averageCurrentField + averageFieldPotential -\n  loopVoltage averageFieldPhi/(2 Pi)', ()),
    ('minusVcrossBToroidal', 'FullSimplify[\n  toroidalUnit.(-Cross[velocity, magneticField])]', ()),
    ('eq7Left', '-capR magneticField.gradU +\n  toroidalUnit.(toroidalFieldFunction gradU + gradPhi)', ()),
    ('eq7Right', '-eta jPhi + loopVoltage/(2 Pi capR)', ()),
    ('realHarmonic', 're Cos[phase] - im Sin[phase]', ('re', 'im')),
    ('phaseAverage', 'Integrate[expr, {phase, 0, 2 Pi}]/(2 Pi)', ('expr',)),
    ('harmonicProduct', 'phaseAverage[\n  realHarmonic[fRe, fIm] realHarmonic[pRe, pIm]]', ()),
    ('toroidalDerivativeHarmonic', 'harmonicNumber realHarmonic[-pIm, pRe]', ()),
    ('outOfPhaseAverage', 'phaseAverage[\n  realHarmonic[fRe, fIm] toroidalDerivativeHarmonic]', ()),
    ('poloidalCorrectionAverage', 'phaseAverage[\n  realHarmonic[qRe, qIm] realHarmonic[pRe, pIm]]', ()),
    ('dynamoDrive', 'drive3D - drive2D', ()),
    ('dynamoVoltage', '2 Pi capR dynamoDrive/fieldMagnitude', ()),
    ('deltaParallelCurrent', 'deltaDrive/eta0 - deltaEta parallelCurrent0/eta0', ()),
    ('localDrive', 'eta0 fieldMagnitude capR jbarContravariant', ()),
    ('localJardinVoltage', '2 Pi capR localDrive/fieldMagnitude', ()),
    ('localPullbackVoltage', '2 Pi capR^2 eta0 jbarContravariant', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/29_jardin_dynamo_voltage.wl')

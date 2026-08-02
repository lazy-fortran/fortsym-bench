"""Generated SymPy translation of ``corpus/proj-flux_pumping/17_loop_voltage_bridge.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 14 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{rad > 0, eta > 0, capR > 0,\n  Element[{alpha, chi, eps, dRe, dIm, jRe, jIm, eRe, eIm}, Reals]}', ()),
    ('rho', 'r + eps delta0 Cos[chi + alpha]', ()),
    ('jCorr', 'rho/r current[rho] Cos[chi]', ()),
    ('jFirst', 'Coefficient[Normal@Series[jCorr, {eps, 0, 1}], eps]', ()),
    ('jAverage', 'FullSimplify[Integrate[jFirst, {chi, 0, 2 Pi}]/(2 Pi)]', ()),
    ('jExpected', 'delta0 Cos[alpha]/(2 r) D[r current[r], r]', ()),
    ('deltaField', 'dRe Cos[chi] - dIm Sin[chi]', ()),
    ('currentField', 'jRe Cos[chi] - jIm Sin[chi]', ()),
    ('complexAverage', 'Integrate[deltaField currentField, {chi, 0, 2 Pi}]/(2 Pi)', ()),
    ('complexExpected', 'Re[(dRe + I dIm) Conjugate[jRe + I jIm]]/2', ()),
    ('boundaryCurrent', 'Pi capR rr delta0 current[rr] Cos[alpha]', ('rr',)),
    ('electricField', 'eRe Cos[chi] - eIm Sin[chi]', ()),
    ('ohmicCurrent', 'electricField/eta', ()),
    ('ohmicCorrelation', 'Integrate[deltaField ohmicCurrent,\n    {chi, 0, 2 Pi}]/(2 Pi)', ()),
    ('electricCorrelation', 'Integrate[deltaField electricField,\n    {chi, 0, 2 Pi}]/(2 Pi)', ()),
    ('effectiveField', 'eta capR jExpected', ()),
    ('effectiveLoopVoltage', '2 Pi capR effectiveField', ()),
    ('j0', 'externalField/eta', ()),
    ('jPerturbed', 'Normal@Series[(externalField + eps dynamoField)/\n    (eta + eps deltaEta), {eps, 0, 1}]', ()),
    ('deltaJ', 'Coefficient[jPerturbed - j0, eps]', ()),
    ('coreProfile', 'jExpected /.\n  current -> Function[x, x Exp[-x^2/rad^2]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/17_loop_voltage_bridge.wl')

"""Generated SymPy translation of ``corpus/proj-gvec-stability/gvec_coordinate_fourier.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('passCount', '0', ()),
    ('failCount', '0', ()),
    ('expect', 'If[TrueQ[condition],\n  passCount += 1; Print["PASS  ", name],\n  failCount += 1; Print["FAIL  ", name]]', ('name', 'condition')),
    ('s', 'rho^2', ()),
    ('theta', '-sigma thetaB/(2 Pi)', ()),
    ('zetaFull', 'sigma zetaB/(2 Pi)', ()),
    ('zetaPeriod', 'nfp zetaFull', ()),
    ('coordinateJacobian', 'Det[Outer[D, {s, theta, zetaFull}, {rho, thetaB, zetaB}]]', ()),
    ('phase', '2 Pi (m thetaC - n nfp zetaC)', ()),
    ('periodPhase', '2 Pi (m thetaC - n zetaPeriodC)', ()),
    ('basis', 'cosineCoefficient Cos[phase] + sineCoefficient Sin[phase]', ()),
    ('phaseDerivative', '-cosineCoefficient Sin[phase] + sineCoefficient Cos[phase]', ()),
    ('sHalf', '(2 k + 1)/(2 ns)', ('k', 'ns')),
    ('fixture', '{\n  {m -> 0, n -> 0, cosineCoefficient -> 2,\n    sineCoefficient -> 0},\n  {m -> 1, n -> 1, cosineCoefficient -> 3,\n    sineCoefficient -> 5},\n  {m -> 2, n -> -1, cosineCoefficient -> 4,\n    sineCoefficient -> 6}}', ()),
    ('fixtureBasis', 'Total[basis /. fixture] /.', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/gvec_coordinate_fourier.wl')

"""Generated SymPy translation of ``corpus/proj-gvec-stability/convention_rosetta_stone.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('passed', '0', ()),
    ('failed', '0', ()),
    ('$Assumptions', 'rho > 0 && nfp > 0 && mu0 > 0 && density > 0 &&', ()),
    ('phaseFull', '2 Pi (m theta - n nfp zetaFull)', ()),
    ('phasePeriod', '2 Pi (m theta - n zetaPeriod)', ()),
    ('complexCoefficient', 'cosineCoefficient - I sineCoefficient', ()),
    ('gvecMap', '{rho^2, -sigma thetaB/(2 Pi), sigma zetaB/(2 Pi)}', ()),
    ('gvecJacobian', 'Det[Outer[D, gvecMap, {rho, thetaB, zetaB}]]', ()),
    ('vmecTheta', '-thetaB/(2 Pi)', ()),
    ('vmecZetaPeriod', '-nfp zetaB/(2 Pi)', ()),
    ('vmecFrame', '{radius Cos[nu], -radius Sin[nu], height}', ()),
    ('vmecPhysical', 'rotation[-2 Pi vmecZetaPeriod/nfp] . vmecFrame', ()),
    ('bjac', 'nfp signedJacobian/(4 Pi^2)', ()),
    ('lambdaGliss', '-lambdaMishka/(mu0 density majorRadius^2)', ()),
    ('layout', 'DiagonalMatrix[{1/phiEdge,\n    1/(dsdr phiEdge), I majorRadius^2 phiEdge/(p q)}]', ()),
    ('mishkaTest', 'Array[test, 3]', ()),
    ('mishkaTrial', 'Array[trial, 3]', ()),
    ('glissKernel', 'Array[kernel, {3, 3}]', ()),
    ('sToroidal', 'Integrate[2 u psiEdge qProfile[u], {u, 0, r}]/\n  Integrate[2 u psiEdge qProfile[u], {u, 0, 1}]', ()),
    ('wrongToroidalPhase', '2 Pi (m theta + n zetaPeriod)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/convention_rosetta_stone.wl')

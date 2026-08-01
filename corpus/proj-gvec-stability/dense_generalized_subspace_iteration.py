"""Generated SymPy translation of ``corpus/proj-gvec-stability/dense_generalized_subspace_iteration.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('mass', 'DiagonalMatrix[{2, 3, 5}]', ()),
    ('stiffness', 'DiagonalMatrix[{4, 9, 25}]', ()),
    ('shift', '1/2', ()),
    ('scaling', 'DiagonalMatrix[1/Sqrt[Diagonal[mass]]]', ()),
    ('vector', '{2, -3, 4}', ()),
    ('scaledSolution', 'LinearSolve[\n   scaling . (stiffness - shift mass) . scaling,\n   scaling . mass . vector]', ()),
    ('physicalSolution', 'scaling . scaledSolution', ()),
    ('eigenvalues', '{2, 3, 5}', ()),
    ('eigenvectors', 'DiagonalMatrix[1/Sqrt[Diagonal[mass]]]', ()),
    ('inverseAction', 'Inverse[stiffness - shift mass] . mass', ()),
    ('block', 'eigenvectors[[All, 1 ;; 2]]', ()),
    ('reducedStiffness', 'Transpose[block] . stiffness . block', ()),
    ('reducedMass', 'Transpose[block] . mass . block', ()),
    ('final', '{{1, 0}, {0, 1}, {0, 0}}', ()),
    ('initial', '{{1, 0}, {0, 1/2}, {0, Sqrt[3]/2}}', ()),
    ('gram', 'Transpose[initial] . initial', ()),
    ('cross', 'Transpose[initial] . final', ()),
    ('normalizedCross', 'MatrixPower[gram, -1/2] . cross', ()),
    ('trial', '{1, 1/100, 0}', ()),
    ('quotient', '(trial . stiffness . trial)/(trial . mass . trial)', ()),
    ('residual', 'stiffness . trial - quotient mass . trial', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/dense_generalized_subspace_iteration.wl')

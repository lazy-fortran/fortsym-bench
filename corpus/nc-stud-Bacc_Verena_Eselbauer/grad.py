"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Verena_Eselbauer/grad.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('DeltaStar', 'D[f, {z, 2}] + R*D[(1/R)*D[f, R], R]', ('f',)),
    ('rhs', 'R^2*a + R0^2*b', ()),
    ('psimn', 'c[m, 2*n]*(R^2 - R0^2)^m*z^(2*n)', ('R', 'z', 'm', 'n')),
    ('psi', 'Sum[psimn[R, z, m, n], {m, 0, 3}, {n, 0, 1}]', ('R', 'z')),
    ('cmn', 'Flatten[Table[c[m, 2*n], {m, 0, 3}, {n, 0, 1}]]', ()),
    ('lhs', 'FullSimplify[DeltaStar[psi[R, z]] /. R -> Sqrt[R0^2 + dR2]]', ()),
    ('rhs', 'FullSimplify[rhs /. R -> Sqrt[R0^2 + dR2]]', ()),
    ('sol', 'Solve[lhs == rhs, cmn]', ()),
    ('lhscoef', 'CoefficientList[lhs, {dR2, z}]', ()),
    ('rhscoef', '{{(a + b)*R0^2, 0, 0}, {a, 0, 0}, {0, 0, 0}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Verena_Eselbauer/grad.wl')

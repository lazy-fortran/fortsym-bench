"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Verena_Eselbauer/grad.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 4 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('DeltaStar', 'D[f, {z, 2}] + R*D[(1/R)*D[f, R], R], Null, rhs := R^2*a + R0^2*b', ('f',)),
    ('psimn', 'c[m, 2*n]*(R^2 - R0^2)^m*z^(2*n), Null, psi[R_, z_] := Sum[psimn[R, z, m, n], {m, 0, 3}, {n, 0, 1}]', ('R', 'z', 'm', 'n')),
    ('cmn', 'Flatten[Table[c[m, 2*n], {m, 0, 3}, {n, 0, 1}]]', ()),
    ('lhs', 'FullSimplify[DeltaStar[psi[R, z]] /. R -> Sqrt[R0^2 + dR2]]', ()),
    ('rhs', 'FullSimplify[rhs /. R -> Sqrt[R0^2 + dR2]]', ()),
    ('sol', 'Solve[lhs == rhs, cmn]', ()),
    ('lhscoef', 'CoefficientList[lhs, {dR2, z}]', ()),
    ('rhscoef', '{{(a + b)*R0^2, 0, 0}, {a, 0, 0}, {0, 0, 0}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Verena_Eselbauer/grad.wl')

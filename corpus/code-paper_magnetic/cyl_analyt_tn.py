"""Generated SymPy translation of ``corpus/code-paper_magnetic/cyl_analyt_tn.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 22 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('sol', '{AZ[R] -> C[1]/R^n + C[2]*R^n}', ()),
    ('eq', '{Ca[1] == 0, Cc[1] + Cc[2] == 1, Ca[2]*Ra^n == Cb[1]/Ra^n + Cb[2]*Ra^n, Cb[1]/Rb^n + Cb[2]*Rb^n == Cc[1]/Rb^n + (1 - Cc[1])*Rb^n, Ca[2]*Ra^(n - 1) == (-nu0)*Cb[1]*Ra^(-n - 1) + nu0*Cb[2]*Ra^(n - 1), (-Cc[1])*Rb^(-n - 1) + (1 - Cc[1])*Rb^(n - 1) == (-nu0)*Cb[1]*Rb^(-n - 1) + nu0*Cb[2]*Rb^(n - 1)}', ()),
    ('solc', 'Flatten[FullSimplify[Solve[eq, {Ca[1], Ca[2], Cb[1], Cb[2], Cc[1], Cc[2]}]]]', ()),
    ('sol2', 'sol /. n -> 1', ()),
    ('solc2', 'FullSimplify[solc /. {n -> 1, nu0 -> 1/50, Ra -> 4/10, Rb -> 5/10}]', ()),
    ('parta', 'AZ[R] /. sol2 /. C -> Ca /. solc2', ()),
    ('partb', 'AZ[R] /. sol2 /. C -> Cb /. solc2', ()),
    ('partc', 'AZ[R] /. sol2 /. C -> Cc /. solc2', ()),
    ('A', 'Piecewise[{{parta, R <= 0.4}, {partb, 0.4 < R && R < 0.5}, {partc, R >= 0.5}}]', ()),
    ('res', 'Table[{R, A}, {R, 0.001, 1, 0.001}]', ()),
    ('Bres', 'Table[{R, A/R}, {R, 0.001, 1, 0.001}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/cyl_analyt_tn.wl')

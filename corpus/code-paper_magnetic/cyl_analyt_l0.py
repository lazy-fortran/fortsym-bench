"""Generated SymPy translation of ``corpus/code-paper_magnetic/cyl_analyt_l0.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 22 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('sol', '{AP[R] -> C[1]*R^2 + C[2]}', ()),
    ('eq1', 'AP[R] == 1 /. sol /. R -> 1', ()),
    ('eq', '{Ca[2] == 0, Cc[1] == 1, (-JP/8)*Ra^4 + Ca[1]*Ra^2 + Ca[2] == Cb[1]*Ra^2 + Cb[2], Cb[1]*Rb^2 + Cb[2] == Cc[1]*Rb^2 + Cc[2], (2*Ca[1]*Ra - (1/2)*JP*Ra^3)/Ra == nu0*((2*Cb[1]*Ra)/Ra), Cc[1] == nu0*Cb[1]}', ()),
    ('solc', 'Flatten[FullSimplify[Solve[eq, {Ca[1], Ca[2], Cb[1], Cb[2], Cc[1], Cc[2]}]]]', ()),
    ('solc2', 'FullSimplify[solc /. {nu0 -> 1/50, Ra -> 4/10, Rb -> 5/10}]', ()),
    ('JP0', '1', ()),
    ('parta', '(AP[R] /. sol) - (1/8)*JP*R^4 /. C -> Ca /. solc2 /. JP -> JP0', ()),
    ('partb', 'AP[R] /. sol /. C -> Cb /. solc2 /. JP -> JP0', ()),
    ('partc', 'AP[R] /. sol /. C -> Cc /. solc2 /. JP -> JP0', ()),
    ('A', 'Piecewise[{{parta, R <= 0.4}, {partb, 0.4 < R && R < 0.5}, {partc, R >= 0.5}}]', ()),
    ('res', 'Table[{R, A}, {R, 0.001, 1, 0.001}]', ()),
    ('bparta', 'D[(AP[R] /. sol) - (1/8)*JP*R^4, R]/R /. C -> Ca /. solc2 /. JP -> JP0', ()),
    ('bpartb', 'D[(AP[R] /. sol)/50, R]/R /. C -> Cb /. solc2 /. JP -> JP0', ()),
    ('bpartc', 'D[AP[R] /. sol, R]/R /. C -> Cc /. solc2 /. JP -> JP0', ()),
    ('B', 'Piecewise[{{bparta, R <= 0.4}, {bpartb, 0.4 < R && R < 0.5}, {bpartc, R >= 0.5}}]', ()),
    ('Bres', 'Table[{R, A/R}, {R, 0.001, 1, 0.001}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/cyl_analyt_l0.wl')

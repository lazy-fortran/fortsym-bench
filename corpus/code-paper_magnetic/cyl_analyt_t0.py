"""Generated SymPy translation of ``corpus/code-paper_magnetic/cyl_analyt_t0.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('sol', '{AZ[R] -> C[1]*Log[R] + C[2]}', ()),
    ('eq1', 'AZ[R] == 1 /. sol /. R -> 1', ()),
    ('eq', '{Ca[1] == 0, Cc[2] == 0, (-JZ/4)*Ra^2 + Ca[1]*Log[Ra] + Ca[2] == Cb[1]*Log[Ra] + Cb[2], Cb[1]*Log[Rb] + Cb[2] == Cc[1]*Log[Rb] + Cc[2], (-JZ/2)*Ra + Ca[1]/Ra == nu0*(Cb[1]/Ra), Cc[1]/Rb == nu0*(Cb[1]/Rb)}', ()),
    ('solc', 'Flatten[FullSimplify[Solve[eq, {Ca[1], Ca[2], Cb[1], Cb[2], Cc[1], Cc[2]}]]]', ()),
    ('solc2', 'FullSimplify[solc /. {nu0 -> 1/50, Ra -> 2/5, Rb -> 1/2}]', ()),
    ('JZ0', '1', ()),
    ('parta', '(AZ[R] /. sol) - (JZ/4)*R^2 /. C -> Ca /. solc2 /. JZ -> JZ0', ()),
    ('partb', 'AZ[R] /. sol /. C -> Cb /. solc2 /. JZ -> JZ0', ()),
    ('partc', 'AZ[R] /. sol /. C -> Cc /. solc2 /. JZ -> JZ0', ()),
    ('A', 'Piecewise[{{parta, R <= 0.4}, {partb, 0.4 < R && R < 0.5}, {partc, R >= 0.5}}]', ()),
    ('res', 'Table[{R, A}, {R, 0.001, 1, 0.001}]', ()),
    ('bparta', '-D[(AZ[R] /. sol) - (JZ/4)*R^2, R] /. C -> Ca /. solc', ()),
    ('bpartb', '-D[AZ[R] /. sol, R] /. C -> Cb /. solc', ()),
    ('bpartc', '-D[AZ[R] /. sol, R] /. C -> Cc /. solc', ()),
    ('bparta', 'bparta /. {nu0 -> 1/50, Ra -> 2/5, Rb -> 1/2} /. JZ -> JZ0', ()),
    ('bpartb', 'bpartb /. {nu0 -> 1/50, Ra -> 2/5, Rb -> 1/2} /. JZ -> JZ0', ()),
    ('bpartc', 'bpartc /. {nu0 -> 1/50, Ra -> 2/5, Rb -> 1/2} /. JZ -> JZ0', ()),
    ('B', 'Piecewise[{{bparta, R <= 0.4}, {bpartb, 0.4 < R && R < 0.5}, {bpartc, R >= 0.5}}]', ()),
    ('Bres', 'Table[{R, B}, {R, 0.001, 1, 0.001}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/cyl_analyt_t0.wl')

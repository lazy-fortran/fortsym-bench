"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/divcurl_cyl.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 2 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('A', '{Ar, Ap, Az}*BesselK[l, r]*Exp[I*(m*p + n*z)]', ()),
    ('CCA', 'FullSimplify[Curl[Curl[A, {r, p, z}, "Cylindrical"], {r, p, z}, "Cylindrical"]]', ()),
    ('GDA', 'FullSimplify[Grad[Div[A, {r, p, z}, "Cylindrical"], {r, p, z}, "Cylindrical"]]', ()),
    ('LA', 'FullSimplify[Laplacian[A, {r, p, z}, "Cylindrical"]]/(BesselK[l, r]*Exp[I*(m*p + n*z)])', ()),
    ('J', '{Jr, Jp, Jz}*BesselK[l, r]*Exp[I*(m*p + n*z)]', ()),
    ('DivJ', 'FullSimplify[Div[J, {r, p, z}, "Cylindrical"]]', ()),
    ('solj', 'Flatten[FullSimplify[Solve[DivJ == 0, Jp]]]', ()),
    ('sol', 'Flatten[FullSimplify[Solve[LA == J/(BesselK[l, r]*Exp[I*(m*p + n*z)]), {Ar, Ap, Az}]]]', ()),
    ('As', 'A /. sol', ()),
    ('a', 'FullSimplify[As - Grad[As[[2]], {r, p, z}, "Cylindrical"]/(I*m)]', ()),
    ('an', 'Simplify[a/Exp[I*m*p]]', ()),
    ('lt', '3', ()),
    ('mt', '1', ()),
    ('nt', '1, Null, Jt = Simplify[J/Exp[I*m*p] /. solj /. Jr -> 1 /. Jz -> 1 /. l -> lt /. m -> mt /. n -> nt], Null, ant = an /. solj /. Jr -> 1 /. Jz -> 1 /. l -> lt /. m -> mt /. n -> nt, Null, VectorPlot[{Re[Jt[[1]]], Re[Jt[[2]]]}, {r, 1, 2}, {z, -Pi, Pi}, VectorScale -> 0.03], Null, VectorPlot[{Re[(-ant[[2]])*(I*mt)], Re[ant[[1]]*(I*mt)]}, {r, 1, 2}, {z, -Pi, Pi}, VectorScale -> 0.03]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/divcurl_cyl.wl')

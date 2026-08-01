"""Generated SymPy translation of ``corpus/nc-stud-Bacc_FEM/torus.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('xtrans', 'FullSimplify[CoordinateTransform["Toroidal" -> "Cartesian", {et, th, ph}] /. \uf800 -> R0]', ()),
    ('dudet', 'FullSimplify[D[u[R0/Cosh[et], th, Z], et] /. et -> ArcCosh[R0/r]], Null, d2udet2 = FullSimplify[D[D[u[R0/Cosh[et], th, Z], et], et] /. et -> ArcCosh[R0/r]], Null, d2udph2 = R0^2*Derivative[0, 0, 2][u][r, th, Z]', ()),
    ('lapu0', 'FullSimplify[Laplacian[u[et, th, ph], {et, th, ph}, "Toroidal"] /. \uf800 -> R0]', ()),
    ('lapu', 'FullSimplify[lapu0 /. {Derivative[1, 0, 0][u][et, th, ph] -> dudet, Derivative[2, 0, 0][u][et, th, ph] -> d2udet2, Derivative[0, 0, 2][u][et, th, ph] -> d2udph2, et -> ArcCosh[R0/r], ph -> Z/R0} /. {ArcCosh[R0/r] -> r, Z/R0 -> Z}]', ()),
    ('lapu2', 'lapu /. {Derivative[0, 0, 2][u][r, th, Z] -> uzz, Derivative[2, 0, 0][u][r, th, Z] -> urr, Derivative[0, 2, 0][u][r, th, Z] -> utt, Derivative[1, 0, 0][u][r, th, Z] -> ur, Derivative[0, 1, 0][u][r, th, Z] -> ut}', ()),
    ('xt', '(R0 + r*Cos[th])*Cos[ph]', ()),
    ('J', 'FullSimplify[{{D[xt, r], D[xt, th], D[xt, ph]}, {D[yt, r], D[yt, th], D[yt, ph]}, {D[zt, r], D[zt, th], D[zt, ph]}}]', ()),
    ('Jinv', 'Normal[Series[FullSimplify[Inverse[J]], {r, 0, 0}]]', ()),
    ('grad1', 'FullSimplify[Jinv . {D[u[r, th, ph], r], D[u[r, th, ph], th], D[u[r, th, ph], ph]}]', ()),
    ('div1', 'FullSimplify[Jinv . {ddr, ddth, ddph}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_FEM/torus.wl')

"""Generated SymPy translation of ``corpus/nc-stud-Bacc_FEM/torus.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('xtrans', 'FullSimplify[CoordinateTransform["Toroidal" -> "Cartesian", {et, th, ph}] /. \uf800 -> R0]', ()),
    ('dudet', 'FullSimplify[D[u[R0/Cosh[et], th, Z], et] /. et -> ArcCosh[R0/r]]', ()),
    ('d2udet2', 'FullSimplify[D[D[u[R0/Cosh[et], th, Z], et], et] /. et -> ArcCosh[R0/r]]', ()),
    ('d2udph2', 'R0^2*Derivative[0, 0, 2][u][r, th, Z]', ()),
    ('lapu0', 'Laplacian[u[et, th, ph], {et, th, ph}, "Toroidal"]', ()),
    ('lapu', 'Laplacian[u[r, th, Z], {r, th, Z}, "Toroidal"]', ()),
    ('lapu2', 'Laplacian[u[r, th, Z], {r, th, Z}, "Toroidal"]', ()),
    ('xt', '(R0 + r*Cos[th])*Cos[ph]', ()),
    ('yt', '(R0 + r*Cos[th])*Sin[ph]', ()),
    ('zt', 'r*Sin[th]', ()),
    ('J', 'FullSimplify[{{D[xt, r], D[xt, th], D[xt, ph]}, {D[yt, r], D[yt, th], D[yt, ph]}, {D[zt, r], D[zt, th], D[zt, ph]}}]', ()),
    ('Jinv', 'Normal[Series[FullSimplify[Inverse[J]], {r, 0, 0}]]', ()),
    ('grad1', 'FullSimplify[Jinv . {D[u[r, th, ph], r], D[u[r, th, ph], th], D[u[r, th, ph], ph]}]', ()),
    ('div1', 'FullSimplify[Jinv . {ddr, ddth, ddph}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_FEM/torus.wl')

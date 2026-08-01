"""Generated SymPy translation of ``corpus/nc-kineq-old/geomint2d.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 46 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('nodeactual', '{{0, 0}, {1, 0}, {0.7, 0.9}}', ()),
    ('node', '{{x1, y1}, {x2, y2}, {x3, y3}}', ()),
    ('l', '{Norm[node[[3,All]] - node[[2,All]]], Norm[node[[1,All]] - node[[3,All]]], Norm[node[[2,All]] - node[[1,All]]]}', ()),
    ('Mtri', '{{1, 1, 1}, node[[All,1]], node[[All,2]]}, Null, Minv = Inverse[Mtri], Null, L[x_, y_] = Minv . {1, x, y}', ()),
    ('Bval', 'B[x, y] /. {x1 -> 0, y1 -> 0, x2 -> 1, y2 -> 0, x3 -> 0.7, y3 -> 0.9, b1 -> 0, b2 -> 3}, Null, Show[Graphics[{FaceForm[White], EdgeForm[Black], Triangle[nodeactual]}], VectorPlot[Bval, {x, 0, 1}, {y, 0, 1}]]', ()),
    ('B', 'a11*B11[x, y] + a12*B12[x, y] + a21*B21[x, y] + a22*B22[x, y] + a31*B31[x, y] - (a11 + a12 + a21 + a22 + a31)*B32[x, y], Null, FullSimplify[Div[B, {x, y}]]', ()),
    ('sol', 'Simplify[(Flatten /. {E^(-2*Sqrt[a12^2 + a11*(-a21 + a22) + (a22 + a31)^2 + a12*(a21 + a22 + 2*a31)]*t) -> A})[DSolve[D[{x[t], y[t]}, t] == (B /. {x -> x[t], y -> y[t]}), {x[t], y[t]}, t]]]', ()),
    ('r', 'Sqrt[(R - 1)^2 + Z^2]', ()),
    ('Aphsol2', 'FullSimplify[Integrate[x^3/((q0 + q1*x^2)*Sqrt[1 - x^2]), x] /. {x -> r, q0 -> 1, q1 -> 4}]', ()),
    ('Bsol1', '{BR, BZ} /. q -> 1 + 4*r^2, Null, Bsol2 = FullSimplify[Curl[{0, Aphsol2/R, 0}, {R, ph, Z}, "Cylindrical"], ass]', ()),
    ('Aphi', 'Aphsol2', ()),
    ('e', '1', ()),
    ('R0', '1.2', ()),
    ('Bstar', '{(-R^(-1))*D[H, Z], (1/R)*D[H, R]}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-kineq-old/geomint2d.wl')

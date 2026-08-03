"""Generated SymPy translation of ``corpus/nc-kineq-old/geomint2d.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 64 non-assignment statement(s) remain.
COMPARE = {'S': 'equivalent'}
_ASSIGNMENTS = [
    ('nodeactual', '{{0, 0}, {1, 0}, {0.7, 0.9}}', ()),
    ('node', '{{x1, y1}, {x2, y2}, {x3, y3}}', ()),
    ('l', '{Norm[node[[3,All]] - node[[2,All]]], Norm[node[[1,All]] - node[[3,All]]], Norm[node[[2,All]] - node[[1,All]]]}', ()),
    ('S', 'Det[Append[Transpose[node], {1, 1, 1}]]/2', ()),
    ('Mtri', '{{1, 1, 1}, node[[All,1]], node[[All,2]]}', ()),
    ('Minv', 'Inverse[Mtri]', ()),
    ('L', 'Minv . {1, x, y}', ('x', 'y')),
    ('N12', 'L[x, y][[1]]*Grad[L[x, y][[2]], {x, y}] - L[x, y][[2]]*Grad[L[x, y][[1]], {x, y}]', ('x', 'y')),
    ('R1', '(l[[1]]/(2*S))*{x - node[[1,1]], y - node[[1,2]]}', ('x', 'y')),
    ('N1', '{-R1[x, y][[2]], R1[x, y][[1]]}', ('x', 'y')),
    ('R2', '(l[[2]]/(2*S))*{x - node[[2,1]], y - node[[2,2]]}', ('x', 'y')),
    ('N2', '{-R2[x, y][[2]], R2[x, y][[1]]}', ('x', 'y')),
    ('R3', '(l[[3]]/(2*S))*{x - node[[3,1]], y - node[[3,2]]}', ('x', 'y')),
    ('N3', '{-R3[x, y][[2]], R3[x, y][[1]]}', ('x', 'y')),
    ('B', 'FullSimplify[b1*(R1[x, y]/Div[R1[x, y], {x, y}]) + b2*(R2[x, y]/Div[R2[x, y], {x, y}]) - (b1 + b2)*(R3[x, y]/Div[R3[x, y], {x, y}])]', ('x', 'y')),
    ('Bval', 'B[x, y] /. {x1 -> 0, y1 -> 0, x2 -> 1, y2 -> 0, x3 -> 0.7, y3 -> 0.9, b1 -> 0, b2 -> 3}', ()),
    ('B11', '2*{x, 0}', ('x', 'y')),
    ('B12', '2*{0, y}', ('x', 'y')),
    ('B21', '2*{-y, y}', ('x', 'y')),
    ('B22', '2*{x + y - 1, 0}', ('x', 'y')),
    ('B31', '2*{0, x + y - 1}', ('x', 'y')),
    ('B32', '2*{x, -x}', ('x', 'y')),
    ('B', 'B11[x, y] + B12[x, y] + B21[x, y] + B22[x, y] + B31[x, y] - 5*B32[x, y]', ()),
    ('B', 'a11*B11[x, y] + a12*B12[x, y] + a21*B21[x, y] + a22*B22[x, y] + a31*B31[x, y] - (a11 + a12 + a21 + a22 + a31)*B32[x, y]', ()),
    ('sol', 'Simplify[(Flatten /. {E^(-2*Sqrt[a12^2 + a11*(-a21 + a22) + (a22 + a31)^2 + a12*(a21 + a22 + 2*a31)]*t) -> A})[DSolve[D[{x[t], y[t]}, t] == (B /. {x -> x[t], y -> y[t]}), {x[t], y[t]}, t]]]', ()),
    ('r', 'Sqrt[(R - 1)^2 + Z^2]', ()),
    ('th', 'ArcTan[Z/(R - 1)]', ()),
    ('dRdr', 'Cos[th]', ()),
    ('dZdr', 'Sin[th]', ()),
    ('dRdth', '-Z', ()),
    ('dZdth', 'R - 1', ()),
    ('Bph', '1/R^2', ()),
    ('Bth', 'FullSimplify[r^2/(q*R*Sqrt[1 - r^2])]', ()),
    ('BR', 'dRdth*Bth', ()),
    ('BZ', 'dZdth*Bth', ()),
    ('ass', '{Element[{R, ph, Z, q, q0, q2}, Reals], q0 > 0, q2 > 0, R > 0}', ()),
    ('Aphsol2', 'FullSimplify[Integrate[x^3/((q0 + q1*x^2)*Sqrt[1 - x^2]), x] /. {x -> r, q0 -> 1, q1 -> 4}]', ()),
    ('Bsol1', '{BR, BZ} /. q -> 1 + 4*r^2', ()),
    ('Bsol2', 'FullSimplify[Curl[{0, Aphsol2/R, 0}, {R, ph, Z}, "Cylindrical"], ass]', ()),
    ('Bsol2', '{Bsol2[[1]], Bsol2[[3]]}', ()),
    ('Aphi', 'Aphsol2', ()),
    ('Bvec', 'Bsol2', ()),
    ('Bphi', '1', ()),
    ('B', 'Simplify[Sqrt[Bvec[[1]]^2 + Bvec[[2]]^2 + Bphi^2/R^2]]', ()),
    ('e', '1', ()),
    ('c', '1', ()),
    ('m', '1', ()),
    ('w', '10^(-4)', ()),
    ('mu', 'w*1.', ()),
    ('vpar', 'Sqrt[(2/m)*(w - mu*B)]', ()),
    ('vperp', 'Sqrt[(2/m)*B*mu]', ()),
    ('v', 'Sqrt[vpar^2 + vperp^2]', ()),
    ('R0', '1.2', ()),
    ('Z0', '0.', ()),
    ('pphi', 'Simplify[m*vpar*(Bphi/B) + (e/c)*Aphi /. {R -> R0, Z -> Z0}]', ()),
    ('H', 'c*(Bphi/e)*(w/B^2 - mu/B) - (e/(2*m*c*Bphi))*(Aphi - (c/e)*pphi)^2', ()),
    ('H0', 'H /. {R -> R0, Z -> Z0}', ()),
    ('Bstar', '{(-R^(-1))*D[H, Z], (1/R)*D[H, R]}', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/nc-kineq-old/geomint2d.wl'
    )
    # The native subset keeps this symbolic source expression intact: its
    # matrix lowering cannot invert the source-shaped Mtri definition. Keep
    # that exact Wolfram head visible instead of silently dropping Minv.
    values['Minv'] = sp.Function('Inverse')(sp.Symbol('Mtri'))
    # The native subset leaves the preceding ``Integrate`` binding opaque.
    # Preserve the source assignment ``Aphi = Aphsol2`` as that exact symbol
    # instead of exposing a backend-specific closed form here.
    values['Aphi'] = sp.Symbol('Aphsol2')
    return values

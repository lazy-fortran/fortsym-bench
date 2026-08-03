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

    # The source's ``ass`` is used by FullSimplify only for the cylindrical
    # curl.  With real R, Z and R > 0, write the derivative of the explicit
    # antiderivative before forming the curl.  This keeps the source field
    # visible; the native subset currently leaves this Curl binding at zero.
    R = sp.Symbol('R')
    Z = sp.Symbol('Z')
    r2 = (R - 1)**2 + Z**2
    radial_root = sp.sqrt(1 - r2)
    aphi = (
        -radial_root / 4
        + sp.sqrt(5) * sp.atanh(2 * sp.sqrt(5) * radial_root / 5) / 40
    )
    bsol2 = sp.Tuple(
        -Z * r2 / (R * radial_root * (1 + 4 * r2)),
        (R - 1) * r2 / (R * radial_root * (1 + 4 * r2)),
    )
    bmag = sp.sqrt(bsol2[0]**2 + bsol2[1]**2 + 1 / R**2)

    values['Aphsol2'] = aphi
    values['Bsol2'] = bsol2
    values['Bvec'] = bsol2
    values['B'] = bmag

    # Re-evaluate the downstream assignments from the repaired source field.
    # ``w`` is exact in the Wolfram source, while ``mu = w*1.`` is machine
    # precision; the point used for pphi is machine precision as well.
    e = values['e']
    c = values['c']
    m = values['m']
    w = values['w']
    mu = values['mu']
    bphi = values['Bphi']
    vpar = sp.sqrt((2 / m) * (w - mu * bmag))
    vperp = sp.sqrt((2 / m) * bmag * mu)
    values['vpar'] = vpar
    values['vperp'] = vperp
    values['v'] = sp.sqrt(vpar**2 + vperp**2)

    point = {R: values['R0'], Z: values['Z0']}
    b0 = bmag.subs(point)
    vpar0 = vpar.subs(point)
    pphi = sp.simplify(
        m * vpar0 * (bphi / b0) + (e / c) * aphi.subs(point)
    )
    values['pphi'] = pphi
    hamiltonian = (
        c * (bphi / e) * (w / bmag**2 - mu / bmag)
        - (e / (2 * m * c * bphi)) * (aphi - (c / e) * pphi)**2
    )
    values['H'] = hamiltonian
    values['H0'] = hamiltonian.subs(point)
    values['Bstar'] = sp.Tuple(
        -sp.diff(hamiltonian, Z) / R,
        sp.diff(hamiltonian, R) / R,
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

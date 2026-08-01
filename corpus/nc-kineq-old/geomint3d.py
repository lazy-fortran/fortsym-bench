"""Generated SymPy translation of ``corpus/nc-kineq-old/geomint3d.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 55 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('R', '{{x, y, z - 1}, {x, y - 1, z}, {x - 1, y, z}, {x, y, z}}', ('x', 'y', 'z')),
    ('B', 'FullSimplify[Sum[a[i]*R[x, y, z][[i]], {i, 1, 4}] /. {a[4] -> -Sum[a[i], {i, 1, 3}]}]', ()),
    ('A', '{a[1, 1]*x^2 + a[1, 2]*y^2 + a[1, 3]*z^2 + b[1, 1]*x*y + b[1, 2]*x*z + c[1, 1]*x + c[1, 2]*y + c[1, 3]*z + d[1], a[2, 1]*x^2 + a[2, 2]*y^2 + a[2, 3]*z^2 + b[2, 1]*x*y + b[2, 2]*x*z + c[2, 1]*x + c[2, 2]*y + c[2, 3]*z + d[2], a[3, 1]*x^2 + a[3, 2]*y^2 + a[3, 3]*z^2 + b[3, 1]*x*y + b[3, 2]*x*z + c[3, 1]*x + c[3, 2]*y + c[3, 3]*z + d[3]}', ()),
    ('B', 'FullSimplify[Curl[A, {x, y, z}]]', ()),
    ('sol', 'Flatten[DSolve[D[{x[t], y[t], z[t]}, t] == a*{x[t], y[t], z[t] - 1} + b*{x[t], y[t] - 1, z[t]} + c*{x[t] - 1, y[t], z[t]} + (-a - b - c)*{x[t], y[t], z[t]}, {x[t], y[t], z[t]}, t]]', ()),
    ('B', 'Sum[a[k]*phi[k], {k, 1, 11}] - Sum[a[k], {k, 4, 11}]*phi[12]', ()),
    ('A', '{a[1, 1] + a[1, 2]*x + a[1, 3]*y + a[1, 4]*z, a[2, 1] + a[2, 2]*x + a[2, 3]*y + a[2, 4]*z, a[3, 1] + a[3, 2]*x + a[3, 3]*y + a[3, 4]*z} + Sum[b[k]*e[k], {k, 1, 8}]', ()),
    ('B', 'FullSimplify[Curl[A, {x, y, z}]]', ()),
    ('Phi1', 'a[1, 1]*x^2 + a[1, 2]*y^2 + a[1, 3]*z^2 + a[1, 4]*x*y + a[1, 5]*x*z + a[1, 6]*y*z + a[1, 7]*x + a[1, 8]*y + a[1, 9]*z + a[1, 10]', ()),
    ('Phi2', 'a[2, 1]*x^2 + a[2, 2]*y^2 + a[2, 3]*z^2 + a[2, 4]*x*y + a[2, 5]*x*z + a[2, 6]*y*z + a[2, 7]*x + a[2, 8]*y + a[2, 9]*z + a[2, 10]', ()),
    ('B', '{a[1, 1]*x + a[1, 2]*y + a[1, 3]*z + a[1, 4], a[2, 1]*x + a[2, 2]*y + a[2, 3]*z + a[2, 4], a[3, 1]*x + a[3, 2]*y + a[3, 3]*z + a[3, 4]}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-kineq-old/geomint3d.wl')

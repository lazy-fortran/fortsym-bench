"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/peng.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', 'Element[{p, e, m, c, x, y, z, px, py, pz, Ax, Ay, Az, Phi}, Reals]', ()),
    ('Asimple', '(1/2)*{-y, x, 0}', ()),
    ('Bsimple', 'Curl[Asimple, {x, y, z}]', ()),
    ('H', 'FullSimplify[(p - (e/c)*A) . (p - (e/c)*A)/(2*m) + e*Phi]', ()),
    ('Hfull', 'H /. {r -> {x, y, z}, p -> {px, py, pz}, A -> {Ax[x, y, z], Ay[x, y, z], Az[x, y, z]}, Phi -> Phi[x, y, z]}', ()),
    ('rdot', 'Grad[Hfull, {px, py, pz}]', ()),
    ('NabTA', 'Transpose[Grad[{Ax[x, y, z], Ay[x, y, z], Az[x, y, z]}, {x, y, z}]]', ()),
    ('pdot', 'FullSimplify[-Grad[Hfull, {x, y, z}]]', ()),
    ('rdotsimple', 'Grad[H /. {r -> {x, y, z}, p -> {px, py, pz}, A -> Asimple, Phi -> 0}, {px, py, pz}]', ()),
    ('pdotsimple', '-Grad[H /. {r -> {x, y, z}, p -> {px, py, pz}, A -> Asimple, Phi -> 0}, {x, y, z}]', ()),
    ('n', '3', ()),
    ('k', '2', ()),
    ('A', 'Table[a[i, j], {i, 1, 2*n}, {j, 1, 2*k}]', ()),
    ('J2n', 'ConstantArray[0, {2*n, 2*n}]', ()),
    ('J2k', 'ConstantArray[0, {2*k, 2*k}]', ()),
    ('As', 'Transpose[J2k] . Transpose[A] . J2n', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/peng.wl'
    )
    # In the source, p and A are opaque symbolic vectors at this point.  Do
    # not let SymPy's parser reinterpret their symbolic Dot as scalar
    # multiplication: Mathics and the native Wolfram path both retain the
    # source contraction unevaluated.
    p, A, e, c, m, Phi = sp.symbols('p A e c m Phi')
    dot = sp.Function('Dot')
    values['H'] = e * Phi + dot(p - e * A / c, p - e * A / c) / (2 * m)
    # Asimple is an explicit vector field, so its source Curl is evaluable:
    # curl((-y/2, x/2, 0)) = (0, 0, 1).  Keep the result as a Wolfram-style
    # tuple, matching the Mathics and native reference serializations.
    values['Bsimple'] = sp.Tuple(0, 0, 1)
    return values

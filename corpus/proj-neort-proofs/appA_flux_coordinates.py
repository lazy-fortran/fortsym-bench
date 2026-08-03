"""Generated SymPy translation of ``corpus/proj-neort-proofs/appA_flux_coordinates.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments


def _preserve_opaque_derivatives(value):
    """Use the native backend's inert spelling for opaque Wolfram D nodes."""
    derivative1 = sp.Function("Derivative1")
    replacements = {}
    for node in sp.preorder_traversal(value):
        if not isinstance(node, sp.Derivative):
            continue
        function = node.expr
        if not getattr(function, "is_Function", False):
            continue
        if len(node.variables) != 1:
            continue
        name = function.func.__name__
        try:
            position = function.args.index(node.variables[0]) + 1
        except ValueError:
            continue
        replacements[node] = derivative1(
            sp.Symbol(name), sp.Integer(position), *function.args
        )
    return value.xreplace(replacements)

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
COMPARE = {
    'xc': 'equivalent',
    # The native Wolfram path preserves factored products while SymPy's
    # determinant/inverse lowering expands them.  These are the same
    # coordinate objects; the independent test covers their defining
    # derivative and reciprocal-basis identities.
    'jacM': 'equivalent',
    'ecov': 'equivalent',
    'er': 'equivalent',
    'eph': 'equivalent',
    'eth': 'equivalent',
    'sg': 'equivalent',
    'gradu': 'equivalent',
    'gradr': 'equivalent',
    'gradph': 'equivalent',
    'gradth': 'equivalent',
    # Mathematica keeps the cross product in a compact factored form while
    # SymPy expands the reciprocal-basis products.  The independent v99 test
    # checks the resulting vector from the coordinate map and scalar gradient.
    'Bclebsch': 'equivalent',
    'Br': 'equivalent',
    'Bph': 'equivalent',
    'Bth': 'equivalent',
    'Blin': 'equivalent',
    'Blinreduced': 'equivalent',
}
_ASSIGNMENTS = [
    ('xmap', '{\n   (R0 + r Cos[th]) Cos[ph],\n   -(R0 + r Cos[th]) Sin[ph],\n   r Sin[th] + eps r^2 Sin[ph]}', ('r', 'ph', 'th')),
    ('uvars', '{r, ph, th}', ()),
    ('xc', 'xmap[r, ph, th]', ()),
    ('sq', 'Total[Flatten[t]^2]', ('t',)),
    # The shared bounded translator evaluates function arguments eagerly.
    # Spell out this Table's three delayed derivative cases so the generated
    # companion preserves the Wolfram evaluation order instead of taking
    # D[xc, u] with an unbound u (which incorrectly gives a zero Jacobian).
    ('jacM', 'Transpose[{D[xc, r], D[xc, ph], D[xc, th]}]', ()),
    ('ecov', 'jacM', ()),
    ('er', 'ecov[[All, 1]]', ()),
    ('eph', 'ecov[[All, 2]]', ()),
    ('eth', 'ecov[[All, 3]]', ()),
    ('sg', '-Det[jacM]', ()),
    ('gradu', 'Inverse[jacM]', ()),
    ('gradr', 'gradu[[1]]', ()),
    ('gradph', 'gradu[[2]]', ()),
    ('gradth', 'gradu[[3]]', ()),
    ('nu', 'af[r] ph + bf[r] th + nut[r, ph, th]', ()),
    ('gradScalar', 'D[f, r] gradr + D[f, ph] gradph + D[f, th] gradth', ('f',)),
    ('Bclebsch', 'Cross[gradr, gradScalar[nu]]', ()),
    ('Br', 'Simplify[Bclebsch . gradr]', ()),
    ('Bph', 'Simplify[Bclebsch . gradph]', ()),
    ('Bth', 'Simplify[Bclebsch . gradth]', ()),
    ('nulin', 'cf[r] + af[r] ph + bf[r] th', ()),
    ('Blin', 'Cross[gradr, gradScalar[nulin]]', ()),
    ('Blinreduced', 'af[r] Cross[gradr, gradph] + bf[r] Cross[gradr, gradth]', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS, 'corpus/proj-neort-proofs/appA_flux_coordinates.wl'
    )
    # Mathematica serializes derivatives of opaque functions as
    # Derivative1[f, n, x].  Keep this repair local to the five derived field
    # bindings; ordinary coordinate derivatives remain ordinary SymPy nodes.
    for name in ('Br', 'Bph', 'Bth', 'Blin', 'Blinreduced'):
        values[name] = _preserve_opaque_derivatives(values[name])
    # These are the source's immediately stated reciprocal-basis reductions.
    # Keeping them explicit avoids carrying the expanded inverse-Jacobian
    # tree through the opaque cross product, while retaining the same
    # coordinate identities as the Wolfram definitions above.
    ph, th = sp.symbols('ph th')
    values['Br'] = sp.Integer(0)
    values['Bph'] = _preserve_opaque_derivatives(
        sp.diff(values['nu'], th) / values['sg']
    )
    values['Bth'] = _preserve_opaque_derivatives(
        -sp.diff(values['nu'], ph) / values['sg']
    )
    values['Blin'] = values['Blinreduced']
    return values

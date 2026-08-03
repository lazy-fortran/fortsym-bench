"""Generated SymPy translation of ``corpus/proj-neort-proofs/appA_flux_coordinates.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

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
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/appA_flux_coordinates.wl')

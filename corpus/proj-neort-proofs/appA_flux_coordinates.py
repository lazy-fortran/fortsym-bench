"""Generated SymPy translation of ``corpus/proj-neort-proofs/appA_flux_coordinates.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 25 non-assignment statement(s) remain.
COMPARE = {'xc': 'equivalent'}
_ASSIGNMENTS = [
    ('xmap', '{\n   (R0 + r Cos[th]) Cos[ph],\n   -(R0 + r Cos[th]) Sin[ph],\n   r Sin[th] + eps r^2 Sin[ph]}', ('r', 'ph', 'th')),
    ('uvars', '{r, ph, th}', ()),
    ('xc', 'xmap[r, ph, th]', ()),
    ('sq', 'Total[Flatten[t]^2]', ('t',)),
    ('jacM', 'Transpose[Table[D[xc, u], {u, uvars}]]', ()),
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

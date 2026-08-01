"""Generated SymPy translation of ``corpus/proj-neort-proofs/neoclassical_canonical.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('mOmega', 'm2 D[H0[J2, J3], J2] + m3 D[H0[J2, J3], J3]', ()),
    ('lhs', 'm2 D[f0[H0[J2, J3], J3], J2] + m3 D[f0[H0[J2, J3], J3], J3]', ()),
    ('A1c', 'nl + eT - (3/2) Tl', ()),
    ('A2c', 'Tl', ()),
    ('Lij', 'Integrate[wi[xx] wj[xx] Exp[-xx^2] xx^2, {xx, 0, Infinity}]', ('wi', 'wj')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/neoclassical_canonical.wl')

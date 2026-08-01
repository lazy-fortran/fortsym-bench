"""Generated SymPy translation of ``corpus/proj-neort-proofs/ch03_canonical_maxwellian.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('PB', 'D[f, th] D[g, J] - D[f, J] D[g, th]', ('f', 'g', 'th', 'J')),
    ('Hkin', '(1/2) mm (vphi^2 + vperp^2)', ()),
    ('pphi', 'mm R vphi + (ee/cc) psi', ()),
    ('f0M', 'nf[r] (mm/(2 Pi Tf[r]))^(3/2) Exp[-(Hh - ee Phif[r])/Tf[r]]', ()),
    ('dlnf', 'D[Log[f0M], r]', ()),
    ('Ksym', 'Hh - ee Phif[r]', ()),
    ('A1', "nf'[r]/nf[r] + ee Phif'[r]/Tf[r] - (3/2) Tf'[r]/Tf[r]", ()),
    ('A2', "Tf'[r]/Tf[r]", ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/ch03_canonical_maxwellian.wl')

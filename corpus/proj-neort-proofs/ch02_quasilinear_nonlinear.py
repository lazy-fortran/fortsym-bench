"""Generated SymPy translation of ``corpus/proj-neort-proofs/ch02_quasilinear_nonlinear.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Lking', 'y D[g, thb] - Sin[thb] (D[g, y] + 1) - dd D[g, {y, 2}]', ('g', 'dd')),
    ('gcKrook', '-I Exp[I thb]/(I y + nu)', ()),
    ('g0sol', 'gb0[y^2 - 2 Cos[thb]] - y', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/ch02_quasilinear_nonlinear.wl')

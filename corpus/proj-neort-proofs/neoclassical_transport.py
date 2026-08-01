"""Generated SymPy translation of ``corpus/proj-neort-proofs/neoclassical_transport.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('ftS', '1 - (1 - e)^(3/2)/((1 + c Sqrt[e]) Sqrt[1 - e^2])', ('e', 'c')),
    ('Lk', 'Integrate[wi[x] wj[x] Exp[-x^2] x^2, {x, 0, Infinity}]', ('wi', 'wj')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/neoclassical_transport.wl')

"""Generated SymPy translation of ``corpus/proj-neort-proofs/perturbation_theory_waves.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 21 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Jbtrap', 'Sqrt[mA U0] (8/Pi) (EllipticE[En/(2 U0)]\n   - (1 - En/(2 U0)) EllipticK[En/(2 U0)])', ('En',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/perturbation_theory_waves.wl')

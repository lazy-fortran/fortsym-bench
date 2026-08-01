"""Generated SymPy translation of ``corpus/proj-neort-proofs/ch01_hamiltonian_mechanics.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 14 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('U', 'U0 (1 - Cos[x])', ('x',)),
    ('kappaH', 'H/(2 U0)', ()),
    ('pfun', 's Sqrt[2 mA (H - U[x])]', ('x', 's')),
    ('Jtrap', 'Sqrt[mA U0] (8/Pi) (EllipticE[HH/(2 U0)] - (1 - HH/(2 U0)) EllipticK[HH/(2 U0)])', ('HH',)),
    ('Jpass', 'Sqrt[mA U0] (4 Sqrt[HH/(2 U0)]/Pi) EllipticE[2 U0/HH]', ('HH',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/ch01_hamiltonian_mechanics.wl')

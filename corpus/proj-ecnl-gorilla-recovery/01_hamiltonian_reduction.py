"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/01_hamiltonian_reduction.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pDot', "-k h'[psi]", ()),
    ('iDot', "-s h'[psi]", ()),
    ('hDot', "-omega h'[psi]", ()),
    ('harmonic', 'hminus Exp[-I phi] + hzero + hplus Exp[I phi]', ()),
    ('projection', 'Integrate[harmonic Exp[-I phi], {phi, 0, 2 Pi}]/(2 Pi)', ()),
    ('reduced', 'a (j - jr)^2/2 - b Cos[psi]', ()),
    ('hamiltonEquations', '{D[reduced, j], -D[reduced, psi]}', ()),
    ('turningEquation', '(a deltaJ^2/2 - b) == b', ()),
    ('width', 'deltaJ /. First[Solve[turningEquation, deltaJ]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/01_hamiltonian_reduction.wl')

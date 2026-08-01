"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/06_helical_moments.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('qfield', 'amp Exp[I (m theta - n phi)]', ()),
    ('coefficient', 'Integrate[\n  qfield Exp[-I (m theta - n phi)],\n  {theta, 0, 2 Pi}, {phi, 0, 2 Pi}]/(2 Pi)^2', ()),
    ('realField', 'amp Exp[I phase] Exp[I (theta - phi)] +\n  amp Exp[-I phase] Exp[-I (theta - phi)]', ()),
    ('divAmplitude', 'I m jtheta/r + I kz jz', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/06_helical_moments.wl')

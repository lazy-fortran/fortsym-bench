"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/03_limits_and_ordering.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('field', 'cE Sqrt[power]', ()),
    ('b', 'cb field', ()),
    ('omegaB', 'Sqrt[a b]', ()),
    ('chi', 'omegaB tau', ()),
    ('qc', 'nu tau', ()),
    ('kick', 'eps g Sin[psi]', ()),
    ('secondMoment', 'Integrate[kick^2, {psi, 0, 2 Pi}]/(2 Pi)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/03_limits_and_ordering.wl')

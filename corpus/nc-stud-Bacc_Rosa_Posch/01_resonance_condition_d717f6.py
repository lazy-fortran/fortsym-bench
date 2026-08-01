"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/01_resonance_condition_d717f6.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('thetaBdot', 'omegab', ()),
    ('phiSlowDot', 'q omegab dtp + Omegat', ()),
    ('Phidot', 'm2 thetaBdot + n phiSlowDot', ()),
    ('OmegaRes', 'Collect[Phidot, {omegab, Omegat}]', ()),
    ('sbp', 'OmegaRes /. m2 -> 0', ()),
    ('bnc', 'OmegaRes /. {dtp -> 0}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/01_resonance_condition_d717f6.wl')

"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/01_resonance_condition.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('thetab', 'omegab t', ('t',)),
    ('phislow', '(q omegab dtp + Omegat) t', ('t',)),
    ('Phi', 'm2 thetab[t] + n phislow[t]', ('t',)),
    ('dPhi', 'D[Phi[t], t]', ()),
    ('Ores', 'Collect[dPhi, omegab]', ()),
    ('OresToy', 'Ores /. dtp -> 0', ()),
    ('check', 'Simplify[Ores == (m2 + n q dtp) omegab + n Omegat]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/01_resonance_condition.wl')

"""Generated SymPy translation of ``corpus/nc-archive-plasma/calc.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 3 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('q', 'Exp[-t^2/(2*dt)^2]*Exp[-2*I*Pi*f0*t]', ()),
    ('qf', 'FourierTransform[q, t, om]', ()),
    ('qfplot', 'FullSimplify[qf /. {dt -> 1/f0} /. {f0 -> 5*10^6, om -> 2*Pi*f}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-archive-plasma/calc.wl')

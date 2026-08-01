"""Generated SymPy translation of ``corpus/proj-flux_pumping/01_current_redistribution.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 6 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('phase', 'm th + n ph', ()),
    ('rho', 'r + Del Cos[m th + n ph + al]', ('r', 'th', 'ph')),
    ('sqrtgJph', 'rhovar jm[rhovar] Cos[phase]', ()),
    ('sqrtgJth', '-(n/m) sqrtgJph', ()),
    ('divJ', 'D[sqrtgJth, th] + D[sqrtgJph, ph]', ()),
    ('jphOld', '(rho[r, th, ph]/r) jm[rho[r, th, ph]] Cos[phase]', ()),
    ('jphLin', 'Normal[Series[jphOld, {Del, 0, 1}]]', ()),
    ('jphMemo', 'jm[r] Cos[phase] +\n  (Cos[al] + Cos[2 phase + al]) (Del/(2 r)) D[r jm[r], r]', ()),
    ('avg', 'Integrate[jphLin /. {th -> s/m, ph -> 0}, {s, 0, 2 Pi},\n    Assumptions -> m != 0]/(2 Pi)', ()),
    ('avgMemo', '(Del Cos[al]/(2 r)) D[r jm[r], r]', ()),
    ('integrand', '2 Pi r avgMemo', ()),
    ('antideriv', 'Pi Del Cos[al] r jm[r]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/01_current_redistribution.wl')

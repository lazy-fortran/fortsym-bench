"""Generated SymPy translation of ``corpus/nc-Shared-analyt_mechanik-2017/ue08.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 1 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('U', '-a/(2*m*r^n)', ()),
    ('Ueff', 'l^2/(2*m*r^2) + U', ()),
    ('dUeffdr', 'D[Ueff, r]', ()),
    ('solr0', 'Flatten[Solve[dUeffdr == 0, r]]', ()),
    ('r0', 'r /. solr0', ()),
    ('beta', 'FullSimplify[(1/2)*D[Ueff, r, r] /. r -> r0]', ()),
    ('deltaphi', 'FullSimplify[Sqrt[2/(m*beta)]*(l/r0^2)*Pi]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-Shared-analyt_mechanik-2017/ue08.wl')

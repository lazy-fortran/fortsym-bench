"""Generated SymPy translation of ``corpus/nc-Shared-analyt_mechanik-2017/ue09.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 0 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Th22S', 'FullSimplify[Integrate[(M/V)*r*(r^2*Cos[ph]^2 + (z - h/4)^2), {r, 0, R}, {z, 0, h*(1 - r/R)}, {ph, 0, 2*Pi}] /. V -> (Pi/3)*R^2*h]', ()),
    ('Th22O', 'FullSimplify[Integrate[(M/V)*r*(r^2*Cos[ph]^2 + z^2), {r, 0, R}, {z, 0, h*(1 - r/R)}, {ph, 0, 2*Pi}] /. V -> (Pi/3)*R^2*h]', ()),
    ('Th22OCheck', 'FullSimplify[Th22S + M*(h/4)^2]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-Shared-analyt_mechanik-2017/ue09.wl')

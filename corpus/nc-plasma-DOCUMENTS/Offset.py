"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/Offset.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('F', '(BesselK[2, mu]*Exp[mu])/mu', ('mu',)),
    ('dF', 'D[F[mu], mu]', ('mu',)),
    ('ddF', 'D[dF[mu], mu]', ('mu',)),
    ('a02', 'FullSimplify[(mu^2*(-((E^mu*BesselK[2, mu])/mu^2) + (E^mu*BesselK[2, mu])/mu + (E^mu*(-BesselK[1, mu] - BesselK[3, mu]))/(2*mu)))/(E^mu*BesselK[2, mu])]', ('mu',)),
    ('a22', 'mu^2*(ddF[mu]/F[mu])', ('mu',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/Offset.wl')

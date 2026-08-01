"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/Perturbations.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('theta', 'ArcTan[R, Z]', ()),
    ('AR', 'aRmn*Exp[I*(m*theta + n*phi)]', ()),
    ('Aphi', 'aphimn*Exp[I*(m*theta + n*phi)]', ()),
    ('AZ', 'aZmn*Exp[I*(m*theta + n*phi)]', ()),
    ('AR', 'AMPL*R*Cos[phi]', ()),
    ('Aphi', '(-2^(-1))*AMPL2*Z*R', ()),
    ('AZ', '-Log[R]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/Perturbations.wl')

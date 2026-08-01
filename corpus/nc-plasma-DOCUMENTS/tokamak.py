"""Generated SymPy translation of ``corpus/nc-plasma-DOCUMENTS/tokamak.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('nutilde', '-((th + 2*ArcTan[((1 - a)*Tan[th/2])/Sqrt[1 - a^2]])/Sqrt[1 - a^2]), Null, Manipulate[Plot[nutilde[th, 1/A], {th, -Pi, Pi}], {{A, 3}, 1.1, 5}]', ('th', 'a')),
    ('phiofth', '-2*ArcTan[((a - 1)*Tan[th/2])/Sqrt[1 - a^2]]', ('th', 'a')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-plasma-DOCUMENTS/tokamak.wl')

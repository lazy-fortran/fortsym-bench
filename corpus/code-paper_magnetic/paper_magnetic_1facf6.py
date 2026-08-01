"""Generated SymPy translation of ``corpus/code-paper_magnetic/paper_magnetic_1facf6.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 5 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Acov', '{A1cov[x1, x2], A2cov[x1, x2], A3cov[x1, x2]}*Exp[I*n*x3]', ()),
    ('jctr', 'Curl3[nucov . Curl3[Acov] /. {n -> 0}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/paper_magnetic_1facf6.wl')

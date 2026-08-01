"""Generated SymPy translation of ``corpus/proj-stellopt-talk/12_rabe_scalings.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 14 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('iA', 'Integrate[Exp[-x^2 nu], {x, 0, Infinity}, Assumptions -> nu > 0]', ()),
    ('iB', 'Integrate[Exp[-x nu], {x, 0, Infinity}, Assumptions -> nu > 0]', ()),
    ('expA', 'Simplify[nu D[iA, nu]/iA, nu > 0]', ()),
    ('expB', 'Simplify[nu D[iB, nu]/iB, nu > 0]', ()),
    ('xstar', 'Simplify[x /. Last[Solve[x^2/nu == 1 && x > 0, x,\n    Assumptions -> nu > 0]], nu > 0]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/12_rabe_scalings.wl')

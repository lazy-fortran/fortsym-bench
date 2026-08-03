"""Generated SymPy translation of ``corpus/archive-tu/math15y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments
import sympy as sp

# NOT TRANSLATED: 4 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('B', 'Transpose[A]', ()),
    ('lst', 'RandomReal[{0, 1}, 10]', ()),
    ('k', 'N[Exp[-60], 20]', ()),
]

def results():
    values = evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math15y.wl')
    # ``A`` is held in the notebook transcript; preserve the source's
    # unevaluated transpose rather than treating the square brackets as a
    # one-element Python list.
    values['B'] = sp.Function('Transpose')(sp.Symbol('A'))
    return values

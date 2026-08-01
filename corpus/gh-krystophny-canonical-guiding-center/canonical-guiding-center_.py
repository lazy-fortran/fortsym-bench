"""Generated SymPy translation of ``corpus/gh-krystophny-canonical-guiding-center/canonical-guiding-center_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('B', 'Simplify[Curl[A[x1, x2, x3], {x1, x2, x3}]]', ()),
    ('e1', 'FullSimplify[Cross[B, {1, 0, 0}]]', ()),
    ('e2', 'FullSimplify[Cross[B, Cross[B, {1, 0, 0}]]]', ()),
    ('B', 'Curl[Bval[x3]*{(-2^(-1))*x2, (1/2)*x1, 0}, {x1, x2, x3}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-krystophny-canonical-guiding-center/canonical-guiding-center_.wl')

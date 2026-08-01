"""Generated SymPy translation of ``corpus/gh-itpplasma-PhilippsLegacy/tearing3_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('F', 'Tanh[μ]', ()),
    ('d2F', 'D[Tanh[μ], {μ, 2}]', ()),
    ('sol', 'DSolve[{Derivative[2][ψ][μ] - ψ[μ]*(α^2 + d2F/F) == 0}, ψ[μ], μ, Assumptions -> α > 0]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-PhilippsLegacy/tearing3_.wl')

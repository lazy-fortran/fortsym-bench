"""Generated SymPy translation of ``corpus/proj-neort-proofs/collisional_sqrt_nu.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('dresDef', 'dpp (dOmdv/Ompr)^2 + dhh eta (Ib - eta) (dOmdeta/Ompr)^2', ()),
    ('dnormDef', 'dresDef Sqrt[Ompr]/Hmn2^(3/4)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/collisional_sqrt_nu.wl')

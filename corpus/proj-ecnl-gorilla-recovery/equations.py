"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/equations.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 68 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('root', 'DirectoryName[DirectoryName[$InputFileName]]', ()),
    ('out', 'FileNameJoin[{root, "report", "generated"}]', ()),
    ('equations', '<|\n  "gamma" -> "\\\\gamma=\\\\left[1+\\\\frac{p_\\\\parallel^2+2m\\\\Omega I}{m^2c^2}\\\\right]^{1/2}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/equations.wl')

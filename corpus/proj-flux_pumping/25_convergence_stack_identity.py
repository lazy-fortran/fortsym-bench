"""Generated SymPy translation of ``corpus/proj-flux_pumping/25_convergence_stack_identity.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('resultPath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",\n    "wp2_neo2", "helical_core_l1", "results", name}]', ('name',)),
    ('paths', 'resultPath /@ {"convergence_18565141.json",\n    "convergence_18565152.json", "convergence_18564639.json",\n    "convergence_18565189.json", "asymptotic_convergence_18565189.json"}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/25_convergence_stack_identity.wl')

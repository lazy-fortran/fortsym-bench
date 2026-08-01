"""Generated SymPy translation of ``corpus/proj-flux_pumping/23_response_error_floor.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('summaryPath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",\n    "wp2_neo2", "helical_core_l1", "results",\n    "asymptotic_convergence_18565063.json"}]', ()),
    ('convergencePath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",\n    "wp2_neo2", "helical_core_l1", "results",\n    "convergence_18565063.json"}]', ()),
    ('summary', 'Import[summaryPath, "RawJSON"]', ()),
    ('convergence', 'Import[convergencePath, "RawJSON"]', ()),
    ('l2Differences', 'summary["fixed_domain_errors"]["relative_l2_difference"]', ()),
    ('l2Orders', 'summary["norms"]["relative_l2"]["observed_order"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/23_response_error_floor.wl')

"""Generated SymPy translation of ``corpus/proj-flux_pumping/24_refinement_cancellation.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('summaryPath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",\n    "wp2_neo2", "helical_core_l1", "results",\n    "refinement_sensitivity_18565126.json"}]', ()),
    ('summary', 'Import[summaryPath, "RawJSON"]', ()),
    ('conditions', 'summary["qflux_cancellation"][[All, "cancellation_condition"]]', ()),
    ('solutionChange', 'summary["assembled_system"]["solution_change"]["relative_l2"]', ()),
    ('gammaChange', 'summary["gamma_relative_change"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/24_refinement_cancellation.wl')

"""Generated SymPy translation of ``corpus/proj-flux_pumping/22_period_return_tie.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 9 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('firstDistance', '6.2831853072124133*10^-2', ()),
    ('numericalTie', '6.2831849552580366*10^-2', ()),
    ('closedReturn', '3.8516034805979871*10^-10', ()),
    ('relativeTieTolerance', '8 Sqrt[2^-52]', ()),
    ('summaryPath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",\n    "wp2_neo2", "helical_core_l1", "results",\n    "asymptotic_convergence_18564920.json"}]', ()),
    ('summary', 'Import[summaryPath, "RawJSON"]', ()),
    ('l2', 'summary["norms"]["relative_l2"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/22_period_return_tie.wl')

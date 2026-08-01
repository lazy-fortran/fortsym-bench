"""Generated SymPy translation of ``corpus/proj-flux_pumping/21_local_response_convergence.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 22 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('qh', 'q0 + cq x^p', ('x',)),
    ('jh', 'cj x^p', ('x',)),
    ('coarseDifference', 'qh[h/2] - qh[h]', ()),
    ('fineDifference', 'qh[h/4] - qh[h/2]', ()),
    ('physicalAccepted', 'screenPassed && profileConverged && forcesApplied &&', ()),
    ('endpointOnly', 'Piecewise[{{traceValue, x == x0}}, 0]', ('x',)),
    ('linear', 'aa + bb x', ('x',)),
    ('summaryPath', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",\n    "wp2_neo2", "helical_core_l1", "results",\n    "profile_convergence_18564705.json"}]', ()),
    ('summary', 'Import[summaryPath, "RawJSON"]', ()),
    ('pairs', 'summary["pair_errors"]', ()),
    ('l2Run', 'Lookup[pairs, "relative_l2"]', ()),
    ('linfRun', 'Lookup[pairs, "relative_linf"]', ()),
    ('coverageRun', 'Lookup[pairs, "compared_coordinate_fraction"]', ()),
    ('expectedOrder', 'Log[2, l2Run[[1]]/l2Run[[2]]]', ()),
    ('gammaN', 'nterm unitRoundoff/(1 - nterm unitRoundoff)', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/21_local_response_convergence.wl')

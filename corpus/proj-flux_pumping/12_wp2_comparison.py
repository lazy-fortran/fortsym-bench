"""Generated SymPy translation of ``corpus/proj-flux_pumping/12_wp2_comparison.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('base', 'FileNameJoin[{DirectoryName[$InputFileName], "..", "runs", "wp2_neo2"}]', ()),
    ('summaryPath', 'FileNameJoin[{base, "results", "summary.csv"}]', ()),
    ('raw', 'Import[summaryPath, "CSV"]', ()),
    ('header', 'First[raw]', ()),
    ('rows', 'Rest[raw]', ()),
    ('col', 'First@FirstPosition[header, name]', ('name',)),
    ('required', '{"case", "nu_factor", "D31_NA_ee", "D32_NA_ee"}', ()),
    ('phiRows', 'Select[rows,\n  StringStartsQ[ToString[#[[col["case"]]]], "phi_nu"] &]', ()),
    ('nuFactors', 'Sort[phiRows[[All, col["nu_factor"]]]]', ()),
    ('row', 'First@Select[rows, #[[col["case"]]] == name &]', ('name',)),
    ('zc', 'row["zc_brad"]', ()),
    ('phi1', 'row["phi_nu1"]', ()),
    ('rotNone', 'row["rot_none"]', ()),
    ('rotAlip', 'row["rot_alip"]', ()),
    ('rotAlim', 'row["rot_alim"]', ()),
    ('d31', 'row[[col["D31_NA_ee"]]]', ('row',)),
    ('scaleCircular', 'dFinal/rawMean', ()),
    ('derived', 'FileNameJoin[{base, "results", "comparison.csv"}]', ()),
    ('profileDir', 'FileNameJoin[{base, "results", "profiles"}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/12_wp2_comparison.wl')

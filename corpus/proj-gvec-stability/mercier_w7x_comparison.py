"""Generated SymPy translation of ``corpus/proj-gvec-stability/mercier_w7x_comparison.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 4 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('scriptDirectory', 'DirectoryName[ExpandFileName[$InputFileName]]', ()),
    ('projectDirectory', 'FileNameJoin[{scriptDirectory, ".."}]', ()),
    ('benchmarkDirectory', 'FileNameJoin[{projectDirectory, "benchmarks"}]', ()),
    ('figureDirectory', 'FileNameJoin[{projectDirectory, "docs", "figures"}]', ()),
    ('readCurve', 'Module[{table},\n  If[! FileExistsQ[path], Return[Missing["NotAvailable"]]];\n  table = Rest[Import[path, "CSV"]];\n  Select[Table[{row[[sColumn]], row[[valueColumn]]}, {row, table}],\n    NumberQ[#[[1]]] && NumberQ[#[[2]]] && #[[1]] > 0.05 &]]', ('path', 'sColumn', 'valueColumn')),
    ('curves', 'DeleteMissing[<|\n  "VMEC (original wout)" -> readCurve[FileNameJoin[{benchmarkDirectory,\n    "vmec", "w7x", "output", "vmec_dmerc_original.csv"}], 1, 6],\n  "DESC" -> readCurve[FileNameJoin[{benchmarkDirectory,\n    "desc", "w7x", "output", "desc_mercier.csv"}], 1, 6],\n  "pygvec" -> readCurve[FileNameJoin[{benchmarkDirectory,\n    "pygvec", "w7x", "output", "pygvec_mercier.csv"}], 1, 2],\n  "GLISS" -> readCurve[FileNameJoin[{benchmarkDirectory,\n    "gliss", "w7x", "output", "mercier_ns64_MN12.csv"}], 1, 6]|>]', ()),
    ('styles', '<|\n  "VMEC (original wout)" -> Directive[Black, Thick],\n  "DESC" -> Directive[RGBColor[0.10, 0.35, 0.70], Thick, Dashed],\n  "pygvec" -> Directive[RGBColor[0.10, 0.45, 0.25], Thick, DotDashed],\n  "GLISS" -> Directive[RGBColor[0.65, 0.20, 0.12], Thick, Dotted]|>', ()),
    ('comparisonPlot', 'ListLinePlot[Values[curves],\n  PlotStyle -> (styles[#] & /@ Keys[curves]),\n  PlotLegends -> Placed[LineLegend[Keys[curves]], Below],\n  Frame -> True,\n  FrameLabel -> {Style["Normalized toroidal flux  s", 12],\n    Style["Mercier criterion  (1/Wb\\.b2)", 12]},\n  PlotRange -> {{0, 1}, {-0.03, 0.08}},\n  GridLines -> {None, {0}},\n  GridLinesStyle -> Directive[GrayLevel[0.4]],\n  ImageSize -> 520,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/mercier_w7x_comparison.wl')

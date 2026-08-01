"""Generated SymPy translation of ``corpus/proj-gvec-stability/newcomb_convergence_figure.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 3 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('scriptDirectory', 'DirectoryName[ExpandFileName[$InputFileName]]', ()),
    ('projectDirectory', 'FileNameJoin[{scriptDirectory, ".."}]', ()),
    ('table', 'Rest[Import[FileNameJoin[{projectDirectory, "validation",\n  "data", "newcomb_cylinder_convergence.csv"}], "CSV"]]', ()),
    ('resonant', 'Select[table, #[[2]] == 1 && #[[3]] == 1 &][[All, {1, 4}]]', ()),
    ('stable', 'Select[table, #[[2]] == 2 && #[[3]] == 1 &][[All, {1, 4}]]', ()),
    ('figure', 'ListLogLinearPlot[{resonant, stable},\n  Joined -> True, PlotMarkers -> {Automatic, 8},\n  PlotStyle -> {Directive[RGBColor[0.65, 0.20, 0.12], Thick],\n    Directive[RGBColor[0.10, 0.35, 0.70], Thick, Dashed]},\n  PlotLegends -> Placed[LineLegend[{"resonant (m,n) = (1,1)",\n    "non-resonant (m,n) = (2,1)"}], Below],\n  Frame -> True,\n  FrameLabel -> {Style["Radial intervals", 12],\n    Style["Artificial stiffness level", 12]},\n  GridLines -> {None, {0}},\n  GridLinesStyle -> Directive[GrayLevel[0.4]],\n  ImageSize -> 480,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/newcomb_convergence_figure.wl')

"""Generated SymPy translation of ``corpus/proj-flux_pumping/32_spectral_maxwell_closure.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 31 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('chi', 'm theta + k z + beta', ()),
    ('jr', '0', ()),
    ('jtheta', '-k r current[r] Cos[chi]/m', ()),
    ('jz', 'current[r] Cos[chi]', ()),
    ('radialOperator', 'D[expr, {r, 2}] + D[expr, r]/r -\n  (m^2/r^2 + k^2) expr', ('expr',)),
    ('residual', "radialOperator[u] - r s'[r] - 2 s[r]", ('u', 's')),
    ('modeData', 'makeMode[#, 0.25] & /@ {1, 2, 3}', ()),
    ('sourcePeaks', 'Max[#[[All, 2]]] & /@ (modeData[[All, "source"]])', ()),
    ('fieldPeaks', 'Max[Abs[#[[All, 2]]]] & /@ (modeData[[All, "field"]])', ()),
    ('styles', '{\n  Directive[Thick, ColorData[97][1]],\n  Directive[Thick, Dashed, ColorData[97][2]],\n  Directive[Thick, DotDashed, ColorData[97][4]]}', ()),
    ('legend', '{"m = 1", "m = 2", "m = 3"}', ()),
    ('sourcePlot', 'ListLinePlot[modeData[[All, "source"]],\n  Frame -> True, FrameLabel -> {"r/a", "normalized current harmonic"},\n  PlotStyle -> styles, PlotLegends -> Placed[legend, {0.76, 0.78}],\n  PlotRange -> All, ImageSize -> 330]', ()),
    ('fieldPlot', 'ListLinePlot[modeData[[All, "field"]],\n  Frame -> True, FrameLabel -> {"r/a", "radial field (normalized units)"},\n  PlotStyle -> styles, PlotLegends -> None, PlotRange -> All,\n  ImageSize -> 330]', ()),
    ('spectralFigure', 'GraphicsRow[{sourcePlot, fieldPlot}, Spacings -> 12,\n  ImageSize -> 700]', ()),
    ('currentScaling', 'detuning^exponent', ()),
    ('fieldScaling', 'fieldScale detuning^exponent', ()),
    ('displacementScaling', 'fieldScaling/detuning', ()),
    ('pullbackScaling', 'currentScaling displacementScaling', ()),
    ('twoSidedFeedback', 'detuning Abs[detuning]^(2 exponent - 2)', ()),
    ('scalingFigure', 'LogLogPlot[\n  Evaluate@Table[d^(p - 1), {p, 0, 2}], {d, 10^-3, 1},\n  Frame -> True,\n  FrameLabel -> {"|D|/Dref", "|Delta|/Delta_ref"},\n  PlotStyle -> styles,\n  PlotLegends -> Placed[{"p = 0: fixed current", "p = 1: finite Delta",\n    "p = 2: Delta proportional to D"}, {0.65, 0.28}],\n  GridLines -> {{}, {1}}, GridLinesStyle -> Directive[Gray, Dotted],\n  PlotRange -> {10^-3, 10^3}, ImageSize -> 470]', ()),
    ('stabilizingMap', 'x + coupling x^3', ()),
    ('reinforcingMap', 'x - coupling x^3', ()),
    ('foldLocation', '1/Sqrt[3 coupling]', ()),
    ('foldDrive', 'FullSimplify[reinforcingMap /. x -> foldLocation,\n  coupling > 0]', ()),
    ('couplingValue', '4.', ()),
    ('closureFigure', 'Show[\n  Plot[\n    Evaluate[{x, x + couplingValue x^3, x - couplingValue x^3}],\n    {x, -0.75, 0.75}, Frame -> True,\n    FrameLabel -> {"response detuning x", "imposed detuning x0"},\n    PlotStyle -> {Directive[Gray, Dashed], styles[[1]], styles[[2]]},\n    PlotLegends -> Placed[{"no feedback", "stabilizing phase",\n      "reinforcing phase"}, {0.25, 0.78}], PlotRange -> {-1.1, 1.1},\n    ImageSize -> 470],\n  Graphics[{Black, PointSize[0.016],\n    Point[{{foldLocation /. coupling -> couplingValue,\n        foldDrive /. coupling -> couplingValue},\n      {-foldLocation /. coupling -> couplingValue,\n        -foldDrive /. coupling -> couplingValue}}]}]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/32_spectral_maxwell_closure.wl')

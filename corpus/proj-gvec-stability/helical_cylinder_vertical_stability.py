"""Generated SymPy translation of ``corpus/proj-gvec-stability/helical_cylinder_vertical_stability.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('passed', '0', ()),
    ('failed', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  passed++; Print["PASS: ", name], failed++; Print["FAIL: ", name]]', ('name', 'condition')),
    ('$Assumptions', 'kappa >= 1 && psi0 > 0 && volume > 0 &&', ()),
    ('psiCurrent', '(1 - externalFraction) psi0', ()),
    ('energyPrefactor', '2 volume displacement^2/b^4', ()),
    ('energyBracket', '(1 + kappa) psi0^2 -\n  (kappa^2 + 1) psiCurrent psi0', ()),
    ('energy', 'energyPrefactor energyBracket', ()),
    ('criticalFraction', '(kappa^2 - kappa)/(kappa^2 + 1)', ()),
    ('projectDirectory', 'DirectoryName[DirectoryName[$InputFileName]]', ()),
    ('figureDirectory', 'FileNameJoin[{projectDirectory, "docs", "figures"}]', ()),
    ('boundaryPoints', 'Table[\n  {x, (x^2 - x)/(x^2 + 1)}, {x, 1, 5, 0.02}]', ()),
    ('figure', 'Graphics[{\n    {RGBColor[0.76, 0.86, 0.72],\n     Polygon[Join[boundaryPoints, {{5, 1}, {1, 1}}]]},\n    {RGBColor[0.88, 0.68, 0.65],\n     Polygon[Join[{{1, 0}, {5, 0}}, Reverse[boundaryPoints]]]},\n    {Black, Thick, Line[boundaryPoints]},\n    {Black, PointSize[0.018], Point[{2, 2/5}]},\n    Text[Style["stable", 14, Bold], {4.1, 0.88}],\n    Text[Style["unstable", 14, Bold], {4.1, 0.45}],\n    Text[Style["(2, 0.4)", 12], {2.35, 0.35}]},\n  PlotRange -> {{1, 5}, {0, 1}}, Frame -> True, Axes -> False,\n  FrameLabel -> {Style["elongation  κ", 14],\n    Style["external-transform fraction  f", 14]},\n  BaseStyle -> {FontFamily -> "Helvetica", 12}, ImageSize -> 520,\n  AspectRatio -> 0.62, PlotRangePadding -> None]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/helical_cylinder_vertical_stability.wl')

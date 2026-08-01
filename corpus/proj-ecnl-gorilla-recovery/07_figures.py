"""Generated SymPy translation of ``corpus/proj-ecnl-gorilla-recovery/07_figures.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 12 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('root', 'DirectoryName[DirectoryName[$InputFileName]]', ()),
    ('out', 'FileNameJoin[{root, "report", "figures"}]', ()),
    ('colors', '{RGBColor[0.0, 0.45, 0.70], RGBColor[0.90, 0.62, 0.0],\n  RGBColor[0.0, 0.62, 0.45], RGBColor[0.80, 0.47, 0.65]}', ()),
    ('regime', 'Legended[\n  Graphics[{\n    {colors[[1]], Rectangle[{-2, -2}, {-0.5, 2}]},\n    {colors[[2]], Rectangle[{-0.5, -2}, {0.5, 2}]},\n    {colors[[3]], Rectangle[{0.5, -2}, {2, 0}]},\n    {colors[[4]], Rectangle[{0.5, 0}, {2, 2}]},\n    {Black, Dashed, Line[{{-0.5, -2}, {-0.5, 2}}],\n      Line[{{0.5, -2}, {0.5, 2}}], Line[{{0.5, 0}, {2, 0}}]}},\n    Frame -> True, FrameLabel -> {"log10(chi) = log10(omega_b tau_b)",\n      "log10(q_c) = log10(nu_c tau_b)"},\n    FrameTicks -> {{{-2, -1, 0, 1, 2}, None}, {{-2, -1, 0, 1, 2}, None}},\n    PlotRange -> {{-2, 2}, {-2, 2}}, ImageSize -> 470,\n    BaseStyle -> {FontFamily -> "Latin Modern Roman", 12}],\n  Placed[SwatchLegend[colors,\n    {"linear / QL", "finite crossing", "adiabatic", "collision interrupted"}], Below]]', ()),
    ('resonance', 'ContourPlot[\n  Sqrt[1 + (vpar^2 + vperp^2)/9] - 0.70 vpar - 1.18,\n  {vpar, -3, 3}, {vperp, 0, 3}, Contours -> {0},\n  ContourStyle -> Directive[colors[[1]], Thick],\n  FrameLabel -> {"v_parallel / v_T", "v_perp / v_T"},\n  Epilog -> {Directive[colors[[2]], Thick], Arrow[{{0.45, 1.25}, {0.85, 1.75}}],\n    Text[Style["finite RF kick", 12], {1.25, 1.85}],\n    Directive[GrayLevel[0.3], Dashed], Line[{{-0.8, 0}, {-0.8, 3}}],\n    Text[Style["trapped-passing boundary", 10], {-1.45, 2.65}]},\n  PlotRange -> All, ImageSize -> 430,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 12}]', ()),
    ('nodes', '<|"wave / beam" -> {0, 2}', ()),
    ('box', 'Inset[\n  Framed[Style[label, 10, FontFamily -> "Latin Modern Roman"],\n    Background -> White, FrameStyle -> Directive[colors[[1]], Thick],\n    RoundingRadius -> 4, FrameMargins -> {{7, 7}, {5, 5}}], nodes[label]]', ('label',)),
    ('flow', 'Graphics[{\n   Directive[GrayLevel[0.25], Thick, Arrowheads[0.025]],\n   Arrow[{nodes["wave / beam"] + {0.68, 0}, nodes["RF crossing kernel"] - {0.78, 0}}],\n   Arrow[{nodes["RF crossing kernel"] + {0.78, 0}, nodes["GORILLA orbit"] - {0.68, 0}}],\n   Arrow[{nodes["GORILLA orbit"] + {0, -0.28}, nodes["collisions"] + {0, 0.28}}],\n   Arrow[{nodes["collisions"] + {0.18, 0.28}, nodes["GORILLA orbit"] + {0.18, -0.28}}],\n   Arrow[{nodes["GORILLA orbit"] + {0.68, -0.08}, nodes["delta f"] - {0.55, -0.30}}],\n   Arrow[{nodes["collisions"] + {0.68, 0.08}, nodes["delta f"] - {0.55, 0.30}}],\n   Arrow[{nodes["delta f"] + {0.55, 0}, nodes["power, current, torque"] - {0.95, 0}}],\n   Map[box, Keys[nodes]]}, PlotRange -> {{-0.9, 10.1}, {0, 2.5}},\n  ImagePadding -> 20, ImageSize -> 650, Background -> White]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-ecnl-gorilla-recovery/07_figures.wl')

root = DirectoryName[DirectoryName[$InputFileName]];
out = FileNameJoin[{root, "report", "figures"}];
If[!DirectoryQ[out], CreateDirectory[out, CreateIntermediateDirectories -> True]];

colors = {RGBColor[0.0, 0.45, 0.70], RGBColor[0.90, 0.62, 0.0],
  RGBColor[0.0, 0.62, 0.45], RGBColor[0.80, 0.47, 0.65]};

regime = Legended[
  Graphics[{
    {colors[[1]], Rectangle[{-2, -2}, {-0.5, 2}]},
    {colors[[2]], Rectangle[{-0.5, -2}, {0.5, 2}]},
    {colors[[3]], Rectangle[{0.5, -2}, {2, 0}]},
    {colors[[4]], Rectangle[{0.5, 0}, {2, 2}]},
    {Black, Dashed, Line[{{-0.5, -2}, {-0.5, 2}}],
      Line[{{0.5, -2}, {0.5, 2}}], Line[{{0.5, 0}, {2, 0}}]}},
    Frame -> True, FrameLabel -> {"log10(chi) = log10(omega_b tau_b)",
      "log10(q_c) = log10(nu_c tau_b)"},
    FrameTicks -> {{{-2, -1, 0, 1, 2}, None}, {{-2, -1, 0, 1, 2}, None}},
    PlotRange -> {{-2, 2}, {-2, 2}}, ImageSize -> 470,
    BaseStyle -> {FontFamily -> "Latin Modern Roman", 12}],
  Placed[SwatchLegend[colors,
    {"linear / QL", "finite crossing", "adiabatic", "collision interrupted"}], Below]];
Export[FileNameJoin[{out, "regime_map.pdf"}], regime];

resonance = ContourPlot[
  Sqrt[1 + (vpar^2 + vperp^2)/9] - 0.70 vpar - 1.18,
  {vpar, -3, 3}, {vperp, 0, 3}, Contours -> {0},
  ContourStyle -> Directive[colors[[1]], Thick],
  FrameLabel -> {"v_parallel / v_T", "v_perp / v_T"},
  Epilog -> {Directive[colors[[2]], Thick], Arrow[{{0.45, 1.25}, {0.85, 1.75}}],
    Text[Style["finite RF kick", 12], {1.25, 1.85}],
    Directive[GrayLevel[0.3], Dashed], Line[{{-0.8, 0}, {-0.8, 3}}],
    Text[Style["trapped-passing boundary", 10], {-1.45, 2.65}]},
  PlotRange -> All, ImageSize -> 430,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 12}];
Export[FileNameJoin[{out, "resonance_geometry.pdf"}], resonance];

nodes = <|"wave / beam" -> {0, 2}, "RF crossing kernel" -> {2.2, 2},
  "GORILLA orbit" -> {4.6, 2}, "collisions" -> {4.6, 0.5},
  "delta f" -> {6.8, 1.25}, "power, current, torque" -> {9.0, 1.25}|>;
box[label_] := Inset[
  Framed[Style[label, 10, FontFamily -> "Latin Modern Roman"],
    Background -> White, FrameStyle -> Directive[colors[[1]], Thick],
    RoundingRadius -> 4, FrameMargins -> {{7, 7}, {5, 5}}], nodes[label]];
flow = Graphics[{
   Directive[GrayLevel[0.25], Thick, Arrowheads[0.025]],
   Arrow[{nodes["wave / beam"] + {0.68, 0}, nodes["RF crossing kernel"] - {0.78, 0}}],
   Arrow[{nodes["RF crossing kernel"] + {0.78, 0}, nodes["GORILLA orbit"] - {0.68, 0}}],
   Arrow[{nodes["GORILLA orbit"] + {0, -0.28}, nodes["collisions"] + {0, 0.28}}],
   Arrow[{nodes["collisions"] + {0.18, 0.28}, nodes["GORILLA orbit"] + {0.18, -0.28}}],
   Arrow[{nodes["GORILLA orbit"] + {0.68, -0.08}, nodes["delta f"] - {0.55, -0.30}}],
   Arrow[{nodes["collisions"] + {0.68, 0.08}, nodes["delta f"] - {0.55, 0.30}}],
   Arrow[{nodes["delta f"] + {0.55, 0}, nodes["power, current, torque"] - {0.95, 0}}],
   Map[box, Keys[nodes]]}, PlotRange -> {{-0.9, 10.1}, {0, 2.5}},
  ImagePadding -> 20, ImageSize -> 650, Background -> White];
Export[FileNameJoin[{out, "operator_flow.pdf"}], flow];

Print["WROTE FIGURES TO ", out];

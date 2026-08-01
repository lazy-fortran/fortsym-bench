scriptDirectory = DirectoryName[ExpandFileName[$InputFileName]];
projectDirectory = FileNameJoin[{scriptDirectory, ".."}];
benchmarkDirectory = FileNameJoin[{projectDirectory, "benchmarks"}];
figureDirectory = FileNameJoin[{projectDirectory, "docs", "figures"}];

readCurve[path_, sColumn_, valueColumn_] := Module[{table},
  If[! FileExistsQ[path], Return[Missing["NotAvailable"]]];
  table = Rest[Import[path, "CSV"]];
  Select[Table[{row[[sColumn]], row[[valueColumn]]}, {row, table}],
    NumberQ[#[[1]]] && NumberQ[#[[2]]] && #[[1]] > 0.05 &]];

curves = DeleteMissing[<|
  "VMEC (original wout)" -> readCurve[FileNameJoin[{benchmarkDirectory,
    "vmec", "w7x", "output", "vmec_dmerc_original.csv"}], 1, 6],
  "DESC" -> readCurve[FileNameJoin[{benchmarkDirectory,
    "desc", "w7x", "output", "desc_mercier.csv"}], 1, 6],
  "pygvec" -> readCurve[FileNameJoin[{benchmarkDirectory,
    "pygvec", "w7x", "output", "pygvec_mercier.csv"}], 1, 2],
  "GLISS" -> readCurve[FileNameJoin[{benchmarkDirectory,
    "gliss", "w7x", "output", "mercier_ns64_MN12.csv"}], 1, 6]|>];
Print["curves: ", Keys[curves]];

styles = <|
  "VMEC (original wout)" -> Directive[Black, Thick],
  "DESC" -> Directive[RGBColor[0.10, 0.35, 0.70], Thick, Dashed],
  "pygvec" -> Directive[RGBColor[0.10, 0.45, 0.25], Thick, DotDashed],
  "GLISS" -> Directive[RGBColor[0.65, 0.20, 0.12], Thick, Dotted]|>;

comparisonPlot = ListLinePlot[Values[curves],
  PlotStyle -> (styles[#] & /@ Keys[curves]),
  PlotLegends -> Placed[LineLegend[Keys[curves]], Below],
  Frame -> True,
  FrameLabel -> {Style["Normalized toroidal flux  s", 12],
    Style["Mercier criterion  (1/Wb\.b2)", 12]},
  PlotRange -> {{0, 1}, {-0.03, 0.08}},
  GridLines -> {None, {0}},
  GridLinesStyle -> Directive[GrayLevel[0.4]],
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}];
Export[FileNameJoin[{figureDirectory, "mercier_w7x_comparison.pdf"}],
  comparisonPlot];
Print["exported figure with ", Length[curves], " curves"];
Quit[0];

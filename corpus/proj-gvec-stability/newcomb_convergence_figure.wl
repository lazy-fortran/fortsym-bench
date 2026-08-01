scriptDirectory = DirectoryName[ExpandFileName[$InputFileName]];
projectDirectory = FileNameJoin[{scriptDirectory, ".."}];
table = Rest[Import[FileNameJoin[{projectDirectory, "validation",
  "data", "newcomb_cylinder_convergence.csv"}], "CSV"]];
resonant = Select[table, #[[2]] == 1 && #[[3]] == 1 &][[All, {1, 4}]];
stable = Select[table, #[[2]] == 2 && #[[3]] == 1 &][[All, {1, 4}]];
figure = ListLogLinearPlot[{resonant, stable},
  Joined -> True, PlotMarkers -> {Automatic, 8},
  PlotStyle -> {Directive[RGBColor[0.65, 0.20, 0.12], Thick],
    Directive[RGBColor[0.10, 0.35, 0.70], Thick, Dashed]},
  PlotLegends -> Placed[LineLegend[{"resonant (m,n) = (1,1)",
    "non-resonant (m,n) = (2,1)"}], Below],
  Frame -> True,
  FrameLabel -> {Style["Radial intervals", 12],
    Style["Artificial stiffness level", 12]},
  GridLines -> {None, {0}},
  GridLinesStyle -> Directive[GrayLevel[0.4]],
  ImageSize -> 480,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}];
Export[FileNameJoin[{projectDirectory, "docs", "figures",
  "newcomb_cylinder_convergence.pdf"}], figure];
Print["exported"];
Quit[0];

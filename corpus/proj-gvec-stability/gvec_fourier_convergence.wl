scriptDirectory = DirectoryName[ExpandFileName[$InputFileName]];
Get[FileNameJoin[{scriptDirectory, "validation_helpers.wl"}]];
projectDirectory = FileNameJoin[{scriptDirectory, ".."}];
dataFile = FileNameJoin[{
    projectDirectory, "validation", "data", "gvec_fourier_convergence.csv"}];
figureDirectory = FileNameJoin[{projectDirectory, "docs", "figures"}];
generatedDirectory = FileNameJoin[{projectDirectory, "docs", "generated"}];

pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

table = Import[dataFile, "CSV"];
header = First[table];
rows = Rest[table];
truncations = {2, 4, 6, 8, 10, 12, 16, 20, 24, 32, 40, 48};
fields = {
  "mod_B", "xhat", "yhat", "zhat", "Jac", "g_tt", "g_tz", "g_zz",
  "II_tt", "II_tz", "II_zz", "B_contra_t", "B_contra_z"};
acceptanceTolerance = 10^-3;

check["CSV schema",
  header == {
    "truncation", "field", "max_absolute_error", "max_relative_error",
    "max_absolute_theta_derivative_error",
    "max_relative_theta_derivative_error",
    "max_absolute_zeta_derivative_error",
    "max_relative_zeta_derivative_error"}];
check["complete truncation grid",
  Sort[DeleteDuplicates[rows[[All, 1]]]] == truncations];
check["complete field set",
  Sort[DeleteDuplicates[rows[[All, 2]]]] == Sort[fields]];
check["one row per field and truncation",
  Length[rows] == Length[truncations] Length[fields]];
check["positive finite errors",
  And @@ Flatten[Map[0 < # < Infinity &, rows[[All, 3 ;; 8]], {2}]]];

fieldData[field_] := SortBy[
  Cases[rows, row_ /; row[[2]] == field :> {row[[1]], row[[4]]}],
  First];
check["fieldwise strict convergence",
  And @@ Table[
    With[{errors = fieldData[field][[All, 2]]},
      And @@ Thread[Rest[errors] < Most[errors]]],
    {field, fields}]];

finalRows = Select[rows, First[#] == Last[truncations] &];
worstRow = First[MaximalBy[finalRows, #[[4]] &]];
check["all fields meet acceptance tolerance",
  Max[finalRows[[All, 4]]] < acceptanceTolerance];

groups = {
  {"geometry and |B|", {"mod_B", "xhat", "yhat", "zhat"}},
  {"metric and Jacobian", {"Jac", "g_tt", "g_tz", "g_zz"}},
  {"second fundamental form", {"II_tt", "II_tz", "II_zz"}},
  {"contravariant B", {"B_contra_t", "B_contra_z"}}};
groupData[groupFields_] := Table[
  {truncation, Max[
    Select[rows, First[#] == truncation &&
        MemberQ[groupFields, #[[2]]] &][[All, 4]]]},
  {truncation, truncations}];
plotData = groupData /@ groups[[All, 2]];
acceptanceData = Transpose[{
    truncations, ConstantArray[acceptanceTolerance, Length[truncations]]}];

convergencePlot = ListLogPlot[
  Append[plotData, acceptanceData],
  Frame -> True,
  FrameLabel -> {
    Style["Fourier truncation  M = N", 12],
    Style["Maximum relative reconstruction error", 12]},
  PlotStyle -> {
    Directive[RGBColor[0.10, 0.35, 0.70], Thick],
    Directive[Black, Thick, Dashed],
    Directive[RGBColor[0.65, 0.20, 0.12], Thick, DotDashed],
    Directive[RGBColor[0.10, 0.45, 0.25], Thick, Dotted],
    Directive[GrayLevel[0.45], Thin, Dashed]},
  Joined -> True,
  PlotMarkers -> {
    {Automatic, 7}, {Automatic, 7}, {Automatic, 7}, {Automatic, 7}, None},
  PlotLegends -> Placed[
    LineLegend[Append[
      groups[[All, 1]], Row[{"acceptance  ", Superscript["10", "-3"]}]]],
    Below],
  PlotRange -> {{2, 48}, {10^-7, 1}},
  FrameTicks -> {{
    Table[{10^exponent, Superscript["10", ToString[exponent]]},
      {exponent, -7, 0}], None}, {Automatic, None}},
  GridLines -> {None, {acceptanceTolerance}},
  GridLinesStyle -> Directive[GrayLevel[0.65], Dashed],
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}];
Export[
  FileNameJoin[{figureDirectory, "gvec_fourier_convergence.pdf"}],
  convergencePlot];

fieldTeX = <|
  "II_tz" -> "\\mathrm{II}_{\\vartheta\\zeta}",
  "II_tt" -> "\\mathrm{II}_{\\vartheta\\vartheta}",
  "II_zz" -> "\\mathrm{II}_{\\zeta\\zeta}"|>;
worstFieldTeX = Lookup[fieldTeX, worstRow[[2]], "\\texttt{" <>
    StringReplace[worstRow[[2]], "_" -> "\\_"] <> "}"];
numberText = StringRiffle[{
  "\\newcommand{\\GVECFourierHighestTruncation}{" <>
    ToString[Last[truncations]] <> "}",
  "\\newcommand{\\GVECFourierAcceptanceTolerance}{" <>
    scientificTeX[acceptanceTolerance, 2] <> "}",
  "\\newcommand{\\GVECFourierWorstField}{" <> worstFieldTeX <> "}",
  "\\newcommand{\\GVECFourierWorstRelativeError}{" <>
    scientificTeX[worstRow[[4]], 4] <> "}",
  "\\newcommand{\\GVECFourierPointCount}{" <>
    ToString[4 Last[truncations] + 1] <> "}"}, "\n"];
Export[
  FileNameJoin[{
    generatedDirectory, "gvec_fourier_convergence_numbers.tex"}],
  numberText, "Text"];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

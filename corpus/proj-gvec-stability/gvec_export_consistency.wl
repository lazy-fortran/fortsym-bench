scriptDirectory = DirectoryName[ExpandFileName[$InputFileName]];
Get[FileNameJoin[{scriptDirectory, "validation_helpers.wl"}]];
projectDirectory = FileNameJoin[{scriptDirectory, ".."}];
dataDirectory = FileNameJoin[{projectDirectory, "validation", "data"}];
figureDirectory = FileNameJoin[{projectDirectory, "docs", "figures"}];
generatedDirectory = FileNameJoin[{projectDirectory, "docs", "generated"}];

pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

nodes = Range[-3, 3];
unknownWeights = Array[weight, Length[nodes]];
nodePower[node_, power_] := If[power == 0, 1, node^power];
weightRules = First[Solve[
  Table[Sum[unknownWeights[[index]] nodePower[nodes[[index]], power],
      {index, Length[nodes]}] == If[power == 1, 1, 0],
    {power, 0, 6}], unknownWeights]];
stencilWeights = unknownWeights /. weightRules;
check["sixth-order centered derivative weights",
  stencilWeights == {-1/60, 3/20, -3/4, 0, 3/4, -3/20, 1/60}];
check["sixth-order derivative moments",
  Table[Sum[stencilWeights[[index]] nodePower[nodes[[index]], power],
      {index, Length[nodes]}], {power, 0, 6}] == {0, 1, 0, 0, 0, 0, 0}];

majorRadius[theta_, phi_] :=
  4 + Cos[theta] + 2/5 Cos[theta - 2 phi];
verticalPosition[theta_, phi_] :=
  Sin[theta] - 2/5 Sin[theta - 2 phi];
analyticVolume = FullSimplify[
  1/2 Integrate[
    majorRadius[theta, phi]^2 D[verticalPosition[theta, phi], theta],
    {theta, 0, 2 Pi}, {phi, 0, 2 Pi}]];
check["ELLIPSTELL analytical boundary volume",
  analyticVolume == 168 Pi^2/25];

fourierTable = Import[
  FileNameJoin[{dataDirectory, "gvec_fourier_convergence.csv"}], "CSV"];
fourierHeader = First[fourierTable];
fourierRows = Rest[fourierTable];
truncations = {2, 4, 6, 8, 10, 12, 16, 20, 24, 32, 40, 48};
groups = {
  {"geometry and |B|", {"mod_B", "xhat", "yhat", "zhat"}},
  {"metric and Jacobian", {"Jac", "g_tt", "g_tz", "g_zz"}},
  {"second fundamental form", {"II_tt", "II_tz", "II_zz"}},
  {"contravariant B", {"B_contra_t", "B_contra_z"}}};
derivativeTolerance = 10^-2;

check["derivative CSV schema", fourierHeader == {
  "truncation", "field", "max_absolute_error", "max_relative_error",
  "max_absolute_theta_derivative_error",
  "max_relative_theta_derivative_error",
  "max_absolute_zeta_derivative_error",
  "max_relative_zeta_derivative_error"}];
derivativeGroupData[groupFields_] := Table[
  {truncation, Max[Flatten[
    Select[fourierRows, First[#] == truncation &&
        MemberQ[groupFields, #[[2]]] &][[All, {6, 8}]]]]},
  {truncation, truncations}];
derivativePlotData = derivativeGroupData /@ groups[[All, 2]];
check["asymptotic derivative convergence",
  And @@ Table[
    With[{errors = Select[data, First[#] >= 6 &][[All, 2]]},
      And @@ Thread[Rest[errors] < Most[errors]]],
    {data, derivativePlotData}]];
finalDerivativeRows = Select[fourierRows, First[#] == Last[truncations] &];
finalDerivativeCandidates = Flatten[Table[
  {{row[[2]], "theta", row[[6]]}, {row[[2]], "zeta", row[[8]]}},
  {row, finalDerivativeRows}], 1];
worstDerivative = First[MaximalBy[finalDerivativeCandidates, Last]];
check["all first derivatives meet acceptance tolerance",
  worstDerivative[[3]] < derivativeTolerance];

volumeTable = Import[
  FileNameJoin[{dataDirectory, "gvec_volume_convergence.csv"}], "CSV"];
volumeHeader = First[volumeTable];
volumeRows = Rest[volumeTable];
check["volume CSV schema", volumeHeader == {
  "truncation", "signed_one_period_volume", "full_device_volume",
  "reference_volume", "relative_error"}];
check["left-handed signed volumes", And @@ Thread[volumeRows[[All, 2]] < 0]];
check["field-period volume relation",
  Max[Abs[volumeRows[[All, 3]] + 2 volumeRows[[All, 2]]]] < 10^-12];
volumeErrors = volumeRows[[All, 5]];
check["volume convergence before roundoff plateau",
  And @@ Thread[Rest[Take[volumeErrors, 8]] < Most[Take[volumeErrors, 8]]]];
check["full-device volume meets acceptance tolerance",
  Last[volumeErrors] < 10^-12];
check["state volume matches analytical boundary volume",
  Abs[Last[volumeRows][[4]] - N[analyticVolume]]/N[analyticVolume] < 10^-14];

acceptanceData = Transpose[{
  truncations, ConstantArray[derivativeTolerance, Length[truncations]]}];
derivativePlot = ListLogPlot[
  Append[derivativePlotData, acceptanceData],
  Frame -> True,
  FrameLabel -> {
    Style["Fourier truncation  M = N", 12],
    Style["Maximum relative first-derivative error", 12]},
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
      groups[[All, 1]], Row[{"acceptance  ", Superscript["10", "-2"]}]]],
    Below],
  PlotRange -> {{2, 48}, {10^-5, 2}},
  FrameTicks -> {{
    Table[{10^exponent, Superscript["10", ToString[exponent]]},
      {exponent, -5, 0}], None}, {Automatic, None}},
  GridLines -> {None, {derivativeTolerance}},
  GridLinesStyle -> Directive[GrayLevel[0.65], Dashed],
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}];
Export[FileNameJoin[{
    figureDirectory, "gvec_derivative_convergence.pdf"}], derivativePlot];

fieldTeX = <|
  "II_tz" -> "\\mathrm{II}_{\\vartheta\\zeta}",
  "II_tt" -> "\\mathrm{II}_{\\vartheta\\vartheta}",
  "II_zz" -> "\\mathrm{II}_{\\zeta\\zeta}"|>;
worstFieldTeX = Lookup[fieldTeX, worstDerivative[[1]], "\\texttt{" <>
    StringReplace[worstDerivative[[1]], "_" -> "\\_"] <> "}"];
directionTeX = If[worstDerivative[[2]] == "theta", "\\vartheta",
  "\\zeta_{\\mathrm{per}}"];
finalVolume = Last[volumeRows];
numberText = StringRiffle[{
  "\\newcommand{\\GVECDerivativeAcceptanceTolerance}{" <>
    scientificTeX[derivativeTolerance, 2] <> "}",
  "\\newcommand{\\GVECDerivativeWorstField}{" <> worstFieldTeX <> "}",
  "\\newcommand{\\GVECDerivativeWorstDirection}{" <> directionTeX <> "}",
  "\\newcommand{\\GVECDerivativeWorstRelativeError}{" <>
    scientificTeX[worstDerivative[[3]], 4] <> "}",
  "\\newcommand{\\GVECSignedPeriodVolume}{" <>
    scientificTeX[finalVolume[[2]], 8] <> "}",
  "\\newcommand{\\GVECReferenceVolume}{" <>
    scientificTeX[finalVolume[[4]], 8] <> "}",
  "\\newcommand{\\GVECVolumeRelativeError}{" <>
    scientificTeX[finalVolume[[5]], 4] <> "}"}, "\n"];
Export[FileNameJoin[{
    generatedDirectory, "gvec_export_consistency_numbers.tex"}],
  numberText, "Text"];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

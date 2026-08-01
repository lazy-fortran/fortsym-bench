"""Generated SymPy translation of ``corpus/proj-gvec-stability/gvec_export_consistency.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('scriptDirectory', 'DirectoryName[ExpandFileName[$InputFileName]]', ()),
    ('projectDirectory', 'FileNameJoin[{scriptDirectory, ".."}]', ()),
    ('dataDirectory', 'FileNameJoin[{projectDirectory, "validation", "data"}]', ()),
    ('figureDirectory', 'FileNameJoin[{projectDirectory, "docs", "figures"}]', ()),
    ('generatedDirectory', 'FileNameJoin[{projectDirectory, "docs", "generated"}]', ()),
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[condition],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('nodes', 'Range[-3, 3]', ()),
    ('unknownWeights', 'Array[weight, Length[nodes]]', ()),
    ('nodePower', 'If[power == 0, 1, node^power]', ('node', 'power')),
    ('weightRules', 'First[Solve[\n  Table[Sum[unknownWeights[[index]] nodePower[nodes[[index]], power],\n      {index, Length[nodes]}] == If[power == 1, 1, 0],\n    {power, 0, 6}], unknownWeights]]', ()),
    ('stencilWeights', 'unknownWeights /. weightRules', ()),
    ('majorRadius', '4 + Cos[theta] + 2/5 Cos[theta - 2 phi]', ('theta', 'phi')),
    ('verticalPosition', 'Sin[theta] - 2/5 Sin[theta - 2 phi]', ('theta', 'phi')),
    ('analyticVolume', 'FullSimplify[\n  1/2 Integrate[\n    majorRadius[theta, phi]^2 D[verticalPosition[theta, phi], theta],\n    {theta, 0, 2 Pi}, {phi, 0, 2 Pi}]]', ()),
    ('fourierTable', 'Import[\n  FileNameJoin[{dataDirectory, "gvec_fourier_convergence.csv"}], "CSV"]', ()),
    ('fourierHeader', 'First[fourierTable]', ()),
    ('fourierRows', 'Rest[fourierTable]', ()),
    ('truncations', '{2, 4, 6, 8, 10, 12, 16, 20, 24, 32, 40, 48}', ()),
    ('groups', '{\n  {"geometry and |B|", {"mod_B", "xhat", "yhat", "zhat"}},\n  {"metric and Jacobian", {"Jac", "g_tt", "g_tz", "g_zz"}},\n  {"second fundamental form", {"II_tt", "II_tz", "II_zz"}},\n  {"contravariant B", {"B_contra_t", "B_contra_z"}}}', ()),
    ('derivativeTolerance', '10^-2', ()),
    ('derivativeGroupData', 'Table[\n  {truncation, Max[Flatten[\n    Select[fourierRows, First[#] == truncation &&\n        MemberQ[groupFields, #[[2]]] &][[All, {6, 8}]]]]},\n  {truncation, truncations}]', ('groupFields',)),
    ('derivativePlotData', 'derivativeGroupData /@ groups[[All, 2]]', ()),
    ('finalDerivativeRows', 'Select[fourierRows, First[#] == Last[truncations] &]', ()),
    ('finalDerivativeCandidates', 'Flatten[Table[\n  {{row[[2]], "theta", row[[6]]}, {row[[2]], "zeta", row[[8]]}},\n  {row, finalDerivativeRows}], 1]', ()),
    ('worstDerivative', 'First[MaximalBy[finalDerivativeCandidates, Last]]', ()),
    ('volumeTable', 'Import[\n  FileNameJoin[{dataDirectory, "gvec_volume_convergence.csv"}], "CSV"]', ()),
    ('volumeHeader', 'First[volumeTable]', ()),
    ('volumeRows', 'Rest[volumeTable]', ()),
    ('volumeErrors', 'volumeRows[[All, 5]]', ()),
    ('acceptanceData', 'Transpose[{\n  truncations, ConstantArray[derivativeTolerance, Length[truncations]]}]', ()),
    ('derivativePlot', 'ListLogPlot[\n  Append[derivativePlotData, acceptanceData],\n  Frame -> True,\n  FrameLabel -> {\n    Style["Fourier truncation  M = N", 12],\n    Style["Maximum relative first-derivative error", 12]},\n  PlotStyle -> {\n    Directive[RGBColor[0.10, 0.35, 0.70], Thick],\n    Directive[Black, Thick, Dashed],\n    Directive[RGBColor[0.65, 0.20, 0.12], Thick, DotDashed],\n    Directive[RGBColor[0.10, 0.45, 0.25], Thick, Dotted],\n    Directive[GrayLevel[0.45], Thin, Dashed]},\n  Joined -> True,\n  PlotMarkers -> {\n    {Automatic, 7}, {Automatic, 7}, {Automatic, 7}, {Automatic, 7}, None},\n  PlotLegends -> Placed[\n    LineLegend[Append[\n      groups[[All, 1]], Row[{"acceptance  ", Superscript["10", "-2"]}]]],\n    Below],\n  PlotRange -> {{2, 48}, {10^-5, 2}},\n  FrameTicks -> {{\n    Table[{10^exponent, Superscript["10", ToString[exponent]]},\n      {exponent, -5, 0}], None}, {Automatic, None}},\n  GridLines -> {None, {derivativeTolerance}},\n  GridLinesStyle -> Directive[GrayLevel[0.65], Dashed],\n  ImageSize -> 520,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}]', ()),
    ('fieldTeX', '<|\n  "II_tz" -> "\\\\mathrm{II}_{\\\\vartheta\\\\zeta}",\n  "II_tt" -> "\\\\mathrm{II}_{\\\\vartheta\\\\vartheta}",\n  "II_zz" -> "\\\\mathrm{II}_{\\\\zeta\\\\zeta}"|>', ()),
    ('worstFieldTeX', 'Lookup[fieldTeX, worstDerivative[[1]], "\\\\texttt{" <>\n    StringReplace[worstDerivative[[1]], "_" -> "\\\\_"] <> "}"]', ()),
    ('directionTeX', 'If[worstDerivative[[2]] == "theta", "\\\\vartheta",\n  "\\\\zeta_{\\\\mathrm{per}}"]', ()),
    ('finalVolume', 'Last[volumeRows]', ()),
    ('numberText', 'StringRiffle[{\n  "\\\\newcommand{\\\\GVECDerivativeAcceptanceTolerance}{" <>\n    scientificTeX[derivativeTolerance, 2] <> "}",\n  "\\\\newcommand{\\\\GVECDerivativeWorstField}{" <> worstFieldTeX <> "}",\n  "\\\\newcommand{\\\\GVECDerivativeWorstDirection}{" <> directionTeX <> "}",\n  "\\\\newcommand{\\\\GVECDerivativeWorstRelativeError}{" <>\n    scientificTeX[worstDerivative[[3]], 4] <> "}",\n  "\\\\newcommand{\\\\GVECSignedPeriodVolume}{" <>\n    scientificTeX[finalVolume[[2]], 8] <> "}",\n  "\\\\newcommand{\\\\GVECReferenceVolume}{" <>\n    scientificTeX[finalVolume[[4]], 8] <> "}",\n  "\\\\newcommand{\\\\GVECVolumeRelativeError}{" <>\n    scientificTeX[finalVolume[[5]], 4] <> "}"}, "\\n"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/gvec_export_consistency.wl')

"""Generated SymPy translation of ``corpus/proj-gvec-stability/generate_validation_figures.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
COMPARE = {
    'compressionRatio': 'numeric',
    'eigenvector0': 'numeric',
    'meshWidths': 'numeric',
}
_ASSIGNMENTS = [
    ('scriptDirectory', 'DirectoryName[ExpandFileName[$InputFileName]]', ()),
    ('figureDirectory', 'FileNameJoin[{scriptDirectory, "..", "docs", "figures"}]', ()),
    ('generatedDirectory', 'FileNameJoin[{scriptDirectory, "..", "docs", "generated"}]', ()),
    ('mu0', '4 Pi 10^-7', ()),
    ('b0', '10^-3', ()),
    ('pressure', '1', ()),
    ('gamma', '5/3', ()),
    ('compressionRatio', 'N[gamma pressure mu0/b0^2]', ()),
    ('driveGrid', 'Subdivide[0, 2, 200]', ()),
    ('spectrumData', '{\n  Transpose[{driveGrid, 1 - driveGrid}],\n  Transpose[{driveGrid, ConstantArray[1, Length[driveGrid]]}],\n  Transpose[{driveGrid, ConstantArray[compressionRatio, Length[driveGrid]]}]}', ()),
    ('spectrumPlot', 'ListLinePlot[spectrumData,\n  Frame -> True,\n  FrameLabel -> {\n    Style["Normalized drive  D̂", 12],\n    Style["Normalized eigenvalue  ω²", 12]},\n  PlotStyle -> {\n    Directive[RGBColor[0.10, 0.35, 0.70], Thick],\n    Directive[Black, Thick, Dashed],\n    Directive[RGBColor[0.55, 0.20, 0.10], Thick, DotDashed]},\n  PlotLegends -> Placed[\n    LineLegend[{"normal branch", "shear-Alfvén branch", "compression branch"}],\n    Below],\n  PlotRange -> {{0, 2}, {-1.05, 2.25}},\n  GridLines -> {{1}, {0}},\n  GridLinesStyle -> Directive[GrayLevel[0.65], Dashed],\n  ImageSize -> 520,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}]', ()),
    ('stiffness', '{{2 + p, 1/5}, {1/5, 4 - p}}', ('p',)),
    ('mass', '{{2 + p/10, 0}, {0, 3}}', ('p',)),
    ('p0', '1/3', ()),
    ('lowestIndex', 'First[Ordering[eigenvalues0]]', ()),
    ('eigenvector0', 'eigenvectors0[[lowestIndex]]', ()),
    ('eigenvector0', 'eigenvector0/Sqrt[eigenvector0.N[mass[p0]].eigenvector0]', ()),
    ('lambda0', 'eigenvalues0[[lowestIndex]]', ()),
    ('analyticDerivative', 'eigenvector0.\n  (D[stiffness[p], p] - lambda0 D[mass[p], p] /. p -> p0).eigenvector0', ()),
    ('stepSizes', '10.^Range[-8, -1, 1/4]', ()),
    ('derivativeErrors', 'Table[\n  Abs[(lowestEigenvalue[p0 + h] - lowestEigenvalue[p0 - h])/(2 h) -\n    analyticDerivative],\n  {h, stepSizes}]', ()),
    ('positiveDerivativeData', 'Select[\n  Transpose[{stepSizes, derivativeErrors}], Last[#] > 0 &]', ()),
    ('referenceDerivative', 'positiveDerivativeData[[-1, 2]]/2 *\n  (positiveDerivativeData[[All, 1]]/positiveDerivativeData[[-1, 1]])^2', ()),
    ('derivativePlot', 'ListLogLogPlot[\n  {positiveDerivativeData,\n    Transpose[{positiveDerivativeData[[All, 1]], referenceDerivative}]},\n  Frame -> True,\n  FrameLabel -> {\n    Style["Centered-difference step h", 12],\n    Style["Absolute eigenvalue-derivative error", 12]},\n  PlotStyle -> {\n    Directive[RGBColor[0.10, 0.35, 0.70], Thick],\n    Directive[Black, Dashed, Thick]},\n  Joined -> {True, True},\n  PlotMarkers -> {{Automatic, 7}, None},\n  PlotLegends -> Placed[LineLegend[{"centered difference", "h squared reference"}], Below],\n  ImageSize -> 520,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}]', ()),
    ('elementCounts', '{4, 8, 16, 32, 64, 128}', ()),
    ('meshWidths', 'N[1/elementCounts]', ()),
    ('finiteElementEigenvalues', 'lowestFiniteElementEigenvalue /@ elementCounts', ()),
    ('finiteElementErrors', 'Abs[finiteElementEigenvalues - Pi^2]/Pi^2', ()),
    ('referenceFiniteElement', 'finiteElementErrors[[1]]/2 * (meshWidths/meshWidths[[1]])^2', ()),
    ('finiteElementPlot', 'ListLogLogPlot[\n  {Transpose[{meshWidths, finiteElementErrors}],\n    Transpose[{meshWidths, referenceFiniteElement}]},\n  Frame -> True,\n  FrameLabel -> {\n    Style["Radial mesh width h", 12],\n    Style["Relative error in lowest eigenvalue", 12]},\n  PlotStyle -> {\n    Directive[RGBColor[0.55, 0.20, 0.10], Thick],\n    Directive[Black, Dashed, Thick]},\n  Joined -> {True, True},\n  PlotMarkers -> {{Automatic, 7}, None},\n  PlotLegends -> Placed[LineLegend[{"linear finite elements", "h squared reference"}], Below],\n  ImageSize -> 520,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}]', ()),
    ('asymptoticOrders', 'Differences[Log[finiteElementErrors]]/Differences[Log[meshWidths]]', ()),
    ('numberText', 'StringRiffle[{\n  "\\\\newcommand{\\\\PrototypeCompressionRatio}{" <>\n    ToString[NumberForm[compressionRatio, {6, 4}]] <> "}",\n  "\\\\newcommand{\\\\SensitivityAnalyticValue}{" <>\n    ToString[NumberForm[analyticDerivative, {8, 6}]] <> "}",\n  "\\\\newcommand{\\\\FinestFEMRelativeError}{" <>\n    scientificTeX[Last[finiteElementErrors], 4] <> "}",\n  "\\\\newcommand{\\\\FinestFEMOrder}{" <>\n    ToString[NumberForm[Last[asymptoticOrders], {5, 3}]] <> "}"}, "\\n"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/generate_validation_figures.wl')

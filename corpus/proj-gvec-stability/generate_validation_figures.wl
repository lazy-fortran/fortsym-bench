ClearAll["Global`*"];
scriptDirectory = DirectoryName[ExpandFileName[$InputFileName]];
Get[FileNameJoin[{scriptDirectory, "validation_helpers.wl"}]];
figureDirectory = FileNameJoin[{scriptDirectory, "..", "docs", "figures"}];
generatedDirectory = FileNameJoin[{scriptDirectory, "..", "docs", "generated"}];
If[!DirectoryQ[figureDirectory],
  CreateDirectory[figureDirectory, CreateIntermediateDirectories -> True]];
If[!DirectoryQ[generatedDirectory],
  CreateDirectory[generatedDirectory, CreateIntermediateDirectories -> True]];

mu0 = 4 Pi 10^-7;
b0 = 10^-3;
pressure = 1;
gamma = 5/3;
compressionRatio = N[gamma pressure mu0/b0^2];
driveGrid = Subdivide[0, 2, 200];
spectrumData = {
  Transpose[{driveGrid, 1 - driveGrid}],
  Transpose[{driveGrid, ConstantArray[1, Length[driveGrid]]}],
  Transpose[{driveGrid, ConstantArray[compressionRatio, Length[driveGrid]]}]};
spectrumPlot = ListLinePlot[spectrumData,
  Frame -> True,
  FrameLabel -> {
    Style["Normalized drive  D̂", 12],
    Style["Normalized eigenvalue  ω²", 12]},
  PlotStyle -> {
    Directive[RGBColor[0.10, 0.35, 0.70], Thick],
    Directive[Black, Thick, Dashed],
    Directive[RGBColor[0.55, 0.20, 0.10], Thick, DotDashed]},
  PlotLegends -> Placed[
    LineLegend[{"normal branch", "shear-Alfvén branch", "compression branch"}],
    Below],
  PlotRange -> {{0, 2}, {-1.05, 2.25}},
  GridLines -> {{1}, {0}},
  GridLinesStyle -> Directive[GrayLevel[0.65], Dashed],
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}];
Export[FileNameJoin[{figureDirectory, "local_spectrum.pdf"}], spectrumPlot];

stiffness[p_] := {{2 + p, 1/5}, {1/5, 4 - p}};
mass[p_] := {{2 + p/10, 0}, {0, 3}};
lowestEigenvalue[p_?NumericQ] := Min[Eigenvalues[{N[stiffness[p]], N[mass[p]]}]];
p0 = 1/3;
{eigenvalues0, eigenvectors0} = Eigensystem[{N[stiffness[p0]], N[mass[p0]]}];
lowestIndex = First[Ordering[eigenvalues0]];
eigenvector0 = eigenvectors0[[lowestIndex]];
eigenvector0 = eigenvector0/Sqrt[eigenvector0.N[mass[p0]].eigenvector0];
lambda0 = eigenvalues0[[lowestIndex]];
analyticDerivative = eigenvector0.
  (D[stiffness[p], p] - lambda0 D[mass[p], p] /. p -> p0).eigenvector0;
stepSizes = 10.^Range[-8, -1, 1/4];
derivativeErrors = Table[
  Abs[(lowestEigenvalue[p0 + h] - lowestEigenvalue[p0 - h])/(2 h) -
    analyticDerivative],
  {h, stepSizes}];
positiveDerivativeData = Select[
  Transpose[{stepSizes, derivativeErrors}], Last[#] > 0 &];
referenceDerivative = positiveDerivativeData[[-1, 2]]/2 *
  (positiveDerivativeData[[All, 1]]/positiveDerivativeData[[-1, 1]])^2;
derivativePlot = ListLogLogPlot[
  {positiveDerivativeData,
    Transpose[{positiveDerivativeData[[All, 1]], referenceDerivative}]},
  Frame -> True,
  FrameLabel -> {
    Style["Centered-difference step h", 12],
    Style["Absolute eigenvalue-derivative error", 12]},
  PlotStyle -> {
    Directive[RGBColor[0.10, 0.35, 0.70], Thick],
    Directive[Black, Dashed, Thick]},
  Joined -> {True, True},
  PlotMarkers -> {{Automatic, 7}, None},
  PlotLegends -> Placed[LineLegend[{"centered difference", "h squared reference"}], Below],
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}];
Export[FileNameJoin[{figureDirectory, "eigen_sensitivity_error.pdf"}], derivativePlot];

lowestFiniteElementEigenvalue[elementCount_Integer] := Module[
  {h, elementStiffness, elementMass, stiffnessMatrix, massMatrix, nodes, interior},
  h = 1/elementCount;
  elementStiffness = {{1, -1}, {-1, 1}}/h;
  elementMass = h {{2, 1}, {1, 2}}/6;
  stiffnessMatrix = ConstantArray[0., {elementCount + 1, elementCount + 1}];
  massMatrix = ConstantArray[0., {elementCount + 1, elementCount + 1}];
  Do[
    nodes = {element, element + 1};
    stiffnessMatrix[[nodes, nodes]] += elementStiffness;
    massMatrix[[nodes, nodes]] += elementMass,
    {element, elementCount}];
  interior = Range[2, elementCount];
  Min[Eigenvalues[{
    stiffnessMatrix[[interior, interior]],
    massMatrix[[interior, interior]]}]]];
elementCounts = {4, 8, 16, 32, 64, 128};
meshWidths = N[1/elementCounts];
finiteElementEigenvalues = lowestFiniteElementEigenvalue /@ elementCounts;
finiteElementErrors = Abs[finiteElementEigenvalues - Pi^2]/Pi^2;
referenceFiniteElement = finiteElementErrors[[1]]/2 * (meshWidths/meshWidths[[1]])^2;
finiteElementPlot = ListLogLogPlot[
  {Transpose[{meshWidths, finiteElementErrors}],
    Transpose[{meshWidths, referenceFiniteElement}]},
  Frame -> True,
  FrameLabel -> {
    Style["Radial mesh width h", 12],
    Style["Relative error in lowest eigenvalue", 12]},
  PlotStyle -> {
    Directive[RGBColor[0.55, 0.20, 0.10], Thick],
    Directive[Black, Dashed, Thick]},
  Joined -> {True, True},
  PlotMarkers -> {{Automatic, 7}, None},
  PlotLegends -> Placed[LineLegend[{"linear finite elements", "h squared reference"}], Below],
  ImageSize -> 520,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}];
Export[FileNameJoin[{figureDirectory, "radial_fem_convergence.pdf"}], finiteElementPlot];

asymptoticOrders = Differences[Log[finiteElementErrors]]/Differences[Log[meshWidths]];
If[Min[Take[asymptoticOrders, -4]] < 1.95, Print["FAIL  FEM order"]; Quit[1]];

numberText = StringRiffle[{
  "\\newcommand{\\PrototypeCompressionRatio}{" <>
    ToString[NumberForm[compressionRatio, {6, 4}]] <> "}",
  "\\newcommand{\\SensitivityAnalyticValue}{" <>
    ToString[NumberForm[analyticDerivative, {8, 6}]] <> "}",
  "\\newcommand{\\FinestFEMRelativeError}{" <>
    scientificTeX[Last[finiteElementErrors], 4] <> "}",
  "\\newcommand{\\FinestFEMOrder}{" <>
    ToString[NumberForm[Last[asymptoticOrders], {5, 3}]] <> "}"}, "\n"];
Export[FileNameJoin[{generatedDirectory, "validation_numbers.tex"}], numberText, "Text"];

Print["PASS  local spectrum figure"];
Print["PASS  eigenvalue sensitivity figure"];
Print["PASS  radial finite-element convergence figure"];
Quit[0];

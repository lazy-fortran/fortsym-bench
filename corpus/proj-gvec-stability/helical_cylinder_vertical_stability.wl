ClearAll["Global`*"];

passed = 0;
failed = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  passed++; Print["PASS: ", name], failed++; Print["FAIL: ", name]];

$Assumptions = kappa >= 1 && psi0 > 0 && volume > 0 &&
  displacement != 0 && b > 0;

psiCurrent = (1 - externalFraction) psi0;
energyPrefactor = 2 volume displacement^2/b^4;
energyBracket = (1 + kappa) psi0^2 -
  (kappa^2 + 1) psiCurrent psi0;
energy = energyPrefactor energyBracket;
criticalFraction = (kappa^2 - kappa)/(kappa^2 + 1);

check["published energy reduction",
  Factor[energyBracket/psi0^2] ==
    1 + kappa - (kappa^2 + 1) (1 - externalFraction)];
check["marginal external-transform fraction",
  FullSimplify[energyBracket /. externalFraction -> criticalFraction] == 0];
check["stable above marginality",
  FullSimplify[energyBracket > 0, externalFraction > criticalFraction]];
check["unstable below marginality",
  FullSimplify[energyBracket < 0, 0 <= externalFraction < criticalFraction]];
check["circular limit", (criticalFraction /. kappa -> 1) == 0];
check["elongation two", (criticalFraction /. kappa -> 2) == 2/5];
check["large-elongation limit",
  Block[{$Assumptions = True}, Limit[criticalFraction, kappa -> Infinity]] == 1];
check["monotone for elongated sections",
  FullSimplify[D[criticalFraction, kappa] > 0, kappa > 1]];
check["corrupted denominator is detected",
  ((kappa^2 - kappa)/(kappa^2 - 1) /. kappa -> 2) != 2/5];

projectDirectory = DirectoryName[DirectoryName[$InputFileName]];
figureDirectory = FileNameJoin[{projectDirectory, "docs", "figures"}];
boundaryPoints = Table[
  {x, (x^2 - x)/(x^2 + 1)}, {x, 1, 5, 0.02}];
figure = Graphics[{
    {RGBColor[0.76, 0.86, 0.72],
     Polygon[Join[boundaryPoints, {{5, 1}, {1, 1}}]]},
    {RGBColor[0.88, 0.68, 0.65],
     Polygon[Join[{{1, 0}, {5, 0}}, Reverse[boundaryPoints]]]},
    {Black, Thick, Line[boundaryPoints]},
    {Black, PointSize[0.018], Point[{2, 2/5}]},
    Text[Style["stable", 14, Bold], {4.1, 0.88}],
    Text[Style["unstable", 14, Bold], {4.1, 0.45}],
    Text[Style["(2, 0.4)", 12], {2.35, 0.35}]},
  PlotRange -> {{1, 5}, {0, 1}}, Frame -> True, Axes -> False,
  FrameLabel -> {Style["elongation  κ", 14],
    Style["external-transform fraction  f", 14]},
  BaseStyle -> {FontFamily -> "Helvetica", 12}, ImageSize -> 520,
  AspectRatio -> 0.62, PlotRangePadding -> None];
Export[FileNameJoin[{figureDirectory,
   "helical_cylinder_vertical_stability.pdf"}], figure];
Export[FileNameJoin[{figureDirectory,
   "helical_cylinder_vertical_stability.png"}], figure,
  ImageResolution -> 180];

Print["Passed: ", passed, " Failed: ", failed];
If[failed > 0, Exit[1]];

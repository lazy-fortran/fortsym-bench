Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];
figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];

ClearAll[r, theta, z, m, k, beta, current, source, chi, jr, jtheta, jz];
chi = m theta + k z + beta;
jr = 0;
jtheta = -k r current[r] Cos[chi]/m;
jz = current[r] Cos[chi];

check["spectral source: every non-axisymmetric helical harmonic is solenoidal",
  FullSimplify[D[r jr, r]/r + D[jtheta, theta]/r + D[jz, z]] == 0];

ClearAll[u1, u2, source1, source2, a1, a2, radialOperator];
radialOperator[expr_] := D[expr, {r, 2}] + D[expr, r]/r -
  (m^2/r^2 + k^2) expr;
residual[u_, s_] := radialOperator[u] - r s'[r] - 2 s[r];
check["spectral Maxwell map is linear mode by mode",
  FullSimplify[residual[a1 u1[r] + a2 u2[r],
      Function[{x}, a1 source1[x] + a2 source2[x]]] ==
    a1 residual[u1[r], source1] + a2 residual[u2[r], source2]]];

check["distinct Fourier harmonics are orthogonal in the surface average",
  Integrate[Cos[theta + z] Cos[2 theta + z],
    {theta, 0, 2 Pi}, {z, 0, 2 Pi}]/(2 Pi)^2 == 0];

ClearAll[makeMode];
makeMode[mode_Integer, axialWave_?NumericQ] := Module[
  {peakRadius, peakValue, sourceValue, regular, decaying,
    regularPrime, decayingPrime, lower, upper, radialField, potential,
    radii, sourceSamples, fieldSamples, odeSolution, comparisonRadii,
    odePotentialError, odeFieldError},
  peakRadius = Sqrt[mode/2.];
  peakValue = peakRadius^mode Exp[-peakRadius^2];
  sourceValue[x_?NumericQ] := x^mode Exp[-x^2]/peakValue;
  regular[x_?NumericQ] := BesselI[mode, axialWave x];
  decaying[x_?NumericQ] := BesselK[mode, axialWave x];
  regularPrime[x_?NumericQ] := axialWave
    (BesselI[mode - 1, axialWave x] +
      BesselI[mode + 1, axialWave x])/2.;
  decayingPrime[x_?NumericQ] := -axialWave
    (BesselK[mode - 1, axialWave x] +
      BesselK[mode + 1, axialWave x])/2.;
  lower[x_?NumericQ] := lower[x] = NIntegrate[
    s^2 regularPrime[s] sourceValue[s], {s, 0, x},
    AccuracyGoal -> 11, PrecisionGoal -> 9];
  upper[x_?NumericQ] := upper[x] = NIntegrate[
    s^2 decayingPrime[s] sourceValue[s], {s, x, Infinity},
    AccuracyGoal -> 11, PrecisionGoal -> 9];
  radialField[x_?NumericQ] :=
    (decayingPrime[x] lower[x] + regularPrime[x] upper[x])/mode;
  potential[x_?NumericQ] :=
    decaying[x] lower[x] + regular[x] upper[x];
  radii = N@Subdivide[0.04, 4., 120];
  sourceSamples = ({#, sourceValue[#]} &) /@ radii;
  fieldSamples = ({#, radialField[#]} &) /@ radii;
  (* ODE residual of the Green construction (script 28 chain): the
     potential u = K_m lower + I_m upper must solve
     u'' + u'/r - (m^2/r^2 + k^2) u = r s' + 2 s, and the plotted
     radial field must equal (u' - r s)/m.  Solve the same ODE
     independently with NDSolve from Green boundary values and compare
     both at interior radii, relative to the per-mode maximum.  The
     boundary-value solve runs at WorkingPrecision 25 because the
     homogeneous solutions x^(+-m) vary by (100)^m across the sampled
     domain, which costs about 2m digits; boundary-value errors damp
     toward the interior, so the comparison is well conditioned. *)
  odeSolution = NDSolveValue[{
      v''[x] + v'[x]/x -
          (mode^2/x^2 + Rationalize[axialWave, 0]^2) v[x] ==
        ((mode + 2) x^mode - 2 x^(mode + 2)) Exp[-x^2]/
          Rationalize[peakValue, 0],
      v[SetPrecision[First[radii], 25]] ==
        SetPrecision[potential[First[radii]], 25],
      v[SetPrecision[Last[radii], 25]] ==
        SetPrecision[potential[Last[radii]], 25]},
    v, {x, SetPrecision[First[radii], 25], SetPrecision[Last[radii], 25]},
    WorkingPrecision -> 25, AccuracyGoal -> 15, PrecisionGoal -> 15,
    MaxSteps -> Infinity];
  comparisonRadii = {0.1, 0.3, 0.7, 1., 1.5, 2., 3., 3.7};
  odePotentialError = Max[(Abs[odeSolution[#] - potential[#]] &) /@
      comparisonRadii]/Max[(Abs[potential[#]] &) /@ comparisonRadii];
  odeFieldError = Max[(Abs[(odeSolution'[#] - # sourceValue[#])/mode -
          radialField[#]] &) /@ comparisonRadii]/
    Max[(Abs[radialField[#]] &) /@ comparisonRadii];
  <|"mode" -> mode, "source" -> sourceSamples, "field" -> fieldSamples,
    "odePotentialError" -> odePotentialError,
    "odeFieldError" -> odeFieldError|>
  ];

modeData = makeMode[#, 0.25] & /@ {1, 2, 3};
sourcePeaks = Max[#[[All, 2]]] & /@ (modeData[[All, "source"]]);
fieldPeaks = Max[Abs[#[[All, 2]]]] & /@ (modeData[[All, "field"]]);

Print["    ODE-residual relative errors, potential u: ",
  N[modeData[[All, "odePotentialError"]], 3]];
Print["    ODE-residual relative errors, field (u'-r s)/m: ",
  N[modeData[[All, "odeFieldError"]], 3]];

check["spectral example: all source harmonics have unit peak amplitude",
  Max[Abs[sourcePeaks - 1]] < 2 10^-3];
check["spectral solver: Green potential solves the radial ODE for all three modes (rel tol 1e-6)",
  Max[modeData[[All, "odePotentialError"]]] < 10^-6];
check["spectral solver: plotted field equals (u'-r s)/m of the independent ODE solve for all three modes (rel tol 1e-6)",
  Max[modeData[[All, "odeFieldError"]]] < 10^-6];
check["spectral example: higher poloidal harmonics are progressively filtered",
  fieldPeaks[[1]] > fieldPeaks[[2]] > fieldPeaks[[3]] > 0];
check["spectral example: regular radial fields remain finite near the axis",
  Max[Abs[modeData[[All, "field", 1, 2]]]] < 1];

styles = {
  Directive[Thick, ColorData[97][1]],
  Directive[Thick, Dashed, ColorData[97][2]],
  Directive[Thick, DotDashed, ColorData[97][4]]};
legend = {"m = 1", "m = 2", "m = 3"};
sourcePlot = ListLinePlot[modeData[[All, "source"]],
  Frame -> True, FrameLabel -> {"r/a", "normalized current harmonic"},
  PlotStyle -> styles, PlotLegends -> Placed[legend, {0.76, 0.78}],
  PlotRange -> All, ImageSize -> 330];
fieldPlot = ListLinePlot[modeData[[All, "field"]],
  Frame -> True, FrameLabel -> {"r/a", "radial field (normalized units)"},
  PlotStyle -> styles, PlotLegends -> None, PlotRange -> All,
  ImageSize -> 330];
spectralFigure = GraphicsRow[{sourcePlot, fieldPlot}, Spacings -> 12,
  ImageSize -> 700];
Export[FileNameJoin[{figdir, "fig_maxwell_spectrum.pdf"}], spectralFigure];
check["[exists] fig_maxwell_spectrum exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_maxwell_spectrum.pdf"}]]];

ClearAll[detuning, exponent, fieldScale];
currentScaling = detuning^exponent;
fieldScaling = fieldScale detuning^exponent;
displacementScaling = fieldScaling/detuning;
pullbackScaling = currentScaling displacementScaling;

check["closure scaling: displacement is D^(p-1)",
  FullSimplify[displacementScaling ==
    fieldScale detuning^(exponent - 1), detuning > 0]];
check["closure scaling: axisymmetric pullback is D^(2p-1)",
  FullSimplify[pullbackScaling ==
    fieldScale detuning^(2 exponent - 1), detuning > 0]];
check["closure scaling: Delta proportional to D gives a cubic pullback",
  FullSimplify[({displacementScaling, pullbackScaling} /.
      exponent -> 2) == {fieldScale detuning, fieldScale detuning^3}]];

twoSidedFeedback = detuning Abs[detuning]^(2 exponent - 2);
check["closure scaling: the real two-sided law reproduces p=1 and p=2",
  FullSimplify[
    {twoSidedFeedback /. exponent -> 1,
      twoSidedFeedback /. exponent -> 2} ==
     {detuning, detuning^3}, Element[detuning, Reals]]];

scalingFigure = LogLogPlot[
  Evaluate@Table[d^(p - 1), {p, 0, 2}], {d, 10^-3, 1},
  Frame -> True,
  FrameLabel -> {"|D|/Dref", "|Delta|/Delta_ref"},
  PlotStyle -> styles,
  PlotLegends -> Placed[{"p = 0: fixed current", "p = 1: finite Delta",
    "p = 2: Delta proportional to D"}, {0.65, 0.28}],
  GridLines -> {{}, {1}}, GridLinesStyle -> Directive[Gray, Dotted],
  PlotRange -> {10^-3, 10^3}, ImageSize -> 470];
Export[FileNameJoin[{figdir, "fig_detuning_scaling.pdf"}], scalingFigure];
check["[exists] fig_detuning_scaling exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_detuning_scaling.pdf"}]]];

ClearAll[x, x0, coupling];
stabilizingMap = x + coupling x^3;
reinforcingMap = x - coupling x^3;

check["toy closure: stabilizing p=2 branch is unique",
  FullSimplify[D[stabilizingMap, x] > 0,
    coupling > 0 && Element[x, Reals]]];
check["toy closure: stabilizing p=2 relaxation is locally attracting",
  FullSimplify[D[x0 - stabilizingMap, x] < 0,
    coupling > 0 && Element[x, Reals]]];

foldLocation = 1/Sqrt[3 coupling];
foldDrive = FullSimplify[reinforcingMap /. x -> foldLocation,
  coupling > 0];
check["toy closure: reinforcing p=2 branch has a fold",
  FullSimplify[(D[reinforcingMap, x] /. x -> foldLocation) == 0 &&
    foldDrive == 2/(3 Sqrt[3 coupling]), coupling > 0]];

couplingValue = 4.;
closureFigure = Show[
  Plot[
    Evaluate[{x, x + couplingValue x^3, x - couplingValue x^3}],
    {x, -0.75, 0.75}, Frame -> True,
    FrameLabel -> {"response detuning x", "imposed detuning x0"},
    PlotStyle -> {Directive[Gray, Dashed], styles[[1]], styles[[2]]},
    PlotLegends -> Placed[{"no feedback", "stabilizing phase",
      "reinforcing phase"}, {0.25, 0.78}], PlotRange -> {-1.1, 1.1},
    ImageSize -> 470],
  Graphics[{Black, PointSize[0.016],
    Point[{{foldLocation /. coupling -> couplingValue,
        foldDrive /. coupling -> couplingValue},
      {-foldLocation /. coupling -> couplingValue,
        -foldDrive /. coupling -> couplingValue}}]}]];
Export[FileNameJoin[{figdir, "fig_toy_closure.pdf"}], closureFigure];
check["[exists] fig_toy_closure exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_toy_closure.pdf"}]]];

reportAndExit[];

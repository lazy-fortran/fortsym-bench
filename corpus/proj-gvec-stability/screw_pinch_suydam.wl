scriptDirectory = DirectoryName[ExpandFileName[$InputFileName]];
projectDirectory = FileNameJoin[{scriptDirectory, ".."}];
figureDirectory = FileNameJoin[{projectDirectory, "docs", "figures"}];

pass = 0; fail = 0;
assumptions = {r > 0, rs > 0, mu0 > 0, Element[{m, k}, Reals],
  Element[{btheta[r], bz[r], xr[r], eta[r], Derivative[1][xr][r],
    Derivative[1][eta][r], Derivative[1][btheta][r],
    Derivative[1][bz][r], Derivative[1][p][r]}, Reals],
  btheta[r]^2 + bz[r]^2 > 0, m^2 + k^2 r^2 > 0};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];
conj[expr_] := expr /. Complex[a_, b_] :> Complex[a, -b];

(* Screw pinch, perturbation Exp[I(m theta + k z)].  The tangential
   amplitude carries -I so that all reduced coefficients are real. *)
coords = {r, theta, z};
phase = Exp[I (m theta + k z)];
bField = {0, btheta[r], bz[r]};
bMag = Sqrt[btheta[r]^2 + bz[r]^2];
current = Curl[bField, coords, "Cylindrical"]/mu0;
forceBalance = Derivative[1][p][rr_] :>
  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -
    bz[rr] Derivative[1][bz][rr]/mu0;

xiPerp = {xr[r], -I eta[r] bz[r]/bMag, I eta[r] btheta[r]/bMag} phase;
check["displacement is perpendicular to B", xiPerp . bField == 0];

qField = Curl[Cross[xiPerp, bField], coords, "Cylindrical"];
divPerp = Div[xiPerp, coords, "Cylindrical"];
gradP = {Derivative[1][p][r], 0, 0};

(* Incompressible fixed-boundary energy density (Freidberg 2014):
   the gamma-p fluid-compression term is annihilated by the parallel
   displacement and is dropped before the reduction. *)
density = qField . conj[qField]/mu0 -
  conj[xiPerp] . Cross[current, qField] +
  (xiPerp . gradP) conj[divPerp];
realDensity = Simplify[ComplexExpand[(density + conj[density])/2,
    TargetFunctions -> {Re, Im}] /. {theta -> 0, z -> 0}, assumptions];
radialDensity = Simplify[r realDensity, assumptions];

check["binormal amplitude appears algebraically",
  D[radialDensity, eta'[r]] == 0];
quadratic = CoefficientList[radialDensity, eta[r]];
check["binormal coefficient is positive", quadratic[[3]] > 0];
minimized = Simplify[
  quadratic[[1]] - quadratic[[2]]^2/(4 quadratic[[3]]), assumptions];

fCoefficient = Simplify[D[minimized, {xr'[r], 2}]/2, assumptions];
crossCoefficient = Simplify[D[D[minimized, xr'[r]], xr[r]], assumptions];
cCoefficient = Simplify[D[minimized, {xr[r], 2}]/2, assumptions];
gCoefficient = Simplify[
  cCoefficient - D[crossCoefficient, r]/2 /. forceBalance, assumptions];

lineBending = m btheta[r]/r + k bz[r];
check["Newcomb f equals the field-line-bending form",
  fCoefficient == r lineBending^2/(mu0 (k^2 + m^2/r^2))];

(* Frobenius analysis at the resonant surface F(rs) = 0. *)
resonance = k -> -m btheta[rs]/(rs bz[rs]);
fQuadratic = Simplify[
  (D[fCoefficient /. r -> rr, {rr, 2}]/2 /. rr -> rs) /. resonance,
  assumptions];
gResonant = Simplify[(gCoefficient /. r -> rs) /. resonance, assumptions];

indicialRoots = nu /. Solve[fQuadratic nu (nu + 1) == gResonant, nu];
indicialRatio = Simplify[1 + 4 gResonant/fQuadratic, assumptions];
check["real indicial roots iff the indicial ratio is non-negative",
  (indicialRoots[[1]] - indicialRoots[[2]])^2 == indicialRatio];

safety = rr bz[rr]/(len btheta[rr]);
shearTerm = (D[safety, rr]/safety /. rr -> rs);
suydamRatio = Simplify[
  (1 + 8 mu0 Derivative[1][p][rs]/(rs bz[rs]^2 shearTerm^2)) /.
    forceBalance, assumptions];
check["indicial ratio equals the Suydam ratio",
  indicialRatio == suydamRatio];
check["mode numbers cancel from the marginal condition",
  FreeQ[indicialRatio, m] && FreeQ[indicialRatio, k]];

(* Normalized variables X = r q'/q, Y = -2 mu0 r p'/Bz^2:
   marginal stability at Y = X^2/4. *)
normalizedRatio = 1 + 8 mu0 pp/(rs bzs^2 st^2) /.
  {pp -> -yy bzs^2/(2 mu0 rs), st -> xx/rs};
check["normalized marginal parabola  Y = X^2/4",
  Simplify[(normalizedRatio /. yy -> xx^2/4) == 0, xx != 0]];

stabilityPlot = Show[
  RegionPlot[y < x^2/4, {x, 0, 3}, {y, 0, 2.5},
    PlotStyle -> Directive[RGBColor[0.10, 0.35, 0.70], Opacity[0.12]],
    BoundaryStyle -> None, PlotPoints -> 60],
  Plot[x^2/4, {x, 0, 3},
    PlotStyle -> Directive[RGBColor[0.10, 0.35, 0.70], Thick]],
  Frame -> True,
  FrameLabel -> {
    Style["Normalized shear  X = r q'/q", 12],
    Style["Normalized pressure gradient  Y = \[Minus]2\[Mu]\:2080r p\[Prime]/Bz\.b2",
      12]},
  Epilog -> {
    Text[Style["Suydam stable", 12, RGBColor[0.10, 0.35, 0.70]],
      {2.15, 0.45}],
    Text[Style["interchange unstable", 12, RGBColor[0.65, 0.20, 0.12]],
      {0.95, 1.9}],
    Text[Style["Y = X\.b2/4", 12], {2.45, 1.75}]},
  PlotRange -> {{0, 3}, {0, 2.5}},
  ImageSize -> 460,
  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}];
Export[FileNameJoin[{figureDirectory, "screw_pinch_suydam.pdf"}],
  stabilityPlot];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

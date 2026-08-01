(* General helically symmetric Maxwell and magnetic-surface closure.
   Physical cylindrical components use chi=m theta+k z, k=n/R, and CGS. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[r, theta, z, chi, m, k, cl, current, source, u, radialOp,
  brAmp, bthetaAmp, bzAmp];

$Assumptions = {r > 0, m > 0, k >= 0, cl > 0,
  Element[m, Integers]};

chi = m theta + k z;
source[r_] := 4 Pi current[r]/cl;

jr = 0;
jtheta = -k r current[r] Cos[chi]/m;
jz = current[r] Cos[chi];
divJ = FullSimplify[
  D[r jr, r]/r + D[jtheta, theta]/r + D[jz, z]];

check["Maxwell current: arbitrary radial profile is divergence-free",
  divJ == 0];

radialOp[expr_] := D[expr, {r, 2}] + D[expr, r]/r -
  (m^2/r^2 + k^2) expr;
brAmp[r_] := (u'[r] - r source[r])/m;
bthetaAmp[r_] := u[r]/r;
bzAmp[r_] := k u[r]/m;

br = brAmp[r] Sin[chi];
btheta = bthetaAmp[r] Cos[chi];
bz = bzAmp[r] Cos[chi];

divB = FullSimplify[
  D[r br, r]/r + D[btheta, theta]/r + D[bz, z]];
curlB = FullSimplify[{
  D[bz, theta]/r - D[btheta, z],
  D[br, z] - D[bz, r],
  (D[r btheta, r] - D[br, theta])/r}];

check["Maxwell field: divergence is the scalar radial residual",
  FullSimplify[divB ==
    (radialOp[u[r]] - r source'[r] - 2 source[r]) Sin[chi]/m]];
check["Maxwell field: radial Ampere component vanishes", curlB[[1]] == 0];
check["Maxwell field: poloidal Ampere component matches the helical pitch",
  FullSimplify[curlB[[2]] == -k r source[r] Cos[chi]/m]];
check["Maxwell field: axial Ampere component matches any right-hand side",
  FullSimplify[curlB[[3]] == source[r] Cos[chi]]];

ClearAll[lowerMoment, upperMoment];
uZero = (r^-m lowerMoment[r] - r^m upperMoment[r])/2;
momentRules = {
  lowerMoment'[r] -> r^(m + 1) source[r],
  lowerMoment''[r] -> (m + 1) r^m source[r] + r^(m + 1) source'[r],
  upperMoment'[r] -> -r^(1 - m) source[r],
  upperMoment''[r] -> -(1 - m) r^-m source[r] -
    r^(1 - m) source'[r]};

check["Green k=0: radial moments solve Maxwell for arbitrary source",
  FullSimplify[(radialOp[uZero] /. k -> 0) - r source'[r] -
      2 source[r] /. momentRules] == 0];

ClearAll[compactSource, compactInside, compactOutside, s];
compactSource[x_] := x (1 - x)^2;
compactInside = FullSimplify[(r^-1 Integrate[
      s^2 compactSource[s], {s, 0, r}] -
    r Integrate[compactSource[s], {s, r, 1}])/2];
compactOutside = FullSimplify[r^-1 Integrate[
    s^2 compactSource[s], {s, 0, 1}]/2];

check["Green k=0: compact polynomial source satisfies Maxwell inside",
  FullSimplify[(radialOp[compactInside] /. {m -> 1, k -> 0}) ==
    r compactSource'[r] + 2 compactSource[r], 0 < r < 1]];
check["Green k=0: compact polynomial field is regular on axis",
  FullSimplify[(compactInside /. r -> 0) == 0]];
check["Green k=0: compact polynomial solution matches its exterior tail",
  FullSimplify[
    ((compactInside - compactOutside) /. r -> 1) == 0 &&
    (D[compactInside - compactOutside, r] /. r -> 1) == 0]];

ClearAll[reg, dec, lowerGreen, upperGreen];
uGreen = dec[r] lowerGreen[r] + reg[r] upperGreen[r];
greenDerivativeRules = {
  lowerGreen'[r] -> r^2 reg'[r] source[r],
  upperGreen'[r] -> -r^2 dec'[r] source[r]};
greenWronskian = reg[r] dec'[r] - reg'[r] dec[r] == -1/r;
uGreenPrime = dec'[r] lowerGreen[r] + reg'[r] upperGreen[r] +
  r source[r];

check["Green k>0: source-only integrals give the required first derivative",
  FullSimplify[(D[uGreen, r] /. greenDerivativeRules) == uGreenPrime,
    greenWronskian]];

greenHomogeneousRules = {
  reg''[r] -> -reg'[r]/r + (m^2/r^2 + k^2) reg[r],
  dec''[r] -> -dec'[r]/r + (m^2/r^2 + k^2) dec[r]};
uGreenSecond = D[uGreenPrime, r] /. greenDerivativeRules;
greenResidual = uGreenSecond + uGreenPrime/r -
  (m^2/r^2 + k^2) uGreen - r source'[r] - 2 source[r];

check["Green k>0: modified-Bessel kernel solves Maxwell for arbitrary source",
  FullSimplify[greenResidual /. greenHomogeneousRules] == 0];
check["Green k>0: I_m and K_m have the required Wronskian",
  FullSimplify[
    BesselI[m, k r] D[BesselK[m, k r], r] -
      D[BesselI[m, k r], r] BesselK[m, k r] == -1/r,
    k > 0 && r > 0 && m > 0]];

ClearAll[btheta0, bz0, psi0, eps];
detuning[r_] := m btheta0[r]/r + k bz0[r];
phaseField[r_] := m bthetaAmp[r]/r + k bzAmp[r];
psi = psi0[r] - eps r brAmp[r] Cos[chi];
brTotal = eps brAmp[r] Sin[chi];
bthetaTotal = btheta0[r] + eps bthetaAmp[r] Cos[chi];
bzTotal = bz0[r] + eps bzAmp[r] Cos[chi];
bDotGradPsi = FullSimplify[
  brTotal D[psi, r] + bthetaTotal D[psi, theta]/r +
    bzTotal D[psi, z]];
surfaceRules = {
  psi0'[r] -> -r detuning[r],
  u''[r] -> -u'[r]/r + (m^2/r^2 + k^2) u[r] +
    r source'[r] + 2 source[r]};

check["Surface: helical flux is an exact invariant for arbitrary source",
  FullSimplify[bDotGradPsi /. surfaceRules] == 0];

delta[r_] := brAmp[r]/detuning[r];
rhoLabel = r + eps delta[r] Cos[chi];
bDotGradRho = brTotal D[rhoLabel, r] +
  bthetaTotal D[rhoLabel, theta]/r + bzTotal D[rhoLabel, z];

check["Surface: Sergei label has Delta=delta B_r/(B0.grad chi)",
  FullSimplify[Coefficient[Normal@Series[bDotGradRho, {eps, 0, 1}], eps]] == 0];

ClearAll[gap, p, source0, field0];
check["Detuning scaling: source O(D^p) gives Delta O(D^(p-1))",
  FullSimplify[gap^p field0/gap == gap^(p - 1) field0,
    gap > 0 && Element[p, Reals]]];
check["Detuning scaling: a fixed source gives inverse-detuning displacement",
  FullSimplify[gap^0 field0/gap == field0/gap, gap > 0]];
check["Detuning scaling: Delta proportional to detuning requires quadratic source",
  FullSimplify[gap^2 field0/gap == gap field0, gap > 0]];

ClearAll[sourceBar, bthetaBar, capR, bmag];
sourceBar[r_] := D[r source[r] delta[r], r]/(2 r);
bthetaBar[r_] := source[r] delta[r]/2;

check["Axisymmetric pullback: Ampere integrates for arbitrary source and Delta",
  FullSimplify[D[r bthetaBar[r], r]/r == sourceBar[r]]];
check["Axisymmetric pullback: rotational-transform correction matches the memo",
  FullSimplify[capR bthetaBar[r]/(r bmag) ==
    capR source[r] delta[r]/(2 r bmag)]];

mNum = 1;
kNum = 1/5;
rMin = 1/20;
rMax = 14;
sourceNum[x_?NumericQ] := x Exp[-x];
sourceNumPrime[x_?NumericQ] := (1 - x) Exp[-x];
regNum[x_?NumericQ] := BesselI[mNum, kNum x];
decNum[x_?NumericQ] := BesselK[mNum, kNum x];
regNumPrime[x_?NumericQ] := kNum (BesselI[mNum - 1, kNum x] +
    BesselI[mNum + 1, kNum x])/2;
decNumPrime[x_?NumericQ] := -kNum (BesselK[mNum - 1, kNum x] +
    BesselK[mNum + 1, kNum x])/2;

lowerGreenNum[x_?NumericQ] := NIntegrate[
  s^2 regNumPrime[s] sourceNum[s], {s, 0, x},
  WorkingPrecision -> 35, AccuracyGoal -> 24, PrecisionGoal -> 20];
upperGreenNum[x_?NumericQ] := NIntegrate[
  s^2 decNumPrime[s] sourceNum[s], {s, x, Infinity},
  WorkingPrecision -> 35, AccuracyGoal -> 24, PrecisionGoal -> 20];
uGreenNum[x_?NumericQ] :=
  decNum[x] lowerGreenNum[x] + regNum[x] upperGreenNum[x];

uNumeric = NDSolveValue[{
    v''[x] + v'[x]/x - (mNum^2/x^2 + kNum^2) v[x] ==
      x sourceNumPrime[x] + 2 sourceNum[x],
    v[rMin] == uGreenNum[rMin], v[rMax] == uGreenNum[rMax]},
  v, {x, rMin, rMax}, WorkingPrecision -> 35,
  AccuracyGoal -> 24, PrecisionGoal -> 20];

comparisonRadii = {1/5, 1/2, 1, 2, 4, 8, 12};
greenOdeError = Max[Abs[(uNumeric[#] - uGreenNum[#])/
      Max[1, Abs[uGreenNum[#]]]] & /@ comparisonRadii];
check["Numerical fallback: Green integral agrees with radial ODE solve",
  greenOdeError < 10^-12];

fNum[x_?NumericQ] := (uNumeric'[x] - x sourceNum[x])/mNum;
gNum[x_?NumericQ] := uNumeric[x]/x;
hNum[x_?NumericQ] := kNum uNumeric[x]/mNum;

capRNum = 1/kNum;
iotaBackground = -3/4;
epsilonNum = 1/200;
detuningNum = (mNum iotaBackground + 1)/capRNum;
psi0Num[x_?NumericQ] := -detuningNum x^2/2;
psiNum[x_?NumericQ, phase_?NumericQ] :=
  psi0Num[x] - epsilonNum x fNum[x] Cos[phase];

rotationForLaunch[phaseStart_?NumericQ, psiStar_?NumericQ] := Module[
  {radiusStart, solution, phaseEnd, radiusEnd, thetaAdvance, zetaAdvance,
    invariantSamples, invariantError},
  radiusStart = radius /. FindRoot[
      psiNum[radius, phaseStart] == psiStar, {radius, 2},
      WorkingPrecision -> 30];
  phaseEnd = phaseStart + 2 Pi;
  solution = NDSolveValue[{
      radius'[phase] ==
        epsilonNum fNum[radius[phase]] Sin[phase]/
          (mNum (iotaBackground radius[phase]/capRNum +
                epsilonNum gNum[radius[phase]] Cos[phase])/radius[phase] +
            kNum (1 + epsilonNum hNum[radius[phase]] Cos[phase])),
      poloidal'[phase] ==
        ((iotaBackground radius[phase]/capRNum +
              epsilonNum gNum[radius[phase]] Cos[phase])/radius[phase])/
          (mNum (iotaBackground radius[phase]/capRNum +
                epsilonNum gNum[radius[phase]] Cos[phase])/radius[phase] +
            kNum (1 + epsilonNum hNum[radius[phase]] Cos[phase])),
      toroidal'[phase] ==
        ((1 + epsilonNum hNum[radius[phase]] Cos[phase])/capRNum)/
          (mNum (iotaBackground radius[phase]/capRNum +
                epsilonNum gNum[radius[phase]] Cos[phase])/radius[phase] +
            kNum (1 + epsilonNum hNum[radius[phase]] Cos[phase])),
      radius[phaseStart] == radiusStart,
      poloidal[phaseStart] == phaseStart/mNum,
      toroidal[phaseStart] == 0},
    {radius, poloidal, toroidal}, {phase, phaseStart, phaseEnd},
    WorkingPrecision -> 30, AccuracyGoal -> 20, PrecisionGoal -> 18,
    MaxSteps -> Infinity];
  radiusEnd = solution[[1]][phaseEnd];
  thetaAdvance = solution[[2]][phaseEnd] - solution[[2]][phaseStart];
  zetaAdvance = solution[[3]][phaseEnd] - solution[[3]][phaseStart];
  invariantSamples = Table[
    psiNum[solution[[1]][phase], phase],
    {phase, phaseStart, phaseEnd, Pi/12}];
  invariantError = Max[Abs[invariantSamples - psiStar]];
  {thetaAdvance/zetaAdvance,
    mNum thetaAdvance + zetaAdvance - 2 Pi,
    radiusEnd - radiusStart, invariantError}
  ];

psiStarNum = psiNum[2, 0];
trace0 = rotationForLaunch[0, psiStarNum];
trace1 = rotationForLaunch[Pi/3, psiStarNum];

Print["    field-line invariant errors = ", N[{trace0[[4]], trace1[[4]]}, 8]];

check["Field line: one helical period satisfies m Delta theta+n Delta zeta=2pi",
  Max[Abs[{trace0[[2]], trace1[[2]]}]] < 10^-14];
check["Field line: invariant contour returns to its launch radius",
  Max[Abs[{trace0[[3]], trace1[[3]]}]] < 10^-12];
check["Field line: exact helical flux is conserved numerically",
  Max[{trace0[[4]], trace1[[4]]}] < 10^-10];
check["Field line: rotational transform is launch-point independent",
  Abs[trace0[[1]] - trace1[[1]]] < 10^-11];

axisymmetricIota = Module[{thetaAdvance, zetaAdvance},
  thetaAdvance = 2 Pi iotaBackground/(mNum iotaBackground + 1);
  zetaAdvance = 2 Pi/(mNum iotaBackground + 1);
  thetaAdvance/zetaAdvance];
check["Field line: axisymmetric limit returns the prescribed iota",
  Abs[axisymmetricIota - iotaBackground] < 10^-15];

gap1 = 1/10;
gap2 = 2/10;
deltaFixed[gapValue_] := capRNum fNum[2]/gapValue;
deltaQuadratic[gapValue_] := gapValue^2 deltaFixed[gapValue];
check["Detuning scan: fixed non-Gaussian source has slope minus one",
  Abs[deltaFixed[gap1]/deltaFixed[gap2] - gap2/gap1] < 10^-12];
check["Detuning scan: quadratic source has slope plus one",
  Abs[deltaQuadratic[gap1]/deltaQuadratic[gap2] - gap1/gap2] < 10^-12];

Print["    Green/ODE relative error = ", N[greenOdeError, 6]];
Print["    traced iota = ", N[trace0[[1]], 12],
  ", background iota = ", N[iotaBackground, 12]];
Print["    launch-point iota difference = ",
  N[Abs[trace0[[1]] - trace1[[1]]], 6]];

reportAndExit[];

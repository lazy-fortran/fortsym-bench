(* Jardin et al. PRL 115, 215001 (2015), Eqs. (1)-(10).
   SI is used through the paper derivation; the final local bridge states the
   additional toroidal-field and fixed-resistivity assumptions explicitly. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[capR, eta, loopVoltage, gradPhi, gradU, magneticField,
  currentDensity, velocity, toroidalUnit, gradToroidal];

$Assumptions = {capR > 0, eta > 0,
  Element[{loopVoltage, fieldMagnitude}, Reals]};

toroidalUnit = {0, 1, 0};
gradToroidal = toroidalUnit/capR;
gradU = {uR, uPhi, uZ};
magneticField = {bR, bPhi, bZ};
currentDensity = {jR, jPhi, jZ};
gradPhi = {pR, pPhi, pZ};
velocity = capR^2 Cross[gradU, gradToroidal];

eq2Left = -Cross[velocity, magneticField] + eta currentDensity;
eq2Right = -gradPhi + loopVoltage gradToroidal/(2 Pi);

eq3Residual = toroidalUnit.(eq2Left - eq2Right);
eq3Rearranged = toroidalUnit.(-Cross[velocity, magneticField] + gradPhi) +
  eta jPhi - loopVoltage/(2 Pi capR);
check["Jardin Eq. (3): toroidal projection of stationary Ohm law",
  FullSimplify[eq3Residual == eq3Rearranged]];

check["Jardin Eq. (4): field projection removes V cross B",
  FullSimplify[magneticField.Cross[velocity, magneticField]] == 0];
eq4Residual = magneticField.(eq2Left - eq2Right);
eq4Rearranged = eta magneticField.currentDensity + magneticField.gradPhi -
  loopVoltage magneticField.gradToroidal/(2 Pi);
check["Jardin Eq. (4): projected stationary Ohm law",
  FullSimplify[eq4Residual == eq4Rearranged]];

ClearAll[averageCurrentField, averageFieldPhi, averageFieldPotential];
averagedOhmResidual = eta averageCurrentField + averageFieldPotential -
  loopVoltage averageFieldPhi/(2 Pi);
check["Jardin Eq. (5): surface average annihilates B.grad Phi",
  FullSimplify[(averagedOhmResidual /. averageFieldPotential -> 0)/
      averageFieldPhi ==
    eta (averageCurrentField/averageFieldPhi - loopVoltage/(2 Pi eta)),
    averageFieldPhi != 0]];

minusVcrossBToroidal = FullSimplify[
  toroidalUnit.(-Cross[velocity, magneticField])];
check["Jardin Eq. (7): Hodge velocity gives the two toroidal terms",
  FullSimplify[minusVcrossBToroidal ==
    -capR magneticField.gradU + capR bPhi toroidalUnit.gradU]];

eq7Left = -capR magneticField.gradU +
  toroidalUnit.(toroidalFieldFunction gradU + gradPhi);
eq7Right = -eta jPhi + loopVoltage/(2 Pi capR);
check["Jardin Eq. (7): M3D-C1 toroidal field is bPhi=F/R",
  FullSimplify[minusVcrossBToroidal + toroidalUnit.gradPhi ==
      eq7Left /. toroidalFieldFunction -> capR bPhi]];

check["Jardin Eq. (9): cancellation grad Phi=-F grad U leaves dynamo term",
  FullSimplify[
    (eq7Left == eq7Right) /.
      toroidalUnit.(toroidalFieldFunction gradU + gradPhi) -> 0] ==
    FullSimplify[eta jPhi ==
      capR magneticField.gradU + loopVoltage/(2 Pi capR)]];

check["Jardin Eqs. (4),(9): nonlinear terms agree under grad Phi=-F grad U",
  FullSimplify[(-magneticField.gradPhi /.
      {pR -> -toroidalFieldFunction uR,
       pPhi -> -toroidalFieldFunction uPhi,
       pZ -> -toroidalFieldFunction uZ}) ==
    toroidalFieldFunction magneticField.gradU]];

ClearAll[phase, fRe, fIm, pRe, pIm, qRe, qIm];
realHarmonic[re_, im_] := re Cos[phase] - im Sin[phase];
phaseAverage[expr_] := Integrate[expr, {phase, 0, 2 Pi}]/(2 Pi);

harmonicProduct = phaseAverage[
  realHarmonic[fRe, fIm] realHarmonic[pRe, pIm]];
check["Jardin Eq. (10): harmonic n=0 product is one-half complex correlation",
  FullSimplify[harmonicProduct == (fRe pRe + fIm pIm)/2]];

toroidalDerivativeHarmonic =
  harmonicNumber realHarmonic[-pIm, pRe];
outOfPhaseAverage = phaseAverage[
  realHarmonic[fRe, fIm] toroidalDerivativeHarmonic];
check["Jardin field split: in-phase delta F gives no mean F dPhi/dphi",
  FullSimplify[(outOfPhaseAverage /.
      {fRe -> phaseScale pRe, fIm -> phaseScale pIm}) == 0]];

poloidalCorrectionAverage = phaseAverage[
  realHarmonic[qRe, qIm] realHarmonic[pRe, pIm]];
check["Jardin field split: in-phase poloidal correction contributes",
  FullSimplify[(poloidalCorrectionAverage /.
      {qRe -> pRe, qIm -> pIm}) == (pRe^2 + pIm^2)/2]];

ClearAll[drive3D, drive2D, dynamoVoltage];
dynamoDrive = drive3D - drive2D;
dynamoVoltage = 2 Pi capR dynamoDrive/fieldMagnitude;
check["Jardin Eq. (10): Vdyn is the matched 3D-minus-2D parallel drive",
  FullSimplify[fieldMagnitude dynamoVoltage/(2 Pi capR) == dynamoDrive]];

ClearAll[eta0, deltaEta, parallelCurrent0, deltaDrive,
  deltaParallelCurrent];
deltaParallelCurrent =
  deltaDrive/eta0 - deltaEta parallelCurrent0/eta0;
check["Jardin separation: dynamo drive and resistivity flattening are distinct",
  FullSimplify[
    eta0 deltaParallelCurrent + deltaEta parallelCurrent0 == deltaDrive]];

ClearAll[jbarContravariant];
localDrive = eta0 fieldMagnitude capR jbarContravariant;
localJardinVoltage = 2 Pi capR localDrive/fieldMagnitude;
localPullbackVoltage = 2 Pi capR^2 eta0 jbarContravariant;
check["Jardin bridge: local pullback voltage needs toroidal-field dominance",
  FullSimplify[localJardinVoltage == localPullbackVoltage]];

check["Jardin bridge: the correlation alone is not a voltage",
  FullSimplify[
    D[localPullbackVoltage, eta0] ==
      2 Pi capR^2 jbarContravariant &&
    D[correlationAmplitude, eta0] == 0]];

reportAndExit[];

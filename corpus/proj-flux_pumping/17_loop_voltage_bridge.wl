Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

$Assumptions = {rad > 0, eta > 0, capR > 0,
  Element[{alpha, chi, eps, dRe, dIm, jRe, jIm, eRe, eIm}, Reals]};

rho = r + eps delta0 Cos[chi + alpha];
jCorr = rho/r current[rho] Cos[chi];
jFirst = Coefficient[Normal@Series[jCorr, {eps, 0, 1}], eps];
jAverage = FullSimplify[Integrate[jFirst, {chi, 0, 2 Pi}]/(2 Pi)];
jExpected = delta0 Cos[alpha]/(2 r) D[r current[r], r];

check["corrugated-coordinate pullback gives the memo redistribution",
  FullSimplify[jAverage == jExpected]];

deltaField = dRe Cos[chi] - dIm Sin[chi];
currentField = jRe Cos[chi] - jIm Sin[chi];
complexAverage = Integrate[deltaField currentField, {chi, 0, 2 Pi}]/(2 Pi);
complexExpected = Re[(dRe + I dIm) Conjugate[jRe + I jIm]]/2;

check["real harmonic product equals one half of the complex correlation",
  FullSimplify[complexAverage == complexExpected]];
check["memo real-amplitude formula is the complex correlation at fixed phase",
  FullSimplify[(complexExpected /. {dRe -> delta0 Cos[alpha],
      dIm -> delta0 Sin[alpha], jRe -> current[r], jIm -> 0})
    == delta0 current[r] Cos[alpha]/2,
    Element[{delta0, current[r]}, Reals]]];
check["conjugate-harmonic sign reversal reverses the redistribution",
  FullSimplify[(complexExpected /. {jRe -> -jRe, jIm -> -jIm})
    == -complexExpected]];
check["an aligned potential has zero misalignment correlation",
  FullSimplify[complexExpected /. {jRe -> 0, jIm -> 0}] == 0];

boundaryCurrent[rr_] := Pi capR rr delta0 current[rr] Cos[alpha];
check["radial integration is the boundary current term",
  FullSimplify[D[boundaryCurrent[r], r] == 2 Pi capR r jExpected]];
check["a regular, decaying harmonic redistributes zero net current",
  FullSimplify[Integrate[
      2 Pi capR r (jExpected /. {delta0 -> 1,
        current -> Function[x, x Exp[-x^2/rad^2]]}),
      {r, 0, Infinity}]] == 0];

electricField = eRe Cos[chi] - eIm Sin[chi];
ohmicCurrent = electricField/eta;
ohmicCorrelation = Integrate[deltaField ohmicCurrent,
    {chi, 0, 2 Pi}]/(2 Pi);
electricCorrelation = Integrate[deltaField electricField,
    {chi, 0, 2 Pi}]/(2 Pi);

check["local Ohm response maps the helical voltage correlation to current",
  FullSimplify[ohmicCorrelation == electricCorrelation/eta]];

effectiveField = eta capR jExpected;
effectiveLoopVoltage = 2 Pi capR effectiveField;
check["effective loop voltage and redistributed current obey local Ohm law",
  FullSimplify[jExpected == effectiveLoopVoltage/(2 Pi capR^2 eta)]];

j0 = externalField/eta;
jPerturbed = Normal@Series[(externalField + eps dynamoField)/
    (eta + eps deltaEta), {eps, 0, 1}];
deltaJ = Coefficient[jPerturbed - j0, eps];
check["dynamo voltage and resistivity flattening are separate first-order terms",
  FullSimplify[deltaJ == dynamoField/eta - deltaEta j0/eta]];
check["negative dynamo voltage depletes the local current at fixed resistivity",
  FullSimplify[(deltaJ /. deltaEta -> 0) < 0, dynamoField < 0]];

coreProfile = jExpected /.
  current -> Function[x, x Exp[-x^2/rad^2]];
check["opposite phase gives negative central loop voltage and current change",
  FullSimplify[Limit[eta capR coreProfile /. alpha -> Pi, r -> 0] < 0,
    delta0 > 0]];

reportAndExit[];

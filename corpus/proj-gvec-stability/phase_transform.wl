ClearAll["Global`*"];
$Assumptions = Element[{a, b, c, d, m1, m2, r, s, phi1, phi2,
    kxx, kxy, kyy, mxx, mxy, myy, lambda, theta, zeta, baseM,
    baseN, envelopeM, envelopeN, xe, xo, ye, yo, referenceLength,
    radialIntervals, poloidalPoints, toroidalPoints}, Reals] &&
  kyy != 0 && radialIntervals != 0 && poloidalPoints != 0 &&
  toroidalPoints != 0;
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

stiffness = {{a, c + I d}, {c - I d, b}};
mass = {{m1, r + I s}, {r - I s, m2}};
phase = DiagonalMatrix[{Exp[I phi1], Exp[I phi2]}];
stiffnessPrime = ConjugateTranspose[phase].stiffness.phase;
massPrime = ConjugateTranspose[phase].mass.phase;

check["phase matrix is unitary",
  ConjugateTranspose[phase].phase == IdentityMatrix[2]];
check["stiffness remains Hermitian",
  stiffnessPrime == ConjugateTranspose[stiffnessPrime]];
check["mass remains Hermitian",
  massPrime == ConjugateTranspose[massPrime]];
check["generalized characteristic polynomial is invariant",
  Det[stiffnessPrime - lambda massPrime] ==
    Det[stiffness - lambda mass]];

base = baseM theta + baseN zeta;
envelope = envelopeM theta + envelopeN zeta;
xiEnvelope = xe Cos[envelope] Cos[base] +
  xo Sin[envelope] Sin[base];
xiSidebands = 1/2 (xe - xo) Cos[base + envelope] +
  1/2 (xe + xo) Cos[base - envelope];
etaEnvelope = ye Cos[envelope] Sin[base] +
  yo Sin[envelope] Cos[base];
etaSidebands = 1/2 (ye + yo) Sin[base + envelope] +
  1/2 (ye - yo) Sin[base - envelope];

check["normal phase-envelope product gives the two sidebands",
  TrigExpand[xiEnvelope - xiSidebands] == 0];
check["tangential phase-envelope product gives the two sidebands",
  TrigExpand[etaEnvelope - etaSidebands] == 0];
check["normal theta derivative commutes with the sideband map",
  TrigExpand[D[xiEnvelope, theta] - D[xiSidebands, theta]] == 0];
check["normal zeta derivative commutes with the sideband map",
  TrigExpand[D[xiEnvelope, zeta] - D[xiSidebands, zeta]] == 0];
check["tangential theta derivative commutes with the sideband map",
  TrigExpand[D[etaEnvelope, theta] - D[etaSidebands, theta]] == 0];
check["tangential zeta derivative commutes with the sideband map",
  TrigExpand[D[etaEnvelope, zeta] - D[etaSidebands, zeta]] == 0];

normalMap = 1/2 {{1, -1}, {1, 1}};
tangentialMap = 1/2 {{1, 1}, {1, -1}};
coefficientMap = ArrayFlatten[{{normalMap, ConstantArray[0, {2, 2}]},
    {ConstantArray[0, {2, 2}], tangentialMap}}];
check["normal sideband coefficient map has half identity Gram matrix",
  Transpose[normalMap].normalMap == 1/2 IdentityMatrix[2]];
check["tangential sideband coefficient map has half identity Gram matrix",
  Transpose[tangentialMap].tangentialMap == 1/2 IdentityMatrix[2]];
check["CAS3D2MN artificial mass is positive on all envelope coefficients",
  Eigenvalues[Transpose[coefficientMap].coefficientMap] ==
    ConstantArray[1/2, 4]];

(* Schwab (1991), eq. (3.4.3), treats the zero envelope harmonic
   exceptionally: its two sidebands coincide at the carrier, so its physical
   coefficient equals the even envelope coefficient without a factor 1/2.
   Every nonzero envelope harmonic retains the two-by-two map above. *)
carrierAndPairMap = ArrayFlatten[{{{{1}}, ConstantArray[0, {1, 2}]},
    {ConstantArray[0, {2, 1}], normalMap}}];
printedEnvelopeMass = 1/2 IdentityMatrix[3];
carrierAndPairInverse = Inverse[carrierAndPairMap];
inducedPhysicalMass = Transpose[carrierAndPairInverse].
  printedEnvelopeMass.carrierAndPairInverse;
check["zero envelope harmonic maps to the carrier without a half factor",
  carrierAndPairMap[[1, 1]] == 1];
check["printed envelope mass induces half carrier and full pair weights",
  inducedPhysicalMass == DiagonalMatrix[{1/2, 1, 1}]];
check["uniform physical-sideband identity misses the carrier exception",
  inducedPhysicalMass != IdentityMatrix[3]];

carrierPairK = {{3, 1, -2}, {1, 5, 1}, {-2, 1, 7}};
carrierPairEnvelopeK = Transpose[carrierAndPairMap].carrierPairK.
  carrierAndPairMap;
check["carrier-plus-pair generalized polynomial survives congruence",
  Det[carrierPairEnvelopeK - lambda printedEnvelopeMass] ==
    Det[carrierAndPairMap]^2 Det[carrierPairK - lambda inducedPhysicalMass]];

coefficientScale = referenceLength^3/(radialIntervals poloidalPoints
     toroidalPoints);
check["coefficient scale changes cubically with reference length",
  FullSimplify[(coefficientScale /. referenceLength -> 10 referenceLength)/
      coefficientScale] == 1000];

zero2 = ConstantArray[0, {2, 2}];
twoLabelNormalMap = ArrayFlatten[{{normalMap, zero2},
    {zero2, normalMap}}];
check["separate noncolliding labels have an invertible formal map",
  Det[twoLabelNormalMap] != 0];
check["the formal noncolliding map has the expected Gram matrix",
  Transpose[twoLabelNormalMap].twoLabelNormalMap ==
    1/2 IdentityMatrix[4]];

(* For base (3,2), five field periods and m=0 envelope labels -1 and +1,
   the labeled sidebands are (-3,7) and (7,-3) in opposite order.  The
   projection below merges equal physical Fourier functions. *)
canonicalMode[{modeM_, modeN_}] := Which[
  modeM < 0, {-modeM, -modeN},
  modeM == 0 && modeN < 0, {0, -modeN},
  True, {modeM, modeN}];
integerSidebands[envelopeNValue_] := {
  canonicalMode[{3, 2 + 5 envelopeNValue}],
  canonicalMode[{3, 2 - 5 envelopeNValue}]};
minusSidebands = integerSidebands[-1];
plusSidebands = integerSidebands[1];
check["Figure 6 m=0 conjugate labels collide by exact integer arithmetic",
  minusSidebands == Reverse[plusSidebands]];

uniquePhysicalProjection = {{1, 0, 0, 1}, {0, 1, 1, 0}};
physicalCoefficientMap = uniquePhysicalProjection.twoLabelNormalMap;
check["labeled-to-unique projection has exact collision rank loss",
  MatrixRank[uniquePhysicalProjection] == 2 &&
    Length[NullSpace[uniquePhysicalProjection]] == 2];
check["quotienting equal Fourier functions loses two envelope directions",
  MatrixRank[physicalCoefficientMap] == 2];

(* A physical bilinear form must factor through the unique Fourier
   coefficients.  Pulling it back to four colliding label coordinates gives
   a singular pencil whose null space is exactly the redundant-label kernel.
   It is not a four-dimensional generalized eigenproblem. *)
uniqueKFixture = {{-3, 1}, {1, 2}};
uniqueMFixture = {{2, 0}, {0, 3}};
collidingKFixture = Transpose[physicalCoefficientMap].uniqueKFixture.
  physicalCoefficientMap;
collidingMFixture = Transpose[physicalCoefficientMap].uniqueMFixture.
  physicalCoefficientMap;
check["physical mass pullback is singular at a sideband collision",
  MatrixRank[collidingMFixture] == 2 && Det[collidingMFixture] == 0];
check["redundant label directions vanish from physical stiffness and mass",
  And @@ ((collidingKFixture.# == ConstantArray[0, 4] &&
        collidingMFixture.# == ConstantArray[0, 4]) & /@
      NullSpace[physicalCoefficientMap])];

quotientLift = Transpose[physicalCoefficientMap].
  Inverse[physicalCoefficientMap.Transpose[physicalCoefficientMap]];
quotientKFixture = Transpose[quotientLift].collidingKFixture.quotientLift;
quotientMFixture = Transpose[quotientLift].collidingMFixture.quotientLift;
check["the canonical lift is a right inverse of the physical map",
  physicalCoefficientMap.quotientLift == IdentityMatrix[2]];
check["quotient stiffness equals the unique-mode stiffness",
  quotientKFixture == uniqueKFixture];
check["quotient mass equals the unique-mode mass",
  quotientMFixture == uniqueMFixture];
check["quotient generalized roots equal the unique physical roots",
  Det[quotientKFixture - lambda quotientMFixture] ==
    Det[uniqueKFixture - lambda uniqueMFixture]];

sidebandK = {{a, c, 0, d}, {c, b, -d, 0},
  {0, -d, a + b, r}, {d, 0, r, a + 2 b}};
sidebandM = IdentityMatrix[4];
envelopeK = Transpose[coefficientMap].sidebandK.coefficientMap;
envelopeM = Transpose[coefficientMap].sidebandM.coefficientMap;
check["phase-envelope stiffness congruence remains symmetric",
  envelopeK == Transpose[envelopeK]];
check["phase-envelope mass congruence remains symmetric",
  envelopeM == Transpose[envelopeM]];
check["phase-envelope congruence preserves generalized roots",
  Det[envelopeK - lambda envelopeM] ==
    Det[coefficientMap]^2 Det[sidebandK - lambda sidebandM]];

fullK = {{kxx, kxy}, {kxy, kyy}};
fullM = {{mxx, mxy}, {mxy, myy}};
zeroSchur = kxx - kxy^2/kyy;
shiftedSchur = kxx - lambda mxx -
  (kxy - lambda mxy)^2/(kyy - lambda myy);
zeroCondensedPencil = zeroSchur - lambda mxx;

check["zero-shift determinant factors through the stiffness Schur complement",
  Det[fullK] == kyy zeroSchur];
check["generalized determinant requires a lambda-dependent Schur complement",
  Det[fullK - lambda fullM] ==
    (kyy - lambda myy) shiftedSchur];
check["tangential mass makes zero-shift condensation spectrally different",
  FullSimplify[(shiftedSchur - zeroCondensedPencil) /. mxy -> 0] ==
    -lambda myy kxy^2/(kyy (kyy - lambda myy))];
check["zero-shift condensation remains exact at marginality",
  FullSimplify[(shiftedSchur - zeroCondensedPencil) /. lambda -> 0] == 0];

fixtureK = {{2, 3}, {3, 2}};
fixtureM = IdentityMatrix[2];
fixtureFullSpectrum = Eigenvalues[{fixtureK, fixtureM}];
fixtureCondensed = fixtureK[[1, 1]] -
  fixtureK[[1, 2]]^2/fixtureK[[2, 2]];
check["exact full generalized fixture spectrum",
  Sort[fixtureFullSpectrum] == {-1, 5}];
check["exact zero-shift condensed fixture eigenvalue",
  fixtureCondensed == -5/2];
check["fixture preserves the marginal inertia count",
  Count[fixtureFullSpectrum, value_ /; value < 0] ==
    Boole[fixtureCondensed < 0]];
check["fixture finite eigenvalue changes under zero-shift condensation",
  Min[fixtureFullSpectrum] != fixtureCondensed];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

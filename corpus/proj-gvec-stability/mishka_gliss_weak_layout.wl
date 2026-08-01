ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Local covariant magnetic fields used by the GLISS kernel. *)
bContravariant = {fp/jac, ft/jac};
tangentialMetric = {{gtt, gtz}, {gtz, gzz}};
{bTheta, bZeta} = tangentialMetric . bContravariant;
bSquared = bContravariant . tangentialMetric . bContravariant;
check["local covariant-field contraction",
 FullSimplify[fp bTheta + ft bZeta == jac bSquared,
  Element[{fp, ft, jac, gtt, gtz, gzz}, Reals] && jac != 0]];

jTheta = (betaZeta - iPrime)/jac;
jZeta = (jPrime - betaTheta)/jac;
check["local current-field contraction",
 FullSimplify[jTheta bTheta + jZeta bZeta ==
   ((betaZeta - iPrime) bTheta +
      (jPrime - betaTheta) bZeta)/jac,
  Element[{betaZeta, betaTheta, iPrime, jPrime}, Reals] && jac != 0]];

(* An explicit varying-metric counterexample excludes surface averages. *)
fixtureMetric[angle_] := {{2 + Cos[angle]/5, Sin[angle]/10},
  {Sin[angle]/10, 3}};
fixtureB = {2/5, -7/10};
fixtureJac = 9/5;
fixtureFlux = fixtureJac fixtureB;
fixtureCovariant[angle_] := fixtureMetric[angle] . fixtureB;
fixtureBSquared[angle_] := fixtureB . fixtureMetric[angle] . fixtureB;
fixtureAverage = Integrate[fixtureCovariant[angle], {angle, 0, 2 Pi}]/(2 Pi);
check["local fixture obeys B squared Jacobian identity",
 FullSimplify[fixtureFlux . fixtureCovariant[angle] ==
   fixtureJac fixtureBSquared[angle]]];
check["surface-averaged covariant field fails locally",
 FullSimplify[fixtureFlux . fixtureAverage !=
   fixtureJac fixtureBSquared[0]]];
fixtureCurrent = {1/5, 3/10}/fixtureJac;
check["surface average also corrupts local j dot B",
 FullSimplify[fixtureCurrent . fixtureAverage !=
   fixtureCurrent . fixtureCovariant[0]]];

(* Axisymmetric HELENA/MISHKA field and current identities. *)
axisJacobian = p[r] q[r] radiusSquared[r, theta]/t[r];
axisBTheta = q[r] gradPsiSquared[r, theta]/t[r];
axisBZeta = t[r];
axisBRadial = -p[r] q[r] gradPsiTheta[r, theta]/t[r];
axisBSquared = (t[r]^2 + gradPsiSquared[r, theta])/
  radiusSquared[r, theta];
check["MISHKA local covariant fields reproduce B squared Jacobian",
 FullSimplify[p[r] axisBTheta + p[r] q[r] axisBZeta ==
   axisJacobian axisBSquared,
  p[r] != 0 && q[r] != 0 && t[r] != 0 && radiusSquared[r, theta] != 0]];

axisJTheta = -D[axisBZeta, r]/axisJacobian;
axisJZeta = (D[axisBTheta, r] - D[axisBRadial, theta])/axisJacobian;
axisJDotB = axisJTheta axisBTheta + axisJZeta axisBZeta;
axisJDotBExpected = t[r]/(p[r] q[r] radiusSquared[r, theta]) *
  (q'[r] gradPsiSquared[r, theta] +
    q[r] D[gradPsiSquared[r, theta], r] -
    2 q[r] gradPsiSquared[r, theta] t'[r]/t[r] +
    p[r] q[r] D[gradPsiTheta[r, theta], theta]);
check["MISHKA axisymmetric j dot B identity",
 FullSimplify[axisJDotB == axisJDotBExpected,
  p[r] != 0 && q[r] != 0 && t[r] != 0 && radiusSquared[r, theta] != 0]];

(* MISHKA's generalized off-diagonal coefficient must reduce exactly on the
   diagonal. This pins the n q versus n cancellation in A(2,1). *)
mishkaA21GPGT = -I (mTrial + n q0) *
  (mTrial - mTest + n q0)/(q0 t0);
check["MISHKA A21 diagonal n q cancellation",
 FullSimplify[(mishkaA21GPGT /. {mTest -> m, mTrial -> m}) ==
   -I n (m + n q0)/t0, q0 != 0 && t0 != 0]];

(* Exact layout translation used by the numerical comparison gate. *)
layoutTransform = DiagonalMatrix[
  {1/edgeFlux, 1/(dsdr edgeFlux), I majorRadius^2 edgeFlux/(p0 q0)}];
mishkaTest = Array[test, 3];
mishkaTrial = Array[trial, 3];
glissTest = layoutTransform . mishkaTest;
glissTrial = layoutTransform . mishkaTrial;
glissKernel = Array[kernel, {3, 3}];
translatedKernel = dsdr ConjugateTranspose[layoutTransform] .
  glissKernel . layoutTransform;
layoutAssumptions = Element[{edgeFlux, dsdr, majorRadius, p0, q0}, Reals] &&
  edgeFlux != 0 && dsdr != 0 && p0 != 0 && q0 != 0;
check["component congruence and radial-measure translation",
 FullSimplify[
  dsdr Conjugate[glissTest] . glissKernel . glissTrial ==
   Conjugate[mishkaTest] . translatedKernel . mishkaTrial,
  layoutAssumptions]];

(* GLISS stores real cosine normal amplitudes and real sine tangential
   amplitudes.  In the complex Fourier layout used for the MISHKA congruence,
   those amplitudes are c_normal and -i c_tangential.  The real harmonic
   bilinear form is one half of the real part of the complex form. *)
realFourierAssumptions =
  Element[{aNormal, aTangential, bNormal, bTangential, phase}, Reals];
check["normal cosine amplitude in complex layout",
 FullSimplify[
  ComplexExpand[Re[aNormal Exp[I phase]]] == aNormal Cos[phase],
  realFourierAssumptions]];
check["tangential sine amplitude in complex layout",
 FullSimplify[
  ComplexExpand[Re[-I aTangential Exp[I phase]]] ==
   aTangential Sin[phase], realFourierAssumptions]];
realHarmonicProduct = Integrate[
   (aNormal Cos[phase] + aTangential Sin[phase]) *
    (bNormal Cos[phase] + bTangential Sin[phase]),
   {phase, 0, 2 Pi}]/(2 Pi);
complexHarmonicProduct = 1/2 Re[
   Conjugate[aNormal - I aTangential] *
    (bNormal - I bTangential)];
check["real harmonic energy is half the complex form",
 FullSimplify[realHarmonicProduct == complexHarmonicProduct,
  realFourierAssumptions]];

(* The incompressible comparison has four physical terms.  Plasma
   compressibility is a fifth term in the compressible GLISS model and is
   absent here by model choice.  Congruence and radial measure distribute over
   the term sum, so comparing the translated sum with MISHKA cannot hide a
   change of component layout between terms. *)
incompressibleTermNames = {"field_line_bending", "magnetic_shear",
  "magnetic_compression", "pressure_drive"};
check["incompressible physical term order is complete",
 Length[incompressibleTermNames] == 4 &&
  DuplicateFreeQ[incompressibleTermNames]];
termKernels = Table[Array[term[index], {3, 3}], {index, 4}];
translatedTerms =
  dsdr ConjugateTranspose[layoutTransform] . # . layoutTransform & /@
   termKernels;
check["termwise congruence sums to total congruence",
 FullSimplify[Total[translatedTerms] ==
   dsdr ConjugateTranspose[layoutTransform] . Total[termKernels] .
    layoutTransform, layoutAssumptions]];

normalBasis = {h[r], h'[r], 0};
tangentialBasis = {0, 0, l[r]};
check["normal layout includes value and radial derivative",
 normalBasis[[1 ;; 2]] == {h[r], h'[r]}];
check["tangential layout occupies only the third component",
 tangentialBasis == {0, 0, l[r]}];

(* The same displacement congruence appears in both quadratic forms and
   therefore cancels from the generalized eigenvalue. The remaining physical
   scales fix the sign and units of the global spectral comparison. *)
stiffnessScale = 2 Pi^2 majorRadius^3/mu0;
massScale = 2 Pi^2 majorRadius^5 density;
normalizationAssumptions =
  Element[{majorRadius, mu0, density, lambdaMishka, lambdaGliss}, Reals] &&
   majorRadius > 0 && mu0 > 0 && density > 0;
check["global stiffness-to-mass scale",
 FullSimplify[massScale/stiffnessScale == mu0 density majorRadius^2,
  normalizationAssumptions]];

(* K_GLISS = -stiffnessScale A_MISHKA and
   M_GLISS = massScale B_MISHKA. *)
lambdaGlissFromMishka =
  -stiffnessScale lambdaMishka/massScale;
lambdaMishkaFromGliss = -massScale lambdaGliss/stiffnessScale;
check["MISHKA-to-GLISS eigenvalue normalization",
 FullSimplify[lambdaGlissFromMishka ==
   -lambdaMishka/(mu0 density majorRadius^2),
  normalizationAssumptions]];
check["GLISS-to-MISHKA eigenvalue normalization",
 FullSimplify[lambdaMishkaFromGliss ==
   -mu0 density majorRadius^2 lambdaGliss,
  normalizationAssumptions]];
check["normalization maps MISHKA unstable sign to GLISS negative sign",
 FullSimplify[lambdaGlissFromMishka < 0,
  normalizationAssumptions && lambdaMishka > 0]];
check["physical-mass GLISS level scales inversely with density",
 FullSimplify[
  (-lambdaMishka/(mu0 density2 majorRadius^2))/
    (-lambdaMishka/(mu0 density1 majorRadius^2)) == density1/density2,
  normalizationAssumptions && lambdaMishka != 0 &&
   Element[{density1, density2}, Reals] && density1 > 0 && density2 > 0]];

(* Global radial-coordinate translation. MISHKA uses
   r = sqrt(psi_p/psi_p,edge), whereas GLISS uses normalized toroidal flux.
   The two coordinates agree with r^2 only for constant q (up to the edge
   normalization).  The exact integrated-q map is mandatory for comparing a
   profile away from the axis. *)
toroidalFlux[r_] = Integrate[2 u psiEdge qProfile[u], {u, 0, r},
  Assumptions -> r > 0];
normalizedToroidalFlux[r_] = toroidalFlux[r]/phiEdge;
check["integrated-q toroidal coordinate derivative",
 FullSimplify[D[normalizedToroidalFlux[r], r] ==
   2 r psiEdge qProfile[r]/phiEdge,
  r > 0 && psiEdge != 0 && phiEdge != 0]];
check["constant-q coordinate reduces to radius squared",
 FullSimplify[(normalizedToroidalFlux[r] /. {
      qProfile[u_] :> qAxis, phiEdge -> psiEdge qAxis}) == r^2,
  r > 0 && psiEdge != 0 && qAxis != 0]];
variableQFlux = FullSimplify[
  normalizedToroidalFlux[r] /. {
    qProfile[u_] :> 1 + a u^2, phiEdge -> psiEdge (1 + a/2)}];
check["variable-q coordinate is not radius squared",
 FullSimplify[variableQFlux != r^2,
  0 < r < 1 && a > 0 && psiEdge != 0]];
axisFlux = Integrate[
   2 u psiEdge (qAxis + qSlope u + qCurve u^2), {u, 0, r}]/phiEdge;
check["integrated-q coordinate remains quadratic on axis",
 FullSimplify[Limit[axisFlux/r^2, r -> 0] ==
   psiEdge qAxis/phiEdge,
  Element[{psiEdge, phiEdge, qAxis, qSlope, qCurve}, Reals] &&
   phiEdge != 0 && qAxis != 0]];

(* Axis-space translation. On MISHKA's first
   cell x=r/h, the left cubic value and slope slots are H2 and H4; the left
   quadratic value slot is H4 because H2 is identically zero. Its source
   constrains the value slot of v1 for every m, and also its slope slot for
   |m|>1. It constrains the unused quadratic slot for every m, and also the
   quadratic value slot for |m|>1. These exact polynomials pin the surviving
   leading powers without an inferred continuum limit. *)
cubicRightValue[x_] = 3 x^2 - 2 x^3;
cubicLeftValue[x_] = 3 (1 - x)^2 - 2 (1 - x)^3;
cubicRightSlope[x_, h_] = h (x - 1) x^2;
cubicLeftSlope[x_, h_] = h x (1 - x)^2;
quadraticBubble[x_] = 4 x (1 - x);
quadraticRightValue[x_] = 2 (x - 1/2) x;
quadraticLeftValue[x_] = 2 (x - 1/2) (x - 1);

check["MISHKA cubic left value and slope slots",
 FullSimplify[{cubicLeftValue[0],
    D[cubicLeftSlope[x, h], x]/h /. x -> 0} == {1, 1}, h != 0]];
check["MISHKA quadratic left value slot",
 quadraticLeftValue[0] == 1 && quadraticBubble[0] == 0 &&
  quadraticRightValue[0] == 0];
check["MISHKA m=1 normal survivor is linear in radius",
 FullSimplify[Limit[cubicLeftSlope[x, h]/(h x), x -> 0] == 1]];
check["MISHKA m=1 tangential survivor is constant in radius",
 FullSimplify[Limit[quadraticLeftValue[x], x -> 0] == 1]];
check["MISHKA m=2 normal survivors are quadratic in radius",
 FullSimplify[{Limit[cubicRightValue[x]/x^2, x -> 0],
    Limit[cubicRightSlope[x, h]/(h x^2), x -> 0]} == {3, -1}]];
check["MISHKA m=2 tangential survivors are linear in radius",
 FullSimplify[{Limit[quadraticBubble[x]/x, x -> 0],
    Limit[quadraticRightValue[x]/x, x -> 0]} == {4, -1}]];

(* The pointwise component congruence contains
   eta_GLISS = i R0^2 Phi_edge v2/(p q), with p=2 r psi_edge.
   Therefore v1~r^m and v2~r^(m-1) become xi~r^m and
   eta~r^(m-2). The exact integrated-q GLISS coordinate is proportional to
   r^2 on axis, so a constrained H1 function starts as s while an L2 function
   starts as one. Multiplying both by s^(-storedPower),
   storedPower=1-m/2, gives exactly those two leading orders. *)
axisMapAssumptions = Element[{r, qAxis, psiEdge}, Reals] &&
  r > 0 && qAxis != 0 && psiEdge != 0;
mishkaP = 2 r psiEdge;
check["MISHKA eta layout contributes one inverse radius",
 FullSimplify[(1/(mishkaP qAxis))/(1/(2 psiEdge qAxis)) == 1/r,
  axisMapAssumptions]];
storedPower[m_] = 1 - m/2;
check["weighted GLISS normal order matches MISHKA for m=1,2",
 FullSimplify[
  And @@ Table[(r^2) (r^2)^(-storedPower[m]) == r^m, {m, 1, 2}],
  r > 0]];
check["weighted GLISS eta order matches translated MISHKA for m=1,2",
 FullSimplify[
  And @@ Table[(r^2)^(-storedPower[m]) == r^(m - 2), {m, 1, 2}],
  r > 0]];
check["MISHKA-compatible m=0 special exponent",
 FullSimplify[{(r^2) (r^2)^(-1/2), (r^2)^(-1/2)} == {r, 1/r},
  r > 0]];

(* Floating-point certificate for the term-resolved energy identity. The
   compensated quadratic form is not trusted circularly: its distance from an
   ordinary nested evaluation is added to the ordinary evaluation's standard
   gamma_n forward bound. The assembled total may also differ from the exact
   sum of four stored term matrices by the four-term reduction error. *)
gamma[k_] = k unitRoundoff/(1 - k unitRoundoff);
roundoffAssumptions =
  Element[{unitRoundoff, absoluteContribution, compensatedValue,
    ordinaryValue, exactValue, potentialError, matrixError,
    termSumError, termError1, termError2, termError3, termError4,
    potentialBound, matrixBound, termSumBound, termBound1, termBound2,
    termBound3, termBound4, ordinaryErrorBound, energyScale,
    closureTolerance, totalBound}, Reals] &&
   Element[{dimension, operations}, Integers] &&
   0 < unitRoundoff < 1/100 && absoluteContribution >= 0 &&
   potentialBound >= 0 && matrixBound >= 0 && termSumBound >= 0 &&
   termBound1 >= 0 && termBound2 >= 0 && termBound3 >= 0 &&
   termBound4 >= 0 && ordinaryErrorBound >= 0 && energyScale > 0 &&
   closureTolerance >= 0 && totalBound >= 0;
ordinaryBound = gamma[2 dimension + 2] absoluteContribution;
check["gamma factor is positive below its operation-count pole",
 FullSimplify[gamma[operations] > 0,
  0 < unitRoundoff && operations > 0 && operations unitRoundoff < 1]];
check["compensated value is enclosed without trusting compensation",
 FullSimplify[
  Abs[compensatedValue - exactValue] <=
   Abs[compensatedValue - ordinaryValue] + ordinaryErrorBound,
  roundoffAssumptions &&
   Abs[ordinaryValue - exactValue] <= ordinaryErrorBound]];
check["ordinary nested quadratic-form bound is positive",
 FullSimplify[ordinaryBound >= 0,
  roundoffAssumptions && dimension > 0 &&
   (2 dimension + 2) unitRoundoff < 1]];

closureError = potentialError + matrixError - termSumError -
  termError1 - termError2 - termError3 - termError4;
closureBound = potentialBound + matrixBound + termSumBound +
  termBound1 + termBound2 + termBound3 + termBound4;
check["term-resolved energy closure follows by the triangle inequality",
 FullSimplify[-closureBound <= closureError <= closureBound,
  roundoffAssumptions && -potentialBound <= potentialError <= potentialBound &&
   -matrixBound <= matrixError <= matrixBound &&
   -termSumBound <= termSumError <= termSumBound &&
   -termBound1 <= termError1 <= termBound1 &&
   -termBound2 <= termError2 <= termBound2 &&
   -termBound3 <= termError3 <= termBound3 &&
   -termBound4 <= termError4 <= termBound4]];
check["four-term matrix reduction uses a finite positive gamma factor",
 FullSimplify[0 < gamma[4] < 1,
  0 < unitRoundoff < 1/8]];
check["bounded closure and bounded conditioning imply physical closure",
 FullSimplify[
  -closureTolerance energyScale <= certifiedClosure <=
   closureTolerance energyScale,
  Element[{certifiedClosure, totalBound, closureTolerance, energyScale},
    Reals] &&
   totalBound >= 0 && closureTolerance >= 0 && energyScale > 0 &&
   -totalBound <= certifiedClosure <= totalBound &&
   totalBound <= closureTolerance energyScale]];

(* Cross-space static condensation used by the mode-energy gate.  MISHKA
   supplies the normal coordinate.  GLISS varies only its tangential L2
   coordinate, so the result is a genuine Ritz trial vector rather than a
   copied MISHKA kernel or an independently solved GLISS eigenvector. *)
blockEnergy = kxx normal^2 + 2 kxe normal eta + kee eta^2;
ritzEta = -kxe normal/kee;
ritzAssumptions = Element[{kxx, kxe, kee, normal, eta}, Reals] && kee > 0;
check["static condensation is stationary in the tangential coordinate",
 FullSimplify[(D[blockEnergy, eta] /. eta -> ritzEta) == 0,
  ritzAssumptions]];
check["static condensation completes the energy square",
 FullSimplify[blockEnergy ==
   (kxx - kxe^2/kee) normal^2 + kee (eta - ritzEta)^2,
  ritzAssumptions]];
check["an incompatible tangential interpolation adds nonnegative energy",
 FullSimplify[blockEnergy - (blockEnergy /. eta -> ritzEta) >= 0,
  ritzAssumptions]];

matrixKxx = {{5, 1}, {1, 4}};
matrixKxe = {{1, 2}, {-1, 1}};
matrixKee = {{6, 1}, {1, 5}};
matrixNormal = {2, -1};
matrixEtaRitz = -Inverse[matrixKee] . Transpose[matrixKxe] . matrixNormal;
matrixEta = {eta1, eta2};
matrixEnergy[etaVector_] :=
  matrixNormal . matrixKxx . matrixNormal +
   2 matrixNormal . matrixKxe . etaVector +
   etaVector . matrixKee . etaVector;
check["matrix static condensation solves the exact block equation",
 matrixKee . matrixEtaRitz + Transpose[matrixKxe] . matrixNormal == {0, 0}];
check["matrix energy penalty is the positive block quadratic form",
 FullSimplify[matrixEnergy[matrixEta] - matrixEnergy[matrixEtaRitz] ==
   (matrixEta - matrixEtaRitz) . matrixKee .
    (matrixEta - matrixEtaRitz), Element[{eta1, eta2}, Reals]]];

counterK = {{4, 1}, {1, 3}};
counterVector = {1, -1/3};
check["static condensation does not manufacture an eigenvector",
 Det[Transpose[{counterK . counterVector, counterVector}]] != 0];
check["Ritz quotient is invariant under phase-fit scaling",
 FullSimplify[
  ((scale counterVector) . counterK . (scale counterVector))/
    ((scale counterVector) . (scale counterVector)) ==
   (counterVector . counterK . counterVector)/
    (counterVector . counterVector),
  Element[scale, Reals] && scale != 0]];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

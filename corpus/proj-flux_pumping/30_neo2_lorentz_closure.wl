Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[eta0, eta1, constantDistribution];
bandIntegral = Integrate[constantDistribution, {eta, eta0, eta1}];
check["Band representation: constant f is stored as delta eta times f",
  FullSimplify[bandIntegral == constantDistribution (eta1 - eta0),
    eta1 > eta0]];

ClearAll[theta, eta, b0, hTheta, kappa, constantG, trialG];
lambdaAbs = Sqrt[1 - b0 eta];
diffusionCoefficient = 2 kappa lambdaAbs eta/hTheta;
lorentzOperator[function_] :=
  D[function, theta] -
    D[diffusionCoefficient D[function, eta], eta];

check["Continuous Lorentz equation: a constant distribution is a right null",
  FullSimplify[lorentzOperator[constantG] == 0,
    b0 > 0 && hTheta != 0]];
check["Continuous Lorentz flux: the eta=0 boundary coefficient vanishes",
  FullSimplify[(diffusionCoefficient /. eta -> 0) == 0,
    b0 > 0 && hTheta != 0]];
check["Continuous Lorentz flux: the mirror-boundary coefficient vanishes",
  FullSimplify[(diffusionCoefficient /. eta -> 1/b0) == 0,
    b0 > 0 && hTheta != 0]];

ClearAll[collisionFlux0, collisionFlux1, collisionFlux2,
  collisionFlux3];
collisionFluxPolynomial = collisionFlux0 + collisionFlux1 eta +
  collisionFlux2 eta^2 + collisionFlux3 eta^3;
check["Continuous Lorentz flux: the pitch divergence is a boundary term",
  FullSimplify[
    Integrate[-D[collisionFluxPolynomial, eta], {eta, eta0, eta1}] ==
      (collisionFluxPolynomial /. eta -> eta0) -
        (collisionFluxPolynomial /. eta -> eta1)]];

(* Streaming through the moving trapped-passing boundary eta_b(theta):
   the Leibniz rule produces the boundary term eta_b'(theta) g(eta_b) in
   each co-/counter-passing half; the mirror condition g+ = g- at eta_b
   cancels the pair.  Derived from D of the integral, not assumed. *)
ClearAll[gPlus, gMinus, etaBoundary, period, netStream];
streamingPlus = D[Integrate[gPlus[theta, eta],
  {eta, 0, etaBoundary[theta]}], theta];
streamingMinus = D[Integrate[gMinus[theta, eta],
  {eta, 0, etaBoundary[theta]}], theta];
interiorPart = Integrate[D[gPlus[theta, eta], theta],
    {eta, 0, etaBoundary[theta]}] -
  Integrate[D[gMinus[theta, eta], theta],
    {eta, 0, etaBoundary[theta]}];
movingBoundaryTerm = FullSimplify[
  streamingPlus - streamingMinus - interiorPart];
check["Continuous streaming: Leibniz rule isolates the moving-boundary term etaB' (g+ - g-)",
  FullSimplify[movingBoundaryTerm ==
    etaBoundary'[theta] (gPlus[theta, etaBoundary[theta]] -
      gMinus[theta, etaBoundary[theta]])]];
check["Continuous streaming: mirror matching g+=g- cancels the moving pitch boundary",
  FullSimplify[(movingBoundaryTerm /. gMinus -> gPlus) == 0]];

(* The remaining streaming boundary integral telescopes to the endpoint
   difference of the passing densities and vanishes for periodic data.
   Verified on a four-coefficient trigonometric family (Mathematica does
   not evaluate the abstract fundamental-theorem integral). *)
netStreamFamily = c0 + c1 Cos[theta] + s1 Sin[theta] + c2 Cos[2 theta];
check["Continuous streaming: the remaining boundary integral telescopes and vanishes periodically",
  FullSimplify[Integrate[D[netStreamFamily, theta], {theta, 0, capT},
        Assumptions -> capT > 0] ==
      (netStreamFamily /. theta -> capT) -
        (netStreamFamily /. theta -> 0)] &&
  FullSimplify[Integrate[D[netStreamFamily, theta],
      {theta, 0, 2 Pi}] == 0]];

ClearAll[electricAmplitude, sigma];
electricSource[sign_] := sign electricAmplitude;
check["[definition] Continuous source: the parallel-electric drive is odd in sigma, hence pointwise compatible",
  electricSource[1] + electricSource[-1] == 0];

pitchIntegral = Integrate[(2 - b0 eta)/Sqrt[1 - b0 eta],
  {eta, 0, 1/b0}, Assumptions -> b0 > 0];
check["Continuous source: the radial-drift pitch integral is 8/(3 B)",
  FullSimplify[pitchIntegral == 8/(3 b0), b0 > 0]];

ClearAll[periodicB];
check["Continuous source: the axisymmetric Boozer radial drive is a total derivative",
  FullSimplify[
    D[-1/periodicB[theta], theta] ==
      periodicB'[theta]/periodicB[theta]^2,
    periodicB[theta] != 0]];
radialPeriodIntegral = -1/periodicB[period] + 1/periodicB[0];
check["Continuous source: the axisymmetric radial drive is globally compatible",
  FullSimplify[
    (radialPeriodIntegral /.
      periodicB[period] -> periodicB[0]) == 0,
    periodicB[0] != 0]];

bandFluxes = Array[collisionBandFlux, 5, 0];
bandDivergences = Table[
  collisionBandFlux[index - 1] - collisionBandFlux[index],
  {index, 1, 4}];
check["Band finite volume: internal Lorentz fluxes telescope exactly",
  Total[bandDivergences] == collisionBandFlux[0] - collisionBandFlux[4]];

ClearAll[mu, w1, w2, q1, q2, q3, l1, l2, l3];
particleInvariant = {1, 1, 1};
constantBand = {w1, w2, mu - w1 - w2};
source = {q1, q2, q3};
flux = {l1, l2, l3};
projector = IdentityMatrix[3] -
  Outer[Times, constantBand, particleInvariant]/mu;

check["Global projector: particle invariant annihilates projected source",
  FullSimplify[particleInvariant.projector.source == 0, mu != 0]];
check["Global projector: constant-distribution direction is removed",
  FullSimplify[projector.constantBand == {0, 0, 0}, mu != 0]];
check["Global projector: operation is idempotent",
  FullSimplify[projector.projector == projector, mu != 0]];
check["Global projector: a compatible physical source is unchanged",
  FullSimplify[projector.source == source,
    mu != 0 && particleInvariant.source == 0]];

projectedFlux = flux.projector;
check["Dual correction: projected flux annihilates the gauge direction",
  FullSimplify[projectedFlux.constantBand == 0, mu != 0]];
check["Dual correction: source and flux corrections preserve the pairing",
  FullSimplify[projectedFlux.source == flux.(projector.source), mu != 0]];

ClearAll[c1, c2, c3, u1, u2, u3];
currentCovector = {c1, c2, c3, -c1, -c2, -c3};
constantBoundaryState = {u1, u2, u3, u1, u2, u3};
check["Physical current: an isotropic constant gauge carries no parallel current",
  currentCovector.constantBoundaryState == 0];

ClearAll[a11, a12, a13, a21, a22, a23, x1, x2, y1, y2];
leftConservingMap = {
  {a11, a12, a13},
  {a21, a22, a23},
  {1 - a11 - a21, 1 - a12 - a22, 1 - a13 - a23}};
incomingBand = {x1, x2, mu - x1 - x2};
outgoingBand = {y1, y2, mu - y1 - y2};
projectorIn = IdentityMatrix[3] -
  Outer[Times, incomingBand, particleInvariant]/mu;
projectorOut = IdentityMatrix[3] -
  Outer[Times, outgoingBand, particleInvariant]/mu;
transportDefect = leftConservingMap.incomingBand - outgoingBand;

check["Local map: column normalization transports the left invariant",
  FullSimplify[particleInvariant.leftConservingMap == particleInvariant]];
check["Local projector: commutator is the right-transport defect outer product",
  FullSimplify[
    projectorOut.leftConservingMap - leftConservingMap.projectorIn ==
      Outer[Times, transportDefect, particleInvariant]/mu, mu != 0]];
check["Local projector: exact constant-f transport implies intertwining",
  FullSimplify[
    ((projectorOut.leftConservingMap - leftConservingMap.projectorIn) /.
      {y1 -> (leftConservingMap.incomingBand)[[1]],
       y2 -> (leftConservingMap.incomingBand)[[2]]}) ==
      ConstantArray[0, {3, 3}], mu != 0]];
check["Local projector: left conservation alone does not remove the commutator",
  FullSimplify[
    ((projectorOut.leftConservingMap - leftConservingMap.projectorIn) /.
      {mu -> 1, x1 -> 1/5, x2 -> 1/4, y1 -> 1/3, y2 -> 1/6,
       a11 -> 1/2, a12 -> 1/3, a13 -> 1/4,
       a21 -> 1/5, a22 -> 1/4, a23 -> 1/3}) !=
      ConstantArray[0, {3, 3}]]];

ClearAll[m1, m2, m3, s1, s2, s3, state0];
map1 = Array[m1, {3, 3}];
map2 = Array[m2, {3, 3}];
map3 = Array[m3, {3, 3}];
localSource1 = Array[s1, 3];
localSource2 = Array[s2, 3];
localSource3 = Array[s3, 3];
initialState = Array[state0, 3];
state1 = map1.initialState + localSource1;
state2 = map2.state1 + localSource2;
state3 = map3.state2 + localSource3;
globalMap = map3.map2.map1;
globalSource = map3.map2.localSource1 + map3.localSource2 + localSource3;

check["Affine composition: three local propagators give the joined map and source",
  Expand[state3] == Expand[globalMap.initialState + globalSource]];

ClearAll[d1, d2, d3, z1, z2, z3];
globalCorrection = Array[d1, 3];
freeCorrection = Array[z1, 3];
decompositionA = {ConstantArray[0, 3], ConstantArray[0, 3],
  globalCorrection};
decompositionB = {ConstantArray[0, 3], freeCorrection,
  globalCorrection - map3.freeCorrection};
composeCorrection[parts_] :=
  map3.map2.parts[[1]] + map3.parts[[2]] + parts[[3]];

check["Affine source: a correction placed at the final map reproduces the global correction",
  Expand[composeCorrection[decompositionA]] == globalCorrection];
check["Affine source: an arbitrary upstream correction has a compensating downstream family",
  Expand[composeCorrection[decompositionB]] == globalCorrection];
check["Affine source: global correction does not determine a unique local decomposition",
  decompositionA =!= decompositionB];

ClearAll[aa, ab, ba, bb, ca, cb, u0, r1, r2, t1, t2];
invariant2 = {1, 1};
band0 = {u0, mu - u0};
affineMap1 = {{aa, ab}, {1 - aa, 1 - ab}};
affineMap2 = {{ba, bb}, {1 - ba, 1 - bb}};
band1 = affineMap1.band0;
band2 = affineMap2.band1;
projector0 = IdentityMatrix[2] - Outer[Times, band0, invariant2]/mu;
projector1 = IdentityMatrix[2] - Outer[Times, band1, invariant2]/mu;
projector2 = IdentityMatrix[2] - Outer[Times, band2, invariant2]/mu;
affineSource1 = {r1, r2};
affineSource2 = {t1, t2};

check["Commuting projectors: first map transports its endpoint projectors",
  FullSimplify[projector1.affineMap1 == affineMap1.projector0, mu != 0]];
check["Commuting projectors: second map transports its endpoint projectors",
  FullSimplify[projector2.affineMap2 == affineMap2.projector1, mu != 0]];
check["Commuting projectors: local source projection equals final global projection",
  FullSimplify[
    projector2.affineMap2.projector1.affineSource1 +
      projector2.affineSource2 ==
      projector2.(affineMap2.affineSource1 + affineSource2), mu != 0]];

ClearAll[kappa];
mapResidual = outgoingBand - leftConservingMap.incomingBand;
rankOneMap = leftConservingMap +
  Outer[Times, mapResidual, particleInvariant]/mu;
nullLeftVector = {1, -1, 0};
nullRightCovector = {incomingBand[[2]], -incomingBand[[1]], 0};
neutralMapChange = Outer[Times, nullLeftVector, nullRightCovector];

check["Rank-one candidate: correction transports the constant-f band vector",
  FullSimplify[rankOneMap.incomingBand == outgoingBand, mu != 0]];
check["Rank-one candidate: correction preserves the left invariant",
  FullSimplify[particleInvariant.rankOneMap == particleInvariant, mu != 0]];
check["Map correction family: neutral addition preserves the left invariant",
  FullSimplify[particleInvariant.neutralMapChange == {0, 0, 0}]];
check["Map correction family: neutral addition preserves constant-f transport",
  FullSimplify[neutralMapChange.incomingBand == {0, 0, 0}]];
check["Map correction family: rank-one repair is not unique",
  FullSimplify[(rankOneMap + kappa neutralMapChange).incomingBand ==
      outgoingBand &&
    particleInvariant.(rankOneMap + kappa neutralMapChange) ==
      particleInvariant, mu != 0]];
check["Map correction family: neutral addition is generically nonzero",
  neutralMapChange[[1, 1]] == incomingBand[[2]]];

periodicMap = {{1/2, 1/4, 1/4}, {1/2, 1/4, 0}, {0, 1/2, 3/4}};
periodicMatrix = IdentityMatrix[3] - periodicMap;
periodicRightNull = First[NullSpace[periodicMatrix]];
periodicRightNull = periodicRightNull/Total[periodicRightNull];
uniformBand = {1/3, 1/3, 1/3};

check["Periodic system: column conservation supplies a left null",
  particleInvariant.periodicMatrix == {0, 0, 0}];
check["Periodic system: numerical right null solves the homogeneous equation",
  periodicMatrix.periodicRightNull == {0, 0, 0}];
check["Periodic system: left conservation does not imply the chosen constant-f right null",
  periodicMatrix.uniformBand != {0, 0, 0}];

ClearAll[gaugeParameter, x01, x02, x03, g1, g2, g3];
particularState = {x01, x02, x03};
compatibleRhs = periodicMatrix.particularState;
gaugeFlux = {g1, g2, g3}.(
    IdentityMatrix[3] -
      Outer[Times, periodicRightNull, particleInvariant]);

check["Periodic gauge: adding the numerical right null leaves the equation unchanged",
  FullSimplify[periodicMatrix.(particularState +
        gaugeParameter periodicRightNull) == compatibleRhs]];
check["Periodic gauge: dual flux must annihilate the numerical right null",
  FullSimplify[gaugeFlux.periodicRightNull == 0]];
check["Periodic gauge: annihilating the right null makes the flux gauge independent",
  FullSimplify[gaugeFlux.(particularState +
        gaugeParameter periodicRightNull) == gaugeFlux.particularState]];

sourceExample = {1, 2, 3};
directionA = {1, 1, 1};
directionB = {1, 2, 3};
projectAlong[direction_] := IdentityMatrix[3] -
  Outer[Times, direction, particleInvariant]/
    (particleInvariant.direction);
projectedA = projectAlong[directionA].sourceExample;
projectedB = projectAlong[directionB].sourceExample;

check["Solvability direction: two correction directions both enforce compatibility",
  particleInvariant.projectedA == 0 && particleInvariant.projectedB == 0];
check["Solvability direction: compatibility alone does not select the correction",
  projectedA != projectedB];

crossingWidthCurrent = 3.8755753453293407*10^-2;
crossingWidthNext = 3.8419219196663246*10^-2;
crossingStreamingCoefficient = 1.5272028264247180*10^2;
crossingRowResidual = 5.1395606791432513*10^-2;

check["Pitch crossing: band-width mismatch reproduces the sparse row residual",
  Abs[(crossingWidthCurrent - crossingWidthNext)*
      crossingStreamingCoefficient - crossingRowResidual] < 10^-14];

reportAndExit[];

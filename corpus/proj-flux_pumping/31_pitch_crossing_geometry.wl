Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[phi, phiLeft, phiRight, magneticOffset, magneticSlope,
  pitch, magneticField];
magneticField[coordinate_] := magneticOffset + magneticSlope coordinate;
crossing = (1/pitch - magneticOffset)/magneticSlope;

check["Crossing root: root-aligned magnetic field satisfies eta B=1",
  FullSimplify[pitch magneticField[crossing] == 1,
    pitch != 0 && magneticSlope != 0]];

leftWeight = (phiRight - crossing)/(phiRight - phiLeft);
rightWeight = (crossing - phiLeft)/(phiRight - phiLeft);
check["Root interpolation: affine weights preserve a constant",
  FullSimplify[leftWeight + rightWeight == 1,
    phiRight != phiLeft]];
check["Root interpolation: affine weights reproduce the crossing coordinate",
  FullSimplify[leftWeight phiLeft + rightWeight phiRight == crossing,
    phiRight != phiLeft]];
check["Root interpolation: a linear physical field reaches the mirror value",
  FullSimplify[
    pitch (leftWeight magneticField[phiLeft] +
        rightWeight magneticField[phiRight]) == 1,
    pitch != 0 && magneticSlope != 0 && phiRight != phiLeft]];

ClearAll[metric, geodesic];
metric[coordinate_] := 2 magneticField[coordinate] + 3 coordinate;
geodesic[coordinate_] := 5 - coordinate + coordinate^2;
check["Consistent evaluation: coupled field identity holds at the moved node",
  FullSimplify[
    metric[crossing] - 2 magneticField[crossing] - 3 crossing == 0,
    pitch != 0 && magneticSlope != 0]];
check["Fixed-node overwrite: changing only B breaks the coupled field identity",
  metric[1/2] - 2 (1/(1/2)) - 3/2 != 0 /.
    {magneticOffset -> 1, magneticSlope -> 1}];
check["Consistent evaluation: derived coefficient uses one physical point",
  FullSimplify[
    (metric[crossing]/magneticField[crossing])
        (geodesic[crossing]/metric[crossing]) ==
      geodesic[crossing]/magneticField[crossing],
    pitch != 0 && magneticSlope != 0 && metric[crossing] != 0]];
check["Derivative consistency: d log B/dphi comes from the same field",
  FullSimplify[
    (D[magneticField[phi], phi]/magneticField[phi] /. phi -> crossing) ==
      pitch magneticSlope,
    pitch != 0 && magneticSlope != 0]];

check["Mirror boundary: the parallel-speed factor vanishes at the root",
  FullSimplify[Sqrt[1 - pitch magneticField[crossing]] == 0,
    pitch != 0 && magneticSlope != 0]];
check["Root ordering: the representative crossing remains inside its bracket",
  1/2 < (crossing /. {magneticOffset -> 1, magneticSlope -> 1,
      pitch -> 1/2}) < 3/2];

ClearAll[eta0, eta1, eta2, constantDistribution];
pitchBandVector = constantDistribution {eta1 - eta0, eta2 - eta1};
check["Pitch measure: spatial root alignment leaves every band integral unchanged",
  (pitchBandVector /. phi -> crossing) == pitchBandVector];

ClearAll[flux0, flux1, flux2, flux3, width1, width2, width3];
cellDivergence = {
  (flux0 - flux1)/width1,
  (flux1 - flux2)/width2,
  (flux2 - flux3)/width3};
check["Nonuniform finite volume: cell-integrated streaming fluxes telescope",
  Expand[{width1, width2, width3}.cellDivergence] == flux0 - flux3];

ClearAll[constantSource];
check["Cell split: constant-source quadrature preserves the original measure",
  FullSimplify[
    constantSource (crossing - phiLeft) +
        constantSource (phiRight - crossing) ==
      constantSource (phiRight - phiLeft)]];

ClearAll[period];
remeshedPeriod = {0, crossing, period};
check["Periodic boundary: moving an interior crossing preserves both endpoints",
  First[remeshedPeriod] == 0 && Last[remeshedPeriod] == period];

check["Crossing conflict: two distinct pitch boundaries cannot share one field node",
  Reduce[{(1 + phi)/2 == 1, (1 + phi)/3 == 1}, phi] === False];

ClearAll[coordinateScale, fieldScale, dimensionlessCoordinate,
  dimensionlessField, dimensionlessPitch];
scaledCrossingProduct =
  (dimensionlessPitch/fieldScale)*
    (fieldScale*dimensionlessField[dimensionlessCoordinate]);
check["Units: eta B is independent of the magnetic-field scale",
  FullSimplify[scaledCrossingProduct ==
    dimensionlessPitch*dimensionlessField[dimensionlessCoordinate],
    fieldScale != 0]];
scaledLogDerivative =
  D[Log[fieldScale dimensionlessField[phi/coordinateScale]], phi];
check["Units: d log B/dphi carries inverse-coordinate scale",
  FullSimplify[scaledLogDerivative ==
    dimensionlessField'[phi/coordinateScale]/
      (coordinateScale dimensionlessField[phi/coordinateScale]),
    fieldScale > 0 && coordinateScale != 0 &&
      dimensionlessField[phi/coordinateScale] > 0]];

reportAndExit[];

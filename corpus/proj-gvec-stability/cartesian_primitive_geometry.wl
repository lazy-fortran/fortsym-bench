ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

phase = 2 Pi (m theta - n zeta);
complexHarmonic = (c - I d) Exp[I phase];
check["complex coefficient convention",
 FullSimplify[ComplexExpand[Re[complexHarmonic]] ==
   c Cos[phase] + d Sin[phase],
  Element[{c, d, theta, zeta, m, n}, Reals]]];
check["poloidal phase derivative",
 FullSimplify[D[Exp[I phase], theta] ==
   I 2 Pi m Exp[I phase]]];
check["toroidal-period phase derivative",
 FullSimplify[D[Exp[I phase], zeta] ==
   -I 2 Pi n Exp[I phase]]];
check["second poloidal phase derivative",
 FullSimplify[D[Exp[I phase], {theta, 2}] ==
   -(2 Pi m)^2 Exp[I phase]]];
check["mixed angular phase derivative",
 FullSimplify[D[Exp[I phase], theta, zeta] ==
   (2 Pi)^2 m n Exp[I phase]]];
check["second toroidal-period phase derivative",
 FullSimplify[D[Exp[I phase], {zeta, 2}] ==
   -(2 Pi n)^2 Exp[I phase]]];

rotation[angle_] = {{Cos[angle], -Sin[angle], 0},
  {Sin[angle], Cos[angle], 0}, {0, 0, 1}};
generator = {{0, -1, 0}, {1, 0, 0}, {0, 0, 0}};
hatted = {hx[s, theta, u], hy[s, theta, u], hz[s, theta, u]};
rotationRate = 2 Pi windingSymbol/nfpSymbol;
rotationAngle = rotationRate u;
physical = rotation[rotationAngle] . hatted;
rotated[vector_] := rotation[rotationAngle] . vector;
rotatingJetAssumptions = nfpSymbol > 0 &&
  Element[{s, theta, u, windingSymbol}, Reals] &&
  Element[nfpSymbol, Integers];
check["rotating-frame matrix is orthogonal",
 FullSimplify[Transpose[rotation[rotationAngle]] .
   rotation[rotationAngle] == IdentityMatrix[3],
  rotatingJetAssumptions]];
check["rotating-frame generator derivative",
 FullSimplify[D[rotation[rotationAngle], u] ==
   rotationRate rotation[rotationAngle] . generator,
  rotatingJetAssumptions]];
check["rotating-frame position",
 FullSimplify[physical == rotated[hatted], rotatingJetAssumptions]];
check["rotating-frame radial derivative",
 FullSimplify[D[physical, s] == rotated[D[hatted, s]],
  rotatingJetAssumptions]];
check["rotating-frame poloidal derivative",
 FullSimplify[D[physical, theta] == rotated[D[hatted, theta]],
  rotatingJetAssumptions]];
check["rotating-frame toroidal-period derivative",
 FullSimplify[D[physical, u] == rotated[D[hatted, u] +
    rotationRate generator . hatted], rotatingJetAssumptions]];
check["rotating-frame second radial derivative",
 FullSimplify[D[physical, {s, 2}] == rotated[D[hatted, {s, 2}]],
  rotatingJetAssumptions]];
check["rotating-frame radial-poloidal derivative",
 FullSimplify[D[physical, s, theta] ==
   rotated[D[hatted, s, theta]], rotatingJetAssumptions]];
check["rotating-frame radial-toroidal derivative",
 FullSimplify[D[physical, s, u] == rotated[D[hatted, s, u] +
    rotationRate generator . D[hatted, s]], rotatingJetAssumptions]];
check["rotating-frame second poloidal derivative",
 FullSimplify[D[physical, {theta, 2}] ==
   rotated[D[hatted, {theta, 2}]], rotatingJetAssumptions]];
check["rotating-frame poloidal-toroidal derivative",
 FullSimplify[D[physical, theta, u] ==
   rotated[D[hatted, theta, u] +
    rotationRate generator . D[hatted, theta]],
  rotatingJetAssumptions]];
check["rotating-frame second toroidal-period derivative",
 FullSimplify[D[physical, {u, 2}] ==
   rotated[D[hatted, {u, 2}] +
    2 rotationRate generator . D[hatted, u] +
    rotationRate^2 generator . generator . hatted],
  rotatingJetAssumptions]];
check["rotating frame closes after all field periods",
 FullSimplify[rotation[rotationRate (u + nfpSymbol)] ==
   rotation[rotationRate u], rotatingJetAssumptions &&
   Element[windingSymbol, Integers]]];

(* VMEC Boozer angles map to GLISS's left-handed, normalized coordinates as
   theta=-theta_B/(2 Pi) and zeta=-N_FP zeta_B/(2 Pi). The rotating position
   frame must recover phi=zeta_B-nu without reflecting physical y. *)
vmecTheta = -thetaB/(2 Pi);
vmecZeta = -nfpSymbol zetaB/(2 Pi);
vmecWinding = -1;
vmecFrame = {radiusB Cos[nuB], -radiusB Sin[nuB], heightB};
vmecPhysical =
  rotation[2 Pi vmecWinding vmecZeta/nfpSymbol] . vmecFrame;
vmecExpected = {radiusB Cos[zetaB - nuB],
  radiusB Sin[zetaB - nuB], heightB};
vmecAssumptions = nfpSymbol > 0 && Element[nfpSymbol, Integers] &&
  Element[{thetaB, zetaB, nuB, radiusB, heightB}, Reals];
check["VMEC rotating position frame preserves physical orientation",
 FullSimplify[vmecPhysical == vmecExpected, vmecAssumptions]];
sourcePhase = m thetaB - n nfpSymbol zetaB;
exportPhase = 2 Pi (m vmecTheta - n vmecZeta);
check["VMEC to GLISS Fourier phase reverses sign",
 FullSimplify[exportPhase == -sourcePhase, vmecAssumptions &&
   Element[{m, n}, Reals]]];
check["VMEC sine coefficient changes sign under the coordinate map",
 FullSimplify[
  cosineB Cos[exportPhase] - sineB Sin[exportPhase] ==
   cosineB Cos[sourcePhase] + sineB Sin[sourcePhase],
  vmecAssumptions && Element[{m, n, cosineB, sineB}, Reals]]];

r = {x[s, theta, zeta], y[s, theta, zeta], z[s, theta, zeta]};
rs = D[r, s]; rt = D[r, theta]; rz = D[r, zeta];
rss = D[r, {s, 2}]; rst = D[r, s, theta]; rsz = D[r, s, zeta];
rtt = D[r, {theta, 2}]; rtz = D[r, theta, zeta];
rzz = D[r, {zeta, 2}];
jacobian = rs . Cross[rt, rz];
frame = Transpose[{rs, rt, rz}];
metric = Transpose[frame] . frame;

check["metric components are Cartesian tangent dot products",
 metric == {{rs . rs, rs . rt, rs . rz},
   {rt . rs, rt . rt, rt . rz}, {rz . rs, rz . rt, rz . rz}}];
check["metric is symmetric",
 FullSimplify[metric == Transpose[metric]]];
metricRadial = D[metric, s];
basis = {rs, rt, rz};
basisRadial = {rss, rst, rsz};
metricRadialProduct = Table[
  basisRadial[[i]] . basis[[j]] + basis[[i]] . basisRadial[[j]],
  {i, 1, 3}, {j, 1, 3}];
check["radial metric product rule",
 FullSimplify[metricRadial == metricRadialProduct]];
check["radial metric remains symmetric",
 FullSimplify[metricRadial == Transpose[metricRadial]]];
check["signed Jacobian is the frame determinant",
 FullSimplify[jacobian == Det[frame]]];
check["swapping angular coordinates reverses orientation",
 FullSimplify[rs . Cross[rz, rt] == -jacobian]];
check["metric determinant is signed Jacobian squared",
 FullSimplify[Det[metric] == jacobian^2]];
angularMinor = metric[[2, 2]] metric[[3, 3]] - metric[[2, 3]]^2;
check["angular metric minor is the surface-area norm squared",
 FullSimplify[angularMinor == Cross[rt, rz] . Cross[rt, rz]]];
check["radial inverse metric is the angular cofactor over Jacobian squared",
 FullSimplify[Det[metric] != 0 &&
    Inverse[metric][[1, 1]] == angularMinor/jacobian^2,
  jacobian != 0]];
check["mixed Cartesian derivatives commute",
 FullSimplify[D[r, s, theta] == D[r, theta, s] &&
   D[r, s, zeta] == D[r, zeta, s] &&
   D[r, theta, zeta] == D[r, zeta, theta]]];
check["radial Jacobian product rule",
 FullSimplify[D[jacobian, s] == rss . Cross[rt, rz] +
   rs . Cross[rst, rz] + rs . Cross[rt, rsz]]];
check["poloidal Jacobian product rule",
 FullSimplify[D[jacobian, theta] == rst . Cross[rt, rz] +
   rs . Cross[rtt, rz] + rs . Cross[rt, rtz]]];
check["toroidal Jacobian product rule",
 FullSimplify[D[jacobian, zeta] == rsz . Cross[rt, rz] +
   rs . Cross[rtz, rz] + rs . Cross[rt, rzz]]];

bTheta = -chiSlope/(periods jacobian);
bZeta = -phiSlope/jacobian;
b = bTheta rt + bZeta rz;
check["toroidal flux convention",
 FullSimplify[-jacobian bZeta == phiSlope]];
check["poloidal flux convention",
 FullSimplify[-periods jacobian bTheta == chiSlope]];
check["magnetic field is tangent to a flux surface",
 FullSimplify[b . Cross[rt, rz] == 0]];
check["covariant poloidal field from the metric",
 FullSimplify[b . rt == bTheta metric[[2, 2]] +
   bZeta metric[[2, 3]]]];
check["covariant toroidal field from the metric",
 FullSimplify[b . rz == bTheta metric[[2, 3]] +
   bZeta metric[[3, 3]]]];
check["magnetic magnitude from primitive metric",
 FullSimplify[b . b == bTheta^2 metric[[2, 2]] +
   2 bTheta bZeta metric[[2, 3]] + bZeta^2 metric[[3, 3]]]];

phiPrime = phiProfile'[s]; chiPrime = chiProfile'[s];
phiSecond = phiProfile''[s]; chiSecond = chiProfile''[s];
bt = -chiPrime/(periods jacobian);
bz = -phiPrime/jacobian;
btRadial = -chiSecond/(periods jacobian) -
  bt D[jacobian, s]/jacobian;
bzRadial = -phiSecond/jacobian - bz D[jacobian, s]/jacobian;
check["radial contravariant poloidal field product rule",
 FullSimplify[D[bt, s] == btRadial]];
check["radial contravariant toroidal field product rule",
 FullSimplify[D[bz, s] == bzRadial]];
covariantField = metric[[2 ;; 3, 2 ;; 3]] . {bt, bz};
covariantFieldRadial = metricRadial[[2 ;; 3, 2 ;; 3]] . {bt, bz} +
  metric[[2 ;; 3, 2 ;; 3]] . {btRadial, bzRadial};
check["radial covariant field product rule",
 FullSimplify[D[covariantField, s] == covariantFieldRadial]];
check["toroidal flux curvature recovered after Jacobian cancellation",
 FullSimplify[D[jacobian bz, s] == -phiSecond]];
check["poloidal flux curvature recovered after Jacobian cancellation",
 FullSimplify[D[jacobian bt, s] == -chiSecond/periods]];
check["flux representation is divergence free",
 FullSimplify[D[-chiSlope[s]/periods, theta] +
   D[-phiSlope[s], zeta] == 0]];
check["flux-surface pressure is constant along the field",
 FullSimplify[0 D[pressure[s], s] + bTheta D[pressure[s], theta] +
   bZeta D[pressure[s], zeta] == 0]];
check["field-line phase derivative uses the signed mode combination",
 FullSimplify[bTheta D[Exp[I phase], theta] +
   bZeta D[Exp[I phase], zeta] ==
   I 2 Pi (m bTheta - n bZeta) Exp[I phase]]];

unitNormal = Cross[rt, rz]/Sqrt[Cross[rt, rz] . Cross[rt, rz]];
secondTT = unitNormal . rtt;
secondTZ = unitNormal . rtz;
secondZZ = unitNormal . rzz;
check["mixed second form is coordinate-order independent",
 FullSimplify[secondTZ == unitNormal . D[r, zeta, theta]]];
check["second form is unchanged by tangential second-derivative parts",
 FullSimplify[unitNormal . (rtt + aa rt + bb rz) == secondTT &&
   unitNormal . (rtz + cc rt + dd rz) == secondTZ &&
   unitNormal . (rzz + ee rt + ff rz) == secondZZ]];

fixturePhase = phase /. {m -> 2, n -> -1, theta -> 1/8, zeta -> 1/8};
fixtureValue = 4 Cos[fixturePhase] + 6 Sin[fixturePhase];
fixtureJet = {fixtureValue,
  D[4 Cos[phase] + 6 Sin[phase], {theta, 2}],
  D[4 Cos[phase] + 6 Sin[phase], theta, zeta],
  D[4 Cos[phase] + 6 Sin[phase], {zeta, 2}]} /.
 {m -> 2, n -> -1, theta -> 1/8, zeta -> 1/8};
check["exact angular second-derivative fixture",
 FullSimplify[fixtureJet == {Sqrt[2], -16 Pi^2 Sqrt[2],
    -8 Pi^2 Sqrt[2], -4 Pi^2 Sqrt[2]}]];
Print["fixture angular jet = ", fixtureJet];

frs = {1, 2, -1}; frt = {0, 2, 1}; frz = {3, -1, 2};
frss = {2, 1, -1}; frst = {1, -1, 0}; frsz = {0, 2, -1};
frtt = {1, 0, 2}; frtz = {-1, 2, 1}; frzz = {2, -2, 0};
fcross = Cross[frt, frz];
fj = frs . fcross;
fmetric = {frs, frt, frz} . Transpose[{frs, frt, frz}];
fjs = frss . fcross + frs . Cross[frst, frz] +
  frs . Cross[frt, frsz];
fjt = frst . fcross + frs . Cross[frtt, frz] +
  frs . Cross[frt, frtz];
fjz = frsz . fcross + frs . Cross[frtz, frz] +
  frs . Cross[frt, frzz];
fbTheta = 3/(5 fj); fbZeta = -7/fj;
fbCovariant = {fmetric[[2, 2]] fbTheta + fmetric[[2, 3]] fbZeta,
  fmetric[[2, 3]] fbTheta + fmetric[[3, 3]] fbZeta};
fbSquared = {fbTheta, fbZeta} . fbCovariant;
fsecond = {{fcross . frtt, fcross . frtz},
    {fcross . frtz, fcross . frzz}}/Sqrt[fcross . fcross];
check["exact point fixture metric",
 fmetric == {{6, 3, -1}, {3, 5, 0}, {-1, 0, 14}}];
check["exact point fixture signed Jacobian", fj == 17];
check["exact point fixture Jacobian derivatives",
 {fjs, fjt, fjz} == {7, 9, 42}];
check["exact point fixture contravariant field",
 {fbTheta, fbZeta} == {3/85, -7/17}];
check["exact point fixture covariant field",
 fbCovariant == {3/17, -98/17}];
check["exact point fixture magnetic magnitude squared",
 fbSquared == 3439/1445];
check["exact point fixture second form",
 fsecond == {{-7/Sqrt[70], -5/Sqrt[70]},
   {-5/Sqrt[70], 4/Sqrt[70]}}];
Print["fixture point = ", {fmetric, fj, {fjs, fjt, fjz},
  {fbTheta, fbZeta}, fbCovariant, Sqrt[fbSquared], fsecond}];

torusRadius = major + minor Sqrt[s] Cos[2 Pi theta];
torus = {torusRadius Cos[2 Pi zeta], torusRadius Sin[2 Pi zeta],
  minor Sqrt[s] Sin[2 Pi theta]};
rhoS = 1/(2 Sqrt[s]); rhoSS = -1/(4 s^(3/2));
torusS = minor rhoS {Cos[2 Pi theta] Cos[2 Pi zeta],
  Cos[2 Pi theta] Sin[2 Pi zeta], Sin[2 Pi theta]};
torusSS = minor rhoSS {Cos[2 Pi theta] Cos[2 Pi zeta],
  Cos[2 Pi theta] Sin[2 Pi zeta], Sin[2 Pi theta]};
check["manufactured torus radial derivative",
 FullSimplify[D[torus, s] == torusS, s > 0]];
check["manufactured torus second radial derivative",
 FullSimplify[D[torus, {s, 2}] == torusSS, s > 0]];
check["manufactured torus poloidal derivative",
 FullSimplify[D[torus, theta] ==
   2 Pi minor Sqrt[s] {-Sin[2 Pi theta] Cos[2 Pi zeta],
    -Sin[2 Pi theta] Sin[2 Pi zeta], Cos[2 Pi theta]}, s > 0]];
check["manufactured torus toroidal derivative",
 FullSimplify[D[torus, zeta] == 2 Pi torusRadius
   {-Sin[2 Pi zeta], Cos[2 Pi zeta], 0}, s > 0]];
check["manufactured torus radial-poloidal derivative",
 FullSimplify[D[torus, s, theta] ==
   2 Pi minor rhoS {-Sin[2 Pi theta] Cos[2 Pi zeta],
    -Sin[2 Pi theta] Sin[2 Pi zeta], Cos[2 Pi theta]}, s > 0]];
check["manufactured torus radial-toroidal derivative",
 FullSimplify[D[torus, s, zeta] == 2 Pi minor rhoS
   {-Cos[2 Pi theta] Sin[2 Pi zeta],
    Cos[2 Pi theta] Cos[2 Pi zeta], 0}, s > 0]];
check["manufactured torus second poloidal derivative",
 FullSimplify[D[torus, {theta, 2}] == -(2 Pi)^2 minor Sqrt[s]
   {Cos[2 Pi theta] Cos[2 Pi zeta],
    Cos[2 Pi theta] Sin[2 Pi zeta], Sin[2 Pi theta]}, s > 0]];
check["manufactured torus mixed angular derivative",
 FullSimplify[D[torus, theta, zeta] == (2 Pi)^2 minor Sqrt[s]
   {Sin[2 Pi theta] Sin[2 Pi zeta],
    -Sin[2 Pi theta] Cos[2 Pi zeta], 0}, s > 0]];
check["manufactured torus second toroidal derivative",
 FullSimplify[D[torus, {zeta, 2}] == -(2 Pi)^2 torusRadius
   {Cos[2 Pi zeta], Sin[2 Pi zeta], 0}, s > 0]];

torusXFourier = major Cos[2 Pi zeta] + minor Sqrt[s]/2 *
  (Cos[2 Pi (theta - zeta)] + Cos[2 Pi (theta + zeta)]);
torusYFourier = major Sin[2 Pi zeta] + minor Sqrt[s]/2 *
  (Sin[2 Pi (theta + zeta)] - Sin[2 Pi (theta - zeta)]);
torusZFourier = minor Sqrt[s] Sin[2 Pi theta];
check["manufactured torus x Fourier decomposition",
 FullSimplify[torus[[1]] == torusXFourier, s >= 0 &&
   Element[{theta, zeta, major, minor}, Reals]]];
check["manufactured torus y Fourier decomposition",
 FullSimplify[torus[[2]] == torusYFourier, s >= 0 &&
   Element[{theta, zeta, major, minor}, Reals]]];
check["manufactured torus z Fourier decomposition",
 FullSimplify[torus[[3]] == torusZFourier, s >= 0]];

torusFrame = {D[torus, s], D[torus, theta], D[torus, zeta]};
torusMetric = torusFrame . Transpose[torusFrame];
torusJacobian = torusFrame[[1]] . Cross[torusFrame[[2]], torusFrame[[3]]];
torusAssumptions = s > 0 && minor > 0 &&
  major > minor Sqrt[s] &&
  Element[{theta, zeta, major, minor}, Reals];
expectedTorusMetric = DiagonalMatrix[{minor^2/(4 s),
   (2 Pi minor Sqrt[s])^2, (2 Pi torusRadius)^2}];
check["manufactured torus metric",
 FullSimplify[torusMetric == expectedTorusMetric, torusAssumptions]];
check["manufactured torus signed Jacobian",
 FullSimplify[torusJacobian == -2 Pi^2 minor^2 torusRadius,
  torusAssumptions]];
check["manufactured torus radial Jacobian derivative",
 FullSimplify[D[torusJacobian, s] ==
   -Pi^2 minor^3 Cos[2 Pi theta]/Sqrt[s], torusAssumptions]];
check["manufactured torus poloidal Jacobian derivative",
 FullSimplify[D[torusJacobian, theta] ==
   4 Pi^3 minor^3 Sqrt[s] Sin[2 Pi theta], torusAssumptions]];
check["manufactured torus toroidal Jacobian derivative",
 FullSimplify[D[torusJacobian, zeta] == 0, torusAssumptions]];
torusNormal = {Cos[2 Pi theta] Cos[2 Pi zeta],
  Cos[2 Pi theta] Sin[2 Pi zeta], Sin[2 Pi theta]};
check["manufactured torus outward normal",
 FullSimplify[Cross[torusFrame[[2]], torusFrame[[3]]] ==
   -(2 Pi minor Sqrt[s]) (2 Pi torusRadius) torusNormal,
  torusAssumptions]];
torusSecond = {{torusNormal . D[torus, {theta, 2}],
    torusNormal . D[torus, theta, zeta]},
   {torusNormal . D[torus, theta, zeta],
    torusNormal . D[torus, {zeta, 2}]}};
check["manufactured torus second form",
 FullSimplify[torusSecond == {{-(2 Pi)^2 minor Sqrt[s], 0},
    {0, -(2 Pi)^2 torusRadius Cos[2 Pi theta]}}, torusAssumptions]];

manufacturedPhi[s_] = 2 + 7 s;
manufacturedChi[s_] = -1 - 3 s;
manufacturedPressure[s_] = 1000 (1 - s)^2;
check["manufactured equilibrium toroidal flux slope",
 D[manufacturedPhi[s], s] == 7];
check["manufactured equilibrium poloidal flux slope",
 D[manufacturedChi[s], s] == -3];
check["manufactured equilibrium pressure jet",
 {manufacturedPressure[9/25],
   D[manufacturedPressure[s], s] /. s -> 9/25} == {2048/5, -1280}];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

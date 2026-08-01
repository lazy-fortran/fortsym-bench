(* Conditional geometric toroidal-current completion in the l=1 cylinder.
   NEO-2's accepted output is a flux-surface parallel-current moment, not a
   pointwise total current vector. The memo redistribution needs j^zeta and
   j_tor = R j^zeta. A parallel projection alone cannot determine them:
   an arbitrary current perpendicular to B leaves j_par unchanged. If the
   separate l=1 surface-current ansatz j^theta = -j^zeta from script 14 is
   imposed, the cylinder model selects one completion. This script verifies
   that conditional algebra and demonstrates the missing degree of freedom.
   Straight-cylinder metric diag(1, r^2, R^2), memo angles (r, theta, zeta),
   straight field line B^theta = iota B^zeta, B^r = 0. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[r, capR, iota, Jamp, Bz, th, zet, jZeta, jTheta];
ass = r > 0 && capR > 0 && Bz > 0 && Element[iota, Reals];

(* Cylinder surface metric and straight-field-line equilibrium field. *)
gTheta = r^2;
gZeta = capR^2;
Btheta = iota Bz;
Bzeta = Bz;
Bmag = Sqrt[gTheta Btheta^2 + gZeta Bzeta^2];   (* |B| *)

(* Divergence-free l=1 helical current: sqrt(g) j^theta = -sqrt(g) j^zeta
   for the unit helical phase (script 14, Hel5), i.e. j^theta = -j^zeta. *)
jZeta = Jamp;
jTheta = -Jamp;

check["Geo1: l=1 divergence-free current has j^theta = -j^zeta",
  jTheta == -jZeta];
check["Geo1: this current is divergence-free for the Cos(theta+zeta) phase",
  FullSimplify[
    D[Sqrt[gTheta gZeta] jTheta Cos[th + zet], th]
      + D[Sqrt[gTheta gZeta] jZeta Cos[th + zet], zet] == 0]];

(* Parallel current density j_par = (j.B)/|B| in the real cylinder metric. *)
jDotB = gTheta jTheta Btheta + gZeta jZeta Bzeta;
jPar = FullSimplify[jDotB/Bmag, ass];
jParClosed = Jamp (capR^2 - r^2 iota)/Sqrt[r^2 iota^2 + capR^2];

check["Geo2: parallel projection of the l=1 current in the cylinder metric",
  FullSimplify[jPar == jParClosed, ass]];

(* Invert: recover the toroidal contravariant current and the physical
   toroidal current density from the NEO-2 parallel response. *)
jZetaFromPar = jParVal Sqrt[r^2 iota^2 + capR^2]/(capR^2 - r^2 iota);
jTorPhysical = capR jZetaFromPar;   (* physical component sqrt(g_zeta) j^zeta *)

check["Geo3: the l=1 ansatz conditionally recovers j^zeta from j_par",
  FullSimplify[(jZetaFromPar /. jParVal -> jParClosed) == Jamp, ass]];
check["Geo3: physical toroidal current density is R j^zeta",
  FullSimplify[
    (jTorPhysical /. jParVal -> jParClosed) == capR Jamp, ass]];

(* Resonance limit iota = -1: the current is purely parallel, so j_par
   equals the full current magnitude |j| = sqrt(g_ij j^i j^j). *)
jMagnitude = Sqrt[gTheta jTheta^2 + gZeta jZeta^2];
check["Geo4: at iota=-1 the parallel current equals the full current magnitude",
  FullSimplify[(jPar /. iota -> -1) == (jMagnitude /. Jamp -> Abs[Jamp]),
    Jamp > 0]];

(* Perpendicular part: j - j_par b. It vanishes at iota=-1 and is first
   order in (iota+1), the divergence-free completion the projection misses. *)
bHat = {Btheta, Bzeta}/Bmag;                 (* unit field, contravariant *)
jVec = {jTheta, jZeta};
gMat = DiagonalMatrix[{gTheta, gZeta}];
jParVec = ((jVec.gMat.bHat)) bHat;           (* parallel component vector *)
jPerpVec = FullSimplify[jVec - jParVec, ass];

check["Geo5: perpendicular current is orthogonal to B in the cylinder metric",
  FullSimplify[jPerpVec.gMat.bHat == 0, ass]];
check["Geo5: perpendicular completion vanishes at the iota=-1 resonance",
  FullSimplify[jPerpVec /. iota -> -1, ass] == {0, 0}];
perpDerivative = FullSimplify[D[jPerpVec, iota] /. iota -> -1, ass];
check["Geo5: perpendicular completion is first order in iota+1",
  FullSimplify[perpDerivative.gMat.perpDerivative > 0,
    ass && Jamp != 0]];

(* Non-uniqueness before the l=1 ansatz is imposed. Any multiple of the
   metric-orthogonal direction p has the same parallel projection. *)
ClearAll[jParVal, alpha];
pVec = {capR^2 Bzeta, -r^2 Btheta};
jFamily = jParVal bHat + alpha pVec;
check["Geo6: a parallel moment leaves an arbitrary perpendicular current",
  FullSimplify[jFamily.gMat.bHat == jParVal, ass]];
check["Geo6: distinct perpendicular completions exist at every regular point",
  FullSimplify[(D[jFamily, alpha].gMat.D[jFamily, alpha]) > 0, ass]];

(* NEO-2 map (script 16): zeta = -phi, so the toroidal contravariant
   component flips sign, j^zeta_memo = -j^phi_neo, while iota_memo =
   -iota_neo. The physical toroidal current magnitude R|j^zeta| is
   convention-independent. *)
jNeo = {jTheta, -jZeta};
bNeo = {Btheta, -Bzeta}/Bmag;
check["Geo7: physical toroidal current magnitude is invariant under zeta=-phi",
  FullSimplify[capR Abs[jNeo[[2]]] == capR Abs[jZeta], ass]];
check["Geo7: the parallel projection is invariant under the coordinate reversal",
  FullSimplify[jNeo.gMat.bNeo == jVec.gMat.bHat, ass]];

reportAndExit[];

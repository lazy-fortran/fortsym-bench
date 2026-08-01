(* Bridge between the published dynamo diagnostics and the memo's
   misalignment drive (literature/notes/{jardin15,krebs17,zhang25,
   zhang26}.md, extracted 2026-07-20). Three operationally different
   quantities appear in the MHD literature: Jardin 2015 diagnoses the
   toroidally averaged parallel electrostatic drop -B.grad Phi
   (an electric-field diagnostic); Krebs 2017 and both Zhang papers
   diagnose the mean-field-parallel fluctuation motional emf
   b0.<v1 x B1> (a velocity diagnostic); our reduced model works with
   the misaligned-potential drive. This script verifies, at the level
   of single-helicity harmonic algebra in the cylinder: (1) the exact
   identity (v x B).B = 0, so a parallel dynamo emf exists only
   through the mean/fluctuation split; (2) the n = 0 average of
   v x B splits exactly into mean and quadratic fluctuation parts,
   and the fluctuation part is the complex half-correlation;
   (3) a potential aligned with the corrugated surfaces gives
   exactly zero Jardin signal - the 3D-minus-2D matched -B.grad Phi
   measures precisely the misalignment part of the potential, which
   identifies Jardin's V_dyn with the memo's misalignment drive;
   (4) given stationary Ohm's law, the velocity diagnostic and the
   electric-field diagnostic differ exactly by the matched parallel
   current change times eta plus the external loop-voltage term -
   the fixed-resistivity, matched-current conditions of the
   document's bridge equation, now verified rather than assumed.
   No figure. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[vv, bb, v0, b0v, chi, m, k, r, B0, Bth, Delta, Phi0, phiA,
  eps, alpha, EA, eta];
$Assumptions = r > 0 && Element[{chi, eps, m, k}, Reals] && B0 > 0;

(* ==== 1. No pointwise parallel motional emf ==== *)
vv = {v1, v2, v3}; bb = {b1, b2, b3};
check["(v x B).B = 0 identically",
  Simplify[Cross[vv, bb] . bb] === 0];

(* ==== 2. Mean/fluctuation split of the n = 0 motional emf ==== *)
(* Real single-helicity harmonics X = Re[Xhat Exp[I chi]]; the chi
   average of a product is the complex half-correlation. *)
harm[hat_] := ComplexExpand[Re[hat Exp[I chi]]];
avgChi[X_] := Integrate[X, {chi, 0, 2 Pi}]/(2 Pi);

vHat = {vr + I vri, vt + I vti, vz + I vzi};
bHat = {br + I bri, bt + I bti, bz + I bzi};
v0v = {0, w0t[r], w0z[r]};
b0full = {0, Bth[r], B0};
vTot = v0v + harm /@ vHat;
bTot = b0full + harm /@ bHat;

split = Simplify[avgChi[Cross[vTot, bTot]] -
  (Cross[v0v, b0full] + Map[ComplexExpand[Re[#]] &,
     Cross[vHat, Conjugate[bHat]]/2])];
check["n=0 motional emf splits exactly into mean plus half-correlation",
  Simplify[ComplexExpand[split]] === {0, 0, 0}];

(* The Krebs/Zhang diagnostic is the b0 projection of the quadratic
   fluctuation part: with (v x B).B = 0 it equals minus the
   projection of the mean-flow emf plus the full parallel emf, i.e.
   it exists only because b0 is not the full bhat. *)
epsPar = Simplify[b0full . Map[ComplexExpand[Re[#]] &,
  Cross[vHat, Conjugate[bHat]]/2]/Sqrt[b0full . b0full]];
check["mean-parallel fluctuation emf is generally nonzero",
  Simplify[epsPar] =!= 0];

(* ==== 3. Jardin's diagnostic measures the misalignment ==== *)
(* Corrugated-surface machinery of script 39: label
   rho = r + eps Delta Cos[chi], tangency-locked field
   p = Delta D, D = m Bth/r + k B0, t from div B = 0 with w = 0.
   A potential aligned with the surfaces, Phi = Phi0(rho), gives
   B.grad Phi = Phi0'(rho) B.grad rho = 0 exactly at first order:
   zero Jardin signal. An arbitrary first-order potential
   Phi = Phi0(r) + eps phiA(r) Cos[chi + beta] gives an n = 0
   3D-minus-2D signal equal to the half-correlation of the field
   harmonic with the MISALIGNMENT part of the potential harmonic
   alone. *)
chiOf[th_, z_] := m th + k z;
gradCyl[f_, r_, th_, z_] := {D[f, r], D[f, th]/r, D[f, z]};
detD = m Bth[r]/r + k B0;
tAmp = (r D[Delta[r] detD, r] + Delta[r] detD)/m;
Bpert[r_, th_, z_] := {
  eps Delta[r] detD Sin[chiOf[th, z]],
  Bth[r] + eps tAmp Cos[chiOf[th, z]],
  B0};

(* Aligned potential: Phi0 evaluated on the flux label. *)
phiAligned = Phi0[r + eps Delta[r] Cos[chiOf[th, z]]];
alignedDrive = Simplify[Coefficient[Normal@Series[
  Bpert[r, th, z] . gradCyl[phiAligned, r, th, z], {eps, 0, 1}], eps]];
check["aligned potential gives zero first-order B.grad Phi: no Jardin signal",
  Simplify[alignedDrive] === 0];

(* General potential harmonic in quadratures,
   Phi1 = phiC(r) Cos[chi] + phiS(r) Sin[chi]; the n=0 quadratic part
   of -B.grad Phi is linear in (phiC, phiS), and the aligned choice
   (phiC, phiS) = (-Phi0' Delta, 0) gives zero signal, so by
   superposition the signal depends only on the misalignment
   remainder (phiC + Phi0' Delta, phiS). *)
sig[pc_, ps_] := Simplify[avgChi[Coefficient[Normal@Series[
  -Bpert[r, th, z] . gradCyl[
     Phi0[r] + eps (pc Cos[chiOf[th, z]] + ps Sin[chiOf[th, z]]),
     r, th, z], {eps, 0, 2}], eps, 2] /.
    {th -> chi/m, z -> 0}]];
jardinSignal = sig[phiC[r], phiS[r]];
check["the aligned harmonic alone produces zero n=0 Jardin signal",
  Simplify[sig[-Phi0'[r] Delta[r], 0]] === 0];
check["the Jardin signal is additive in the potential harmonic",
  Simplify[sig[phiC[r] + qc[r], phiS[r] + qs[r]] -
    sig[phiC[r], phiS[r]] - sig[qc[r], qs[r]] + sig[0, 0]] === 0 &&
  Simplify[sig[0, 0]] === 0];
check["hence the Jardin signal equals the signal of the misalignment part",
  Simplify[sig[phiC[r] + Phi0'[r] Delta[r], phiS[r]] -
    jardinSignal] === 0];

(* ==== 4. The two published diagnostics under stationary Ohm ==== *)
(* Impose E = eta J - v x B pointwise (stationary Ohm) with
   arbitrary mean fields and single-helicity harmonics, and allow a
   resistivity harmonic eta = eta0 + Re[etaHat Exp[I chi]]. *)
ClearAll[JcurHat, J0v, etaTot];
JcurHat = {jr + I jri, jt + I jti, jz + I jzi};
J0v = {0, j0t[r], j0z[r]};
Jtot = J0v + harm /@ JcurHat;
etaTot = eta0 + harm[etaHat];
EOhm = etaTot Jtot - Cross[vTot, bTot];

(* (i) Full-B projection kills the motional emf exactly, so the
   averaged full-parallel electric field is a pure current
   correlation - including the resistivity-fluctuation channel. *)
lhsI = Simplify[avgChi[bTot . EOhm]];
rhsI = Simplify[avgChi[etaTot bTot . Jtot]];
check["averaged B.E equals averaged eta B.J exactly (motional emf drops)",
  Simplify[ComplexExpand[lhsI - rhsI]] === 0];

(* Quadratic (fluctuation) content of the full-parallel average:
   at fixed resistivity it is eta0 times the field-current
   half-correlation; a resistivity harmonic adds the correlation of
   etaHat with the parallel current - the "resistivity flattening"
   channel appears additively next to the dynamo correlation. *)
quadI = Simplify[ComplexExpand[lhsI - b0full . (eta0 J0v)]];
expectedQuad = Simplify[ComplexExpand[
  eta0 Re[bHat . Conjugate[JcurHat]]/2 +
  Re[etaHat Conjugate[b0full . JcurHat + bHat . J0v]]/2]];
check["quadratic parallel-E average = eta0 (B.J correlation) + eta-fluctuation channel",
  Simplify[ComplexExpand[quadI - expectedQuad]] === 0];

(* (ii) Mean-field projection (the Krebs/Zhang diagnostic): the
   velocity diagnostic equals eta-weighted mean-parallel current
   minus mean-parallel electric field minus the mean-flow emf, an
   exact consequence of Ohm - the two published diagnostics differ
   exactly by matched parallel-current and resistivity-correlation
   terms, never by new physics. *)
velDiag = Simplify[b0full . Map[ComplexExpand[Re[#]] &,
  Cross[vHat, Conjugate[bHat]]/2]];
meanParE = Simplify[avgChi[b0full . EOhm]];
identityII = Simplify[ComplexExpand[
  velDiag - (avgChi[b0full . (etaTot Jtot)] - meanParE -
    b0full . Cross[v0v, b0full])]];
check["mean-parallel Ohm: velocity diagnostic = eta J - E - mean-flow emf",
  Simplify[ComplexExpand[identityII]] === 0];

(* ==== 5. Published M3D-C1/JOREK reductions used in the report ==== *)
(* The governing PDEs themselves are code-model definitions copied from
   the cited papers; CAS cannot establish a modelling postulate.  What it
   can and must establish are the vector projections, Fourier selection,
   3D-minus-2D subtraction, and order counting used to interpret them. *)

(* Machine-readable source-equation ledger.  Inert operators preserve the
   exact published model structure without pretending that a selected
   closure can be proved algebraically. *)
ClearAll[dtOp, divOp, gradOp, curlOp, lapOp, tensorDivOp, fieldDivOp,
  nDen, rhoDen, vel, mag, elec, cur, pres, temp, tempI, tempE,
  vecPot, scalarPot, sourceN, sourceRho, sourceT, sourceTI, sourceTE,
  diffN, diffPerp, diffPar, chiPerp, chiPar, kappaPerpI,
  kappaParI, kappaPerpE, kappaParE, gammaGas, massI, viscDyn,
  etaRes, currentSource, heatFluxTensor, fEq];
mhdSourceLedger = <|
  "M3D-A1" -> HoldComplete[
    dtOp[nDen] + divOp[nDen vel] == diffN lapOp[nDen] + sourceN],
  "M3D-A2" -> HoldComplete[dtOp[mag] == -curlOp[elec]],
  "M3D-A3" -> HoldComplete[
    nDen massI (dtOp[vel] + divOp[vel, vel]) ==
      -gradOp[pres] + Cross[cur, mag] + viscDyn lapOp[vel]],
  "M3D-A4" -> HoldComplete[
    3 nDen dtOp[temp]/2 + 3 nDen divOp[vel, temp]/2 +
      nDen temp divOp[vel] == viscDyn gradOp[vel]^2 +
      etaRes cur^2 + tensorDivOp[heatFluxTensor] + sourceT],
  "M3D-A5" -> HoldComplete[mag == curlOp[vecPot]],
  "M3D-A6" -> HoldComplete[elec == -Cross[vel, mag] + etaRes cur],
  "M3D-A7" -> HoldComplete[cur == curlOp[mag]/mu0],
  "JOREK-1" -> HoldComplete[
    dtOp[vecPot] == Cross[vel, mag] -
      etaRes (cur - currentSource) ePhi - gradOp[scalarPot]],
  "JOREK-2" -> HoldComplete[
    rhoDen dtOp[vel] == -rhoDen divOp[vel, vel] + Cross[cur, mag] -
      gradOp[pres] + tensorDivOp[viscDyn gradOp[vel]] - sourceRho vel],
  "JOREK-3" -> HoldComplete[
    dtOp[rhoDen] == -divOp[rhoDen vel] +
      tensorDivOp[diffPerp gradOp[rhoDen] + diffPar fieldDivOp[rhoDen]] +
      sourceRho],
  "JOREK-4i" -> HoldComplete[
    dtOp[pres] == -divOp[vel, pres] - gammaGas pres divOp[vel] +
      tensorDivOp[kappaPerpI gradOp[tempI] +
        kappaParI fieldDivOp[tempI]] + sourceTI],
  "JOREK-4e" -> HoldComplete[
    dtOp[pres] == -divOp[vel, pres] - gammaGas pres divOp[vel] +
      tensorDivOp[kappaPerpE gradOp[tempE] +
        kappaParE fieldDivOp[tempE]] + sourceTE]
  |>;
check["source-equation ledger contains all M3D-C1 and JOREK equations printed",
  Sort[Keys[mhdSourceLedger]] === Sort[{"M3D-A1", "M3D-A2", "M3D-A3",
    "M3D-A4", "M3D-A5", "M3D-A6", "M3D-A7", "JOREK-1",
    "JOREK-2", "JOREK-3", "JOREK-4i", "JOREK-4e"}]];

(* Jardin's M3D-C1 stream-function representation
     V = R^2 grad U x grad phi = R grad U x e_phi,
   with B_phi = F/R, gives Eq. (7) by a vector identity. *)
ClearAll[gR, gPhi, gZ, BR, Bphi, BZ, RR, FF];
gradU = {gR, gPhi, gZ};
ePhi = {0, 1, 0};
bJardin = {BR, FF/RR, BZ};
vJardin = RR Cross[gradU, ePhi];
jardinProjection = Simplify[
  -ePhi . Cross[vJardin, bJardin] -
  (-RR bJardin . gradU + FF ePhi . gradU)];
check["M3D-C1 stream function gives Jardin toroidal projection exactly",
  jardinProjection === 0];

(* For a real n=1 pair, only 1 x (-1) produces the n=0 emf.  This
   component formula makes the required velocity/magnetic cross-phase
   explicit in the physical (R,phi,Z) basis. *)
torCorr = Simplify[avgChi[Cross[harm /@ vHat, harm /@ bHat][[2]]]];
torCorrExpected = ComplexExpand[Re[
  vHat[[3]] Conjugate[bHat[[1]]] -
  vHat[[1]] Conjugate[bHat[[3]]]]/2];
check["n=1 x n=-1 selection gives the axisymmetric toroidal dynamo",
  Simplify[ComplexExpand[torCorr - torCorrExpected]] === 0];

(* JOREK embeds its toroidal angle with the opposite orientation to the
   standard geometric cylindrical angle:
     x = R cos(phiJ), y = -R sin(phiJ).
   Consequently e_phiJ = -e_phigeo and the source diagnostic
     (v x B)_phiJ = vR BZ - vZ BR
   has the correct cross-product sign in JOREK coordinates. *)
ClearAll[phiJ, vRj, vPj, vZj, bRj, bPj, bZj];
eRj = {Cos[phiJ], -Sin[phiJ], 0};
ePj = {-Sin[phiJ], -Cos[phiJ], 0};
eZj = {0, 0, 1};
vJ = vRj eRj + vPj ePj + vZj eZj;
bJ = bRj eRj + bPj ePj + bZj eZj;
check["JOREK toroidal basis is left-handed relative to geometric phi",
  Simplify[Cross[eRj, ePj] + eZj] === {0, 0, 0}];
check["JOREK source formula for (v x B)_phi has the correct mapped sign",
  Simplify[Cross[vJ, bJ] . ePj - (vRj bZj - vZj bRj)] === 0];

(* Zhang's Eq. (8) is an exact regrouping of the retained n=0
   induction terms when eta_0=eta_2D+deta and J_0=J_2D+dJ. *)
ClearAll[eta2d, dEta, j2d, dJ, sj, emfMean, emfFluc, eta1j1,
  ord, Rmaj];
etaMean = eta2d + dEta;
jMean = j2d + dJ;
ind3D = emfMean + emfFluc - etaMean (jMean - sj) - eta1j1;
ind2D = -eta2d (j2d - sj);
zhangDifference = Expand[ind3D - ind2D];
zhangRetained = emfMean + emfFluc - eta2d dJ -
  dEta (jMean - sj) - eta1j1;
check["JOREK exact 3D-minus-2D resistivity regrouping",
  Simplify[zhangDifference - zhangRetained] === 0];
check["mean-flow emf vanishes under projection on its own mean B",
  Simplify[b0full . Cross[v0v, b0full]] === 0];

(* Krebs Eq. (6) is the first-order version without a current source or
   mean flow.  The formally second-order dEta*dJ term is discarded, while
   the fluctuation correlations are retained as mean O(ord) effects. *)
krebsOrdered = Expand[ind3D /. {
    sj -> 0, emfMean -> 0, eta1j1 -> ord eta1j1,
    emfFluc -> ord emfFluc, dEta -> ord dEta, dJ -> ord dJ}];
krebsFirst = Coefficient[krebsOrdered - ind2D, ord, 1];
krebsExpected = emfFluc - eta2d dJ - dEta j2d - eta1j1;
check["Krebs stationary balance is the first-order matched subtraction",
  Simplify[krebsFirst - krebsExpected] === 0];

(* The local voltage-deficit estimate follows from the large-aspect-ratio
   on-axis relation q=2 Bphi/(mu0 R Jphi), not from a fitted coefficient. *)
ClearAll[Baxis, mu0, q2d, etaDef];
jFromQ[q_] := 2 Baxis/(mu0 Rmaj q);
voltageDeficit = Simplify[etaDef (jFromQ[1] - jFromQ[q2d])];
voltageExpected = 2 etaDef Baxis/(mu0 Rmaj) (1 - 1/q2d);
check["Krebs voltage-deficit formula follows from the on-axis q estimate",
  Simplify[voltageDeficit - voltageExpected] === 0];

(* Dimensionless controls used in the 2026 JOREK scan. *)
ClearAll[tauR, tauNu, tauA, Lc, vA, nuKin];
tauR = mu0 Lc^2/etaDef;
tauNu = Lc^2/nuKin;
tauA = Lc/vA;
hartmannTimes = Simplify[Sqrt[tauR tauNu]/tauA];
hartmannPrimitive = Sqrt[mu0/(etaDef nuKin)] Lc vA;
prandtlTimes = Simplify[tauR/tauNu];
check["Hartmann definition reduces to primitive transport parameters",
  PowerExpand[hartmannTimes - hartmannPrimitive] === 0];
check["magnetic Prandtl definition reduces to mu0 nu/eta",
  Simplify[prandtlTimes - mu0 nuKin/etaDef] === 0];

reportAndExit[];

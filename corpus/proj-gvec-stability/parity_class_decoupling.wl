ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* The dual-parity family assembly carries two trial classes per mode:
   class 1 (xi ~ cos, eta ~ sin) and class 2 (xi ~ sin, eta ~ cos).
   For stellarator-symmetric coefficient fields -- even under
   P: (theta, zeta) -> (-theta, -zeta) for sqrt(g), B, |grad s|^2,
   j.B, the metric g_tt, g_tz, g_zz, and the drive; odd for
   sigma_tilde, beta_tilde, g_st, g_sz -- every cross-class energy
   integrand is P-odd, so its angular average vanishes and the
   assembled family matrix is block-diagonal in the classes.  The
   uniform angular quadrature grid is P-symmetric modulo one period
   (-theta_j = theta_(N-j)), so the discrete assembly enjoys the same
   cancellation to round-off, and the Schur condensation of the
   tangential block preserves the block structure.  Transcribed
   exactly from two_component_components and add_drive_chart_term. *)

pmap = {theta -> -theta, zeta -> -zeta};

(* Flux-surface functions: angular constants. *)
fluxTslope = FTp; fluxPslope = FPp;
fluxTcurve = FTc; fluxPcurve = FPc;
currentI = Ic; currentJ = Jc; pressureSlope = Ps;

(* Even coefficient fields: generic cosine representatives (parity is
   termwise, so generic terms carry the argument for the full series). *)
sqg = e0 + e1 Cos[theta - zeta] + e2 Cos[2 theta - 3 zeta];
bmag = f0 + f1 Cos[theta - zeta];
gradS2 = g0 + g1 Cos[2 theta - zeta];
jDotB = h0 + h1 Cos[theta];
driveA = d0 + d1 Cos[theta - zeta];
(* Odd coefficient fields: sine representatives.  sb is an even
   symmetry-breaking part, zero in the stellarator-symmetric checks. *)
sigmaT = s1 Sin[theta - zeta] + s2 Sin[2 theta - 3 zeta] + sb;
betaT = t1 Sin[theta - zeta] + t2 Sin[theta];

bgrad[xt_, xz_] := (fluxPslope xt + fluxTslope xz)/sqg;
cOne[xt_, xz_] := bgrad[xt, xz]/Sqrt[gradS2];
cTwo[x_, xt_, xz_, et_, ez_] := -(Sqrt[gradS2]/(bmag sqg)) (
  sqg bgrad[et, ez]
  - (fluxTslope fluxPcurve - fluxTcurve fluxPslope) x
  + jDotB sqg x/gradS2
  + sigmaT bmag sqg bgrad[xt, xz]/gradS2);
cThree[x_, xs_, xt_, xz_, et_, ez_] := (1/(bmag sqg)) (
  currentJ ez - currentI et
  - (fluxTslope currentI + fluxPslope currentJ) xs
  - (currentJ fluxPcurve + currentI fluxTcurve) x
  - pressureSlope sqg x
  + betaT sqg bgrad[xt, xz]);
energyBilinear[u_, v_] := (cOne[u[[3]], u[[4]]] cOne[v[[3]], v[[4]]]
  + cTwo[u[[1]], u[[3]], u[[4]], u[[5]], u[[6]]]
    cTwo[v[[1]], v[[3]], v[[4]], v[[5]], v[[6]]]
  + cThree[u[[1]], u[[2]], u[[3]], u[[4]], u[[5]], u[[6]]]
    cThree[v[[1]], v[[2]], v[[3]], v[[4]], v[[5]], v[[6]]]
  - driveA u[[1]] v[[1]]) sqg;
(* sqg as weight: the assembly uses |sqrt g|; the sign is an angular
   constant, so the parity statements are unaffected. *)

(* Trial slot vectors (xi, xi_s, xi_theta, xi_zeta, eta_theta,
   eta_zeta) with independent amplitudes: a superset of the assembled
   hat/step radial structure, so the identities cover every matrix
   sub-block including the tangential one. *)
phiA = m theta - n zeta; phiB = mp theta - np zeta;
classA = {a1 Cos[phiA], a2 Cos[phiA], -a3 Sin[phiA], a4 Sin[phiA],
  a5 Cos[phiA], a6 Cos[phiA]};
classB = {b1 Sin[phiB], b2 Sin[phiB], b3 Cos[phiB], b4 Cos[phiB],
  -b5 Sin[phiB], b6 Sin[phiB]};

crossDensity = energyBilinear[classA, classB] /. sb -> 0;
check["cross-class energy integrand is P-odd (average vanishes)",
  Simplify[TrigExpand[crossDensity + (crossDensity /. pmap)]] == 0];

sameA = energyBilinear[classA, classA] /. sb -> 0;
sameB = energyBilinear[classB, classB] /. sb -> 0;
check["class-1 energy integrand is P-even",
  Simplify[TrigExpand[sameA - (sameA /. pmap)]] == 0];
check["class-2 energy integrand is P-even",
  Simplify[TrigExpand[sameB - (sameB /. pmap)]] == 0];

(* Negative check: an even (symmetry-breaking) sigma_tilde part
   couples the classes -- the (xi_theta, eta_theta) cross entry
   between the classes survives the angular average. *)
brokenAverage = Integrate[
    energyBilinear[classA, classB] /. {m -> 1, n -> 1, mp -> 1,
      np -> 1, e0 -> 2, e1 -> 1/2, e2 -> 0, f0 -> 3, f1 -> 0, g0 -> 1,
      g1 -> 0, h0 -> 1, h1 -> 0, d0 -> 1, d1 -> 0, s1 -> 0, s2 -> 0,
      sb -> 1, t1 -> 0, t2 -> 0, FTp -> 1, FPp -> 1/3, FTc -> 1,
      FPc -> 1, Ic -> 1, Jc -> 1, Ps -> 1},
    {theta, 0, 2 Pi}, {zeta, 0, 2 Pi}]/(4 Pi^2);
check["an even sigma_tilde part couples the classes",
  Simplify[D[D[brokenAverage, a3], b5]] =!= 0];

(* Drive chart term (add_drive_chart_term): the operand built from the
   odd g_st, g_sz and the even beta-derivatives is P-odd, and the
   forward magnetic operator makes the added drive term P-even, so the
   assembled drive keeps the even parity the decoupling needs. *)
gst = u1 Sin[theta - zeta] + u2 Sin[2 theta - zeta];
gsz = u3 Sin[theta - zeta] + u4 Sin[theta];
gtt = w0 + w1 Cos[theta];
gtz = v0 + v1 Cos[theta - zeta];
gzz = q0 + q1 Cos[theta - zeta];
upperTS = (gsz gtz - gst gzz)/sqg^2;
upperZS = (gst gtz - gsz gtt)/sqg^2;
gradS2chart = (gtt gzz - gtz^2)/sqg^2;
operand = ((Ip - D[betaT, theta]) upperTS
  - (D[betaT, zeta] - Jp) upperZS)/gradS2chart;
chartTerm = (FPp D[operand, theta] + FTp D[operand, zeta])/sqg;
check["drive chart operand is P-odd",
  Simplify[TrigExpand[operand + (operand /. pmap)]] == 0];
check["drive chart term is P-even",
  Simplify[TrigExpand[chartTerm - (chartTerm /. pmap)]] == 0];

(* Angular constants and vanishing sigma_tilde, beta_tilde (the
   unshifted cylinder): the quarter-phase shift (cos phi -> sin phi,
   sin phi -> -cos phi) maps a class-1 trial to the class-2 trial
   with the tangential amplitude negated, so the raw averages differ
   in the xi-eta cross term, but the condensed forms -- minimized
   over the tangential amplitude, as the assembly condenses -- are
   blind to that sign and coincide: the degenerate dual-parity pair
   the family tests observe.  Faithful single-trial slot vectors: the
   derivative slots carry the trial's own amplitudes and mode
   factors. *)
cylinderRules = {e1 -> 0, e2 -> 0, f1 -> 0, g1 -> 0, h1 -> 0, d1 -> 0,
  s1 -> 0, s2 -> 0, sb -> 0, t1 -> 0, t2 -> 0};
trialA = {xv Cos[phiA], xs Cos[phiA], -m xv Sin[phiA],
  n xv Sin[phiA], m yv Cos[phiA], -n yv Cos[phiA]};
trialB = {xv Sin[phiA], xs Sin[phiA], m xv Cos[phiA],
  -n xv Cos[phiA], -m yv Sin[phiA], n yv Sin[phiA]};
average[expr_] := Integrate[TrigReduce[expr],
  {theta, 0, 2 Pi}, {zeta, 0, 2 Pi}]/(4 Pi^2);
condense[w_] := Module[{q = CoefficientList[w, yv]},
  q[[1]] - q[[2]]^2/(4 q[[3]])];
integerModes = {Element[m, Integers], Element[n, Integers],
  m >= 1, n >= 1};
averageA = Simplify[
  average[energyBilinear[trialA, trialA] /. cylinderRules],
  Assumptions -> integerModes];
averageB = Simplify[
  average[energyBilinear[trialB, trialB] /. cylinderRules],
  Assumptions -> integerModes];
check["condensed cylinder class energies are degenerate",
  Simplify[condense[averageA] - condense[averageB]] == 0];
check["the raw class averages differ only in the tangential cross sign",
  Simplify[(averageB /. yv -> -yv) - averageA] == 0];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

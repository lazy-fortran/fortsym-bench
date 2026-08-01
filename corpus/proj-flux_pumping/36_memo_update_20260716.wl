(* Verification of the 2026-07-16 memo update (memo_HC_and_RMP_ext.tex,
   sha256 a731ff2c..., received 2026-07-16 18:38 UTC).  The update adopts
   the reported corrections (helical phase renamed to phi, (phicompamp)
   prose sign, (checkjrzero) derivative, dk measure in the transform pair,
   signed Bessel orders with corrected prefactors, m>0 qualifier, B15
   coefficient) and adds two subsections: "Field line integration" (exact
   helical-flux Hamiltonian and rotational transform) and "Small
   corrugations" (second-order expansion of the transform).  This script
   checks the adopted corrections against our derived values, verifies the
   new exact construction symbolically and numerically against the script-33
   fixture and decomposition, re-derives the second-order expansion from
   first principles, and pins the remaining typos.
   Cylinder metric diag(1, r^2, R0^2), phase Exp[I(m th + n ph)], CGS. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* ==== Part 1: Appendix B updates ==== *)

(* B15 (intcurr_simpl_anom_smallDr): the update replaces the superseded
   coefficient 2^(11/3) Gamma[1/3]^2/(3^(8/3) Sqrt[Pi]) by
   2^(2/3) Gamma[1/6] Gamma[1/3]/(3^(5/3) Sqrt[Pi]). *)
b15New = 2^(2/3) Gamma[1/6] Gamma[1/3]/(3^(5/3) Sqrt[Pi]);
b15Ours = 2^(1/3) Gamma[1/3]^3/(3^(7/6) Pi);
b15Old = 2^(11/3) Gamma[1/3]^2/(3^(8/3) Sqrt[Pi]);
(* Gamma(1/6) = Sqrt[3] Gamma(1/3)^2/(2^(1/3) Sqrt[Pi]) follows from the
   duplication formula at z=1/6 and the reflection formula at 1/3; with it
   the printed form reduces exactly to the derived coefficient. *)
gammaSixth = Sqrt[3] Gamma[1/3]^2/(2^(1/3) Sqrt[Pi]);
check["Gamma(1/6) reduction via duplication and reflection (50-digit witness)",
  Abs[N[Gamma[1/6] - gammaSixth, 60]] < 10^-50];
check["B15 update: printed Gamma(1/6)Gamma(1/3) form equals the derived coefficient",
  FullSimplify[(b15New /. Gamma[1/6] -> gammaSixth) == b15Ours]];
check["B15 update: numeric value 2.1401304355",
  Abs[N[b15New, 20] - 2.1401304355] < 10^-9];
check["B15 update: the superseded printed value 2.7466534496 is replaced",
  Abs[N[b15Old, 20] - 2.7466534496] < 10^-9 &&
    FullSimplify[b15New == b15Old] =!= True];

(* (fourdef)/(greencoord): the inverse transform now integrates over dk.
   Round trip on a Gaussian. *)
gaussian[x_] = Exp[-x^2/2];
forward[k_] = Integrate[Exp[-I k x] gaussian[x], {x, -Infinity, Infinity}];
roundTrip = FullSimplify[
  Integrate[Exp[I k y] forward[k], {k, -Infinity, Infinity}]/(2 Pi),
  Element[y, Reals]];
check["(fourdef)/(greencoord): dk inverse transform closes the Gaussian round trip",
  FullSimplify[roundTrip == gaussian[y], Element[y, Reals]]];

(* The electric-drive supports (unchanged in this update): the magnetic
   top-hat Theta(Dr-x)Theta(Dr+x) and the electric 1-Theta Theta factor have
   disjoint supports, so the prose "region where both are nonzero" remains
   contradicted. *)
tophat[x_, dr_] = UnitStep[dr - x] UnitStep[dr + x];
check["electric drive: magnetic and electric supports remain disjoint",
  Simplify[PiecewiseExpand[tophat[x, dr] (1 - tophat[x, dr])] == 0,
    Element[x, Reals] && dr > 0]];

(* ==== Part 2: signed Maxwell solution ==== *)

(* (solbes) with k_z = |n|/R0, orders |m|, prefactor 4 pi n k_z/(c m R0):
   verify it solves (divB0_fouramp),
   (1/r)(r Bphi')' - (m^2/r^2 + n^2/R0^2) Bphi = (4 pi n/(c m R0 r)) (r^2 j)',
   for all four sign combinations of (m, n).  The radial integrals are kept
   formal: kj' = -r^2 (d/dr K_|m|(kz r)/kz) j, ij' = r^2 (d/dr I_|m|(kz r)/kz) j,
   matching the memo's K'_|m|(kz r'), I'_|m|(kz r') integrands. *)
ClearAll[besselCheck];
besselCheck[mSgn_Integer, nSgn_Integer] := Module[
  {mm, nn, mAbs, kz, ii, kk, kj, ij, bphi, resid, source},
  mm = 2 mSgn; nn = 3 nSgn;
  mAbs = Abs[mm]; kz = Abs[nn]/R0;
  ii[r_] = BesselI[mAbs, kz r]; kk[r_] = BesselK[mAbs, kz r];
  kj /: Derivative[1][kj] = Function[r, -r^2 (D[BesselK[mAbs, kz s], s]/kz /. s -> r) j[r]];
  ij /: Derivative[1][ij] = Function[r, r^2 (D[BesselI[mAbs, kz s], s]/kz /. s -> r) j[r]];
  bphi[r_] = (4 Pi nn kz/(cc mm R0)) (ii[r] kj[r] + kk[r] ij[r]);
  resid = D[r D[bphi[r], r], r]/r - (mm^2/r^2 + nn^2/R0^2) bphi[r];
  source = (4 Pi nn/(cc mm R0 r)) D[r^2 j[r], r];
  FullSimplify[resid - source == 0, r > 0 && R0 > 0]
];
check["(solbes) signed: solves (divB0_fouramp) for m>0, n>0", besselCheck[1, 1]];
check["(solbes) signed: solves (divB0_fouramp) for m>0, n<0", besselCheck[1, -1]];
check["(solbes) signed: solves (divB0_fouramp) for m<0, n>0", besselCheck[-1, 1]];
check["(solbes) signed: solves (divB0_fouramp) for m<0, n<0", besselCheck[-1, -1]];

(* (brsol): the first form (i R0^2/n)((4 pi n/(c m R0)) r j - Bphi')
   equals the printed second integral form through the Wronskian
   W = I K' - K I' = -1/x. *)
ClearAll[brsolCheck];
brsolCheck[mSgn_Integer, nSgn_Integer] := Module[
  {mm, nn, mAbs, kz, ii, kk, iip, kkp, kj, ij, bphi, brFirst, brSecond},
  mm = 2 mSgn; nn = 3 nSgn;
  mAbs = Abs[mm]; kz = Abs[nn]/R0;
  ii[r_] = BesselI[mAbs, kz r]; kk[r_] = BesselK[mAbs, kz r];
  iip[r_] = D[BesselI[mAbs, kz s], s]/kz /. s -> r;
  kkp[r_] = D[BesselK[mAbs, kz s], s]/kz /. s -> r;
  kj /: Derivative[1][kj] = Function[r, -r^2 kkp[r] j[r]];
  ij /: Derivative[1][ij] = Function[r, r^2 iip[r] j[r]];
  bphi[r_] = (4 Pi nn kz/(cc mm R0)) (ii[r] kj[r] + kk[r] ij[r]);
  brFirst = (I R0^2/nn) ((4 Pi nn/(cc mm R0)) r j[r] - D[bphi[r], r]);
  brSecond = (4 Pi nn^2/(I cc mm R0)) (iip[r] kj[r] + kkp[r] ij[r]);
  FullSimplify[brFirst - brSecond == 0, r > 0 && R0 > 0]
];
check["(brsol) signed: derivative and integral forms agree via the Wronskian for m>0, n>0",
  brsolCheck[1, 1]];
check["(brsol) signed: derivative and integral forms agree via the Wronskian for m<0, n<0",
  brsolCheck[-1, -1]];

(* (solbes_approx): leading-order forms with |m| powers and sgn(m) in B^r.
   Substitute the leading Bessel behaviour I_M(x) ~ (x/2)^M/M!,
   K_M(x) ~ ((M-1)!/2)(2/x)^M into the exact solutions with formal
   integrals: the memo prints
   Bphi ~ (2 pi n/(c m R0)) (r^-|m| Int_0^r r'^(1+|m|) j - r^|m| Int_r^inf r'^(1-|m|) j),
   Br   ~ (2 pi i R0 sgn(m)/(c r)) (r^-|m| Int_0^r r'^(1+|m|) j + r^|m| Int_r^inf r'^(1-|m|) j). *)
ClearAll[leadingCheck];
leadingCheck[mSgn_Integer, nSgn_Integer] := Module[
  {mm, nn, mAbs, kz, iiL, kkL, iipL, kkpL, innerCoef, outerCoef,
   bphiLead, brLead, bphiPrinted, brPrinted, intInner, intOuter},
  mm = 2 mSgn; nn = 3 nSgn;
  mAbs = Abs[mm]; kz = Abs[nn]/R0;
  iiL[x_] = (x/2)^mAbs/mAbs!;
  kkL[x_] = ((mAbs - 1)!/2) (2/x)^mAbs;
  iipL[x_] = D[iiL[x], x]; kkpL[x_] = D[kkL[x], x];
  (* exact integrands r'^2 K'(kz r') j and r'^2 I'(kz r') j at leading order:
     collect the pure powers of r'; intInner and intOuter denote
     Int_0^r r'^(1+|m|) j dr' and Int_r^inf r'^(1-|m|) j dr'. *)
  innerCoef = FullSimplify[r^2 iipL[kz r] j[r]/(r^(1 + mAbs) j[r])];
  outerCoef = FullSimplify[r^2 kkpL[kz r] j[r]/(r^(1 - mAbs) j[r])];
  bphiLead = (4 Pi nn kz/(cc mm R0)) (iiL[kz r] outerCoef intOuter +
    kkL[kz r] innerCoef intInner);
  brLead = (4 Pi nn^2/(I cc mm R0)) (iipL[kz r] outerCoef intOuter +
    kkpL[kz r] innerCoef intInner);
  bphiPrinted = (2 Pi nn/(cc mm R0)) (r^-mAbs intInner - r^mAbs intOuter);
  brPrinted = (2 Pi I R0 Sign[mm]/(cc r)) (r^-mAbs intInner + r^mAbs intOuter);
  FullSimplify[{bphiLead == bphiPrinted, brLead == brPrinted},
    r > 0 && R0 > 0] === {True, True}
];
check["(solbes_approx): leading forms including sgn(m) verified for m>0, n>0",
  leadingCheck[1, 1]];
check["(solbes_approx): leading forms including sgn(m) verified for m<0, n>0",
  leadingCheck[-1, 1]];
check["(solbes_approx): leading forms including sgn(m) verified for m>0, n<0",
  leadingCheck[1, -1]];

(* ==== Part 3: field line integration (new subsection) ==== *)

(* (divB0again): for helically symmetric fields B^k(r, phi) with
   phi = m th + n ph and s = r^2/2, the cylinder divergence reduces to
   d(B^s)/ds + d(B^phihel)/dphi with B^s = r B^r,
   B^phihel = m B^th + n B^ph. *)
ClearAll[br0, bth0, bph0, divCyl, divHel];
divCyl = D[r br0[r, m th + n ph], r]/r +
  D[bth0[r, m th + n ph], th] + D[bph0[r, m th + n ph], ph];
divHel = With[{s = r^2/2},
  (D[(rr br0[rr, hp]) /. rr -> Sqrt[2 ss], ss] /. ss -> r^2/2 /. hp -> m th + n ph) +
  (D[m bth0[r, hp] + n bph0[r, hp], hp] /. hp -> m th + n ph)];
check["(divB0again): cylinder divergence equals d_s B^s + d_phi B^phihel",
  FullSimplify[divCyl == divHel, r > 0]];

(* (hamform)/(checkpsi): with B^s = -d(psi)/dphi and B^phihel = d(psi)/ds,
   psi is invariant along field lines. *)
ClearAll[psiH];
check["(checkpsi): psi from (hamform) is a field-line invariant",
  Simplify[(-D[psiH[s, p], p]) D[psiH[s, p], s] +
    D[psiH[s, p], s] D[psiH[s, p], p] == 0]];

(* (psihel) => (hamform): with psi = Int_0^s B^phihel ds', divergence-free
   B, and B^s(0,phi)=0, the phi derivative returns -B^s. *)
ClearAll[bsF, bpF];
(* represent B^s via the divergence constraint d_s B^s = -d_phi B^phihel *)
bsF[s_, p_] = -Integrate[D[bpF[sp, p], p], {sp, 0, s}];
check["(psihel): -d_phi psi recovers B^s for divergence-free fields with B^s(0)=0",
  Simplify[-D[Integrate[bpF[sp, p], {sp, 0, s}], p] == bsF[s, p]]];

(* The script-33 analytic Maxwell fixture (m=n=1, R0=5), reused verbatim. *)
mNum = 1; nNum = 1; capRNum = 5; kNum = nNum/capRNum;
iotaBackgroundExpr = -3/4 + 3 x^2/100;
bz0Expr = 1;
btheta0Expr = iotaBackgroundExpr x/capRNum;
detExpr = FullSimplify[mNum btheta0Expr/x + kNum bz0Expr];
uExpr = x^3/100;
sourceExpr = (8 x/3 - kNum^2 x^3/5)/100;
fExpr = FullSimplify[(D[uExpr, x] - x sourceExpr)/mNum];
gExpr = uExpr/x;
hExpr = kNum uExpr/mNum;
phaseExpr = FullSimplify[mNum gExpr/x + kNum hExpr];

(* (psihel) on the fixture: the helical flux amplitude Int_0^r (m g + k r' h)
   equals r f, the invariant used by script 33's direct trace. *)
check["(psihel) fixture: Int_0^r (m g + k r' h) dr' = r f",
  FullSimplify[Integrate[(mNum gExpr + kNum xp hExpr) /. x -> xp, {xp, 0, x},
      Assumptions -> x > 0] == x fExpr, x > 0]];

(* (deliota) exact transform by helical-flux quadrature versus a direct
   NDSolve field-line trace of ds/dphi = B^s/B^phihel,
   dvarphi/dphi = B^varphi/B^phihel. *)
ClearAll[fV, gV, hV, dV, pV, b0V, iotaQuad, iotaTrace];
fV[y_] := fExpr /. x -> y; gV[y_] := gExpr /. x -> y;
hV[y_] := hExpr /. x -> y; dV[y_] := detExpr /. x -> y;
pV[y_] := phaseExpr /. x -> y;
b0V[y_] := btheta0Expr /. x -> y;

(* his quadrature: s(psi,phi) from psi(s,phi)=const, then
   iota - iota_m = (bar(m B^varphi/B^phihel))^-1 *)
iotaQuad[rho_?NumericQ, amp_?NumericQ] := Module[
  {psi0, invar, rOnSurf, average},
  psi0[y_?NumericQ] := NIntegrate[yp dV[yp], {yp, 0, y},
    WorkingPrecision -> 40, AccuracyGoal -> 30, PrecisionGoal -> 28];
  invar[y_?NumericQ, phv_?NumericQ] := psi0[y] + amp y fV[y] Cos[phv];
  rOnSurf[phv_?NumericQ] := rr /. FindRoot[
    invar[rr, phv] == invar[rho, Pi/2], {rr, rho},
    WorkingPrecision -> 40, AccuracyGoal -> 26, PrecisionGoal -> 26];
  average = NIntegrate[
    With[{y = rOnSurf[phv]},
      mNum ((bz0Expr /. x -> y) + amp hV[y] Cos[phv])/
        (capRNum (dV[y] + amp pV[y] Cos[phv]))],
    {phv, 0, 2 Pi}, WorkingPrecision -> 35, AccuracyGoal -> 24,
    PrecisionGoal -> 22, MaxRecursion -> 18]/(2 Pi);
  1/average];

iotaTrace[rho_?NumericQ, amp_?NumericQ] := Module[
  {sol, varphiAdvance, sInit},
  sInit = rho^2/2;
  sol = NDSolve[{
      sF'[phv] == amp Sqrt[2 sF[phv]] fV[Sqrt[2 sF[phv]]] Sin[phv]/
        (dV[Sqrt[2 sF[phv]]] + amp pV[Sqrt[2 sF[phv]]] Cos[phv]),
      vF'[phv] == ((bz0Expr /. x -> Sqrt[2 sF[phv]]) +
          amp hV[Sqrt[2 sF[phv]]] Cos[phv])/
        (capRNum (dV[Sqrt[2 sF[phv]]] + amp pV[Sqrt[2 sF[phv]]] Cos[phv])),
      sF[Pi/2] == sInit, vF[Pi/2] == 0},
    {sF, vF}, {phv, Pi/2, Pi/2 + 2 Pi},
    WorkingPrecision -> 32, AccuracyGoal -> 22, PrecisionGoal -> 22,
    MaxSteps -> 10^6][[1]];
  varphiAdvance = vF[Pi/2 + 2 Pi] /. sol;
  2 Pi/(mNum varphiAdvance)];

rhoCheck = 1;
ampCheck = 1/500;
quadValue = iotaQuad[rhoCheck, ampCheck];
traceValue = iotaTrace[rhoCheck, ampCheck];
Print["    (deliota) quadrature = ", N[quadValue, 20]];
Print["    field-line trace     = ", N[traceValue, 20]];
check["(deliota): helical-flux quadrature equals the direct field-line trace",
  Abs[quadValue - traceValue] < 10^-12];

(* Second-order coefficient of his exact formula versus the script-33
   corrugated-path (geometric) coefficient: (deliota) with first-order
   fields only reproduces the geometric term, not the mean-current term. *)
deltaExpr = FullSimplify[fExpr/detExpr];
gammaExpr = FullSimplify[deltaExpr D[deltaExpr, x] +
  deltaExpr^2 (1 + x D[detExpr, x]/detExpr)/(2 x)];
a0Expr = FullSimplify[bz0Expr/(capRNum detExpr)];
a1Expr = FullSimplify[(hExpr detExpr - bz0Expr phaseExpr)/(capRNum detExpr^2)];
a2Expr = FullSimplify[bz0Expr phaseExpr^2/(capRNum detExpr^3) -
  hExpr phaseExpr/(capRNum detExpr^2)];
hSeriesExpr = FullSimplify[gammaExpr D[a0Expr, x] +
  deltaExpr^2 D[a0Expr, {x, 2}]/2 - deltaExpr D[a1Expr, x] + a2Expr];
cHelicalExpr = FullSimplify[-hSeriesExpr/(2 mNum a0Expr^2)];
bthetaMeanExpr = FullSimplify[sourceExpr deltaExpr/2];
cMeanExpr = FullSimplify[capRNum bthetaMeanExpr/(x bz0Expr)];

iotaZeroQuad = iotaQuad[rhoCheck, 0];
iotaMinusQuad = iotaQuad[rhoCheck, -ampCheck];
quadCoefficient = (quadValue + iotaMinusQuad - 2 iotaZeroQuad)/(2 ampCheck^2);
cHelicalValue = N[cHelicalExpr /. x -> rhoCheck, 20];
cMeanValue = N[cMeanExpr /. x -> rhoCheck, 20];
Print["    quadrature eps^2 coefficient = ", N[quadCoefficient, 12]];
Print["    script-33 geometric term     = ", N[cHelicalValue, 12]];
Print["    script-33 mean-current term  = ", N[cMeanValue, 12]];
check["(deliota) second order: exact formula reproduces the geometric transform term",
  Abs[quadCoefficient - cHelicalValue] < 2 10^-7];
check["(deliota) second order: the mean-current term is a separate physics input",
  Abs[quadCoefficient - (cHelicalValue + cMeanValue)] > 10^-4];

(* ==== Part 4: small corrugations, derived from first principles ==== *)

(* Generic single-harmonic fields:
   B^phihel = P(s) + eps p(s) cos(phi),  B^varphi = T(s) + eps t(s) cos(phi),
   psi = Psi0(s) + eps cos(phi) Q(s) with Psi0'=P, Q'=p, Q(0)=0.
   Invert psi(s,phi) = Psi0(s0), expand the transform integrand
   m B^varphi/B^phihel to second order, average over phi, invert. *)
ClearAll[PP, pp, TT, tt, QQ, Psi0F, u1, u2, sExp, psiExp, ord1, ord2,
  integrand, integrandSeries, avgExp, invAvg, dIotaDerived];
Psi0F /: Derivative[1][Psi0F] = PP;
QQ /: Derivative[1][QQ] = pp;
sExp = s0 + eps u1 Cos[phi] + eps^2 (u20 + u22 Cos[2 phi]);
psiExp = Normal@Series[Psi0F[sExp] + eps Cos[phi] QQ[sExp], {eps, 0, 2}];
ord1 = Coefficient[psiExp - Psi0F[s0], eps, 1];
u1Sol = u1 /. First@Solve[(ord1 /. Cos[phi] -> 1) == 0, u1];
ord2 = Coefficient[psiExp - Psi0F[s0], eps, 2] /. u1 -> u1Sol //
  TrigReduce // Expand;
u20Sol = u20 /. First@Solve[Coefficient[ord2, Cos[2 phi], 0] == 0, u20];
u22Sol = u22 /. First@Solve[Coefficient[ord2, Cos[2 phi], 1] == 0, u22];
check["(deltas): first-order surface shift is -cos(phi) Q(s0)/P(s0)",
  Simplify[u1Sol == -QQ[s0]/PP[s0]]];

(* (deltas) erratum: with Int_0^s0 (dBth - iota_m dBph) ds = (Q/m) cos(phi)
   and Delta iota_0 = P/(m T), the correct shift is
   -(1/(Delta iota_0 B0^varphi)) Int(...), while the printed
   -(1/Delta iota_0) Int(...) misses the 1/B0^varphi factor. *)
check["(deltas) erratum: corrected shift carries 1/(Delta iota_0 B0^varphi)",
  Simplify[u1Sol == -(1/((PP[s0]/(m TT[s0])) TT[s0])) QQ[s0]/m]];
check["(deltas) erratum: the printed 1/Delta iota_0 prefactor alone is inconsistent",
  Simplify[u1Sol == -(1/(PP[s0]/(m TT[s0]))) QQ[s0]/m] =!= True];

integrand = m (TT[sExp] + eps tt[sExp] Cos[phi])/
  (PP[sExp] + eps pp[sExp] Cos[phi]) /.
  {u1 -> u1Sol, u20 -> u20Sol, u22 -> u22Sol};
integrandSeries = Normal@Series[integrand, {eps, 0, 2}];
avgExp = Integrate[integrandSeries, {phi, 0, 2 Pi}]/(2 Pi);
invAvg = Normal@Series[1/avgExp, {eps, 0, 2}];
dIotaDerived = FullSimplify[Coefficient[invAvg, eps, 2]];
Print["    derived second-order delta iota (generic) = ",
  InputForm[dIotaDerived]];

(* Translate the printed (deliota_smallamp) into the same notation:
   delta B^th - iota_m delta B^ph -> (p/m) cos(phi),
   delta B^th - iota_0 delta B^ph -> (1/m)(p - P t/T) cos(phi),
   Delta iota_0 = P/(m T),  B0^varphi = T,
   Int_0^s0 (delta B^th - iota_m delta B^ph) ds = (Q/m) cos(phi).  The
   phi-average of cos^2 is 1/2. *)
dIotaPrinted = FullSimplify[
  -(1/((PP[s0]/(m TT[s0])) TT[s0]^2)) (1/2) (pp[s0]/m) ((pp[s0] -
        PP[s0] tt[s0]/TT[s0])/m) -
  (1/2) (QQ[s0]/m) D[((pp[ss] - PP[ss] tt[ss]/TT[ss])/m)/
      ((PP[ss]/(m TT[ss]))^2 TT[ss]), ss] /. ss -> s0];

printedMatches = FullSimplify[dIotaDerived - dIotaPrinted];
Print["    derived minus printed (deliota_smallamp) = ",
  InputForm[printedMatches]];
(* (deliota_smallamp) erratum: the printed expansion cannot equal the
   first-principles result: the exact expansion carries second-derivative
   terms P'' Q^2 and T'' Q^2 (the delta-s^2 Taylor and second-order
   inversion pieces of the zeroth-order integrand m T/P), which the printed
   two-term structure has no slot for; the difference is proportional to Q
   and does not vanish for generic fields. *)
check["(deliota_smallamp) erratum: printed expansion differs from the derivation for generic fields",
  Simplify[printedMatches === 0] === False];
check["(deliota_smallamp) erratum: the difference vanishes only without radial variation",
  Simplify[(printedMatches /. {Derivative[2][PP][_] -> 0,
        Derivative[2][TT][_] -> 0, Derivative[1][PP][_] -> 0,
        Derivative[1][TT][_] -> 0, Derivative[1][pp][_] -> 0,
        Derivative[1][tt][_] -> 0}) == 0]];

(* Fixture cross-check of the derived generic coefficient against the
   script-33 geometric term: map P -> D(x(s)), p -> phase(x(s)),
   T -> bz0/R0, t -> h/R0, Q -> x f. *)
ClearAll[sVar, xOfS, dIotaFixture];
xOfS[sv_] := Sqrt[2 sv];
fixtureRules = {
    m -> mNum,
    PP[s0] -> (detExpr /. x -> xOfS[s0v]),
    pp[s0] -> (phaseExpr /. x -> xOfS[s0v]),
    TT[s0] -> (bz0Expr/capRNum /. x -> xOfS[s0v]),
    tt[s0] -> (hExpr/capRNum /. x -> xOfS[s0v]),
    QQ[s0] -> (x fExpr /. x -> xOfS[s0v]),
    Derivative[1][PP][s0] -> (D[detExpr, x]/x /. x -> xOfS[s0v]),
    Derivative[1][pp][s0] -> (D[phaseExpr, x]/x /. x -> xOfS[s0v]),
    Derivative[1][TT][s0] -> 0,
    Derivative[1][tt][s0] -> (D[hExpr/capRNum, x]/x /. x -> xOfS[s0v]),
    Derivative[1][QQ][s0] -> (D[x fExpr, x]/x /. x -> xOfS[s0v]),
    Derivative[2][PP][s0] -> (D[D[detExpr, x]/x, x]/x /. x -> xOfS[s0v]),
    Derivative[2][pp][s0] -> (D[D[phaseExpr, x]/x, x]/x /. x -> xOfS[s0v]),
    Derivative[2][TT][s0] -> 0,
    Derivative[2][tt][s0] -> (D[D[hExpr/capRNum, x]/x, x]/x /. x -> xOfS[s0v]),
    Derivative[2][QQ][s0] -> (D[D[x fExpr, x]/x, x]/x /. x -> xOfS[s0v])};
dIotaFixture = dIotaDerived /. fixtureRules;
fixtureValue = N[dIotaFixture /. s0v -> rhoCheck^2/2, 20];
printedFixture = N[(dIotaPrinted /. fixtureRules) /. s0v -> rhoCheck^2/2, 20];
Print["    generic expansion on fixture = ", N[fixtureValue, 12]];
Print["    printed formula on fixture   = ", N[printedFixture, 12]];
check["small corrugations: generic expansion equals the script-33 geometric term",
  Abs[fixtureValue - cHelicalValue] < 10^-12];
check["small corrugations: generic expansion equals the exact-quadrature coefficient",
  Abs[fixtureValue - quadCoefficient] < 2 10^-7];
Print["    printed-minus-exact on fixture = ",
  N[printedFixture - cHelicalValue, 6], "  (relative ",
  N[(printedFixture - cHelicalValue)/cHelicalValue, 4], ")"];
check["(deliota_smallamp) erratum: printed formula misses the fixture geometric term",
  Abs[printedFixture - cHelicalValue] > 10^-5 &&
    Abs[fixtureValue - cHelicalValue] < 10^-12];

(* (zerofield): the printed definition iota_0 = B0^th/B0^th is a typo; the
   subsequent identity B0^varphi/B0^phihel = 1/(m(iota_0 - iota_m)) requires
   iota_0 = B0^th/B0^varphi. *)
ClearAll[bth0s, bph0s];
check["(zerofield): corrected iota_0 = B0^th/B0^varphi satisfies the printed identity",
  Simplify[bph0s/(m bth0s + n bph0s) ==
      1/(m (bth0s/bph0s - (-n/m))), m bth0s + n bph0s != 0 && bph0s != 0]];
check["(zerofield): the printed iota_0 = B0^th/B0^th = 1 fails the identity for general fields",
  Simplify[bph0s/(m bth0s + n bph0s) == 1/(m (1 - (-n/m)))] =!= True];

reportAndExit[]

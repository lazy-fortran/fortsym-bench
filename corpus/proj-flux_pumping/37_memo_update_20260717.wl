(* Verification of the 2026-07-17 memo correction (memo_HC_and_RMP_ext.tex,
   sha256 d91aae43..., received 2026-07-17 10:38 UTC).  The revision applies
   all three fixes reported on 2026-07-16: the (zerofield) definition, the
   1/B0^varphi factor in (deltas), and the second-order Taylor terms in
   (uptoquad)/(Deliota_smallamp)/(deliota_smallamp).  It also adds the
   labels, frames the kinetic closure via Lainer et al. (lainer26-055037),
   states that (deliota_smallamp) becomes a nonlinear integral equation for
   delta iota once the kinetic helical current is inserted, and adds the
   "Consistent inductive current" subsection acknowledging the ignored
   average current.  This script re-derives the second-order expansion from
   first principles and checks the corrected printed formulas against it,
   generically and on the script-33 fixture.
   Cylinder metric diag(1, r^2, R0^2), phase Exp[I(m th + n ph)], CGS. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* ==== corrected (zerofield) and the new (bphi) identity ==== *)
ClearAll[bth0s, bph0s];
check["(zerofield) corrected: iota_0 = B0^th/B0^varphi satisfies (bphi)",
  Simplify[(m bth0s + n bph0s) ==
      m (bth0s/bph0s - (-n/m)) bph0s, bph0s != 0]];

(* ==== first-principles second-order expansion (as in script 36) ==== *)
ClearAll[PP, pp, TT, tt, QQ, Psi0F, u1, u2, u20, u22, sExp, psiExp,
  ord1, ord2, u1Sol, u20Sol, u22Sol, integrand, integrandSeries, avgExp,
  invAvg, dIotaDerived];
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
integrand = m (TT[sExp] + eps tt[sExp] Cos[phi])/
  (PP[sExp] + eps pp[sExp] Cos[phi]) /.
  {u1 -> u1Sol, u20 -> u20Sol, u22 -> u22Sol};
integrandSeries = Normal@Series[integrand, {eps, 0, 2}];
avgExp = Integrate[integrandSeries, {phi, 0, 2 Pi}]/(2 Pi);
invAvg = Normal@Series[1/avgExp, {eps, 0, 2}];
dIotaDerived = FullSimplify[Coefficient[invAvg, eps, 2]];

(* ==== corrected (deltas) ==== *)
(* delta s = -[1/((iota_0-iota_m) B0^varphi)] Int_0^{s0} (dBth - iota_m dBph):
   with Int = (Q/m) cos(phi) and Delta iota_0 = P/(m T) this is -cos Q/P. *)
check["(deltas) corrected: the 1/B0^varphi factor makes the shift exact",
  Simplify[u1Sol ==
    -(1/((PP[s0]/(m TT[s0])) TT[s0])) QQ[s0]/m]];

(* ==== corrected (deliota_smallamp) ==== *)
(* Printed structure (2026-07-17):
   delta iota = -[1/(Dio T^2)] <X Y>
                - (Dio/T) < IntX d/ds0 [ Y/(Dio^2 T) ] >
                - [1/(2 Dio T^2)] < IntX^2 > d^2/ds0^2 (1/Dio),
   with X = (dBth - iota_m dBph) -> (p/m) cos, Y = (dBth - iota_0 dBph) ->
   ((p - P t/T)/m) cos, IntX = (Q/m) cos, Dio = Delta iota_0 = P/(m T),
   and <cos^2> = 1/2. *)
ClearAll[dioF, yF, dIotaPrinted17];
dioF[ss_] = PP[ss]/(m TT[ss]);
yF[ss_] = (pp[ss] - PP[ss] tt[ss]/TT[ss])/m;
dIotaPrinted17 = FullSimplify[
  -(1/(dioF[s0] TT[s0]^2)) (1/2) (pp[s0]/m) yF[s0] -
  (dioF[s0]/TT[s0]) (1/2) (QQ[s0]/m) (D[yF[ss]/(dioF[ss]^2 TT[ss]), ss] /.
     ss -> s0) -
  (1/(2 dioF[s0] TT[s0]^2)) (1/2) (QQ[s0]/m)^2 (D[1/dioF[ss], {ss, 2}] /.
     ss -> s0)];
printedDiff17 = FullSimplify[dIotaDerived - dIotaPrinted17];
Print["    derived minus corrected printed (deliota_smallamp) = ",
  InputForm[printedDiff17]];

(* The remaining gap is exactly the second-order mean surface shift: the
   memo's (firstoder) defines delta s only to first order, but the phi
   average of the second-order shift <delta s_2> = eps^2 u20 survives and
   multiplies d/ds0 of the zeroth-order integrand.  Its closed form is
   u20 = -(1/B0^phihel) [ (1/2) <delta s^2> d(B0^phihel)/ds0
                          + <delta s  delta B^phihel> ],
   and the missing delta-iota piece is -Delta iota_0^2 u20 d/ds0 (1/Dio). *)
check["(deliota_smallamp) erratum: mean second-order shift identity",
  Simplify[u20Sol == -(1/PP[s0]) ((1/2) (u1Sol^2/2) Derivative[1][PP][s0] +
      (1/2) pp[s0] u1Sol)]];
(* Two-part diagnosis: (a) the delta-s^2 Taylor entry in the intermediate
   bracket lacks the Delta iota_0 scaling its two sibling terms carry, so
   the final term prints 1/(2 Dio T^2) instead of the correct 1/(2 T^2);
   (b) the mean second-order shift term is missing entirely. *)
g0pp = D[m TT[ss]/PP[ss], {ss, 2}] /. ss -> s0;
g0p = D[m TT[ss]/PP[ss], ss] /. ss -> s0;
term3printed = -(1/(2 dioF[s0] TT[s0]^2)) (1/2) (QQ[s0]/m)^2 g0pp;
term3correct = -(1/(2 TT[s0]^2)) (1/2) (QQ[s0]/m)^2 g0pp;
missingShift = -dioF[s0]^2 u20Sol g0p;
check["(deliota_smallamp) erratum: residual = Taylor-scaling slip + missing mean shift",
  Simplify[printedDiff17 == (term3correct - term3printed) + missingShift]];
check["(deliota_smallamp) erratum: corrected printed formula still differs generically",
  Simplify[printedDiff17 === 0] === False];

(* ==== fixture cross-check against the script-33 geometric term ==== *)
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
rhoCheck = 1;
cHelicalValue = N[cHelicalExpr /. x -> rhoCheck, 20];

ClearAll[xOfS, fixtureRules];
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
printedFixture17 = N[(dIotaPrinted17 /. fixtureRules) /. s0v -> rhoCheck^2/2, 20];
derivedFixture = N[(dIotaDerived /. fixtureRules) /. s0v -> rhoCheck^2/2, 20];
Print["    corrected printed formula on fixture = ", N[printedFixture17, 12]];
Print["    first-principles value on fixture    = ", N[derivedFixture, 12]];
Print["    script-33 geometric term             = ", N[cHelicalValue, 12]];
Print["    printed-minus-exact relative         = ",
  N[(printedFixture17 - cHelicalValue)/cHelicalValue, 4]];
check["first-principles expansion equals the script-33 geometric term",
  Abs[derivedFixture - cHelicalValue] < 10^-12];
check["(deliota_smallamp) erratum: corrected printed formula misses the fixture term",
  Abs[printedFixture17 - cHelicalValue] > 10^-5 &&
    Abs[derivedFixture - cHelicalValue] < 10^-12];

(* ==== unchanged items ==== *)
(* The electric-drive supports are still complementary: h_m^r carries
   Theta(Dr-x)Theta(Dr+x) and the electric amplitude carries one minus that
   product, so no point has both drives nonzero; the prose alignment
   sentence is the remaining open wording (Sergei's 2026-07-17 question). *)
tophat[x_, dr_] = UnitStep[dr - x] UnitStep[dr + x];
check["electric drive: supports remain disjoint in the 2026-07-17 revision",
  Simplify[PiecewiseExpand[tophat[x, dr] (1 - tophat[x, dr])] == 0,
    Element[x, Reals] && dr > 0]];

reportAndExit[]

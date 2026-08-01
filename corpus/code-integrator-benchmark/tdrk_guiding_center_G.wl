(* ::Package:: *)

(* Analytic second-derivative term for TDRK on the canonical guiding-centre
   system, and a check that the closed form implemented in SIMPLE is right.

   TDRK integrates zdd = G(z) with G = F'(z) F(z), where F is the guiding-centre
   vector field. G is what makes the method cheap here: it needs second
   derivatives of the canonical field quantities, and SIMPLE already computes
   exactly those at mode_secders = 2 for the implicit symplectic Jacobians. So
   the expensive ingredient is already paid for.

   This file does three things:
     1. builds F symbolically, exactly as src/orbit_symplectic_quasi.f90:f_ode,
     2. differentiates it with Mathematica to get G = J.F,
     3. compares that against the hand-derived closed form written in terms of
        the field_can_t component names, and asserts the difference is zero.

   Step 3 is the point. A hand derivation that is only checked against its own
   restatement proves nothing; here the oracle is Mathematica's own D[], which
   knows nothing about the closed form.

   Run:  wolframscript -file derivation/tdrk_guiding_center_G.wl
*)

BeginPackage["TDRKGuidingCentre`"];
Begin["`Private`"];

(* ------------------------------------------------------------------ *)
(* State and field quantities                                          *)
(*                                                                     *)
(* z = (r, th, ph, pph). H, pth and vpar depend on all four; hth and    *)
(* hph are geometric and depend on position only, which is why          *)
(* field_can_t carries dhth(3)/dhph(3) rather than (4).                 *)
(* ------------------------------------------------------------------ *)

vars = {r, th, ph, pph};

H[r_, th_, ph_, pph_] := HH[r, th, ph, pph];
pth[r_, th_, ph_, pph_] := PTH[r, th, ph, pph];
vpar[r_, th_, ph_, pph_] := VPAR[r, th, ph, pph];
hth[r_, th_, ph_] := HTH[r, th, ph];
hph[r_, th_, ph_] := HPH[r, th, ph];

(* ------------------------------------------------------------------ *)
(* F, transcribed from f_ode                                           *)
(*                                                                     *)
(*   Hprime = dH(1)/dpth(1)                                            *)
(*   zdot(1) = -(dH(2) - hth/hph*dH(3))/dpth(1)                        *)
(*   zdot(2) = Hprime                                                  *)
(*   zdot(3) = (vpar - Hprime*hth)/hph                                 *)
(*   zdot(4) = -(dH(3) - Hprime*dpth(3))                               *)
(*                                                                     *)
(* Index convention: dH(i) is the derivative with respect to vars[[i]], *)
(* so dH(1) = d/dr, dH(2) = d/dth, dH(3) = d/dph, dH(4) = d/dpph.       *)
(* ------------------------------------------------------------------ *)

dH[i_] := D[H[r, th, ph, pph], vars[[i]]];
dpth[i_] := D[pth[r, th, ph, pph], vars[[i]]];
dvpar[i_] := D[vpar[r, th, ph, pph], vars[[i]]];

Hprime = dH[1]/dpth[1];

F = {
   -(dH[2] - hth[r, th, ph]/hph[r, th, ph]*dH[3])/dpth[1],
   Hprime,
   (vpar[r, th, ph, pph] - Hprime*hth[r, th, ph])/hph[r, th, ph],
   -(dH[3] - Hprime*dpth[3])
   };

(* ------------------------------------------------------------------ *)
(* G = J.F, by Mathematica. This is the oracle.                        *)
(* ------------------------------------------------------------------ *)

J = Table[D[F[[i]], vars[[j]]], {i, 4}, {j, 4}];
Goracle = J . F // Simplify;

(* ------------------------------------------------------------------ *)
(* The closed form, written the way it will be coded in Fortran.       *)
(*                                                                     *)
(* Everything below is expressed only in quantities field_can_t already *)
(* carries at mode_secders = 2: dH, dpth, dvpar (4 each), d2H, d2pth,  *)
(* d2vpar (10 each), hth, hph, dhth, dhph (3 each). Nothing else may    *)
(* appear -- if the check passes, the term is computable without a      *)
(* single extra field evaluation, which is the whole cost argument.     *)
(*                                                                     *)
(* d2 index order, from field_can_base.f90:                            *)
(*   1:(r,r) 2:(r,th) 3:(r,ph) 4:(th,th) 5:(th,ph) 6:(ph,ph)           *)
(*   7:(pph,r) 8:(pph,th) 9:(pph,ph) 10:(pph,pph)                      *)
(* ------------------------------------------------------------------ *)

d2Index = {{1, 1} -> 1, {1, 2} -> 2, {1, 3} -> 3, {2, 2} -> 4,
   {2, 3} -> 5, {3, 3} -> 6, {1, 4} -> 7, {2, 4} -> 8, {3, 4} -> 9,
   {4, 4} -> 10};

(* second derivative of quantity q with respect to vars[[i]], vars[[j]] *)
d2[q_, i_, j_] := D[q[r, th, ph, pph], vars[[i]], vars[[j]]];

(* Hprime differentiated by the quotient rule, which is the only place a
   hand derivation usually goes wrong: Hprime = dH1/dpth1 depends on z
   through BOTH numerator and denominator. *)
dHprime[j_] := (d2[HH, 1, j]*dpth[1] - dH[1]*d2[PTH, 1, j])/dpth[1]^2;

(* d/dz_j of each component of F *)
dF1[j_] := -((d2[HH, 2, j] -
       (D[hth[r, th, ph], vars[[j]]]/hph[r, th, ph]
         - hth[r, th, ph]*D[hph[r, th, ph], vars[[j]]]/hph[r, th, ph]^2)*dH[3]
       - hth[r, th, ph]/hph[r, th, ph]*d2[HH, 3, j])*dpth[1]
     - (dH[2] - hth[r, th, ph]/hph[r, th, ph]*dH[3])*d2[PTH, 1, j])/dpth[1]^2;

dF2[j_] := dHprime[j];

dF3[j_] := ((dvpar[j] - dHprime[j]*hth[r, th, ph]
      - Hprime*D[hth[r, th, ph], vars[[j]]])*hph[r, th, ph]
    - (vpar[r, th, ph, pph] - Hprime*hth[r, th, ph])*
     D[hph[r, th, ph], vars[[j]]])/hph[r, th, ph]^2;

dF4[j_] := -(d2[HH, 3, j] - dHprime[j]*dpth[3] - Hprime*d2[PTH, 3, j]);

Gclosed = Table[
   Sum[{dF1[j], dF2[j], dF3[j], dF4[j]}[[i]]*F[[j]], {j, 4}], {i, 4}];

(* ------------------------------------------------------------------ *)
(* The check                                                           *)
(* ------------------------------------------------------------------ *)

residual = Simplify[Goracle - Gclosed];
symbolicOK = (residual === {0, 0, 0, 0}) || (Simplify[Total[Abs[residual]]] === 0);

Print["Symbolic check, G = J.F against the closed form:"];
Print["  residual = ", residual];
Print["  ", If[symbolicOK, "PASS", "FAIL"]];

(* ------------------------------------------------------------------ *)
(* Numeric spot-check with concrete analytic field quantities.         *)
(*                                                                     *)
(* The symbolic identity above can hold trivially if both sides were    *)
(* built from the same expression, so this substitutes real functions   *)
(* and evaluates at a random point. The functions are deliberately      *)
(* nonlinear and coupled in all four variables: a separable or linear   *)
(* choice would mask an error in any cross term.                        *)
(* ------------------------------------------------------------------ *)

concrete = {
   HH -> Function[{r, th, ph, pph},
     pph^2/(2 (1 + r^2)) + Cos[th] Sin[ph] + r^3 pph + Exp[-r] Cos[th + ph]],
   PTH -> Function[{r, th, ph, pph},
     pph (1 + r^2/3) + Sin[th] Cos[ph] + r pph^2/5],
   VPAR -> Function[{r, th, ph, pph},
     pph/(1 + r) + Sin[th + 2 ph] + r^2 pph/7],
   HTH -> Function[{r, th, ph}, 1 + r^2/4 + Sin[th] Cos[ph]/3],
   HPH -> Function[{r, th, ph}, 2 + r/5 + Cos[th + ph]/4]
   };

pt = {r -> 37/100, th -> 61/100, ph -> 117/100, pph -> 43/100};

gO = Goracle /. concrete /. pt // N;
gC = Gclosed /. concrete /. pt // N;
numericErr = Max[Abs[gO - gC]];

Print[""];
Print["Numeric spot-check at r=0.37, th=0.61, ph=1.17, pph=0.43:"];
Print["  G (oracle) = ", gO];
Print["  G (closed) = ", gC];
Print["  max |difference| = ", numericErr];
Print["  ", If[numericErr < 10^-10, "PASS", "FAIL"]];

(* ------------------------------------------------------------------ *)
(* Confirm the closed form uses ONLY quantities SIMPLE already has.    *)
(*                                                                     *)
(* This is the cost argument made checkable. If a third derivative of   *)
(* H, pth or vpar appears anywhere, G is not obtainable at              *)
(* mode_secders = 2 and TDRK loses its advantage here.                  *)
(* ------------------------------------------------------------------ *)

derivOrder[expr_, f_] := Max[0, Cases[expr,
    Derivative[a__][f][__] :> Total[{a}], {0, Infinity}]];

orders = {
   "H" -> derivOrder[Gclosed, HH],
   "pth" -> derivOrder[Gclosed, PTH],
   "vpar" -> derivOrder[Gclosed, VPAR],
   "hth" -> derivOrder[Gclosed, HTH],
   "hph" -> derivOrder[Gclosed, HPH]
   };

Print[""];
Print["Highest derivative order appearing in the closed form:"];
(Print["  ", #[[1]], ": ", #[[2]]] &) /@ orders;
ordersOK = AllTrue[orders, #[[2]] <= 2 &];
Print["  ", If[ordersOK,
   "PASS -- second derivatives suffice, so mode_secders = 2 covers G",
   "FAIL -- a third derivative is required, G is NOT free here"]];

Print[""];
Print[If[symbolicOK && numericErr < 10^-10 && ordersOK,
   "ALL CHECKS PASSED", "CHECKS FAILED"]];

If[! (symbolicOK && numericErr < 10^-10 && ordersOK), Exit[1]];

End[];
EndPackage[];

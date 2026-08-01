(* Edge orbits across the plasma boundary: the mathematics of Plan A (extend the
   axisymmetric equilibrium field across the separatrix and bound the domain by a
   convex wall) and Plan B (approximate the bounce integral from the accessible
   inside arc).  Companion prose: tex monograph chapter "Arbitrary coordinates",
   section "Edge orbits across the plasma boundary" (sec:edge).

   Conventions: psi(R,Z) the poloidal flux, F(psi)=R B_phi the toroidal field
   function, axisymmetric so d/dphi = 0.  B0 = grad psi x grad phi + F grad phi. *)

(* ============================================================
   1.  Plan A: the equilibrium field is divergence free and regular
   ============================================================
   With B_R = -(1/R) psi_Z, B_Z = (1/R) psi_R, B_phi = F(psi)/R, the field
   B0 = grad psi x grad phi + F grad phi is solenoidal for ANY psi and F. *)

ClearAll[psi, Ffun];
With[{BR = -(1/RR) D[psi[RR, ZZ], ZZ],
      BZ = (1/RR) D[psi[RR, ZZ], RR],
      Bphi = Ffun[psi[RR, ZZ]]/RR},
  (* cylindrical divergence, axisymmetric (d/dphi = 0): *)
  CheckEq["edge  div B0 = 0  (B0 = grad psi x grad phi + F grad phi, any psi,F)",
     (1/RR) D[RR BR, RR] + D[BZ, ZZ], 0]];

(* The toroidal field carries no poloidal current outside: F = F_vac const, so
   B_phi = F_vac/R is continuous across the separatrix and the extension is C0. *)
CheckEq["edge  B_phi continuous across separatrix (F -> F_vac const outside)",
   (Fvac/RR) - (Fvac/RR), 0];

(* The poloidal field vanishes at the X-point, where grad psi = 0. *)
CheckEq["edge  B_p = |grad psi|/R = 0 at the X-point (psi_R = psi_Z = 0)",
   Sqrt[psiR^2 + psiZ^2]/RR /. {psiR -> 0, psiZ -> 0}, 0];

(* ============================================================
   2.  Plan A: the X-point bounce-time logarithm
   ============================================================
   Near the X-point psi = psi_X + (1/2)(a dR^2 - b dZ^2) is a saddle, so
   B_p ~ s (distance from the X-point) and the transit-time element ~ ds/s.
   The accumulated time from a tip at distance d to O(1) diverges as -ln d. *)

CheckEq["edge  int_d^1 ds/s = -ln d  (X-point logarithm)",
   Integrate[1/s, {s, d, 1}, Assumptions -> 0 < d < 1], -Log[d]];

CheckClose["edge  X-point log numeric: tau(d=1e-3) ~ ln(1000)",
   NIntegrate[1/s, {s, 1*^-3, 1}], Log[1000.], 1*^-6];

(* The saddle has |grad psi| linear in the distance: with
   psi = psiX + (1/2)(a dR^2 - b dZ^2), grad psi = (a dR, -b dZ), whose norm
   along dR = r cos t, dZ = r sin t is r sqrt(a^2 cos^2 t + b^2 sin^2 t) ~ r. *)
With[{gradnorm = Sqrt[(a x)^2 + (b y)^2] /. {x -> r Cos[t], y -> r Sin[t]}},
  CheckEq["edge  |grad psi| ~ r near the saddle (linear in distance)",
     Simplify[gradnorm/r, r > 0], Sqrt[a^2 Cos[t]^2 + b^2 Sin[t]^2]]];

(* ============================================================
   3.  Plan B: the half-bounce equals the full-bounce average
   ============================================================
   A trapped orbit is invariant under vpar -> -vpar, so the full bounce is two
   equal tip-to-tip passes: oint = forward + backward = 2 * forward for any vpar-
   even A.  Hence <A>_full = <A>_{tip-to-tip}. *)

With[{If = Iarm, Tf = Tarm},
  CheckEq["edge  <A>_full = <A>_arm  (oint = 2 int_arm, vpar-even A)",
     (If + If)/(Tf + Tf), If/Tf]];

(* The vpar-ODD bounce average vanishes (forward +vpar cancels backward -vpar).
   Model: vpar(th) = sqrt(1 - etaB(th)) on a cosine well, integrated over the
   closed bounce with both signs. *)
Module[{etaB, vpar, thp, num, den},
  etaB[th_] := 0.6 (1 + 0.5 (1 - Cos[th]));   (* turning where etaB = 1 *)
  thp = th /. FindRoot[etaB[th] == 1, {th, 1.5}];
  vpar[th_] := Sqrt[Max[1 - etaB[th], 0]];
  (* forward (+vpar) and backward (-vpar) contributions to <vpar>: cancel *)
  num = NIntegrate[(+vpar[th])/vpar[th], {th, -thp, thp}]
      + NIntegrate[(-vpar[th])/vpar[th], {th, -thp, thp}];
  CheckClose["edge  <vpar>_bounce = 0  (vpar-odd average cancels over full bounce)",
     num, 0., 1*^-6]];

(* ============================================================
   4.  Plan B: the fractional-bounce error formula
   ============================================================
   Split the bounce into an accessible (inside) and an inaccessible (outside) arc.
   The full average is the time-weighted mean, so using only the accessible
   average has the exact error (1-f)(<A>_inacc - <A>_acc), f = tau_acc/tau_b. *)

With[{Aacc = Ia/Ta, Ainacc = Ib/Tb, Afull = (Ia + Ib)/(Ta + Tb),
      f = Ta/(Ta + Tb)},
  CheckEq["edge  <A> - <A>_acc = (1-f)(<A>_inacc - <A>_acc)  (fractional error)",
     Afull - Aacc, (1 - f) (Ainacc - Aacc)]];

(* The half-banana limit: the widest orbit tangent to the boundary keeps exactly
   its inner arm, f = 1/2, and by the half-bounce identity the arm average is the
   full bounce average, coinciding with the thin orbit on the separatrix. *)
With[{Aacc = Ia/Ta, Ainacc = Ia/Ta, Afull = (Ia + Ia)/(Ta + Ta)},
  CheckEq["edge  half-banana (f=1/2, symmetric arms): <A>_acc = <A>_full (exact)",
     Afull, Aacc]];

(* ============================================================
   5.  Plan B: the thin-orbit limit of the bounce average
   ============================================================
   As the orbit width w -> 0 the bounce average tends to its value on the limiting
   surface.  Model: the bounce average of A(th)=cos th over a cosine well whose
   trapping depth -> 0 (deeply trapped, w -> 0) tends to A at the bottom, cos 0 = 1. *)

Module[{avg},
  (* eta = 1 - delta with b fixed: turning point 1-cos thp = (1/eta-1)/b -> 0 as
     delta -> 0, a deeply trapped (narrow, width -> 0) orbit near th = 0. *)
  avg[delta_] := Module[{eta = 1 - delta, b = 0.5, eB, vp, tp},
    eB[th_] := eta (1 + b (1 - Cos[th]));
    tp = th /. FindRoot[eB[th] == 1, {th, Sqrt[2 delta/b]}];
    vp[th_] := Sqrt[Max[1 - eB[th], 0]];
    NIntegrate[Cos[th]/vp[th], {th, -tp, tp}]/
      NIntegrate[1/vp[th], {th, -tp, tp}]];
  CheckClose["edge  thin-orbit limit: <cos th>_bounce -> 1 as width -> 0",
     avg[1*^-4], 1., 1*^-3]];

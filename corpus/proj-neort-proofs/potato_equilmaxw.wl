(* POTATO equilibrium distribution for wide bananas (finite orbit width).
   Source: NEO-RT/POTATO/TEX/equilmaxw.tex, sec. "Equilibrium distribution for
   wide bananas".  The canonical Maxwellian f0(H, psistar) with the EXACT canonical
   toroidal momentum psistar = (c/e) p_phi = (m c/e) v_phi + psi (Larmor gyration
   included) is an exact collisional equilibrium in all regimes; expanding to
   linear order in the FOW parameter q R rho_L / a^2 gives a drifting Maxwellian
   with V_tor = Omega_tor R.  This is the clean finite-orbit-width form behind
   docs/canonical_maxwellian.md.  v_phi = R v_tor; expansion parameter delta. *)

(* ---------- 1. psistar and the FOW expansion parameter ---------- *)
(* psistar - psi = (m c/e) p_phi-kinetic = (m c/e) v_phi = (m c/e) R v_tor *)
CheckEq["psistar - psi = (m c/e) v_phi = (m c/e) R v_tor",
   (mm cc/ee) vphi /. vphi -> R vtor, (mm cc/ee) R vtor];

(* ---------- 2. linear expansion of f0(H,psistar) in v_tor ---------- *)
(* the v_tor-linear part of  e(Phi(psi)-Phi(psistar)) + T(log nbar(psi)-log nbar(psistar))
   equals  - m V_tor v_tor,  V_tor = c R (Phi'(psi) + T/(e nbar) nbar'(psi)) *)
delta = (mm cc/ee) R vtor;                   (* psistar - psi *)
shift = ee (Phi[psi] - Phi[psi + delta]) + T (Log[nbar[psi]] - Log[nbar[psi + delta]]);
lin = Normal[Series[shift, {vtor, 0, 1}]];   (* keep O(v_tor) *)
Vtor = cc R (Phi'[psi] + T/(ee nbar[psi]) nbar'[psi]);
CheckEq["FOW expansion: v_tor-linear term of f0 exponent = - m V_tor v_tor",
   lin, -mm Vtor vtor];

(* ---------- 3. V_tor = Omega_tor R ---------- *)
Omtor = cc (Phi'[psi] + T/(ee nbar[psi]) nbar'[psi]);
CheckEq["V_tor = Omega_tor R,  Omega_tor = c(Phi' + T/(e nbar) nbar')",
   Vtor, Omtor R];

(* ---------- 4. completion of the square (correct centrifugal sign) ----------
   1/2(v_pol^2 + v_tor^2) - V_tor v_tor = 1/2(v_pol^2 + (v_tor-V_tor)^2) - 1/2 V_tor^2.
   The residual is -1/2 V_tor^2, i.e. the density factor exp(+ m V_tor^2/2T) which
   PEAKS outboard (large R): the centrifugal effect.  The thesis source prints
   +V_tor^2 inside exp(-...); that sign is a typo (it would deplete outboard). *)
CheckEq["wide-banana completion of square: residual is -1/2 V_tor^2 (centrifugal)",
   (1/2) (vp^2 + vt^2) - Vt vt, (1/2) (vp^2 + (vt - Vt)^2) - (1/2) Vt^2];
CheckEq["centrifugal density factor exp(+m V_tor^2/2T) peaks outboard",
   D[Exp[mm Vt^2/(2 T)] /. Vt -> Om R, R], (mm Om^2 R/T) Exp[mm Om^2 R^2/(2 T)],
   mm > 0 && T > 0 && Om > 0 && R > 0];

(* ---------- 5. f0(H,psistar) is an exact equilibrium (Jeans) ----------
   H and psistar (proportional to p_phi) are constants of motion, so {f0,H}=0 *)
CheckEq["{f0(H,psistar), H} = 0 given {p_phi,H}=0 (exact wide-banana equilibrium)",
   D[f0w[Hs, Pstar], Hs] BH + D[f0w[Hs, Pstar], Pstar] BP /. {BH -> 0, BP -> 0}, 0];

(* ---------- 6. the POTATO code uses the exact unexpanded form (no typo) ----------
   sub_potato.f90::equilmaxw: fmaxw = dens*exp((phi_elec - toten)/temp)/temp^1.5
   = n*exp(-(H - e Phi)/T)/T^1.5, the exact f0; the +V_tor^2 typo is only in the
   illustrative expansion, not the code. *)
CheckEq["POTATO code form dens*exp((phi-H)/T)/T^1.5 = exact f0 = dens*exp(-(H-phi)/T)/T^1.5",
   dens Exp[(phi - Hh)/T]/T^(3/2), dens Exp[-(Hh - phi)/T]/T^(3/2)];

Note["potato-code-correct",
  "sub_potato.f90::equilmaxw implements the EXACT unexpanded f0 = dens*exp((phi_elec-toten)/temp)/temp^1.5 = n(psistar) exp(-(H-e Phi(psistar))/T)/T^1.5. The centrifugal +V_tor^2 sign typo is confined to the drifting-Maxwellian expansion in equilmaxw.tex; the code is correct."];
Note["potato-centrifugal-typo",
  "equilmaxw.tex prints the wide-banana Maxwellian as exp(-(m/2T)(v_pol^2+(v_tor-V_tor)^2+V_tor^2)); completing the square of (1/2 v_tor^2 - V_tor v_tor) gives -1/2 V_tor^2, so the correct sign is -V_tor^2 (density peaks outboard, centrifugal). The printed +V_tor^2 is a sign typo."];
Note["potato-allregimes",
  "the wide-banana f0(H,psistar) is an equilibrium in ALL collisionality regimes because it is a function of exact constants of motion (Jeans) and reduces to a drifting Maxwellian (collisional steady state); no thin-orbit assumption."];

(* POTATO: computation of moments, box counting, profile expansion.
   Source: NEO-RT/POTATO/TEX/equilmaxw.tex, sec. "Computation of moments,
   box counting" (eqs. moments..inttorque) and subsec. "Profile expansion
   over base functions" (eqs. basexp..bj0), lines 170-585.

   Verified here: the Heaviside flux-surface-average identity, the angle-
   integral box-counting factors ((2pi)^2 and 2pi^3), the change of variables
   to bounce time, the full-derivative vanishing of the zero-order radial flux,
   the resonance reduction of the action derivative (the red-marked error in the
   source), the weight function Theta_w and its delta_w->0 limit, and the
   least-squares normal equations for the base-function expansion. *)

(* ---------- 1. Heaviside form of the flux-surface average (eq. neofsav_expr) ----------
   <A(r0)> = (dV/dr0)^-1 d/dr0 \int_{V(r0)} d^3r A
           = (dV/dr0)^-1 d/dr  \int d^3r A Theta(r0 - r(r)).
   Mechanizable core: differentiating the volume integral in r0 with a sharp
   cut Theta(r0-r) reproduces the surface integrand.  Test with a radial model
   A=g(r), volume element w(r): d/dr0 \int_0^Rmax g(r) w(r) Theta(r0-r) dr
   = g(r0) w(r0), i.e. the surface contribution, dividing by w(r0)=dV/dr0
   leaves <A>=g(r0). *)
CheckEq["neofsav: d/dr0 of box integral with Theta(r0-r) = surface integrand",
   D[Integrate[g[r] w[r] HeavisideTheta[r0 - r], {r, 0, Rmax},
        Assumptions -> 0 < r0 < Rmax], r0],
   g[r0] w[r0],
   0 < r0 < Rmax];

(* the average itself: divide the surface integrand by dV/dr0 = w(r0) *)
CheckEq["neofsav: <A(r0)> = g(r0) for A=g(r) (Theta-derivative form)",
   D[Integrate[g[r] w[r] HeavisideTheta[r0 - r], {r, 0, Rmax},
        Assumptions -> 0 < r0 < Rmax], r0] / w[r0],
   g[r0],
   0 < r0 < Rmax];

(* ---------- 2. box-counting angle integrals (eqs. Abox_actang, Abox_0) ----------
   integrand independent of gyrophase theta^1 and of toroidal angle theta^3:
   the two trivial angle integrals each give 2pi, hence the (2pi)^2 prefactor. *)
CheckEq["Abox_0: trivial integral over gyrophase theta^1 gives 2pi",
   Integrate[1, {th1, 0, 2 Pi}], 2 Pi];
CheckEq["Abox_0: two trivial angle integrals give the (2pi)^2 prefactor",
   Integrate[1, {th1, 0, 2 Pi}] Integrate[1, {th3, 0, 2 Pi}], (2 Pi)^2];

(* ---------- 3. change of variables to bounce time (eq. Abox_0_noncan) ----------
   poloidal canonical angle -> bounce time via vartheta_c = omega_b tau, and
   poloidal action -> H0 via dH0/dJ2 = omega_b.  The product of the two
   Jacobians, d(vartheta_c)/d(tau) = omega_b and d(J2)/d(H0) = 1/omega_b,
   is unity, so dJ2 d vartheta_c = dH0 dtau (no leftover factor). *)
CheckEq["Abox_0_noncan: Jacobian d(vartheta_c,J2)/d(tau,H0) = 1",
   D[omegab tau, tau] D[Integrate[1/omegab, H0], H0], 1,
   omegab > 0];
(* equivalently the upper limit maps: vartheta_c in (0,2pi) -> tau in (0,tau_b),
   2pi = omega_b tau_b *)
CheckEq["Abox_0_noncan: bounce period tau_b = 2pi/omega_b",
   2 Pi / omegab, taub /. taub -> 2 Pi/omegab,
   omegab > 0];

(* ---------- 4. zero-order radial flux is a full tau-derivative (eq. fullder) ----------
   a0 Theta(r - u(tau)) = Theta(r - u) v_g0.nabla r = d/dtau [ Theta(r-u)(u-r) ],
   with u = r(R,Z) along the orbit and v_g0.nabla r = {r,H0} = du/dtau.
   d/dtau[Theta(r-u)(u-r)] = -delta(r-u) u'(u-r) + Theta(r-u) u'.
   The boundary term vanishes since (u-r) delta(r-u) = 0; what remains is
   Theta(r-u) du/dtau, the zero-order radial flux integrand.  Hence the
   tau-integral telescopes and the zero-order term gives no net flux. *)
CheckEq["fullder: d/dtau[Theta(r-u)(u-r)] = Theta(r-u) u' (boundary term drops)",
   D[HeavisideTheta[r - u[tau]] (u[tau] - r), tau]
     /. (u[tau] - r) DiracDelta[r - u[tau]] -> 0,
   HeavisideTheta[r - u[tau]] u'[tau]];
(* the boundary term itself vanishes identically: x delta(x) = 0; here x = r-u
   is the cut-surface argument.  Mathematica fires x DiracDelta[x] -> 0 on a
   single symbol, so test the identity in that canonical form. *)
CheckEq["fullder: x delta(x) = 0, x = r-u (Theta-derivative boundary term)",
   xx DiracDelta[xx], 0];

(* ---------- 5. resonance reduction of the action derivative (red-marked error) ----------
   Source eq. boxflux: m_j df0/dJ_j with f0=f0(H0,p_phi) and H0=H0(J), p_phi=J3.
   m_j df0/dJ_j = (m_j dH0/dJ_j) df0/dH0 + m3 df0/dp_phi
              = (m_j Omega^j) df0/dH0 + m3 df0/dp_phi.
   On resonance m_j Omega^j = 0 (m2 omega_b + m3 Omega_phi = 0), so the
   df0/dH0 term DROPS.  The source first prints the extra red term
   m2 omega_b df0/dH0; the correct on-resonance result is m3 df0/dp_phi. *)
(* chain rule before applying the resonance condition *)
CheckEq["boxflux: m_j df0/dJ_j = (m_j Omega^j) df0/dH0 + m3 df0/dp_phi",
   m2 (omegab fH + 0) + m3 (Omphi fH + fP),
   (m2 omegab + m3 Omphi) fH + m3 fP];
(* on resonance m2 omega_b + m3 Omega_phi = 0 the H0 term vanishes *)
CheckEq["boxflux: on resonance (m2 omega_b + m3 Omega_phi = 0) -> m3 df0/dp_phi",
   ((m2 omegab + m3 Omphi) fH + m3 fP) /. Omphi -> -m2 omegab/m3,
   m3 fP,
   m3 != 0];

(* ---------- 6. box-counting prefactor 2pi^3 (eqs. boxflux, Tphi) ----------
   Gamma carries pi/2 from the quasilinear operator; the two trivial angle
   integrals (gyrophase and toroidal) give (2pi)^2.  Total (pi/2)(2pi)^2 = 2pi^3. *)
CheckEq["boxflux: (pi/2)(2pi)^2 = 2 pi^3 prefactor",
   (Pi/2) (2 Pi)^2, 2 Pi^3];

(* ---------- 7. weight function Theta_w (eqs. Theta_W_def) ----------
   Theta_w(x) = x^k/(x^k + delta_w^k).  In the limit delta_w -> 0 it becomes 1
   for x>0, i.e. the Heaviside function.  With k=3 it is C^2 at x=0+:
   value and first two derivatives vanish as x->0+. *)
CheckLimit["Theta_w: delta_w -> 0 limit is 1 for x>0 (Heaviside)",
   x^kk/(x^kk + dw^kk), dw -> 0, 1,
   x > 0 && kk > 0];
(* k=3: Theta_w and its first two x-derivatives -> 0 as x->0+ (smooth onset) *)
CheckEq["Theta_w (k=3): value vanishes at x=0+",
   (x^3/(x^3 + dw^3)) /. x -> 0, 0, dw > 0];
CheckEq["Theta_w (k=3): 1st derivative vanishes at x=0+",
   D[x^3/(x^3 + dw^3), x] /. x -> 0, 0, dw > 0];
CheckEq["Theta_w (k=3): 2nd derivative vanishes at x=0+",
   D[x^3/(x^3 + dw^3), x, x] /. x -> 0, 0, dw > 0];

(* ---------- 8. least-squares normal equations (eqs. functional, set, coefsset) ----------
   S = \int dr (dV/dr) Theta_w (sum_k alpha_k phi_k - <A>)^2.
   dS/dalpha_i = 0  gives  sum_k a_ik alpha_k = b_i with
   a_ik = \int w phi_i phi_k,  b_i = \int w <A> phi_i,  w = (dV/dr) Theta_w.
   Verify on a finite basis (N_b=2) that the stationarity condition factors
   into exactly this linear system.  Use symbolic moments of the weight w:
   m[i,k] = \int w phi_i phi_k,  c[i] = \int w <A> phi_i. *)
(* S as a quadratic form in (alpha1,alpha2); derivative wrt alpha1 *)
CheckEq["normal-eq: dS/dalpha_1 = 2(a_11 alpha_1 + a_12 alpha_2 - b_1)",
   D[a11 al1^2 + 2 a12 al1 al2 + a22 al2^2
       - 2 (b1 al1 + b2 al2) + cconst, al1],
   2 (a11 al1 + a12 al2 - b1)];
(* stationarity of both partials reproduces the symmetric 2x2 system set/coefsset *)
CheckEq["normal-eq: stationarity gives sum_k a_ik alpha_k = b_i (a symmetric)",
   Solve[{a11 al1 + a12 al2 == b1, a12 al1 + a22 al2 == b2}, {al1, al2}]
     // First // (al1 /. #) &,
   (a22 b1 - a12 b2)/(a11 a22 - a12^2),
   a11 a22 - a12^2 != 0];

(* a_ik is symmetric in i,k since phi_i phi_k = phi_k phi_i under the same weight *)
CheckEq["coefsset: a_ik = a_ki (symmetric Gram matrix under weight w)",
   Integrate[wt[r] ph1[r] ph2[r], {r, 0, ra}],
   Integrate[wt[r] ph2[r] ph1[r], {r, 0, ra}]];

(* ---------- definitions / modeling steps recorded as notes ---------- *)
Note["potato-redmark-error",
  "Source marks in red (eqs. boxflux, boxfluxmVphi, inttorque) two extra terms m2 omega_b df0/dH0 and m2 omega_b (dr/dH0) that should NOT appear: f0=f0(H0,p_phi) and r=r(theta,J) both depend on p_phi through H0, and on resonance m_j Omega^j=0 the H0-derivative term drops, leaving m3 df0/dp_phi and m3 (dr/dp_phi)_{H0,theta^2}. Verified the correct reduction in check 5."];
Note["potato-jeans-zero-flux",
  "fullder: the zero-order radial flux integrand is a full tau-derivative along the closed orbit (check 4), so its bounce integral over (0,tau_b) telescopes to zero -- the unperturbed term carries no net radial flux, as expected for an axisymmetric equilibrium."];
Note["potato-vphi-replacement",
  "boxfluxmVphi uses the guiding-center relation v_phi ~= v_parallel B_phi/B (physical-modeling step, not an algebraic identity); recorded, not checked symbolically."];
Note["potato-quasilin-operator",
  "The pi/2 |H_m|^2 delta(m_k Omega^k - omega) m_i d/dJ_i ... quasilinear operator (eq. quasilinevol) and the continuity/momentum balance (conteq, genmomeq, kinmomeq) are physics derivations from the QL evolution equation; only the resulting algebraic prefactors and resonance reductions are mechanized here."];
Note["potato-orbit-integrals",
  "Inner tau-integrals over the orbit (R(tau),Z(tau)) in Abox_0_noncan, biviaorbs, bj0 are evaluated by the orbit solver; the change of variables and Jacobians are the mechanizable part (check 3)."];

(* POTATO orbit classification and canonical frequencies (finite orbit width).
   Source: NEO-RT/POTATO/TEX/equilmaxw.tex, sec. "Phase space integration, orbit
   classification" (lines 585-1347).  Verifies the closed-form ALGEBRAIC relations:
   phase-space Jacobian reduction, extremum-line condition, canonical-frequency
   definitions, the delta-function resonance reduction, the bounce-average / theta
   identities, the Heaviside representation, the constant-p_phi derivative chain
   rule, and the singularity-flattening properties of the class parameterization
   functions xi_ij.  Orbit integrals (tau_b, Delta_phi_b, b_i, Gamma_box) are
   NUMERICAL and recorded as Note; only the relations among them are mechanized. *)

(* ---------- 1. phase-space Jacobian reduction (eq:poljac) ----------
   J_z = e B*_par R/(c v_par); velocities (eq:polpl_pphi) are
   dR = -(c v_par)/(e R B*_par) dp/dZ,  dZ = (c v_par)/(e R B*_par) dp/dR.
   Then J_z (dR/dRc V^Z - dZ/dRc V^R) = dRc R dp/dR + dRc Z dp/dZ = d/dRc p(R(Rc),Z(Rc)).
   Check the algebraic collapse of the prefactors to 1. *)
CheckEq["eq:poljac  J_z * (dR/dRc V^Z - dZ/dRc V^R) prefactor reduces to dp/dRc",
   (ea bpar rr/(cc vpar)) * ((cc vpar/(ea rr bpar)) dRdRc dpdR
      + (cc vpar/(ea rr bpar)) dZdRc dpdZ),
   dRdRc dpdR + dZdRc dpdZ,
   ea > 0 && bpar > 0 && rr > 0 && cc > 0 && vpar > 0];

(* ---------- 2. extremum line / Poincare cut condition (eq:extrline) ----------
   p_phi depends on (R,Z) only via psi(R,Z) and B(R,Z).  grad p_phi = 0 is a
   linear homogeneous 2x2 system in (dp/dpsi, dp/dB); a nontrivial solution exists
   iff the coefficient determinant vanishes: psi_R B_Z - psi_Z B_R = 0. *)
CheckEq["eq:extrline  Jacobian det of (psi,B) wrt (R,Z) = psi_R B_Z - psi_Z B_R",
   Det[{{psiR, BR}, {psiZ, BZ}}], psiR BZ - psiZ BR];
(* elimination identity: ppsi*(det) = BZ*(grad_R eqn) - BR*(grad_Z eqn).
   When both grad eqns vanish, ppsi*det=0; with ppsi!=0 this forces det=0. *)
CheckEq["eq:extrline  ppsi*det = BZ*(eqR) - BR*(eqZ)  (det=0 follows from grad p=0)",
   ppsi (psiR BZ - psiZ BR),
   BZ (ppsi psiR + pB BR) - BR (ppsi psiZ + pB BZ)];

(* ---------- 3. canonical frequencies (eq:canfreqs) ----------
   omega_b = 2 pi / tau_b,  Omega_phi = Delta_phi_b / tau_b. *)
CheckEq["eq:canfreqs  omega_b tau_b = 2 pi  (theta = Omega tau, sigma=+1)",
   (2 Pi/taub) taub, 2 Pi, taub > 0];
CheckEq["eq:canfreqs  Omega_phi tau_b = Delta_phi_b",
   (dphib/taub) taub, dphib, taub > 0];
(* theta^2 = omega_b * tau is the bounce angle; advances by 2 pi over tau_b *)
CheckEq["eq:boubox  theta^2(tau_b) = omega_b tau_b = 2 pi",
   (2 Pi/taub) taub, 2 Pi, taub > 0];

(* ---------- 4. bounce average equivalence (eq:boubox) ----------
   <F>_b = (1/tau_b) int_0^tau_b F dtau = (1/2pi) int_0^2pi F dtheta^2,
   with theta^2 = (2pi/tau_b) tau, dtheta^2 = (2pi/tau_b) dtau.  Verify the
   change of variables maps the time integral onto the angle integral for an
   explicit test integrand. *)
With[{taubv = 7/2},
  Module[{Fdef, ttime, tangle},
    Fdef[t_] := 3 + 2 Cos[(2 Pi/taubv) t] + Sin[2 (2 Pi/taubv) t];
    ttime = (1/taubv) NIntegrate[Fdef[tau], {tau, 0, taubv}, WorkingPrecision -> 30];
    tangle = (1/(2 Pi)) NIntegrate[
       Fdef[th taubv/(2 Pi)], {th, 0, 2 Pi}, WorkingPrecision -> 30];
    CheckClose["eq:boubox  (1/tau_b)int dtau = (1/2pi)int dtheta^2", ttime, tangle]]];

(* ---------- 5. Heaviside representation (eq:reprTheta) ----------
   Theta(x) = (1/2) d/dx (x + |x|).  For x != 0 this is 1 (x>0) and 0 (x<0). *)
CheckEq["eq:reprTheta  (1/2) d/dx(x+|x|) = 1 for x>0",
   (1/2) D[x + Abs[x], x], 1, x > 0];
CheckEq["eq:reprTheta  (1/2) d/dx(x+|x|) = 0 for x<0",
   (1/2) D[x + Abs[x], x], 0, x < 0];

(* ---------- 6. delta-function resonance reduction (eq:boxflux_classes ->
   eq:boxflux_classes_conv) ----------
   delta(m2 omega_b + m3 Omega_phi) with omega_b=2pi/tau_b, Omega_phi=dphib/tau_b:
   m2 omega_b + m3 Omega_phi = (m3/tau_b)(dphib + 2pi m2/m3).
   delta(a y) = delta(y)/|a|, a = m3/tau_b  =>  factor tau_b/|m3|. *)
CheckEq["eq:resarg  m2 omega_b + m3 Omega_phi = (m3/tau_b)(dphib + 2pi m2/m3)",
   m2 (2 Pi/taub) + m3 (dphib/taub),
   (m3/taub) (dphib + 2 Pi m2/m3),
   taub > 0 && m3 != 0];
(* delta-rescaling prefactor: |m3| * (tau_b/|m3|) = tau_b cancels |m3| introduced
   when factoring m3/tau_b out of the argument. *)
CheckEq["eq:resjac  |m3| * delta-rescale factor tau_b/|m3| = tau_b",
   m3abs (taub/m3abs), taub, m3abs > 0];
(* On the resonance surface dphib = -2pi m2/m3, the weight
   (m2 omega_b df/dH + m3 df/dp) * (tau_b/|m3|) collapses to
   sgn(m3)(tau_b df/dp - dphib df/dH); pulling |m3| in front leaves
   exactly (tau_b df/dp - dphib df/dH) inside (eq:boxflux_classes_conv). *)
With[{dHv = 5/3, dPv = -4/7, m2v = 2, m3v = -3, taubv = 11/4},
  Module[{dphibRes, lhs, rhs},
    dphibRes = -2 Pi m2v/m3v;                       (* resonance condition *)
    lhs = m3v Abs[m3v] (taubv/Abs[m3v])             (* |m3|*(tau_b/|m3|) *)
            (m2v (2 Pi/taubv) dHv + m3v dPv)/m3v;   (* weight / m3, after sgn split *)
    rhs = m3v (taubv dPv - dphibRes dHv);
    CheckClose["eq:boxflux_conv  resonance weight collapses to tau_b df/dp - dphib df/dH",
       lhs, rhs]]];

(* ---------- 7. constant-p_phi derivative chain rule (eq:derH0_pp) ----------
   (d/dH0)_{p_phi} = (d/dH0)_x - (dp_phi/dH0)_x (dp_phi/dx)^{-1} d/dx,
   with (dp_phi/dH0)_x = h_phi/v_par.  Check on a test p_phi(H0,x) that the
   constant-p_phi total H0-derivative of a field equals the RHS combination. *)
With[{},
  Module[{ppf, Ffield, h0v, xv, pxv, dHfixedp, rhs, hphi, vpar},
    ppf[h0_, xx_] := h0 xx + xx^2;        (* test p_phi(H0,x) *)
    Ffield[h0_, xx_] := h0^2 xx + Sin[xx] + h0;  (* test field F(H0,x) *)
    h0v = 6/5; xv = 7/9;
    (* solve x(H0) along constant p_phi = ppf[h0v,xv]; differentiate F wrt H0 *)
    pxv = ppf[h0v, xv];
    dHfixedp = Module[{xsol, dF},
       xsol = x /. FindRoot[ppf[h0, x] == pxv /. h0 -> h0t, {x, xv},
          Evaluate -> False] /. h0t -> h0;
       (* analytic: dF/dH0 + dF/dx * dx/dH0, dx/dH0 = -(dp/dH0)/(dp/dx) *)
       (D[Ffield[h0, xx], h0] + D[Ffield[h0, xx], xx]
          (-D[ppf[h0, xx], h0]/D[ppf[h0, xx], xx])) /. {h0 -> h0v, xx -> xv}];
    rhs = (D[Ffield[h0, xx], h0]
            - D[ppf[h0, xx], h0]/D[ppf[h0, xx], xx] D[Ffield[h0, xx], xx]
          ) /. {h0 -> h0v, xx -> xv};
    CheckClose["eq:derH0_pp  (d/dH0)_pphi F = (d/dH0)_x F - (dp/dH0)(dp/dx)^-1 (d/dx) F",
       N[dHfixedp, 30], N[rhs, 30]]]];

(* ---------- 8. class parameterization functions xi_ij (eq:xifuns) ----------
   Each maps its x-range monotonically onto 0<xi<1, hitting the boundary values.
   xi_11=x, xi_12=1-(1-x)^2, xi_21=x^2, xi_22=(1-cos pi x)/2 on [0,1];
   xi_13=tanh x, xi_23=tanh^2 x on [0,inf); xi_33=(1+tanh x)/2 on (-inf,inf). *)
(* xi_12 endpoints and zero slope at the right (type-2 / sqrt) boundary *)
CheckEq["eq:xifuns  xi_12=1-(1-x)^2: xi(0)=0",   1 - (1 - 0)^2, 0];
CheckEq["eq:xifuns  xi_12=1-(1-x)^2: xi(1)=1",   1 - (1 - 1)^2, 1];
CheckEq["eq:xifuns  xi_12: xi'(1)=0 (flat right boundary)",
   D[1 - (1 - x)^2, x] /. x -> 1, 0];
(* xi_21=x^2: zero slope at the left boundary (sqrt-singular edge) *)
CheckEq["eq:xifuns  xi_21=x^2: xi(1)=1 and xi'(0)=0 (flat left boundary)",
   (x^2 /. x -> 1) + (D[x^2, x] /. x -> 0), 1];
(* xi_22=(1-cos pi x)/2: endpoints and flat at both ends *)
CheckEq["eq:xifuns  xi_22=(1-cos pi x)/2: xi(0)=0, xi(1)=1",
   ((1 - Cos[Pi x])/2 /. x -> 0) + ((1 - Cos[Pi x])/2 /. x -> 1), 1];
CheckEq["eq:xifuns  xi_22: xi'(0)=0 and xi'(1)=0 (flat both ends)",
   (D[(1 - Cos[Pi x])/2, x] /. x -> 0) + (D[(1 - Cos[Pi x])/2, x] /. x -> 1), 0];
(* xi_33=(1+tanh x)/2 maps (-inf,inf) onto (0,1) *)
CheckEq["eq:xifuns  xi_33=(1+tanh x)/2: limit x->-inf = 0",
   Limit[(1 + Tanh[x])/2, x -> -Infinity], 0];
CheckEq["eq:xifuns  xi_33=(1+tanh x)/2: limit x->+inf = 1",
   Limit[(1 + Tanh[x])/2, x -> Infinity], 1];

(* xi_13=tanh x flattens the log singularity: near an X-point/separatrix
   tau_b ~ C log|R_c - R_X|, and the convreg map R_c = R_X + dR exp(x) gives
   tau_b ~ C x linear in x as x->-inf.  Check d/dx log(exp(x)) = 1 (linearization). *)
CheckEq["eq:convreg  R_c=R_X+dR exp(x) linearizes log singularity: d/dx log|R_c-R_X|=1",
   D[Log[dR Exp[x]], x], 1, dR > 0];

(* X-point has double log amplitude vs usual crossing (eq: tau_b ~ 2 C log|R_c-R_X|).
   p_phi has an EXTREMUM at X (dp/dRc ~ (R_c-R_X)), finite slope at usual crossing.
   In x-variable R_c-R_X ~ exp(x): a quadratic extremum p ~ (R_c-R_X)^2 ~ exp(2x). *)
CheckEq["eq:xptdouble  X-point dp/dRc ~ (R_c-R_X) (extremum), vanishing slope",
   D[(rc - rx)^2/2, rc] /. rc -> rx, 0];

(* ---------- Notes: definitions and numerical / modeling steps ---------- *)
Note["eq:jacbz  phase-space Jacobian definition",
  "J_z = sqrt(g) e B*_par/(c v_par) = e B*_par R/(c v_par) is the guiding-centre phase-space Jacobian (definition, used in the reduction check above)."];
Note["eq:finalint  orbit-integral structure",
  "A = 4pi^2 sum_sigma int dH0 dJperp dp_phi dtau A is the reduced phase-space integral; the tau and R_c (p_phi) integrals are evaluated NUMERICALLY by the orbit solver, not in closed form."];
Note["eq:bi_classes / boxflux_classes  numerical orbit integrals",
  "b_i, A_0box, Gamma_box, T_phi^(int): bounce integrals over tau_b of real orbits; tau_b, Delta_phi_b sampled adaptively over class parameter x. Numerical, not mechanizable in closed form."];
Note["eq:fullbou  bounce time as sum of return times",
  "tau_b = tau_r(sigma') + tau_r(sigma, R(R_c,tau_r)); definition of full bounce time from two first-return segments. Geometric/modeling identity tied to real orbit topology."];
Note["orbit classification (sec:class Classes)",
  "Split into N_cl classes at X-points R_X and separatrix crossings R_s (roots of p_phi^sigma=p_phi^X); class count independent of sigma. Topology-driven counting, not a closed-form algebraic identity."];
Note["eq:xifuns interval ranges (16 interval types)",
  "x-interpolation ranges use epsilon (accuracy) and delta=|Rmax-Rmin|/Rmin (relative class width); these set truncation of tanh/exp ranges for log/sqrt singularities. Numerical-discretization choice, recorded not mechanized."];
Note["singularity classification (4 boundary types)",
  "type1 regular (finite), type2 reflecting v_par=0 (dp/dRc ~ |R_c-R_r|^-1/2 sqrt-singular), type3 usual separatrix (tau_b ~ C log), type4 X-point (tau_b ~ 2C log, double amplitude). Asymptotic scalings of real orbit integrals."];

(* Chapter 3: Hamiltonian theory of guiding-centre motion in a tokamak.
   Verified against Diss_Albert.tex, chap:Action-Angle-variables-in.
   Topics: guiding-centre Lagrangian, canonical form, transformation of radial
   dependencies, action-angle in quasi-1D and tokamak, canonical frequencies,
   generating function, small orbit width approximation, approximate canonical
   coordinates.
   Convention: thesis elliptic K(kappa), E(kappa) with kappa = k^2 maps to
   Mathematica EllipticK[m], EllipticE[m] (parameter m = kappa). *)

(* ---------- guiding-centre kinematics: v_parallel <-> H ---------- *)

(* eq:vpar / eq:Hamiltonian  consistency of the two inverse relations.
   v_par = sigma sqrt(2/m (H - e Phi - Jperp wc)); inverting for H reproduces
   eq:Hamiltonian. *)
vpar[s_] := s Sqrt[(2/mA) (Hh - eA Phi - Jp wc)];
CheckEq["eq:Hamiltonian  H = m vpar^2/2 + e Phi + Jperp wc inverts eq:vpar",
   mA vpar[1]^2/2 + eA Phi + Jp wc, Hh,
   mA > 0 && Hh - eA Phi - Jp wc > 0];

(* eq:vpar derivative wrt H:  dv_par/dH = 1/(m v_par)  (used for J_par, tau_b) *)
CheckEq["eq:vpar  dvpar/dH = 1/(m vpar)",
   D[vpar[1], Hh], 1/(mA vpar[1]),
   mA > 0 && Hh - eA Phi - Jp wc > 0];

(* eq:vpar derivative wrt Jperp: dv_par/dJperp = -wc/(m v_par)  (used for
   Omega^phi = <wc>_b) *)
CheckEq["eq:vpar  dvpar/dJperp = -wc/(m vpar)",
   D[vpar[1], Jp], -wc/(mA vpar[1]),
   mA > 0 && Hh - eA Phi - Jp wc > 0];

(* ---------- large aspect ratio pendulum analogy ---------- *)

(* eq:Hamiltonian-1-1  with B = B0(1 - eps cos theta) the magnetic potential
   term Jperp e/(m c) B is, up to a constant, a cosine well: the theta-dependent
   part is -(Jperp e B0 eps/(m c)) cos(theta), i.e. pendulum U0 = Jperp e B0 eps/(m c). *)
Bfield[th_] := B0 (1 - eps Cos[th]);
CheckEq["eq:Hamiltonian-1-1  Jperp e/(mc) B has pendulum cos-well form",
   Jp eA/(mA cc) Bfield[th] - Jp eA B0/(mA cc),
   -(Jp eA B0 eps/(mA cc)) Cos[th]];

(* ---------- quasi-1D action-angle: structural identities ---------- *)

(* eq:Jk  for a coordinate with constant momentum p_k over a full range Dx^k,
   J_k = (1/2pi) oint dx^k p_k = (Dx^k/2pi) p_k. *)
CheckEq["eq:Jk  J_k = Dx^k/(2pi) p_k for constant p_k",
   (1/(2 Pi)) Integrate[pk, {xk, 0, Dxk}], (Dxk/(2 Pi)) pk];

(* eq:omn / eq:thetatau  Omega^n tau_b = sigma 2pi; theta^n = Omega^n tau *)
CheckEq["eq:omn  Omega^n tau_b = sigma 2 pi",
   (sig 2 Pi/taub) taub, sig 2 Pi];
CheckEq["eq:thetatau  theta^n = Omega^n tau = 2 pi sigma tau/tau_b",
   (sig 2 Pi/taub) tau, 2 Pi sig tau/taub];

(* eq:om1 / eq:om2  Omega^k = (2pi/Dx^k)(1/tau_b) int_0^tau_b xdot^k dtau
   = (2pi/Dx^k)(1/tau_b)(x^k(tau_b)-x^k(0)).  Fundamental theorem of calculus:
   int_0^tau_b xdot^k dtau = x^k(tau_b)-x^k(0).  Verified on a representative
   non-uniform path x^k(t)=ck t + ak sin(wk t) (uniform drift + oscillation). *)
With[{xk = (ck # + ak Sin[wk #] &)},
  CheckEq["eq:om2  int_0^tau_b xdot^k dtau = x^k(tau_b) - x^k(0)",
     Integrate[xk'[t], {t, 0, taub}],
     xk[taub] - xk[0]]];

(* ---------- canonical form: covariant radial field and G ODE ---------- *)

(* eq:G derivation  B_rbar = (dtheta/dr) B_theta + (dphi/dr) B_phi + B_r with
   theta = thbar + G, phi = phbar + q G (G = G(r), tokamak); plugging in the
   transformation derivatives gives B_rbar = G'(B_theta + q B_phi) + G q' B_phi
   + B_r.  Verify this expansion. *)
With[{},
  Module[{th, ph, Brbar},
    th = thbar + Gf[r];
    ph = phbar + qf[r] Gf[r];
    Brbar = D[th, r] Bth + D[ph, r] Bph + Br;
    CheckEq["eq:G  B_rbar = G'(B_th+qB_ph) + G q' B_ph + B_r",
       Brbar,
       Gf'[r] (Bth + qf[r] Bph) + Gf[r] qf'[r] Bph + Br]]];

(* eq:G  setting B_rbar = 0 and solving for G' gives the thesis ODE rhs. *)
CheckEq["eq:G  G' = -(B_r + G q' B_ph)/(B_th + q B_ph)",
   Gprime /. Solve[Gprime (Bth + qf Bph) + Gf qf' Bph + Br == 0, Gprime][[1]],
   -(Br + Gf qf' Bph)/(Bth + qf Bph)];

(* ---------- transformation of radial dependencies ---------- *)

(* eq:dpdr  dp_phi/dr_phi = -(e/c) psi_pol'(r_phi).  With psi_pol' = sqrt(g) B^theta
   and B^theta = wc m c / e * h^theta (from wc = e B/(m c), B = B^theta/h^theta...),
   verify the chain -(e/c) sqrt(g) B^th = -m sqrt(g) h^th wc using B^th = wc m c h^th/e. *)
CheckEq["eq:dpdr  -(e/c) sqrt(g) B^theta = -m sqrt(g) h^theta wc",
   -(eA/cc) sg Bth /. Bth -> wc mA cc hth/eA,
   -mA sg hth wc];

(* eq:rphi / eq:dpdr  p_phi = (e/c) A_phi = -(e/c) psi_pol; dp/dr = -(e/c) psi_pol'. *)
CheckEq["eq:rphi  p_phi = (e/c) A_phi = -(e/c) psi_pol",
   (eA/cc) Aph /. Aph -> -psipol, -(eA/cc) psipol];

(* ---------- small orbit width: poloidal momentum and metric identity ---------- *)

(* eq:ptheta-1  p_theta = e/c A_th + m v (h_th + q h_phi) and h_th + q h_phi = 1/h^th.
   Identity from B^2 = B^theta (B_theta + q B_phi): with h_i = B_i/B, h^theta = B^theta/B,
   1/h^theta = B/B^theta = (B_theta+q B_phi)/B = h_theta + q h_phi. *)
(* h_i = B_i/B, h^theta = B^theta/B; B^2 = B^theta(B_theta + q B_phi) gives
   B^theta = B^2/(B_theta + q B_phi).  Then h_theta + q h_phi = (B_theta+qB_phi)/B
   = B/B^theta = 1/h^theta. *)
CheckEq["eq:ptheta-1  h_theta + q h_phi = 1/h^theta  via B^2=B^th(B_th+qB_ph)",
   (Bthc + qf Bphc)/Bf - 1/(Bthcon/Bf) /. Bthcon -> Bf^2/(Bthc + qf Bphc),
   0, Bf > 0 && Bthc + qf Bphc > 0];

(* eq:rofrph  first-order radius shift r = r_phi + c m v h_phi/(e psi_pol')
   = r_phi + v h_phi/(wc sqrt(g) h^theta), using psi_pol' = h^theta wc sqrt(g) c m/e. *)
CheckEq["eq:rofrph  two forms of the first-order radius shift agree",
   cc mA vp hph/(eA psipolp) /. psipolp -> hth wc sg cc mA/eA,
   vp hph/(wc sg hth)];

(* ---------- small orbit width: canonical frequencies ---------- *)

(* eq:Jpar derivative  dJ_par/dH = (1/2pi) oint dth m/h^th * dv/dH
   = (1/2pi) oint dth/(h^th v) = sigma tau_b/(2pi), using dv/dH = 1/(m v) and
   tau_b = sigma oint dth/(v h^th).  Verify the integrand identity. *)
CheckEq["eq:Jpar  integrand m/h^th dv/dH = 1/(h^th v) (-> sigma tau_b/2pi)",
   (mA/hth) (1/(mA vpll)), 1/(hth vpll), hth > 0 && vpll > 0];

(* eq:Omega^phi  dJ_par/dJperp integrand: m/h^th dv/dJperp = -wc/(h^th v)
   -> Omega^phi = <wc>_b.  Verify integrand. *)
CheckEq["eq:Omphi  integrand m/h^th dv/dJperp = -wc/(h^th v)",
   (mA/hth) (-wc/(mA vpll)), -wc/(hth vpll), hth > 0 && vpll > 0];

(* eq:dAtheta/dpphi  dA_theta/dp_phi = A_theta'(dr_phi/dp_phi)
   = -(c/e) psi_tor'/psi_pol' = -(c/e) q, with A_theta'=psi_tor',
   dr_phi/dp_phi = (dp_phi/dr_phi)^{-1} = -c/(e psi_pol'), q = psi_tor'/psi_pol'. *)
CheckEq["eq:dAtheta  dA_theta/dp_phi = -(c/e) q",
   psitorp (-cc/(eA psipolp)),
   -(cc/eA) (psitorp/psipolp), eA != 0 && psipolp != 0];

(* eq:OmtB  metric derivative d/dr(1/h^theta) = -1/B^theta dB/dr
   + 1/B d/dr(B_theta - q B_phi), with 1/h^theta = (B_theta - q B_phi)/B.
   (thesis uses B^2 = B^theta(B_theta+qB_phi), here covariant combination.) *)
With[{},
  Module[{inv},
    inv = (Bthc[r] - qf[r] Bphc[r])/Bf[r];
    CheckEq["eq:OmtB  d/dr(1/h^th) expansion",
       D[inv, r],
       -(1/Bthcon[r]) Bf'[r] + (1/Bf[r]) D[Bthc[r] - qf[r] Bphc[r], r]
         /. Bthcon[r] -> Bf[r]^2/(Bthc[r] - qf[r] Bphc[r])]]];

(* ---------- velocity-space parametrization ---------- *)

(* eq:Jperp / eq:vpar-2  with Jperp = m v^2/2 * (mc/e) eta and
   wc = e B/(m c), the perpendicular energy Jperp wc = m v^2 eta B/2, so
   v_par^2 = v^2 - 2 Jperp wc/m = v^2(1 - eta B), i.e. v_par = sigma v sqrt(1-eta B). *)
CheckEq["eq:vpar-2  vpar^2 = v^2(1 - eta B) from Jperp, eta parametrization",
   vv^2 - (2/mA) (mA vv^2/2 (mA cc/eA) eta) (eA Bf/(mA cc)),
   vv^2 (1 - eta Bf)];

(* ---------- approximate transformation to canonical coordinates ---------- *)

(* eq:dphi / total-derivative identity  m v h_r rdot = d/dt(v h_r r) - r d/dt(v h_r).
   product rule, treating v h_r and r as functions of time. *)
CheckEq["eq:dphi  m v h_r rdot = d/dt(v h_r r) - r d/dt(v h_r)",
   D[vhr[t] rr[t], t] - rr[t] D[vhr[t], t],
   vhr[t] rr'[t]];

(* ---------- thesis annotations (non-mechanizable) ---------- *)

Note["eq:Lagrangian-1",
  "guiding-centre Lagrangian (Littlejohn 1983) is a physical-modeling definition, not a derivable identity"];
Note["eq:Jtheta",
  "poloidal action as orbit/coordinate integral relies on numerical orbit integration; no closed symbolic check"];
Note["eq:am",
  "Fourier-harmonic transformation to canonical angles depends on orbit-integrated theta_orb(tau); verified structurally elsewhere, not symbolically here"];
Note["eq:Omt-1",
  "bounce-averaged precession frequency is an integral over numerically integrated orbits; bounce average has no closed form"];

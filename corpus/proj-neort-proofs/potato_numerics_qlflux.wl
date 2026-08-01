(* POTATO normalized variables, paraxial check, toroidal GC rotation, QL flux/torque.
   Source: NEO-RT/POTATO/TEX/equilmaxw.tex, sec. "Normalized variables, numerics,
   tests" (lines 1347-2308): eqs normvar, normPhiandH, normjperp, paraxial bi_check,
   torflow, torflow_L, torflow_L_booz, normtorfl, nl_themforces, bouav_theta_norm,
   normperham.  Verified here: the normalization algebra, the paraxial integral
   reductions, the toroidal flow / Larmor-flow surface-average step, the
   thermodynamic-force gradient, the rectifier identity, and the perturbed-
   Hamiltonian normalization. *)

(* ---------- 1. normalization of H0 (eq normPhiandH) ----------
   H0 = p^2/(2m) + e Phi.  Hhat0 = H0/E_ref = (p/p0)^2 + e Phi/E_ref = phat^2 + Phihat
   with p0 = sqrt(2 m E_ref). *)
CheckEq["normPhiandH  Hhat0 = phat^2 + Phihat with p0=sqrt(2 m Eref)",
   (pp^2/(2 mm) + ee Phi)/Eref,
   (pp/Sqrt[2 mm Eref])^2 + ee Phi/Eref,
   mm > 0 && Eref > 0];

(* ---------- 2. normalization of perp invariant (eq normjperp) ----------
   Jperp_hat = phat_perp^2/B with phat_perp=p_perp/p0, p0^2=2 m Eref, equals
   e Jperp/(m c Eref) for the canonical perp invariant Jperp = c p_perp^2/(2 e B). *)
CheckEq["normjperp  phat_perp^2/B = e Jperp/(m c Eref),  Jperp=c p_perp^2/(2eB)",
   (pperp^2/(2 mm Eref))/B,
   ee (cc pperp^2/(2 ee B))/(mm cc Eref),
   mm > 0 && Eref > 0 && B > 0 && ee > 0 && cc > 0];

(* ---------- 3. paraxial check: Jperp integral (eq bi_check line3->line4) ----------
   Integral over Jperp of 1/sqrt(H0 - Jperp B0), 0..H0/B0, equals 2 sqrt(H0)/B0;
   times prefactor 4 pi^{3/2} R0 B0 gives 8 pi^{3/2} R0 sqrt(H0). *)
CheckEq["bi_check  Int_0^{H0/B0} dJp/sqrt(H0-Jp B0) = 2 sqrt(H0)/B0",
   Integrate[1/Sqrt[H0 - Jp B0], {Jp, 0, H0/B0}, Assumptions -> H0 > 0 && B0 > 0],
   2 Sqrt[H0]/B0,
   H0 > 0 && B0 > 0];

(* ---------- 4. paraxial check: H0 integral (eq bi_check line4->line5) ----------
   Int_0^inf sqrt(H0) exp(-H0) dH0 = sqrt(pi)/2, so 8 pi^{3/2} R0 * (this) = 4 pi^2 R0. *)
CheckEq["bi_check  8 pi^{3/2} Int_0^inf sqrt(H0) e^{-H0} dH0 = 4 pi^2",
   8 Pi^(3/2) Integrate[Sqrt[H0] Exp[-H0], {H0, 0, Infinity}],
   4 Pi^2];

(* ---------- 5. paraxial check: class/substitution prefactor (line2->line3) ----------
   2 classes give 2 sqrt(pi); substituting |dpsi*/dr|=r B0/q0 and
   taub_hat = 2 pi q0 R0/sqrt(...) the r/q0-independent prefactor is 4 pi^{3/2} R0 B0. *)
CheckEq["bi_check  (2 sqrt(pi))(B0/q0)(2 pi q0 R0) = 4 pi^{3/2} R0 B0",
   (2 Sqrt[Pi]) (B0/q0) (2 Pi q0 R0),
   4 Pi^(3/2) R0 B0,
   q0 != 0];

(* ---------- 6. toroidal-flow surface-average step (eq torflow_L line1->line2) ----------
   The d_theta(nbar B_psi/B^2) term in n V_L^phi is a total theta-derivative; over a
   full poloidal period it integrates to zero, leaving only the d_psi piece. *)
CheckEq["torflow_L  total theta-derivative term vanishes on poloidal average",
   Integrate[D[Sin[th]^2 + Cos[3 th] + th^0 g, th], {th, 0, 2 Pi}],
   0];

(* ---------- 7. normalized toroidal flow (eq normtorfl) ----------
   <n V^phi> = c(nbar Phi' + (T/e) nbar') (from torflow). Normalizing Phi=Eref Phihat/e,
   T=Eref That, dividing by v0, gives Phi_eff(nbar Phihat' + That nbar'),
   Phi_eff = c Eref/(e v0). *)
CheckEq["normtorfl  <nVhat^phi> = Phi_eff(nbar Phihat' + That nbar'), Phi_eff=cEref/(ev0)",
   (1/v0) cc (nbar (Eref/ee) dPhihat + (Eref That/ee) dnbar),
   (cc Eref/(ee v0)) (nbar dPhihat + That dnbar),
   ee != 0 && v0 != 0];

(* ---------- 8. thermodynamic forces (eq nl_themforces) ----------
   d/dpsi* log[ nbar T^{-3/2} exp((Phi-H0)/T) ] = A1* + (H0-Phi)/T A2*,
   with A1*=nbar'/nbar + Phi'/T - (3/2)T'/T, A2*=T'/T.  This is the load-bearing
   identity behind the A1*,A2* split in boxflux/inttorque. *)
CheckEq["nl_themforces  d_psi* log f = A1* + (H0-Phi)/T A2*",
   D[Log[nbar[ps]] - (3/2) Log[Tt[ps]] + (Phi[ps] - H0)/Tt[ps], ps],
   (nbar'[ps]/nbar[ps] + Phi'[ps]/Tt[ps] - (3/2) Tt'[ps]/Tt[ps])
     + (H0 - Phi[ps])/Tt[ps] (Tt'[ps]/Tt[ps])];

(* ---------- 9. rectifier identity (eq bouav_theta_norm line1->line2) ----------
   1/2 (r0-r + |r0-r|) = (r0-r) Theta(r0-r).  Drops the factor 1/2 and the abs into
   the ramp function used inside the bounce average. *)
CheckEq["bouav_theta_norm  (r0-r+|r0-r|)/2 = (r0-r) Theta(r0-r),  r0>r",
   (1/2) ((r0 - r) + Abs[r0 - r]), (r0 - r) UnitStep[r0 - r],
   r0 > r];
CheckEq["bouav_theta_norm  (r0-r+|r0-r|)/2 = (r0-r) Theta(r0-r),  r0<r",
   (1/2) ((r0 - r) + Abs[r0 - r]), (r0 - r) UnitStep[r0 - r],
   r0 < r];

(* ---------- 10. perturbed-Hamiltonian normalization (eq normperham) ----------
   delta Hhat = (2(Hhat0-Phihat) - Jperp_hat B) delta B/B.  With phat^2=Hhat0-Phihat
   = phat_par^2 + Jperp_hat B (eqs normPhiandH/normjperp), this equals
   (2 phat_par^2 + Jperp_hat B) delta B/B, i.e. mu delta B form (parallel doubled). *)
CheckEq["normperham  (2(Hhat0-Phihat)-Jp B) dB/B = (2 ppar^2 + Jp B) dB/B",
   (2 (ppar^2 + Jp B) - Jp B) (dB/B),
   (2 ppar^2 + Jp B) (dB/B),
   B != 0];

(* ---------- 11. equilibrium test profile derivative (eq equi_input) ----------
   Phihat = PhiA(r - r^2/2 + r^3/4)  =>  dPhihat/dr = PhiA(1 - r + 3 r^2/4),
   used to build A1* for the AUG g30835 test case. *)
CheckEq["equi_input  d/dr [PhiA(r - r^2/2 + r^3/4)] = PhiA(1 - r + 3 r^2/4)",
   D[PhiA (r - r^2/2 + r^3/4), r], PhiA (1 - r + 3 r^2/4)];

(* ---------- 12. Rc reparameterization chain rule (eq below bouav_theta_norm_Rc) ----------
   dpsi*/dRc = (dpsi*/dx)(dRc/dx)^-1 when psi* and Rc are both functions of x. *)
CheckEq["bouav_theta_norm_Rc  dpsi*/dRc = (dpsi*/dx)(dRc/dx)^-1",
   D[psis[x], x]/D[Rc[x], x], D[psis[x], x] (D[Rc[x], x])^-1];

(* ---------- modeling / definition steps recorded as Notes ---------- *)
Note["normvar-defs",
  "normvar/That: hat t=v0 t, phat=p/p0, p0=m v0=sqrt(2 m Eref), That=T/Eref are normalization definitions; checks 1,2,7,10 verify the algebra they feed."];
Note["bi_classes_norm-jacobian",
  "bi_classes_norm is the Jacobian change of variables (p_phi->psi*, plus Hhat0,Jperp_hat,x) of the orbit phase-space integral; the prefactor sqrt(pi)/2 and the Maxwellian weight nbar/That^{3/2} exp((Phihat-Hhat0)/That) are carried symbolically, the integral reductions are verified in the paraxial limit (checks 3-5)."];
Note["torflow_L-curl",
  "torflow_L line1 is the contravariant phi-component of curl(p_perp h/(m omega_c)) in flux coords with p_perp=nbar T (const T), h_i=B_i/B, omega_c=eB/(mc), giving the -cT/e prefactor; this is a vector-identity/modeling step. Check 6 verifies the surface-average annihilation of the d_theta term."];
Note["torflow_L_booz-flux-functions",
  "torflow_L_booz pulls (q B_phi + B_theta) out of the theta-average (Boozer sqrt g) treating q B_phi+B_theta and B_theta as flux functions, then drops B_theta vs q B_phi at O((eps_t/q)^2); a tokamak-ordering modeling step, not a pure identity."];
Note["adaptive-grid",
  "the adaptive-grid binary-refinement description (ssec:adaptive) and the grid-point Table are algorithmic/numerical-experiment content with no closed-form identity to mechanize."];
Note["delta-eval-method1",
  "boxflux/inttorque _evald replace the x-integral by sum over resonant roots x_res with the delta(Delta phi_b + 2 pi m2/m3) Jacobian |d Delta phi_b/dx|^{-1}; standard delta-of-composite-function rule, an orbit/resonance step."];
Note["AG-contour-method2",
  "Method 2 (Albert-Grabenwarter) recasts the 2D delta integral as an ODE march along the resonant line s=0 with speed 1/|grad s|; this is the level-set contour construction, a geometric/numerical method, not an algebraic identity."];
Note["Hbm-periodic",
  "hatBm_norm rewrites the resonant phase m3 phi - i(m2 omega_b + m3 Omega_phi)tau using the resonance condition and tau-periodicity into the period-tau_b form for numerical bounce averaging; an orbit-averaging modeling step."];

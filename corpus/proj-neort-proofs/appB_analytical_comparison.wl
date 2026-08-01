(* Appendix B: Analytical comparison to existing results.
   Verified against Diss_Albert.tex, chap:Comparison-to-existing
   (thesis lines 5075-5615): toroidal drift frequencies, bounce integrals in
   the large-aspect-ratio limit, the Eulerian drift-orbit-resonance reduction,
   transport coefficients for bounce-drift resonances, and the transit-drift
   resonance with the non-periodic Fourier correction.

   Elliptic convention: thesis K(kappa), E(kappa) with kappa=k^2 matches
   Mathematica EllipticK[m], EllipticE[m] (parameter convention). *)

(* ===== Toroidal drift frequencies (eq:magdrift -> eq:OmtB) ===== *)

(* psi_pol' = B^theta = B^2/(B_th + q B_ph). The product-rule line (thesis
   second line of psi'' block) is the plain derivative of that ratio. *)
B2[r_] := Bsq[r];
den[r_] := Bth[r] + q[r] Bph[r];
Bcontra[r_] := B2[r]/den[r];
CheckEq["eq:psipp-prod  psi'' = d/dr(B^2/(B_th+qB_ph)) (product rule)",
   D[B2[r]/den[r], r],
   -B2[r]/den[r]^2 D[den[r], r] + 1/den[r] D[B2[r], r]];

(* Factored form (thesis third line of psi'' block, eq:magdrift derivation).
   As printed the thesis has +dB^2/dr inside the bracket; the form consistent
   with the product rule and with the subsequent psi''/psi'*B line carries
   -dB^2/dr.  Verify the CORRECT (sign-fixed) factored form. *)
psipp[r_] := -1/den[r] (Bcontra[r] D[den[r], r] - D[B2[r], r]);
CheckEq["eq:psipp-fact  psi'' = -(1/(B_th+qB_ph))(B^th d(B_th+qB_ph)/dr - dB^2/dr)",
   D[B2[r]/den[r], r], psipp[r]];

(* psi''/psi' * B (eq:magdrift block lines): using psi'=B^theta=B^2/den and
   B^2=B^theta*den, the prefactor B/(B^theta den) collapses to 1/B. *)
CheckEq["eq:psipp-B  (psi''/psi') B = B/(B^th den)(-B^th d(den)/dr + dB^2/dr)",
   psipp[r]/Bcontra[r] Bx,
   Bx (-Bcontra[r] D[den[r], r] + D[B2[r], r])/(Bcontra[r] den[r])];
CheckEq["eq:psipp-B2  collapses to (1/B)(-B^th d(den)/dr + dB^2/dr) via B^2=B^th den",
   (Bx (-Bcontra[r] D[den[r], r] + D[B2[r], r])/(Bcontra[r] den[r])) /.
      Bsq -> Function[r, Bx^2],
   (1/Bx (-Bcontra[r] D[den[r], r] + D[B2[r], r])) /. Bsq -> Function[r, Bx^2]];

(* ===== Bounce integrals in the large-aspect-ratio limit ===== *)

(* Turning points: sin^2(th^pm/2)=kappa  =>  th^pm = +-2 arcsin sqrt(kappa). *)
CheckEq["eq:turn  sin^2(arcsin sqrt(kappa)) = kappa",
   Sin[ArcSin[Sqrt[kap]]]^2, kap, 0 < kap < 1];

(* eq:taub-2  trapped bounce time: full-orbit integral between turning points
   oint dth/sqrt(kappa - sin^2(th/2)) = 4 K(kappa).  Definite integral, numeric
   with rational kappa; turning points th^pm = +-2 arcsin sqrt(kappa). *)
With[{kv = 3/10},
  Module[{xp, Iint},
    xp = 2 ArcSin[Sqrt[kv]];
    Iint = NIntegrate[1/Sqrt[kv - Sin[th/2]^2], {th, -xp, xp},
       WorkingPrecision -> 30];
    CheckClose["eq:taub-2  oint dth/sqrt(kappa-sin^2(th/2)) = 4 K(kappa)",
       Iint, 4 EllipticK[kv]]]];

(* eq:bounceavg2  bounce average normalisation: <a>_b with a=1 returns 1, i.e.
   (1/(4K)) * (full-orbit integral) = 1. *)
With[{kv = 2/5},
  Module[{xp, Iint},
    xp = 2 ArcSin[Sqrt[kv]];
    Iint = NIntegrate[1/Sqrt[kv - Sin[th/2]^2], {th, -xp, xp},
       WorkingPrecision -> 30];
    CheckClose["eq:bounceavg2  <1>_b = (1/(4K)) oint dth/v_par-kernel = 1",
       Iint/(4 EllipticK[kv]), 1]]];

(* Passing transit: full theta range (-pi,pi), kappa>1 (here 1/kappa<1).
   oint dth/sqrt(kappa - sin^2(th/2)) = (4/sqrt(kappa)) K(1/kappa); one pass
   (half) is 2 K(1/kappa)/sqrt(kappa) as in the transit-time expression. *)
With[{kv = 13/10},
  CheckClose["eq:taub-pass  oint_{-pi}^{pi} dth/sqrt(kappa-sin^2) = 4 K(1/kappa)/sqrt(kappa)",
     NIntegrate[1/Sqrt[kv - Sin[th/2]^2], {th, -Pi, Pi}, WorkingPrecision -> 30],
     4 EllipticK[1/kv]/Sqrt[kv]]];

(* kappa as a function of pitch eta (thesis kappa = (1/eta - B_a(1-eps))/(2 B_a eps))
   and its derivative dkappa/deta = -1/(2 eta^2 B_a eps). *)
kapEta[e_] := (1/e - Ba (1 - eps))/(2 Ba eps);
CheckEq["eq:kappa-eta  kappa = (1/eta - B_a(1-eps))/(2 B_a eps)",
   kapEta[eta],
   (1 - eta Ba (1 - eps))/(2 eta Ba eps), eta > 0 && Ba > 0 && eps > 0];
CheckEq["eq:dkappa-deta  dkappa/deta = -1/(2 eta^2 B_a eps)",
   D[kapEta[eta], eta], -1/(2 eta^2 Ba eps), Ba > 0 && eps > 0];

(* ===== Eulerian approach to drift-orbit resonances ===== *)

(* Thermodynamic-force algebra (thesis "Notice that" line):
   (1/(n T)) d/ds(n T) = (1/n) dn/ds + (1/T) dT/ds. *)
CheckEq["eq:A12  (1/(nT)) d/ds(nT) = (1/n)dn/ds + (1/T)dT/ds",
   D[nn[s] tt[s], s]/(nn[s] tt[s]),
   nn'[s]/nn[s] + tt'[s]/tt[s]];

(* Kinetic-energy weight rearrangement (Eulerian-equation source term):
   with mu B = (v^2 - v_par^2)/2,
   v_par^2 - mu B = (3/2) v_par^2 - (1/2) v^2 = -v^2(1/2 - (3/2) v_par^2/v^2). *)
CheckEq["eq:vpar-muB  v_par^2 - mu B = 3/2 v_par^2 - 1/2 v^2  (mu B=(v^2-v_par^2)/2)",
   vpar^2 - (v^2 - vpar^2)/2, 3/2 vpar^2 - 1/2 v^2];
CheckEq["eq:vpar-fact  = -v^2(1/2 - (3/2) v_par^2/v^2)",
   3/2 vpar^2 - 1/2 v^2, -v^2 (1/2 - 3/2 vpar^2/v^2), v != 0];

(* ===== Transport coefficients for bounce-drift resonances ===== *)

(* Velocity-space measure change x=u^2, dx=2u du: u^3 e^{-u^2} du = (1/2) x e^{-x} dx
   (the step taking the eq:D1x integrand from u to x). *)
CheckClose["eq:D1x-measure  int u^3 e^{-u^2} du = (1/2) int x e^{-x} dx",
   NIntegrate[u^3 Exp[-u^2], {u, 0, Infinity}, WorkingPrecision -> 30],
   (1/2) NIntegrate[xx Exp[-xx], {xx, 0, Infinity}, WorkingPrecision -> 30]];

(* Radial-coordinate substitution chi' = psi_pol' ds/dV (thesis chi'(V)=psipol'(s) ds/dV)
   gives (ds/dV)^2/chi'^2 = 1/psi_pol'^2, used to recast the eq:D1x prefactor. *)
CheckEq["eq:chi-prime  (ds/dV)^2/chi'^2 = 1/psi_pol'^2   (chi'=psi_pol' ds/dV)",
   dsdV^2/chip^2 /. chip -> psip dsdV, 1/psip^2, psip != 0 && dsdV != 0];

(* Resonance-condition derivative (thesis eq above eq:Gnm2): chain rule
   d/deta(...) = (dkappa/deta) d/dkappa(...) with the factoring of the bracket
   into m2 * sqrt(mu B_a eps/m)(chi'/B_a)(... - pi/(2K)). With the leading
   -1/(2 eta^2 B_a eps) this matches m2/(2 eta^2 B_a eps) times the factored
   bracket.  Verified as the K-independent bracket identity (S=sqrt(mu B_a eps/m)). *)
CheckEq["eq:res-fact  -[-n c/chi dPhi + m2 (pi/2K) S chi/Ba] = m2 S chi/Ba((n/m2)(c/chi)(1/S)(Ba/chi)dPhi - pi/2K)",
   -(-nh cc/chi dPhidV + m2 Pi/(2 KK) S chi/Ba),
   m2 (S chi/Ba ((nh/m2)(cc/chi)(1/S)(Ba/chi) dPhidV - Pi/(2 KK))),
   chi != 0 && Ba != 0 && S != 0 && m2 != 0];

(* ===== Transit-drift resonance: non-periodic Fourier correction ===== *)

(* Quasi-period of the incomplete elliptic integral of the first kind:
   F(phi+pi, m) = F(phi, m) + 2 K(m).  This is the engine behind the periodic
   angle alpha(theta). *)
With[{mv = 1/3, phv = 2/5},
  CheckClose["eq:F-quasiperiod  F(phi+pi,m) = F(phi,m) + 2 K(m)",
     N[EllipticF[phv + Pi, mv], 30],
     N[EllipticF[phv, mv] + 2 EllipticK[mv], 30]]];

(* alpha(theta) periodic: xi(theta)=(pi/K(1/kappa)) F(theta/2, 1/kappa) advances
   by exactly 2 pi over one period, so xi(theta)=theta+alpha(theta) with alpha
   periodic.  Numeric check xi(theta+2 pi) - xi(theta) = 2 pi. *)
With[{m = 1/4, t0 = 7/10},
  Module[{xi},
    xi[t_] := Pi/EllipticK[m] EllipticF[t/2, m];
    CheckClose["eq:alpha-periodic  xi(theta+2pi) - xi(theta) = 2 pi",
       N[xi[t0 + 2 Pi] - xi[t0], 30], N[2 Pi, 30]]]];

(* Fourier-exponent algebra for circulating particles (thesis g(xi,zeta0) block):
   (m-nq)(xi+beta) + n z0 = m xi + n z0 + (m-nq) beta - nq xi. *)
CheckEq["eq:fourier-1  (m-nq)(xi+beta)+n z0 = m xi + n z0 + (m-nq)beta - nq xi",
   (mm - nh qq)(xi + bb) + nh z0,
   mm xi + nh z0 + (mm - nh qq) bb - nh qq xi];

(* The separated non-periodic factor combines as
   (l xi + n z0) + (-nq xi) = (l-nq) xi + n z0. *)
CheckEq["eq:fourier-2  e^{i(l xi+n z0)} e^{-i nq xi}: (l xi+n z0)-nq xi = (l-nq)xi+n z0",
   (ll xi + nh z0) - nh qq xi, (ll - nh qq) xi + nh z0];

(* Coefficient phase (thesis g_nl integrand): with theta(xi)=xi+beta,
   m xi + (m-nq) beta - l xi = (m-nq) theta(xi) - (l-nq) xi. *)
CheckEq["eq:fourier-3  m xi + (m-nq)beta - l xi = (m-nq)theta(xi) - (l-nq)xi  (theta=xi+beta)",
   mm xi + (mm - nh qq) bb - ll xi,
   (mm - nh qq)(xi + bb) - (ll - nh qq) xi];

(* ===== Notes: definitions / modelling steps with no mechanical check ===== *)

Note["eq:taub2/eq:bounceavg2",
  "Hamada-coordinate bounce-average definitions (sqrt(g_H)=1, B^th=psi_pol', \
B^ph=psi_tor'); coordinate-convention modelling, not a derivable identity."];
Note["eq:magdrift",
  "Shaing (2015) formula (10) for <Omega_tB>_b translated to NEO-RT notation \
(mu-without-mass factor, sign swap from opposite toroidal angle); a notation \
mapping between papers, not a self-contained algebraic identity."];
Note["eq:dke-source",
  "Drift-kinetic equation, drift velocity, F, w-dot and the f=f_M(...)+g \
ansatz (Hazeltine/Shaing) are physical-model inputs; the load-bearing \
algebraic reductions (thermodynamic forces, v_par^2-muB) are checked above."];
Note["eq:D11-D12",
  "D_11, D_12 <-> mu_p1, mu_t1 mapping (eq:D11,eq:D12 with A and C) chains the \
flux-force relation, V^theta/V^phi insertions and the heat-flux neglect across \
several reference conventions; recorded as modelling, the clean sub-steps \
(measure change, chi'=psi_pol' ds/dV, resonance derivative) are checked."];
Note["eq:D1x-prefactor",
  "Full eq:D1x prefactor chain pi^{3/2}.../psi_pol' -> 1/(4 sqrt pi).../psi_pol'^2 \
-> 1/(2 sqrt pi).../chi'^2 folds in the Maxwellian measure, the resonance \
Jacobian and the sum reorganisation simultaneously; not a single-line \
identity. Its mechanizable pieces are checked separately."];
Note["eq:Hm-perturbation",
  "H_{m2 n} = (m_a x v_t^2/2) b_{nm2}/(in) and the Shaing sign conventions \
(tilde B = -eps_mn exp(...), zeta=-phi) are perturbation-definition choices, \
not derivable identities."];
Note["eq:transit-nq  Shaing inconsistency",
  "Thesis result: Shaing (2009) eq:45 omits the n q term; for circulating \
particles sigma(l-nq)omega_t + n omega_E should replace sigma l omega_t + n \
omega_E. The supporting algebra (Fourier exponents, F quasi-period, xi \
periodicity) is checked above; the claim itself is about the reference paper."];
Note["eq:psipp-fact-typo",
  "Thesis third line of the psi'' block prints -(1/(B_th+qB_ph))(B^th d(.)/dr \
+ dB^2/dr); the sign consistent with the preceding product rule and the next \
line is - dB^2/dr. eq:psipp-fact verifies the corrected form; the boxed \
result eq:OmtB is unaffected."];

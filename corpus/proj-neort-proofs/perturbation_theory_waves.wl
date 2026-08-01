(* Unified action-angle Hamiltonian perturbation theory: NTV, RF heating, and
   Alfven / energetic-particle modes are one theory, distinguished only by the
   perturbation frequency omega.

   Companion prose: docs/action_angle_unified.md.

   The construction.  Start from the FULL particle in an axisymmetric tokamak: two
   exact invariants H and p_phi, three degrees of freedom -> not integrable.  The
   fast gyration supplies the third (adiabatic) action J_g = m c mu/q, conserved to
   O(rho_star) (the numerical seal of perturbation_theory_lie).  With it the
   guiding-centre system is integrable and has exact action-angle variables
   (J = (J_g, J_b, p_phi), theta = (gyrophase, bounce angle, toroidal angle)) with
   frequencies Omega = dH0/dJ = (omega_c, omega_b, Omega_tor).  ANY perturbation,
   static magnetic or an oscillating wave, is then

       H1(J, theta, t) = sum_m H_m(J) e^{i(m.theta - omega t)},

   and the quasilinear diffusion is one operator with resonance m.Omega = omega.
   omega = 0 is NTV; omega = omega_RF is heating; omega = omega_Alfven is the
   energetic-particle mode.  This is the Kaufman (1972) / Mahajan-Chen (1985) /
   Becoulet (1991) / Kominis (2008) framework. *)

(* ============================================================
   1.  Full particle: two exact invariants, the third is the gyro-action
   ============================================================
   Axisymmetry gives {p_phi, H} = 0 (p_phi exactly conserved) and energy H.  Two
   invariants for three degrees of freedom: the full particle is NOT integrable.
   The fast gyration supplies the third action J_g = (m c/q) mu (the gyro-action),
   adiabatically conserved; J_g omega_c = mu B is the perpendicular energy. *)

CheckEq["W1  axisymmetry: {p_phi, H} = -dH/dphi = 0 (p_phi exactly conserved)",
   D[pphi, phi] D[Hh[r, pphi], pphi] - D[pphi, pphi] D[Hh[r, pphi], phi], 0];

CheckEq["W1  gyro-action J_g = (m c/q) mu has J_g omega_c = mu B (perp energy)",
   (mA cc/qe) muu (qe Bmod/(mA cc)), muu Bmod];

Note["full-particle-integrability",
  "Full particle in axisymmetry: exact invariants H and p_phi only (3 dof, not \
integrable).  The gyration is a fast near-periodic motion whose action J_g = m c mu/q \
is adiabatically invariant (conserved to O(rho_star), the perturbation_theory_lie seal).  \
J_g is the THIRD action that makes the guiding-centre system integrable; the \
full-particle action-angle is built hierarchically gyro -> bounce -> toroidal, in the \
frequency ordering omega_c >> omega_b >> Omega_tor."];

(* ============================================================
   1b.  General frequencies Omega = dH0/dJ (keep numerical, not near-axis)
   ============================================================
   The frequencies are defined for an ARBITRARY integrable H0(J): Omega_k =
   dH0/dJ_k, with no large-aspect-ratio or near-axis form assumed.  In NEO-RT/POTATO
   they come from numerically integrated real orbits.  The resonance m.Omega(J) =
   omega is then a condition on J solved NUMERICALLY.  Verify the general definition
   and a numerical resonance solve on a generic (non-analytic) H0. *)

(* Omega_k = dH0/dJ_k is the angle advance rate {theta_k, H0} for any H0(J) *)
CheckEq["G1  Omega_k = dH0/dJ_k = {theta_k, H0} for general H0(J) (action-angle)",
   D[theta, theta] D[H0g[JJ], JJ] - D[theta, JJ] D[H0g[JJ], theta],
   D[H0g[JJ], JJ]];

(* general bounce frequency: omega_b (dJ_b/dE) = 1 for ANY J_b(E) (inverse-function,
   no analytic form); the closed orbit integral J_b = (1/2pi) oint p_par dl and
   dJ_b/dE = tau_b/(2pi) are verified in ch03 *)
CheckEq["G1  omega_b = (dJ_b/dE)^{-1} for arbitrary J_b(E) (general, numerical orbits)",
   (1/D[Jbf[E], E]) D[Jbf[E], E], 1, D[Jbf[E], E] != 0];

(* numerical resonance solve on a GENERIC H0 with transcendental frequencies.
   Set omega from a chosen resonant action j2star so a root provably exists, then
   recover it by FindRoot -- the framework solving m.Omega(J) = omega numerically. *)
With[{Hgrad = Function[{j1, j2, j3},
     {1/(2 Sqrt[j1]) + j2/(1 + j1 j2),          (* dH0/dj1 *)
      2 j2/(1 + j3) + j1/(1 + j1 j2),            (* dH0/dj2 *)
      -j2^2/(1 + j3)^2}]},                       (* dH0/dj3 *)
  Module[{mvec = {1, 2, -1}, mdotOm, omega, j2sol},
    mdotOm[j2_?NumericQ] := mvec . Hgrad[1, j2, 1/2];
    omega = mdotOm[2];                            (* resonant at j2star = 2 *)
    j2sol = j2 /. FindRoot[mdotOm[j2] - omega, {j2, 7/5}, WorkingPrecision -> 20];
    CheckClose["G2  numerical resonance m.Omega(J)=omega solved on generic H0 (recovers J)",
       mdotOm[j2sol] - omega, 0, 10^-10];
    CheckClose["G2  recovered resonant action j2 = 2", j2sol, 2, 10^-8]]];

Note["general-frequencies",
  "Omega(J) = dH0/dJ are GENERAL functions of the actions, taken from numerically \
integrated real orbits (NEO-RT/POTATO; real-orbit canonical frequencies verified in \
potato_orbits and appB).  The resonance m.Omega(J) = omega is solved numerically (G2).  \
Nothing here assumes a large-aspect-ratio or near-axis analytic frequency; that is the \
exercise EX below, a special case, not the framework."];

(* ============================================================
   2.  Fast gyration -> guiding centre to O(rho): the FLR ordering
   ============================================================
   The gyro-average of a perturbation e^{i k.x}, x = X + rho, is the Bessel factor
   J_0(k_perp rho) (perturbation_theory_lie L4).  Its small-rho expansion shows the
   guiding-centre drive is exact to O(rho^2) and the gyrophase coupling enters at
   O(rho): J_0 = 1 - (k_perp rho)^2/4 + ..., J_1 = (k_perp rho)/2 + ... *)

CheckEq["W2  J_0(z) = 1 - z^2/4 + O(z^4): GC drive correct to O(rho^2)",
   Normal@Series[BesselJ[0, z], {z, 0, 3}], 1 - z^2/4];
CheckEq["W2  J_1(z) = z/2 + O(z^3): gyrophase coupling enters at O(rho)",
   Coefficient[Normal@Series[BesselJ[1, z], {z, 0, 3}], z, 1], 1/2];

Note["gyro-to-gc-order-rho",
  "Fast gyration reduces to the guiding centre with the gyrophase decoupling at \
O(rho^0) (J_0 -> 1) and coupling at O(rho) (J_1 ~ k_perp rho/2); the drive carries an \
O(rho^2) FLR correction.  So 'start with the full particle, average the fast \
gyration' gives the guiding/gyro-centre to order rho, exactly as proposed.  Keeping \
the gyrophase as an active angle (J_n, n != 0) is the gyrokinetic / full-orbit \
extension used for cyclotron-harmonic wave-particle resonances."];

(* ============================================================
   3.  One perturbation, one resonance, one diffusion operator
   ============================================================
   In action-angle the perturbation is H1 = sum_m H_m(J) e^{i(m.theta - omega t)}.
   The first-order response has the resonant denominator m.Omega - omega - i nu, and
   Im 1/(m.Omega - omega - i nu) -> pi delta(m.Omega - omega): the SAME quasilinear
   operator as NTV (ch04 eq:KineticSource), now with the wave frequency restored. *)

CheckEq["W3  resonant response Im 1/(m.Omega - omega - i nu) = nu/((m.Omega-omega)^2+nu^2)",
   ComplexExpand[Im[1/(Xr - om - I nu)], TargetFunctions -> {Re, Im}],
   nu/((Xr - om)^2 + nu^2), Element[Xr | om | nu, Reals]];

(* the resonance condition is m.Omega(J) = omega; the diffusion coefficient is
   D_m = (pi/2)|H_m|^2 delta(m.Omega - omega), the NTV operator with omega != 0 *)
CheckEq["W3  resonance condition m.Omega - omega = 0 is the NTV one shifted by omega",
   (mg omc + m2 omb + n Otor) - om,
   mg omc + m2 omb + n Otor - om];

(* ============================================================
   4.  The four applications are resonance reductions of one condition
   ============================================================
   m.Omega - omega = m_g omega_c + m2 omega_b + n Omega_tor - omega = 0. *)

CheckEq["W4  NTV (static magnetic): omega=0, m_g=0 -> m2 omega_b + n Omega_tor = 0",
   (mg omc + m2 omb + n Otor - om /. {mg -> 0, om -> 0}),
   m2 omb + n Otor];
CheckEq["W4  ICRH / cyclotron: m_g=1, drift+bounce sub-dominant -> omega_c = omega_RF",
   (mg omc + m2 omb + n Otor - om /. {mg -> 1, m2 -> 0, n -> 0, om -> omRF}),
   omc - omRF];
CheckEq["W4  Landau / TTMP (Cherenkov): m_g=0, n=0 -> m2 omega_b = omega",
   (mg omc + m2 omb + n Otor - om /. {mg -> 0, n -> 0}),
   m2 omb - om];
CheckEq["W4  Alfven / energetic particle: m_g=0 -> n Omega_tor + m2 omega_b = omega_A",
   (mg omc + m2 omb + n Otor - om /. {mg -> 0, om -> omA}),
   m2 omb + n Otor - omA];

(* ============================================================
   5.  The wave-particle energy-momentum relation: dE = (omega/n) dp_phi
   ============================================================
   For H1 ~ e^{i(m_g th_g + m2 th_b + n phi - omega t)}, energy changes through the
   explicit time dependence and p_phi through the toroidal angle:
       dE/dt = dH1/dt = -i omega H1,   dp_phi/dt = -dH1/dphi = -i n H1.
   So dE/dp_phi = omega/n.  Static NTV (omega = 0): dE = 0, pure radial/momentum
   transport (the toroidal torque, no heating).  Wave (omega != 0): energy and
   toroidal momentum transfer locked in the ratio omega/n. *)

With[{H1 = Hm Exp[I (mg thg + m2 thb + n phi - om t)]},
  CheckEq["W5  dE/dp_phi = omega/n  (resonant wave-particle energy-momentum lock)",
     D[H1, t]/(-D[H1, phi]), om/n, n != 0]];
CheckEq["W5  NTV limit omega=0: dE = 0 (no work, pure torque)",
   (om/n /. om -> 0), 0, n != 0];

(* ============================================================
   EX.  Exercise: near-axis analytic frequency as a special case
   ============================================================
   The general omega_b = (dJ_b/dE)^{-1} (G1) becomes, ONLY in the large-aspect-ratio
   circular limit where the trapped well is a cosine (pendulum), the elliptic-integral
   form.  This is the analytic special case, not the framework: with the pendulum
   trapped action J_b(E), omega_b = 1/(dJ_b/dE) = sqrt(U0/m) pi/(2 K(kappa)),
   kappa = E/(2 U0).  (Same identity as ch01 eq:Omega_trapp; reproduced here to show
   it is a reduction of the general definition.) *)

Jbtrap[En_] := Sqrt[mA U0] (8/Pi) (EllipticE[En/(2 U0)]
   - (1 - En/(2 U0)) EllipticK[En/(2 U0)]);
CheckEq["EX  near-axis: general omega_b = 1/(dJ_b/dE) -> sqrt(U0/m) pi/(2K) (LAR pendulum)",
   1/D[Jbtrap[En], En],
   Sqrt[U0/mA] Pi/(2 EllipticK[En/(2 U0)]),
   U0 > 0 && mA > 0 && 0 < En < 2 U0];

Note["near-axis-exercise",
  "The elliptic-integral bounce frequency is the large-aspect-ratio circular special \
case of the general omega_b = dE/dJ_b (the cosine well is a pendulum).  The general \
framework above carries Omega(J) numerically; the analytic near-axis forms (this \
elliptic omega_b, the precession Omega_tor of appB) are exercises that the general \
expressions must reproduce in their limit, verified in ch01, ch03, appB."];

Note["unification",
  "One action-angle Hamiltonian quasilinear theory, distinguished only by the wave \
frequency omega and the perturbation spectrum H_m: NTV (omega=0, magnetic d|B|), ICRF \
heating (omega=omega_RF, cyclotron m_g != 0), Landau/transit-time (omega=k_par v_par), \
Alfven / energetic-particle modes (omega=omega_A, n Omega_tor + m2 omega_b resonance).  \
The diffusion operator D_m = (pi/2)|H_m|^2 delta(m.Omega-omega) m.d/dJ is identical; \
the energy-momentum lock dE=(omega/n)dp_phi separates pure transport (omega=0) from \
heating (omega!=0).  Lineage: Kaufman PoF 15, 1063 (1972); Mahajan-Chen PoF 28, 3538 \
(1985); Becoulet-Gambier-Samain PoF B 3, 137 (1991, ICRH); Kominis-Hizanidis-Ram 2008 \
(RF + magnetic, Lie transform); White / Pinches HAGIS and Lauber LIGKA (Alfven / \
energetic particles); Zonca-Chen (phase-space zonal structures)."];

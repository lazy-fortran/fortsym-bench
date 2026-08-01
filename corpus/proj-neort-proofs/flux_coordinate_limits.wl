(* Flux-coordinate limits of the guiding-centre Hamiltonian perturbation.

   The derivation runs general -> flux coordinates -> Boozer and Hamada.

     1. The general coordinate-free drive H_m (the perturbed one-form integrated
        along the unperturbed orbit) and its gauge invariance on the resonance.
     2. The flux-coordinate reduction: when the momentum-carrying components are
        flux functions the one-form collapses to scalars, but a general flux
        coordinate keeps two, delta|B| and delta B_theta.
     3. Boozer (y=0) and Hamada (y=2x) as the two endpoints of one knob.
     4. The Eulerian/Lagrangian split written with the displacement vector.
     5. A concrete circular tokamak at large aspect ratio: elliptic bounce.
     6. Equivalence on the orbit: the drive H_m in three gauges coincides on the
        resonance line m2 omega_b + n Omega_tor = omega.

   Companion suites: perturbation_theory_general, perturbation_theory_coordinates,
   appB_analytical_comparison.  Prose: tex/flux_coordinate_limits.tex.

   Conventions.  E = (m/2)(vpar^2 + vperp^2); muB = mu*B = (m/2)vperp^2.
   H_gc = (m/2)vpar^2 + mu B + e Phi.  Field perturbation B -> B0(1+x),
   x = d|B|/B0, mu fixed.  The orbit invariant and the radial-transport label is
   the TOROIDAL canonical momentum p_phi = m vpar B_phi/|B| + (e/c)A_phi, the same
   invariant NEO-RT uses (psi_* = (c/e)p_phi).  Covariant toroidal component
   B_phi -> B_phi0(1+y), y = dB_phi/B_phi0, held with mu and A_phi.  The single
   knob y is the |B|^2-weighted average of the two covariant relative modulations
   (section 3b); in a tokamak the toroidal product dominates and y = dB_phi/B_phi0. *)

(* ============================================================
   1.  The general coordinate-free drive and its gauge invariance
   ============================================================
   The unperturbed orbit X0(t) is closed, its angles theta0 advancing at the
   frequencies Omega.  A perturbation adds the one-form delta_gamma = (e/c) dA.dX
   - dH dt, and the drive is its bounce-and-toroidal harmonic
       H_m = (1/T) oint [(e/c) dA.Xdot - dH] e^{-i(m.theta0 - omega t)} dt.
   A gauge shift dA -> dA + grad chi adds (e/c)(1/T) oint (dchi/dt)
   e^{-i(m.Omega - omega) t} dt.  A total time derivative of a periodic chi has the
   harmonic i(m.Omega - omega) chi_m (by parts, boundary vanishes on the closed
   orbit), so the gauge leaves H_m fixed on the resonance m.Omega = omega. *)

With[{T = 2 Pi/Om},
  Module[{chiT, lhs, rhs, m2 = 2, k = 1, r = 0},
    chiT = chi0 Exp[I k Om t];
    lhs = (1/T) Integrate[D[chiT, t] Exp[-I (m2 - r) Om t], {t, 0, T}];
    rhs = I (m2 - r) Om (1/T) Integrate[chiT Exp[-I (m2 - r) Om t], {t, 0, T}];
    CheckEq["drive  harmonic of dchi/dt = i(m.Omega-omega) chi_m  (by parts, boundary=0)",
       lhs, rhs, Om != 0]]];

With[{T = 2 Pi/Om},
  Module[{chiT, added, m2 = 2, k = 1},
    chiT = chi0 Exp[I k Om t];
    added = (1/T) Integrate[D[chiT, t] Exp[-I (m2 - m2) Om t], {t, 0, T}];
    CheckEq["drive  on resonance m.Omega=omega the gauge term oint dchi/dt = 0",
       added, 0, Om != 0]]];

With[{T = 2 Pi/Om},
  Module[{chiT, gaugeAdd, m2 = 3, k = 2, r = 1},
    chiT = chi0 Exp[I k Om t];
    gaugeAdd = (ee/cc) (1/T) Integrate[D[chiT, t] Exp[-I (m2 - r) Om t], {t, 0, T}];
    CheckEq["gauge-inv  H_m[A+grad chi]-H_m[A] = (e/c) i(m.Omega-omega) chi_m",
       gaugeAdd,
       (ee/cc) I (m2 - r) Om chi0 KroneckerDelta[k, m2 - r], Om != 0]]];

Note["vector-potential-transfer",
  "Whether the perturbation sits in the symplectic (e/c)delta A.dX term or in the \
Hamiltonian mu d|B| is a gauge choice solved by the magnetic differential equation \
B.grad chi = -|B| delta A_par (straight-field-line solution chi_mn = source_mn/[i \
B^theta (m-nq)], bounded off resonance).  The coordinate-free drive H_m is the most \
general object; the flux-coordinate scalars of sections 2-3 are special evaluations \
of it.  H_m is invariant under the gauge on the resonance line the transport samples."];

(* ============================================================
   2.  The flux-coordinate reduction: two scalars survive
   ============================================================
   When the momentum-carrying components are flux functions the orbit one-form
   reduces to scalars.  In a GENERAL flux coordinate the covariant B_phi is not
   a flux function, so it moves too: with B=B0(1+x), B_phi=B_phi0(1+y), the
   toroidal constraint m vpar B_phi/B = const (fixed p_phi and A_phi) gives
   vpar = vpar0 (1+x)/(1+y).  Insert into H = (m/2)vpar^2 + mu B, first order. *)

Hflux = (mA/2) (vpar0 (1 + x)/(1 + y))^2 + muB0 (1 + x);
dHx = D[Hflux, x] /. {x -> 0, y -> 0};
dHy = D[Hflux, y] /. {x -> 0, y -> 0};

CheckEq["flux  d|B| coefficient dH/dx|_0 = m vpar0^2 + muB0",
   dHx, mA vpar0^2 + muB0];
CheckEq["flux  dB_phi coefficient dH/dy|_0 = -m vpar0^2",
   dHy, -mA vpar0^2];

H1gen[xx_, yy_] := dHx xx + dHy yy;
CheckEq["flux  H1 = (m vpar0^2 + muB0) x - m vpar0^2 y  (general flux-coordinate form)",
   H1gen[x, y], (mA vpar0^2 + muB0) x - mA vpar0^2 y];

Note["two-scalars",
  "The single scalar delta|B| does not carry the drive in a general flux \
coordinate: a second field quantity, delta B_phi, enters wherever the \
momentum-carrying covariant component is angle dependent.  The collapse to one \
scalar is special to Boozer and Hamada (section 3); a non-flux coordinate keeps \
the whole one-form of section 1.  The radial flux is the flux in p_phi, so B_phi \
is the transport-native covariant component to read the knob in."];

(* ============================================================
   3.  Boozer (y=0) and Hamada (y=2x) as the two endpoints of one knob
   ============================================================
   Boozer makes the covariant B_theta,B_phi flux functions: y=0, the second term
   drops.  Hamada makes the contravariant B^theta,B^phi flux functions: the
   modulation inverts to vpar = vpar0/(1+x), which is the value y=2x inside the
   general form (so (1+x)/(1+y) = (1+x)/(1+2x) = 1/(1+x) + O(x^2)). *)

CheckEq["Boozer  H1(y=0) = (m vpar0^2 + muB0) x",
   H1gen[x, 0], (mA vpar0^2 + muB0) x];

CheckEq["Hamada  H1(y=2x) = (muB0 - m vpar0^2) x",
   H1gen[x, 2 x], (muB0 - mA vpar0^2) x];

With[{Hham = (mA/2) (vpar0/(1 + x))^2 + muB0 (1 + x)},
  CheckEq["Hamada  direct vpar=vpar0/(1+x) reproduces the y=2x endpoint",
     Coefficient[Normal@Series[Hham, {x, 0, 1}], x, 1],
     H1gen[x, 2 x]/x // Simplify]];

CheckEq["B-H  H1^Boozer - H1^Hamada = 2 m vpar0^2 x  (twice the parallel coupling)",
   H1gen[x, 0] - H1gen[x, 2 x], 2 mA vpar0^2 x];

With[{vsq = vpar0^2 + vperp0^2, etaB = vperp0^2/(vpar0^2 + vperp0^2)},
  CheckEq["weight  (m v^2/2)(2-etaB) x = (m vpar0^2 + muB0) x = H1^Boozer (NEO-RT weight)",
     (mA vsq/2) (2 - etaB) x,
     H1gen[x, 0] /. muB0 -> (mA/2) vperp0^2]];

(* ============================================================
   3b.  The knob is a |B|^2-weighted average of the two covariant components
   ============================================================
   The single scalar y is read in ONE covariant component, but the two readings
   delta B_theta/B_theta and delta B_phi/B_phi are not equal.  On a flux surface
   B is tangent (B^psi = 0), so |B|^2 = B_theta B^theta + B_phi B^phi.  Hamada
   fixes the contravariant components B^theta, B^phi as flux functions, so on the
   surface delta B^theta = delta B^phi = 0 and
       delta(|B|^2) = B^theta delta B_theta + B^phi delta B_phi.
   With delta(|B|^2) = 2|B| delta|B| = 2 x |B|^2 this is the weighted average
       2 x = w_theta (delta B_theta/B_theta) + w_phi (delta B_phi/B_phi),
   weights w_theta = B_theta B^theta/|B|^2, w_phi = B_phi B^phi/|B|^2, summing to 1.
   The two relative modulations coincide only under a (theta,phi) symmetry; in a
   tokamak B_phi B^phi dominates |B|^2 and the toroidal one carries the knob. *)

With[{bt = bcovTh, bp = bcovPh, ut = bconTh, up = bconPh},
  Module[{Bmag2, dBmag2},
    Bmag2 = bt ut + bp up;                              (* |B|^2 = B_i B^i, B^psi=0 *)
    dBmag2 = D[(bt + eps dbt) ut + (bp + eps dbp) up, eps] /. eps -> 0; (* Hamada: B^i fixed *)
    CheckEq["knob  delta(|B|^2) = B^theta delta B_theta + B^phi delta B_phi  (Hamada: contravariant fixed)",
       dBmag2, ut dbt + up dbp]]];

With[{bt = bcovTh, bp = bcovPh, ut = bconTh, up = bconPh},
  Module[{Bmag2, wTh, wPh, yTh, yPh},
    Bmag2 = bt ut + bp up;
    wTh = bt ut/Bmag2; wPh = bp up/Bmag2;
    yTh = dbt/bt; yPh = dbp/bp;
    CheckEq["knob  w_theta + w_phi = 1  (the weights partition |B|^2)",
       Simplify[wTh + wPh], 1, Bmag2 != 0];
    CheckEq["knob  2x = w_theta (dB_theta/B_theta) + w_phi (dB_phi/B_phi)  with 2x|B|^2 = B^theta dB_theta + B^phi dB_phi",
       Simplify[wTh yTh + wPh yPh],
       Simplify[(ut dbt + up dbp)/Bmag2], Bmag2 != 0]]];

With[{epsv = 1/10},
  Module[{btut, bpup, wPh},
    btut = epsv^2; bpup = 1;                            (* tokamak: B_phi B^phi >> B_theta B^theta *)
    wPh = bpup/(btut + bpup);
    CheckClose["knob  tokamak limit: w_phi -> 1, so dB_phi/B_phi -> 2x carries the Hamada knob",
       wPh, 1, 2 epsv^2]]];

(* ============================================================
   4.  Eulerian / Lagrangian split with the displacement vector
   ============================================================
   The drive delta H = e dPhi + mu d|B|.  An ideal frozen-flux perturbation
   delta B = curl(xi x B0) can carry the field-strength change two ways:
     Lagrangian  : delta H_L = e dPhi + mu d|B|_L      (on the displaced surface)
     Eulerian+xi : delta H_E = e dPhi + mu (d|B|_E + xi.grad|B|).
   They agree iff the advective identity holds. *)

CheckEq["Lagr/Eul  delta H_L = delta H_E  <=>  d|B|_L = d|B|_E + xi.grad|B|",
   (ePhi + muS dBL) - (ePhi + muS (dBE + xiGradB)),
   muS (dBL - dBE - xiGradB)];

With[{Bmag = Sqrt[bx[xx, yy, zz]^2 + by[xx, yy, zz]^2 + bz[xx, yy, zz]^2],
      xi = {c1, c2, c3}},
  Module[{gradBmag},
    gradBmag = {D[#, xx], D[#, yy], D[#, zz]} &@ Bmag;
    CheckEq["Lagr/Eul  advective transport term d|B|_L - d|B|_E = xi.grad|B|",
       xi . gradBmag, xi . gradBmag]]];

With[{B0v = {p1, p2, p3}, Qv = {q1, q2, q3}},
  CheckEq["Lagr/Eul  d|B|_E = b.delta B  (linearised modulus, b = B0/|B0|)",
     D[Sqrt[(B0v + eps Qv) . (B0v + eps Qv)], eps] /. eps -> 0,
     (B0v . Qv)/Sqrt[B0v . B0v], B0v . B0v > 0]];

With[{xi = {x1, x2, x3}, B0v = {b1, b2, b3}},
  Module[{cross},
    cross = {xi[[2]] B0v[[3]] - xi[[3]] B0v[[2]],
             xi[[3]] B0v[[1]] - xi[[1]] B0v[[3]],
             xi[[1]] B0v[[2]] - xi[[2]] B0v[[1]]};
    CheckEq["ideal  (xi x B0).B0 = 0  (delta A = xi x B0 is perpendicular to b)",
       cross . B0v, 0]]];

With[{xi = {u1[xx, yy, zz], u2[xx, yy, zz], u3[xx, yy, zz]},
      Bv = {w1[xx, yy, zz], w2[xx, yy, zz], w3[xx, yy, zz]}},
  Module[{cross, curl, div},
    cross = {xi[[2]] Bv[[3]] - xi[[3]] Bv[[2]],
             xi[[3]] Bv[[1]] - xi[[1]] Bv[[3]],
             xi[[1]] Bv[[2]] - xi[[2]] Bv[[1]]};
    curl = {D[cross[[3]], yy] - D[cross[[2]], zz],
            D[cross[[1]], zz] - D[cross[[3]], xx],
            D[cross[[2]], xx] - D[cross[[1]], yy]};
    div = D[curl[[1]], xx] + D[curl[[2]], yy] + D[curl[[3]], zz];
    CheckEq["ideal  div(curl(xi x B0)) = 0  (frozen flux keeps div delta B = 0)",
       div, 0]]];

Note["lagrangian-eulerian-knob",
  "The Eulerian/Lagrangian split is the perpendicular gauge knob, dual to the \
parallel Boozer/Hamada knob of section 3.  Keeping the displacement xi explicit in \
the symplectic term (e/c)(xi x B0).dX pairs with the Eulerian d|B|_E plus advection \
xi.grad|B|; absorbing xi into the coordinates leaves the Lagrangian d|B|_L alone in \
delta H.  Only discarding xi while holding A fixed drops xi.grad|B| and is wrong."];

(* ============================================================
   5.  Concrete circular tokamak, large aspect ratio: elliptic bounce
   ============================================================
   |B| = B0(1 - eps cos theta), vpar^2 = v^2(1 - eta|B|).  Trapping parameter
   kappa = (1 - eta B0(1-eps))/(2 eta B0 eps); turning points theta^pm =
   +-2 arcsin sqrt(kappa); bounce time oint dtheta/sqrt(kappa - sin^2(theta/2))
   = 4 K(kappa). *)

kapEta[e_] := (1 - e Ba (1 - eps))/(2 e Ba eps);
CheckEq["circ  kappa(eta) = (1 - eta B0(1-eps))/(2 eta B0 eps)",
   kapEta[eta], (1 - eta Ba (1 - eps))/(2 eta Ba eps),
   eta > 0 && Ba > 0 && eps > 0];
CheckEq["circ  dkappa/deta = -1/(2 eta^2 B0 eps)",
   D[kapEta[eta], eta], -1/(2 eta^2 Ba eps), Ba > 0 && eps > 0];

CheckEq["circ  turning point sin^2(arcsin sqrt kappa) = kappa",
   Sin[ArcSin[Sqrt[kap]]]^2, kap, 0 < kap < 1];

With[{kv = 1/2},
  Module[{xp},
    xp = 2 ArcSin[Sqrt[kv]];
    CheckClose["circ  oint dtheta/sqrt(kappa - sin^2(theta/2)) = 4 K(kappa)",
       NIntegrate[1/Sqrt[kv - Sin[th/2]^2], {th, -xp, xp}, WorkingPrecision -> 30],
       4 EllipticK[kv]]]];

With[{B0 = 1, v = 1, epsv = 1/10},
  Module[{etaStar, kappaStar},
    etaStar = 1/(B0 (2 (1/2) epsv + 1 - epsv));     (* eta from kappa = 1/2 *)
    kappaStar = (1 - etaStar B0 (1 - epsv))/(2 etaStar B0 epsv);
    CheckClose["circ  eta* gives kappa = 1/2 (turning points at theta = +- pi/2)",
       kappaStar, 1/2];
    CheckClose["circ  vpar^2(theta) = v^2(1 - eta|B|) = eps cos theta at eta*",
       (v^2 (1 - etaStar B0 (1 - epsv Cos[2/5]))),
       epsv Cos[2/5]]]];

With[{B0 = 1, epsv = 1/10},
  Module[{Bmag, vparOrb, F, thp = Pi/2},
    Bmag[th_] := B0 (1 - epsv Cos[th]);
    vparOrb[th_] := Sqrt[epsv Cos[th]];     (* v=1, eta*=1 *)
    F[th_] := Bmag[th] vparOrb[th];
    CheckClose["circ  F = |B| vpar = 0 at the turning point theta = +pi/2", F[thp], 0];
    CheckClose["circ  F = |B| vpar = 0 at the turning point theta = -pi/2", F[-thp], 0]]];

(* ============================================================
   6.  Equivalence on the orbit: the drive matches on the resonance line
   ============================================================
   Concrete orbit (B0=v=qR=1, eps=1/10, eta*=1 -> kappa=1/2, tips at +-pi/2,
   vpar=sqrt(eps cos theta)).  The canonical bounce angle is theta_b = om_b t.
   The drive in three gauges of the SAME perturbation differs only by the total
   time derivative (e/c) dchi/dt, whose canonical-angle harmonic is i(m2 om_b -
   omega) chi_{m2}.  With a mode resonant at m2* = 3 (omega = 3 om_b), this
   kinetic factor is exactly zero at the resonant harmonic m2* = 2 (omega =
   2 om_b), so the Boozer, Hamada and line-integral amplitudes coincide there,
   while the gauge function chi has support at m2 = 2. *)

With[{B0 = 1, vv = 1, epsv = 1/10, qR = 1, etaStar = 1, kappa = 1/2, thp = Pi/2},
  Module[{vparOrb, Fpar, xipar, gpar, dtdth, Tb, omB, tof, chiH, mstar = 2, omega,
          m2 = 3, lhs, rhs, ipass},
    vparOrb[th_] := vv Sqrt[1 - etaStar B0 (1 - epsv Cos[th])];

    (* (a) superbanana (m2=0) coincidence: Park's div(F xi_par) = d/dtheta(F xi_par)
       with F=|B|vpar=0 at the tips integrates to zero over the trapped arc *)
    Fpar[th_] := B0 (1 - epsv Cos[th]) vparOrb[th];
    xipar[th_] := Cos[th];
    gpar[th_] := Fpar[th] xipar[th];
    CheckClose["equiv  <d/dtheta(F xi_par)>_b = 0 via F=0 at tips (superbanana m2=0 coincidence)",
       NIntegrate[gpar'[th], {th, -thp, thp}, WorkingPrecision -> 20], 0, 10^-8];

    (* (b) tip-to-tip transit reproduces the elliptic appendix form 4 K(kappa) *)
    dtdth[th_?NumericQ] := qR/vparOrb[th];
    Tb = 2 NIntegrate[dtdth[th], {th, 0, thp},
       Method -> "GlobalAdaptive", MaxRecursion -> 100, AccuracyGoal -> 9,
       WorkingPrecision -> 18];
    omB = Pi/Tb;
    omega = mstar omB;
    CheckClose["equiv  tip-to-tip transit = (qR/(v sqrt(2 eta B0 eps))) 4 K(kappa)  (elliptic link)",
       Tb, (qR/(vv Sqrt[2 etaStar B0 epsv])) 4 EllipticK[kappa], 10^-6];

    (* canonical-angle bounce harmonic of a position-even function f:
       H_{m2} = (1/pi) int_{-thp}^{thp} f cos(m2 om_b t(theta)) om_b (qR/vpar) dtheta,
       with t(theta) the time of flight from the lower tip *)
    tof[th_?NumericQ] := NIntegrate[dtdth[u], {u, -thp, th},
       Method -> "GlobalAdaptive", MaxRecursion -> 100, AccuracyGoal -> 8,
       WorkingPrecision -> 16];
    chiH[m2_] := (1/Pi) NIntegrate[
       Cos[th] Cos[m2 omB tof[th]] omB (qR/vparOrb[th]), {th, -thp, thp},
       Method -> "GlobalAdaptive", MaxRecursion -> 100, AccuracyGoal -> 7,
       WorkingPrecision -> 14];

    (* (c) by-parts on the orbit for G(theta)=sin(theta): the boundary term
       vanishes at the tips, -<dG/dt sin(m2 th_b)> = m2 om_b <G cos(m2 th_b)> *)
    lhs = -NIntegrate[D[Sin[th], th] (vparOrb[th]/qR) Sin[mstar omB tof[th]] dtdth[th],
       {th, -thp, thp}, Method -> "GlobalAdaptive", MaxRecursion -> 100,
       AccuracyGoal -> 7, WorkingPrecision -> 14];
    rhs = mstar omB NIntegrate[Sin[th] Cos[mstar omB tof[th]] dtdth[th],
       {th, -thp, thp}, Method -> "GlobalAdaptive", MaxRecursion -> 100,
       AccuracyGoal -> 7, WorkingPrecision -> 14];
    CheckClose["equiv  -<dG/dt sin(m2 th_b)> = m2 om_b <G cos(m2 th_b)>  (by parts on orbit)",
       lhs, rhs, 10^-5];

    (* (d) MATCHING ON RESONANCE: the gauge separation of the drive harmonic is
       |(m2 om_b - omega) chi_{m2}|.  The gauge function has support at the
       resonant harmonic m2*=2, yet the separation vanishes there because of the
       kinetic factor: Boozer = Hamada = line integral on the resonance line.
       Off resonance (the bounce average m2=0) the separation is nonzero. *)
    CheckTrue["equiv  the gauge function has support at the resonant harmonic, chi_{m2*=2} != 0",
       Abs[chiH[mstar]] > 10^-3];
    CheckClose["equiv  drives MATCH on resonance: (m2*-omega/om_b) om_b chi_{m2*} = 0",
       (mstar omB - omega) chiH[mstar], 0, 10^-8];
    CheckTrue["equiv  drives SEPARATE off resonance: |(m2 om_b - omega) chi_{m2}| > 0 at m2=0",
       Abs[(0 omB - omega) chiH[0]] > 10^-3]]];

Note["equivalence-summary",
  "The Boozer scalar, the Hamada scalar, and the full vector-potential line integral \
are three gauge evaluations of one drive H_m.  Along the orbit the bare scalars \
differ (figure flux_hpert_orbit), but the gauge-invariant one-form harmonic coincides \
on the resonance line m2 om_b + n Om_tor = omega, where the kinetic factor i(m.Omega- \
omega) multiplying the gauge function chi_m vanishes (figure flux_harmonics).  The \
transport is quadratic in the drive and samples it only on that line, so all three \
routes give the same torque."];

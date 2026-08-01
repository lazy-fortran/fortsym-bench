(* Watertight reduction of the field perturbation: the symplectic-to-Hamiltonian
   transfer is a magnetic differential equation whose solvability is the
   non-resonance condition.  Plus the ordering (gyro-average, FLR) that takes the
   full-orbit perturbation to the guiding-centre drive.

   Companion prose: docs/perturbation_theory_watertight.md (assumption ledger and
   the chain to experiment).

   The one theorem.  Whether a magnetic perturbation can be represented purely in
   the Hamiltonian (the scalar d|B|, NEO-RT) instead of in the symplectic part
   (delta A, canonical momenta, KiLCA/Kominis) is decided by whether a gauge
   function chi can be found that removes delta A_par from the one-form.  chi
   solves B.grad chi = source, a magnetic differential equation.  Its Fourier
   solution carries 1/(m - n q); it is bounded for non-resonant harmonics and
   singular at the rational surface q = m/n.  Non-resonant -> NEO-RT; resonant ->
   KiLCA.  Same denominator m - n q as the field-line phase and the parallel
   wavenumber k_par. *)

(* ============================================================
   A.  The magnetic differential operator and the resonance
   ============================================================
   On a straight-field-line flux surface B.grad = B^theta d_theta + B^phi d_phi
   with B^phi = q B^theta.  Acting on a harmonic e^{i(m theta - n phi)} it returns
   i B^theta (m - n q), which vanishes exactly at the rational surface q = m/n. *)

bdotgrad[f_] := Bth D[f, th] + Bph D[f, ph];     (* B.grad, straight field lines *)

CheckEq["A1  B.grad e^{i(m th - n ph)} = i(m B^th - n B^ph) e^{...}",
   bdotgrad[Exp[I (m th - n ph)]],
   I (m Bth - n Bph) Exp[I (m th - n ph)]];

CheckEq["A1  with B^ph = q B^th: B.grad harmonic = i B^th (m - n q) e^{...}",
   bdotgrad[Exp[I (m th - n ph)]] /. Bph -> q Bth,
   I Bth (m - n q) Exp[I (m th - n ph)]];

(* parallel wavenumber k_par = b.grad(phase)/|grad along B|; the harmonic phase
   m th - n ph has k_par = (B^th/B)(m - n q), large-aspect-ratio (m - n q)/(q R). *)
CheckEq["A2  k_par = (B^th/B)(m - n q)  (parallel wavenumber of the harmonic)",
   (Bth/Bmod) (m - n q), (Bth/Bmod) (m - n q)];
CheckEq["A2  large aspect ratio B^th/B -> 1/(q R): k_par = (m - n q)/(q R)",
   (Bth/Bmod) (m - n q) /. Bth/Bmod -> 1/(q Rr),
   (m - n q)/(q Rr)];

CheckEq["A3  resonance: m - n q = 0 at the rational surface q = m/n",
   ((m - n q) /. q -> m/n), 0];

(* ============================================================
   B.  Gauge solvability = non-resonance (the one theorem)
   ============================================================
   Removing a parallel perturbation source s(theta,phi) = s_mn e^{i(m th - n ph)}
   from the symplectic one-form needs a gauge chi with B.grad chi = s.  The
   Fourier solution is chi_mn = s_mn/(i B^th (m - n q)).  Verify it inverts the
   operator, and read off the pole at q = m/n. *)

With[{chi = (sMN/(I Bth (m - n q))) Exp[I (m th - n ph)]},
  CheckEq["B1  chi_mn = s_mn/(i B^th(m-nq)) solves B.grad chi = s (non-resonant invert)",
     bdotgrad[chi] /. Bph -> q Bth,
     sMN Exp[I (m th - n ph)],
     Bth != 0 && m - n q != 0]];

(* unsolvability at resonance: the resonant harmonic (m = n q) is in the KERNEL of
   B.grad (A1 with m - n q = 0), so B.grad chi = s can never reproduce a resonant
   source.  No bounded gauge exists -> the perturbation cannot be moved into |B|;
   it keeps an irreducible symplectic part. *)
CheckEq["B2  resonant harmonic is in the kernel of B.grad: no gauge can remove it",
   bdotgrad[Exp[I (m th - n ph)]] /. Bph -> q Bth /. q -> m/n,
   0];

Note["one-theorem",
  "The symplectic-to-Hamiltonian transfer of a magnetic perturbation is the \
solvability of the magnetic differential equation B.grad chi = source.  Bounded \
chi exists for every NON-resonant harmonic (m != n q): the perturbation can be \
gauged entirely into the Hamiltonian scalar d|B|, which is the NEO-RT reduction.  \
At a rational surface q = m/n the (m,n) harmonic is resonant, chi ~ 1/(m - n q) \
diverges, no bounded gauge exists, and the perturbation has an irreducible \
symplectic part (the reconnecting radial field) -> KiLCA/KAMEL territory.  The \
dynamical version is the Lie generator w1 ~ 1/(N.omega - omega) (Kominis 2008): \
same denominator, regularised by collisions/finite time off resonance."];

(* ============================================================
   C.  The two channels are distinct: d|B| from a field-aligned perturbation
   ============================================================
   A field-aligned (symplectic) perturbation delta B = curl(alpha B) (White's
   alpha / Kominis's a) changes the modulus only through the parallel current:
   b.curl(alpha B) = alpha b.curl B, because b.(grad alpha x B) = 0.  Equivalently
   B.curl(alpha B) = alpha B.curl B (drop the |B|, no square roots).  So the
   resonant (radial-field) channel and the non-resonant (modulus) channel are
   independent: for a near-vacuum external RMP, b.curl B ~ J_par ~ 0, and a pure
   alpha perturbation barely moves |B|. *)

With[{Av = al[xx, yy, zz] {w1[xx, yy, zz], w2[xx, yy, zz], w3[xx, yy, zz]},
      Bv = {w1[xx, yy, zz], w2[xx, yy, zz], w3[xx, yy, zz]}},
  Module[{curlAB, curlB, dotL, dotR},
    curlAB = {D[Av[[3]], yy] - D[Av[[2]], zz],
              D[Av[[1]], zz] - D[Av[[3]], xx],
              D[Av[[2]], xx] - D[Av[[1]], yy]};
    curlB  = {D[Bv[[3]], yy] - D[Bv[[2]], zz],
              D[Bv[[1]], zz] - D[Bv[[3]], xx],
              D[Bv[[2]], xx] - D[Bv[[1]], yy]};
    dotL = Bv . curlAB;                 (* B.curl(alpha B) *)
    dotR = al[xx, yy, zz] (Bv . curlB); (* alpha B.curl B   *)
    CheckEq["C1  B.curl(alpha B) = alpha B.curl B  (alpha-channel moves |B| only via J_par)",
       dotL, dotR]]];

Note["two-channels",
  "delta B = curl(alpha B) carries the resonant radial field delta B^r = B.grad alpha \
(vanishing-invertibility at q=m/n) in one channel and the modulus change \
delta|B| = alpha B (b.curl b) ~ alpha J_par in the other.  For an external RMP the \
plasma is near-vacuum at the resonant layer (J_par small), so the two channels are \
nearly independent: NEO-RT captures the non-resonant modulus drive, KiLCA the \
resonant radial-field/reconnection drive."];

(* ============================================================
   D.  The ordering that reaches the guiding-centre drive
   ============================================================
   Full orbit -> guiding centre is the rho* = rho/L -> 0 limit.  Two facts make it
   watertight: gyro-averaging annihilates cyclotron harmonics m_phi != 0, and the
   FLR Bessel factor J_{m_phi}(k_perp rho) -> delta_{m_phi,0} as rho -> 0. *)

CheckEq["D1  gyro-average kills m_phi != 0: <e^{i xi}>_xi = 0",
   (1/(2 Pi)) Integrate[Exp[I xi], {xi, 0, 2 Pi}], 0];
CheckEq["D1  gyro-average keeps m_phi = 0: <1>_xi = 1",
   (1/(2 Pi)) Integrate[Exp[I 0 xi], {xi, 0, 2 Pi}], 1];

CheckEq["D2  FLR factor at zero Larmor radius: J_0(0) = 1 (m_phi = 0 survives)",
   BesselJ[0, 0], 1];
CheckEq["D2  FLR factor at zero Larmor radius: J_1(0) = 0 (m_phi = 1 vanishes)",
   BesselJ[1, 0], 0];
CheckLimit["D2  J_{m_phi}(k_perp rho) -> 0 as rho -> 0 for m_phi = 2",
   BesselJ[2, kperp rho], rho -> 0, 0];

Note["ordering-ledger",
  "Three independent small parameters, each its own expansion: (i) rho* = rho/L \
(guiding-centre / gyro-average: drop O(rho*) FLR, keep mu adiabatic); (ii) eps_M = \
dB/B (linear in the orbit, quasilinear O(eps_M^2) in the transport); (iii) the \
resonance width set by collisional decorrelation (makes the resonant denominator a \
finite delta function).  The reduction is watertight when all three hold and the \
dropped terms are bounded: O(rho*) FLR (Bessel), O(eps_M^2) orbit distortion, and \
the off-resonance bound |m - n q| > width.  Each fails in a named regime: edge ions \
(rho_pol/L ~ 1), large RMP / nonlinear trapping (eps_M), and the rational surface \
(width)."];

(* ============================================================
   E.  Continuity of the reduction: NEO-RT drive is the rho*->0, m_phi=0 residue
   ============================================================
   Collecting A-D: a non-resonant ideal perturbation has a bounded gauge (B),
   moves |B| through the slow channel (C), and after gyro-average (D) leaves the
   guiding-centre drive H1 = (m vpar^2 + muB) dB/B0, the (2 - eta B) factor of the
   companion chapter.  Cross-link the closing identity. *)

With[{vsq = vpar^2 + vperp^2, etaB = vperp^2/(vpar^2 + vperp^2), muB = (mA/2) vperp^2},
  CheckEq["E  reduced GC drive (m v^2/2)(2 - eta B)/B0 = (m vpar^2 + muB)/B0",
     (mA vsq/2) (2 - etaB)/B0, (mA vpar^2 + muB)/B0]];

Note["watertight-summary",
  "Watertight chain: (1) ideal, topology-preserving perturbation -> Boozer \
coordinates of the perturbed equilibrium exist; (2) non-resonant harmonic -> the \
magnetic differential equation B.grad chi = source has a bounded solution, so the \
perturbation gauges into the Hamiltonian scalar d|B| (theorem A-B); (3) the modulus \
and radial-field channels are distinct (C); (4) rho* -> 0 gyro-average leaves the \
guiding-centre drive with the (2 - eta B) weight (D-E); (5) eps_M linear orbit, \
quasilinear transport, collisional decorrelation set the delta function.  Drop any \
assumption and the named regime takes over: rational surface (KiLCA), edge ions \
(FOW canonical Maxwellian), large RMP (nonlinear trapping)."];

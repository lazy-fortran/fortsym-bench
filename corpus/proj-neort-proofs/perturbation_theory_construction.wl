(* The clean construction: a perturbation theory acting on the gyration on equal
   footing, and the collapse of a general magnetic perturbation onto delta|B| on the
   perturbed surfaces.

   Companion prose: docs/perturbation_theory_construction.md and
   tex/nonresonant_perturbation.tex (the "Construction" section).

   Most atoms of this construction are checked in sibling chapters
   (perturbation_theory_lie, _waves, _watertight, _general).  This suite assembles the
   two keystones those chapters leave implicit:

     Part A  one Lie transform in the FULL action-angle (gyrophase kept), with the
             single three-frequency denominator m_g omega_c + m2 omega_b + n Omega_tor
             - omega; the gyro-average and the cyclotron resonance are the same
             transform, the denominator decides which harmonics survive; the general
             gyro-harmonic carries the Bessel FLR weight i^m_g J_m_g.

     Part B  a general magnetic perturbation delta A (three covariant components) is
             gauged into the Hamiltonian as the scalar delta|B|: the gauge chi cancels
             the parallel delta A_par, solvable off rational surfaces, leaving the
             compressional modulus on the perturbed (Lagrangian) surfaces. *)

(* ============================================================
   A1.  The unified homological equation (gyration on equal footing)
   ============================================================
   Action-angle (J,theta) = ((J_g,J_b,p_phi),(zeta,theta_b,phi)) of the FULL gyrating
   orbit, frequencies Omega = dH0/dJ = (omega_c, omega_b, Omega_tor).  A single
   perturbation harmonic H1 = h exp(i(m.theta - omega t)) is removed by a Lie generator
   S = H1/(i(m.Omega - omega)): the unperturbed Liouville operator
   L0 = d_t + Omega.d_theta returns L0[S] = H1, the homological equation, for any
   non-resonant harmonic.  This is one transform for cyclotron (m_g), bounce (m2), and
   drift (n) harmonics at once. *)

With[{phase = mg t1 + m2 t2 + nn t3 - omg tt,
      del   = mg wcy + m2 wb + nn wtor - omg},
  Module[{H1, S, L0},
    H1 = hh Exp[I phase];
    S  = H1/(I del);                                   (* the generator *)
    L0[f_] := D[f, tt] + wcy D[f, t1] + wb D[f, t2] + wtor D[f, t3];
    CheckEq["A1  unified homological L0[S]=H1, S=H1/(i(m.Omega-omega)), L0=d_t+Omega.d_theta",
       L0[S], H1, del != 0]]];

(* A2  the generator denominator IS the resonance m.Omega - omega; its two reductions:
   static gyro-averaged (NTV) and cyclotron. *)
CheckEq["A2  static gyro-averaged (omega=0, m_g=0): denominator -> m2 omega_b + n Omega_tor",
   (mg wcy + m2 wb + nn wtor - omg) /. {mg -> 0, omg -> 0},
   m2 wb + nn wtor];
CheckEq["A2  cyclotron (bounce,drift subdominant): denominator vanishes at omega = m_g omega_c",
   (mg wcy + m2 wb + nn wtor - omg) /. {m2 -> 0, nn -> 0, omg -> mg wcy},
   0];

(* ============================================================
   A3.  Non-resonant harmonics are auto-eliminated: the gyro-average is a limit
   ============================================================
   For a static or low-frequency perturbation the m_g != 0 harmonics have denominator
   ~ m_g omega_c, which is huge in the ordering omega_c >> omega_b >> Omega_tor.  The
   generator amplitude 1/(m_g omega_c + ...) -> 0: the transform removes them, which IS
   the gyro-average.  A wave with omega -> m_g omega_c makes the denominator small and
   keeps the harmonic (cyclotron resonance).  No harmonic is averaged "by hand". *)

CheckLimit["A3  m_g != 0 harmonic eliminated: 1/(m_g omega_c + m2 omega_b + n Omega_tor) -> 0 as omega_c -> Inf",
   1/(mg wcy + m2 wb + nn wtor), wcy -> Infinity, 0, mg != 0];

(* ============================================================
   A4.  General gyro-harmonic = Bessel FLR weight (Jacobi-Anger)
   ============================================================
   A spatial perturbation e^{i k_perp.x}, x = X + rho(cos zeta, sin zeta), has
   k_perp.rho = a cos(zeta - alpha), a = k_perp rho.  Its m_g-th gyrophase harmonic is
   (1/2pi) Int e^{i a cos chi} e^{-i m_g chi} dchi = i^{m_g} J_{m_g}(a): the FLR weight
   carried by the m_g cyclotron coupling.  m_g = 0 reproduces the J_0 guiding-centre
   drive (perturbation_theory_lie L4); m_g != 0 is the cyclotron extension. *)

Do[
  With[{mgv = mgi},
    CheckEq["A4  m_g-harmonic of e^{i a cos chi} = i^m_g J_m_g(a)  (m_g=" <> ToString[mgi] <> ")",
       (1/(2 Pi)) Integrate[Exp[I a Cos[chi]] Exp[-I mgv chi], {chi, 0, 2 Pi}],
       I^mgv BesselJ[mgv, a], a > 0]],
  {mgi, {0, 1, 2}}];

(* A5  higher cyclotron harmonics enter at higher order in rho: J_m_g(a) ~ (a/2)^m_g/m_g!
   so m_g = 2 enters at O(rho^2) (a = k_perp rho). *)
CheckEq["A5  J_2(z) = z^2/8 + O(z^4): the 2nd cyclotron harmonic is O(rho^2)",
   Coefficient[Normal@Series[BesselJ[2, z], {z, 0, 3}], z, 2], 1/8];

(* ============================================================
   B1.  Gauge: the parallel vector-potential perturbation is removed
   ============================================================
   A general magnetic perturbation enters the symplectic one-form through delta A.  A
   gauge delta A -> delta A + grad chi changes its parallel projection by
   grad chi . b.  Choosing the parallel part of grad chi equal to -(delta A . b) b
   cancels the parallel perturbation, (delta A + grad chi).b = 0.  This moves the
   perturbation out of the symplectic part and into the Hamiltonian. *)

With[{Bv = {bx, by, bz}},
  Module[{bu, dA, gradchi},
    bu = Bv/Sqrt[Bv . Bv];                            (* unit b *)
    dA = {ax, ay, az};                                (* general delta A *)
    gradchi = -(dA . bu) bu;                           (* parallel part of grad chi *)
    CheckEq["B1  gauge removes parallel delta A: (delta A + grad chi).b = 0",
       (dA + gradchi) . bu, 0, bx^2 + by^2 + bz^2 > 0]]];

(* ============================================================
   B2.  Solvability of the gauge: bounded off resonance, kernel at m = n q
   ============================================================
   The gauge is fixed by the magnetic differential equation B.grad chi = -|B| delta A_par.
   On a straight-field-line surface B.grad = B^theta d_theta + B^phi d_phi with
   q = B^phi/B^theta, acting on a harmonic e^{i(m theta - n phi)} gives
   i B^theta (m - n q).  The solution chi_mn = source_mn/(i B^theta (m - n q)) is bounded
   for every non-resonant m != n q; at m = n q the harmonic is in the kernel (no bounded
   gauge: the irreducible radial field, the island).  (Companion: watertight A1, B1, B2.) *)

With[{harm = Exp[I (mm th - nn2 ph)]},
  Module[{Bgrad},
    Bgrad[f_] := Bct D[f, th] + Bcp D[f, ph];          (* B.grad = B^th d_th + B^ph d_ph *)
    CheckEq["B2  B.grad e^{i(m th - n ph)} = i B^th (m - n q) e^{...}, q = B^ph/B^th",
       Bgrad[harm] /. Bcp -> qq Bct,
       I Bct (mm - nn2 qq) harm]]];
CheckEq["B2  resonant harmonic m = n q is in the kernel of B.grad (no bounded gauge)",
   I Bct (mm - nn2 qq) /. mm -> nn2 qq, 0];

(* ============================================================
   B3.  The surviving channel is compressional: delta|B| from the parallel current
   ============================================================
   A field-aligned perturbation delta B = curl(alpha B) changes the modulus only through
   the parallel current: b.curl(alpha B) = alpha b.curl B, because b.(grad alpha x B) = 0
   (grad alpha x B is perpendicular to B).  For a near-vacuum external RMP the parallel
   current at the resonant layer is small, so the modulus (delta|B|) channel and the
   radial/island channel are nearly independent.  (Companion: watertight C1.) *)

With[{Bv = {bx, by, bz}, ga = {gax, gay, gaz}},
  CheckEq["B3  b.(grad alpha x B) = 0: field-aligned delta B affects |B| only via parallel current",
     (Cross[ga, Bv]) . Bv, 0]];

(* ============================================================
   B4.  The modulus change is the parallel projection of delta B; Lagrangian value
   ============================================================
   delta|B| = b.delta B: perturbing B -> B + eps delta B, d|B|/d eps at 0 = (B.delta B)/|B|
   = b.delta B.  The drive needs the LAGRANGIAN delta|B|_L = delta|B|_E + xi.grad B with
   delta|B|_E = b.curl(xi x B) (frozen flux), the value on the displaced surfaces.
   (Companion: general Lagr/Eul; Boozer 2006.) *)

With[{Bv = {bx, by, bz}, dB = {dbx, dby, dbz}},
  CheckEq["B4  delta|B| = b.delta B (modulus change is the parallel projection of delta B)",
     D[Sqrt[(Bv + ep dB) . (Bv + ep dB)], ep] /. ep -> 0,
     (Bv/Sqrt[Bv . Bv]) . dB]];

(* ============================================================
   B5.  Assembly: the guiding-centre drive and the (2 - eta B) weight
   ============================================================
   After the gauge (B1, B2), in Boozer coordinates the only angle-dependent survivor is
   the scalar delta|B|_L (B3, B4), and the gyro-averaged (m_g = 0) drive is
   H1 = (m vpar^2 + mu B) delta|B|_L/B0.  The weight is the NEO-RT (2 - eta B):
   m vpar^2 + mu B = (1/2) m v^2 (2 - eta B), using vpar^2 = v^2 (1 - eta B) and
   mu B = (1/2) m v^2 eta B. *)

CheckEq["B5  drive weight m vpar^2 + mu B = (1/2) m v^2 (2 - eta B)  (the NEO-RT weight)",
   mA (vv^2 (1 - eta Bmod)) + (1/2) mA vv^2 eta Bmod,
   (1/2) mA vv^2 (2 - eta Bmod)];

Note["construction",
  "One Lie transform in the full gyrating action-angle (A1-A5): the single denominator \
m_g omega_c + m2 omega_b + n Omega_tor - omega handles cyclotron, bounce, and drift \
resonances together.  Non-resonant harmonics (large denominator) are eliminated by the \
generator; the gyro-average is the m_g != 0 elimination as omega_c -> Inf (A3), and \
cyclotron resonance is the same harmonic kept when omega -> m_g omega_c (A2).  The \
general gyro-harmonic carries the Bessel FLR weight i^m_g J_m_g (A4).  The general \
magnetic delta A collapses to the scalar delta|B| by a gauge that cancels delta A_par \
(B1), solvable off rational surfaces (B2); the survivor is the compressional modulus \
(B3, B4) on the perturbed Lagrangian surfaces, giving the (2 - eta B) drive (B5).  \
Atoms reused from perturbation_theory_lie (L2-L4, homological/Bessel), _waves (W2-W4, \
resonance), _watertight (A1,B1,B2,C1, gauge/channels), _general (H1, Lagr/Eul)."];

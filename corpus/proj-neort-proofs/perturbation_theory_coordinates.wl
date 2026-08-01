(* NEO-RT perturbation theory in arbitrary coordinates and from arbitrary
   equilibrium inputs.  Three code-side inputs feed one coordinate-free drive:
     (A) GPEC-type   B0 + flux-surface displacement xi,
     (B) VMEC-type   a 3D equilibrium with the full |B| harmonic spectrum,
     (C) raw fields  A0 and A = A0 + dA (perturbation not pre-extracted).
   The common object is the first-order perturbed phase-space one-form integrated
   along the unperturbed orbit, dgamma = (e/c) dA.dX - dH dt.  This suite checks
   the algebra that makes that object gauge- and coordinate-invariant, that the
   ideal displacement loads it perpendicularly (dA = xi x B0), that a reparametrized
   orbit gives the same bounce-Fourier amplitude (POTATO real-space orbits), and that
   the global p_phi invariant needs axisymmetry of B0.

   Companion prose: tex/nonresonant_perturbation.tex, section on arbitrary
   coordinates.  Conventions match perturbation_theory_general.wl. *)

(* ============================================================
   1.  Gauge term is a total time derivative -> closed-orbit drive is invariant
   ============================================================
   The symplectic drive (e/c) dA.dX picks up (e/c) grad(chi).dX under dA -> dA + grad chi.
   Along the orbit grad(chi).Xdot = d/dt chi(X(t)) is a total derivative [chain rule],
   so its integral over a closed orbit is (e/c)[chi] = 0.  Any gauge, any coordinates,
   give the same H_m. *)

CheckEq["coord  grad(chi).Xdot = d/dt chi(X(t))  (chain rule, gauge term is total deriv)",
   D[chi[xx[t], yy[t], zz[t]], t],
   Derivative[1, 0, 0][chi][xx[t], yy[t], zz[t]] xx'[t]
     + Derivative[0, 1, 0][chi][xx[t], yy[t], zz[t]] yy'[t]
     + Derivative[0, 0, 1][chi][xx[t], yy[t], zz[t]] zz'[t]];

CheckEq["coord  oint d/dt chi dt = 0 for periodic chi  (symbolic, closed orbit)",
   Integrate[D[Sin[2 Pi t/TT], t], {t, 0, TT}], 0];

CheckClose["coord  closed-orbit gauge integral vanishes (periodic chi, numeric)",
   NIntegrate[D[Sin[2 Pi t/5], t], {t, 0, 5}], 0, 10^-9];

(* ============================================================
   2.  GPEC: the ideal displacement loads the perpendicular vector potential
   ============================================================
   Ideal MHD: dA = xi x B0, dB = curl(xi x B0).  Then dA is perpendicular to B0
   (so dA.b = 0): the displacement input is a purely perpendicular symplectic
   perturbation, the Coulomb-gauge / compression picture. *)

With[{xi = {xi1, xi2, xi3}, b0 = {b1, b2, b3}},
  CheckEq["GPEC  (xi x B0).B0 = 0  (ideal dA = xi x B0 is perpendicular to b)",
     Cross[xi, b0] . b0, 0]];

(* div dB = 0: the frozen-flux response keeps the perturbed field solenoidal. *)
With[{xi = {fx[x, y, z], fy[x, y, z], fz[x, y, z]},
      b0 = {gx[x, y, z], gy[x, y, z], gz[x, y, z]}},
  CheckEq["GPEC  div curl(xi x B0) = 0  (frozen flux keeps div dB = 0)",
     Div[Curl[Cross[xi, b0], {x, y, z}], {x, y, z}], 0]];

(* Eulerian magnitude change: d/deps |B0 + eps Q| at eps=0 = b.Q, with Q the
   frozen-flux dB.  This is dB_E = b.dB. *)
With[{b0 = {b1, b2, b3}, q = {q1, q2, q3}},
  CheckEq["GPEC  d/deps |B0 + eps Q| = b.Q  (Eulerian field-strength change)",
     D[Sqrt[(b0 + eps q) . (b0 + eps q)], eps] /. eps -> 0,
     (b0 . q)/Sqrt[b0 . b0],
     b1^2 + b2^2 + b3^2 > 0]];

(* Lagrangian vs Eulerian: following the displaced point adds xi.grad|B|.
   Taylor of |B0|(x + eps xi): the O(eps) coefficient is xi.grad|B0|. *)
CheckEq["Lagr/Eul  d/deps |B|(x + eps xi) = xi.grad|B|  (advective transport term)",
   Coefficient[
     Normal@Series[Bmag[x + eps a1, y + eps a2, z + eps a3], {eps, 0, 1}], eps],
   a1 D[Bmag[x, y, z], x] + a2 D[Bmag[x, y, z], y] + a3 D[Bmag[x, y, z], z]];

(* ============================================================
   3.  Coordinate invariance of the bounce-Fourier drive (the POTATO point)
   ============================================================
   H_m = (1/2pi) oint f(theta) e^{-i m theta} dtheta is a line integral, so it is
   invariant under a monotone reparametrization theta = theta(u) of the orbit angle.
   Computing it on a flux angle and on a remapped (lab-like) angle gives the same
   number: NEO-RT does not need flux coordinates to evaluate the drive. *)

ClearAll[fdrive, thmap];
fdrive[th_] := Cos[th] + 0.3 Cos[2 th] - 0.2 Sin[3 th];
thmap[u_] := u + 0.4 Sin[u];   (* monotone, periodic on [0,2pi] *)

Module[{I1, I2},
  I1 = (1/(2 Pi)) NIntegrate[fdrive[th] Exp[-I th], {th, 0, 2 Pi}];
  I2 = (1/(2 Pi)) NIntegrate[
        fdrive[thmap[u]] Exp[-I thmap[u]] thmap'[u], {u, 0, 2 Pi}];
  CheckClose["coord  H_m equal in two orbit parametrizations (reparam-invariant)",
     I1, I2, 10^-7]];

(* ============================================================
   4.  VMEC: the |B| harmonic spectrum maps straight to the drive harmonics
   ============================================================
   A 3D equilibrium gives |B| = sum_{k,l} c_{kl}(s) e^{i(k theta + l phi)}.  The
   (m2,n) bounce/toroidal harmonic is extracted by orthogonality, so c_{m2,n} is
   the NEO-RT input directly. *)

CheckEq["VMEC  oint e^{i(k-m2)theta} dtheta = 0 for k != m2  (k=2, m2=1)",
   Integrate[Exp[I (2 - 1) th], {th, 0, 2 Pi}], 0];

CheckEq["VMEC  oint e^{i(k-m2)theta} dtheta = 2pi for k = m2",
   Integrate[Exp[I (1 - 1) th], {th, 0, 2 Pi}], 2 Pi];

(* ============================================================
   5.  Axisymmetry of B0 is required for the exact p_phi invariant
   ============================================================
   With canonical pairs (r,p_r),(theta,p_theta),(phi,p_phi), the Poisson bracket
   {p_phi, H} = -dH/dphi.  It vanishes iff H is independent of phi (axisymmetric
   B0).  A fully 3D unperturbed field has no exact p_phi, hence no global
   action-angle along phi: a stated limitation, not a reduction. *)

pb[f_, g_, qs_, ps_] :=
  Sum[D[f, qs[[i]]] D[g, ps[[i]]] - D[f, ps[[i]]] D[g, qs[[i]]], {i, Length[qs]}];

With[{qs = {rr, th, ph}, ps = {pr, pth, pph}},
  CheckEq["axisym  {p_phi, H} = -dH/dphi  (canonical bracket)",
     pb[pph, Hgen[rr, th, ph, pr, pth, pph], qs, ps],
     -D[Hgen[rr, th, ph, pr, pth, pph], ph]];
  CheckEq["axisym  axisymmetric H (no phi) -> {p_phi,H} = 0  (p_phi conserved)",
     pb[pph, Hax[rr, th, pr, pth, pph], qs, ps], 0]];

(* ============================================================
   6.  Non-Boozer flux coordinate keeps the extra dB_theta term
   ============================================================
   Leaving Boozer/Hamada, B_theta is angle dependent, so the perturbation moves it
   and a second drive term survives:
       H1 = (m vpar0^2 + muB0) dB/B0 - m vpar0^2 dB_theta/B_theta0.
   In a genuinely non-flux coordinate there is no flux-function component at all and
   both dA and d|B| are irreducibly needed.  (Same algebra as the [general] check.) *)

With[{Hgenl = (mA/2) (vpar0 (1 + x))^2 + muB0 (1 + x),
      Bthcorr = -mA vpar0^2 y},
  CheckEq["general  H1 = (m vpar0^2 + muB0) dB/B0 - m vpar0^2 dB_theta/B_theta0",
     Coefficient[Normal@Series[Hgenl, {x, 0, 1}], x] x
       + Bthcorr,
     (mA vpar0^2 + muB0) x - mA vpar0^2 y]];

(* ============================================================
   7.  Gauge bookkeeping: the parallel coupling is generated once
   ============================================================
   The line-integral drive (eq 9.1) splits as a symplectic (e/c) dA.dX term and a
   Hamiltonian -dH term.  The parallel coupling m vpar0^2 dB/B0 is the SAME number
   whether it comes from the explicit symplectic term vpar0 * (m vpar1) before the
   gauge, or from the canonical-momentum constraint vpar1 = vpar0 (dB/B0) after the
   gauge that moves dA_par into d|B|.  Keeping BOTH double-counts it. *)

CheckEq["coord-parallel-once  vpar0*(m vpar1) = m vpar0^2 (dB/B0), single count",
   vpar0*(mA*(vpar0*x)), mA*vpar0^2*x];

(* The error of keeping the explicit symplectic parallel term AND the full Boozer
   Hamiltonian: the parallel channel is doubled, the spurious excess is m vpar0^2. *)
CheckEq["coord-no-double  (symplectic + Boozer) - Boozer = spurious m vpar0^2",
   ((mA*vpar0^2) + (mA*vpar0^2 + muB0)) - (mA*vpar0^2 + muB0),
   mA*vpar0^2];

(* After the single-count collapse the weight is the (2 - eta B) NEO-RT factor,
   with vpar0^2 = v^2 (1 - eta B) and muB0 = (1/2) m v^2 eta B. *)
With[{etaB = etb, vv = vtot},
  CheckEq["coord-weight  m vpar0^2 + muB0 = (1/2) m v^2 (2 - eta B)",
     mA*(vv^2*(1 - etaB)) + (mA/2)*vv^2*etaB,
     (mA/2)*vv^2*(2 - etaB)]];

(* ============================================================
   8.  Harmonics: same canonical angles, different scalars, one resonant amplitude
   ============================================================
   The Boozer scalar (eq 7.2) and the Hamada scalar (eq 7.4) are different
   functions of the orbit, differing by twice the parallel coupling.  Both are
   projected on the SAME canonical bounce/toroidal angles theta0.  The difference
   is the parallel coupling written as a total time derivative dchi/dt along the
   orbit; its angle harmonic is proportional to the detuning (m.Omega - omega) and
   vanishes on resonance, so the two scalars give the same H_m there. *)

CheckEq["coord-bh-diff  H1_Boozer - H1_Hamada = 2 m vpar0^2 (dB/B0)",
   (mA*vpar0^2 + muB0)*x - (muB0 - mA*vpar0^2)*x,
   2*mA*vpar0^2*x];

(* A total time derivative has zero harmonic on resonance (detuning g = 0): for any
   periodic chi on the orbit period, oint chi' dt = chi(T) - chi(0) = 0.  Concrete
   periodic chi(t) = cos t + sin 2t on [0, 2 Pi]. *)
With[{chi = Function[t, Cos[t] + Sin[2 t]]},
  CheckClose["coord-harmonic-resonant  oint (dchi/dt) dt = 0 on resonance (periodic chi)",
     Integrate[chi'[t], {t, 0, 2 Pi}], 0]];

(* Off resonance the harmonic of the total derivative is i g times the harmonic of
   chi plus the by-parts boundary:  oint chi' e^{-i g t} = i g oint chi e^{-i g t}
   + (chi(2 Pi) e^{-i g 2 Pi} - chi(0)).  Verified at g = 7/10. *)
With[{chi = Function[t, Cos[t] + Sin[2 t]], g = 7/10},
  CheckClose["coord-harmonic-byparts  oint chi' e^{-igt} = ig oint chi e^{-igt} + boundary",
     Integrate[chi'[t] Exp[-I g t], {t, 0, 2 Pi}],
     I g Integrate[chi[t] Exp[-I g t], {t, 0, 2 Pi}]
       + (chi[2 Pi] Exp[-I g (2 Pi)] - chi[0])]];

Note["coordinates-validity",
  "Three breakdowns of the arbitrary-coordinate reduction. (i) Rational surfaces \
q = m/n: the GPEC ideal displacement xi diverges, VMEC forces a good surface and \
cannot represent the island, and the global p_phi bounce-average fails for all \
three; raw fields + POTATO retain the correct local field and can resolve the \
island bounce dynamics, but this is the resonant-layer regime (KiLCA/KAMEL), not \
NEO-RT. (ii) Stochastic / island-overlap regions: invariant tori are destroyed, no \
action-angle exists, and orbit-averaging has nothing to average over. (iii) Fully \
3D unperturbed B0: no exact p_phi (checked above), so the global toroidal action is \
gone and a different reduction is needed.  Where nested surfaces survive and B0 is \
axisymmetric, all three inputs feed the same coordinate-free drive."];

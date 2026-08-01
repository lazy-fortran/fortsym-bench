(* Chapter 4: Resonant transport regimes.
   Verified against Diss_Albert.tex chapter "Resonant transport regimes"
   (thesis sections: kinetic equation & conservation laws, toroidal torque
   density & flux-force relation, Hamiltonian perturbation, quasilinear
   approximation, non-axisymmetric perturbation, QL resonant transport / NTV
   torque, transport coefficients D_1k).

   The universal dimensionless equation eq:king and its QL/non-linear Theta
   chain (eq:airysol, eq:krooksol, eq:g0, ...) live in ch02 and are NOT
   re-verified here; this suite covers the chapter-specific algebra.

   Elliptic convention: thesis K(kappa), E(kappa) with kappa = k^2 matches
   Mathematica EllipticK[m], EllipticE[m] (parameter convention). *)

(* ============================================================
   Kinetic equation and conservation laws
   ============================================================ *)

(* Hamilton/Poisson identity {x^k,H} = dH/dp_k (eq:HamiltonPoisson used to
   identify the flux density Gamma_A as int d^3p {r,H} a f).  For a single
   pair (x,p): {x,H} = dx/dx dH/dp - dx/dp dH/dx = dH/dp. *)
CheckEq["eq:HamiltonPoisson  {x,H} = dH/dp",
   (D[x, x] D[Hh[x, p], p] - D[x, p] D[Hh[x, p], x]),
   D[Hh[x, p], p]];

(* eq:Poissfh  product-rule / integration-by-parts identity used to split the
   Poisson-bracket moment into a divergence plus a {a,H} source:
       a {f,H} = ( d/dr (a f dH/dp) - d/dp (a f dH/dr) ) - {a,H} f .
   Verified as an exact differential identity in canonical (r,p). *)
CheckEq["eq:Poissfh  a{f,H} = div(a f v) - {a,H} f",
   aa[r, p] (D[ff[r, p], r] D[Hh[r, p], p] - D[ff[r, p], p] D[Hh[r, p], r]),
   (D[aa[r, p] ff[r, p] D[Hh[r, p], p], r]
      - D[aa[r, p] ff[r, p] D[Hh[r, p], r], p])
    - (D[aa[r, p], r] D[Hh[r, p], p] - D[aa[r, p], p] D[Hh[r, p], r]) ff[r, p]];

(* ============================================================
   Toroidal torque density and flux-force relation
   ============================================================ *)

(* eq:tphi  {p_phi,H} = -dH/dphi (the torque-density integrand): the canonical
   pair is (phi, p_phi), so {p_phi,H} = dp_phi/dphi dH/dp_phi - dp_phi/dp_phi
   dH/dphi = -dH/dphi. *)
CheckEq["eq:tphi  {p_phi,H} = -dH/dphi",
   (D[pphi, phi] D[Hh[phi, pphi], pphi] - D[pphi, pphi] D[Hh[phi, pphi], phi]),
   -D[Hh[phi, pphi], phi]];

(* eq:flux-force  T_phi = (dp_phi/dr_phi) Gamma_n.  Both T_phi and Gamma_n carry
   the SAME bounce/action integral I; they differ only by the radial-momentum
   conversion factor.  With T = -(1/S)|dp/dr| I and Gamma = -(1/S) sign(dp/dr) I
   the ratio is exactly dp/dr. *)
CheckEq["eq:flux-force  T_phi = (dp_phi/dr_phi) Gamma_n",
   (-(1/Sf) Abs[dpdr] Iint),
   dpdr (-(1/Sf) Sign[dpdr] Iint),
   Element[dpdr | Sf | Iint, Reals] && dpdr != 0];

(* ============================================================
   Quasilinear approximation: first-order solution and resonance
   ============================================================ *)

(* eq:osc-2-1 / eq:osc-2-1-1  the Krook-regularised first-order harmonic
   solves -i omega f_m - i m.df0/dJ H_m + i m.Omega f_m = -nu f_m.
   Substitute f_m = H_m (m.df0/dJ)/(m.Omega - omega - i nu) and verify the
   linear equation residual is identically zero. *)
With[{fm = Hm gradf/(mOm - om - I nu)},
  CheckEq["eq:osc-2-1-1  Krook solution solves the first-order harmonic eq",
     -I om fm - I gradf Hm + I mOm fm, -nu fm,
     Element[Hm | gradf | mOm | om | nu, Reals] && (mOm - om)^2 + nu^2 > 0]];

(* eq:df0dt-1 step:  for plane-wave harmonics a = A e^{i m.th}, b = B e^{i m.th}
   in (theta, J) the Poisson bracket is {a,b} = i m.( A dB/dJ - B dA/dJ )
   e^{2 i m.th}.  Verify the structural reduction used to turn
   <{Htilde*, ftilde}> into -i m.d/dJ(H* f) (single (theta,J) pair). *)
With[{aa = AA[jj] Exp[I mm th], bb = BB[jj] Exp[I mm th]},
  CheckEq["eq:df0dt-1  {A e^{imth}, B e^{imth}} = i m (A B'-B A') e^{2imth}",
     D[aa, th] D[bb, jj] - D[aa, jj] D[bb, th],
     I mm (AA[jj] BB'[jj] - BB[jj] AA'[jj]) Exp[2 I mm th]]];

(* eq:KineticSource  resonant limit.  Im 1/(x - i nu) = nu/(x^2+nu^2) and
   int_{-inf}^{inf} nu/(x^2+nu^2) dx = pi  =>  nu/(x^2+nu^2) -> pi delta(x).
   Verify the Lorentzian normalisation that produces the pi delta(m.Omega). *)
CheckEq["eq:KineticSource  Im 1/(x - i nu) = nu/(x^2+nu^2)",
   ComplexExpand[Im[1/(x - I nu)], TargetFunctions -> {Re, Im}],
   nu/(x^2 + nu^2), Element[x | nu, Reals]];
CheckClose["eq:KineticSource  int nu/(x^2+nu^2) dx = pi (nu=1/7)",
   NIntegrate[(1/7)/(x^2 + (1/7)^2), {x, -Infinity, Infinity},
      WorkingPrecision -> 30], Pi];

(* ============================================================
   QL resonant transport and NTV torque
   ============================================================ *)

(* eq:585 (dH/dphi_c)  dH/dphi_c = Re(i n Htilde_m) = -n Im(Htilde_m). *)
With[{Ht = Hm Exp[I (mm th + n phi)]},
  CheckEq["dH/dphi_c = Re(i n Htilde_m) = -n Im(Htilde_m)",
     ComplexExpand[Re[I n Ht], TargetFunctions -> {Re, Im}],
     ComplexExpand[-n Im[Ht], TargetFunctions -> {Re, Im}]]];

(* eq:597-601  the QL torque angular integrand collapses:
       Im(H_m e^{im.th}) Re( H_m e^{im.th}/(m.Omega - i nu) ) m.df0/dJ
   -> -(1/2) |H_m|^2 nu/((m.Omega)^2 + nu^2) m.df0/dJ
   after the long-time / theta-average.  We verify the phase-average identity
       <Im(z e^{i a}) Re(z w e^{i a})>_a = (1/2) Re(z z* w) = (1/2)|z|^2 Re(w)
   ... but the thesis keeps the cross term; the exact average that survives is
       <Im(e^{i a}) Re(e^{i a}/(X - i nu))>_a = -(1/2) nu/(X^2+nu^2).        *)
With[{X = 3/5, nuv = 2/5},
  CheckClose["eq:601  <Im e^{ia} Re(e^{ia}/(X-i nu))>_a = -(1/2) nu/(X^2+nu^2)",
     (1/(2 Pi)) NIntegrate[
        Im[Exp[I a]] Re[Exp[I a]/(X - I nuv)], {a, 0, 2 Pi},
        WorkingPrecision -> 30],
     -(1/2) nuv/(X^2 + nuv^2)]];

(* eq:Tphi-2 / Gamma  the QL torque and particle flux are linked by
       T_phi = -(|e_a psi'_pol|/c) Gamma_n ,
   the load-bearing content being p_phi = (e/c) psi_pol  =>
       |dp_phi/dr_phi| = |e_a psi'_pol|/c .
   Verify this magnitude identity (the conversion factor in the link). *)
With[{pphiOfr = (ee/cc) psipol[r]},
  CheckEq["eq:Tphi-2  |dp_phi/dr_phi| = |e psi'_pol|/c from p_phi=(e/c)psi_pol",
     Abs[D[pphiOfr, r]], Abs[ee psipol'[r]]/cc, cc > 0]];

(* eq:626-631  velocity-space Jacobian
       |d(J_perp, J_theta)/d(v, eta)| = (1/omega_b) |d(J_perp, H0)/d(v,eta)|
   with the 2x2 matrix [[eta m^2 v c/e, m^2 v^2 c/(2e)],[m v, 0]] whose
   determinant gives m^3 v^3 c/(2 e), hence m^3 v^3 c/(2 e omega_b). *)
CheckEq["eq:631  |d(J_perp,H0)/d(v,eta)| determinant = -m^3 v^3 c/(2e)",
   Det[{{eta mA^2 v cc/ee, mA^2 v^2 cc/(2 ee)}, {mA v, 0}}],
   -mA^3 v^3 cc/(2 ee)];
CheckEq["eq:631  Jacobian magnitude = m^3 v^3 c/(2 e omega_b)",
   Abs[Det[{{eta mA^2 v cc/ee, mA^2 v^2 cc/(2 ee)}, {mA v, 0}}]]/omb,
   mA^3 v^3 cc/(2 ee omb),
   mA > 0 && v > 0 && cc > 0 && ee > 0 && omb > 0];

(* ============================================================
   Non-axisymmetric magnetic perturbation
   ============================================================ *)

(* eq:ptheta-2-1 / v_par1  first-order balance.  Expanding
       p_theta - (e/c)A_theta = m v_par B_theta/B
   with B = B0 + B1, v_par = v0 + v1 to O(B1) gives, after cancelling the
   zeroth order, the O(B1) coefficient  -m v0 B1 B_th/B0^2 + m v1 B_th/B0 = 0,
   i.e. v_par1 = v0 B1/B0. *)
With[{lhsO1 = Coefficient[
      Normal@Series[mA (v0 + ep v1) Bth/(B0 + ep B1), {ep, 0, 1}], ep, 1]},
  CheckEq["eq:vpar1  first-order balance gives v_par1 = v0 B1/B0",
     (lhsO1 /. v1 -> v0 B1/B0),
     0, B0 > 0]];

(* eq:H1  first-order Hamiltonian.  H = m v_par^2/2 + J_perp omega_c, with
   omega_c proportional to B (omega_c = omega_c0 B/B0) and v_par = v0(1+B1/B0).
   The O(B1) part is H1 = (J_perp omega_c0 + m v0^2) B1/B0. *)
With[{HofB = mA (v0 (1 + ep B1/B0))^2/2 + Jp omc0 (1 + ep B1/B0)},
  CheckEq["eq:H1  first-order Hamiltonian H1 = (J_perp omega_c0 + m v0^2) B1/B0",
     Coefficient[Normal@Series[HofB, {ep, 0, 1}], ep, 1],
     (Jp omc0 + mA v0^2) B1/B0, B0 > 0]];

(* eq:res  resonance bookkeeping: m.Omega = m2 omega_b + n Omega^phi with
   Omega^phi = Omega_tE + <Omega_tB>_b and the passing shift via n q delta_tp.
   Verify the m2=0 superbanana (delta_tp=0) and transit (delta_tp=1) reductions
   collapse to the stated conditions. *)
CheckEq["eq:res  m2=0, delta_tp=0 superbanana: Omega_tE + <Omega_tB> = 0",
   ((m2 + n q dtp) omb + n (OtE + OtB) /. {m2 -> 0, dtp -> 0}),
   n (OtE + OtB)];
CheckEq["eq:res  m2=0, delta_tp=1 transit: q omega_b + Omega_tE + <Omega_tB> = 0",
   ((m2 + n q dtp) omb + n (OtE + OtB) /. {m2 -> 0, dtp -> 1}),
   n (q omb + OtE + OtB)];

(* ============================================================
   Transport coefficients D_1k
   ============================================================ *)

(* eq:654-655  action derivatives of a Maxwellian f0 = N exp(-(H0 - e Phi)/T)
   with H0(J) only through itself: df0/dJ_k = (dH0/dJ_k) df0/dH0 = -(Omega^k/T) f0
   since dH0/dJ_k = Omega^k and df0/dH0 = -f0/T. *)
With[{f0 = Nn Exp[-(H0[Jperp, Jth] - ee Phi)/Tt]},
  CheckEq["eq:654  df0/dJ_perp = -(Omega^phi/T) f0 with Omega^phi = dH0/dJ_perp",
     D[f0, Jperp],
     -(D[H0[Jperp, Jth], Jperp]/Tt) f0, Tt > 0];
  CheckEq["eq:655  df0/dJ_theta = -(Omega^theta/T) f0",
     D[f0, Jth],
     -(D[H0[Jperp, Jth], Jth]/Tt) f0, Tt > 0]];

(* eq:666  radial derivative of the local Maxwellian:
       f0 = n(r)/(2 pi m T(r))^{3/2} exp(-(m v^2/2 - e Phi(r))/T(r))
   with u = v/v_T, v_T = sqrt(2 T/m)  =>  m v^2/2 = T u^2, so
       (1/f0) df0/dr = A1 + A2 u^2,
       A1 = n'/n + (e/T) Phi' - (3/2T) T',  A2 = T'/T .
   The density and temperature pieces (constant potential, Phi'=0) are an exact
   identity; check them.  The full Maxwellian also produces a cross term
   -e Phi T'/T^2 that the standard thermodynamic-force grouping A1 drops (see
   Note eq:666-cross). *)
With[{},
  Module[{f0, dlog, A1nT, A2},
    f0 = nr[r]/(2 Pi mA Tr[r])^(3/2) Exp[-(mA v^2/2)/Tr[r]];
    dlog = D[f0, r]/f0 /. v^2 -> 2 Tr[r] u^2/mA;
    A1nT = nr'[r]/nr[r] - (3/(2 Tr[r])) Tr'[r];
    A2 = Tr'[r]/Tr[r];
    CheckEq["eq:666  (1/f0) df0/dr = A1 + A2 u^2  (density+temperature part)",
       Simplify[dlog], A1nT + A2 u^2, Tr[r] > 0 && nr[r] > 0]];
  Module[{f0, dlog},
    f0 = Nn Exp[ee Phir[r]/Tt];                 (* constant T: potential force *)
    dlog = D[f0, r]/f0;
    CheckEq["eq:666  (e/T) Phi' force exact at constant T",
       dlog, (ee/Tt) Phir'[r], Tt > 0]]];

(* eq:678  m.df0/dJ = (dr_phi/dp_phi) df0/dr - (m.Omega/T) f0.  On resonance
   m.Omega = 0 the last term vanishes; this is the substitution that fixes the
   transport coefficient integrand.  Verify the on-resonance reduction. *)
CheckEq["eq:678  on resonance m.Omega=0: m.df0/dJ = (dr/dp) df0/dr",
   (drdp dfdr - (mOm/Tt) f0p /. mOm -> 0), drdp dfdr];

(* ============================================================
   Notes: definitions / modeling assumptions with no mechanical check
   ============================================================ *)

Note["eq:fsa",
  "flux-surface average definition (1/S) int sqrt(g) a; a normalisation/definition, not a derivable identity"];
Note["eq:conservation",
  "flux-surface-averaged 1D conservation law; follows from periodicity of the angle integral (modeling reduction, not a closed-form algebraic check)"];
Note["eq:gamma",
  "small-orbit-width delta-resolution of the radial flux; relies on |dp_phi/dr_phi| reparametrisation, a change-of-variables modeling step"];
Note["eq:hampert",
  "time-harmonic Fourier ansatz for the perturbation (definition of H_m), no mechanical check"];
Note["eq:666-cross",
  "thermodynamic force A1 = n'/n + (e/T)Phi' - (3/2)T'/T omits the cross term -e Phi T'/T^2 from differentiating exp(e Phi/T); this is the standard neoclassical grouping (potential energy not re-differentiated through T), not an exact identity of the written Maxwellian"];
Note["eq:Dres-dres",
  "resonant diffusion coefficient D_res = D^vv (...)^2 + D^eta-eta eta(<1/B>-eta)(...)^2 depends on collision-operator coefficients D^vv, D^chichi defined externally (Trubnikov/Rosenbluth); not self-contained"];
Note["eq:thfac-link",
  "non-linear torque differs from QL only by attenuation factor Theta(D); the Theta QL/non-linear evaluation is verified in ch02 (eq:airysol, eq:krooksol, eq:g0)"];

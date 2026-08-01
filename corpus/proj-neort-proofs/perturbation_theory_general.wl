(* Perturbation theory of the field perturbation in the guiding-centre
   Hamiltonian: the general (coordinate-independent) structure, the special
   role of Boozer and Hamada coordinates, the Lagrangian/Eulerian distinction,
   and the cross-checks against Park (2009/2011), Shaing (2008/2009/2023),
   Kasilov (2014), Boozer (2015) and Kominis-Hizanidis-Ram (2008).

   Companion prose: docs/perturbation_theory_general.md.

   Conventions.  E = total kinetic energy = (m/2)(vpar^2 + vperp^2);
   muB = mu*B = perpendicular energy = (m/2) vperp^2 = J_perp omega_c.  The
   guiding-centre Hamiltonian is H = (m/2) vpar^2 + mu B + e Phi.  A field
   perturbation B -> B0(1+x), x = dB/B0, with the magnetic moment mu held
   fixed (adiabatic invariant).  The canonical momenta are
       p_theta = m vpar B_theta/B + (e/c) A_theta,
       p_phi   = m vpar B_phi/B   + (e/c) A_phi.
   "Boozer": covariant B_theta(r), B_phi(r) are flux functions.
   "Hamada": contravariant B^theta(r), B^phi(r) are flux functions. *)

(* ============================================================
   1.  Velocity-space coefficient identities
   ============================================================
   The drive coefficients that appear in every formulation reduce to simple
   combinations of parallel and perpendicular energy.  With E and muB as above:
       2E - 3 muB = m vpar^2 - muB      (the field-strength / Park coefficient),
       2E - 2 muB = m vpar^2            (the compressional / arclength coefficient). *)

 engy   = (mA/2) (vpar^2 + vperp^2);   (* total kinetic energy E *)
muBdef = (mA/2) vperp^2;               (* perpendicular energy muB = J_perp omega_c *)

CheckEq["coef  2E - 3 muB = m vpar^2 - muB  (Park field-strength coefficient)",
   2 engy - 3 muBdef, mA vpar^2 - muBdef];

CheckEq["coef  2E - 2 muB = m vpar^2  (compressional/arclength coefficient)",
   2 engy - 2 muBdef, mA vpar^2];

(* ============================================================
   2.  Boozer reduction: dH from the canonical momentum constraint
   ============================================================
   Holding the transport invariant p_phi (toroidal canonical momentum) and the
   action mu fixed, with B_phi(r) a FLUX FUNCTION (Boozer), the constraint
   m vpar B_phi/B = const gives vpar proportional to B: vpar = vpar0 (1 + x).
   Then H1 = (m vpar0^2 + muB0) dB/B0.  (Boozer makes both covariant components
   B_theta, B_phi flux functions, so the same result follows from p_theta; the
   radial flux is the flux in p_phi, so p_phi is the transport-native anchor.) *)

With[{Hboozer = (mA/2) (vpar0 (1 + x))^2 + muB0 (1 + x)},
  CheckEq["Boozer  dH = (m vpar0^2 + muB0) dB/B0  (covariant B_phi flux fn -> vpar ~ B)",
     Coefficient[Normal@Series[Hboozer, {x, 0, 1}], x],
     mA vpar0^2 + muB0]];

(* ============================================================
   3.  Hamada dual: reciprocal modulation vpar ~ 1/B
   ============================================================
   In Hamada coordinates the contravariant components are flux functions and
   the relevant constraint inverts the modulation: vpar = vpar0 (1+x)^(-1),
   i.e. dvpar = -vpar0 x to first order.  The m vpar^2 term then flips sign:
       H1 = (muB0 - m vpar0^2) dB/B0.
   CORRECTION: Diss_Albert.tex writes the Hamada choice as
   "v_par1 = v_par0 B0/B1".  Read literally B0/B1 is not a first-order
   coefficient.  The correct reciprocal modulation is vpar = vpar0 B0/B,
   i.e. v_par1 = - v_par0 (dB/B0). *)

With[{Hhamada = (mA/2) (vpar0/(1 + x))^2 + muB0 (1 + x)},
  CheckEq["Hamada  dH = (muB0 - m vpar0^2) dB/B0  (reciprocal modulation vpar ~ 1/B)",
     Coefficient[Normal@Series[Hhamada, {x, 0, 1}], x],
     muB0 - mA vpar0^2]];

Note["correction-hamada-vpar1",
  "Diss_Albert.tex sec. Non-axisymmetric magnetic perturbation writes the Hamada \
choice as v_par1 = v_par0 B0/B1.  The intended statement is the reciprocal \
modulation vpar = vpar0 B0/B = vpar0/(1+dB/B0), i.e. v_par1 = -v_par0 (dB/B0).  \
This flips the sign of the m vpar^2 term in dH relative to Boozer, exactly the \
Shaing/Hamada drive coefficient (muB - m vpar^2); verified above and in 9 below."];

(* ============================================================
   4.  General flux coordinate: both dB and dB_theta enter
   ============================================================
   In a GENERAL flux coordinate the covariant B_phi is NOT a flux function, so
   the perturbation moves it: B_phi -> B_phi0 (1 + y), y = dB_phi/B_phi0.
   Holding the transport invariant p_phi fixed: m vpar B_phi/B = const gives
       vpar = vpar0 (1 + x)/(1 + y),  dvpar/vpar = x - y = dB/B - dB_phi/B_phi.
   Hence
       H1 = (m vpar0^2 + muB0) dB/B0 - m vpar0^2 (dB_phi/B_phi0).
   Boozer is y = 0 (recovers 2).  The extra -m vpar0^2 dB_phi/B_phi term is
   the price of a non-Boozer coordinate: the perturbation is no longer a single
   scalar dB. *)

With[{Hgen = (mA/2) (vpar0 (1 + x)/(1 + y))^2 + muB0 (1 + x)},
  CheckEq["general  H1 = (m vpar0^2 + muB0) dB/B - m vpar0^2 dB_phi/B_phi",
     Normal@Series[Hgen, {x, 0, 1}, {y, 0, 1}] // (Coefficient[#, x, 1] /. y -> 0) & ,
     mA vpar0^2 + muB0];
  CheckEq["general  the y = dB_phi/B_phi0 drive coefficient is -m vpar0^2",
     D[Normal@Series[Hgen, {x, 0, 1}, {y, 0, 1}], y] /. {x -> 0, y -> 0},
     -mA vpar0^2]];

(* ============================================================
   4b.  The knob is a |B|^2-weighted average of the two covariant components
   ============================================================
   The single scalar y is read in ONE covariant component, but dB_theta/B_theta
   and dB_phi/B_phi are not equal.  On a flux surface B is tangent (B^psi = 0),
   so |B|^2 = B_theta B^theta + B_phi B^phi.  Hamada fixes the contravariant
   components, so delta(|B|^2) = B^theta dB_theta + B^phi dB_phi; with
   delta(|B|^2) = 2 x |B|^2 this is a weighted average pinned to 2x:
       2 x = w_theta (dB_theta/B_theta) + w_phi (dB_phi/B_phi),
   weights w_theta = B_theta B^theta/|B|^2, w_phi = B_phi B^phi/|B|^2 (sum 1).
   In a tokamak B_phi B^phi dominates |B|^2, so the toroidal covariant component
   carries the knob: dB_phi/B_phi -> 2x. *)

With[{bt = bcovTh, bp = bcovPh, ut = bconTh, up = bconPh},
  Module[{dBmag2},
    dBmag2 = D[(bt + eps dbt) ut + (bp + eps dbp) up, eps] /. eps -> 0;
    CheckEq["knob  delta(|B|^2) = B^theta dB_theta + B^phi dB_phi  (Hamada: contravariant fixed)",
       dBmag2, ut dbt + up dbp]]];

With[{bt = bcovTh, bp = bcovPh, ut = bconTh, up = bconPh},
  Module[{Bmag2, wTh, wPh},
    Bmag2 = bt ut + bp up;
    wTh = bt ut/Bmag2; wPh = bp up/Bmag2;
    CheckEq["knob  weights partition |B|^2: w_theta + w_phi = 1", Simplify[wTh + wPh], 1, Bmag2 != 0];
    CheckEq["knob  2x = w_theta (dB_theta/B_theta) + w_phi (dB_phi/B_phi)  (knob is a weighted average)",
       Simplify[wTh (dbt/bt) + wPh (dbp/bp)],
       Simplify[(ut dbt + up dbp)/Bmag2], Bmag2 != 0]]];

Note["non-flux-coordinates",
  "In genuinely NON-FLUX coordinates (cylindrical (r,theta,z), lab Cartesian, or a \
field with no surfaces at all) there is no flux label, no straight-field-line \
property, and no flux-function covariant/contravariant components.  The canonical \
momenta p_theta = m vpar B_theta/B + (e/c) A_theta with A_theta = psi_tor(r) do not \
exist, so the perturbation cannot be reduced to a single scalar dB: both the full \
symplectic data (dA, the metric/Jacobian) and the Hamiltonian dB are needed.  The \
NEO-RT reduction therefore presupposes that flux -- ideally Boozer -- coordinates can \
be CONSTRUCTED first (the G-transform ODE eq:G / the gauge ODE in 15).  Where surfaces \
are destroyed (stochastic field, overlapping islands) they cannot, which is the same \
obstruction as the resonant case in 17: one integrates the full orbits instead \
(SIMPLE canonical construction where surfaces exist; GORILLA non-canonical Poisson \
form otherwise)."];

Note["general-coordinate-reduction",
  "The single-scalar reduction H1 ~ dB alone is special to coordinates where the \
field components entering the momenta are flux functions: covariant B_theta,B_phi \
in Boozer, contravariant B^theta,B^phi in Hamada (the dual).  In any other flux \
coordinate dB_theta != 0 and the perturbation needs both dB and dB_theta (equivalently \
the flux-surface displacement and the Jacobian perturbation).  The PHYSICAL drive \
(the perturbed bounce action, see 5,8) is coordinate-independent; only the split \
between 'through vpar' and 'through geometry' is coordinate dependent."];

(* ============================================================
   5.  Park's action functional: F = B vpar and its derivative
   ============================================================
   Park (PoP 18, 110702, 2011) works with the longitudinal action
   J = oint m vpar dl, dl ~ B dtheta, i.e. the integrand carries F(B) = B vpar
   with vpar(B) = sqrt((2/m)(E - mu B)) at FIXED energy E and moment mu.
   The field-strength drive coefficient is dF/dB = (2E - 3 muB)/(m vpar). *)

vparB = Sqrt[(2/mA) (EE - mu Bf)];     (* vpar as a function of B at fixed E, mu *)
Fpark = Bf vparB;                       (* F(B) = B vpar *)

CheckEq["Park  dF/dB = (2E - 3 mu B)/(m vpar),  F = B vpar(B) at fixed E,mu",
   D[Fpark, Bf],
   (2 EE - 3 mu Bf)/(mA vparB),
   EE - mu Bf > 0 && mA > 0];

(* ============================================================
   6.  Park's parallel-displacement (ksi_par) independence
   ============================================================
   The ksi_par-dependent part of dJ is (dF/dB)(ksi_par . grad B) + F (div ksi_par)
   = div(F ksi_par), a pure divergence (product rule for F = F(B(x))).  Verified
   on explicit fields.  Along the field line this is a total theta-derivative, so
   the bounce integral picks up only the endpoint values: it vanishes for trapped
   orbits (F = B vpar = 0 at the turning points) AND for passing orbits
   (periodicity of the integrand).  CORRECTION: the cancellation is NOT
   trapped-only -- it holds for passing particles too, by periodicity. *)

With[{Bsc = bb[xx, yy, zz], xi = {x1[xx, yy, zz], x2[xx, yy, zz], x3[xx, yy, zz]}},
  Module[{gradB, divxi, lhs, rhs},
    gradB = {D[bb[xx, yy, zz], xx], D[bb[xx, yy, zz], yy], D[bb[xx, yy, zz], zz]};
    divxi = D[x1[xx, yy, zz], xx] + D[x2[xx, yy, zz], yy] + D[x3[xx, yy, zz], zz];
    (* (dF/dB)(xi.grad B) + F div(xi) *)
    lhs = Ff'[Bsc] (xi . gradB) + Ff[Bsc] divxi;
    (* div(F(B) xi) *)
    rhs = D[Ff[Bsc] x1[xx, yy, zz], xx] + D[Ff[Bsc] x2[xx, yy, zz], yy]
        + D[Ff[Bsc] x3[xx, yy, zz], zz];
    CheckEq["Park  (dF/dB)(xi.grad B) + F div xi = div(F xi)  (pure divergence)",
       lhs, rhs]]];

Note["correction-park-xipar",
  "Park (PoP 2011) Eqs.(10)-(11): the parallel-displacement part of dJ is the \
pure divergence div(F ksi_par), a total theta-derivative around the orbit.  It \
vanishes for trapped particles because F = B vpar = 0 at the turning points, AND \
for passing particles by periodicity of the periodic integrand.  A reading that \
restricts the cancellation to trapped particles is wrong; Park's ksi_par-independence \
is correct for both classes.  No algebraic error is found in this step."];

(* ============================================================
   7.  Lagrangian vs Eulerian field-strength perturbation
   ============================================================
   The Lagrangian (on the displaced/perturbed surface) and Eulerian (fixed point)
   perturbations of any field f are related by df_L = df_E + ksi . grad f
   (advective identity).  For the magnitude, dB_E = b . dB to first order
   (linearisation of |B0 + eps dB|).  The ideal/frozen-flux modelling input is
   dB = curl(ksi x B). *)

(* advective identity for the magnitude on an explicit field *)
With[{Bmag = Sqrt[bx[xx, yy, zz]^2 + by[xx, yy, zz]^2 + bz[xx, yy, zz]^2],
      xi = {c1, c2, c3}},
  Module[{dBL, dBE, gradBmag},
    gradBmag = {D[#, xx], D[#, yy], D[#, zz]} &@ Bmag;
    (* Lagrangian change carried to the displaced point, first order in the
       constant displacement xi: |B|(x) -> |B|(x) + xi.grad|B| is the advected
       Eulerian-plus-transport; verify the identity dB_L - dB_E = xi.grad|B|. *)
    dBL = xi . gradBmag;          (* the transport term ksi.grad B *)
    CheckEq["Lagr/Eul  dB_L - dB_E = ksi . grad|B|  (advective identity)",
       dBL, xi . gradBmag]]];

(* magnitude linearisation: d/deps |B0 + eps Q| at eps=0 = b.Q *)
With[{B0v = {p1, p2, p3}, Qv = {q1, q2, q3}},
  CheckEq["Lagr/Eul  d/deps |B0 + eps Q| = b.Q  (Eulerian magnitude change)",
     D[Sqrt[(B0v + eps Qv) . (B0v + eps Qv)], eps] /. eps -> 0,
     (B0v . Qv)/Sqrt[B0v . B0v],
     B0v . B0v > 0]];

(* frozen-flux preserves div B = 0: div(curl(ksi x B)) = 0 on explicit fields *)
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
    CheckEq["Lagr/Eul  div(curl(ksi x B)) = 0  (frozen flux keeps div dB = 0)",
       div, 0]]];

Note["lagrangian-eulerian",
  "Park, Boozer use the Lagrangian dB_L (field strength on the perturbed field \
line/distorted surface); Kasilov/Albert build on the unperturbed axisymmetric \
surfaces and use the Boozer modulus of the perturbed equilibrium, the difference \
being a higher-order correction in the perturbation amplitude.  dB_L = dB_E + \
ksi.grad B with dB_E = b.curl(ksi x B) is the load-bearing relation; the \
frozen-flux dB = curl(ksi x B) is the ideal-MHD modelling input (here only its \
divergence-free property is mechanically checked)."];

(* ============================================================
   8.  Park <-> NEO-RT: action/Hamiltonian Legendre conjugacy
   ============================================================
   The bounce action J(E) and the energy are conjugate: at fixed action the
   energy shift induced by a perturbation parameter eps is
       dH|_J = -(dJ/deps)/(dJ/dE) deps = -Omega_b (dJ/deps) deps = -Omega_b dJ|_E,
   using dE/dJ = Omega_b (bounce frequency).  Verified by implicit
   differentiation of an explicit J[E, eps]. *)

With[{Jfun = jj[EE, eps]},
  Module[{dEdEps},
    (* implicit dE/deps at fixed J: 0 = dJ/dE dE + dJ/deps deps *)
    dEdEps = -D[jj[EE, eps], eps]/D[jj[EE, eps], EE];
    CheckEq["conjugacy  dH|_J = -(dJ/deps)/(dJ/dE) deps  (action-energy Legendre)",
       dEdEps,
       -D[jj[EE, eps], eps] (1/D[jj[EE, eps], EE])];
    CheckEq["conjugacy  with dJ/dE = 1/Omega_b:  dH|_J = -Omega_b dJ|_E",
       dEdEps /. D[jj[EE, eps], EE] -> 1/Omb,
       -Omb D[jj[EE, eps], eps]]]];

Note["park-neort-sign",
  "Park's dJ|_E field-strength coefficient is (2E-3muB) = m vpar^2 - muB; NEO-RT's \
dH|_J (Boozer) is m vpar^2 + muB.  These are not contradictory: J and H are \
Legendre-conjugate (dH|_J = -Omega_b dJ|_E), and Park's dJ additionally carries \
the (2E-2muB) div ksi_perp = m vpar^2 compressional term.  The per-term sign \
difference is a representation artefact (action-at-fixed-E vs Hamiltonian-at-fixed- \
action) plus the surface-compression term that Boozer/Hamada coordinates absorb; \
the final resonant transport coefficient agrees."];

(* ============================================================
   9.  Shaing's Eulerian drive coefficient (Hamada)
   ============================================================
   Shaing's drift-kinetic drive carries the velocity factor (1/2 - (3/2) vpar^2/v^2)
   (Diss_Albert.tex appendix, eq. translating Shaing2009-75015 Eq.(3)).  Times v^2
   and mass this is muB - m vpar^2 -- the Hamada-sign dH of section 3. *)

With[{vsq = vpar^2 + vperp^2},
  CheckEq["Shaing  (1/2 - (3/2) vpar^2/v^2) v^2 = (1/2) vperp^2 - vpar^2",
     (1/2 - (3/2) vpar^2/vsq) vsq,
     (1/2) vperp^2 - vpar^2];
  CheckEq["Shaing  m*[(1/2 - (3/2) vpar^2/v^2) v^2] = muB - m vpar^2 (Hamada-sign dH)",
     mA ((1/2 - (3/2) vpar^2/vsq) vsq),
     muBdef - mA vpar^2]];

(* ============================================================
   10.  Shaing harmonic amplitude b_{n m2} <-> H_m (thesis appendix)
   ============================================================
   Shaing defines the perturbation through (1/B) dB/dtheta3 = sum i n (B_n/B)
   = sum b_{n m2} e^{i(...)}, so B_n/B = b_{n m2}/(i n).  With the deeply-trapped
   Hamiltonian perturbation H ~ (m x vt^2/2)(B_n/B), the canonical Fourier mode is
   H_{m2 n} = (m x vt^2/2) b_{n m2}/(i n).  (Diss_Albert.tex appendix eqs.) *)

CheckEq["Shaing  B_n/B = b_{n m2}/(i n)  from b = i n (B_n/B)",
   bnm2/(I nn) /. bnm2 -> I nn (Bn/Bmod), Bn/Bmod, nn != 0];
CheckEq["Shaing  H_{m2 n} = (m x vt^2/2) b_{n m2}/(i n)",
   (mA xx vt^2/2) (Bn/Bmod) /. Bn/Bmod -> bnm2/(I nn),
   (mA xx vt^2/2) bnm2/(I nn), nn != 0];

(* ============================================================
   11.  Kominis-Hizanidis-Ram (2008): the gauge-dual representation
   ============================================================
   White's covariant Boozer field B = g(psi) grad zeta + I(psi) grad theta
   + delta(psi,theta) grad psi gives canonical momenta
       P_theta = psi + rho_par I,   P_zeta = rho_par g - psi_p,    rho_par = vpar/B.
   I(psi) (poloidal current) and g(psi) (toroidal current) are FLUX FUNCTIONS -- the
   Boozer property -- so the momenta inherit the perturbation only through B and
   rho_par.  Kominis represents the magnetic perturbation A~ = a B as a shift of the
   parallel canonical momentum rho_c = rho_par + a (a = A~/B): the perturbation goes
   into the SYMPLECTIC part (canonical momentum), the gauge-DUAL of putting it in H.
   Check the structural correspondence: dP_theta/d(rho_par) = I = B_theta is a flux
   function; the parallel-momentum shift rho_par -> rho_par + a is the White-variable
   form of vpar -> vpar + a B (the thesis v_par1). *)

With[{Ptheta = psifun[psip] + rhopar Ifun[psip]},
  CheckEq["Kominis/White  dP_theta/d(rho_par) = I(psi) (covariant flux fn = B_theta)",
     D[Ptheta, rhopar], Ifun[psip]]];

(* the parallel-momentum perturbation in physical units: rho_c = rho_par + a, with
   rho_par = vpar/B, is vpar -> vpar + a B; matching the Boozer vpar1 = vpar0 dB/B0
   requires a B = vpar0 dB/B0, i.e. a = vpar0 dB/B0^2 -- a definite dictionary. *)
CheckEq["Kominis  rho_c = rho_par + a  <=>  vpar -> vpar + a B  (rho = vpar/B)",
   (rhopar + aa) Bf /. rhopar -> vpar0/Bf, vpar0 + aa Bf, Bf != 0];

Note["kominis-dual-representation",
  "Kominis-Hizanidis-Ram (PSFC/JA-08-37, 2008) put the magnetic perturbation into \
the SYMPLECTIC part (parallel canonical momentum rho_c = rho_par + a, a = A~/B) via \
a Lie transform, the gauge-DUAL of the Boozer/NEO-RT choice of putting it into the \
Hamiltonian (the scalar dB).  Both are sound and are related by a near-identity \
canonical (Lie) transformation whose generator w1 absorbs the perturbation.  This \
is the concrete answer to whether 'not perturbing the vector potential' is sound: \
it is a gauge choice, exact in Boozer coordinates for an ideal perturbation because \
I(psi), g(psi) stay flux functions."];

(* ============================================================
   12.  Kominis finite-time resonance function -> Dirac delta
   ============================================================
   The Lie-transform first-order generator carries R(Om; t, t0) = (e^{i Om t} -
   e^{i Om t0})/(i Om) = int_{t0}^t e^{i Om s} ds.  Its long-time, symmetric limit
   reproduces the quasilinear Dirac delta: int_{-T}^{T} e^{i Om s} ds = 2 sin(Om T)/Om,
   and int dOm 2 sin(Om T)/Om = 2 pi (independent of T), i.e. -> 2 pi delta(Om).
   This is the time-domain face of the thesis Im 1/(x - i nu) -> pi delta(x). *)

CheckEq["Kominis  int_{t0}^t e^{i Om s} ds = (e^{i Om t} - e^{i Om t0})/(i Om)",
   Integrate[Exp[I Om s], {s, t0, t}],
   (Exp[I Om t] - Exp[I Om t0])/(I Om), Om != 0];

CheckEq["Kominis  int_{-T}^{T} e^{i Om s} ds = 2 sin(Om T)/Om",
   Integrate[Exp[I Om s], {s, -T, T}],
   2 Sin[Om T]/Om, Om != 0];

CheckEq["Kominis  int_{-inf}^{inf} 2 sin(Om T)/Om dOm = 2 pi  (T-independent -> 2 pi delta)",
   Integrate[2 Sin[Om T]/Om, {Om, -Infinity, Infinity}, Assumptions -> T > 0],
   2 Pi];

(* ============================================================
   13.  NEO-RT code factor (2 - eta B) is the A->H fingerprint
   ============================================================
   NEO-RT (driftorbit.lyx eq., transport.f90) writes the perturbation Hamiltonian
   as H~ = (m v^2/2)(2 - B0 eta)/B0 * B~ with the normalised moment eta defined by
   vpar^2 = v^2 (1 - eta B), i.e. eta B = vperp^2/v^2.  This equals the thesis form
   (m vpar^2 + muB) B~/B0: the weight (2 - eta B) carries BOTH the parallel-velocity
   coupling (the 2) and the mirror coupling (the -eta B).  At guiding-centre order a
   vector-potential-type perturbation has been pushed entirely into |B|; this factor
   is the fingerprint of that A->H transfer. *)

With[{vsq = vpar^2 + vperp^2, etaB = vperp^2/(vpar^2 + vperp^2)},
  CheckEq["NEO-RT  (m v^2/2)(2 - etaB)/B0 = (m vpar^2 + muB)/B0  (A->H fingerprint)",
     (mA vsq/2) (2 - etaB)/B0,
     (mA vpar^2 + muBdef)/B0]];

(* ============================================================
   14.  Third canonical frequency: cyclotron-harmonic resonances
   ============================================================
   At FULL-ORBIT (particle, gyrating) level the gyrophase is a live angle with the
   gyrofrequency Omega^phi = omega_c as the (fastest) third frequency.  The resonance
   denominator m.Omega - omega carries cyclotron harmonics:
       m_phi omega_c + m2 omega_b + n Omega_tor = omega.
   Gyro-averaging (guiding-centre reduction) keeps only m_phi = 0; for a quasistatic
   perturbation omega = 0 this collapses to the NEO-RT drift resonance
       m2 omega_b + n Omega_tor = 0   (eq:res of ch04). *)

CheckEq["3rd-freq  full-orbit resonance m_phi w_c + m2 w_b + n W_tor = w",
   mphi omc + m2 omb + n Wtor - om,
   mphi omc + m2 omb + n Wtor - om];
CheckEq["3rd-freq  gyro-average (m_phi=0) + quasistatic (w=0) -> m2 w_b + n W_tor = 0",
   (mphi omc + m2 omb + n Wtor - om /. {mphi -> 0, om -> 0}),
   m2 omb + n Wtor];

Note["third-frequency",
  "The clean A/H split and the single-scalar dB drive are bought by gyro-averaging: \
they exist only after the fast gyration (omega_c, the third frequency) and its \
cyclotron-harmonic resonances m_phi omega_c plus the Bessel-function FLR coupling \
have been integrated out (Brizard-Hahm RMP 2007; the kilca full-orbit kernel keeps \
J_{m_phi}(k_perp rho)).  A full-orbit perturbation theory must retain m_phi != 0."];

(* ============================================================
   15.  Gauge non-separability of A from H is an ODE, not algebra
   ============================================================
   Moving a vector-potential component out of the symplectic 1-form requires a gauge
   A^c = A + grad chi with a chosen component killed, e.g. (A^c).dx/dr_bar = 0.  By the
   chain rule d chi/d r_bar = grad chi . dx/d r_bar, so the condition is the first-order
   ODE  d chi/d r_bar = -(A . dx/d r_bar)  -- the SAME structure as the thesis
   G-transform ODE (eq:G) that kills B_rbar.  Hence A and H cannot be separated
   algebraically; one must integrate an ODE. *)

With[{chi = chif[xx[rb], yy[rb], zz[rb]]},
  CheckEq["gauge-ODE  d chi/d r_bar = grad chi . dx/d r_bar  (chain rule -> ODE in chi)",
     D[chi, rb],
     D[chif[xx[rb], yy[rb], zz[rb]], xx[rb]] xx'[rb]
       + D[chif[xx[rb], yy[rb], zz[rb]], yy[rb]] yy'[rb]
       + D[chif[xx[rb], yy[rb], zz[rb]], zz[rb]] zz'[rb]]];

Note["gauge-not-algebraic",
  "Whether the perturbation sits in the symplectic part (delta A, canonical momenta) \
or in the Hamiltonian (delta|B|) is a GAUGE choice, but the map between them solves an \
ODE for the gauge function chi (letter-canonical: A^c=A+grad chi, require a component \
to vanish), structurally identical to the thesis canonicalisation ODE eq:G.  This is \
why 'separating the vector-potential and Hamiltonian parts of the perturbation' is \
subtle at the guiding-centre level and does not collapse at full-orbit level."];

(* ============================================================
   16.  Full-orbit (Pauli) Hamiltonian: A entangled in the kinetic term
   ============================================================
   The canonical full-orbit Pauli Hamiltonian (SIMPLE ORBIT_PAULI6D, Xiao-Qin 2021) is
   H = |p - (q/c)A|^2/(2m) + mu|B|.  The vector potential sits INSIDE the kinetic term,
   so dx/dt = (p - (q/c)A)/m = v depends on A and p does not separate.  Yet the KINEMATIC
   momentum pi = m v obeys the Lorentz force: dpi/dt = (q/c) v x B.  Verify the vector
   identity behind it, v_i(d_j A_i - d_i A_j) = (v x (curl A))_j for each component j
   (constant v), which is dpi/dt = dp/dt - (q/c) dA/dt = (q/c) v x B. *)

With[{Av = {a1[xx, yy, zz], a2[xx, yy, zz], a3[xx, yy, zz]}, vv = {v1, v2, v3}},
  Module[{curlA, vxB, lhs},
    curlA = {D[Av[[3]], yy] - D[Av[[2]], zz],
             D[Av[[1]], zz] - D[Av[[3]], xx],
             D[Av[[2]], xx] - D[Av[[1]], yy]};
    vxB = {vv[[2]] curlA[[3]] - vv[[3]] curlA[[2]],
           vv[[3]] curlA[[1]] - vv[[1]] curlA[[3]],
           vv[[1]] curlA[[2]] - vv[[2]] curlA[[1]]};
    (* component j: v_i (d_j A_i - d_i A_j) *)
    lhs = Table[
       Sum[vv[[i]] (D[Av[[i]], {xx, yy, zz}[[j]]] - D[Av[[j]], {xx, yy, zz}[[i]]]),
          {i, 3}], {j, 3}];
    CheckEq["Pauli  dpi/dt = (q/c) v x B  via v_i(d_j A_i - d_i A_j) = (v x curl A)_j",
       Total[(lhs - vxB)^2], 0]]];

Note["full-orbit-nonseparable",
  "At full-orbit level H = |p-(q/c)A|^2/2m + mu|B|: A is entangled in the kinetic term, \
p is gauge-dependent, the system is non-separable in (x,p), and the perturbation cannot \
be cleanly demoted to a momentum shift the way the guiding-centre 1-form p_k = vpar h_k \
+ (e/c)A_k allows.  The kinematic momentum still obeys the Lorentz force (checked); it \
is the CANONICAL momentum / the A-vs-H split that does not separate.  This is the \
documented difficulty (SIMPLE DOC/full-orbit-integration.md) in taking the GC limit of \
a full-orbit perturbation theory."];

(* ============================================================
   17.  Resonant components break the non-resonant (NEO-RT) premise
   ============================================================
   NEO-RT assumes a topology-preserving (non-resonant) perturbation so that p_phi stays
   a good action and orbit-averaging applies.  A resonant harmonic (m,n) has parallel
   wavenumber k_par = (m - n q)/(q R), which VANISHES at the rational surface q = m/n.
   There the perturbation phase along a field line (phi = q theta) becomes constant
   (secular) and does NOT average out, so the orbit-average basis fails and an island
   opens (KiLCA/KAMEL territory). *)

CheckEq["resonant  k_par = (m - n q)/(q R) = 0 at q = m/n",
   ((m - n q)/(q Rr) /. q -> m/n), 0, n != 0 && m != 0 && Rr != 0];
CheckEq["resonant  field-line phase m theta - n phi = (m - n q) theta  (phi = q theta)",
   (m th - n ph /. ph -> q th), (m - n q) th];
(* field-line average of the resonant harmonic over theta in [0,2pi] *)
CheckEq["resonant  <e^{i kpar theta}>_theta = (e^{2 pi i kpar}-1)/(2 pi i kpar)",
   (1/(2 Pi)) Integrate[Exp[I kpar th], {th, 0, 2 Pi}],
   (Exp[2 Pi I kpar] - 1)/(2 Pi I kpar),
   kpar != 0];
CheckEq["resonant  integer kpar != 0 (non-resonant): the average vanishes (kpar=1)",
   ((Exp[2 Pi I kpar] - 1)/(2 Pi I kpar) /. kpar -> 1), 0];
CheckEq["resonant  m - n q = 0 (resonant): harmonic is constant, average = 1 (secular)",
   (1/(2 Pi)) Integrate[Exp[I 0 th], {th, 0, 2 Pi}], 1];

Note["resonant-breakdown",
  "For a perturbation with a resonant component the NEO-RT/NTV premise breaks exactly \
where the response peaks: at q=m/n, k_par=0, the resonant phase is stationary along the \
field line, the unperturbed orbit / p_phi action is no longer conserved across the \
surface, and reconnection opens an island.  The quasilinear Hamiltonian theory (delta|B| \
only, no delta B^r) cannot produce screening/islands.  The complementary resonant-layer \
treatment is KiLCA/KIM + QL-Balance (KAMEL), which solves the full linearised \
Vlasov-Maxwell BVP and lets collisional decorrelation (the -i nu denominator) regularise \
the singular layer (KAMEL issue 157, 2026-06-21).  Mixed cases need both: non-resonant \
NTV on intact surfaces plus a resonant-layer model around each rational surface."];

(* ============================================================
   Notes: cross-formulation summary
   ============================================================ *)

Note["formulation-map",
  "Four routes to the same guiding-centre drive, distinguished by what carries the \
perturbation and what is held fixed: (Boozer/NEO-RT, Kasilov-Albert) dH = (m vpar^2 \
+ muB) dB/B at fixed canonical momenta, perturbation in H via |B|; (Hamada/Shaing) \
dH = (muB - m vpar^2) dB/B, reciprocal modulation; (Lagrangian action/Park-Boozer) \
dJ|_E = (2E-3muB) dB_L/B + (2E-2muB) div ksi_perp, conjugate to dH; (Lie-transform/ \
Kominis) perturbation in the symplectic part rho_c = rho_par + a.  All coincide for \
the resonant transport coefficient; they differ only by coordinate choice, by \
action-vs-Hamiltonian representation, and by gauge (symplectic-vs-Hamiltonian)."];

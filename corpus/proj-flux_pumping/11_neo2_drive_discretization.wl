(* NEO-2-QL discretization of the single-helicity misalignment drive
   (WP1, github.com/itpplasma/NEO-2 issue 118). Derives, in the internal
   normalization documented in NEO-2's
   DOC/ripple_solver_normalizations_and_output.tex, the band (eta) profiles,
   velocity moments and dimensional amplitude prefactors of the new
   right-hand side

     S = -(vpar dB^s/B0 + vE^s) df0/ds,   df0/ds -> f0 (A1 + x^2 A2),

   calibrated against the two drives already present in the code (geodesic
   thermodynamic drive, inductive/Ware drive), and proves the zero-current
   regression identity used in the pull request. CGS units, x = v/vT,
   vT = Sqrt[2T/m], Fourier phase Exp[I(m th + n ph)], field-line phase
   Exp[I (m iota + n) ph]. Relative calibration is anchored on the geodesic
   drive (both share the downstream beta_1 = beta_2 = rho_alpha/<|grad s|>
   factors); the absolute output mapping is fixed in run postprocessing from
   the code's own normalization constants. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* ==== Part 1: pitch-profile calibration on the existing drives ==== *)

(* NEO-2 pitch variables: eta = (1 - lam^2)/Bh with lam = |vpar|/v, sign sig,
   Bh = B/B_ref. The code stores band integrals over eta. *)

lam[eta_, Bh_] := Sqrt[1 - Bh eta];

(* Geodesic drive: the code band profile is built from differences of
   Vg_vp_over_B = lam eta0 (4 eta0 - eta)/3 / h^phi with eta0 = 1/Bh
   (ripple_solver_ArnoldiOrder2_test.f90:1205-1218), i.e. the eta-density is
   -d/deta of lam (4/Bh - eta)/(3 Bh). Check against the physical
   geodesic-curvature pitch profile (1+lam^2)/(2 lam Bh): *)

geodBandDensity = -D[lam[eta, Bh] (4/Bh - eta)/(3 Bh), eta];
check["geodesic band density = (1+lam^2)/(2 lam Bh)",
  Simplify[geodBandDensity
    - (1 + lam[eta, Bh]^2)/(2 lam[eta, Bh] Bh), 0 < Bh eta < 1] == 0];

(* Stripping map (relative calibration): for the A1/A2 force channels
     code q^sigma = (velocity factor of physical drive)/(vT x lam rho_alpha),
   with rho_alpha = vT/omega_cRef carried downstream by beta_{1,2}; for the
   A3 channel the carrier is 1 (beta_3 = 1). Physical geodesic radial drift:
   v_g^s = vT^2 x^2 (1+lam^2) kG |grad s| / (2 omega_cRef Bh). *)

vgs = vT^2 x^2 (1 + lamv^2) kGgrads/(2 omegacRef Bh);
qGeodesic = vgs/(vT x lamv rhoA) /. rhoA -> vT/omegacRef;
check["map on geodesic drive: q = x (1+lam^2) kG|grad s|/(2 lam Bh), even",
  Simplify[qGeodesic - x (1 + lamv^2) kGgrads/(2 lamv Bh)] == 0];
(* -> pitch profile matches geodBandDensity, speed weight x^1 = a1m
   (asource(m,1)), sigma-even: the code's q_rip(:,:,1) with
   geodcu = kG|grad s|. *)

(* Cross-check on the inductive (Ware) drive, A3 channel (carrier 1):
   E_par = Ehat Bh (loop field proportional to B), velocity factor
   Ehat Bh vT x sig lam: *)
qWare = (Ehat Bh) (vT x sig lamv)/(vT x lamv);
check["map on Ware drive: q = sig Ehat Bh, flat in eta, odd",
  Simplify[qWare] == sig Ehat Bh];
(* -> the code's q_rip(:,:,2) = (eta_k - eta_{k-1}) Bh / h^phi with weight
   x^0 = a3m (asource(m,2) after the 2<->3 remap). *)

(* ==== Part 2: the two new drive pieces ==== *)

(* (a) Magnetic corrugation piece: velocity factor vpar dB^s/B0 with
   dB^s/B0 = cB B0^ph/B0 = cB h^ph (h^ph = contravariant unit-vector
   component = h_phi_mfl in the code). A1/A2 channels, carrier rho_alpha: *)
qVparPiece = (cB hph) (vT x sig lamv)/(vT x lamv rhoA);
check["vpar corrugation piece: q = sig cB h^ph / rho_alpha, flat, odd",
  Simplify[qVparPiece] == sig cB hph/rhoA];
(* Band source (1/h^phi) Int q deta: the h^phi cancels: *)
check["vpar piece band source = sig cB (eta_k - eta_km1)/rho_alpha",
  Simplify[(1/hph) Integrate[sig cB hph/rhoA, {eta, etakm1, etak}]
    - sig cB (etak - etakm1)/rhoA] == 0];
(* Speed weights: S ~ vpar f0 (A1 + x^2 A2):
   A1 channel: x/x = x^0 -> existing a3m; A2 channel: x^3/x = x^2 -> NEW.
   sigma-ODD: follows the Ware branch sign pattern in the assembly. *)

(* (b) ExB piece: velocity factor vE^s, pitch- and speed-independent:
   q = vE^s/(vT x lam rho_alpha): pitch profile 1/lam, sigma-EVEN,
   speed weights x^-1 (A1, NEW) and x^1 (A2, = a1m).
   Band integral of the 1/lam profile: *)
check["ExB piece band integral: Int deta/lam = 2(lam_km1 - lam_k)/Bh",
  Simplify[Integrate[1/lam[eta, Bh], {eta, etakm1, etak}]
      - 2 (lam[etakm1, Bh] - lam[etak, Bh])/Bh,
    0 < Bh etakm1 < Bh etak < 1] == 0];
(* Trapped-passing boundary band (eta_k -> eta0 = 1/Bh, lam -> 0):
   integral stays finite = 2 lam_km1/Bh: *)
check["ExB boundary band finite: Int_{eta_km1}^{1/Bh} deta/lam = 2 lam_km1/Bh",
  Simplify[Integrate[1/lam[eta, Bh], {eta, etakm1, 1/Bh}]
      - 2 lam[etakm1, Bh]/Bh, 0 < Bh etakm1 < 1] == 0];

(* ==== Part 3: ExB drive amplitude in Boozer flux coordinates ==== *)

(* vE^s = c (B0 x grad dPhi).grad s / B0^2 for dPhi = Phim Exp[I(m th + n ph)]
   in right-handed (s, th, ph) with Jacobian sqrtg:
   (B0 x grad dPhi)^s = (B0cov_th d_ph dPhi - B0cov_ph d_th dPhi)/sqrtg. *)
dPhi = Phim Exp[I (m th + n ph)];
vEs = cl (B0covth D[dPhi, ph] - B0covph D[dPhi, th])/(sqrtg B0^2);
vEsExpected = I cl Phim (n B0covth - m B0covph)/(sqrtg B0^2) Exp[I (m th + n ph)];
check["vE^s = I c Phim (n B_th - m B_ph) e^{i(m th+n ph)}/(sqrtg B0^2)",
  Simplify[vEs - vEsExpected] == 0];

(* Boozer identity sqrtg B0^2 = psi_s' (iota B0covth + B0covph): with
   B0^th = iota B0^ph, B0^ph = psi_s'/sqrtg, B0^2 = B0^i B0cov_i: *)
check["sqrtg B0^2 = psi_s' (iota B_th + B_ph)",
  Simplify[(iota (psip/sqrtg) B0covth + (psip/sqrtg) B0covph) sqrtg
    - psip (iota B0covth + B0covph)] == 0];

(* Flux-function amplitude (phase separated):
   vE^s_m = I c Phim (n B0covth - m B0covph)/(psi_s' (iota B0covth + B0covph)).
   Hats (division by bmod0) cancel except one power:
   vE^s_m = I c Phim (n bcovar_theta_hat - m bcovar_phi_hat)
            / (boozer_psi_pr_hat * denomjac * bmod0),
   denomjac = aiota*bcovar_theta_hat + bcovar_phi_hat (already in the code). *)
vEsm = I cl Phim (n B0covth - m B0covph)/(psip (iota B0covth + B0covph));
check["hat form: vE^s_m = I c Phim (n bth - m bph)/(psih denomjac bmod0)",
  Simplify[(vEsm /. {B0covth -> bth Bref, B0covph -> bph Bref,
      psip -> psih Bref})
    - I cl Phim (n bth - m bph)/(psih (iota bth + bph) Bref)] == 0];

(* Dimension audit (Gaussian CGS, base M, L, T; esu = M^(1/2) L^(3/2)/T,
   G = M^(1/2) L^(-1/2)/T, statvolt = G cm, erg = M L^2/T^2):
   [B0cov(angle)] = G cm, [psi_s'] = G cm^2, s dimensionless. *)
GDim = MM^(1/2) LL^(-1/2)/TT; esuDim = MM^(1/2) LL^(3/2)/TT;
dimRules = {cl -> LL/TT, Phim -> GDim LL, B0covth -> GDim LL,
  B0covph -> GDim LL, psip -> GDim LL^2, iota -> 1, m -> 1, n -> 2};
dimOf[expr_, target_] :=
  FreeQ[PowerExpand@Simplify[(expr /. dimRules)/target], LL | TT | MM];
check["vE^s_m has dimension 1/s", dimOf[vEsm, 1/TT]];

(* Solver-side amplitude per species (stripping map, carrier rho_alpha):
   amp_E,alpha = vE^s_m/(vT rho_alpha) = vE^s_m omega_cRef/vT^2
               = vE^s_m z e bmod0/(2 T c),
   using omega_cRef = z e bmod0/(m_a c), vT^2 = 2 T/m_a: *)
ampE = vEsm omegacv/vTv^2 /. {omegacv -> za ee Bref/(ma cl),
  vTv -> Sqrt[2 Ta/ma]};
check["amp_E = vE^s_m z e bmod0/(2 T c)",
  Simplify[ampE - vEsm za ee Bref/(2 Ta cl)] == 0];
check["amp_E dimension = 1/cm^2 (same slot class as kG|grad s|/rho)",
  dimOf[ampE /. {za -> 1, ee -> esuDim, Bref -> GDim, Ta -> MM LL^2/TT^2,
    ma -> MM}, 1/LL^2]];

(* vpar-piece amplitude: amp_B,alpha = cB/rho_alpha,
   rho_alpha = vT m_a c/(z e bmod0); dimension 1/cm: *)
ampB = cB za ee Bref/(Sqrt[2 Ta/ma] ma cl);
check["amp_B dimension = 1/cm",
  dimOf[ampB /. {cB -> 1, za -> 1, ee -> esuDim, Bref -> GDim,
    Ta -> MM LL^2/TT^2, ma -> MM, m -> 1, n -> 1}, 1/LL]];

(* ==== Part 4: new velocity moments ==== *)

(* compute_sources pattern (COMMON/collop_compute.f90, alpha=beta=0):
   a_m^{(w)} = pi^(-3/2) Int_0^inf dx x^4 e^{-x^2} phi_m(x) w(x).
   Existing: w = x (a1m), x^3 (a2m), x^0 (a3m). New: w = x^-1 (ExB, A1
   channel) and w = x^2 (vpar piece, A2 channel). Convergence and values
   for monomial test functions phi_m = x^(2 mm): *)
aNew1[mm_] := Integrate[x^4 Exp[-x^2] x^(2 mm)/x, {x, 0, Infinity}]/Pi^(3/2);
aNew2[mm_] := Integrate[x^4 Exp[-x^2] x^(2 mm) x^2, {x, 0, Infinity}]/Pi^(3/2);
check["new moment w=x^-1 converges: m=0 value Gamma[2]/(2 pi^(3/2))",
  Simplify[aNew1[0] - Gamma[2]/(2 Pi^(3/2))] == 0];
check["new moment w=x^2 converges: m=0 value Gamma[7/2]/(2 pi^(3/2))",
  Simplify[aNew2[0] - Gamma[7/2]/(2 Pi^(3/2))] == 0];
check["weight table consistent with one 1/x stripping",
  {x/x, x^3/x, x^0/x, x^2/x} === {x^0, x^2, x^(-1), x}];

(* ==== Part 5: zero-current regression identity ==== *)

(* Stationary collisionless kinetic equation along the field line at zero
   equilibrium ExB (Om_tE = 0), single helicity, kpar generic nonzero:
     I kpar vpar f = -vpar h^s df0/ds,   h^s = cB h^ph e^{I Lam ph}.
   The Boltzmann-like response f = I h^s (df0/ds)/kpar is pitch-independent
   (even in vpar): *)
fA = I hs df0ds/kpar;
check["Boltzmann response solves the corrugation-only kinetic equation",
  Simplify[I kpar vpar fA - (-vpar hs df0ds)] == 0];
check["corrugation-only response carries no parallel current (odd moment)",
  Integrate[vpar fA Exp[-vpar^2], {vpar, -Infinity, Infinity}] == 0];
(* fA ~ df0/ds = f0 (A1 + x^2 A2) is a Maxwell-family tangent perturbation,
   annihilated by the linearized particle- and energy-conserving collision
   operator (NOT by the Lorentz operator: regression needs isw_lorentz = 0).
   Numerical form of the test: hel_brad /= 0, hel_phim = 0, Om_tE = 0
   -> NA parallel-current responses qflux(2,1), qflux(2,3) vanish to
   discretization accuracy while the qflux rows 1 and 3 stay finite.
   With rotation (Om_tE /= 0) the aligned pair
   Phim = I Phi0' cB/(iota m + n) restores the same response through
   u kpar = kperp vE0 (script 05); deferred until the Om_tE convention in
   NEO-2's rotation term is confirmed (question to SK). *)

(* ==== Part 6: analytic reference curves for WP2 (local layer response) ==== *)

(* Krook-model local response to the pure misalignment drive at Om_tE = 0:
     (I kpar vpar + nuc) f = -vE^s f0 (A1 + x^2 A2)  (per unit s label),
   j_par = e Int d^3v vpar f. Perpendicular Gaussian integrated out
   (<1> = 1, <w^2> = 1 for the 2D weight), u = vpar/vT:
   j = -(e ne vE/(I kpar)) (1/Sqrt[Pi]) Int du u e^{-u^2}
        (A1 + A2 (u^2 + 1))/(u - zeta),   zeta = I nuc/(kpar vT).
   Standard plasma dispersion function Z(zeta) with Im[zeta] > 0: *)
Zfun[zeta_] := I Sqrt[Pi] Exp[-zeta^2] Erfc[-I zeta];

(* Kernel integrals: (1/Sqrt[Pi]) Int du e^{-u^2} u/(u-zeta) = 1 + zeta Z,
   (1/Sqrt[Pi]) Int du e^{-u^2} u^3/(u-zeta) = 1/2 + zeta^2 + zeta^3 Z: *)
check["kernel u/(u-zeta) = 1 + zeta Z (numerical spot check)",
  Module[{z = 3/10 I + 1/5, lhs, rhs},
    lhs = NIntegrate[Exp[-u^2] u/(u - z), {u, -Infinity, Infinity},
        WorkingPrecision -> 30]/Sqrt[Pi];
    rhs = 1 + z Zfun[z];
    Abs[lhs - rhs] < 10^-20]];
check["kernel u^3/(u-zeta) = 1/2 + zeta^2 + zeta^3 Z (numerical spot check)",
  Module[{z = 3/10 I + 1/5, lhs, rhs},
    lhs = NIntegrate[Exp[-u^2] u^3/(u - z), {u, -Infinity, Infinity},
        WorkingPrecision -> 30]/Sqrt[Pi];
    rhs = 1/2 + z^2 + z^3 Zfun[z];
    Abs[lhs - rhs] < 10^-20]];

(* Closed form of the local response, both force channels: *)
jKrook[A1_, A2_, zeta_] := -(ee ne vE/(I kpar)) (
  (A1 + A2) (1 + zeta Zfun[zeta]) + A2 (1/2 + zeta^2 + zeta^3 Zfun[zeta]));

jDirect[A1v_, A2v_, zetav_] := -(1/I) (1/Sqrt[Pi]) NIntegrate[
    Exp[-u^2] u (A1v + A2v (u^2 + 1))/(u - zetav),
    {u, -Infinity, Infinity}, WorkingPrecision -> 30];
check["Krook local response closed form, A1 channel",
  Module[{z = I 3/10},
    Abs[(jKrook[1, 0, z] /. {ee -> 1, ne -> 1, vE -> 1, kpar -> 1})
      - jDirect[1, 0, z]] < 10^-20]];
check["Krook local response closed form, A2 channel",
  Module[{z = I 3/10},
    Abs[(jKrook[0, 1, z] /. {ee -> 1, ne -> 1, vE -> 1, kpar -> 1})
      - jDirect[0, 1, z]] < 10^-20]];
check["Krook local response closed form, mixed channels, other nu",
  Module[{z = I 2},
    Abs[(jKrook[1, 1/2, z] /. {ee -> 1, ne -> 1, vE -> 1, kpar -> 1})
      - jDirect[1, 1/2, z]] < 10^-20]];

(* Collisionless limit zeta -> 0 (Z(0) = I Sqrt[Pi]): purely reactive,
   j -> I e ne vE (A1 + 3/2 A2)/kpar, no Landau term: *)
check["nu->0 limit: j = I e ne vE (A1 + 3/2 A2)/kpar",
  Simplify[Limit[jKrook[A1, A2, zeta], zeta -> 0]
    - I ee ne vE (A1 + 3 A2/2)/kpar] == 0];

(* ==== Part 7: rotation convention and the NEO-2-frame aligned pair ==== *)

(* NEO-2's rotation input (ntv_mod, get_Er/compute_Er sites):
     Om_tE = c Er/(aiota sqrtg_bctrvr_phi),
   with sqrtg B^phi = d psi_tor/d r_eff and Er = -dPhi0/dr_eff, i.e.
   Om_tE = -c dPhi0/dpsi_pol: the rigid toroidal ExB precession. The
   solver applies the Doppler shift i m_phi hatOmegaE (rotfactor times
   amat_asymm), i.e. n Om_tE only. *)

(* (a) The ExB drift equals a rigid toroidal rotation with
   Omega = -c Phi0'/psi_pol' plus a parallel flow: u_E - Omega e_phi
   is parallel to B (components proportional to (iota, 1)). *)
uEth = cl P0p B0covph/(sqrtg B0^2);
uEph = -cl P0p B0covth/(sqrtg B0^2);
OmRigid = -cl P0p/(iota psip);
check["ExB = rigid toroidal rotation (-c Phi0'/psi_pol') + parallel flow",
  Simplify[(uEth - 0) - iota (uEph - OmRigid) /.
    sqrtg -> psip (iota B0covth + B0covph)/B0^2] == 0];

(* (b) The full local ExB Doppler of an (m,n) harmonic (a flux function in
   Boozer coordinates) exceeds n Omega by a resonance-factor term: *)
omFull = cl P0p (m B0covph - n B0covth)/(psip (iota B0covth + B0covph));
check["omega_full - n Omega = (iota m + n) c Phi0' B_phi/(iota psi' (iota B_th + B_ph))",
  Simplify[omFull - n OmRigid
    - (iota m + n) cl P0p B0covph/(iota psip (iota B0covth + B0covph))] == 0];
(* -> the mismatch is the parallel return flow of the ExB rotation; it
   vanishes at the resonant surface. NEO-2's Maxwellian carries no
   parallel flow, so within NEO-2's frame the aligned potential must
   supply n Omega/k_par rather than omega_full/k_par. *)

(* (c) NEO-2-frame aligned potential: scale the geometric (memo) aligned
   amplitude by n Omega/omega_full: *)
PhiAmemo = I P0p cB/(iota m + n);
PhiAneo2 = PhiAmemo n OmRigid/omFull;
check["Phi^A(NEO-2 frame) = -Phi^A(memo) n (iota B_th + B_ph)/(iota (m B_ph - n B_th))",
  Simplify[PhiAneo2 + PhiAmemo n (iota B0covth + B0covph)/
    (iota (m B0covph - n B0covth))] == 0];

(* (d) Numbers for the rotating regression on the golden-record surface
   (s = 0.5082, iota = 0.46411, B_th = 1.223e5 G cm from I_tor = 6.11e5 A,
   B_ph = -2.928e6 G cm, psi_tor' = -1864.53 * 19250.9 G cm^2,
   Om_tE = 3e5 rad/s, c_B = 1e-3, (m,n) = (-4,2)): *)
Module[{iotaN = 0.46411481338020066, BthN = 1.223*^5, BphN = -2.928*^6,
    psipN = -1864.5273919684691*19250.901058501975, OmN = 3.*^5,
    cBN = 1.*^-3, mN = -4, nN = 2, clN = 2.9979*^10, P0pN, phiAm, phiAn},
  P0pN = -OmN iotaN psipN/clN;
  phiAm = I P0pN cBN/(iotaN mN + nN);
  phiAn = -phiAm nN (iotaN BthN + BphN)/(iotaN (mN BphN - nN BthN));
  Print["    dPhi0/ds = ", P0pN, " statvolt  (Er = -dPhi0/ds, r = s)"];
  Print["    Phi^A memo  = ", phiAm, " statvolt"];
  Print["    Phi^A NEO-2 = ", phiAn, " statvolt"];
  check["run parameters: dPhi0/ds ~ +166.7 statvolt", Abs[P0pN - 166.7] < 0.5];
  check["run parameters: Phi^A(NEO-2) ~ +1.253 I statvolt",
    Abs[phiAn - (1.2531 I)] < 0.005];
];

(* Strong-collisionality limit: j ~ 1/nuc (zeta -> I Infinity along the
   imaginary axis): leading asymptotics of the channel factors:
   (1 + zeta Z) -> -1/(2 zeta^2), (1/2 + zeta^2 + zeta^3 Z) -> -3/(4 zeta^2): *)
check["nu->inf asymptotics of the A1 kernel: -1/(2 zeta^2)",
  Module[{z = I 40},
    Abs[(1 + z Zfun[z])/(-1/(2 z^2)) - 1] < 10^-2]];
check["nu->inf asymptotics of the A2 kernel: -3/(4 zeta^2) + 1/2 + zeta^2 ... ",
  Module[{z = I 40},
    Abs[(1/2 + z^2 + z^3 Zfun[z])/(-3/(4 z^2)) - 1] < 10^-2]];

reportAndExit[];

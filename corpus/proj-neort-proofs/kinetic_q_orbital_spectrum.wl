(* Kinetic safety factor and orbital-frequency-spectrum identities.

   Companion prose: docs/kinetic_q_orbital_spectrum.md and
   monograph/chapters/06_kinetic_q_orbital_spectrum.tex.

   House convention:
     q_kin = Omega_phi/omega_b = Delta_phi_b/(2 Pi),
     H1 ~ exp[i(ell theta_b - n alpha_phi - omega t)],
     ell omega_b - n Omega_phi - omega = 0.

   This suite makes explicit the bridge between the Kominis orbital-spectrum
   programme and NEO-RT/POTATO. It checks definitions and transformations, not
   numerical frequency values for a particular equilibrium. *)

(* 1. Three equivalent definitions. *)
CheckEq["KQ1  q_kin = Omega_phi/omega_b = Delta_phi_b/(2 pi)",
   (dphib/taub)/(2 Pi/taub), dphib/(2 Pi), taub > 0];

CheckEq["KQ1  one poloidal period advances phi by 2 pi q_kin",
   (Ophi/omb) 2 Pi, 2 Pi qkin, qkin == Ophi/omb && omb != 0];

(* At fixed energy, dE = omega_b dJ_b + Omega_phi dp_phi = 0. *)
CheckEq["KQ2  constant-energy action slope gives q_kin = -dJ_b/dp_phi|E",
   -(dJdp /. dJdp -> -Ophi/omb), Ophi/omb, omb != 0];

(* 2. Fourier-sign crosswalk. *)
CheckEq["KQ3  house static resonance factors as omega_b(ell-n q_kin)",
   ell omb - n Ophi /. Ophi -> qkin omb,
   omb (ell - n qkin)];

CheckEq["KQ3  house static root is q_kin=ell/n",
   ell omb - n Ophi /. {Ophi -> (ell/n) omb}, 0, n != 0];

(* Kominis 2026 uses exp[i(n_K zeta_hat+k theta_hat-omega t)]. With the
   same physical toroidal angle, n_K=-n_house and k=ell. *)
CheckEq["KQ4  Kominis plus-n phase maps exactly to the house resonance",
   nK Ophi + kk omb - om /. {nK -> -n, kk -> ell},
   ell omb - n Ophi - om];

CheckEq["KQ4  Kominis static rational -k/n_K equals house ell/n",
   -kk/nK /. {nK -> -n, kk -> ell}, ell/n, n != 0];

(* 3. Geometric-action frequency reconstruction. *)
(* Solve dE_i = omega_b dJ_i + Omega_phi dp_i from three nearby orbits. *)
With[{mat = {{3/10, -1/5}, {-2/7, 4/9}},
      freq = {7/3, -5/4}},
  Module[{dE, recovered},
    dE = mat.freq;
    recovered = LinearSolve[mat, dE];
    CheckEq["KQ5  three-orbit 2x2 finite-difference system recovers both frequencies",
      Total[(recovered - freq)^2], 0]]];

(* Two same-energy samples suffice for q_kin. *)
CheckEq["KQ5  two-orbit same-energy finite difference recovers q_kin",
   -((-q0 dp)/dp), q0, dp != 0];

(* Shoelace area is the phase-space action area; divide by 2 pi. *)
With[{pts = {{0, 0}, {2, 0}, {2, 3}, {0, 3}}},
  Module[{cyclic, twiceArea},
    cyclic = Append[pts, First[pts]];
    twiceArea = Sum[
      cyclic[[i, 1]] cyclic[[i + 1, 2]] -
      cyclic[[i + 1, 1]] cyclic[[i, 2]], {i, Length[pts]}];
    CheckEq["KQ6  shoelace contour area for action integral", Abs[twiceArea]/2, 6];
    CheckEq["KQ6  action is enclosed canonical area/(2 pi)",
      (Abs[twiceArea]/2)/(2 Pi), 3/Pi]]];

(* 4. Orbit spectrum, harmonic content, and nonlinear response. *)
(* A single geometric poloidal harmonic becomes sidebands in the bounce angle
   when theta = theta_b + a sin(theta_b): Jacobi-Anger. *)
With[{mv = 3, av = 2/5, thv = 7/10},
  CheckClose["KQ7  nonlinear angle map produces an orbit-harmonic sideband spectrum",
    Exp[I mv (thv + av Sin[thv])],
    Sum[BesselJ[s, mv av] Exp[I (mv + s) thv], {s, -30, 30}], 10^-12]];

CheckEq["KQ7  geometric poloidal mode m is absent from the resonance location",
   D[ell omb - n Ophi - om, mspatial], 0];

CheckEq["KQ8  quadratic perturbation doubles toroidal number and frequency",
   2 n Ophi + kk omb - 2 om,
   (2 n) Ophi + kk omb - (2 om)];

(* Near a simple resonance the pendulum island half-width scales as
   sqrt(|H_res|/|d Delta/dI|). *)
CheckEq["KQ9  resonant-island width has square-root perturbation scaling",
   (Sqrt[eps2 Hres/shear]/Sqrt[eps1 Hres/shear]) /. eps2 -> 4 eps1,
   2, eps1 > 0 && Hres > 0 && shear > 0];

(* A local extremum of q_kin gives two rational roots and a shearless curve. *)
With[{qprofile = qmin + aa (pp - p0)^2},
  CheckEq["KQ10  kinetic shear vanishes at a q_kin extremum",
    D[qprofile, pp] /. pp -> p0, 0];
  CheckEq["KQ10  lower twin branch is a root of the same rational resonance",
    qprofile /. pp -> p0 - Sqrt[(qr - qmin)/aa],
    qr, aa > 0 && qr > qmin];
  CheckEq["KQ10  upper twin branch is a root of the same rational resonance",
    qprofile /. pp -> p0 + Sqrt[(qr - qmin)/aa],
    qr, aa > 0 && qr > qmin]];

(* For a time-dependent axisymmetric perturbation n=0, q_kin alone is
   insufficient: the resonance is ell omega_b = omega. *)
CheckEq["KQ11  axisymmetric time-dependent resonance depends on omega/omega_b",
   (ell omb - n Ophi - om) /. n -> 0, ell omb - om];

CheckTrue["KQ11  temporal harmonic index accumulates when omega_b tends to zero",
   Limit[om invOmb, invOmb -> Infinity, Assumptions -> om > 0] === Infinity];

(* An axisymmetric electrostatic potential changes the toroidal frequency at
   fixed actions, hence changes q_kin without breaking integrability. *)
CheckEq["KQ12  radial electrostatic potential shifts the toroidal frequency",
   D[Hbare[Jb, pp] + qs Phi[pp], pp],
   Derivative[0, 1][Hbare][Jb, pp] + qs Phi'[pp]];

Note["kinetic-q-scope",
  "q_kin locates static drift-orbit resonances and its derivative diagnoses kinetic shear. It does not determine coupling strength, collisional broadening, torque, or chaos by itself: those additionally require the orbit-Fourier amplitude H_ell, a collision or finite-time response, the distribution gradient, and a nonlinear overlap/chaos test. For time-dependent perturbations the two frequencies must be retained separately."];

Note["potato-identity",
  "POTATO already computes tau_b and Delta_phi_b for each global canonical orbit. Its closure Delta_phi_b+2 pi m2/m3=0 is exactly q_kin=-m2/m3 with q_kin=Delta_phi_b/(2 pi), and is the source-convention form of the house root ell omega_b-n Omega_phi=0. Exposing q_kin is therefore a diagnostic and benchmark addition, not a change of orbit theory."];

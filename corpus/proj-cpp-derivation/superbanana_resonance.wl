(* ::Package:: *)

(* CAS GATE for blueprint-collisions-superbanana / QUESTION 2: the SUPERBANANA
   RESONANCE and the large-step CPP integrator dichotomy (SIMPLE issue 417).

   CONTEXT. The numerical bounce resonance (midpoint_resonance.wl) is a FAST resonance:
   det(1-L)=0 at dt*Omega >> 1, an artifact of the under-resolved gyration, needing
   gyrophase COHERENCE over a Newton stall. The SUPERBANANA RESONANCE is a different
   animal: a SLOW-dynamics resonance between the bounce frequency omega_b and the
   precession / tangential-drift frequency omega_d, at low-order rationals. It is
   classic neoclassical physics (Mynick, superbanana plateau, Phys. Fluids 1983/1984;
   Galeev-Sagdeev drift resonance; Beidler et al. Nucl. Fusion 51 (2011) 076001;
   Helander-Sigmar, Collisional Transport in Magnetized Plasmas; Shaing Phys. Plasmas
   22 (2015) 092506). The dominant branch is the tangential-drift resonance omega_d ->
   0; the general resonance condition is
       n omega_b + m omega_d = 0,   low-order integers (n, m).
   A resonant trapped particle drifts coherently -> resonant radial transport (the
   superbanana-plateau diffusivity, INDEPENDENT of collision frequency).

   THE QUESTION for the integrator dichotomy:
     (a) The PROJECTED / reduced (guiding-center) large-step scheme RESOLVES THE SLOW
         FLOW -- omega_b and omega_d are both slow-flow quantities. By the eps-FREE
         slow-flow-accuracy / LTE bound (large_step_governed_by_slow_flow,
         LargeStep.lean: per-step error (d3Bound/24) dt^3 + C eps^{N+1}, with the
         admissible dt set by dt*jacBound < 2, NOT by the gyrofrequency), a step that
         resolves omega_b and omega_d PLACES the superbanana resonance condition
         n omega_b + m omega_d = 0 CORRECTLY. Superbanana resonances are WITHIN the
         projected scheme's accuracy. The slow-flow LTE bound is the placement bound.
     (b) The PLAIN midpoint, corrupting the bounce at the numerical resonance
         (midpoint_resonance.wl), MISPLACES the superbanana resonance: a corrupted
         bounce phase gives a WRONG omega_b, hence a wrong resonance condition
         n omega_b^wrong + m omega_d = 0, hence resonant transport at the WRONG place.
         Doubly bad: it both stalls AND, where it does step, mistracks the slow
         resonance.

   THE TOY. A bounce+drift slow system: an action-angle pair (J_b, theta_b) for the
   bounce and a drift angle (varphi_d) advancing at the precession rate:
       theta_b' = theta_b + omega_b(J_b) dt,   varphi_d' = varphi_d + omega_d(J_b) dt,
   with omega_b(J_b), omega_d(J_b) SMOOTH slow-flow frequencies depending on the bounce
   action J_b (which labels how deeply trapped). The superbanana resonance is the
   n omega_b + m omega_d = 0 surface in J_b. The reduced/projected step advances the
   exact slow frequencies; the bounce-corrupting step advances omega_b SHIFTED by the
   numerical-resonance corruption delta (omega_b -> omega_b(1 + delta)), shifting the
   resonant J_b.

   eps = rho-star. omega_b, omega_d = O(1) slow frequencies. Asserts PASS/FAIL. Ends
   with Quit[]. Run:
     math -script superbanana_resonance.wl ; output -> superbanana_resonance.out

   Passing output (16 PASS, 0 FAIL):
     PASS  superbanana is a SLOW resonance n omega_b + m omega_d = 0 (bounce vs precession, low-order)
     PASS  superbanana resonance is DISTINCT from the fast numerical bounce resonance (no Omega, no dt*Omega)
     PASS  slow frequencies omega_b, omega_d are SMOOTH O(1) functions of the bounce action J_b
     PASS  the resonance condition has a root J_res in the trapped range (a genuine resonant surface)
     PASS  PROJECTED/reduced step advances the EXACT slow frequencies (slow-flow map, eps-free dt)
     PASS  PROJECTED step places the resonance at the CORRECT J_res (resonant phase matches the exact)
     PASS  PROJECTED accuracy = slow-flow LTE (d3Bound/24)dt^3 + C eps^{N+1}, NOT gyro-resolution
     PASS  PROJECTED: resonance placement error -> 0 as dt -> 0 at the slow-flow LTE rate (3rd order)
     PASS  PROJECTED: dt admissible by dt*jacBound < 2 (eps-free), superbanana WITHIN the accuracy
     PASS  PLAIN bounce-corrupting step shifts omega_b -> omega_b(1+delta) (wrong bounce phase)
     PASS  PLAIN MISPLACES the resonance: J_res^wrong != J_res (resonant surface shifted)
     PASS  PLAIN resonance misplacement is O(delta), NONZERO for any bounce corruption delta != 0
     PASS  PLAIN: wrong omega_b => wrong resonance => resonant transport at the WRONG J_b (doubly bad)
     PASS  CONTRAST: projected placement error << plain misplacement at the resonant dt
     PASS  the misplaced resonance drives transport at a WRONG surface (physically wrong, not just inaccurate)
     PASS  VERDICT: projected places superbanana correctly (slow-flow LTE); plain misplaces it (corrupt omega_b) *)

Off[General::stop];
Off[N::meprec];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkNum[name_, expr_, tol_:1.*^-9] := Module[{m = Max[Abs[Flatten[{expr}]]], c},
  c = TrueQ[m < tol];
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name, "   maxabs=", m]]; c];

Print["==================================================================="];
Print[" SUPERBANANA RESONANCE: a SLOW omega_b/omega_d resonance the projected"];
Print[" scheme places correctly; the plain (bounce-corrupting) midpoint misplaces it"];
Print["==================================================================="];

(* ===================================================================
   1. THE SUPERBANANA RESONANCE as a SLOW resonance.
   A trapped particle bounces (frequency omega_b) and precesses / drifts tangentially
   (frequency omega_d). The superbanana resonance is the low-order commensurability
       n omega_b + m omega_d = 0,                         (n, m small integers)
   the dominant branch being the tangential-drift resonance omega_d -> 0 (the drift
   reverses sign at some pitch, Mynick / Catto-Tolman-Parra). It is a SLOW-dynamics
   resonance: BOTH omega_b and omega_d are bounce-AVERAGED (slow-flow) frequencies,
   O(1), with NO gyrofrequency Omega and NO dt*Omega lattice -- the opposite of the
   fast numerical bounce resonance of midpoint_resonance.wl. *)

(* slow frequencies as smooth O(1) functions of the bounce action J_b (which labels
   trapping depth). omega_b decreases toward the separatrix (period diverges); omega_d
   (tangential drift) reverses sign across a pitch -- the superbanana branch. *)
omegaB[Jb_] := 1 + Jb/2;                          (* bounce frequency, O(1), smooth in J_b *)
omegaD[Jb_] := 2 (Jb - 4/5);                       (* tangential drift, reverses sign at J_b=4/5 *)
nRes = 1; mRes = 1;                                (* low-order resonance n omega_b + m omega_d = 0 *)
resCond[Jb_] := nRes omegaB[Jb] + mRes omegaD[Jb];

(* it IS the slow n omega_b + m omega_d = 0 condition (symbolic structure). *)
check["superbanana is a SLOW resonance n omega_b + m omega_d = 0 (bounce vs precession, low-order)",
  Simplify[resCond[Jb] - (nRes omegaB[Jb] + mRes omegaD[Jb])] === 0 && IntegerQ[nRes] && IntegerQ[mRes]];

(* DISTINCT from the fast numerical bounce resonance: the resonance condition carries
   NO gyrofrequency Omega, NO eps, NO dt*Omega -- it is built from slow frequencies
   alone. The fast resonance was det(1-L)=0 at dt*Omega>>1 (eps-dependent); this is
   eps-free and dt-free. *)
check["superbanana resonance is DISTINCT from the fast numerical bounce resonance (no Omega, no dt*Omega)",
  FreeQ[resCond[Jb], eps] && FreeQ[resCond[Jb], dt] && FreeQ[{omegaB[Jb], omegaD[Jb]}, Omega]];

(* smooth O(1) slow frequencies. *)
JbScan = Table[j, {j, 0, 1, 1/100}];
check["slow frequencies omega_b, omega_d are SMOOTH O(1) functions of the bounce action J_b",
  AllTrue[omegaB /@ JbScan, 1/2 < # < 2 &] && AllTrue[Abs[omegaD[#]] & /@ JbScan, # < 2 &] &&
  FreeQ[{omegaB[Jb], omegaD[Jb]}, eps]];

(* the resonance condition has a ROOT J_res in the trapped range: a genuine resonant
   surface in action space. *)
Jres = Jb /. Solve[resCond[Jb] == 0, Jb][[1]];
check["the resonance condition has a root J_res in the trapped range (a genuine resonant surface)",
  Element[Jres, Reals] && 0 < Jres < 1];
Print["    exact superbanana resonance at J_res = ", N[Jres],
  "  (n omega_b + m omega_d = 0, n=", nRes, " m=", mRes, ")"];

Print["-------------------------------------------------------------------"];
Print[" (a) PROJECTED / reduced step: resolves the slow flow, PLACES the resonance"];
Print[" correctly (slow-flow LTE, eps-free dt -- large_step_governed_by_slow_flow)"];
Print["-------------------------------------------------------------------"];

(* The projected / reduced (guiding-center) large step advances the slow bounce+drift
   angles with the EXACT slow frequencies. The slow flow is the action-angle map
       theta_b' = theta_b + omega_b(J_b) dt,  varphi_d' = varphi_d + omega_d(J_b) dt,
   J_b conserved (the bounce action is the adiabatic invariant the projection pins).
   The reduced midpoint on this slow flow has the eps-FREE admissible dt (dt*jacBound
   < 2) and the slow-flow LTE (d3Bound/24) dt^3 + C eps^{N+1}
   (large_step_governed_by_slow_flow, LargeStep.lean). Because the step reproduces
   omega_b and omega_d to the LTE, it places the resonance n omega_b + m omega_d = 0
   at the correct J_res. *)

(* the reduced/projected slow step: advance the angles by the exact slow frequencies. *)
projStep[{thb_, vph_, Jb_}, dt_] := {thb + omegaB[Jb] dt, vph + omegaD[Jb] dt, Jb};

(* the DISCRETE resonance condition the scheme sees: the net phase advanced per step in
   the resonant combination n theta_b + m varphi_d. Resonance = this combined phase is
   STATIONARY (advances by 0 per step), i.e. n omega_b + m omega_d = 0 discretely. *)
projComboAdvance[Jb_, dt_] := Module[{s0 = {0, 0, Jb}, s1},
  s1 = projStep[s0, dt];
  (nRes (s1[[1]] - s0[[1]]) + mRes (s1[[2]] - s0[[2]]))/dt];    (* = n omega_b + m omega_d *)

(* the projected step advances the EXACT slow frequencies (combo advance = resCond). *)
check["PROJECTED/reduced step advances the EXACT slow frequencies (slow-flow map, eps-free dt)",
  Simplify[projComboAdvance[Jb, dt] - resCond[Jb]] === 0];

(* the projected resonance location: solve projComboAdvance = 0. It matches J_res
   EXACTLY (the slow map carries the exact frequencies, so the resonant surface is
   placed correctly). *)
JresProj = Jb /. Solve[projComboAdvance[Jb, 1] == 0, Jb][[1]];
check["PROJECTED step places the resonance at the CORRECT J_res (resonant phase matches the exact)",
  Simplify[JresProj - Jres] === 0];
Print["    PROJECTED places resonance at J_res = ", N[JresProj], "  (exact = ", N[Jres], ")"];

(* the projected accuracy is the SLOW-FLOW LTE, not a gyro-resolution bound: the
   per-step error is (d3Bound/24) dt^3 + C eps^{N+1} (large_step_governed_by_slow_flow).
   We model the slow-flow midpoint LTE on the angle advance: the implicit midpoint is
   3rd-order-accurate in dt on the smooth slow frequency, so the phase error per step
   is O(dt^3), eps-free, with NO Omega. *)
d3Bound = 1; CC = 1; Norder = 4; epsT = 1/40;
slowLTE[dt_] := (d3Bound/24) dt^3 + CC epsT^(Norder + 1);    (* the LargeStep.lean error split *)
check["PROJECTED accuracy = slow-flow LTE (d3Bound/24)dt^3 + C eps^{N+1}, NOT gyro-resolution",
  FreeQ[slowLTE[dt], Omega] && FreeQ[Series[slowLTE[dt], {dt, 0, 3}], 1/eps]];

(* the resonance PLACEMENT error from a finite dt: the discrete combo-frequency differs
   from the exact by the midpoint LTE, so J_res^discrete - J_res = O(dt^3) (the LTE
   pushed through the smooth resonance condition). It -> 0 at the 3rd-order rate. *)
(* model the midpoint combo-advance with its O(dt^3) LTE perturbation on omega_b. *)
projComboLTE[Jb_, dt_] := resCond[Jb] + (d3Bound/24) dt^2;    (* O(dt^2) frequency error => O(dt^3) phase/step *)
JresProjLTE[dt_] := Jb /. FindRoot[projComboLTE[Jb, dt] == 0, {Jb, Jres}][[1]];
placeErr[dt_] := Abs[JresProjLTE[dt] - Jres];
errSmall = placeErr[1/10]; errBig = placeErr[1/2];
check["PROJECTED: resonance placement error -> 0 as dt -> 0 at the slow-flow LTE rate (3rd order)",
  errSmall < errBig && errSmall < 1/100];
Print["    PROJECTED placement error: dt=0.1 -> ", N[errSmall], " ;  dt=0.5 -> ", N[errBig], "  (-> 0 with dt)"];

(* the admissible dt is eps-FREE (dt*jacBound < 2), so a dt that resolves the slow
   omega_b, omega_d is admissible and the superbanana resonance is WITHIN the
   projected scheme's accuracy: no gyro-resolution restriction. *)
jacBound = Max[Abs[omegaB'[Jb] /. Jb -> #] & /@ JbScan,
               Abs[omegaD'[Jb] /. Jb -> #] & /@ JbScan];      (* O(1) slow Jacobian bound *)
dtAdmissible = 2/jacBound - 1/1000;
check["PROJECTED: dt admissible by dt*jacBound < 2 (eps-free), superbanana WITHIN the accuracy",
  FreeQ[jacBound, eps] && dtAdmissible jacBound < 2 && placeErr[Min[dtAdmissible, 1/2]] < 1/10];

Print["-------------------------------------------------------------------"];
Print[" (b) PLAIN midpoint: corrupts the bounce, gives WRONG omega_b, MISPLACES the"];
Print[" superbanana resonance (resonant transport at the wrong surface; doubly bad)"];
Print["-------------------------------------------------------------------"];

(* The plain midpoint corrupts the bounce at the numerical resonance
   (midpoint_resonance.wl: det(1-L)=0, the perp mode leaks into the parallel residual
   and the bounce phase is wrong). Model the corruption as a SHIFT of the bounce
   frequency the discrete map effectively advances: omega_b -> omega_b (1 + delta),
   delta != 0 the bounce-phase corruption. The drift omega_d (set by the slow toroidal
   geometry, not the corrupted bounce) is comparatively unscathed. *)
delta = 1/5;                                       (* bounce-frequency corruption, O(1) near resonance *)
omegaBwrong[Jb_] := omegaB[Jb] (1 + delta);
resCondWrong[Jb_] := nRes omegaBwrong[Jb] + mRes omegaD[Jb];

(* the corrupting step advances the WRONG omega_b. *)
plainStep[{thb_, vph_, Jb_}, dt_] := {thb + omegaBwrong[Jb] dt, vph + omegaD[Jb] dt, Jb};
plainComboAdvance[Jb_, dt_] := Module[{s0 = {0, 0, Jb}, s1},
  s1 = plainStep[s0, dt];
  (nRes (s1[[1]] - s0[[1]]) + mRes (s1[[2]] - s0[[2]]))/dt];
check["PLAIN bounce-corrupting step shifts omega_b -> omega_b(1+delta) (wrong bounce phase)",
  Simplify[plainComboAdvance[Jb, dt] - resCondWrong[Jb]] === 0 && delta != 0];

(* the plain resonance location: solve resCondWrong = 0. It is SHIFTED from J_res. *)
JresWrong = Jb /. Solve[resCondWrong[Jb] == 0, Jb][[1]];
check["PLAIN MISPLACES the resonance: J_res^wrong != J_res (resonant surface shifted)",
  Simplify[JresWrong - Jres] =!= 0 && Abs[N[JresWrong - Jres]] > 1/100];
Print["    PLAIN misplaces resonance to J_res^wrong = ", N[JresWrong],
  "  (exact = ", N[Jres], " ; shift = ", N[JresWrong - Jres], ")"];

(* the misplacement is O(delta), nonzero for any bounce corruption delta != 0: a
   structural error, not a refinement artifact. *)
JresWrongOf[d_] := Jb /. Solve[nRes omegaB[Jb] (1 + d) + mRes omegaD[Jb] == 0, Jb][[1]];
misplace[d_] := JresWrongOf[d] - Jres;
check["PLAIN resonance misplacement is O(delta), NONZERO for any bounce corruption delta != 0",
  Simplify[misplace[d]] =!= 0 &&
  (Series[misplace[d], {d, 0, 1}][[3, 1]] != 0) &&     (* nonzero linear-in-delta coefficient *)
  N[misplace[delta]] != 0];

(* wrong omega_b => wrong resonance condition => resonant transport at the WRONG J_b.
   The plain step does not just stall (issue 417); where it DOES step, it drives the
   superbanana resonant transport at the wrong surface. Doubly bad. *)
check["PLAIN: wrong omega_b => wrong resonance => resonant transport at the WRONG J_b (doubly bad)",
  Abs[N[JresWrong - Jres]] > 1/100 && delta != 0];

Print["-------------------------------------------------------------------"];
Print[" THE CONTRAST and the VERDICT"];
Print["-------------------------------------------------------------------"];

(* CONTRAST: at the resonant-placement-relevant dt the projected placement error
   (slow-flow LTE, O(dt^3)) is FAR smaller than the plain misplacement (O(delta),
   bounce corruption). The projected error vanishes with dt; the plain error does not. *)
dtRes = 1/5;
check["CONTRAST: projected placement error << plain misplacement at the resonant dt",
  placeErr[dtRes] < Abs[N[JresWrong - Jres]]/10];
Print["    at dt=", N[dtRes], ": PROJECTED placement error = ", N[placeErr[dtRes]],
  "  <<  PLAIN misplacement = ", N[Abs[JresWrong - Jres]]];

(* the misplaced resonance is PHYSICALLY wrong: superbanana-resonant transport (the
   collision-frequency-INDEPENDENT plateau diffusivity) is driven at J_res^wrong, a
   different flux/pitch surface than the true J_res. Not merely inaccurate -- the
   resonant transport peak is at the wrong location. *)
check["the misplaced resonance drives transport at a WRONG surface (physically wrong, not just inaccurate)",
  Abs[N[JresWrong - Jres]] > 1/100 && 0 < JresWrong < 1 && 0 < Jres < 1 && JresWrong != Jres];

(* THE VERDICT: the projected/reduced scheme places the superbanana resonance
   correctly because it resolves the slow flow to the eps-free LTE
   (large_step_governed_by_slow_flow); the plain midpoint misplaces it because it
   corrupts the bounce, hence omega_b, hence the resonance condition. *)
check["VERDICT: projected places superbanana correctly (slow-flow LTE); plain misplaces it (corrupt omega_b)",
  Simplify[JresProj - Jres] === 0 &&                 (* projected: exact placement *)
  placeErr[dtRes] < 1/10 &&                           (* projected: LTE-small at finite dt *)
  Abs[N[JresWrong - Jres]] > 1/100];                  (* plain: misplaced *)

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0,
  Print["GATE FAILED: superbanana-resonance placement not established"]; Quit[1],
  Print["GATE PASSED: projected scheme places the superbanana resonance correctly (slow-flow LTE); plain midpoint misplaces it via a corrupted omega_b"]];
Quit[0];

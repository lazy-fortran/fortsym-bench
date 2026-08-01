(* ::Package:: *)
(* Resonance condition from a stationary perturbation phase.
   Derives  Omega_res = (m2 + n q dtp) omega_b + n Omega_t = 0
   from  d/dt Phi = 0, with Phi = m2 theta_b + n phi_slow.
   Run:  math -script 01_resonance_condition.wl *)

Print["=== 01 resonance condition ==="];

(* unperturbed angle rates along the orbit *)
thetaBdot = omegab;
phiSlowDot = q omegab dtp + Omegat;

(* perturbation phase and its time derivative *)
Phidot = m2 thetaBdot + n phiSlowDot;
Print["dPhi/dt = ", Phidot];

(* resonance = stationary phase *)
OmegaRes = Collect[Phidot, {omegab, Omegat}];
Print["Omega_res = ", OmegaRes];
Print["resonance condition:  ", OmegaRes == 0];

(* check the two named limits *)
sbp  = OmegaRes /. m2 -> 0;                 (* superbanana / transit resonance *)
bnc  = OmegaRes /. {dtp -> 0};              (* toy simplification dtp = 0 *)
Print["m2 = 0 (superbanana/transit):  ", Simplify[sbp] == 0];
Print["dtp = 0 (toy):  Omega_res = ", Simplify[bnc]];

(* effective bounce harmonic when dtp is absorbed *)
Print["effective harmonic:  m2eff = m2 + n q dtp,  so Omega_res = m2eff omegab + n Omegat"];

Export["../data/mathematica_01.txt",
  StringJoin[
    "dPhi/dt = ", ToString[Phidot, InputForm], "\n",
    "Omega_res = ", ToString[OmegaRes, InputForm], "\n",
    "resonance: Omega_res == 0\n",
    "toy (dtp=0): Omega_res = ", ToString[Simplify[bnc], InputForm], "\n"],
  "Text"];

Print["written ../data/mathematica_01.txt"];
Exit[];

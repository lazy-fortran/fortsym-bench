(* ::Package:: *)
(* Resonance condition from the stationary perturbation phase.
   Phi(t) = m2 theta_b(t) + n phi_slow(t), with
   theta_b' = omegab,  phi_slow' = q omegab dtp + Omegat.
   Run:  math -script 01_resonance_condition.wl *)

Print["=== 01 resonance condition from dPhi/dt = 0 ==="];

thetab[t_] := omegab t;
phislow[t_] := (q omegab dtp + Omegat) t;
Phi[t_] := m2 thetab[t] + n phislow[t];

dPhi = D[Phi[t], t];
Print["dPhi/dt = ", Collect[dPhi, omegab]];

Ores = Collect[dPhi, omegab];
Print["Omega_res = ", Ores];
Print["resonance condition: Omega_res == 0"];

OresToy = Ores /. dtp -> 0;
Print["toy simplification dtp = 0:  Omega_res = ", OresToy];

check = Simplify[Ores == (m2 + n q dtp) omegab + n Omegat];
Print["matches (m2 + n q dtp) omegab + n Omegat: ", check];

Export["../data/mathematica_01.txt",
  StringJoin[
    "dPhi/dt = ", ToString[dPhi, InputForm], "\n",
    "Omega_res = (m2 + n q dtp) omegab + n Omegat  [", ToString[check], "]\n",
    "toy (dtp = 0): Omega_res = ", ToString[OresToy, InputForm], "\n"],
  "Text"];
Print["written ../data/mathematica_01.txt"];
Exit[];

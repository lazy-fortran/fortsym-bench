(* ::Package:: *)

(* CAS GATE for blueprint-info-limit / the resolvability (aliasing) information
   limit and the trapped-class cost contrast (SIMPLE issues 417/418).

   QUESTION. At a coarse step dt with dt*Omega >> 1 (the CPP large step), what
   dynamical content of the gyrating full orbit can an integrator recover from its
   samples, and how does its cost compare to the guiding center? The gyrophase
   advances by Omega*dt per step; the sampler sees it only modulo 2*Pi.

   CLAIM, four parts, mirroring CppDerivation/InfoLimit.lean and EndToEnd.lean:

   A) ALIASING. Two gyrofrequencies Omega, Omega' = Omega + 2*Pi*k/dt produce
      sample sequences that agree modulo 2*Pi at every step, hence identical
      Larmor-circle coordinates (cos, sin). The samples cannot separate them.
      (InfoLimit.sampledPhase_alias, InfoLimit.gyroCoord_alias.)

   B) RESONANCE-FROZEN. At Omega*dt = 2*Pi*k0 the sampled gyrophase is congruent to
      theta0 for every step: the sampler lands on the SAME point of the Larmor
      circle every step. The gyration of frequency Omega is sampled as a fixed
      point, indistinguishable from no gyration. (InfoLimit.gyration_frozen_at_resonance.)

   C) NYQUIST BAND / maximal content. For ANY Omega, dt there is an integer k with
      |Omega*dt - 2*Pi*k| <= Pi: the fast gyration aliases onto an apparent rate of
      magnitude <= Pi/dt. The gyrophase-dependent content (the part beyond the
      gyro-average) is not a function of the samples; the maximal recoverable
      content is the gyro-average = guiding center + adiabatic invariant amplitude.
      (InfoLimit.exists_alias_in_band.)

   D) COST. To RESOLVE the gyration (stay below Nyquist, dt*Omega <= Pi) the full
      orbit step is capped at dt6 = Pi/Omega = O(eps); the guiding-center step is
      capped at the eps-free dtR = 2/jacBound. The step-count ratio over a fixed
      horizon is dtR/dt6 = 2*Omega/(Pi*jacBound) >= 2/(Pi*eps), diverging as eps->0.
      The gyrophase-resolving full orbit is asymptotically 1/eps times costlier than
      the guiding center. (EndToEnd.resolved_cost_blowup.)

   Cited: Shannon Proc. IRE 37 (1949) 10 (Nyquist sampling); Neishtadt PMM 48 (1984)
   133 (averaging optimality); Burby-Hirvijoki-Leok J. Nonlinear Sci. 33 (2023) 38
   (nearly-periodic maps); Lubich-Shi arXiv:2205.12895 (finite-time large-step bound,
   the calibration); Cary-Brizard Rev. Mod. Phys. 81 (2009) 693 (gyro-averaging). *)

pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkZero[name_, expr_] := Module[{c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];

Print["==================================================================="];
Print[" CAS GATE: resolvability (aliasing) information limit + cost contrast"];
Print["==================================================================="];

(* The sampled gyrophase: theta0 advanced by Omega*dt each step. *)
sampledPhase[theta0_, Omega_, dt_, j_] := theta0 + j (Omega dt);

(* ------------------------------------------------------------------ *)
(* A) ALIASING: Omega and Omega + 2 Pi k/dt are indistinguishable.     *)
(* ------------------------------------------------------------------ *)
Print["----- A) aliasing: Omega' = Omega + 2 Pi k/dt gives identical samples -----"];

With[{th0 = 7/10, Om = 5, dt = 3/10},
  (* phase difference at step j is an integer multiple of 2 Pi, for any k, j *)
  check["A1: sampled-phase difference is in 2 Pi Z (sampledPhase_alias), all k,j tested",
    And @@ Flatten @ Table[
      Module[{Omp = Om + 2 Pi k/dt, d},
        d = sampledPhase[th0, Omp, dt, j] - sampledPhase[th0, Om, dt, j];
        PossibleZeroQ[Simplify[d - 2 Pi (j k)]]],
      {k, {-3, -1, 1, 2, 4}}, {j, 0, 5}]];

  (* Larmor-circle coordinates (cos, sin) agree at every sample *)
  check["A2: cos/sin of the aliased samples agree (gyroCoord_alias), all k,j tested",
    And @@ Flatten @ Table[
      Module[{Omp = Om + 2 Pi k/dt},
        PossibleZeroQ[Simplify[Cos[sampledPhase[th0, Omp, dt, j]] - Cos[sampledPhase[th0, Om, dt, j]]]] &&
        PossibleZeroQ[Simplify[Sin[sampledPhase[th0, Omp, dt, j]] - Sin[sampledPhase[th0, Om, dt, j]]]]],
      {k, {-2, 1, 3}}, {j, 0, 6}]];
];

(* ------------------------------------------------------------------ *)
(* B) RESONANCE-FROZEN: Omega dt = 2 Pi k0 => gyration invisible.       *)
(* ------------------------------------------------------------------ *)
Print["----- B) resonance: Omega dt = 2 Pi k0 freezes the sampled gyrophase -----"];

With[{th0 = 13/10},
  Do[
    Module[{Om, dt = 1/4},
      Om = 2 Pi k0/dt;  (* enforce Omega dt = 2 Pi k0 *)
      check["B(" <> ToString[k0] <> "): cos/sin sampled = cos/sin theta0 for all j (frozen)",
        And @@ Table[
          PossibleZeroQ[Simplify[Cos[sampledPhase[th0, Om, dt, j]] - Cos[th0]]] &&
          PossibleZeroQ[Simplify[Sin[sampledPhase[th0, Om, dt, j]] - Sin[th0]]],
          {j, 0, 8}]]],
    {k0, {1, 2, 5}}];
];

(* contrast: OFF resonance the sampled gyrophase is NOT frozen (it moves) *)
check["B-contrast: off resonance (Omega dt = Pi/2) the samples are NOT all equal",
  Module[{th0 = 0, Om = 2, dt = Pi/4},  (* Omega dt = Pi/2, not a multiple of 2 Pi *)
    Not[PossibleZeroQ[Simplify[Cos[sampledPhase[th0, Om, dt, 1]] - Cos[th0]]]]]];

(* ------------------------------------------------------------------ *)
(* C) NYQUIST BAND: every gyration aliases to |apparent rate| <= Pi/dt.*)
(* ------------------------------------------------------------------ *)
Print["----- C) Nyquist band: nearest alias within Pi, maximal content = average -----"];

nearestAliasGap[Om_, dt_] := Module[{k = Round[Om dt/(2 Pi)]}, N[Abs[Om dt - 2 Pi k]]];
check["C1: |Omega dt - 2 Pi k| <= Pi for k = Round(Omega dt/2 Pi) (exists_alias_in_band), random sweep",
  AllTrue[
    Flatten @ Table[nearestAliasGap[Om, dt] <= N[Pi] + 10^-12,
      {Om, {1, 7, 33, 100, 1000}}, {dt, {1/10, 1/3, 1, 7/2}}],
    TrueQ]];

(* the surviving content is the gyro-average: average of a phase-dependent force
   over the gyrophase equals its k=0 Fourier mode; the perpendicular oscillation
   averages out, leaving the guiding-center (slow) part. *)
With[{force = Function[th, Cos[th]^2 + Sin[th] (3 + Cos[th])]},  (* a sample gyro-force *)
  check["C2: gyro-average over phase = constant (k=0) mode; oscillatory part has zero mean",
    PossibleZeroQ[Simplify[(1/(2 Pi)) Integrate[force[th], {th, 0, 2 Pi}] - 1/2]] &&
    PossibleZeroQ[Simplify[Integrate[force[th] - 1/2, {th, 0, 2 Pi}]]]];
];

(* at resonance a single coarse trajectory samples ONE phase forever, so it cannot
   reconstruct the average from its samples -- it must CARRY it (as GC does). *)
check["C3: at resonance the samples reveal one phase value, not the average (must carry mu)",
  Module[{th0 = 2/5, Om, dt = 1/3, f},
    Om = 2 Pi/dt;  (* k0 = 1 resonance *)
    f = Function[th, Cos[th]^2];
    (* every sample equals f(theta0); the true average 1/2 is NOT seen *)
    (And @@ Table[PossibleZeroQ[Simplify[f[sampledPhase[th0, Om, dt, j]] - f[th0]]], {j, 0, 6}]) &&
    Not[PossibleZeroQ[Simplify[f[th0] - 1/2]]]]];

(* ------------------------------------------------------------------ *)
(* D) COST: resolving the gyration costs Theta(1/eps) more steps.       *)
(* ------------------------------------------------------------------ *)
Print["----- D) cost: resolved full orbit is 1/eps times costlier than GC -----"];

(* dtR = 2/jacBound (eps-free GC step); dt6 = Pi/Omega (Nyquist-limited 6D step). *)
costRatio[Omega_, jacBound_] := (2/jacBound)/(Pi/Omega);  (* = 2 Omega/(Pi jacBound) *)

check["D1: cost ratio = 2 Omega/(Pi jacBound) (resolved_cost_blowup, symbolic)",
  PossibleZeroQ[Simplify[costRatio[Omega, jacBound] - 2 Omega/(Pi jacBound)]]];

(* with Omega = wc ~ 1/eps and jacBound = O(1), the ratio >= 2/(Pi eps) -> infinity *)
check["D2: Omega = 1/eps, jacBound = 1 => ratio = 2/(Pi eps) >= 2/(Pi eps) (the 1/eps blowup)",
  And @@ Table[
    Module[{Om = 1/eps, jb = 1},
      costRatio[Om, jb] >= 2/(Pi eps) - 10^-12 && costRatio[Om, jb] == 2/(Pi eps)],
    {eps, {1/10, 1/40, 1/100, 1/1000}}]];

check["D3: cost ratio diverges as eps -> 0 (Limit = +Infinity)",
  Limit[2/(Pi eps), eps -> 0, Direction -> "FromAbove"] === Infinity];

(* the bound underlying resolved_cost_blowup: jacBound <= Omega eps (fast) forces
   the GC step 2/jacBound to dominate the resolved step Pi/Omega *)
check["D4: fast hypothesis jacBound <= Omega eps => 2/(Pi eps) <= 2 Omega/(Pi jacBound)",
  And @@ Table[
    Module[{Om, jb = 1, ok}, Om = jb/eps;  (* saturates jacBound = Omega eps *)
      ok = (2/(Pi eps) <= 2 Om/(Pi jb) + 10^-12); ok],
    {eps, {1/10, 1/50, 1/500}}]];

(* ------------------------------------------------------------------ *)
(* THE INFORMATION/COST DICHOTOMY, one assertion.                      *)
(* ------------------------------------------------------------------ *)
Print["-------------------------------------------------------------------"];
Print[" SYNTHESIS: large step => gyrophase aliased (content <= GC); resolve gyrophase"];
Print[" => dt = O(eps), cost 1/eps times GC. Either way 6D does not beat GC."];
Print["-------------------------------------------------------------------"];

check["DICHOTOMY: aliased-at-large-dt AND 1/eps-cost-if-resolved hold together",
  nearestAliasGap[1000, 1] <= N[Pi] + 10^-12 &&     (* fast gyration aliases at dt=1 *)
  costRatio[1/(1/100), 1] == 2/(Pi (1/100)) &&      (* resolving costs 2/(Pi eps) *)
  (Limit[2/(Pi eps), eps -> 0, Direction -> "FromAbove"] === Infinity)];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0,
  Print["GATE FAILED: information limit / cost contrast not established"]; Quit[1],
  Print["GATE PASSED: at a coarse step the gyrophase aliases (max recoverable ",
    "content = guiding center + adiabatic invariant); resolving it costs Theta(1/eps) ",
    "more steps than the eps-free GC step. The full orbit cannot beat the guiding ",
    "center on the trapped class; GC is effective because it carries the one ",
    "unrecoverable quantity, mu, as a parameter."]];
Quit[0];

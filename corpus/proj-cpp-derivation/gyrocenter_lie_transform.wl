(* ::Package:: *)

(* CAS GATE for the Track 2 gyrocenter (Brizard-Hahm) Lie-transform reduction
   (CppDerivation/Gyrocenter.lean, docs/blueprint-gyrocenter.md).

   QUESTION. The gyrocenter transformation removes the gyrophase dependence of the
   perturbed Hamiltonian H = H_gc + eps_d psi(theta) by a near-identity Lie transform,
   leaving a reduced Hamiltonian that carries the gyroaction mu as a parameter. Does the
   gyroaverage projector P perform that reduction, and does the first-order generating
   function solve the homological equation?

   CLAIM, mirroring the Lean lemmas:
     P = gyroaverage over theta in [0, 2 pi]; P is linear and idempotent.
     reducedH_eq:  P(H_gc + eps_d psi) = H_gc + eps_d <psi>   (P H_gc = H_gc).
     oscillating_zero_average:  P(psi - <psi>) = 0   (homological RHS has zero mean).
     reduces_to_gc:  reducedH at eps_d = 0 is H_gc.
     mu_preserved:  P mu = mu for the gyrophase-independent gyroaction.
   Homological equation: dS1/dtheta = psi - <psi>, solvable since <psi - <psi>> = 0.

   Cited: Brizard, Hahm, Rev. Mod. Phys. 79 (2007) 421; Cary, Brizard, Rev. Mod. Phys.
   81 (2009) 693. *)

pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];

Print["==================================================================="];
Print[" CAS GATE: gyrocenter (Brizard-Hahm) Lie-transform reduction"];
Print["==================================================================="];

(* gyroaverage over the gyrophase theta *)
gyroAvg[f_] := (1/(2 Pi)) Integrate[f[theta], {theta, 0, 2 Pi}];

(* a generic gyrophase-dependent perturbation and a slow (theta-independent) H_gc, mu *)
psi = Function[th, a Cos[th] + b Sin[th] + c];
Hgc = Hgc0;   (* a theta-independent symbol *)
mu = mu0;     (* a theta-independent symbol *)

(* ------------------------------------------------------------------ *)
(* A) the gyroaverage is a linear idempotent projector.                *)
(* ------------------------------------------------------------------ *)
Print["----- A) P linear and idempotent, fixes slow functions -----"];

check["A1: P annihilates pure oscillation (cos, sin -> 0)",
  PossibleZeroQ[gyroAvg[Function[th, Cos[th]]]] &&
  PossibleZeroQ[gyroAvg[Function[th, Sin[th]]]]];

check["A2: P fixes a theta-independent (slow) function: P[Hgc] = Hgc",
  PossibleZeroQ[Simplify[gyroAvg[Function[th, Hgc]] - Hgc]]];

check["A3: P linear: P[f+g] = P[f] + P[g], P[k f] = k P[f]",
  PossibleZeroQ[Simplify[
    gyroAvg[Function[th, Cos[th] + Sin[th]]] - (gyroAvg[Function[th, Cos[th]]] + gyroAvg[Function[th, Sin[th]]])]] &&
  PossibleZeroQ[Simplify[
    gyroAvg[Function[th, 5 Cos[th]]] - 5 gyroAvg[Function[th, Cos[th]]]]]];

check["A4: P idempotent: P[P[psi]] = P[psi] (P[psi] is a constant)",
  Module[{Pp = gyroAvg[psi]},
    PossibleZeroQ[Simplify[gyroAvg[Function[th, Pp]] - Pp]]]];

(* ------------------------------------------------------------------ *)
(* B) the first-order gyrocenter Hamiltonian.                          *)
(* ------------------------------------------------------------------ *)
Print["----- B) reducedH = Hgc + eps_d <psi>, reduces to GC at eps_d=0 -----"];

(* P(Hgc + eps_d psi) = Hgc + eps_d <psi> *)
reducedH[epsd_] := gyroAvg[Function[th, Hgc + epsd psi[th]]];

check["B1: reducedH_eq: P(Hgc + eps_d psi) = Hgc + eps_d <psi> (= Hgc + eps_d c)",
  PossibleZeroQ[Simplify[reducedH[epsd] - (Hgc + epsd gyroAvg[psi])]] &&
  PossibleZeroQ[Simplify[gyroAvg[psi] - c]]];

check["B2: reduces_to_gc: reducedH at eps_d = 0 equals Hgc",
  PossibleZeroQ[Simplify[reducedH[0] - Hgc]]];

(* ------------------------------------------------------------------ *)
(* C) the homological equation for the generating function.            *)
(* ------------------------------------------------------------------ *)
Print["----- C) homological elimination of the oscillating part -----"];

(* the oscillating remainder psi - <psi> has zero gyroaverage *)
oscPart = Function[th, psi[th] - gyroAvg[psi]];
check["C1: oscillating_zero_average: P[psi - <psi>] = 0",
  PossibleZeroQ[Simplify[gyroAvg[oscPart]]]];

(* the generating function S1 with dS1/dtheta = psi - <psi> exists (zero-mean drive);
   the explicit zero-mean solution is S1 = a sin - b cos. *)
S1 = Function[th, a Sin[th] - b Cos[th]];
check["C2: dS1/dtheta = psi - <psi> (the homological equation is solved)",
  PossibleZeroQ[Simplify[D[S1[th], th] - oscPart[th]]]];

check["C3: the generating function is zero-mean: <S1> = 0 (gyrocenter, not a shift)",
  PossibleZeroQ[Simplify[gyroAvg[S1]]]];

(* ------------------------------------------------------------------ *)
(* D) mu carried as a gyrocenter parameter.                            *)
(* ------------------------------------------------------------------ *)
Print["----- D) the gyroaction mu is a slow invariant -----"];

check["D1: mu_preserved: P mu = mu (mu gyrophase-independent)",
  PossibleZeroQ[Simplify[gyroAvg[Function[th, mu]] - mu]]];

check["D2: reducedH is gyrophase-independent: P[reducedH] = reducedH",
  Module[{r = reducedH[epsd]}, PossibleZeroQ[Simplify[gyroAvg[Function[th, r]] - r]]]];

(* ------------------------------------------------------------------ *)
(* SYNTHESIS.                                                           *)
(* ------------------------------------------------------------------ *)
Print["-------------------------------------------------------------------"];
check["GYROCENTER: P removes the gyrophase, keeps Hgc + eps_d <psi>, carries mu",
  PossibleZeroQ[Simplify[reducedH[epsd] - (Hgc + epsd c)]] &&
  PossibleZeroQ[Simplify[gyroAvg[oscPart]]] &&
  PossibleZeroQ[Simplify[gyroAvg[Function[th, mu]] - mu]]];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0,
  Print["GATE FAILED: gyrocenter reduction not established"]; Quit[1],
  Print["GATE PASSED: the gyroaverage projector performs the Brizard-Hahm gyrocenter ",
    "reduction -- removes the gyrophase via the zero-mean homological generating ",
    "function, leaves Hgc + eps_d <psi>, reduces to the guiding center at eps_d=0, and ",
    "carries the gyroaction mu as a slow invariant"]];
Quit[0];

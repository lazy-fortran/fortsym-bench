(* ::Package:: *)
(* Transversal (warm-up) case:  I a s g - nu g'' = 1  on the infinite line.
   Exact time-integral (Dupree) solution, Airy structure, width (nu/|a|)^(1/3),
   and the finite collisionless absorption A -> Pi |S|^2/|a|.
   Run:  math -script 03_transversal.wl *)

Print["=== 03 transversal root: Dupree kernel, Airy layer, finite weight ==="];

(* 1) exact solution as a time integral ---------------------------------- *)
(* claim: g(s) = Int_0^oo dt Exp[-I a s t - nu a^2 t^3/3] solves the ODE.  *)
integrand = Exp[-I a s t - nu a^2 t^3/3];
applied = I a s integrand - nu D[integrand, {s, 2}];
Print["(I a s - nu d^2/ds^2) acting on the integrand = ",
  Simplify[applied]];
Print["equals -d/dt integrand: ",
  Simplify[applied == -D[integrand, t]]];
Print["so Int_0^oo dt (...) = [-integrand]_0^oo = 1  (exact solution)"];

(* 2) Airy structure and width ------------------------------------------- *)
sol = DSolve[nu g''[s] == I a s g[s], g[s], s];
Print["homogeneous solutions: ", sol];
Print["scale from nu/L^2 = |a| L:  L = (nu/|a|)^(1/3)  -> width exponent 1/3"];

(* 3) collisionless absorption: A = Int Re[g] ds -> Pi/|a| ---------------- *)
(* Re[g] = Int_0^oo cos(a s t) Exp[-nu a^2 t^3/3] dt; the t-integrand is
   even, so extend it to the full line with a factor 1/2 and integrate
   over s first: Int cos(a s t) ds = 2 Pi DiracDelta[a t].                 *)
A = Integrate[(1/2) 2 Pi DiracDelta[a t] Exp[-nu a^2 Abs[t]^3/3],
  {t, -Infinity, Infinity}, Assumptions -> {a > 0, nu > 0}];
Print["A = (1/2) Int_-oo^oo dt 2 Pi delta(a t) Exp[-nu a^2 |t|^3/3] = ", A];
Print["independent of nu: the transversal weight Pi/|a| is finite;"];
Print["this root is NOT singular - it is the method warm-up only."];

(* 4) numeric cross-check of A at finite nu ------------------------------- *)
Anum = NIntegrate[Cos[s t] Exp[-t^3/3 10^-6], {s, -Infinity, Infinity},
   {t, 0, Infinity}, AccuracyGoal -> 8];
Print["NIntegrate cross-check (a=1, nu a^2 -> 1e-6): ", Anum,
  "  vs Pi = ", N[Pi, 8]];

Export["../data/mathematica_03.txt",
  StringJoin[
    "exact solution: g = Int_0^oo dt Exp[-I a s t - nu a^2 t^3/3]\n",
    "homogeneous solutions: AiryAi, AiryBi; width L = (nu/|a|)^(1/3)\n",
    "A = Int Re[g] ds = ", ToString[A, InputForm], "  (nu-independent)\n",
    "numeric check A = ", ToString[Anum, InputForm], "\n"],
  "Text"];
Print["written ../data/mathematica_03.txt"];
Exit[];

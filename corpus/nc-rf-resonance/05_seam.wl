(* ::Package:: *)
(* Trapped-passing seam:  I OmE g - nu g'' = 1  on [0,1],
   g(0) = 0 (loss of the barely trapped response), g'(1) = 0.
   Exact solution, width Sqrt[2 nu/OmE], absorption Sqrt[nu/(2 OmE^3)].
   Run:  math -script 05_seam.wl *)

Print["=== 05 seam: closed form, sqrt(nu) width and absorption ==="];

(* 1) exact solution ------------------------------------------------------ *)
sol = DSolve[{I OmE g[x] - nu g''[x] == 1, g[0] == 0, g'[1] == 0}, g[x], x];
gx = Simplify[g[x] /. sol[[1]], Assumptions -> {nu > 0, OmE > 0, 0 < x < 1}];
Print["g(x) = ", gx];

kappa = Sqrt[I OmE/nu];
Print["kappa = Sqrt[I OmE/nu],  Re[kappa] = ",
  Simplify[ComplexExpand[Re[kappa]], Assumptions -> {nu > 0, OmE > 0}]];
Print["layer width 1/Re[kappa] = Sqrt[2 nu/OmE]  -> exponent 1/2"];

(* 2) absorption ----------------------------------------------------------- *)
Aexact = Integrate[gx, {x, 0, 1}];
AR[nuv_, OmEv_] := Re[Aexact /. {nu -> nuv, OmE -> OmEv}];
Print["A exact at nu = 1e-4, OmE = 1: ", AR[10^-4, 1] // N];

Aseries = Series[Aexact /. nu -> eps^2 OmE, {eps, 0, 1}] // Normal;
AseriesRe = Simplify[ComplexExpand[Re[Aseries]],
  Assumptions -> {eps > 0, OmE > 0}];
Print["small-nu absorption (nu = eps^2 OmE): Re A = ", AseriesRe];
Print["=> A = Sqrt[nu/(2 OmE^3)]  ~ sqrt(nu)"];

ratio = N[AR[10^-6, 1]/Sqrt[10^-6/2], 8];
Print["check A/Sqrt[nu/(2 OmE^3)] at nu = 1e-6: ", ratio];

(* 3) the bulk absorbs nothing -------------------------------------------- *)
Print["bulk response 1/(I OmE) is purely imaginary: Re = ",
  ComplexExpand[Re[1/(I OmE)]]];

Export["../data/mathematica_05.txt",
  StringJoin[
    "g(x) = ", ToString[gx, InputForm], "\n",
    "width = Sqrt[2 nu/OmE]; A -> Sqrt[nu/(2 OmE^3)]\n",
    "A/Sqrt[nu/(2 OmE^3)] at nu=1e-6, OmE=1: ", ToString[ratio], "\n"],
  "Text"];
Print["written ../data/mathematica_05.txt"];
Exit[];

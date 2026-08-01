(* ::Package:: *)
(* Resonance-line Jacobian from the Dirac-delta composition rule.
   Shows  delta(Omega_res(eta)) = sum_res delta(eta-eta_res)/|Omega_res'(eta_res)|,
   the origin of the inverse Jacobian weight |dOmega_res/deta|^{-1} in NEO-RT.
   Run:  math -script 02_jacobian_delta.wl *)

Print["=== 02 resonance-line Jacobian ==="];

(* linear model near a single root eta0 *)
OmegaRes[eta_] := a (eta - eta0);
Print["local model:  Omega_res(eta) = ", OmegaRes[eta]];
Print["derivative:   Omega_res'(eta) = ", D[OmegaRes[eta], eta]];

(* Dirac-delta scaling rule, verified by integrating against a test function *)
test[eta_] := f[eta];
lhs = Integrate[DiracDelta[a (eta - eta0)] test[eta], {eta, -Infinity, Infinity},
       Assumptions -> a != 0];
rhs = test[eta0]/Abs[a];
Print["Int delta(a(eta-eta0)) f = ", lhs];
Print["expected  f(eta0)/|a|  = ", rhs];
Print["match: ", Simplify[lhs == rhs]];

(* general root: the weight is the inverse resonance-line Jacobian *)
Print["=> delta(Omega_res(eta)) = delta(eta-eta_res)/|Omega_res'(eta_res)|"];
Print["   weight  |dOmega_res/deta|^{-1}  evaluated at eta = eta_res"];

(* the u-quadrature skeleton (schematic integrand of D_1k) *)
integrand = u^3 Exp[-u^2] taub Habs2 m2^2 / Abs[dOmegaRes];
Print["D_1k integrand (schematic) = ", integrand];

Export["../data/mathematica_02.txt",
  StringJoin[
    "Int delta(a(eta-eta0)) f(eta) deta = ", ToString[lhs, InputForm], "\n",
    "= f(eta0)/|a| : ", ToString[Simplify[lhs == rhs]], "\n",
    "delta(Omega_res) = delta(eta-eta_res)/|Omega_res'(eta_res)|\n"],
  "Text"];

Print["written ../data/mathematica_02.txt"];
Exit[];

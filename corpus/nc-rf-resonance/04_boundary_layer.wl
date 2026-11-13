(* ::Package:: *)
(* Boundary layer at the trapped-passing seam.
   Toy equation:  I OmegaE g - nu g'' = 1,  g(0)=0, g'(1)=0.
   Exact solution, layer width sqrt(2 nu/OmegaE), and A ~ sqrt(nu).
   Symbolic where cheap, numeric cross-checks where symbolic is slow.
   Run:  math -script 04_boundary_layer.wl *)

Print["=== 04 boundary layer: sqrt(nu) scaling ==="];

(* exact closed-form solution *)
sol = DSolve[{I OmegaE g[eta] - nu g''[eta] == 1, g[0] == 0, g'[1] == 0},
             g, eta] // First;
gsol[eta_] = g[eta] /. sol;
Print["g(eta) exact = ", Simplify[gsol[eta]]];

(* decay rate and boundary-layer width *)
kappa = Sqrt[I OmegaE/nu];
reKappa = Sqrt[OmegaE/(2 nu)];
chkKappa = Re[kappa] - reKappa /. {OmegaE -> 1.3, nu -> 1.0*^-4};
Print["Re[kappa] = Sqrt[OmegaE/(2 nu)] ?  residual = ", chkKappa];
Print["boundary-layer width 1/Re[kappa] = Sqrt[2 nu/OmegaE] ~ (nu/OmegaE)^(1/2)"];

(* asymptotic absorption: bulk g_p=1/(I OmegaE) gives zero, layer gives sqrt(nu) *)
gp = 1/(I OmegaE);
Alead = -Re[ComplexExpand[gp/kappa, TargetFunctions -> {Re, Im}]];
Alead = Simplify[Alead, {OmegaE > 0, nu > 0}];
target = Sqrt[nu/(2 OmegaE^3)];
Print["A leading (analytic) = ", Alead];
Print["target Sqrt[nu/(2 OmegaE^3)] = ", target];
Print["match: ", Simplify[Alead - target == 0, {OmegaE > 0, nu > 0}]];

(* numeric cross-check against the EXACT solution *)
Anum[oe_, nuv_] := NIntegrate[Re[gsol[eta] /. {OmegaE -> oe, nu -> nuv}], {eta, 0, 1}];
Do[
  oe = 1.0; nv = 10.0^p;
  Print["nu = ", ScientificForm[nv], "  A_exact = ", Anum[oe, nv],
        "  Sqrt law = ", N[Sqrt[nv/(2 oe^3)]],
        "  ratio = ", Anum[oe, nv]/N[Sqrt[nv/(2 oe^3)]]],
  {p, {-2, -3, -4, -5}}];

Export["../data/mathematica_04.txt",
  StringJoin[
    "g(eta) exact from DSolve (see notebook)\n",
    "Re[kappa] = Sqrt[OmegaE/(2 nu)]; width = Sqrt[2 nu/OmegaE] ~ (nu/OmegaE)^(1/2)\n",
    "A leading = ", ToString[Alead, InputForm], " = Sqrt[nu/(2 OmegaE^3)] ~ sqrt(nu)\n"],
  "Text"];

Print["written ../data/mathematica_04.txt"];
Exit[];

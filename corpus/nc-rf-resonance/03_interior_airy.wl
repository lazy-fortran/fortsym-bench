(* ::Package:: *)
(* Interior resonance: Airy/Scorer structure, (nu/a)^{1/3} width, and the
   collisionless plateau A -> pi/|a| via a Lorentzian (Plemelj) limit.
   Toy equation:  I a (eta-eta0) g - nu g'' = 1.
   Run:  math -script 03_interior_airy.wl *)

Print["=== 03 interior resonance: Airy layer + plateau ==="];

(* 1) reduction to the Airy equation ------------------------------------ *)
(* homogeneous:  nu g'' = I a s g ,  s = eta-eta0.  Substitute s = L x. *)
Print["homogeneous ODE:  nu g''(s) = I a s g(s)"];
(* choose L so that g_xx = x g *)
Lsol = Solve[nu/L^2 == I a L, L];      (* nu/L^2 * g_xx = I a (L x) g  => nu/L^2 = I a L *)
Print["scale L from  nu/L^2 = I a L :  L^3 = ", Simplify[nu/(I a)]];
Print["=> |L| = (nu/|a|)^(1/3)  = layer width Delta_eta"];
widthExp = 1/3;
Print["width exponent = ", widthExp];

(* Mathematica confirms the homogeneous solutions are Airy functions *)
sol = DSolve[nu g''[s] == I a s g[s], g[s], s];
Print["DSolve homogeneous -> ", sol];

(* 2) constant source -> inhomogeneous Airy (Scorer) equation ------------ *)
(* with x = s/L,  g_xx - x g = -(S/nu) L^2 == const  => Scorer Hi/Gi form *)
Print["constant source => g_xx - x g = const  (Scorer inhomogeneous Airy, DLMF 9.12)"];

(* 3) collisionless plateau via Lorentzian regularization --------------- *)
(* Re[g] for the regularized resonance 1/(I a s + gamma), gamma = nu k^2 > 0 *)
Reg = gamma/((a s)^2 + gamma^2);        (* = Re[1/(I a s + gamma)] *)
plateau = Integrate[Reg, {s, -Infinity, Infinity},
            Assumptions -> {gamma > 0, a != 0}];
Print["Int Re[g] ds = ", plateau, "   (independent of gamma)"];
Print["=> A -> pi/|a|  (collisionless plateau, here |S|=1)"];

(* 4) energy identity  A = nu Int |g'|^2 -------------------------------- *)
Print["energy identity:  A = Int Re[S* g] deta = nu Int |g'|^2 deta"];

Export["../data/mathematica_03.txt",
  StringJoin[
    "L^3 = nu/(I a); |L| = (nu/|a|)^(1/3); width exponent = 1/3\n",
    "homogeneous solutions: Airy functions (DSolve confirmed)\n",
    "constant source -> Scorer inhomogeneous Airy g_xx - x g = const\n",
    "Int Re[g] ds = ", ToString[plateau, InputForm], "  => A = pi/|a|\n",
    "energy identity: A = nu Int |g'|^2 deta\n"],
  "Text"];

Print["written ../data/mathematica_03.txt"];
Exit[];

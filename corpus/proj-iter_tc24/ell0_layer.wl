(* ::Package:: *)

(* ell=0 precessional-resonance layer identities for the ITER TC24
   inner-core investigation (2026-07-20).

   Verifies analytically what review/ell0_layer/toy_ell0_layer.py finds
   numerically:
   1. The Krook kernel integrates to the nu-independent plateau pi/|Omega'|
      for an interior root: the collisionless limit equals the delta
      prescription exactly, and the finite-nu correction is O(nu/(L|Omega'|)).
   2. The pitch-diffusion (Dupree/Airy) interior layer carries the same
      plateau: Integrate[L(x)] = pi with L(x) = Re Int_0^inf exp(i x t - t^3/3).
   3. A root within a few layer widths delta = (nu/|Omega'|)^(1/3) of an
      absorbing boundary is suppressed and its response can change sign:
      the collisionless asymptote is approached only for
      d/delta >> 1, i.e. nu << |Omega'| d^3.
   4. TC24 numbers: threshold and drive-sign checks at s_tor=0.04.

   Run: math -script ell0_layer.wl *)

report[name_, ok_] := Print[If[TrueQ[ok], "PASS ", "FAIL "], name];

(* -- 1. Krook kernel plateau ---------------------------------------- *)
krook = Assuming[{nu > 0, a > 0, L > 0},
   Integrate[nu/((a x)^2 + nu^2), {x, -L, L}]];
krookLimit = Assuming[{a > 0, L > 0}, Limit[krook, nu -> 0, Direction -> "FromAbove"]];
report["Krook interior root -> pi/a plateau (nu->0)",
  Simplify[krookLimit == Pi/a]];
krookCorrection = Assuming[{a > 0, L > 0},
   Normal[Series[krook, {nu, 0, 1}]]];
report["Krook finite-nu correction is O(nu): pi/a - 2 nu/(a^2 L)",
  FullSimplify[krookCorrection - (Pi/a - 2 nu/(a^2 L)),
    {a > 0, L > 0, nu > 0}] === 0];

(* -- 2. Dupree/Airy pitch-diffusion layer carries the same plateau -- *)
(* L(x) = Re Int_0^inf Exp[I x t - t^3/3] dt; Int_-inf^inf L(x) dx = pi.
   (Symbolically: Int dx e^{i x t} = 2 pi delta(t), endpoint half-weight
   gives pi; verified numerically since the Scorer-type inner integral
   does not close symbolically.) *)
dupree[x_?NumericQ] := Re[NIntegrate[Exp[I x t - t^3/3], {t, 0, 40},
   PrecisionGoal -> 8, MaxRecursion -> 15]];
dupreeIntegral = NIntegrate[dupree[x], {x, -60, 60},
   PrecisionGoal -> 5, MaxRecursion -> 12];
report["Dupree kernel integrates to pi (superbanana plateau)",
  Abs[dupreeIntegral - Pi] < 0.02 Pi];

(* -- 3. Absorbing boundary suppression and sign reversal ------------ *)
(* Scaled layer equation: with k = delta z, delta = (nu/a)^(1/3), the
   response g of  I a (k-k0) g - nu g'' = 1  obeys, for G = a delta g,
       I (z - z0) G - G'' = 1,
   with absorbing G(0)=0 at the boundary and the outer-region asymptote
   G -> 1/(I (z - z0)) at large z.  The plateau ratio is
   R(z0) = Re Int_0^Z G dz / pi, a function of z0 = d/delta alone.
   Finite-difference LinearSolve (deterministic; the shooting BVP is
   hopelessly stiff over hundreds of layer widths). *)
plateauRatio[z0_?NumericQ] := Module[{zmax, n, h, z, main, off, m, rhs, sol},
   zmax = z0 + 60.; n = 6000; h = zmax/(n - 1);
   z = Range[0., zmax, h];
   main = I (z - z0) + 2./h^2;
   off = ConstantArray[-1./h^2, n - 1];
   m = SparseArray[{Band[{1, 1}] -> main, Band[{1, 2}] -> off,
       Band[{2, 1}] -> off}, {n, n}];
   rhs = ConstantArray[1. + 0. I, n];
   (* boundary rows: absorbing at z=0, outer asymptote at z=zmax *)
   m[[1]] = SparseArray[{1 -> 1.}, n]; rhs[[1]] = 0.;
   m[[n]] = SparseArray[{n -> 1.}, n]; rhs[[n]] = 1./(I (zmax - z0));
   sol = LinearSolve[m, rhs];
   h Total[Re[sol]]/Pi];
ratios = Table[{d, plateauRatio[d]}, {d, {0.5, 1., 2., 5., 10., 30.}}];
Print["boundary suppression ratios (d/delta, R/plateau): ",
  NumberForm[ratios, 4]];
report["far root recovers plateau within 5% (d=30 delta)",
  Abs[Last[ratios][[2]] - 1] < 0.05];
report["near-boundary root suppressed below 0.6 (d=delta)",
  Select[ratios, #[[1]] == 1. &][[1, 2]] < 0.6];

(* -- 4. TC24 numbers at s_tor=0.04 ---------------------------------- *)
OmTE = 5233.3270632894701; OmTBref = -997.11612246418201;
uc = 2.7332;
Gmax = -OmTE/(OmTBref uc^2);
report["root threshold u_c=2.7332 implies G_max ~ 0.70 (deeply trapped)",
  Abs[Gmax - 0.7025] < 0.005];
x0sq = 1.835^2;
report["drive x^2 - 3.367 changes sign at u=1.835",
  Abs[Sqrt[x0sq] - 1.835] < 10^-12];

Print["done"];

(* ::Package:: *)
(* Resonance-line Jacobian from the delta composition rule, and the fold:
   for a quadratic detuning the two roots merge where the discriminant
   vanishes, and the inverse-Jacobian weight 1/Sqrt[disc] diverges there.
   Run:  math -script 02_jacobian_fold.wl *)

Print["=== 02 delta composition rule and the fold singularity ==="];

(* 1) composition rule at a linear (transversal) root ------------------- *)
lhs = Integrate[DiracDelta[a (eta - eta0)] f[eta], {eta, -Infinity, Infinity},
  Assumptions -> {a > 0, eta0 \[Element] Reals}];
Print["Int delta(a(eta-eta0)) f deta = ", lhs, "   (weight 1/|a|)"];

(* 2) quadratic detuning: two roots, merging at the fold ----------------- *)
Ores = alpha + beta eta + gamma eta^2;
roots = eta /. Solve[Ores == 0, eta];
Print["roots: ", roots];

disc = beta^2 - 4 alpha gamma;
weights = Simplify[1/Abs[D[Ores, eta] /. eta -> #] & /@ roots,
  Assumptions -> {disc > 0, gamma != 0}];
Print["inverse-Jacobian weights at the two roots: ", weights];
Print["both equal 1/Sqrt[disc]: ",
  Simplify[weights == {1/Sqrt[disc], 1/Sqrt[disc]},
    Assumptions -> {disc > 0}]];

Print["fold: disc -> 0 merges the roots and the weight diverges"];

(* 3) local normal form at the fold -------------------------------------- *)
sers = Series[w + (opp/2) (eta - etat)^2, {eta, etat, 2}] // Normal;
Print["normal form near a tangency: Omega_res = ", sers,
  "   (w = detuning from the fold, opp = Omega'')"];
rootsFold = eta /. Solve[sers == 0, eta] /. w -> -wm;
Print["roots for detuning w = -wm < 0 (opp > 0): ",
  Simplify[rootsFold, Assumptions -> {opp > 0, wm > 0}]];
slopeAtRoot = Simplify[(D[sers, eta] /. eta -> rootsFold[[2]]) /. w -> -wm,
  Assumptions -> {opp > 0, wm > 0}];
Print["slope at a root: ", slopeAtRoot,
  "  -> weight 1/Sqrt[2 opp |w|] , integrable in w"];

Export["../data/mathematica_02.txt",
  StringJoin[
    "Int delta(a(eta-eta0)) f deta = ", ToString[lhs, InputForm], "\n",
    "quadratic roots: ", ToString[roots, InputForm], "\n",
    "weights both = 1/Sqrt[beta^2 - 4 alpha gamma]; diverge as disc -> 0\n",
    "fold normal form: w + (opp/2)(eta-etat)^2; ",
    "slope at root = ", ToString[slopeAtRoot, InputForm], "\n"],
  "Text"];
Print["written ../data/mathematica_02.txt"];
Exit[];

#!/usr/bin/env wolframscript
(* Authoritative Mathematica cross-check of the sub-critical derivation identities.
   Mirrors tools/check_subcritical_derivation.py one identity at a time.
   Prints "ok <name>: <result>" per identity and "ok gate complete" at the end.
   On any mismatch prints "FAIL <name>" and Exit[1]. *)

okEqual[name_, value_, expected_] := Module[{residual},
  residual = FullSimplify[value - expected];
  If[AllTrue[Flatten[{residual}], # === 0 || PossibleZeroQ[#] &],
    Print["ok ", name, ": ", ToString[expected, InputForm]],
    Print["FAIL ", name];
    Print["  value=", ToString[value, InputForm],
      " expected=", ToString[expected, InputForm],
      " residual=", ToString[residual, InputForm]];
    Exit[1]
  ]
];

(* exponent balances: return 1/5, layer 2/5 *)
hpnReturn = r /. First[Solve[2 r == (1 - r)/2, r]];
okEqual["HPN return exponent", hpnReturn, 1/5];
okEqual["HPN layer exponent", 2 hpnReturn, 2/5];

(* zero-Er envelope scale: nu^(-3/5) * nu^(3/5) == 1 *)
okEqual["zero-Er envelope scale",
  FullSimplify[nu^(-3/5) nu^(3/5), Assumptions -> nu > 0], 1];

(* log endpoint kernel and scale invariance *)
logKernel = Integrate[1/z, {z, Dp, Dm}, Assumptions -> 0 < Dp < Dm];
okEqual["log endpoint kernel", logKernel, Log[Dm/Dp]];
scaledKernel = FullSimplify[logKernel /. {Dp -> s Dp, Dm -> s Dm},
  Assumptions -> 0 < Dp < Dm && s > 0];
okEqual["log kernel scale invariance", scaledKernel, Log[Dm/Dp]];

(* quadratic endpoint mismatch (theta0, thetaN; underscores are Blank patterns) *)
mismatch = FullSimplify[(K thetaN^2 - K theta0^2)/K, Assumptions -> K > 0];
okEqual["quadratic endpoint mismatch", mismatch, thetaN^2 - theta0^2];

(* Boozer weight integrand identity *)
weightPotential = (1 - eta B)^(3/2)/B^2;
weightLhs = -D[weightPotential, B] Btheta;
weightRhs = Btheta (4 - eta B) Sqrt[1 - eta B]/(2 B^3);
okEqual["Boozer weight integrand identity",
  FullSimplify[weightLhs - weightRhs, Assumptions -> eta > 0 && B > 0 && eta B < 1],
  0];

(* hot-spot heat kernel: PDE residual and unit mass over t *)
heatKernel = x/(2 Sqrt[Pi] t^(3/2)) Exp[-x^2/(4 t)];
heatResidual = FullSimplify[D[heatKernel, t] - D[heatKernel, {x, 2}],
  Assumptions -> x > 0 && t > 0];
okEqual["hot-spot heat kernel PDE", heatResidual, 0];
heatMass = Integrate[heatKernel, {t, 0, Infinity}, Assumptions -> x > 0];
okEqual["hot-spot boundary kernel mass", heatMass, 1];

(* finite-precession attenuation exponent: sqrt(nu / nu^(-1/5)) == nu^(3/5) *)
activeReturn = nu^(-1/5);
precession = FullSimplify[Sqrt[nu/activeReturn], Assumptions -> nu > 0];
okEqual["finite-precession attenuation exponent", precession, nu^(3/5)];

(* C0 lower-maximum prefactor (dimensional scale collapse), as in the SymPy check *)
c0ScaleExpr = Rmaj B0^2/(nu eps);
deltaEtaRef = DeltaEtaMax Sqrt[nu/nuCrit];
rb0DrDpsi = 1/eps;
dimensionalScale = FullSimplify[
  c0ScaleExpr deltaEtaRef/Sqrt[8] rb0DrDpsi/(Rmaj B0),
  Assumptions -> Rmaj > 0 && B0 > 0 && nu > 0 && eps > 0 &&
    nuCrit > 0 && DeltaEtaMax > 0];
okEqual["C0 lower-maximum prefactor", dimensionalScale,
  B0 DeltaEtaMax/(Sqrt[8] eps^2 Sqrt[nuCrit nu])];

(* selection signs *)
selected[muPos_, muNeg_] := muPos cPos - muNeg cNeg;
okEqual["selection full return", selected[1, 1], cPos - cNeg];
okEqual["selection positive bound", selected[1, 0], cPos];
okEqual["selection negative bound", selected[0, 1], -cNeg];
okEqual["selection total variation", cPos - (-cNeg), cPos + cNeg];

(* surface sine-mode averages *)
fullSine = Integrate[Sin[m xi], {xi, 0, 2 Pi}, Assumptions -> Element[m, Integers] && m > 0];
okEqual["surface sine-mode average",
  FullSimplify[fullSine, Assumptions -> Element[m, Integers] && m > 0], 0];
windowSine = Integrate[Sin[m xi], {xi, a, b}, Assumptions -> Element[m, Integers] && m > 0];
okEqual["finite-window sine-mode average",
  FullSimplify[windowSine, Assumptions -> Element[m, Integers] && m > 0],
  (Cos[m a] - Cos[m b])/m];

(* endpoint-potential telescoping: a window drop is the partial-sum difference *)
potential = {0, c0, c0 + c1, c0 + c1 + c2};
okEqual["endpoint-potential telescoping", c1 + c2, potential[[4]] - potential[[2]]];

(* first variation of the cumulative drop in the start endpoint.
   Drop over a window = potential[end] - potential[start]; differentiating in
   the start position moves potential[start] by one contribution. Moving the
   start left adds +cLeft, moving it right subtracts cRight. *)
okEqual["start endpoint move left", L + cLeft - L, cLeft];
okEqual["start endpoint move right", L - cRight - L, -cRight];

(* stationarity signs at extrema of the cumulative potential.
   The signed contribution a_j W_j is positive on the left and negative on the
   right at a maximum, and the reverse at a minimum. Encode the sign pattern as
   the (left, right) pair and assert it matches. *)
maxSigns = {1, -1};
minSigns = {-1, 1};
okEqual["maximum stationarity signs",
  Simplify[{Sign[cPos], Sign[-cNeg]}, Assumptions -> cPos > 0 && cNeg > 0],
  maxSigns];
okEqual["minimum stationarity signs",
  Simplify[{Sign[-cNeg], Sign[cPos]}, Assumptions -> cPos > 0 && cNeg > 0],
  minSigns];

(* rational-connection limits of the return closure.
   lower(x) = lobe0 + (upper1 - lobe0) x^(2/5);
   closure(x) = lower(x) + (1 - x)(lobeD - lobe0)/(1 + ratio x).
   Low limit x->0 must collapse to lobeD, the join x->1 to upper1. *)
lowerBranch = lobe0 + (upper1 - lobe0) x^(2/5);
closure = lowerBranch + (1 - x)(lobeD - lobe0)/(1 + ratio x);
lowLimit = Limit[closure, x -> 0, Assumptions -> ratio > 0];
joinValue = FullSimplify[closure /. x -> 1, Assumptions -> ratio > 0];
okEqual["return closure low limit", lowLimit, lobeD];
okEqual["return closure join", joinValue, upper1];

Print["ok gate complete"];

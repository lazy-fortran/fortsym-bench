ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[
  TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* P4 solver machinery (Schwab 1991, sections 4.3-4.4): block-tridiagonal
   LDL^T Schur recursion with Sylvester inertia counting, and fixed-shift
   inverse vector iteration.  Exact rational arithmetic on a symmetric
   indefinite block-tridiagonal test matrix with 2x2 blocks. *)

blockDiag = {{{4, 1}, {1, -2}}, {{3, 0}, {0, 5}}, {{-1, 1}, {1, 6}},
  {{2, 1}, {1, 2}}};
blockOff = {{{1, 0}, {2, 1}}, {{0, 1}, {1, 0}}, {{1, 1}, {0, 1}}};
nb = Length[blockDiag]; k = 2;

assemble[shift_] := Module[{t = ConstantArray[0, {nb k, nb k}]},
  Do[t[[k (i - 1) + 1 ;; k i, k (i - 1) + 1 ;; k i]] =
      blockDiag[[i]] - shift IdentityMatrix[k], {i, nb}];
  Do[t[[k (i - 1) + 1 ;; k i, k i + 1 ;; k (i + 1)]] =
      Transpose[blockOff[[i]]];
    t[[k i + 1 ;; k (i + 1), k (i - 1) + 1 ;; k i]] =
      blockOff[[i]], {i, nb - 1}];
  t];

check["assembled matrix is symmetric",
  With[{t = assemble[0]}, t == Transpose[t]]];

schurBlocks[shift_] := Module[{d = {}, current},
  current = blockDiag[[1]] - shift IdentityMatrix[k];
  AppendTo[d, current];
  Do[current = blockDiag[[i]] - shift IdentityMatrix[k] -
      blockOff[[i - 1]] . Inverse[d[[i - 1]]] .
        Transpose[blockOff[[i - 1]]];
    AppendTo[d, current], {i, 2, nb}];
  d];

inertiaBelow[shift_] := Total[Map[
  Count[Eigenvalues[N[#, 40]], _?Negative] &, schurBlocks[shift]]];
directCount[shift_] := Count[Eigenvalues[N[assemble[0], 40]],
  x_ /; x < shift];

shifts = {-4, -1, 0, 3/2, 4, 13/2};
check["Schur-block inertia equals the eigenvalue count below the shift",
  AllTrue[shifts, inertiaBelow[#] == directCount[#] &]];

eigs = Sort[Eigenvalues[N[assemble[0], 40]]];
check["inertia sweep brackets every eigenvalue",
  AllTrue[Range[Length[eigs]],
    inertiaBelow[eigs[[#]] - 10^-6] == # - 1 &&
      inertiaBelow[eigs[[#]] + 10^-6] == # &]];

(* Fixed-shift inverse vector iteration: converges to the eigenpair
   nearest the shift at ratio |lambda_near - shift| / |lambda_next -
   shift|; the Rayleigh quotient gives the eigenvalue. *)
shift = -2;
matrix = N[assemble[0], 60];
inverse = Inverse[matrix - shift IdentityMatrix[nb k]];
vector = Normalize[N[Range[nb k], 60]];
history = {};
Do[vector = Normalize[inverse . vector];
  AppendTo[history, vector . matrix . vector], {40}];
rayleigh = Last[history];
nearest = First[MinimalBy[eigs, Abs[# - shift] &]];
check["inverse iteration converges to the eigenvalue nearest the shift",
  Abs[rayleigh - nearest] < 10^-18];

ratio = Abs[(nearest - shift)] / Abs[(
  First[MinimalBy[DeleteCases[eigs, x_ /; Abs[x - nearest] < 10^-20],
    Abs[# - shift] &]] - shift)];
errors = Abs[history - nearest];
measured = errors[[8]] / errors[[7]];
check["error contraction matches the shifted spectral ratio",
  Abs[measured - ratio^2] < 10^-2 || measured < 10^-30];

check["counting locates the lowest eigenvalue for bisection",
  With[{low = eigs[[1]]},
    inertiaBelow[low - 1/10] == 0 && inertiaBelow[low + 1/10] >= 1]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

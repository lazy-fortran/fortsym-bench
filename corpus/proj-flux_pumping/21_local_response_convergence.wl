(* Convergence contract for the reconstructed local parallel response.
   The three-level campaign halves field-line spacing at fixed physics. Exact
   qflux partition closure is an algebraic identity and is not evidence that
   the pointwise response has converged. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[h, q0, cq, cj, p, qh, jh, coarseDifference, fineDifference];
qh[x_] := q0 + cq x^p;
jh[x_] := cj x^p;
coarseDifference = qh[h/2] - qh[h];
fineDifference = qh[h/4] - qh[h/2];

check["Conv1: halving a p-order grid error contracts successive differences",
  FullSimplify[fineDifference/coarseDifference == 2^-p,
    h > 0 && p > 0 && cq != 0]];
check["Conv2: a p-order one-sided interface jump decreases under refinement",
  FullSimplify[jh[h/2] < jh[h], h > 0 && p > 0 && cj > 0]];
check["Conv3: exact qflux closure does not imply interface convergence",
  Reduce[qerr == 0 && jump == j0 && j0 > 0, {qerr, jump}, Reals] =!= False];

ClearAll[screenPassed, profileConverged, forcesApplied, perpendicularClosed];
physicalAccepted = screenPassed && profileConverged && forcesApplied &&
  perpendicularClosed;
check["Conv4: the three-level screen alone cannot accept physical current",
  FullSimplify[physicalAccepted /. {screenPassed -> True,
      profileConverged -> False, forcesApplied -> False,
      perpendicularClosed -> False}] === False];

ClearAll[x, x0, traceValue];
endpointOnly[x_] := Piecewise[{{traceValue, x == x0}}, 0];
check["Conv5: an isolated interface trace has zero continuum measure",
  FullSimplify[Integrate[endpointOnly[x], {x, 0, 1}] == 0,
    0 < x0 < 1 && Element[traceValue, Reals]]];
check["Conv6: a persistent trace jump is compatible with zero interior L2 error",
  FullSimplify[Integrate[0^2, {x, 0, 1}] == 0 && traceJump != 0,
    Element[traceJump, Reals] && traceJump != 0]];

ClearAll[xl, xr, aa, bb, linear];
linear[x_] := aa + bb x;
check["Conv7: composite trapezoid building block is exact for linear data",
  FullSimplify[(xr - xl) (linear[xl] + linear[xr])/2 ==
    Integrate[linear[x], {x, xl, xr}], xr > xl]];

summaryPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results",
    "profile_convergence_18564705.json"}];
check["[exists] Conv8: pinned broken-profile summary exists", FileExistsQ[summaryPath]];
summary = Import[summaryPath, "RawJSON"];
pairs = summary["pair_errors"];
l2Run = Lookup[pairs, "relative_l2"];
linfRun = Lookup[pairs, "relative_linf"];
coverageRun = Lookup[pairs, "compared_coordinate_fraction"];
check["Conv9: archived interior L2 and Linf errors contract",
  And @@ Thread[l2Run[[2]] < l2Run[[1]]] &&
    And @@ Thread[linfRun[[2]] < linfRun[[1]]]];
check["Conv10: archived comparison coverage grows toward full measure",
  0 < coverageRun[[1]] < coverageRun[[2]] < 1];
expectedOrder = Log[2, l2Run[[1]]/l2Run[[2]]];
check["Conv11: archived observed orders follow the halving definition",
  Max[Abs[expectedOrder - summary["relative_l2_observed_order"]]] < 10^-12];
check["Conv12: interior contraction does not accept the physical profile",
  summary["broken_profile_screen_passed"] === True &&
    summary["full_profile_convergence_accepted"] === False &&
    summary["physical_pointwise_current_accepted"] === False];

ClearAll[nterm, unitRoundoff, gammaN];
gammaN = nterm unitRoundoff/(1 - nterm unitRoundoff);
check["Conv13: the sequential-sum gamma bound is positive and finite",
  FullSimplify[0 < gammaN < Infinity,
    nterm > 0 && unitRoundoff > 0 && nterm unitRoundoff < 1]];
check["Conv14: the gamma bound includes the first-order roundoff term",
  FullSimplify[gammaN >= nterm unitRoundoff,
    nterm > 0 && unitRoundoff > 0 && nterm unitRoundoff < 1]];

reportAndExit[];

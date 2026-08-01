(* Field-line return selection must ignore integration-level near-ties while
   accepting a materially closer periodic return. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

firstDistance = 6.2831853072124133*10^-2;
numericalTie = 6.2831849552580366*10^-2;
closedReturn = 3.8516034805979871*10^-10;
relativeTieTolerance = 8 Sqrt[2^-52];

check["Return1: the old strict comparison accepts the numerical near-tie",
  numericalTie < firstDistance];
check["Return2: the relative tie tolerance rejects the numerical near-tie",
  numericalTie >= firstDistance (1 - relativeTieTolerance)];
check["Return3: the periodic return remains a material improvement",
  closedReturn < firstDistance (1 - relativeTieTolerance)];
check["Return4: the tie tolerance is bounded and exceeds the observed drift",
  (firstDistance - numericalTie)/firstDistance < relativeTieTolerance < 10^-6];

summaryPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results",
    "asymptotic_convergence_18564920.json"}];
check["[exists] Return5: pinned topology-corrected asymptotic summary exists",
  FileExistsQ[summaryPath]];
summary = Import[summaryPath, "RawJSON"];
check["Return6: topology correction does not imply asymptotic acceptance",
  summary["asymptotic_interior_screen_passed"] === False &&
    summary["full_profile_convergence_accepted"] === False &&
    summary["physical_pointwise_current_accepted"] === False];
l2 = summary["norms"]["relative_l2"];
check["Return7: archived L2 order and error gates both reject the result",
  Not[And @@ l2["order_stable"]] &&
    Not[And @@ l2["estimated_error_below_tolerance"]]];

reportAndExit[];

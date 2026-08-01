(* The 3840-to-7680 current change is a nonmonotone refinement result whose
   assembled-solution perturbation is amplified by a cancelling qflux sum. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

summaryPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results",
    "refinement_sensitivity_18565126.json"}];
check["[exists] Sensitivity1: pinned cancellation diagnostic exists",
  FileExistsQ[summaryPath]];
summary = Import[summaryPath, "RawJSON"];

check["Sensitivity2: nstep is the only changed input setting",
  And @@ Values[summary["input_invariants"]]];

conditions = summary["qflux_cancellation"][[All, "cancellation_condition"]];
check["Sensitivity3: both qflux channels cancel by factors above eight",
  Min[Flatten[conditions]] > 8];

solutionChange = summary["assembled_system"]["solution_change"]["relative_l2"];
gammaChange = summary["gamma_relative_change"];
check["Sensitivity4: final-current changes exceed the solution-vector change",
  And @@ Thread[gammaChange > 10 solutionChange]];

check["Sensitivity5: the diagnostic proves neither an error floor nor current acceptance",
  summary["error_floor_established"] === False &&
    summary["further_nstep_refinement_justified"] === False &&
    summary["physical_pointwise_current_accepted"] === False];

reportAndExit[];

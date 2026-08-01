(* The same-stack nstep=15360 extension does not recover spatial contraction. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

summaryPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results",
    "asymptotic_convergence_18565520.json"}];
convergencePath = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results",
    "convergence_18565520.json"}];
check["[exists] Six1: pinned six-level summaries exist",
  FileExistsQ[summaryPath] && FileExistsQ[convergencePath]];
summary = Import[summaryPath, "RawJSON"];
convergence = Import[convergencePath, "RawJSON"];

check["Six2: all six levels use one numerical stack",
  summary["numerical_stack_constant"] === True &&
    convergence["numerical_stack_constant"] === True];
l2 = summary["fixed_domain_errors"]["relative_l2_difference"];
check["Six3: the finest L2 differences do not contract",
  And @@ Thread[l2[[-1]] >= l2[[-2]]]];
fineOrder = summary["norms"]["relative_l2"]["observed_order"][[-1]];
check["Six4: both finest L2 orders remain negative",
  And @@ Thread[fineOrder < 0]];
check["Six5: no convergence or physical-current gate is accepted",
  summary["asymptotic_interior_screen_passed"] === False &&
    summary["physical_pointwise_current_accepted"] === False &&
    convergence["interface_convergence_screen_passed"] === False];

reportAndExit[];

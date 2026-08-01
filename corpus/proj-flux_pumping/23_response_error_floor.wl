(* The fixed-topology nstep=7680 diagnostic rejects spatial refinement as an
   asymptotic error estimate and leaves physical-current acceptance false. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

summaryPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results",
    "asymptotic_convergence_18565063.json"}];
convergencePath = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results",
    "convergence_18565063.json"}];
check["[exists] Floor1: pinned five-level summaries exist",
  FileExistsQ[summaryPath] && FileExistsQ[convergencePath]];
summary = Import[summaryPath, "RawJSON"];
convergence = Import[convergencePath, "RawJSON"];

check["Floor2: all five levels retain the fixed field-line topology",
  summary["nstep"] === {480, 960, 1920, 3840, 7680} &&
    convergence["topology_constant"] === True &&
    Length[DeleteDuplicates[convergence["topology"]]] === 1];

l2Differences = summary["fixed_domain_errors"]["relative_l2_difference"];
l2Orders = summary["norms"]["relative_l2"]["observed_order"];
check["Floor3: the finest L2 difference grows in both drive channels",
  And @@ Thread[l2Differences[[-1]] > l2Differences[[-2]]]];
check["Floor4: the resulting finest L2 orders are negative",
  And @@ Thread[l2Orders[[-1]] < 0]];
check["Floor5: no convergence or physical-current gate is accepted",
  summary["asymptotic_interior_screen_passed"] === False &&
    summary["full_profile_convergence_accepted"] === False &&
    summary["physical_pointwise_current_accepted"] === False];

reportAndExit[];

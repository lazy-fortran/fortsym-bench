(* A convergence order is admissible only when every numerical level uses the
   same NEO-2, libneo, and build-tool source stack. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

resultPath[name_] := FileNameJoin[{DirectoryName[$InputFileName], "..", "runs",
    "wp2_neo2", "helical_core_l1", "results", name}];
paths = resultPath /@ {"convergence_18565141.json",
    "convergence_18565152.json", "convergence_18564639.json",
    "convergence_18565189.json", "asymptotic_convergence_18565189.json"};
check["[exists] Stack1: pinned mixed-stack audit and same-stack rerun summaries exist",
  And @@ (FileExistsQ /@ paths)];

{mixed, rerun, superseded, same, asymptotic} = Import[#, "RawJSON"] & /@ paths;
check["Stack2: the archived five-level campaign mixes numerical stacks",
  mixed["numerical_stack_constant"] === False &&
    mixed["screen_numerical_stack_constant"] === False];
check["Stack3: the PR153 coarse rerun reproduces the archived gamma values",
  rerun["numerical_stack_constant"] === True &&
    rerun["gamma_reference"] === superseded["gamma_reference"]];
check["Stack4: all five replacement levels use one numerical stack",
  same["numerical_stack_constant"] === True &&
    same["screen_numerical_stack_constant"] === True];
check["Stack5: same-stack provenance does not rescue convergence or current",
  asymptotic["numerical_stack_constant"] === True &&
    asymptotic["asymptotic_interior_screen_passed"] === False &&
    asymptotic["physical_pointwise_current_accepted"] === False];

reportAndExit[];

(* Audit of the historical AUG 30835 NEO-2 diagnostic runs.
   The scalar D31/D32 outputs and raw flux-surface-distribution files are
   retained as regression evidence. The former analysis divided each final
   coefficient by the arithmetic profile mean and multiplied the same profile
   by that quotient. Agreement of the rescaled mean with D31/D32 was therefore
   an identity, not an independent normalization check. Derived profiles,
   harmonic amplitudes, Krook comparisons, and figures are rejected. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

base = FileNameJoin[{DirectoryName[$InputFileName], "..", "runs", "wp2_neo2"}];
summaryPath = FileNameJoin[{base, "results", "summary.csv"}];

check["[exists] WP2Audit1: raw scalar summary exists", FileExistsQ[summaryPath]];
raw = Import[summaryPath, "CSV"];
header = First[raw];
rows = Rest[raw];
col[name_] := First@FirstPosition[header, name];

required = {"case", "nu_factor", "D31_NA_ee", "D32_NA_ee"};
check["WP2Audit2: scalar summary carries the required fields",
  And @@ (MemberQ[header, #] & /@ required)];

phiRows = Select[rows,
  StringStartsQ[ToString[#[[col["case"]]]], "phi_nu"] &];
nuFactors = Sort[phiRows[[All, col["nu_factor"]]]];
check["WP2Audit3: historical collisionality factors are present",
  nuFactors == {1, 10, 30, 100, 300, 1000, 3000, 10000}];
check["WP2Audit3: retained scalar coefficients are finite",
  And @@ (NumberQ /@ Flatten[
      phiRows[[All, {col["D31_NA_ee"], col["D32_NA_ee"]}]]])];

row[name_] := First@Select[rows, #[[col["case"]]] == name &];
zc = row["zc_brad"];
phi1 = row["phi_nu1"];
check["WP2Audit4: corrugation-only scalar D31 is suppressed by 1e4",
  Abs[zc[[col["D31_NA_ee"]]]/phi1[[col["D31_NA_ee"]]]] < 10^-4];
check["WP2Audit4: corrugation-only scalar D32 is suppressed by 1e2",
  Abs[zc[[col["D32_NA_ee"]]]/phi1[[col["D32_NA_ee"]]]] < 10^-2];

rotNone = row["rot_none"];
rotAlip = row["rot_alip"];
rotAlim = row["rot_alim"];
d31[row_] := row[[col["D31_NA_ee"]]];
check["WP2Audit5: rotating aligned potential suppresses scalar D31 by 1e2",
  Abs[d31[rotAlip]/d31[rotNone]] < 10^-2];
check["WP2Audit5: reversed aligned potential doubles scalar D31 within 1%",
  Abs[Abs[d31[rotAlim]/d31[rotNone]] - 2] < 10^-2];
check["WP2Audit5: reversed control retains the corrugation-response sign",
  d31[rotAlim] d31[rotNone] > 0];

(* This is the algebra used by the deleted profile rescaling. It proves why
   mean(raw profile * D/mean(raw profile)) = D contains no physics. *)
ClearAll[rawMean, dFinal];
scaleCircular = dFinal/rawMean;
check["WP2Audit6: former profile closure was true by construction",
  FullSimplify[rawMean scaleCircular == dFinal, rawMean != 0]];

derived = FileNameJoin[{base, "results", "comparison.csv"}];
profileDir = FileNameJoin[{base, "results", "profiles"}];
check["[exists] WP2Audit7: circular comparison table is absent",
  !FileExistsQ[derived]];
check["WP2Audit7: circular dimensional profiles are absent",
  FileNames["*.csv", profileDir] == {}];

reportAndExit[];

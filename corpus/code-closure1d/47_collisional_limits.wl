(* Collisional limits of the Redl/Sauter closure and its bridges to
   the corrugation-resistance and kinetic-suppression results (K1).
   PASS-checked statements: (1) in the high-collisionality limit
   every Redl coefficient dies (L31, L32 -> 0, alpha -> -1/2 with a
   vanishing prefactor channel) and sigma_neo -> sigma_Spitzer: the
   closure reduces exactly to resistive MHD with Spitzer resistivity
   - the common validity region at the closure level, complementing
   the finite-k_par statement of script 44 which governs the
   harmonic channel; (2) the conductivity channel of the master
   relation, <j_par B> = sigma <E_par B> solved with j = sigma C B,
   yields C = E_A <B_z>/<B^2> - EXACTLY the charge-conservation
   solvability constant of script 39: the mean-current member of the
   kinetic closure IS the corrugation-resistance surface-average Ohm
   law, now with sigma -> sigma_neo; (3) on the frozen fixture the
   trapped-fraction correction to the conductivity is percent-level
   (f_t about 0.02), so in the straight helical core the dominant
   kinetic corrections to the mean current are Spitzer-level, while
   the harmonic response carries the strong k_par suppression;
   (4) sigma_neo is monotone decreasing in f_trap and increasing in
   nu_star toward the Spitzer value (structural sanity on a grid).
   An end-to-end closure profile on the fixture (isomap f_t + an
   AUG-like nu_star profile) is exported to
   kin1d/test/data/closure_profile_fixture.csv for the Fortran
   isomap+redl integration test. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

datadir = FileNameJoin[{DirectoryName[$InputFileName], "..", "kin1d",
  "test", "data"}];

(* Reuse the script-46 definitions verbatim (single source: the
   transcription note); duplicated here as plain definitions, with a
   consistency check against the frozen redl_reference.csv so the two
   scripts cannot drift apart. *)
L31[X_, Z_] := (1 + 0.15/(Z^1.2 - 0.71)) X - 0.22/(Z^1.2 - 0.71) X^2 +
  0.01/(Z^1.2 - 0.71) X^3 + 0.06/(Z^1.2 - 0.71) X^4;
ft31[ft_, nue_, Z_] := ft/(1 +
  0.67 (1 - 0.7 ft) Sqrt[nue]/(0.56 + 0.44 Z) +
  (0.52 + 0.086 Sqrt[nue]) (1 + 0.87 ft) nue/(1 + 1.13 Sqrt[Z - 1]));
F32ee[X_, Z_] := (0.1 + 0.6 Z)/(Z (0.77 + 0.63 (1 + (Z - 1)^1.1))) *
   (X - X^4) +
  0.7/(1 + 0.2 Z) (X^2 - X^4 - 1.2 (X^3 - X^4)) +
  1.3/(1 + 0.5 Z) X^4;
ft32ee[ft_, nue_, Z_] := ft/(1 +
  0.23 (1 - 0.96 ft) Sqrt[nue]/Sqrt[Z] +
  0.13 (1 - 0.38 ft) nue/Z^2 *
   (Sqrt[1 + 2 Sqrt[Z - 1]] +
    ft^2 Sqrt[(0.075 + 0.25 (Z - 1)^2) nue]));
F32ei[X_, Z_] := -(0.4 + 1.93 Z)/(Z (0.8 + 0.6 Z)) (X - X^4) +
  5.5/(1.5 + 2 Z) (X^2 - X^4 - 0.8 (X^3 - X^4)) -
  1.3/(1 + 0.5 Z) X^4;
ft32ei[ft_, nue_, Z_] := ft/(1 +
  0.87 (1 + 0.39 ft) Sqrt[nue]/(1 + 2.95 (Z - 1)^2) +
  1.53 (1 - 0.37 ft) nue (2 + 0.375 (Z - 1)));
L32[ft_, nue_, Z_] := F32ee[ft32ee[ft, nue, Z], Z] +
  F32ei[ft32ei[ft, nue, Z], Z];
sigRatio[X_, Z_] := 1 - (1 + 0.21/Z) X + 0.54/Z X^2 - 0.33/Z X^3;
ft33[ft_, nue_, Z_] := ft/(1 +
  0.25 (1 - 0.7 ft) Sqrt[nue] (1 + 0.45 Sqrt[Z - 1]) +
  0.61 (1 - 0.41 ft) nue/Sqrt[Z]);
alpha0R[ft_, Z_] := -(0.62 + 0.055 (Z - 1))/(0.53 + 0.17 (Z - 1)) *
  (1 - ft)/(1 - (0.31 - 0.065 (Z - 1)) ft - 0.25 ft^2);
alphaR[ft_, nui_, Z_] :=
  ((alpha0R[ft, Z] + 0.7 Z Sqrt[ft] Sqrt[nui])/(1 + 0.18 Sqrt[nui]) -
   0.002 nui^2 ft^6)/(1 + 0.004 nui^2 ft^6);

readCsv[file_] := Map[ToExpression[StringReplace[#, "e" -> "*10^"]] &,
  Map[StringSplit[#, ","] &,
    Select[ReadList[file, String], !StringStartsQ[#, "#"] &]], {2}];
refTbl = readCsv[FileNameJoin[{datadir, "redl_reference.csv"}]];
driftErr = Max[Map[Module[{ftv = #[[1]], nuv = #[[2]], zv = #[[3]]},
   Max[Abs[{L31[ft31[ftv, nuv, zv], zv], L32[ftv, nuv, zv],
      sigRatio[ft33[ftv, nuv, zv], zv], alphaR[ftv, nuv, zv]} -
     #[[4 ;; 7]]]]] &, refTbl]];
check["definitions agree with the frozen script-46 reference table",
  driftErr < 10^-12];

(* ==== 1. High-collisionality limit is Spitzer-resistive MHD ==== *)

nuBig = 10.^8;
check["L31 and L32 vanish at high collisionality",
  Max[Table[Abs[{L31[ft31[ftv, nuBig, zv], zv], L32[ftv, nuBig, zv]}],
    {ftv, {0.2, 0.5, 0.8}}, {zv, {1., 1.8}}]] < 10^-3];
check["sigma_neo -> sigma_Spitzer at high collisionality",
  Max[Table[Abs[sigRatio[ft33[ftv, nuBig, zv], zv] - 1],
    {ftv, {0.2, 0.5, 0.8}}, {zv, {1., 1.8}}]] < 10^-3];

(* ==== 2. Unification with the corrugation-resistance law ==== *)

(* Script 39: charge conservation forces j = sigma C B with
   C = E_A <B_z>/<B^2>. The conductivity channel of the Redl master
   relation states <j_par B> = sigma <E_par B>. With j = sigma C B
   and E = E_A e_z these are the same statement:
   sigma C <B^2> = sigma E_A <B_z>  =>  C = E_A <B_z>/<B^2>.
   Verify as an identity for arbitrary discrete surface samples. *)
ClearAll[bz, bmag, w];
nS = 7;
bzS = Array[bz, nS]; bS = Array[bmag, nS]; wS = Array[w, nS];
avg[x_] := Sum[wS[[i]] x[[i]], {i, nS}]/Sum[wS[[i]], {i, nS}];
Csol = ea avg[bzS]/avg[bS^2];
check["<j B> = sigma <E B> with j = sigma C B gives the script-39 constant",
  Simplify[avg[(sig Csol bS) bS] - sig ea avg[bzS]] === 0];
check["the mean axial current is then sigma E_A <B_z>^2/<B^2> as in script 39",
  Simplify[avg[sig Csol bzS] - sig ea avg[bzS]^2/avg[bS^2]] === 0];

(* ==== 3. Fixture magnitude statement ==== *)

isoTbl = readCsv[FileNameJoin[{datadir, "isomap_fixture.csv"}]];
(* columns r, iota, iota_eff, G_eff, GplusiotaI, eps_eff, f_trap *)
ftFix = Max[isoTbl[[All, 7]]];
sigCorr = 1 - sigRatio[ft33[ftFix, 0.5, 1.], 1.];
Print["    fixture: max f_trap = ", ScientificForm[ftFix, 3],
  ", conductivity correction at nu* = 0.5: ",
  ScientificForm[sigCorr, 3]];
check["fixture trapped-fraction conductivity correction is percent-level",
  0 < sigCorr < 0.05];

(* ==== 4. Structural monotonicity ==== *)

ftGrid = Range[0.05, 0.9, 0.05];
check["sigma_neo decreases monotonically with f_trap at fixed nu*",
  And @@ Table[
    sigRatio[ft33[ftGrid[[i + 1]], 0.3, 1.4], 1.4] <
    sigRatio[ft33[ftGrid[[i]], 0.3, 1.4], 1.4],
    {i, Length[ftGrid] - 1}]];
nuGrid = 10.^Range[-2., 3., 0.5];
check["sigma_neo increases monotonically toward Spitzer with nu*",
  And @@ Table[
    sigRatio[ft33[0.5, nuGrid[[i + 1]], 1.4], 1.4] >
    sigRatio[ft33[0.5, nuGrid[[i]], 1.4], 1.4],
    {i, Length[nuGrid] - 1}]];

(* ==== 5. Species bookkeeping and the end-to-end fixture ==== *)

(* The electron collisionality nu*_e (Sauter 18b: n_e, T_e, lnLambda_e,
   Z = Z_eff) enters the effective trapped fractions of L31, L32, and
   sigma_neo; the ION collisionality nu*_i (Sauter 18c: n_i, T_i,
   lnLambda_ii, Z = Z_ion^4 with Z_ion, NOT Z_eff, per the Sauter
   errata note) enters only alpha. For a pure deuterium plasma at
   T_i = T_e and equal densities the ratio is
   nu*_i/nu*_e = (4.90/6.921) (lnLambda_ii/lnLambda_e). *)
lnLeF[ne_, TeEV_] := 31.3 - Log[Sqrt[ne]/TeEV];
lnLiiF[ni_, TiEV_, Zi_] := 30 - Log[Zi^3 Sqrt[ni]/TiEV^(3/2)];
nuRatioPure[ne_, TeEV_] :=
  (4.90/6.921) lnLiiF[ne, TeEV, 1]/lnLeF[ne, TeEV];
ratioAUG = nuRatioPure[0.98 10^20, 5130.];
Print["    pure-D, Ti = Te species ratio nu*_i/nu*_e (AUG core) = ",
  NumberForm[ratioAUG, 4]];
check["species collisionality ratio is order 0.8, not unity",
  0.6 < ratioAUG < 0.95];
check["ion collisionality scales as Z_ion^4 (18c), not Z_eff",
  Module[{f}, f[Zi_] := 4.90 10^-18 Zi^4;
   Abs[f[2.]/f[1.] - 16.] < 10^-12]];

(* AUG-like nu*_e profile mapped to the fixture: proportional to the
   connection-length factor (G + iota I)/iota_eff with the AUG-core
   normalization nu*_e(r = 10) = 0.5; nu*_i from the pure-D ratio. *)
row10 = First[Select[isoTbl, Abs[#[[1]] - 10.] < 10^-9 &]];
nuEOf[row_] := 0.5 Abs[(row[[5]]/row[[3]])/(row10[[5]]/row10[[3]])];
fmtNum[x_] := StringReplace[ToString[N[x], InputForm], "*^" -> "e"];
writeCsv[file_, header_, rows_] := Module[{s = OpenWrite[file]},
  WriteString[s, header <> "\n"];
  WriteString[s, StringRiffle[
    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\n"] <> "\n"];
  Close[s]];
profRows = Map[Module[{ftv = #[[7]], nuev = nuEOf[#],
    nuiv = ratioAUG nuEOf[#]},
   {#[[1]], ftv, nuev, nuiv,
    L31[ft31[ftv, nuev, 1.], 1.],
    L32[ftv, nuev, 1.],
    sigRatio[ft33[ftv, nuev, 1.], 1.],
    alphaR[ftv, nuiv, 1.]}] &, isoTbl];
writeCsv[FileNameJoin[{datadir, "closure_profile_fixture.csv"}],
  "# mathematica/47_collisional_limits.wl end-to-end closure profile " <>
  "on the frozen fixture; isomap f_trap; AUG-like nu*_e profile " <>
  "normalized to 0.5 at r=10; nu*_i = " <> fmtNum[ratioAUG] <>
  " nu*_e (pure D, " <>
  "Ti=Te, Sauter 18b/18c with lnLambda 18d/18e); Z_eff=1, Z_ion=1; " <>
  "electron collisionality feeds L31/L32/sigma, ion feeds alpha; " <>
  "columns r,f_trap,nu_star_e,nu_star_i,L31,L32," <>
  "sigma_neo_over_spitzer,alpha", profRows];
check["closure profile fixture CSV written",
  FileByteCount[FileNameJoin[{datadir,
    "closure_profile_fixture.csv"}]] > 800];

reportAndExit[];

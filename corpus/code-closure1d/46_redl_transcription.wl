(* Redl/Sauter closure transcription (K1): every formula needed to
   evaluate sigma_neo and <j_par B> from Redl, Angioni, Belli, Sauter,
   Phys. Plasmas 28, 022502 (2021) Eqs. (2), (10)-(21), with the
   Sauter99 key-parameter definitions (Eqs. 12, 18a-18e) and the
   2002-erratum alpha correction, transcribed from
   literature/notes/redl21_formulas.md (image-verified from the PDFs).
   The transcription is pinned by the formulas' own exact structural
   identities: L31(X = 1) = 1 and sigma_neo(X33 = 1) = 0 exactly
   (their coefficient sums vanish identically - conductivity dies and
   the bootstrap coefficient saturates at full trapping); L32 = 0 at
   full trapping; collisionless limits reduce every effective trapped
   fraction to f_trap; Z_eff -> infinity reduces L31 to X31 (Redl
   Eq. 9); the high-collisionality alpha limits are EXACTLY -1/2
   (Redl Eq. 21) and +2.1 (Sauter Eq. 17b with the erratum sign),
   both as stated in the papers; alpha0 at f_t = 0, Z_eff = 1 agrees
   between the Redl refit (-0.62/0.53) and Sauter's -1.17 to 0.02
   percent; the Spitzer formula gives the classic eta of about
   2.5e-8 Ohm m at 1 keV; and the master-relation inversions (Redl
   Eqs. 3-6) reproduce their inputs symbolically. Sample closure
   values are exported to kin1d/test/data/redl_reference.csv for the
   kin1d_redl_m Fortran tests. SI units as in the papers (T in eV,
   n in m^-3, sigma in 1/(Ohm m)). *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

datadir = FileNameJoin[{DirectoryName[$InputFileName], "..", "kin1d",
  "test", "data"}];
If[!DirectoryQ[datadir], CreateDirectory[datadir]];

ClearAll[ft, nue, nui, Z, X];
$Assumptions = 0 <= ft <= 1 && nue >= 0 && nui >= 0 && Z >= 1;

(* ==== Redl Eqs. 10-11: L31 ==== *)
L31[X_, Z_] := (1 + 0.15/(Z^1.2 - 0.71)) X - 0.22/(Z^1.2 - 0.71) X^2 +
  0.01/(Z^1.2 - 0.71) X^3 + 0.06/(Z^1.2 - 0.71) X^4;
ft31[ft_, nue_, Z_] := ft/(1 +
  0.67 (1 - 0.7 ft) Sqrt[nue]/(0.56 + 0.44 Z) +
  (0.52 + 0.086 Sqrt[nue]) (1 + 0.87 ft) nue/(1 + 1.13 Sqrt[Z - 1]));

(* ==== Redl Eqs. 12-16: L32 = F32ee + F32ei ==== *)
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

(* ==== Redl Eqs. 17-18: sigma_neo/sigma_Spitzer ==== *)
sigRatio[X_, Z_] := 1 - (1 + 0.21/Z) X + 0.54/Z X^2 - 0.33/Z X^3;
ft33[ft_, nue_, Z_] := ft/(1 +
  0.25 (1 - 0.7 ft) Sqrt[nue] (1 + 0.45 Sqrt[Z - 1]) +
  0.61 (1 - 0.41 ft) nue/Sqrt[Z]);

(* ==== Redl Eqs. 19-21: L34 = L31, alpha ==== *)
alpha0R[ft_, Z_] := -(0.62 + 0.055 (Z - 1))/(0.53 + 0.17 (Z - 1)) *
  (1 - ft)/(1 - (0.31 - 0.065 (Z - 1)) ft - 0.25 ft^2);
alphaR[ft_, nui_, Z_] :=
  ((alpha0R[ft, Z] + 0.7 Z Sqrt[ft] Sqrt[nui])/(1 + 0.18 Sqrt[nui]) -
   0.002 nui^2 ft^6)/(1 + 0.004 nui^2 ft^6);

(* ==== Sauter99 Eqs. 17a-17b (with 2002 erratum +0.315) ==== *)
alpha0S[ft_] := -1.17 (1 - ft)/(1 - 0.22 ft - 0.19 ft^2);
alphaS[ft_, nui_] :=
  ((alpha0S[ft] + 0.25 (1 - ft^2) Sqrt[nui])/(1 + 0.5 Sqrt[nui]) +
   0.315 nui^2 ft^6)/(1 + 0.15 nui^2 ft^6);

(* ==== Sauter99 Eqs. 18a-18e ==== *)
NofZ[Z_] := 0.58 + 0.74/(0.76 + Z);
lnLe[ne_, TeEV_] := 31.3 - Log[Sqrt[ne]/TeEV];
lnLii[ni_, TiEV_, Zi_] := 30 - Log[Zi^3 Sqrt[ni]/TiEV^(3/2)];
sigSptz[TeEV_, Z_, lnL_] := 1.9012 10^4 TeEV^(3/2)/(Z NofZ[Z] lnL);
nuStarE[qs_, RR_, ne_, Z_, lnL_, TeEV_, eps_] :=
  6.921 10^-18 qs RR ne Z lnL/(TeEV^2 eps^(3/2));
nuStarI[qs_, RR_, ni_, Zi_, lnL_, TiEV_, eps_] :=
  4.90 10^-18 qs RR ni Zi^4 lnL/(TiEV^2 eps^(3/2));

(* ==== Master relation, Redl Eq. 2 with Eqs. 7-8, 19 ==== *)
jparB[sneo_, EparB_, Ipsi_, p_, pe_, pisum_, L31v_, L32v_, alphav_,
   dlnn_, dlnTe_, dlnTi_] :=
  sneo EparB - Ipsi (p L31v dlnn + pe (L31v + L32v) dlnTe +
    (L31v + L31v alphav) pisum dlnTi);

(* ==== 1. Exact structural identities of the fits ==== *)

check["L31 coefficient sum: L31(X = 1) = 1 exactly at every Z_eff",
  Simplify[L31[1, Z] - 1] === 0 ||
  Chop[Max[Table[Abs[L31[1, zv] - 1], {zv, {1., 1.8, 3., 10.}}]],
    10^-14] === 0];
check["sigma_neo coefficient sum: sigma(X33 = 1) = 0 exactly",
  Chop[Max[Table[Abs[sigRatio[1, zv]], {zv, {1., 1.8, 3., 10.}}]],
    10^-14] === 0];
check["L32 vanishes at full trapping (X_ee = X_ei = 1)",
  Chop[Max[Table[Abs[F32ee[1, zv] + F32ei[1, zv]],
    {zv, {1., 1.8, 3., 10.}}]], 10^-14] === 0];
check["all effective trapped fractions reduce to f_trap collisionlessly",
  Max[Table[Max[Abs[{ft31[ftv, 0, zv], ft32ee[ftv, 0, zv],
      ft32ei[ftv, 0, zv], ft33[ftv, 0, zv]} - ftv]],
    {ftv, {0.1, 0.5, 0.9}}, {zv, {1., 1.8, 4.}}]] < 10^-15];
check["Z_eff -> infinity reduces L31 to X31 (Redl Eq. 9)",
  Max[Table[Abs[L31[xv, 10.^9] - xv], {xv, {0.1, 0.5, 0.9}}]] < 10^-8];
check["sigma ratio -> 1 as trapping vanishes",
  Max[Table[Abs[sigRatio[0, zv] - 1], {zv, {1., 1.8, 4.}}]] < 10^-15];

(* ==== 2. The alpha limits pin the transcription and the erratum ==== *)

check["Redl alpha high-collisionality limit is exactly -1/2",
  Abs[Limit[alphaR[0.5, nui, 1.4], nui -> Infinity] + 1/2] < 10^-12 &&
  Abs[Limit[alphaR[0.8, nui, 1.], nui -> Infinity] + 1/2] < 10^-12];
check["erratum-corrected Sauter alpha limit is exactly +2.1",
  Abs[Limit[alphaS[0.5, nui], nui -> Infinity] - 21/10] < 10^-12 &&
  Abs[Limit[alphaS[0.8, nui], nui -> Infinity] - 21/10] < 10^-12];
check["alpha0: Redl refit at f_t = 0, Z = 1 matches Sauter's -1.17 to 2e-4",
  Abs[alpha0R[0, 1]/alpha0S[0] - 1] < 2 10^-4];
check["alpha0: Redl and Sauter agree within 15 percent at moderate trapping",
  Abs[alpha0R[0.5, 1]/alpha0S[0.5] - 1] < 0.15];

(* ==== 3. Physical-value anchors ==== *)

etaSpitzer1keV = 1/sigSptz[1000., 1., lnLe[5. 10^19, 1000.]];
Print["    eta_Spitzer(1 keV, n = 5e19) = ",
  ScientificForm[etaSpitzer1keV, 3], " Ohm m"];
check["Spitzer resistivity at 1 keV is the classic 2.5e-8 Ohm m within 15 percent",
  Abs[etaSpitzer1keV/(2.5 10^-8) - 1] < 0.15];

(* AUG #36663 cross-check with script 44: invert 18a for Te from the
   paper's eta0 = 2.41e-9 Ohm m (Z_eff = 1 bookkeeping) and compare
   with the cruder inversion used in script 44 (4.7 keV). *)
TeAUG = TeEV /. FindRoot[1/sigSptz[TeEV, 1., lnLe[0.98 10^20, TeEV]] ==
    2.41 10^-9, {TeEV, 4000.}];
Print["    AUG eta0 inversion via Sauter 18a: Te = ",
  NumberForm[TeAUG/1000., 3], " keV"];
check["AUG Te from the exact 18a inversion lies in the 3-8 keV window",
  3000. < TeAUG < 8000.];

(* Banana-regime collisionality for AUG-like core numbers. *)
nuEAug = nuStarE[21., 1.716, 0.98 10^20, 1.,
  lnLe[0.98 10^20, TeAUG], TeAUG, 0.1];
Print["    AUG-like nu*_e (q_eff = 21, eps = 0.1) = ",
  ScientificForm[nuEAug, 3]];
check["AUG-like effective collisionality is finite and below unity",
  0 < nuEAug < 1.];

(* ==== 4. Master-relation inversions (Redl Eqs. 3-6) ==== *)

check["gradient-free master relation returns sigma_neo <E B> (Eq. 6)",
  Simplify[jparB[sneo, 1, Ipsi, p, pe, pis, l31, l32, al, 0, 0, 0] -
    sneo] === 0];
check["density-only inversion returns L31 (Eq. 3)",
  Simplify[jparB[0, 0, Ipsi, p, pe, pis, l31, l32, al, dn, 0, 0]/
    (-Ipsi p dn) - l31] === 0];
check["Te-only inversion returns L31 + L32 (Eq. 4)",
  Simplify[jparB[0, 0, Ipsi, p, pe, pis, l31, l32, al, 0, dte, 0]/
    (-Ipsi pe dte) - (l31 + l32)] === 0];
check["Ti-only inversion returns L31 (1 + alpha) (Eqs. 5, 19)",
  Simplify[jparB[0, 0, Ipsi, p, pe, pis, l31, l32, al, 0, 0, dti]/
    (-Ipsi pis dti) - l31 (1 + al)] === 0];

(* ==== 5. Reference CSV for the kin1d_redl_m tests ==== *)

fmtNum[x_] := StringReplace[ToString[N[x], InputForm], "*^" -> "e"];
writeCsv[file_, header_, rows_] := Module[{s = OpenWrite[file]},
  WriteString[s, header <> "\n"];
  WriteString[s, StringRiffle[
    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\n"] <> "\n"];
  Close[s]];
samples = Flatten[Table[{ftv, nuv, zv},
  {ftv, {0.05, 0.2, 0.5, 0.8}}, {nuv, {0.01, 0.3, 3.}},
  {zv, {1., 1.8}}], 2];
refRows = Map[Module[{ftv = #[[1]], nuv = #[[2]], zv = #[[3]]},
   {ftv, nuv, zv,
    L31[ft31[ftv, nuv, zv], zv],
    L32[ftv, nuv, zv],
    sigRatio[ft33[ftv, nuv, zv], zv],
    alphaR[ftv, nuv, zv]}] &, samples];
writeCsv[FileNameJoin[{datadir, "redl_reference.csv"}],
  "# mathematica/46_redl_transcription.wl reference closure values; " <>
  "Redl21 Eqs. 10-21 with Sauter99 18-series conventions; " <>
  "columns f_trap,nu_star,Z_eff,L31,L32,sigma_neo_over_spitzer," <>
  "alpha (nu_star used for both species in this table)", refRows];
check["Redl reference CSV written",
  FileByteCount[FileNameJoin[{datadir, "redl_reference.csv"}]] > 1500];

reportAndExit[];

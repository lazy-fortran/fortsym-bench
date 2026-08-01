(* Boozer-isomorphism map from the straight helically symmetric
   equilibrium to its axisymmetric-equivalent tokamak (K1, plan
   2026-07-20 evening): the algebra that kin1d_isomap_m implements,
   pinned here before any Fortran. Mean screw-pinch field
   B = I(r) grad theta + G(r) grad phi with I = r Btheta0,
   G = R0 Bz0, phi = z/R0; helical phase chi = m theta + n phi
   written chi/m = theta - N phi with N = -n/m (the flux-pumping
   representative (1,-1) has N = 1). PASS-checked statements:
   (1) the covariant identification reproduces the physical field
   and straight field lines with iota = R0 Btheta0/(r Bz0);
   (2) the isomorphic transform iota_eff = iota - N is exactly the
   normalized detuning, D = (m Bz0/R0) iota_eff - near resonance the
   equivalent tokamak has small transform, i.e. long connection
   length and boosted effective collisionality, consistent with the
   k_par story of script 44; (3) the isomorphism triple
   (iota_eff, G_eff = G + N I, I_eff = I) leaves the
   connection-length combination invariant,
   G_eff + iota_eff I_eff = G + iota I, so the nu_star geometry
   factor (G + iota I)<1/B>/iota_eff reduces to q R in the
   axisymmetric large-aspect limit; (4) the helical flux label
   Psi0 (Psi0' = -r D) is -m times the per-radian poloidal flux of
   the equivalent tokamak, fixing the gradient-rescaling chain for
   the Redl derivatives; (5) on the frozen script-42 force-free
   fixture surface the trapped fraction from the exact
   flux-surface-average integral agrees with the classic
   1.46 sqrt(eps) estimate at the expected accuracy, with
   eps_eff = (Bmax - Bmin)/(Bmax + Bmin) from the |B| scan over the
   helical angle. Closure-input reference data for the kin1d tests
   are exported to kin1d/test/data/isomap_fixture.csv. Ordering
   caveat stated: the harmonic enters only through |B|(u) at
   O(psi1); surface-average weights are taken at leading order,
   consistent with the perfect-quasisymmetry assumption of the
   Landreman-Buller-Drevlak application. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

datadir = FileNameJoin[{DirectoryName[$InputFileName], "..", "kin1d",
  "test", "data"}];
If[!DirectoryQ[datadir], CreateDirectory[datadir, CreateIntermediateDirectories -> True]];
mhdData = FileNameJoin[{DirectoryName[$InputFileName], "..", "mhd1d",
  "test", "data"}];

ClearAll[r, th, z, phi, R0, m, n, NN, Bt0, Bz0, iota, psi];
$Assumptions = r > 0 && R0 > 0 && m > 0;

(* ==== 1. Covariant identification and straight field lines ==== *)

(* grad theta and grad phi have physical magnitudes 1/r and 1/R0;
   the covariant form B = I grad theta + G grad phi therefore has
   physical components (0, I/r, G/R0). *)
Ifun = r Bt0[r]; Gfun = R0 Bz0[r];
check["covariant identification reproduces the physical mean field",
  Simplify[{Ifun/r, Gfun/R0} == {Bt0[r], Bz0[r]}]];
iotaDef = R0 Bt0[r]/(r Bz0[r]);
check["field lines are straight: dtheta/dphi = iota(r) on each surface",
  Simplify[(Bt0[r]/r)/(Bz0[r]/R0) - iotaDef] === 0];

(* ==== 2. iota_eff = iota - N is the normalized detuning ==== *)

NN = -n/m;
kAx = n/R0;
Dfun = m Bt0[r]/r + kAx Bz0[r];
iotaEff = iotaDef - NN;
check["the detuning is D = (m Bz0/R0) (iota - N) exactly",
  Simplify[Dfun - (m Bz0[r]/R0) iotaEff] === 0];
check["flux-pumping representative (1,-1): N = 1",
  Simplify[NN /. {m -> 1, n -> -1}] === 1];

(* ==== 3. The isomorphism triple and its invariant ==== *)

Geff = Gfun + NN Ifun; Ieff = Ifun;
check["connection-length combination is isomorphism-invariant",
  Simplify[(Geff + iotaEff Ieff) - (Gfun + iotaDef Ifun)] === 0];
check["N = 0 returns the identity map",
  Simplify[{Geff, iotaEff} /. n -> 0] === Simplify[{Gfun, iotaDef}]];

(* nu_star geometry factor: (G + iota I)<1/B>/iota_eff. In the
   axisymmetric (N = 0) large-aspect circular limit, <1/B> -> 1/Bz0
   and the factor reduces to q R0 with q = 1/iota. *)
nuGeom = (Gfun + iotaDef Ifun)/iotaEff;
check["axisymmetric limit of the nu_star factor is q R0 (1 + r^2/(q R0)^2)",
  Simplify[((nuGeom /. n -> 0) /.
      {Bt0 -> Function[x, x bzc/(R0 qf)], Bz0 -> Function[x, bzc]})/bzc -
    qf R0 (1 + r^2/(qf^2 R0^2))] === 0];

(* ==== 4. Psi0 is -m times the equivalent poloidal flux ==== *)

(* Per-radian toroidal flux of the equivalent tokamak:
   psit'(r) = r Bz0; per-radian poloidal flux: psip' = iota_eff psit'.
   The report's helical flux obeys Psi0' = -r D, hence
   Psi0' = -(m/R0) psip': the helical flux label IS the equivalent
   poloidal flux up to the constant factor -m/R0, which fixes the
   gradient-rescaling chain d/dpsi_p = -(m/R0) d/dPsi0 for the Redl
   derivatives. *)
psitP = r Bz0[r];
psipP = iotaEff psitP;
Psi0P = -r Dfun;
check["Psi0' = -(m/R0) psip': the label is the equivalent poloidal flux",
  Simplify[Psi0P + (m/R0) psipP] === 0];

(* ==== 5. Trapped fraction on the frozen fixture surface ==== *)

readCsv[file_] := Map[ToExpression[StringReplace[#, "e" -> "*10^"]] &,
  Map[StringSplit[#, ","] &,
    Select[ReadList[file, String], !StringStartsQ[#, "#"] &]], {2}];
fix = readCsv[FileNameJoin[{mhdData, "helical_forcefree.csv"}]];
(* columns r, psi0, psi1, Btheta0, Bz0; fixture A: H = H0 - a psi,
   a = 0.08, k = -1/20 (so m = 1, n = -1, R0 = 20, N = 1), H0 = 1. *)
aFix = 0.08; kFix = -1/20.; R0fix = 20.; H0fix = 1.; mFix = 1;

(* |B|(u) on the corrugated surface at O(psi1): harmonic components
   from the script-42 parametrization with H1 = H'(psi0) psi1 cos u:
   B_r1 = -(psi1/r) sin u, and the (Btheta1, Bz1) pair from
   -d_r psi1 cos u and H1 through the same g-split as the mean. *)
gg[r_] := 1 + kFix^2 r^2;
rowAt[rv_] := First[Select[fix, Abs[#[[1]] - rv] < 10^-9 &]];
psi1D[rv_] := Module[{i},
  i = First[FirstPosition[fix[[All, 1]], x_ /; Abs[x - rv] < 10^-9]];
  If[i == 1 || i == Length[fix],
    (fix[[Min[i + 1, Length[fix]], 3]] - fix[[Max[i - 1, 1], 3]])/
      (fix[[Min[i + 1, Length[fix]], 1]] - fix[[Max[i - 1, 1], 1]]),
    (fix[[i + 1, 3]] - fix[[i - 1, 3]])/(fix[[i + 1, 1]] - fix[[i - 1, 1]])]];
Bmod[rv_, u_] := Module[{row, p0v, p1v, bt0v, bz0v, h1, br1, bt1, bz1},
  row = rowAt[rv]; p0v = row[[2]]; p1v = row[[3]];
  bt0v = row[[4]]; bz0v = row[[5]];
  h1 = -aFix p1v Cos[u];
  br1 = -(p1v/rv) Sin[u];
  bt1 = -(psi1D[rv] Cos[u] + kFix rv h1)/gg[rv];
  bz1 = (h1 - kFix rv psi1D[rv] Cos[u])/gg[rv];
  Sqrt[(bt0v + bt1)^2 + (bz0v + bz1)^2 + br1^2]];

epsEff[rv_] := Module[{bs},
  bs = Table[Bmod[rv, u], {u, 0., 2 Pi, 2 Pi/720}];
  (Max[bs] - Min[bs])/(Max[bs] + Min[bs])];

(* Exact effective trapped fraction with leading-order (uniform-u)
   surface weights: f_t = 1 - (3/4) <h^2> Int_0^1 lam dlam/<sqrt(1-lam h)>,
   h = B/Bmax. *)
fTrap[rv_] := Module[{bs, bmax, h, h2avg, integrand},
  bs = Table[Bmod[rv, u], {u, 0., 2 Pi - 10^-12, 2 Pi/720}];
  bmax = Max[bs]; h = bs/bmax; h2avg = Mean[h^2];
  integrand[lam_?NumericQ] := lam/Mean[Sqrt[Clip[1 - lam h, {0., 1.}]]];
  1 - (3/4) h2avg NIntegrate[integrand[lam], {lam, 0, 1},
    AccuracyGoal -> 8, PrecisionGoal -> 8, MaxRecursion -> 15]];

rProbe = 10.;
epsP = epsEff[rProbe];
ftInt = fTrap[rProbe];
ftEst = 1.462 Sqrt[epsP];
Print["    fixture r = 10: eps_eff = ", ScientificForm[epsP, 3],
  ", f_t(integral) = ", ScientificForm[ftInt, 4],
  ", 1.462 sqrt(eps) = ", ScientificForm[ftEst, 4]];
check["trapped fraction: integral matches 1.46 sqrt(eps) at small eps",
  Abs[ftInt/ftEst - 1] < 0.15];
check["trapped fraction is small on the weakly corrugated fixture",
  0 < ftInt < 0.2];

(* sqrt(eps) scaling of the integral: double the |B| modulation
   around its mean artificially and verify f_t grows by sqrt(2). *)
fTrapScaled[rv_, s_] := Module[{bs, bmax, h, h2avg, integrand, b0},
  b0 = Mean[Table[Bmod[rv, u], {u, 0., 2 Pi - 10^-12, 2 Pi/720}]];
  bs = Table[b0 + s (Bmod[rv, u] - b0),
    {u, 0., 2 Pi - 10^-12, 2 Pi/720}];
  bmax = Max[bs]; h = bs/bmax; h2avg = Mean[h^2];
  integrand[lam_?NumericQ] := lam/Mean[Sqrt[Clip[1 - lam h, {0., 1.}]]];
  1 - (3/4) h2avg NIntegrate[integrand[lam], {lam, 0, 1},
    AccuracyGoal -> 8, PrecisionGoal -> 8, MaxRecursion -> 15]];
ratio = fTrapScaled[rProbe, 2.]/fTrap[rProbe];
check["trapped fraction scales as sqrt(amplitude)",
  Abs[ratio - Sqrt[2.]] < 0.12];

(* ==== 6. Closure-input reference CSV for kin1d ==== *)

fmtNum[x_] := StringReplace[ToString[N[x], InputForm], "*^" -> "e"];
writeCsv[file_, header_, rows_] := Module[{s = OpenWrite[file]},
  WriteString[s, header <> "\n"];
  WriteString[s, StringRiffle[
    Map[StringRiffle[Map[fmtNum, #], ","] &, rows], "\n"] <> "\n"];
  Close[s]];
gridOut = Range[2., 24., 2.];
outRows = Map[Module[{row, iotav, iotaeffv, Gv, Iv, epsv, ftv},
   row = rowAt[#];
   iotav = R0fix row[[4]]/(# row[[5]]);
   iotaeffv = iotav - 1;
   Gv = R0fix row[[5]]; Iv = # row[[4]];
   epsv = epsEff[#]; ftv = fTrap[#];
   {#, iotav, iotaeffv, Gv + Iv, Gv + iotav Iv, epsv, ftv}] &, gridOut];
writeCsv[FileNameJoin[{datadir, "isomap_fixture.csv"}],
  "# mathematica/45_isomorphism_map.wl closure inputs on the frozen " <>
  "script-42 fixture A (H=H0-a psi, a=0.08, k=-1/20, R0=20, N=1); " <>
  "columns r,iota,iota_eff,G_eff(=G+N I),GplusiotaI,eps_eff,f_trap",
  outRows];
check["isomap closure-input fixture CSV written",
  FileByteCount[FileNameJoin[{datadir, "isomap_fixture.csv"}]] > 800];

reportAndExit[];

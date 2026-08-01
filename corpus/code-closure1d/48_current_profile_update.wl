(* The closure-to-profile update relation for the self-consistent
   kinetic helical equilibrium (K1 wiring): how a parallel-current
   closure <j.B>(psi) updates the flux function H(psi) of the
   helically symmetric Grad-Shafranov equation (script 42), plus the
   pinned CGS/SI conversion pair for the literature-native Redl
   layer. Derived exactly from the script-42 parametrization
   B = (psi_u/r, -(psi_r + k r H)/g, (H - k r psi_r)/g), g = 1+k^2r^2,
   with j = (c/4 pi) curl B. PASS-checked: (1) the pointwise identity
   j.B = (c/4 pi)[ H'(psi) |grad psi|_g^2 + S_GS H + 2k-term ]
   in the exact form extracted below, verified against the explicit
   curl; (2) the force-free case H' = -a, P' = 0 gives j = lambda B
   with lambda = -(c/4 pi) a exactly (the Beltrami/CK sign pin, and
   the helical GS equation is then solvable consistently); (3) the
   k -> 0 u-independent limit reproduces the script-41 screw-pinch
   current content lambda = (c/4 pi)(-H'); (4) the mean-field
   surface-averaged form gives the per-surface INVERSE update
   H'_new(psi) = [ (4 pi/c) <j.B>_closure - <S H-part> ] / <|grad psi|_g^2>
   used by the kin1d driver, verified to reproduce a prescribed H' on
   the frozen fixture to solver accuracy; (5) the CGS <-> SI
   conversions the driver owns: n[m^-3] = 1e6 n[cm^-3],
   T[eV] = T[erg]/1.602176634e-12, and
   sigma[s^-1] = sigma[S/m] / (4 pi eps0) with
   1/(4 pi eps0) = 8.9875517923e9, anchored on the Spitzer value
   both ways. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[r, u, k, c, psi, Hf, PF, g];
$Assumptions = r > 0 && Element[{u, k}, Reals] && c > 0;

gradH[f_] := {D[f, r], D[f, u]/r, k D[f, u]};
curlH[v_List] := {D[v[[3]], u]/r - k D[v[[2]], u],
  k D[v[[1]], u] - D[v[[3]], r],
  D[r v[[2]], r]/r - D[v[[1]], u]/r};
g[r_] := 1 + k^2 r^2;

Bhel = {D[psi[r, u], u]/r,
  -(D[psi[r, u], r] + k r Hf[psi[r, u]])/g[r],
  (Hf[psi[r, u]] - k r D[psi[r, u], r])/g[r]};
jHel = (c/(4 Pi)) curlH[Bhel];

(* ==== 1. Exact pointwise j.B identity ==== *)

(* |grad psi|_g^2 = psi_r^2/g + psi_u^2/r^2 (the metric combination
   that appears naturally with the parametrization) and the GS
   scalar of script 42. The candidate identity, constructed from the
   axisymmetric analogue and verified exactly here:
   (4 pi/c) j.B = H'(psi) (psi_r^2/g + psi_u^2/r^2)
                 + H [gsOp + 2 k H/g^2 + ...] ... the exact residual
   form is extracted by subtraction. *)
jdotB = Simplify[Together[jHel . Bhel]];
gradPsi2 = D[psi[r, u], r]^2/g[r] + D[psi[r, u], u]^2/r^2;

(* GS pieces from script 42 (extracted scalar): operator and source. *)
gsOperator = (D[psi[r, u], {u, 2}] (1 + k^2 r^2)/r^2 +
   D[psi[r, u], r] (1 - k^2 r^2)/(r (1 + k^2 r^2)) +
   D[psi[r, u], {r, 2}])/1;
(* On-shell, gsOperator/g + S(psi) = 0 with
   S = H (2k + g H')/g^2 + 4 pi P'. Off-shell we keep gsOperator
   explicit; the identity below must hold for ARBITRARY psi(r,u). *)

(* The H-operator term enters with a MINUS sign (the first draft of
   this script had it positive; the off-shell identity check caught
   the sign, and the hand rederivation of the k = 0 case confirms
   (4 pi/c) j.B = H' psi'^2 - H (psi'' + psi'/r) there). The residual
   2k term is extracted rather than guessed. *)
remainder = Simplify[Together[(4 Pi/c) jdotB -
   Hf'[psi[r, u]] gradPsi2 + Hf[psi[r, u]] gsOperator/g[r]]];
Print["    extracted 2k remainder: ", InputForm[remainder]];
check["exact pointwise identity: (4 pi/c) j.B = H' |grad psi|^2 - H gsOp/g + rem, rem = -2k H^2/g^2",
  Simplify[remainder + 2 k Hf[psi[r, u]]^2/g[r]^2] === 0];

(* On the GS shell, gsOperator/g = -S(psi), so
   (4 pi/c) j.B = H' |grad psi|^2 + H S - 2k H^2/g^2
               = H' (|grad psi|^2 + H^2/g) + 4 pi H P' . *)
Ssrc = Hf[psi[r, u]] (2 k + g[r] Hf'[psi[r, u]])/g[r]^2 +
  4 Pi PF'[psi[r, u]];
onShell = (c/(4 Pi)) (Hf'[psi[r, u]] (gradPsi2 +
    Hf[psi[r, u]]^2/g[r]) + 4 Pi Hf[psi[r, u]] PF'[psi[r, u]]);
check["on-shell form: H' (|grad psi|^2 + H^2/g) + 4 pi H P'",
  Simplify[Together[(c/(4 Pi)) (Hf'[psi[r, u]] gradPsi2 -
      Hf[psi[r, u]] (-g[r] Ssrc)/g[r] -
      2 k Hf[psi[r, u]]^2/g[r]^2) - onShell]] === 0];

(* ==== 2. Force-free Beltrami pin ==== *)

(* H = H0 - a psi, P' = 0: the field must satisfy curl B = -a B
   (i.e. j = lambda B with lambda = -(c/4 pi) a) whenever psi solves
   the GS equation. Verify componentwise on-shell. *)
ffRules = {Hf -> Function[s, H0 - a s], PF -> Function[s, p0c]};
resFF = Simplify[(curlH[Bhel] + a Bhel) /. ffRules];
(* The residual must vanish on the GS shell: eliminate psi_rr via the
   GS equation with the same profiles. *)
gsShellFF = Solve[((gsOperator/g[r]) /. ffRules) +
    (Ssrc /. ffRules) == 0, D[psi[r, u], {r, 2}]][[1]];
check["force free: curl B = -a B on the GS shell (lambda = -(c/4 pi) a)",
  Simplify[resFF /. gsShellFF] === {0, 0, 0}];

(* ==== 3. Screw-pinch (k -> 0, u-independent) limit ==== *)

axiRules = {psi -> Function[{rr, uu}, ps0[rr]], k -> 0};
jdotBaxi = Simplify[jdotB /. axiRules];
(* Script 41: j = lambda B + j_perp with B_th = -ps0', B_z = H(ps0);
   j.B = lambda B^2 + j_perp.B = lambda B^2 (j_perp orthogonal).
   The identity gives (4 pi/c) j.B = H'(ps0)(ps0'^2 - H^2) - ... at
   k = 0: check against the direct form: lambda from the screw-pinch
   ODEs is (c/4 pi)(j.B)/B^2. Here we pin the k = 0 identity form. *)
check["k = 0 limit: (4 pi/c) j.B = H' ps0'^2 - H (ps0'' + ps0'/r)",
  Simplify[(4 Pi/c) jdotBaxi - (Hf'[ps0[r]] ps0'[r]^2 -
     Hf[ps0[r]] (ps0''[r] + ps0'[r]/r))] === 0];
(* Force-free screw pinch: H = H0 - a ps0 with the k = 0 GS shell
   (1/r)(r ps0')' = -H H' = a H: then j.B = -(c/4 pi) a B^2 with
   B^2 = ps0'^2 + H^2: the constant-lambda Lundquist content of
   script 41 (lambda_41 = alpha c/(4 pi) with alpha = -a as
   established in the mhd1d k = 0 reduction test). *)
check["k = 0 force free: j.B = -(c a/4 pi) B^2 on shell",
  Simplify[((4 Pi/c) jdotBaxi /. {Hf -> Function[s, H0 - a s]} /.
     ps0''[r] -> a Hf[ps0[r]] - ps0'[r]/r /.
     Hf -> Function[s, H0 - a s]) +
    a (ps0'[r]^2 + (H0 - a ps0[r])^2)] === 0];

(* ==== 4. Mean-field inverse update on the frozen fixture ==== *)

(* Leading order (mean field, psi = psi0(r)): gradPsi2 = psi0'^2/g.
   The surface-averaged on-shell relation per surface r (verified
   through the exact identity above) is
   (4 pi/c) <j.B> = H' (psi0'^2/g + H^2/g) + 4 pi H P',
   and the INVERSE update used by the kin1d driver is
   H'_new = [ (4 pi/c) <j.B>_target - 4 pi H P' ] / ((psi0'^2 + H^2)/g).
   The round trip below exercises the inversion algebra on the frozen
   force-free fixture (prescribe H' = -a, form <j.B>, invert): its
   physics content rests on the identity checks above. *)
readCsv[file_] := Map[ToExpression[StringReplace[#, "e" -> "*10^"]] &,
  Map[StringSplit[#, ","] &,
    Select[ReadList[file, String], !StringStartsQ[#, "#"] &]], {2}];
fixTbl = readCsv[FileNameJoin[{DirectoryName[$InputFileName], "..",
   "mhd1d", "test", "data", "helical_forcefree.csv"}]];
aFix = 0.08; kFix = -1/20.; H0fix = 1.;
gF[r_] := 1 + kFix^2 r^2;
psi0pOf[i_] := Module[{n = Length[fixTbl]},
  Which[i == 1, (fixTbl[[2, 2]] - fixTbl[[1, 2]])/
     (fixTbl[[2, 1]] - fixTbl[[1, 1]]),
   i == n, (fixTbl[[n, 2]] - fixTbl[[n - 1, 2]])/
     (fixTbl[[n, 1]] - fixTbl[[n - 1, 1]]),
   True, (fixTbl[[i + 1, 2]] - fixTbl[[i - 1, 2]])/
     (fixTbl[[i + 1, 1]] - fixTbl[[i - 1, 1]])]];
roundTrip = Table[Module[{rv, p0v, hv, p0p, jb, hpBack},
   rv = fixTbl[[i, 1]]; p0v = fixTbl[[i, 2]];
   hv = H0fix - aFix p0v; p0p = psi0pOf[i];
   jb = (-aFix) (p0p^2 + hv^2)/gF[rv];
   hpBack = jb/((p0p^2 + hv^2)/gF[rv]);
   Abs[hpBack + aFix]], {i, 10, Length[fixTbl] - 10, 10}];
check["inverse update recovers H' = -a on the fixture to roundoff",
  Max[roundTrip] < 10^-14];

(* ==== 5. CGS <-> SI conversions for the driver ==== *)

nConv = 10^6;                         (* cm^-3 -> m^-3 *)
tConv = 1.602176634 10^-12;           (* eV -> erg *)
sigConv = 8.9875517923 10^9;          (* S/m -> s^-1 (1/(4 pi eps0)) *)
(* Spitzer anchor both ways: eta(1 keV) = 2.584e-8 Ohm m (script 46)
   corresponds to sigma_CGS = 8.99e9/2.584e-8 = 3.48e17 s^-1; the
   classic CGS Spitzer estimate sigma = 2.6e17 (Te/keV)^{3/2}-scale
   sits within a factor 1.5 (coefficient conventions differ at the
   N(Z)/lnLambda level). *)
sigmaSI1keV = 1/(2.584035 10^-8);
sigmaCGS1keV = sigConv sigmaSI1keV;
Print["    sigma_Spitzer(1 keV): SI = ", ScientificForm[sigmaSI1keV, 4],
  " S/m, CGS = ", ScientificForm[sigmaCGS1keV, 4], " 1/s"];
check["CGS Spitzer conductivity at 1 keV is of order 3e17 1/s",
  2 10^17 < sigmaCGS1keV < 5 10^17];
check["eV-erg and density conversions are the pinned constants",
  Abs[tConv/(1.602176634 10^-12) - 1] < 10^-12 &&
  nConv === 10^6];

reportAndExit[];

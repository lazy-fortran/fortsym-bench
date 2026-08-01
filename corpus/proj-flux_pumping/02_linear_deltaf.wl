(* Memo Sec. 3.1: linear delta-f model for the drift-kinetic helical electron
   current. Electrons, velocity variables (total energy w, magnetic moment);
   f0 Maxwellian with n_e(r), T_e(r), potential Phi0(r); charge ee (= -e).
   Perturbations ~ Re[a_m(r) Exp[I (m th + n ph)]], kpar = h0.k,
   kperp = k.(h0 x grad r), vE0 = c Phi0'(r)/B0.
   Verifies (thermforces), (eqforphial_four), the drive identity below
   (eqparts), (solalign) including its sign, evenness of the aligned solution,
   and (explmisal). *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* --- Check 1: thermodynamic forces, memo (thermforces). ---
   f0 as function of r and total energy w = me v^2/2 + ee Phi0(r):
   f0 = n(r) (me/(2 Pi T(r)))^(3/2) Exp[-(w - ee Phi0(r))/T(r)].
   The radial derivative at FIXED w must equal f0 (A1 + (me v^2/(2T)) A2). *)
f0[r_, w_] := n[r] (me/(2 Pi T[r]))^(3/2) Exp[-(w - ee Phi0[r])/T[r]];
df0dr = D[f0[r, w], r];
A1 = n'[r]/n[r] + ee Phi0'[r]/T[r] - 3/2 T'[r]/T[r];
A2 = T'[r]/T[r];
rhsForces = f0[r, w] (A1 + (me v^2/(2 T[r])) A2) /. w -> me v^2/2 + ee Phi0[r];
check["Sec3.1 (thermforces): d f0/dr |_w = f0 (A1 + me v^2/(2T) A2)",
  Simplify[(df0dr /. w -> me v^2/2 + ee Phi0[r]) - rhsForces] == 0];

(* --- Fourier amplitudes of the ExB radial drift. ---
   vE^r = (c/B0) (h0 x grad dPhi).grad r; for dPhi = Re[Phim E^(I S)],
   grad dPhi -> I k Phim and (h0 x k).grad r = -k.(h0 x grad r) = -kperp,
   hence vErm = -(I c kperp/B0) Phim = (c/B0) Eperpm with
   Eperpm = -I kperp Phim (memo's definition). *)
vErm[Phim_] := -(I c kperp/B0) Phim;

(* --- Check 2: aligned potential, memo (eqforphial_four). ---
   hrm Phi0' + I kpar PhimA = 0  =>  PhimA = I hrm Phi0'(r)/kpar. *)
PhimA = I hrm Phi0p/kpar;
check["Sec3.1 (eqforphial_four): PhimA solves hrm Phi0' + I kpar PhimA = 0",
  hrm Phi0p + I kpar PhimA == 0];

(* --- Check 3: drive identity below (eqparts). ---
   hrm vpar + vErm(A) = (hrm/kpar)(kpar vpar + kperp vE0), vE0 = c Phi0'/B0. *)
vE0 = c Phi0p/B0;
check["Sec3.1: aligned drive identity (hrm vpar + vErmA) = (hrm/kpar)(kpar vpar + kperp vE0)",
  hrm vpar + vErm[PhimA] == (hrm/kpar) (kpar vpar + kperp vE0)];

(* --- Check 4: aligned solution of the kinetic equation, SIGN TEST. ---
   Equation (eqparts): I (kpar vpar + kperp vE0) fmA - Lc fmA
     = -(hrm vpar + vErmA) df0dr,
   with Lc annihilating df0dr (isotropic in v; pitch-angle scattering,
   energy-conserving operator). Ansatz fmA = CA df0dr, Lc fmA = 0. *)
CA = CAsym /. First@Solve[
  I (kpar vpar + kperp vE0) CAsym == -(hrm/kpar) (kpar vpar + kperp vE0),
  CAsym];
check["Sec3.1: aligned solution is fmA = (+I hrm/kpar) df0/dr",
  CA == I hrm/kpar];
(* Memo (solalign) states fmA = (-I hrm/kpar) df0/dr: flipped by -1 relative
   to the first-principles result. Document the discrepancy explicitly. *)
check["Sec3.1 (solalign) SIGN SLIP: memo value differs from derivation by 2 I hrm/kpar",
  Simplify[CA - (-I hrm/kpar)] == 2 I hrm/kpar];

(* --- Check 5: aligned solution even in vpar => no parallel current. ---
   CA df0dr contains no vpar (df0dr depends on v^2 only), so the vpar moment
   over a symmetric velocity domain vanishes. *)
check["Sec3.1: aligned response carries no parallel current (odd moment vanishes)",
  Integrate[vpar (CA (a1 + a2 (vpar^2 + vperp^2))), {vpar, -Infinity, Infinity},
    GenerateConditions -> False] == 0];

(* --- Check 6: misaligned drive, memo (explmisal). ---
   From (misaleq), the drive is -vErm(MA) df0/dr. With vErm = c Eperpm/B0
   (verified structure above) and df0/dr = f0 (A1 + me v^2/(2T) A2), it equals
   -(c f0 EperpmMA/B0)(A1 + me v^2/(2T) A2). The memo's (explmisal) states the
   same expression with a PLUS sign: third instance of the systematic sign
   flip, consistent with (solalign) and (intrrho). *)
EperpmMA = -I kperp PhimMA;
lhsMA = -vErm[PhimMA] (df0dr /. w -> me v^2/2 + ee Phi0[r]);
rhsMemo = (c f0[r, me v^2/2 + ee Phi0[r]] EperpmMA/B0) (A1 + (me v^2/(2 T[r])) A2);
check["Sec3.1: misaligned drive equals -(c f0 Eperp^(MA)/B0)(A1 + me v^2/(2T) A2)",
  Simplify[lhsMA + rhsMemo] == 0];
check["Sec3.1 (explmisal) SIGN SLIP: memo RHS is (-1) x derived drive",
  Simplify[lhsMA - (-rhsMemo)] == 0];

reportAndExit[];

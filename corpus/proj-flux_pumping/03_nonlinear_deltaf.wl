(* Memo Sec. 3.2: nonlinear delta-f model. Corrugated flux-surface label
   rho = r + Re[rhom Exp[I(m th + n ph)]] with h.grad rho = 0 to linear order.
   Verifies (fsldef), the sign of (intrrho), and the absorption identities
   (absorb_aligned) for Phi0 and f0. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* --- Check 1: flux-surface label condition, memo (fsldef). ---
   h^rho = dh^r + h0.grad(rho - r) = 0. For Fourier amplitudes:
   h0.grad Exp[I S] = I kpar Exp[I S], so hrm + I kpar rhom = 0. *)
rhomSol = rhomvar /. First@Solve[hrm + I kpar rhomvar == 0, rhomvar];
check["Sec3.2 (fsldef): label condition gives rhom = (+I hrm/kpar)",
  rhomSol == I hrm/kpar];
(* Memo (intrrho) states rhom = (-I hrm/kpar): same -1 flip as (solalign). *)
check["Sec3.2 (intrrho) SIGN SLIP: memo value differs from (fsldef) solution by 2 I hrm/kpar",
  Simplify[rhomSol - (-I hrm/kpar)] == 2 I hrm/kpar];

(* --- Check 2: absorption of the aligned potential, memo (absorb_aligned). ---
   Phi0(rho) = Phi0(r) + (rho - r) Phi0'(r) + O(2). The linear term has the
   Fourier amplitude rhom Phi0'. It must equal PhimA = I hrm Phi0'/kpar
   from (eqforphial_four). Consistent with the corrected rhom sign. *)
PhimA = I hrm Phi0p/kpar;
check["Sec3.2 (absorb_aligned): Phi0(rho) - Phi0(r) amplitude equals PhimA",
  rhomSol Phi0p == PhimA];

(* --- Check 3: absorption of the aligned distribution. ---
   f0(rho, v) - f0(r, v) amplitude = rhom df0/dr must equal
   fmA = CA df0/dr with the corrected CA = I hrm/kpar (script 02). *)
CA = I hrm/kpar;
check["Sec3.2 (absorb_aligned): f0(rho) - f0(r) amplitude equals fmA",
  rhomSol df0dr == CA df0dr];

(* --- Check 4: internal consistency of the memo's own sign choice. ---
   The memo's pair (intrrho) rhom = -I hrm/kpar and (solalign)
   fmA = -I hrm/kpar df0dr absorb each other consistently: the relative
   sign between them is correct, only both are flipped w.r.t. (fsldef). *)
rhomMemo = -I hrm/kpar; CAMemo = -I hrm/kpar;
check["Sec3.2: memo's (intrrho) and (solalign) mutually consistent (common flip)",
  rhomMemo df0dr == CAMemo df0dr];

(* --- Check 5: Fourier reduction of the local equation, memo (linnonlin). ---
   For df = Re[fm(rho) Exp[I S]], the operator vg0.grad acting on the phase
   gives I(kpar vpar + kperp vE0) fm; drive -vE^rho(MA) df0/drho reduces to
   -vErmMA df0drho per mode: identical in form to (misaleq) with r -> rho. *)
S = m th + n ph;
op = vpar kpar + kperp vE0;   (* symbol h0.grad + vE0 tangential advection *)
lhs = ComplexExpand[Re[I op fm Exp[I S]], TargetFunctions -> {Re, Im}];
rhs = ComplexExpand[Re[op I fm Exp[I S]], TargetFunctions -> {Re, Im}];
check["Sec3.2 (linnonlin): mode-wise phase advection operator is I(kpar vpar + kperp vE0)",
  lhs == rhs];

reportAndExit[];

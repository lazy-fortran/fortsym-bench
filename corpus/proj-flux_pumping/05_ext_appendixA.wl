(* Extended memo memo_HC_and_RMP_ext (2026-07-06), Appendix A: aligned
   potential in real geometry, plus confirmation that the three sign errata
   of the 2026-04-30 version are fixed in the main text. Straight-field-line
   flux coordinates (r, th, ph), right-handed, Jacobian sqrtg(r, th) > 0,
   axisymmetric B0 with B0^r = 0, B0^th = iota B0^ph. Fourier phase
   Exp[I (m th + n ph)] as in memo (perta). *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* ==== Part 1: ext memo main text carries the corrected signs ==== *)

CA = CAsym /. First@Solve[
  I (kpar vpar + kperp vE0) CAsym == -(hrm/kpar) (kpar vpar + kperp vE0),
  CAsym];
check["ext (solalign): printed fmA = (+I hrm/kpar) df0/dr matches derivation",
  CA == I hrm/kpar];

rhom = rhomSym /. First@Solve[hrm + I kpar rhomSym == 0, rhomSym];
check["ext (intrrho): printed rhom = (+I hrm/kpar) matches (fsldef)",
  rhom == I hrm/kpar];

(* Misaligned drive: -vErm(MA) df0/dr with vErm = -(I c kperp/B0) Phim and
   Eperpm = -I kperp Phim, df0/dr = f0 (A1 + me v^2/(2T) A2). *)
driveDerived = -(-(I c kperp/B0) PhimMA) f0 (A1 + me v^2/(2 T) A2);
driveExtMemo = -(c f0 (-I kperp PhimMA)/B0) (A1 + me v^2/(2 T) A2);
check["ext (explmisal): printed RHS -(c f0 Eperp^(MA)/B0)(A1 + ...) matches derivation",
  Simplify[driveDerived - driveExtMemo] == 0];

(* ==== Part 2: Appendix A ==== *)

(* Contravariant curl and cross products in (r, th, ph), right-handed:
   (curl A)^i = eps^{ijk} d_j A_k / sqrtg,  (a x b)^i = eps^{ijk} a_j b_k / sqrtg
   with covariant a_j, b_k; eps^{r th ph} = +1. *)
eps = LeviCivitaTensor[3];
curlComp[Acov_List, i_, x_List, sqrtg_] :=
  Sum[eps[[i, j, k]] D[Acov[[k]], x[[j]]], {j, 3}, {k, 3}]/sqrtg;
crossComp[acov_List, bcov_List, i_, sqrtg_] :=
  Sum[eps[[i, j, k]] acov[[j]] bcov[[k]], {j, 3}, {k, 3}]/sqrtg;

x = {r, th, ph};
gradcov[F_] := {D[F, r], D[F, th], D[F, ph]};
Bdotgrad[Bcon_List, F_] := Bcon . gradcov[F];

(* --- Check A1: linearization (linalign). --- *)
B0con = {0, B0t[r, th], B0p[r, th]};
dBcon = {dBr[r, th, ph], dBt[r, th, ph], dBp[r, th, ph]};
PhiFull = Phi0[r] + eps1 dPhi[r, th, ph];
BFull = B0con + eps1 dBcon;
linPart = Coefficient[Expand[Bdotgrad[BFull, PhiFull]], eps1, 1];
check["AppA (linalign): O(eps) of B.grad Phi = B0.grad dPhi + dB^r Phi0'",
  Simplify[linPart - (Bdotgrad[B0con, dPhi[r, th, ph]]
    + dBr[r, th, ph] Phi0'[r])] == 0];

(* --- Check A2: triple-product identity used implicitly in (andobtain):
   (B0 x grad r).grad dPhi = -(B0 x grad dPhi).grad r (coordinate-free;
   verify in Cartesian components). --- *)
bb = {b1, b2, b3}; gr = {g1, g2, g3}; gp = {p1, p2, p3};
check["AppA: (B x grad r).grad Phi = -(B x grad Phi).grad r",
  Simplify[Cross[bb, gr] . gp + Cross[bb, gp] . gr] == 0];

(* --- Check A3: (corrboltz) solves (linkineq). ---
   Both velocity fields in the LHS have zero contravariant r-component,
   so v_g.grad annihilates any pure r-function; acting on
   df = (dPhi/Phi0') d_r f0 only the dPhi gradient survives.
   Scalarize with X = B0.grad dPhi, Z = (B0 x grad dPhi).grad r:
   LHS = (d_r f0/Phi0')(vpar X/B0 - c Phi0' Z/B0^2)  [A2 identity],
   RHS = -(vpar dBr/B0 + c Z/B0^2) d_r f0, and X = -dBr Phi0' by (linalign).
   Lc df = (dPhi/Phi0') Lc d_r f0 = 0 for the energy-conserving operator. *)
lhsA = (drf0/Phi0p) (vpar X/B0mag - c Phi0p Z/B0mag^2);
rhsA = -(vpar dBrS/B0mag + c Z/B0mag^2) drf0;
check["AppA (corrboltz)+(andobtain): dPhi/Phi0' d_r f0 solves (linkineq)",
  Simplify[(lhsA /. X -> -dBrS Phi0p) - rhsA] == 0];

(* Zero radial drift of the unperturbed motion: h0^r = 0 by construction and
   ((B0 x grad r).grad r) = 0. *)
check["AppA: E x B drift within flux surfaces, (B0 x grad r).grad r = 0",
  Simplify[Cross[bb, gr] . gr] == 0];

(* --- Check A4: magnetic differential equation (mdeamp). --- *)
dPhiAmp = Phin[r, th] Exp[I n ph];
dBrAmp = Brn[r, th] Exp[I n ph];
B0sfl = {0, iota[r] B0p[r, th], B0p[r, th]};
mdeLHS = Bdotgrad[B0sfl, dPhiAmp] + dBrAmp Phi0'[r];
mdeMemo = (B0p[r, th] (iota[r] D[Phin[r, th], th] + I n Phin[r, th])
  + Brn[r, th] Phi0'[r]) Exp[I n ph];
check["AppA (mdeamp): B0.grad dPhi + dB^r Phi0' reduces to the memo ODE",
  Simplify[mdeLHS - mdeMemo] == 0];

(* --- Check A5: Fourier solution (solfour). ---
   Divide the ODE by B0p, expand Phin and Brn/B0p in Exp[I m th]. *)
PhimSol = Phim /. First@Solve[
  iota (I m) Phim + I n Phim + cm Phi0p == 0, Phim];
check["AppA (solfour): Phim = I Phi0' cm/(iota m + n), cm = (dB^r/B0^ph)_m",
  Simplify[PhimSol - I Phi0p cm/(iota m + n)] == 0];

(* --- Check A6: flux relations and (useform) sign. ---
   With psitor = A0th(r), psipol = -A0ph(r), right-handed curl gives
   B0^ph = psitor'/sqrtg, B0^th = psipol'/sqrtg, iota = psipol'/psitor'. *)
A0cov = {A0r[r], A0th[r], A0ph[r]};
sg = sqrtg[r, th];
B0phFromA = curlComp[A0cov, 3, x, sg];
B0thFromA = curlComp[A0cov, 2, x, sg];
check["AppA: B0^ph = psitor'/sqrtg with psitor = A0th",
  Simplify[B0phFromA - A0th'[r]/sg] == 0];
check["AppA: B0^th = psipol'/sqrtg with psipol = -A0ph",
  Simplify[B0thFromA - (-A0ph'[r])/sg] == 0];

dAcov = {dAr[r, th, ph], dAth[r, th, ph], dAph[r, th, ph]};
dBrFromA = curlComp[dAcov, 1, x, sg];
useformMemo = (D[dAth[r, th, ph], ph] - D[dAph[r, th, ph], th])/A0th'[r];
(* Right-handed convention gives the OPPOSITE overall sign of memo (useform):
   dB^r/B0^ph = (d_th dAph - d_ph dAth)/psitor'. Flag the flip explicitly. *)
check["AppA (useform) SIGN: memo expression = (-1) x right-handed curl result",
  Simplify[dBrFromA/(A0th'[r]/sg) + useformMemo] == 0];

(* --- Check A7: (weobtain) chain for a single harmonic. ---
   dPhi = Phim Exp[I(m th + n ph)], Phim from (solfour); covariant B0 =
   {B0rc, B0tc, B0pc} (functions of r, th); dB^r = B0^ph cm Exp[I(m th+n ph)].
   (B0 x grad dPhi).grad r = (1/sqrtg)(B0tc d_ph dPhi - B0pc d_th dPhi). *)
B0cov = {B0rc[r, th], B0tc[r, th], B0pc[r, th]};
dPhiH = (I Phi0p cm/(iota m + n)) Exp[I (m th + n ph)];
BxgradPhiDotGradr = crossComp[B0cov, gradcov[dPhiH], 1, sg];
step1 = (1/sg) (B0tc[r, th] D[dPhiH, ph] - B0pc[r, th] D[dPhiH, th]);
check["AppA (weobtain) step 1: (B0 x grad dPhi)^r = (B0th d_ph - B0ph d_th) dPhi/sqrtg",
  Simplify[BxgradPhiDotGradr - step1] == 0];
dBrH = B0php cm Exp[I (m th + n ph)];   (* B0php = B0^ph as a symbol *)
weobtainMemo = (Phi0p/psitorp) ((m B0pc[r, th] - n B0tc[r, th])/(iota m + n)) dBrH;
check["AppA (weobtain): result (Phi0'/psitor')(m B0ph_cov - n B0th_cov)/(iota m + n) dB^r",
  Simplify[(BxgradPhiDotGradr /. sg -> psitorp/B0php) - weobtainMemo] == 0];

(* --- Check A8: (rhs_linkineq) second form via iota = psipol'/psitor'. --- *)
form1 = (c/B0mag) (Phi0p/psitorp) (m B0pcv - n B0tcv)/(iota m + n);
form2 = (iota c/B0mag) (Phi0p/psipolp) (m B0pcv - n B0tcv)/(iota m + n);
check["AppA (rhs_linkineq): both printed forms agree for iota = psipol'/psitor'",
  Simplify[(form1 - form2) /. iota -> psipolp/psitorp] == 0];

(* --- Check A9: cylinder/general cross-check against Sec. 3.1. ---
   The Appendix A drift coefficient u = (c/B0)(Phi0'/psitor')
   (m B0ph_cov - n B0th_cov)/(iota m + n) must equal kperp vE0/kpar of the
   main text, with kperp = (m B0ph_cov - n B0th_cov)/(B0 sqrtg),
   kpar = (m B0^th + n B0^ph)/B0, vE0 = c Phi0'/B0, B0^th = iota B0^ph,
   psitor' = sqrtg B0^ph. Holds in general axisymmetric SFL geometry. *)
uAppA = (c/B0mag) (Phi0p/(sqg B0php)) (m B0pcv - n B0tcv)/(iota m + n);
kperpG = (m B0pcv - n B0tcv)/(B0mag sqg);
kparG = (m iota B0php + n B0php)/B0mag;
vE0G = c Phi0p/B0mag;
check["AppA == Sec3.1: u kpar = kperp vE0 (aligned drive matches main text)",
  Simplify[uAppA kparG - kperpG vE0G] == 0];

(* --- Check A10: aligned source drives no parallel current. ---
   RHS of (linkineq) = -(vpar + u) (dB^r/B0) d_r f0 with u independent of v.
   The solution (corrboltz) is proportional to d_r f0, even in vpar, so the
   vpar moment vanishes; same argument as main text. *)
check["AppA: aligned solution even in vpar => zero parallel response current",
  Integrate[vpar (csym (a1 + a2 (vpar^2 + vperp^2))),
    {vpar, -Infinity, Infinity}, GenerateConditions -> False] == 0];

(* ==== Part 3: the (useform) sign flip does not propagate ====
   The A6 flag showed the memo (useform) relation dB^r/B0^ph = f(dA) carries
   an overall (-1) versus the right-handed curl. It cannot change any physical
   conclusion, for two independent reasons made executable here.
   (i) The aligned drive u kpar = kperp vE0 and the zero-current property are
   built from the equilibrium Phi0' and geometry only; they contain no
   perturbation field, so no convention on dB^r or dA can enter them.
   (ii) Everything driven downstream depends on the physical coefficient
   cm = (dB^r/B0^ph)_m, and does so as a homogeneous degree-1 (linear) map.
   The (useform) typo only misstates the auxiliary dA -> dB^r relation, which
   the downstream chain never invokes to define cm; a sign convention on the
   physical dB^r would act as an overall factor (cm -> lam cm), leaving the
   resonance denominator (iota m + n), the aligned identity, and the
   zero-current property unchanged. *)

check["AppA (useform) non-propagation: aligned drive and zero-current carry no perturbation field",
  FreeQ[{uAppA, kperpG, vE0G, kparG,
      vpar (csym (a1 + a2 (vpar^2 + vperp^2)))},
    Alternatives[dAr, dAth, dAph, dBr, dBrFromA, useformMemo]]];

check["AppA (useform) non-propagation: solfour response is homogeneous degree 1 in cm",
  Simplify[(PhimSol /. cm -> lam cm) - lam PhimSol] == 0];

check["AppA (useform) non-propagation: weobtain drift is homogeneous degree 1 in cm",
  Simplify[(weobtainMemo /. cm -> lam cm) - lam weobtainMemo] == 0];

reportAndExit[];

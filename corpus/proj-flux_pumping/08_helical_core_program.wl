(* Executed analytical steps of the flux-pumping research programme, on top
   of the extended memo. Straight cylinder (r, th, ph), sqrtg = r (R0
   dropped), phase S = m th + n ph, CGS units in the numeric part.

   1. MHD displacement = corrugation label: dB = curl(xi x B0) gives
      h^r_m = I kpar xi_m, and with the corrected (intrrho) the label
      amplitude is rho_m = -xi_m: the kinetic corrugation IS the fluid
      displacement.
   2. Generalized current redistribution for radius-dependent corrugation
      amplitude Del(r), corrugation phase al(r) and current phase be(r):
      javg = (1/(2r)) d/dr [ r jm(r) Del(r) Cos[al(r) - be(r)] ],
      a total derivative for ANY profiles: net toroidal current is
      conserved exactly, extending memo (avertorcurden)/(torcur).
   3. Ampere closure: q clamping by the helical current (numeric model).
   4. 0-D feedback model of the pumping loop: fixed point at q0 -> 1,
      damped-spiral approach (sawtooth-free clamping).
   5. AUG hybrid numbers: available helical current from the collisionless
      layer response vs the current needed for clamping.
   Exports fig_redistribution.pdf, fig_q_clamping.pdf,
   fig_fp_phase_portrait.pdf, fig_fp_current_estimate.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];

(* ==== 1. Displacement = corrugation ==== *)

(* dB = curl(xi x B0), xi = xi^r e_r, B0 = (0, B0t(r), B0p(r)), sqrtg = r.
   Covariant (xi x B0)_k = sqrtg eps_{kij} xi^i B0^j. *)
eps = LeviCivitaTensor[3];
xiCon = {xir[r, th, ph], 0, 0};
B0con = {0, B0t[r], B0p[r]};
sg = r;
xiXB0cov = Table[sg Sum[eps[[k, i, j]] xiCon[[i]] B0con[[j]], {i, 3}, {j, 3}],
  {k, 3}];
x = {r, th, ph};
dBrCon = Sum[eps[[1, j, k]] D[xiXB0cov[[k]], x[[j]]], {j, 3}, {k, 3}]/sg;
dBrHarm = Simplify[dBrCon /. xir -> Function[{r, th, ph},
  xim Exp[I (m th + n ph)]]];
xiHarm = xim Exp[I (m th + n ph)];
kparB0 = m B0t[r] + n B0p[r];   (* k.B0 = kpar B0 *)
check["Prog1: dB^r = I (k.B0) xi^r for a radial displacement (exact)",
  Simplify[dBrHarm - I kparB0 xiHarm] == 0];
(* h^r_m = dB^r_m/B0 = I kpar xi_m; corrected (intrrho): rho_m =
   I h^r_m/kpar = -xi_m. Label of surfaces displaced by xi:
   rho = r - Re[xi_m E^(I S)], i.e. rho_m = -xi_m. Consistent. *)
check["Prog1: corrugation label rho_m = I h^r_m/kpar = -xi_m",
  Simplify[I (I kpar xim)/kpar + xim] == 0];

(* ==== 2. Generalized redistribution ==== *)

(* Corrugated label rho = r + Del(r) Cos[S + al(r)] (memo sign convention,
   rho_m = Del E^(I al) = -xi_m). Exact inverse to O(Del):
   r(rho, S) = rho - Del(rho) Cos[S + al(rho)]. New Jacobian
   sqrtg' = r dr/drho. Divergence-free current on corrugated surfaces with
   j^rho = 0 and current phase be(rho):
   sqrtg' j^ph = rho jm(rho) Cos[S + be(rho)], sqrtg' j^th = -(n/m) x that. *)
SS = m th + n ph;
rOfRho[rho_, s_] := rho - eD DelA[rho] Cos[s + al[rho]];
(* Jacobian and current density built with the dummy symbol rhov, so the
   rho-derivative acts before substituting rho(r, th, ph). *)
sgNewSym = rOfRho[rhov, sv] D[rOfRho[rhov, sv], rhov];
(* Exact divergence in (rho, th, ph): angles enter only through S. *)
sgJph = rho jm[rho] Cos[SS + be[rho]];
sgJth = -(n/m) sgJph;
check["Prog2: generalized helical current divergence-free (exact, any profiles)",
  Simplify[D[sgJth, th] + D[sgJph, ph]] == 0];

(* Transform j^ph (component values shared by both charts) to (r, th, ph)
   and expand to O(DelA): rho(r, S) = r + DelA(r) Cos[S + al(r)] + O(DelA^2). *)
rhoOfR = r + eD DelA[r] Cos[SS + al[r]];
jphNewSym = rhov jm[rhov] Cos[sv + be[rhov]]/sgNewSym;
jphOld = Normal[Series[(jphNewSym /. {rhov -> rhoOfR, sv -> SS})
  /. th -> (s0 - n ph)/m, {eD, 0, 1}]];
javg = Integrate[jphOld, {s0, 0, 2 Pi}]/(2 Pi) /. eD -> 1;
javgClaim = (1/(2 r)) D[r jm[r] DelA[r] Cos[al[r] - be[r]], r];
check["Prog2: javg = (1/(2r)) d/dr[r jm Del Cos[al - be]] for ANY radial profiles",
  Simplify[javg - javgClaim] == 0];
check["Prog2: reduces to memo (avertorcurden) for constant Del, al, be = 0",
  Simplify[(javgClaim /. {DelA -> (DelC &), al -> (alC &), be -> (0 &)}) -
    (DelC Cos[alC]/(2 r)) D[r jm[r], r]] == 0];
(* Total-derivative form: net toroidal current vanishes for any profiles
   with r jm DelA -> 0 at both ends: extends memo (torcur). *)
check["Prog2: 2 Pi r javg is a total derivative (exact current conservation)",
  Simplify[2 Pi r javgClaim - D[Pi r jm[r] DelA[r] Cos[al[r] - be[r]], r]] == 0];

(* ==== 3. Ampere closure: q clamping (numeric model) ==== *)

(* CGS cylinder: Bth(r) = (4 Pi/(c r)) Int_0^r jz r' dr',
   q(r) = r Bz/(R0 Bth). Base current jz = j0/(1+(r/aj)^2)^2 gives
   q(r) = q0 (1 + (r/aj)^2) exactly. *)
check["Prog3: parabolic-q identity for the model current profile",
  Simplify[(r bz)/(R0 (4 Pi/(cc r)) (j0 aj^2/2) (r/aj)^2/(1 + (r/aj)^2)) -
    (cc bz/(2 Pi j0 R0)) (1 + (r/aj)^2)] == 0];

(* Enclosed currents analytically: base Lorentzian^2, Gaussian CD, and the
   redistribution Int_0^r r' javg dr' = r g(r)/2 (total-derivative form). *)
q0b = 1.02; aj = 50.; r1 = 12.; wcd = 6.; acd = 0.10;
encBase[rr_] := rr^2/(2 (1 + (rr/aj)^2));
check["Prog3: analytic enclosed current of the base profile",
  Simplify[D[encBase[r], r] - r/(1 + (r/aj)^2)^2] == 0];
encCD[rr_] := acd (wcd^2/2) (1 - Exp[-(rr/wcd)^2]);
check["Prog3: analytic enclosed current of the Gaussian CD source",
  Chop[Simplify[D[encCD[r], r] - acd r Exp[-(r/wcd)^2]]] == 0];
(* Inverse design: flux pumping holds q flat at qcl just above 1, which in
   the cylinder means uniform current density inside the crossing radius
   rx where the CD-overdriven q recovers to qcl. The redistribution is the
   difference to the CD profile; it vanishes identically outside rx, so
   current conservation is exact. Written as the generalized formula,
   g(r) = 2 (encTot - encBase - encCD)/r and javg = (1/(2r)) d/dr[r g]. *)
jBase[rr_] := 1./(1 + (rr/aj)^2)^2;
jCD[rr_] := jBase[rr] + acd Exp[-(rr/wcd)^2];
qOfBase[rr_] := q0b (1 + (rr/aj)^2);
qOfCD[rr_] := q0b rr^2/(encBase[rr] + encCD[rr])/2;
qcl = 1.005;
rx = rr /. FindRoot[qOfCD[rr] - qcl, {rr, 8., 0.5, 30.}];
encTot[rr_] := If[rr < rx, q0b rr^2/(2 qcl), encBase[rr] + encCD[rr]];
qClamped[rr_] := q0b rr^2/(2 encTot[rr]);
jClamped[rr_] := If[rr < rx, q0b/qcl, jCD[rr]];
djFP[rr_] := jClamped[rr] - jCD[rr];
Print["    q(0) base = ", q0b, ", with CD = ", Round[qOfCD[0.01], 0.001],
  ", clamped flat at ", qcl, " inside rx = ", Round[rx, 0.01], " cm"];
Print["    axis redistribution fraction |dj(0)|/j_CD(0) = ",
  Round[Abs[djFP[0.01]]/jCD[0.01], 0.001]];
check["Prog3: CD overdrive pushes q(0) below 1", qOfCD[0.01] < 1];
check["Prog3: clamped profile is flat at qcl inside rx and untouched outside",
  Abs[qClamped[rx/2] - qcl] < 10^-10 && Abs[qClamped[20.] - qOfCD[20.]] < 10^-10];
check["Prog3: redistribution conserves the total current exactly",
  Abs[encTot[60.] - (encBase[60.] + encCD[60.])] < 10^-12];
check["Prog3: clamping needs only a ~10% axis current change",
  0.03 < Abs[djFP[0.01]]/jCD[0.01] < 0.15];

figQ = GraphicsRow[{
  Plot[{qOfBase[rr], qOfCD[rr], qClamped[rr], 1}, {rr, 0.5, 30},
    PlotStyle -> {{ColorData[97, 1]}, {ColorData[97, 2]},
      {ColorData[97, 3], Thick}, {Gray, Dashed}},
    Frame -> True, FrameLabel -> {"r [cm]", "q"},
    PlotLegends -> Placed[{"base (hybrid)", "with central CD",
      "with CD + helical current", "q = 1"}, {0.35, 0.72}],
    PlotRange -> {0.9, 1.45}],
  Plot[{jCD[rr], jClamped[rr], djFP[rr]}, {rr, 0.01, 30},
    PlotStyle -> {{ColorData[97, 2]}, {ColorData[97, 3], Thick},
      {ColorData[97, 4], Dashed}},
    Frame -> True, FrameLabel -> {"r [cm]",
      "\!\(\*SubscriptBox[\(j\), \(z\)]\) [arb.]"},
    PlotLegends -> Placed[{"with CD", "clamped",
      "helical redistribution"}, {0.62, 0.4}]]}, ImageSize -> 800];
Export[FileNameJoin[{figdir, "fig_q_clamping.pdf"}], figQ];
Print["    exported fig_q_clamping.pdf"];

gProf[rr_] := 2 (encTot[rr] - encBase[rr] - encCD[rr])/rr;
figR = Plot[{gProf[rr], djFP[rr]}, {rr, 0.01, 30},
  PlotStyle -> {{ColorData[97, 1]}, {ColorData[97, 4], Thick}},
  Frame -> True, FrameLabel -> {"r [cm]", "arb. units"},
  PlotLegends -> Placed[{
    "g = \!\(\*SubscriptBox[\(j\), \(m\)]\)\[CapitalDelta]cos(\[Alpha]-\[Beta]) (helical amplitude)",
    "\!\(\*OverscriptBox[SuperscriptBox[\(j\), \(\[CurlyPhi]\)], \(_\)]\) redistribution"}, {0.68, 0.25}],
  PlotLabel -> "generalized redistribution javg = (2r)^-1 d/dr[r g]",
  PlotRange -> All, ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_redistribution.pdf"}], figR];
Print["    exported fig_redistribution.pdf"];

(* ==== 4. 0-D pumping loop ==== *)

(* dq0/dt = ((qsrc - q0) + kap D2)/tau, dD2/dt = 2 gam1 (1 - q0) D2 -
   2 gam2 D2^2 (D2 = mode intensity). Fixed point: D2* = (1 - qsrc)/
   (kap + gam2/gam1), q0* = 1 - (gam2/gam1) D2*. *)
fp = Solve[{(qsrc - q0) + kap D2 == 0, gam1 (1 - q0) - gam2 D2 == 0},
  {q0, D2}] // First;
check["Prog4: fixed point q0* = 1 - (gam2/gam1)(1-qsrc)/(kap + gam2/gam1)",
  Simplify[(q0 /. fp) - (1 - (gam2/gam1) (1 - qsrc)/(kap + gam2/gam1))] == 0];
check["Prog4: q0* -> 1 for marginal saturation gam2 -> 0 (clamping)",
  Simplify[Limit[q0 /. fp, gam2 -> 0]] == 1];
jac = D[{((qsrc - q0) + kap D2)/tau, 2 gam1 (1 - q0) D2 - 2 gam2 D2^2},
  {{q0, D2}}] /. fp // Simplify;
evs = Eigenvalues[jac /. {qsrc -> 0.9, kap -> 1, gam1 -> 50, gam2 -> 5,
  tau -> 1}];
check["Prog4: fixed point is a stable spiral (damped oscillations) for stiff drive",
  Max[Re[evs]] < 0 && Abs[Im[First[evs]]] > 0];

sol = NDSolve[{q0'[t] == ((0.9 - q0[t]) + 1 D2[t]),
  D2'[t] == 2 50 (1 - q0[t]) D2[t] - 2 5 D2[t]^2,
  q0[0] == 1.02, D2[0] == 10^-4}, {q0, D2}, {t, 0, 30}][[1]];
solOff = NDSolve[{q0'[t] == (0.9 - q0[t]), q0[0] == 1.02}, q0, {t, 0, 30}][[1]];
figP = GraphicsRow[{
  Plot[{q0[t] /. sol, q0[t] /. solOff, 1}, {t, 0, 30},
    PlotStyle -> {{ColorData[97, 1], Thick}, {ColorData[97, 2], Dashed},
      {Gray, Dotted}},
    Frame -> True, FrameLabel -> {"t/\[Tau]", "\!\(\*SubscriptBox[\(q\), \(0\)]\)"},
    PlotLegends -> Placed[{"with (1,1) feedback", "no feedback", "q = 1"},
      {0.62, 0.35}], PlotRange -> {0.85, 1.05}],
  StreamPlot[{((0.9 - qq) + dd), 2 50 (1 - qq) dd - 2 5 dd^2},
    {qq, 0.88, 1.03}, {dd, 0, 0.12},
    FrameLabel -> {"\!\(\*SubscriptBox[\(q\), \(0\)]\)",
      "mode intensity \!\(\*SuperscriptBox[\(\[CapitalDelta]\), \(2\)]\) [arb.]"},
    StreamStyle -> Gray,
    Epilog -> {Red, PointSize[0.02],
      Point[{q0 /. fp, D2 /. fp} /. {qsrc -> 0.9, kap -> 1, gam1 -> 50,
        gam2 -> 5}]}]}, ImageSize -> 800];
Export[FileNameJoin[{figdir, "fig_fp_phase_portrait.pdf"}], figP];
Print["    exported fig_fp_phase_portrait.pdf"];

(* ==== 5. AUG hybrid numbers: available vs needed helical current ==== *)

clight = 2.99792458 10^10; ee = 4.80320425 10^-10; me = 9.1093837 10^-28;
erg = 1.602176634 10^-12;
Te = 3 10^3 erg; ne = 6 10^13; B0 = 2 10^4; Rmaj = 170.; rc = 10.;
lnL = 16.;
vTe = Sqrt[Te/me];
qp = 0.002;                       (* dq/dr [1/cm], weak-shear hybrid core *)
kp = qp/(1^2 Rmaj);               (* |kpar'| = q'/(q^2 R) [1/cm^2] *)
Ln = 100.; nep = ne/Ln;
nuE = 2.91 10^-6 ne lnL (Te/erg)^(-3/2);   (* NRL electron collision rate *)
wEex = 5 10^2;                    (* core ExB frequency estimate [1/s] *)
ZDel = (I nuE - wEex)/(Sqrt[2] vTe kp rc);
Print["    vTe [cm/s], kpar' [cm^-2], nu_e [1/s], |Z_Del|: ",
  {vTe, kp, nuE, Abs[ZDel]}];
check["Prog5: helical-core layer is in the collisionless Kramp regime, |Z| << 1",
  Abs[ZDel] < 0.1];

(* Available integral current per unit h_A (Appendix B, collisionless):
   I/h_A = Sqrt[2 Pi] e ne' vTe/|kpar'|  [statA/cm]. Spread over the core
   half-width rc: equivalent current density jm ~ I/(h_A rc). *)
IoverH = Sqrt[2 Pi] ee nep vTe/kp;
(* FP amplitude: h_A = |kpar| xi ~ kp (rc/2) xi, misalignment fraction fMA. *)
hA[xi_, fMA_] := kp (rc/2) xi fMA;
jmAvail[xi_, fMA_] := IoverH hA[xi, fMA]/rc;
(* Needed: from the Ampere model, the clamping redistribution peaks at
   ~0.1 x central current density; AUG hybrid j0 ~ 150 A/cm^2. *)
j0AUG = 150. 2.99792458 10^9;   (* statA/cm^2 *)
jmNeed = 0.1 j0AUG;
fMAneed[xi_] := fMA /. FindRoot[jmAvail[xi, fMA] - jmNeed, {fMA, 0.01, 0., 1.}];
Print["    I/h_A [statA/cm, A/cm]: ", {IoverH, IoverH/(2.998 10^9)}];
Print["    available jm(xi = 2 cm, fMA = 1) vs needed [A/cm^2]: ",
  {jmAvail[2., 1.]/(2.998 10^9), jmNeed/(2.998 10^9)}];
Print["    misalignment fraction needed at xi = 2 cm: ", fMAneed[2.]];
check["Prog5: xi ~ cm corrugation with SMALL misalignment fraction suffices",
  fMAneed[2.] < 0.1];

figE = ContourPlot[
  Log10[jmAvail[xi, 10^lfMA]/jmNeed], {xi, 0.2, 5}, {lfMA, -4, 0},
  Contours -> Range[-3, 3], ContourShading -> Automatic,
  ColorFunction -> "TemperatureMap",
  FrameLabel -> {"corrugation \[Xi] [cm]",
    "log10 misalignment fraction \!\(\*SubscriptBox[\(f\), \(MA\)]\)"},
  PlotLegends -> BarLegend[Automatic,
    LegendLabel -> "log10(available/needed)"],
  Epilog -> {Black, Thick,
    Line[Table[{xi, Log10[fMAneed[xi]]}, {xi, 0.2, 5, 0.2}]],
    Text[Style["marginal clamping", 11, Bold], {3.2, Log10[fMAneed[3.2]] + 0.25}]},
  ImageSize -> 480];
Export[FileNameJoin[{figdir, "fig_fp_current_estimate.pdf"}], figE];
Print["    exported fig_fp_current_estimate.pdf"];

reportAndExit[];

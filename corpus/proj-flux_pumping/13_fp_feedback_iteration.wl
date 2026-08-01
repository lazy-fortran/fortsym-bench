(* Flux-pumping feedback iteration (SK mail P.S. 2026-07-06): compute the
   parallel current response to a FIXED single-harmonic potential and
   corrugation via the lowest-order susceptibility (first term of the
   cylinder response, Lainer et al. Eq. (2)/(29); Krook form verified in
   script 11), redistribute it with the generalized total-derivative
   formula (script 08), close with 1D Ampere, and iterate the q-profile.
   Question posed by SK: does the iteration converge to a flat q-profile?

   Model, cylinder, (m,n) = (-1,1), phase Exp[I(m th + n ph)], CGS-normalized
   units of script 08 (current in units of the axis current density j0,
   r in cm, background q = q0b (1 + (r/aj)^2), Gaussian ECCD overdrive):

   - k_par(r) prop (q(r) - 1): resonance where q = 1.
   - response harmonic j_m(r) = lambda_fb Phi(r) L(qhat), L(k) = k/(k^2 + nu^2):
     the regularized 1/k_par susceptibility response (grows towards the
     resonant surface, sign flips across it). lambda_fb is the neutral
     feedback-coupling constant of this prescribed-profile iteration; it is
     NOT the scalar-closure response strength mu of the report Sec. 4.3, and
     kappa stays reserved for |k| in the report's Maxwell section.
   - in-phase overlap c_ph = cos(alpha - beta) between the current harmonic
     and the corrugation: set by the mode structure (JOREK input in
     reality); c_ph > 0 is the pumping branch.
   - redistribution: enc_FP(r) = c_ph r j_m(r) Delta(r)/2 EXACTLY (the
     generalized formula is a total derivative, script 08), so Ampere
     closure needs no quadrature and net current conservation is exact.
   - iteration with under-relaxation lambda. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];
figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];

(* ==== Background: script 08 clamping model ==== *)
q0b = 1.02; aj = 50.; wcd = 6.; acd = 0.10;
encBase[rr_] := rr^2/(2 (1 + (rr/aj)^2));
encCD[rr_] := acd (wcd^2/2) (1 - Exp[-(rr/wcd)^2]);
enc0[rr_] := encBase[rr] + encCD[rr];
qOf[encf_, rr_] := q0b rr^2/(2 encf[rr]);
check["background: CD overdrive pushes q(0) below 1",
  qOf[enc0, 0.01] < 1];

(* ==== Fixed perturbation profiles ==== *)
(* Axis regularity for |m| = 1: the potential harmonic vanishes like r,
   so the response current harmonic does too and the redistributed
   enclosed current scales as r^2 (regular axis current density). *)
rc = 10.;                      (* helical-core extent, cm *)
PhiProf[rr_] := (rr/rc) Exp[-(rr/rc)^2];  (* potential amplitude, norm. *)
DeltaProf[rr_] := 2. Exp[-(rr/rc)^2];     (* corrugation = displacement, cm *)

(* ==== Susceptibility response, Krook-regularized ==== *)
(* L(k) = k/(k^2 + nu^2): odd in k, ~ 1/k off resonance (the susceptibility
   decay-as-distance-squared per unit E_par: j = chi E_par, chi ~ 1/k^2,
   E_par ~ k Phi). Regularization width nuhat plays the role of the layer
   width in units of q - 1. *)
nuhat = 0.02;
Lresp[k_] := k/(k^2 + nuhat^2);
check["response reduces to 1/k_par away from the layer",
  Abs[Lresp[10 nuhat] 10 nuhat - 1] < 0.011];
check["response is odd across the resonant surface",
  Lresp[-3 nuhat] == -Lresp[3 nuhat]];

(* ==== Feedback fixed point ==== *)
(* enc_FP(r) = c_ph lambda_fb r Phi(r) L(q(r)-1) Delta(r) / 2; q from Ampere:
   q (2 enc0 + c lambda_fb r Phi Delta L(q-1)) = q0b r^2. Because the
   generalized redistribution integrates exactly (total derivative), the
   fixed-point condition is POINTWISE in r: with the rational L it is a
   cubic in q, solved exactly per radius (root continuous from the
   unperturbed branch). The under-relaxed iteration doubles as the
   dynamical (resistive-relaxation) check that this root is the attractor. *)
rmax = 30.; ngrid = 601;
rgrid = Table[rmax ii/ngrid, {ii, 1, ngrid}];

(* Exact pointwise fixed point by branch following: march inward from the
   edge (drive -> 0 there), at each radius pick the real cubic root closest
   to the neighbouring solution. *)
fixedPointQ[lamfb_, cph_] := Module[{qprev, out},
  qprev = qOf[enc0, rmax];
  out = Table[0., {ngrid}];
  Do[Module[{rr = rgrid[[ii]], e0, gg, roots},
    e0 = enc0[rr];
    gg = cph lamfb rr PhiProf[rr] DeltaProf[rr]/2.;
    roots = qq /. NSolve[
      qq (2 e0 ((qq - 1)^2 + nuhat^2) + gg (qq - 1))
        == q0b rr^2 ((qq - 1)^2 + nuhat^2), qq, Reals];
    qprev = First[MinimalBy[roots, Abs[# - qprev] &]];
    out[[ii]] = qprev],
    {ii, ngrid, 1, -1}];
  out];

iterateFP[lamfb_, cph_, lambda_, niter_] := Module[
  {encFP, encFPnew, qvals, hist = {}, resid = Table[0., {niter}], kk},
  encFP = Table[0., {ngrid}];
  Do[
    qvals = q0b rgrid^2/(2 (enc0[rgrid] + encFP));
    encFPnew = cph lamfb rgrid PhiProf[rgrid]*
      Map[Lresp, qvals - 1.] DeltaProf[rgrid]/2.;
    resid[[kk]] = Max[Abs[encFPnew - encFP]];
    If[Mod[kk, 50] == 1, AppendTo[hist, qvals]];
    encFP = (1 - lambda) encFP + lambda encFPnew;
    , {kk, niter}];
  <|"q" -> qvals, "encFP" -> encFP, "resid" -> resid, "hist" -> hist|>];

(* Pumping branch, three drive strengths. The layer response is stiff
   (|dL/dk| up to 1/nuhat^2), so the plain Picard map needs strong
   under-relaxation for the larger drives; the exact root is from the
   cubic in any case. *)
weak = iterateFP[0.02, 1, 0.05, 2000];
med = iterateFP[0.2, 1, 0.005, 20000];
strong = iterateFP[2.0, 1, 0.001, 150000];
anti = iterateFP[0.2, -1, 0.005, 20000];
qroot = fixedPointQ[2.0, 1];
Print["    strong drive: max|q_iter - q_root| = ",
  ScientificForm[Max[Abs[strong["q"] - qroot]], 2]];

qmin[res_] := Min[res["q"][[1 ;; Round[ngrid rc 1.2/rmax]]]];
qaxis[res_] := res["q"][[1]];

Print["    weak   lambda_fb=0.02: q(0) = ", Round[qaxis[weak], 0.0001],
  ", min core q = ", Round[qmin[weak], 0.0001],
  ", final residual = ", ScientificForm[Last[weak["resid"]], 2]];
Print["    medium lambda_fb=0.2 : q(0) = ", Round[qaxis[med], 0.0001],
  ", min core q = ", Round[qmin[med], 0.0001],
  ", final residual = ", ScientificForm[Last[med["resid"]], 2]];
Print["    strong lambda_fb=2.0 : q(0) = ", Round[qaxis[strong], 0.0001],
  ", min core q = ", Round[qmin[strong], 0.0001],
  ", final residual = ", ScientificForm[Last[strong["resid"]], 2]];
Print["    anti-phase lambda_fb=0.2: q(0) = ", Round[qaxis[anti], 0.0001],
  ", min core q = ", Round[qmin[anti], 0.0001]];

check["pumping branch converges (medium drive)",
  Last[med["resid"]] < 10^-6];
(* Comparison against the branch-followed root is done in the core only:
   in the outer wing the cubic is bistable (three real roots; hysteresis
   of pumped states) and the slowly-relaxing dynamics may sit on another
   branch. *)
check["iterate matches the branch-followed exact root in the core",
  Module[{nc = Round[ngrid rc/rmax]},
    Max[Abs[strong["q"][[1 ;; nc]] - qroot[[1 ;; nc]]]] < 10^-2]];
check["exact fixed point is clamped: core min q within layer width of 1",
  Module[{qc = qroot[[1 ;; Round[ngrid rc/rmax]]]},
    Abs[Min[qc] - 1] < 3 nuhat && Max[qc] - Min[qc] < 5 nuhat]];
check["medium drive lifts the core q towards 1",
  qmin[med] > qmin[weak] && qaxis[med] > qOf[enc0, 0.01]];
check["strong drive clamps the core: min q within the layer width of 1",
  Abs[qmin[strong] - 1] < 3 nuhat];
check["strong drive flattens q: core variation within the layer scale",
  Module[{qc = strong["q"][[1 ;; Round[ngrid rc/rmax]]]},
    Max[qc] - Min[qc] < 5 nuhat]];
check["anti-phase drive deepens the q < 1 well (no pumping)",
  qmin[anti] < qmin[weak]];
check["net toroidal current conserved (edge enc_FP exponentially small)",
  Abs[Last[med["encFP"]]] < 10^-5 Max[Abs[med["encFP"]]] &&
  Abs[Last[strong["encFP"]]] < 10^-5 Max[Abs[strong["encFP"]]]];

(* ==== Figures ==== *)
(* Legend symbol: lambda_fb, the neutral feedback-coupling constant defined
   in the legend header of every figure (kappa is reserved for |k| and mu
   for the scalar-closure response strength in the report). *)
lamfbStr[v_] := "\!\(\*SubscriptBox[\(\[Lambda]\), \(fb\)]\) = " <> v;
lamfbDef = Style[
  "\!\(\*SubscriptBox[\(j\), \(m\)]\) = \!\(\*SubscriptBox[\(\[Lambda]\), \(fb\)]\)\[ThinSpace]\[CapitalPhi]\[ThinSpace]L(q - 1)",
  10];

qInit = q0b rgrid^2/(2 enc0[rgrid]);

figQ = Show[
  ListLinePlot[{Transpose[{rgrid, qInit}],
    Transpose[{rgrid, weak["q"]}], Transpose[{rgrid, med["q"]}],
    Transpose[{rgrid, strong["q"]}]},
    PlotStyle -> {Directive[Gray, Dashed], ColorData[97][3],
      ColorData[97][2], Directive[Thick, ColorData[97][1]]},
    PlotLegends -> Placed[LineLegend[{"initial (ECCD overdriven)",
      lamfbStr["0.02"], lamfbStr["0.2"], lamfbStr["2"]},
      LegendLabel -> lamfbDef], {0.35, 0.75}],
    Frame -> True, FrameLabel -> {"r [cm]", "q"},
    PlotRange -> {{0, 25}, {0.9, 1.15}}],
  Graphics[{Black, Dotted, Line[{{0, 1}, {25, 1}}]}],
  ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_fp_feedback_q.pdf"}], figQ];
check["[exists] fig_fp_feedback_q exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_fp_feedback_q.pdf"}]]];

figConv = ListLogPlot[
  {weak["resid"], med["resid"], strong["resid"]},
  Joined -> True,
  PlotStyle -> {ColorData[97][3], ColorData[97][2], ColorData[97][1]},
  PlotLegends -> Placed[LineLegend[{lamfbStr["0.02"], lamfbStr["0.2"],
    lamfbStr["2"]}, LegendLabel -> lamfbDef], {0.8, 0.8}],
  Frame -> True, FrameLabel -> {"iteration", "residual max|\[CapitalDelta]enc|"},
  PlotRange -> All, ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_fp_feedback_conv.pdf"}], figConv];
check["[exists] fig_fp_feedback_conv exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_fp_feedback_conv.pdf"}]]];

(* Approach of q(0) to the clamped state: distance to 1 on log scale,
   iteration axis rescaled by the snapshot stride. *)
axTrace[res_] := Module[{v = 1. - res["hist"][[All, 1]]},
  Transpose[{50 Range[Length[v]], Clip[v, {10^-6, 1}]}]];
figAxis = ListLogLogPlot[
  {axTrace[weak], axTrace[med], axTrace[strong]},
  Joined -> True,
  PlotStyle -> {ColorData[97][3], ColorData[97][2], ColorData[97][1]},
  PlotLegends -> Placed[LineLegend[{lamfbStr["0.02"], lamfbStr["0.2"],
    lamfbStr["2"]}, LegendLabel -> lamfbDef], {0.25, 0.35}],
  Frame -> True, FrameLabel -> {"iteration", "1 - q(0)"},
  PlotRange -> All, ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_fp_feedback_qaxis.pdf"}], figAxis];
check["[exists] fig_fp_feedback_qaxis exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_fp_feedback_qaxis.pdf"}]]];

(* Final current structure: helical response harmonic and its average
   jbar = (1/r) d(encFP)/dr from the exact enclosed current *)
jbar = Module[{d = Differences[strong["encFP"]]/Differences[rgrid]},
  Prepend[d, First[d]]/rgrid];
figJ = ListLinePlot[
  {Transpose[{rgrid, 2.0 PhiProf[rgrid] Map[Lresp, strong["q"] - 1.]}],
   Transpose[{rgrid, jbar}]},
  PlotStyle -> {ColorData[97][1], Directive[Thick, ColorData[97][4]]},
  PlotLegends -> Placed[{"helical response j_m (in-phase part)",
    "redistributed \[LeftAngleBracket]j\[RightAngleBracket]"}, {0.75, 0.8}],
  Frame -> True, FrameLabel -> {"r [cm]", "current density [j0 units]"},
  PlotRange -> All, ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_fp_feedback_current.pdf"}], figJ];
check["[exists] fig_fp_feedback_current exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_fp_feedback_current.pdf"}]]];

reportAndExit[];

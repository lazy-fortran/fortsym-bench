(* Kinetic-vs-MHD common-limit benchmark and the real-parameter AUG
   quantification (meeting follow-up 2026-07-20). Part A derives the
   static (omega = 0) parallel response of a Krook-collisional
   Maxwellian to a helical field-aligned electric field
   E_par Exp[I k z]: sigma = (n q^2/(m nu)) G(xi), xi = k v_t/nu.
   PASS-checked: G(0) = 1 - the kinetic response reduces EXACTLY to
   the local Ohm law of resistive MHD in the collisional limit (the
   common validity region); the first correction is -3 xi^2; and
   G -> 1/xi^2 as xi -> infinity - the static collisionless response
   is adiabatic screening with VANISHING parallel DC current, so a
   resistive-MHD Ohm closure has no kinetic backing at large xi.
   Part B evaluates the real AUG #36663 numbers of Zhang 2025
   (literature/notes/zhang25.md): eta0 = 2.41e-9 Ohm m, B0 = 2.57 T,
   n = 0.98e20 m^-3, R0 = 1.716 m, DeltaJ_phi = 0.8 MA/m^2, required
   field 1.6 mV/m. Verified numerically: (1) eta0 DeltaJ_phi
   reproduces the paper's 1.6 mV/m within 25 percent - the
   resistive bridge is arithmetically consistent; (2) the effective
   collision rate nu_eff = n e^2 eta0/m_e gives a parallel mean free
   path of about 4 km, so at the pumped-state detuning |q - 1| =
   0.01 the parameter xi is about 25: the flux-pumped AUG core is
   DEEP in the kinetic regime; (3) the local-Ohm validity layer
   around the rational surface is |q - 1| < about 4e-4, far
   narrower than every reported detuning; (4) the kinetic
   suppression factor G(xi) at |q - 1| = 0.01 is of order 1e-3, so
   a fluid Ohm closure overestimates the parallel current response
   at fixed E_par by roughly three orders of magnitude there - the
   quantified kinetic-vs-MHD difference for the real AUG case, and
   the memo's argument for kinetic modelling with a number attached;
   (5) the geometric corrugation-resistance deficit (script 39) with
   the tangency-locked amplitude at the near-resonant detuning is
   negligible for AUG (deficit of order 1e-7, dynamo field of order
   1e-9 V/m versus the 1.6e-3 V/m balance): in the near-resonant
   flux-pumped core the mean-current physics is carried by the
   misalignment-drive channel (script 40), not by the geometric
   path-length channel, which dominates only at strong detuning.
   Caveats stated: Krook model, static limit, E_par channel only
   (thermodynamic A1/A2 drives excluded), nu_eff defined through
   eta0 (absorbing Spitzer and Z_eff factors). Part C brackets the
   toroidal-equilibrium error of the core cylinder: a representative
   beta_p=1.5 gives epsilon beta_p=0.13--0.17 at r=0.15--0.20 m and
   0.44 at a=0.50 m. The accepted VMEC matched-pair response converts
   the core bracket to an estimated 2.0--2.6 percent absolute-q floor.
   Redl-minus-sigma1 comparisons share the geometry and remain useful
   as differential observables; their absolute q values do not beat
   that floor.
   Exports fig_kinetic_mhd_bridge.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];

(* ==== A. Static Krook parallel response ==== *)

ClearAll[v, k, nu, vt, xi, zeta];
$Assumptions = vt > 0 && nu > 0 && k > 0;

f0hat[v_] := Exp[-v^2/(2 vt^2)]/(Sqrt[2 Pi] vt);
(* sigma = (n q^2/(m vt^2)) Integrate[v^2 f0hat/(I k v + nu)];
   normalize G = sigma/(n q^2/(m nu)). *)
integralG = Integrate[v^2 f0hat[v]/(I k v + nu), {v, -Infinity, Infinity},
  Assumptions -> vt > 0 && nu > 0 && k > 0];
Gfun = Simplify[(nu/vt^2) integralG];

check["G is real for real parameters (screening response is in phase)",
  Simplify[ComplexExpand[Im[Gfun /. {nu -> 1, k -> 1, vt -> 1}]],
    TargetFunctions -> {Re, Im}] === 0 ||
  Abs[Im[N[Gfun /. {nu -> 1., k -> 1., vt -> 1.}]]] < 10^-12];

Gxi[xiv_] = Simplify[Gfun /. {k -> xiv nu/vt} /. vt -> 1 /. nu -> 1];

(* The closed form has an essential singularity at xi = 0 (Erfc of a
   large argument times a huge exponential), so the collisional limit
   is established from the exact moment expansion of the integral:
   1/(1 + I u) averaged over the Maxwellian gives even moments
   <v^2>/vt^2 = 1, <v^4>/vt^4 = 3, <v^6>/vt^6 = 15, hence
   G = 1 - 3 xi^2 + 15 xi^4 - ... . *)
check["collisional limit: G(0) = 1 from the exact second moment",
  Simplify[Integrate[v^2 f0hat[v], {v, -Infinity, Infinity}]/vt^2]
    === 1];
check["first kinetic correction is -3 xi^2 from the exact fourth moment",
  Simplify[Integrate[v^4 f0hat[v], {v, -Infinity, Infinity}]/vt^4]
    === 3];
check["closed form matches the moment expansion at xi = 0.1",
  Abs[Gxi[0.1] - (1 - 3 0.1^2 + 15 0.1^4)] < 2 10^-4];
check["static collisionless limit: G ~ 1/xi^2, vanishing DC current",
  Simplify[Limit[x^2 Gxi[x], x -> Infinity]] === 1];

(* Crossover: G drops to 1/2 near xi ~ 0.4; numeric root pins the
   validity boundary of the local Ohm closure. *)
xiHalf = x /. FindRoot[Gxi[x] == 1/2, {x, 0.4}];
check["local-Ohm validity boundary sits at xi of order unity",
  0.1 < xiHalf < 1.];

(* ==== B. AUG #36663 numbers (SI) ==== *)

eta0 = 2.41 10^-9; bb0 = 2.57; nne = 0.98 10^20; rr0 = 4.41/2.57;
dJphi = 0.8 10^6; eReq = 1.6 10^-3; jCore = 2.5 10^6;
me = 9.1093837 10^-31; ee = 1.602177 10^-19;

check["AUG: eta0 DeltaJ_phi reproduces the reported 1.6 mV/m within 25 percent",
  Abs[eta0 dJphi/eReq - 1] < 0.25];

(* Electron temperature from Spitzer inversion (lnLambda = 15,
   Z_eff absorbed): eta_Sp ~ 1.65e-9 lnLambda/Te_keV^(3/2). *)
teKev = (1.65 10^-9 15/eta0)^(2/3);
vte = Sqrt[teKev 10^3 ee/me];
nuEff = nne ee^2 eta0/me;
lambdaMfp = vte/nuEff;
Print["    AUG derived: Te = ", NumberForm[teKev, 3], " keV, v_te = ",
  ScientificForm[vte, 3], " m/s, nu_eff = ", NumberForm[nuEff, 4],
  " 1/s, lambda_mfp = ", NumberForm[lambdaMfp, 4], " m"];
check["AUG: parallel mean free path is kilometres",
  1000. < lambdaMfp < 20000.];

kPar[dq_] := dq/rr0;
xiOf[dq_] := kPar[dq] lambdaMfp;
check["AUG: at the pumped-state detuning |q-1| = 0.01 the core is deeply kinetic",
  xiOf[0.01] > 10.];
dqOhm = xiHalf rr0/lambdaMfp;
Print["    AUG: xi(|q-1| = 0.01) = ", NumberForm[xiOf[0.01], 4],
  ";  local-Ohm layer |q-1| < ", ScientificForm[dqOhm, 3]];
check["AUG: the local-Ohm layer is narrower than 1e-3 in q",
  dqOhm < 10^-3];
suppression = Gxi[xiOf[0.01]];
Print["    AUG: kinetic suppression G(xi) at |q-1| = 0.01 is ",
  ScientificForm[suppression, 3]];
check["AUG: fluid Ohm overestimates the parallel response by about 1e3",
  10^-4 < suppression < 10^-2];

(* Corrugation-resistance channel with the tangency-locked amplitude
   at the near-resonant detuning: deficit ~ (3/2)(Delta D/B)^2 with
   displacement Delta = 5 cm, D/B = (1/R0)|1/q - 1| at |q-1| = 0.01;
   the resulting dynamo field is negligible against 1.6 mV/m. *)
deltaHel = 0.05;
dOverB = Abs[0.01]/rr0;
deficitCorr = (3/2) (deltaHel dOverB)^2;
eDynCorr = eta0 jCore deficitCorr;
Print["    AUG: corrugation-resistance deficit = ",
  ScientificForm[deficitCorr, 3], ", dynamo field = ",
  ScientificForm[eDynCorr, 3], " V/m vs required ",
  ScientificForm[eReq, 2], " V/m"];
check["AUG: geometric corrugation resistance is negligible near resonance",
  eDynCorr < 10^-6 eReq/10^-3];
check["AUG: hence the near-resonant mean-current supply must be the misalignment channel",
  eDynCorr/eReq < 10^-4];

(* ==== C. Toroidal-equilibrium floor of the core cylinder ==== *)

(* Zhang reports beta_N=2.9, not a local beta_p profile. We therefore use
   beta_p=1.5 as an explicit representative bracket below the beta_p~2
   transition scale, never as a reconstructed measurement. The small-aspect
   ordering parameter is epsilon beta_p. The conversion to a q-error estimate
   uses the accepted classic-VMEC matched pair at aspect 10:
     epsilon beta_p=0.1809483, relative q_edge drift=0.0269081.
   This is an empirical scale estimate, not a universal coefficient. *)
betaPRepresentative = 1.5;
rCoreBracket = {0.15, 0.20};
aAug = 0.50;
epsBetaCore = betaPRepresentative rCoreBracket/rr0;
epsBetaWhole = betaPRepresentative aAug/rr0;
vmecEpsBeta = 0.1809482656966454;
vmecQDrift = 0.02690807725830191;
vmecQScale = vmecQDrift/vmecEpsBeta;
qFloorCore = vmecQScale epsBetaCore;
Print["    AUG cylinder bracket: eps beta_p(core) = ", epsBetaCore,
  ", whole-machine = ", NumberForm[epsBetaWhole, 4],
  ", estimated absolute-q floor = ", qFloorCore];
check["AUG: representative core epsilon beta_p lies in the 0.13--0.18 bracket",
  0.13 < Min[epsBetaCore] < 0.14 &&
    0.17 < Max[epsBetaCore] < 0.18];
check["AUG: representative whole-machine epsilon beta_p is 0.4--0.5",
  0.4 < epsBetaWhole < 0.5];
check["VMEC-calibrated absolute core-cylinder q floor is percent-level",
  0.019 < Min[qFloorCore] && Max[qFloorCore] < 0.027];
check["K1 differential kinetic shifts overlap the absolute toroidal floor",
  IntervalIntersection[Interval[{0.003, 0.025}],
    Interval[{Min[qFloorCore], Max[qFloorCore]}]] =!= Interval[]];

(* ==== D. Figure ==== *)
figKM = GraphicsRow[{
  LogLogPlot[{Gxi[x], 1/x^2}, {x, 0.01, 100},
    PlotRange -> {{0.01, 100}, {10^-5, 2}}, Frame -> True,
    FrameLabel -> {"\[Xi] = k_par \[Lambda]_mfp", "G"},
    PlotLegends -> {"kinetic G(\[Xi])", "1/\[Xi]^2"},
    PlotLabel -> "static parallel response vs collisionality",
    GridLines -> {{xiHalf, xiOf[0.01]}, {1}}, ImageSize -> 320],
  LogLogPlot[Gxi[dq lambdaMfp/rr0], {dq, 10^-5, 0.1},
    PlotRange -> All, Frame -> True,
    FrameLabel -> {"|q - 1|", "G"},
    PlotLabel -> "AUG #36663: Ohm validity vs detuning",
    GridLines -> {{dqOhm, 0.01}, {0.5}}, ImageSize -> 320]},
  ImageSize -> 660];
Export[FileNameJoin[{figdir, "fig_kinetic_mhd_bridge.pdf"}], figKM];
Print["    exported fig_kinetic_mhd_bridge.pdf"];
check["Fig: kinetic-MHD bridge figure exported",
  FileByteCount[FileNameJoin[{figdir,
    "fig_kinetic_mhd_bridge.pdf"}]] > 5000];

reportAndExit[];

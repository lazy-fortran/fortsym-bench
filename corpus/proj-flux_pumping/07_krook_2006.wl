(* The "old (wrong) paper" Kasilov et al., Contrib. Plasma Phys. 46, 711
   (2006): rotating-field current drive near rational q_min, computed with a
   Krook collision model. Sergei (mail 2026-07-06): the known error is that
   Krook does not conserve particles, so the result is not Galilean
   invariant; the model is only valid in the collisionless limit where nu_c
   merely sets the Landau contour shift. This script makes each part of that
   statement precise. 1D parallel dynamics, fM = n0 Exp[-v^2/(2 vT^2)]/
   (Sqrt[2 Pi] vT), wave phase Exp[I(k x - w t)], Faddeeva
   W(z) = Exp[-z^2] Erfc[-I z], plasma dispersion Z(zeta) = I Sqrt[Pi] W(zeta).
   Exports fig_krook_artifact.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];

fM[v_] := n0 Exp[-v^2/(2 vT^2)]/(Sqrt[2 Pi] vT);
assum = n0 > 0 && vT > 0 && Vd \[Element] Reals;

(* --- Check K1: Krook does not conserve particles. ---
   For a test perturbation df = (a0 + a1 v + a2 v^2) fM the density moment of
   C_Krook = -nu df is -nu dn, nonzero whenever dn != 0. *)
df[v_] := (a0 + a1 v + a2 v^2) fM[v];
dn = Integrate[df[v], {v, -Infinity, Infinity}, Assumptions -> assum];
momKrook = Integrate[-nu df[v], {v, -Infinity, Infinity}, Assumptions -> assum];
check["2006/K1: particle moment of Krook operator = -nu dn (nonzero)",
  Simplify[momKrook + nu dn] == 0];

(* Density-restoring BGK removes the defect for any df of this family. *)
cBGK[v_] := -nu (df[v] - (dn/n0) fM[v]);
check["2006/K1: density-restoring BGK conserves particles",
  Simplify[Integrate[cBGK[v], {v, -Infinity, Infinity},
    Assumptions -> assum]] == 0];

(* --- Check K2: spurious relaxation of a rigidly drifting Maxwellian. ---
   Full Krook C[f] = -nu (f - fM) applied to fM(v - Vd): zero particle
   moment, but momentum moment -m nu n0 Vd: a rigid drift decays at rate nu
   with no physical counterpart selected by the model. The size of the
   artifact is set by the frame in which the target Maxwellian is pinned:
   the operator is not Galilean covariant. *)
cShift[v_] := -nu (fM[v - Vd] - fM[v]);
check["2006/K2: particle moment of C[fM(v - Vd)] vanishes",
  Simplify[Integrate[cShift[v], {v, -Infinity, Infinity},
    Assumptions -> assum]] == 0];
check["2006/K2: momentum moment of C[fM(v - Vd)] = -nu n0 Vd (frame artifact)",
  Simplify[Integrate[v cShift[v], {v, -Infinity, Infinity},
    Assumptions -> assum] + nu n0 Vd] == 0];

(* A BGK operator that restores density AND mean velocity is covariant:
   boosting v -> v + V maps the operator onto itself. *)
uMean = Integrate[v df[v], {v, -Infinity, Infinity}, Assumptions -> assum]/n0;
cBGK2[v_] := -nu (df[v] - (dn/n0) fM[v] - uMean (v/vT^2) fM[v]);
check["2006/K2: density+momentum restoring BGK conserves both moments",
  Simplify[{Integrate[cBGK2[v], {v, -Infinity, Infinity}, Assumptions -> assum],
    Integrate[v cBGK2[v], {v, -Infinity, Infinity}, Assumptions -> assum]}
    == {0, 0}]];

(* --- Check K3: continuity with Krook carries a spurious particle sink. ---
   Linear response to a potential drive, (I(k v - w) + nu) df =
   -(e/m)(I k phi) fM'(v) [+ restoring term]. The velocity moment of the
   kinetic equation gives -I w dn + I k Gam = Int C dv: for Krook the RHS is
   -nu dn (fake sink), for the conserving operator it is 0, so only there
   Gam = (w/k) dn as continuity demands. Verify by explicit moments using
   the Faddeeva function. *)
zeta[w_, nu_, k_, vT_] := (w + I nu)/(Sqrt[2] k vT);
Wf[z_] := Exp[-z^2] Erfc[-I z];
Zpl[z_] := I Sqrt[Pi] Wf[z];
(* Moments of 1/(I(k v - w) + nu) = 1/(I k (v - Sqrt[2] vT zeta)):
   B  = Int fM/(...) dv    = (n0/(I k)) Zpl[zeta]/(Sqrt[2] vT)
   Bv = Int v fM/(...) dv  = (n0/(I k)) (1 + zeta Zpl[zeta])
   A  = Int fM'/(...) dv   = -Bv/vT^2 = -(n0/(I k)) (1 + zeta Zpl[zeta])/vT^2 *)
Bnum[w_?NumericQ, nu_?NumericQ, k_?NumericQ, vTn_?NumericQ] := NIntegrate[
  Exp[-v^2/(2 vTn^2)]/(Sqrt[2 Pi] vTn)/(I (k v - w) + nu),
  {v, -Infinity, Infinity}, WorkingPrecision -> 25, PrecisionGoal -> 10];
BvNum[w_?NumericQ, nu_?NumericQ, k_?NumericQ, vTn_?NumericQ] := NIntegrate[
  v Exp[-v^2/(2 vTn^2)]/(Sqrt[2 Pi] vTn)/(I (k v - w) + nu),
  {v, -Infinity, Infinity}, WorkingPrecision -> 25, PrecisionGoal -> 10];
ANum[w_?NumericQ, nu_?NumericQ, k_?NumericQ, vTn_?NumericQ] := NIntegrate[
  (-v/vTn^2) Exp[-v^2/(2 vTn^2)]/(Sqrt[2 Pi] vTn)/(I (k v - w) + nu),
  {v, -Infinity, Infinity}, WorkingPrecision -> 25, PrecisionGoal -> 10];
BAna[w_, nu_, k_, vTn_] := (1/(I k)) Zpl[zeta[w, nu, k, vTn]]/(Sqrt[2] vTn);
BvAna[w_, nu_, k_, vTn_] := (1/(I k)) (1 + zeta[w, nu, k, vTn] Zpl[zeta[w, nu, k, vTn]]);
AAna[w_, nu_, k_, vTn_] := -BvAna[w, nu, k, vTn]/vTn^2;
pars = {6/10, 3/10, 1, 1};
check["2006/K3: Faddeeva closed forms for the three response moments (numeric)",
  Abs[Bnum @@ pars - BAna @@ pars] < 10^-10 &&
  Abs[BvNum @@ pars - BvAna @@ pars] < 10^-10 &&
  Abs[ANum @@ pars - AAna @@ pars] < 10^-10];

(* Krook and conserving responses to drive q(v) = -(e/m)(I k phi) fM'(v);
   set (e/m) phi = 1. *)
dnKrook[w_, nu_, k_, vTn_] := -I k AAna[w, nu, k, vTn];
gamKrookNum[w_?NumericQ, nu_?NumericQ, k_?NumericQ, vTn_?NumericQ] :=
  NIntegrate[v (-I k) (-v/vTn^2) Exp[-v^2/(2 vTn^2)]/(Sqrt[2 Pi] vTn)/
    (I (k v - w) + nu), {v, -Infinity, Infinity},
    WorkingPrecision -> 25, PrecisionGoal -> 10];
contKrook = With[{w = 6/10, nu = 3/10, k = 1, vTn = 1},
  -I w dnKrook[w, nu, k, vTn] + I k gamKrookNum[w, nu, k, vTn] +
    nu dnKrook[w, nu, k, vTn]];
check["2006/K3: Krook continuity residual equals the fake sink -nu dn (numeric)",
  Abs[contKrook] < 10^-9];
dnCons[w_, nu_, k_, vTn_] := dnKrook[w, nu, k, vTn]/
  (1 - nu BAna[w, nu, k, vTn]);
gamConsNum[w_?NumericQ, nu_?NumericQ, k_?NumericQ, vTn_?NumericQ] :=
  Module[{dnc = dnCons[w, nu, k, vTn]},
    NIntegrate[v ((-I k) (-v/vTn^2) Exp[-v^2/(2 vTn^2)]/(Sqrt[2 Pi] vTn) +
      nu dnc Exp[-v^2/(2 vTn^2)]/(Sqrt[2 Pi] vTn))/(I (k v - w) + nu),
      {v, -Infinity, Infinity}, WorkingPrecision -> 25, PrecisionGoal -> 10]];
contCons = With[{w = 6/10, nu = 3/10, k = 1, vTn = 1},
  -I w dnCons[w, nu, k, vTn] + I k gamConsNum[w, nu, k, vTn]];
check["2006/K3: conserving operator satisfies continuity exactly (numeric)",
  Abs[contCons] < 10^-9];

(* --- Check K4: both models agree in the collisionless (Landau) limit. --- *)
check["2006/K4: dn_Krook = dn_conserving as nu -> 0+ (Landau contour only)",
  Module[{w = 6/10, k = 1, vTn = 1},
    Abs[dnKrook[w, 10^-8, k, vTn] - dnCons[w, 10^-8, k, vTn]] <
      10^-6 Abs[dnCons[w, 10^-8, k, vTn]]]];

(* --- Check K5: at finite nu the two differ at relative order nu B ~
   nu/(k vT): the size of the 2006 model artifact. --- *)
relDiff[w_, nu_, k_, vTn_] := Abs[dnKrook[w, nu, k, vTn]/dnCons[w, nu, k, vTn] - 1];
check["2006/K5: relative Krook artifact grows ~ linearly with nu/(k vT)",
  Module[{r1 = relDiff[6/10, 1/100, 1, 1], r2 = relDiff[6/10, 2/100, 1, 1]},
    1.7 < r2/r1 < 2.3]];

(* --- Figure: Krook vs conserving density response over collisionality. --- *)
fig = LogLogPlot[
  Evaluate[Table[relDiff[wv, nuv, 1, 1], {wv, {1/2, 1, 2}}] /. nuv -> nn],
  {nn, 10^-3, 3},
  PlotStyle -> {ColorData[97, 1], ColorData[97, 2], ColorData[97, 3]},
  Frame -> True,
  FrameLabel -> {"\[Nu]/(k \!\(\*SubscriptBox[\(v\), \(T\)]\))",
    "|\[Delta]\!\(\*SubscriptBox[\(n\), \(Krook\)]\)/\[Delta]\!\(\*SubscriptBox[\(n\), \(cons\)]\) - 1|"},
  PlotLegends -> LineLegend[
    {ColorData[97, 1], ColorData[97, 2], ColorData[97, 3]},
    {"\[Omega]/(k \!\(\*SubscriptBox[\(v\), \(T\)]\)) = 0.5",
     "\[Omega]/(k \!\(\*SubscriptBox[\(v\), \(T\)]\)) = 1",
     "\[Omega]/(k \!\(\*SubscriptBox[\(v\), \(T\)]\)) = 2"}],
  ImageSize -> 420,
  PlotLabel -> "Krook artifact in the density response (2006 model)"];
Export[FileNameJoin[{figdir, "fig_krook_artifact.pdf"}], fig];
Print["    exported fig_krook_artifact.pdf"];

reportAndExit[];

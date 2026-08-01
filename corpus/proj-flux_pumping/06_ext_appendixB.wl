(* Extended memo Appendix B (including the unchanged 2026-07-14 version):
   anomalous transport. Slab, Krook nu_c, diffusive
   turbulence D_A, kpar = kp x (kp = kpar'), phase Exp[I(m th + n ph)].
   Verifies (greensfun_four), (solkode), (solkode_noan), the reduction chain
   of (intcurr), the magnetic drive (intcurr_simpl) -> Kramp result
   (intcurr_simpl_noan)/(Zdel), the strong-diffusion limits, and the electric
   drive results, including Eqs. (B17)--(B19). Finds one erratum: the printed closed-form coefficient in
   (intcurr_simpl_anom_smallDr) disagrees with the memo's own preceding line;
   the correct value is 2^(1/3) Gamma[1/3]^3/(3^(7/6) Pi). Units: e = hA =
   ne' = 1; symbols vT, kp, dr (= Delta r), nu, wE, DA. Kramp function
   W(z) = Exp[-z^2] Erfc[-I z]. The k-integral with cubic damping is the
   Scorer function: Int_0^inf Exp[-a k^3 - b k] dk = Pi ScorerHi[-b/(3a)^(1/3)]
   /(3 (3a)^(1/3))... verified below numerically. Exports figures/. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];

W[z_] := Exp[-z^2] Erfc[-I z];

(* --- Check B1: Fourier transform of the Green's function equation,
   (greensfun) -> (greensfun_four). FT rules for Gk = Int dx E^(-I k x) G:
   d/dx -> I k, x -> I d/dk. *)
opFT = I kp vpar (I gkp) + (I wE + nu) gk + DA (I k)^2 (-1) gk;
memoFT = -kp vpar gkp + (DA k^2 + nu + I wE) gk;
check["AppB (greensfun_four): FT maps the operator to -kp v Gk' + (DA k^2 + nu + I wE) Gk",
  Simplify[opFT - memoFT] == 0];

(* (greencoord) has a typographical error in every ext-memo version through
   2026-07-14: the inverse-transform measure must be dk, not the printed dx. *)
gaussianForward = Integrate[Exp[-I k x] Exp[-x^2],
  {x, -Infinity, Infinity}, Assumptions -> k \[Element] Reals];
gaussianInverse = Integrate[Exp[I k x] gaussianForward,
  {k, -Infinity, Infinity}, Assumptions -> x \[Element] Reals]/(2 Pi);
check["AppB (greencoord) TYPO: inverse Fourier measure is dk (Gaussian round trip)",
  FullSimplify[gaussianInverse == Exp[-x^2], x \[Element] Reals]];

(* --- Check B2: (solkode) solves (greensfun_four). ---
   Gk = (1/(v kp)) Int_k^inf-sign dk' E2(k,k'),
   E2 = Exp[-I k' x0 + (DA/3 (k^3-k'^3) + (nu+I wE)(k-k'))/(v kp)].
   d/dk brings the boundary term -E2(k,k)/(v kp) and the factor
   (DA k^2 + nu + I wE)/(v kp) under the integral (jint). *)
dE2dk = (DA k^2 + nu + I wE)/(vpar kp);
residual = -kp vpar ((1/(vpar kp)) (-e2kk + dE2dk jint)) +
  (DA k^2 + nu + I wE) (1/(vpar kp)) jint;
check["AppB (solkode): integral-term coefficients cancel in the ODE residual",
  Simplify[Coefficient[residual, jint]] == 0];
check["AppB (solkode): boundary term reproduces the source E^(-I k x0)",
  Simplify[(residual /. jint -> 0) - e2kk] == 0];
check["AppB (solkode): E2(k,k) = E^(-I k x0)",
  Simplify[(Exp[-I kk x0 + (DA/3 (k^3 - kk^3) + (nu + I wE) (k - kk))/(vpar kp)]
    /. kk -> k) - Exp[-I k x0]] == 0];

(* --- Check B3: (solkode_noan), DA = 0, both signs of v kp. --- *)
gkNoan[s_] := (s/(vkpAbs s)) Exp[-I k x0] Integrate[
  Exp[-I s t x0 - (nu + I wE) t/vkpAbs], {t, 0, Infinity},
  Assumptions -> nu > 0 && vkpAbs > 0 && x0 \[Element] Reals &&
    wE \[Element] Reals];
check["AppB (solkode_noan): Gk = E^(-I k x0)/(I v kp x0 + I wE + nu), v kp > 0",
  Simplify[gkNoan[1] - Exp[-I k x0]/(I vkpAbs x0 + I wE + nu),
    Assumptions -> nu > 0 && vkpAbs > 0] == 0];
check["AppB (solkode_noan): same for v kp < 0",
  Simplify[gkNoan[-1] - Exp[-I k x0]/(I (-vkpAbs) x0 + I wE + nu),
    Assumptions -> nu > 0 && vkpAbs > 0] == 0];

(* --- Check B4: magnetic-drive source Fourier transform (top hat). --- *)
check["AppB: Int dx0 E^(-I k x0) over |x0| < dr gives 2 Sin[k dr]/k",
  Simplify[Integrate[Exp[-I kk x0], {x0, -dr, dr},
    Assumptions -> dr > 0 && kk \[Element] Reals] - 2 Sin[kk dr]/kk] == 0];

(* --- Check B5: 1D velocity reduction. --- *)
fM3 = ne (me/(2 Pi Te))^(3/2) Exp[-me (vx^2 + vy^2 + vz^2)/(2 Te)];
red = Integrate[fM3, {vx, -Infinity, Infinity}, {vy, -Infinity, Infinity},
  Assumptions -> me > 0 && Te > 0 && ne > 0];
check["AppB: perpendicular Maxwellian reduction to (ne/(Sqrt[2 Pi] vT)) E^(-vpar^2/(2 vT^2))",
  Simplify[(red /. vz -> vpar) -
    (ne/(Sqrt[2 Pi] Sqrt[Te/me])) Exp[-vpar^2/(2 (Te/me))],
    Assumptions -> me > 0 && Te > 0] == 0];

(* --- Check B6: Kramp-function identity used in (intcurr_simpl_noan). --- *)
krampInt = Integrate[Exp[-u^2 + 2 I z u], {u, 0, Infinity},
  Assumptions -> z \[Element] Complexes];
check["AppB: Int_0^inf E^(-u^2+2 I z u) du = (Sqrt[Pi]/2) W(z)",
  FullSimplify[krampInt - (Sqrt[Pi]/2) W[z],
    Assumptions -> z \[Element] Complexes] == 0];

(* --- Check B7: the (intcurr_simpl_noan) chain, symbolic. --- *)
vint1 = Integrate[vpar Exp[-vpar^2/(2 vT^2)] Sin[tau vpar kp dr],
  {vpar, -Infinity, Infinity}, Assumptions -> vT > 0 && tau > 0 && kp > 0 && dr > 0];
vint2 = tau kp dr vT^2 Integrate[Exp[-vpar^2/(2 vT^2)] Cos[tau vpar kp dr],
  {vpar, -Infinity, Infinity}, Assumptions -> vT > 0 && tau > 0 && kp > 0 && dr > 0];
check["AppB (intcurr_simpl_noan): integration by parts in vpar (line 3 = line 4)",
  Simplify[vint1 - vint2, Assumptions -> vT > 0 && tau > 0 && kp > 0 && dr > 0] == 0];
check["AppB (intcurr_simpl_noan): Gaussian vpar integral (line 4 = line 5)",
  Simplify[vint2 - Sqrt[2 Pi] vT^3 tau kp dr Exp[-(tau kp dr vT)^2/2],
    Assumptions -> vT > 0 && tau > 0 && kp > 0 && dr > 0] == 0];
Zdel = (I nu - wE)/(Sqrt[2] vT kp dr);
tauInt = Integrate[Exp[-(tau kp dr vT)^2/2 - (nu + I wE) tau], {tau, 0, Infinity},
  Assumptions -> vT > 0 && kp > 0 && dr > 0 && nu > 0 && wE \[Element] Reals];
check["AppB (intcurr_simpl_noan)+(Zdel): -2 vT^2 dr Int dtau ... = -Sqrt[2 Pi] (vT/kp) W(Zdel)",
  FullSimplify[-2 vT^2 dr tauInt - (-Sqrt[2 Pi] (vT/kp) W[Zdel]),
    Assumptions -> vT > 0 && kp > 0 && dr > 0 && nu > 0 && wE \[Element] Reals] == 0];

(* --- Check B8: full numeric cross-check of (intcurr_simpl_noan). --- *)
ibNoanNum[vT_, kp_, dr_, nu_, wE_] := -Sqrt[2/Pi]/(vT kp) NIntegrate[
  Abs[v] Exp[-v^2/(2 vT^2)] ArcTan[dr Abs[v] kp/(nu + I wE)],
  {v, -Infinity, Infinity}, PrecisionGoal -> 10, MaxRecursion -> 14];
testPars = {{1., 1., 0.8, 0.3, 0.7}, {1., 1., 3., 0.05, -1.5}, {2., 0.5, 1., 1., 0.25}};
Do[
  With[{vT = p[[1]], kp = p[[2]], dr = p[[3]], nu = p[[4]], wE = p[[5]]},
    num = ibNoanNum[vT, kp, dr, nu, wE];
    ana = -Sqrt[2 Pi] (vT/kp) W[(I nu - wE)/(Sqrt[2] vT kp dr)];
    check["AppB (intcurr_simpl_noan) numeric, pars " <> ToString[p],
      Abs[num - ana] < 10^-6 Abs[ana]]],
  {p, testPars}];

(* --- Scorer-function closed form for the cubic-damped k integral. --- *)
kint[a_, b_] := Pi ScorerHi[-b/(3 a)^(1/3)] Exp[0]/(3 a)^(1/3) /; NumericQ[a];
(* ScorerHi[z] = (1/Pi) Int_0^inf Exp[-t^3/3 + z t] dt, so with t =
   (3a)^(1/3) k: Int_0^inf Exp[-a k^3 - b k] dk =
   Pi ScorerHi[-b (3a)^(-1/3)]/(3a)^(1/3). *)
check["AppB: Scorer closed form of Int_0^inf E^(-a k^3 - b k) dk (numeric)",
  Module[{a = 0.7, b = 0.4 + 1.1 I},
    Abs[kint[a, b] - NIntegrate[Exp[-a kk^3 - b kk], {kk, 0, Infinity},
      PrecisionGoal -> 10]] < 10^-8]];
check["AppB: Scorer closed form, strongly oscillatory b (numeric)",
  Module[{a = 0.02, b = 0.05 + 3. I},
    Abs[kint[a, b] - NIntegrate[Exp[-a kk^3 - b kk], {kk, 0, Infinity},
      PrecisionGoal -> 10, MaxRecursion -> 14]] < 10^-8]];

(* --- Check B9: strong-diffusion coefficient (intcurr_simpl_anom_smallDr).
   The memo's own second line gives
   C = 4 Sqrt[2/Pi] (3 Sqrt[2])^(1/3) (1/2) Gamma[7/6] Gamma[4/3];
   the printed closed form is 2^(11/3)/(3^(8/3) Sqrt[Pi]) Gamma[1/3]^2.
   These disagree: ERRATUM. Correct closed form:
   2^(1/3) Gamma[1/3]^3/(3^(7/6) Pi). *)
uint = Integrate[u^(4/3) Exp[-u^2], {u, 0, Infinity}];
tint = Integrate[Exp[-t^3], {t, 0, Infinity}];
check["AppB: Int u^(4/3) E^(-u^2) du = Gamma[7/6]/2 and Int E^(-t^3) dt = Gamma[4/3]",
  Simplify[uint == Gamma[7/6]/2 && tint == Gamma[4/3]]];
cDerived = 4 Sqrt[2/Pi] (3 Sqrt[2])^(1/3) uint tint;
cMemo = 2^(11/3)/(3^(8/3) Sqrt[Pi]) Gamma[1/3]^2;
cCorrect = 2^(1/3) Gamma[1/3]^3/(3^(7/6) Pi);
uintRequiredByMemo = FullSimplify[
  cMemo/(4 Sqrt[2/Pi] (3 Sqrt[2])^(1/3) tint)];
(* Gamma-multiplication identity resists FullSimplify; verify to 50 digits. *)
check["AppB (intcurr_simpl_anom_smallDr): derived coefficient = 2^(1/3) Gamma[1/3]^3/(3^(7/6) Pi)",
  Abs[N[cDerived, 60] - N[cCorrect, 60]] < 10^-50];
check["AppB (intcurr_simpl_anom_smallDr) ERRATUM: printed closed form differs from memo's own previous line",
  FullSimplify[cMemo - cDerived] =!= 0 &&
    Abs[N[cMemo/cDerived] - 1.2834046954] < 10^-9];
check["AppB ERRATUM ratio: printed/correct = 2^(10/3) Sqrt[Pi]/(3^(3/2) Gamma[1/3])",
  FullSimplify[cMemo/cDerived - 2^(10/3) Sqrt[Pi]/(3^(3/2) Gamma[1/3])] == 0];
check["AppB B15 ERRATUM pinpoint: printed coefficient would require Int u^(4/3) Exp[-u^2] = 2 Gamma[1/3]/9",
  FullSimplify[uintRequiredByMemo == 2 Gamma[1/3]/9]];
check["AppB B15 ERRATUM numeric integral and coefficient values",
  Max[Abs[N[{uint, tint, cDerived, cMemo, cMemo/cDerived,
        uintRequiredByMemo}, 14] -
      {0.4638596668, 0.8929795116, 2.1401304355, 2.7466534496,
        1.2834046954, 0.5953196744}]] < 5 10^-10];
Print["    Int u^(4/3) Exp[-u^2] du = ", N[uint, 11],
  ",  Int Exp[-t^3] dt = ", N[tint, 11]];
Print["    correct C = ", N[cDerived, 11], ", printed C = ", N[cMemo, 11],
  ", ratio = ", N[cMemo/cDerived, 11]];
Print["    printed C would require first integral = ",
  N[uintRequiredByMemo, 11]];

(* Full magnetic-drive current: iterated quadrature, k-integral written as
   Im of the difference of two Scorer integrals is unstable; keep the inner
   1D oscillatory integral numeric, outer v integral numeric. *)
ibInner[a_?NumericQ, b_?NumericQ, dr_?NumericQ] := NIntegrate[
  Exp[-a kk^3 - b kk] Sin[kk dr]/kk, {kk, 0, Infinity},
  PrecisionGoal -> 7, MaxRecursion -> 14];
ibFullNum[vT_?NumericQ, kp_?NumericQ, dr_?NumericQ, nu_?NumericQ,
  wE_?NumericQ, da_?NumericQ] := -Sqrt[2/Pi]/(vT kp) 2 NIntegrate[
    v Exp[-v^2/(2 vT^2)] ibInner[da/(3 v kp), (nu + I wE)/(v kp), dr],
    {v, 0.01 vT, 12 vT}, PrecisionGoal -> 6, MaxRecursion -> 12];
numStrong = ibFullNum[1., 1., 0.01, 0.001, 0., 10.^4];
anaStrong = -N[cDerived] 0.01/(10.^4)^(1/3);
anaStrongMemo = -N[cMemo] 0.01/(10.^4)^(1/3);
check["AppB: numeric strong-diffusion current matches CORRECTED asymptote to 2%",
  Abs[numStrong/anaStrong - 1] < 0.02];
check["AppB: numeric strong-diffusion current does NOT match printed coefficient",
  Abs[numStrong/anaStrongMemo - 1] > 0.2];
Print["    numeric/corrected = ", numStrong/anaStrong,
  ",  numeric/printed = ", numStrong/anaStrongMemo];

(* --- Check B10: wide-region limit (intcurr_simpl_anom_bigDelta). --- *)
check["AppB (intcurr_simpl_anom_bigDelta): Dirichlet limit Int dk/k Sin[k dr] = Pi/2",
  Simplify[Integrate[Sin[kk dr]/kk, {kk, 0, Infinity},
    Assumptions -> dr > 0] - Pi/2] == 0];
numWide = ibFullNum[1., 1., 40., 0.001, 0., 1.];
check["AppB: numeric wide-region current -> -Sqrt[2 Pi] vT/kp, any DA (2%)",
  Abs[numWide/(-Sqrt[2 Pi]) - 1] < 0.02];

(* The magnetic-drive wide- and narrow-layer formulae are two different
   limits of lambda = dr (|v kpar'|/DA)^(1/3).  At fixed finite dr,
   DA -> infinity sends lambda -> 0 and selects the DA^(-1/3) result; the
   DA-independent plateau needs the separate wide-layer limit lambda -> inf. *)
lambdaDA = dr (vkpAbs/DA)^(1/3);
linearAtCubicScale = (nu + I wE)/(DA^(1/3) vkpAbs^(2/3));
check["AppB large-DA ordering: collision/E-field terms vanish at the cubic damping scale",
  FullSimplify[
    Limit[linearAtCubicScale, DA -> Infinity,
      Assumptions -> vkpAbs > 0 && nu >= 0 && wE \[Element] Reals] == 0]];
check["AppB large-DA ordering: fixed dr is the small-layer, not wide-layer, limit",
  FullSimplify[
    Limit[lambdaDA, DA -> Infinity,
      Assumptions -> dr > 0 && vkpAbs > 0] == 0]];
check["AppB wide-layer plateau requires lambda -> infinity as a separate limit",
  FullSimplify[
    Limit[lambdaDA, dr -> Infinity,
      Assumptions -> vkpAbs > 0 && DA > 0] == Infinity]];

(* The magnetic-drive top hat (support |x|<dr) and the electric drive
   (support |x|>dr) are complementary apart from the measure-zero boundary.
   The prose saying both are nonzero in one region is therefore inconsistent
   with the stated supports; the B16--B19 algebra remains a valid separately
   superposed electric contribution. *)
check["AppB E-drive PROSE INCONSISTENCY: stated magnetic (|x|<dr) and electric (|x|>dr) supports are disjoint yet nonempty",
  Reduce[Abs[x0] < dr && Abs[x0] > dr && dr > 0, {x0, dr}, Reals] === False &&
  Reduce[Abs[x0] < dr && dr > 0, {x0, dr}, Reals] =!= False &&
  Reduce[Abs[x0] > dr && dr > 0, {x0, dr}, Reals] =!= False];

(* --- Checks B16--B18: electric source, wide electric region and no
   diffusion.  For |x|>dr, Int E^(-I k x)/x dx is
   -2 I Int_dr^inf Sin[k x]/x dx.  The minus sign in Q then produces the
   +2 I prefactor printed in (B16). --- *)
outsideOddPair = Exp[-I kk x0]/x0 - Exp[I kk x0]/x0;
check["AppB (B16): the two exterior half-lines combine to -2 I Sin[k x]/x",
  ComplexExpand[outsideOddPair + 2 I Sin[kk x0]/x0,
    TargetFunctions -> {Re, Im}] == 0];
(* Full exterior transform of the -1/x electric source: both half-lines
   integrated directly reproduce the printed +2 I (Pi/2 - Si(k dr)). *)
exteriorTransform = FullSimplify[
  Integrate[-Exp[-I kk x0]/x0, {x0, -Infinity, -dr},
    Assumptions -> dr > 0 && kk > 0] +
  Integrate[-Exp[-I kk x0]/x0, {x0, dr, Infinity},
    Assumptions -> dr > 0 && kk > 0], dr > 0 && kk > 0];
check["AppB (B16): exterior transform of the -1/x source equals the printed +2 I (Pi/2 - Si(k dr))",
  FullSimplify[exteriorTransform == 2 I (Pi/2 - SinIntegral[kk dr]),
    dr > 0 && kk > 0]];

exteriorSineIntegral = Pi/2 - SinIntegral[kk dr];
check["AppB (B17): Delta r -> 0 gives Int_0^inf Sin[k x]/x dx = Pi/2",
  FullSimplify[Limit[exteriorSineIntegral, dr -> 0, Direction -> "FromAbove"] == Pi/2,
    kk > 0]];
check["AppB (B17): dr -> 0 limit of the exterior transform is the printed Pi I",
  FullSimplify[Limit[exteriorTransform, dr -> 0,
      Direction -> "FromAbove"] == Pi I, kk > 0]];

(* --- Check B18: electric drive, no diffusion
   (intcurr_edrive_wide_noanom). --- *)
meanAbsV = Integrate[Abs[vpar] Exp[-vpar^2/(2 vT^2)]/(Sqrt[2 Pi] vT),
  {vpar, -Infinity, Infinity}, Assumptions -> vT > 0];
check["AppB (B18): <|vpar|> = Sqrt[2/Pi] vT",
  Simplify[meanAbsV - Sqrt[2/Pi] vT, Assumptions -> vT > 0] == 0];
check["AppB (B18): DA=0 k integral is |v kpar'|/(nu+i omegaE)",
  FullSimplify[
    Integrate[Exp[-(nu + I wE) kk/vkpAbs], {kk, 0, Infinity},
      Assumptions -> vkpAbs > 0 && nu > 0 && wE \[Element] Reals] ==
      vkpAbs/(nu + I wE),
    vkpAbs > 0 && nu > 0 && wE \[Element] Reals]];
ieNoan = Pi I wE/kp^2 meanAbsV kp/(nu + I wE);
check["AppB (B18, intcurr_edrive_wide_noanom): printed coefficient verifies",
  Simplify[ieNoan - Sqrt[2 Pi] wE vT/(kp (wE - I nu))] == 0];
check["AppB: collisionless E-drive exactly cancels wide-region B-drive",
  Simplify[Limit[ieNoan, nu -> 0] + (-Sqrt[2 Pi] vT/kp)] == 0];

(* --- Check B19: electric drive, strong diffusion
   (intcurr_edrive_wide_veryanom). --- *)
meanAbsV13 = Integrate[Abs[vpar]^(1/3) Exp[-vpar^2/(2 vT^2)]/(Sqrt[2 Pi] vT),
  {vpar, -Infinity, Infinity}, Assumptions -> vT > 0];
check["AppB (B19): <|vpar|^(1/3)> Maxwell moment",
  FullSimplify[meanAbsV13 ==
    2^(1/6) Gamma[2/3] vT^(1/3)/Sqrt[Pi], vT > 0]];
check["AppB (B19): cubic-damped k integral",
  FullSimplify[
    Integrate[Exp[-DA kk^3/(3 vkpAbs)], {kk, 0, Infinity},
      Assumptions -> DA > 0 && vkpAbs > 0] ==
      Gamma[4/3] (3 vkpAbs/DA)^(1/3),
    DA > 0 && vkpAbs > 0]];
ieAnom = Pi I wE/kp^2 Gamma[4/3] (3 kp/DA)^(1/3) meanAbsV13;
ieAnomMemo = (2^(1/6) Sqrt[Pi] I/3^(2/3)) Gamma[1/3] Gamma[2/3] *
  vT^(1/3) wE/(kp^(5/3) DA^(1/3));
check["AppB (B19, intcurr_edrive_wide_veryanom): printed coefficient verifies",
  FullSimplify[ieAnom - ieAnomMemo, Assumptions -> vT > 0 && kp > 0 && DA > 0 &&
    wE \[Element] Reals] == 0];
check["AppB: suppression ratio scales as wE (kp vT)^(-2/3) DA^(-1/3) as printed",
  With[{ratio = FullSimplify[(ieAnomMemo/(Sqrt[2 Pi] vT/kp)) /
      (wE kp^(-2/3) vT^(-2/3) DA^(-1/3))]},
    FreeQ[ratio, DA] && FreeQ[ratio, vT] && FreeQ[ratio, kp] && FreeQ[ratio, wE]]];

(* ==== Figures ==== *)

(* Fig 1: Kramp response of the layer current, -IB/(Sqrt[2 Pi] vT/kp) = W(Zdel)
   vs normalized ExB frequency for several collisionalities. *)
wHat[nuH_, wH_] := W[(I nuH - wH)];   (* frequencies in units Sqrt[2] vT kp dr *)
fig1 = Plot[
  Evaluate[Flatten@Table[{Abs[wHat[nuH, wH]], Re[wHat[nuH, wH]]},
    {nuH, {0.05, 0.3, 1}}]], {wH, -4, 4},
  PlotStyle -> {
    {Thick, ColorData[97, 1]}, {Thin, Dashed, ColorData[97, 1]},
    {Thick, ColorData[97, 2]}, {Thin, Dashed, ColorData[97, 2]},
    {Thick, ColorData[97, 3]}, {Thin, Dashed, ColorData[97, 3]}},
  Frame -> True,
  FrameLabel -> {"\!\(\*SubscriptBox[\(\[Omega]\), \(E\)]\)/(\[Sqrt]2 \!\(\*SubscriptBox[\(v\), \(Te\)]\)|k'\!\(\*SubscriptBox[\(\[DoubleVerticalBar]\), \(\)]\)|\[CapitalDelta]r)",
    "normalized layer current"},
  PlotLegends -> LineLegend[
    {ColorData[97, 1], ColorData[97, 2], ColorData[97, 3]},
    {"\!\(\*OverscriptBox[\(\[Nu]\), \(^\)]\) = 0.05",
     "\!\(\*OverscriptBox[\(\[Nu]\), \(^\)]\) = 0.3",
     "\!\(\*OverscriptBox[\(\[Nu]\), \(^\)]\) = 1"}],
  PlotRange -> All, ImageSize -> 420,
  Epilog -> {Text[Style["solid: |W|, dashed: Re W", 10], {2.4, 0.9}]}];
Export[FileNameJoin[{figdir, "fig_kramp_response.pdf"}], fig1];
Print["    exported fig_kramp_response.pdf"];

(* Fig 2: anomalous-diffusion suppression of the layer current, dr = 1,
   nu = 10^-3, wE = 0: numerics vs corrected and printed asymptotes. *)
daList = 10^Range[-3, 4];
ibTab = Table[{da, Abs[ibFullNum[1., 1., 1., 0.001, 0., da]]/Sqrt[2 Pi]},
  {da, daList}];
fig2 = Show[
  LogLogPlot[{1, N[cDerived]/Sqrt[2 Pi] da^(-1/3),
    N[cMemo]/Sqrt[2 Pi] da^(-1/3)}, {da, 10^-3, 10^4},
    PlotStyle -> {{Gray, Dotted}, {ColorData[97, 2]},
      {ColorData[97, 4], Dashed}}],
  ListLogLogPlot[ibTab, PlotStyle -> {PointSize[0.015], ColorData[97, 1]}],
  Frame -> True, FrameLabel -> {
    "\!\(\*SubscriptBox[\(D\), \(A\)]\)/(\!\(\*SubscriptBox[\(v\), \(Te\)]\)|k'\!\(\*SubscriptBox[\(\[DoubleVerticalBar]\), \(\)]\)|\[CapitalDelta]\!\(\*SuperscriptBox[\(r\), \(3\)]\))",
    "|I|/(\[Sqrt](2\[Pi]) e \!\(\*SubscriptBox[\(h\), \(A\)]\)\!\(\*SubscriptBox[\(n\), \(e\)]\)'\!\(\*SubscriptBox[\(v\), \(Te\)]\)/|k'\!\(\*SubscriptBox[\(\[DoubleVerticalBar]\), \(\)]\)|)"},
  PlotRange -> All, ImageSize -> 420,
  Epilog -> {Text[Style["numerics", 10], Log@{3 10^-3, 1.3}],
    Text[Style["corrected \!\(\*SuperscriptBox[\(D\), \(-1/3\)]\) asymptote", 10],
      Log@{100, 0.3}],
    Text[Style["printed coefficient (erratum)", 10], Log@{100, 0.055}]}];
Export[FileNameJoin[{figdir, "fig_DA_suppression.pdf"}], fig2];
Print["    exported fig_DA_suppression.pdf"];

(* Fig 3: anomalous transport switches on the net current: |IB + IE| vs DA
   for the aligned configuration (wide magnetic region + 1/x electric field),
   wE = 1, nu = 0.05, vT = kp = 1. IE via the Scorer closed form of the
   k integral: 1D velocity quadrature only. *)
ieNum[da_?NumericQ, nu_?NumericQ, wE_?NumericQ] := Pi I wE 2 NIntegrate[
  Exp[-v^2/2]/Sqrt[2 Pi] kint[da/(3 v), (nu + I wE)/v],
  {v, 0.01, 12}, PrecisionGoal -> 7, MaxRecursion -> 12];
ibWide = -Sqrt[2 Pi] W[(I 0.05 - 1.)/(Sqrt[2] 40.)];
netTab = Table[{da, Abs[ibWide + ieNum[da, 0.05, 1.]]/Sqrt[2 Pi]},
  {da, 10^Range[-3, 3, 1/2]}];
fig3 = ListLogLinearPlot[netTab, Joined -> True, PlotMarkers -> Automatic,
  PlotStyle -> ColorData[97, 1], Frame -> True,
  FrameLabel -> {"\!\(\*SubscriptBox[\(D\), \(A\)]\)|k'\!\(\*SubscriptBox[\(\[DoubleVerticalBar]\), \(\)]\)\!\(\*SuperscriptBox[\(|\), \(\(-1\)\(\\ \)\)]\)\!\(\*SubsuperscriptBox[\(v\), \(Te\), \(-3\)]\)\!\(\*SubsuperscriptBox[\(\[Omega]\), \(E\), \(3\)]\)",
    "|\!\(\*SubscriptBox[\(I\), \(B\)]\)+\!\(\*SubscriptBox[\(I\), \(E\)]\)|/(\[Sqrt](2\[Pi]) e \!\(\*SubscriptBox[\(h\), \(A\)]\)\!\(\*SubscriptBox[\(n\), \(e\)]\)'\!\(\*SubscriptBox[\(v\), \(Te\)]\)/|k'\!\(\*SubscriptBox[\(\[DoubleVerticalBar]\), \(\)]\)|)"},
  PlotRange -> All, ImageSize -> 420,
  PlotLabel -> "aligned drive: net current appears only through \!\(\*SubscriptBox[\(D\), \(A\)]\)"];
Export[FileNameJoin[{figdir, "fig_drive_cancellation.pdf"}], fig3];
Print["    exported fig_drive_cancellation.pdf"];

reportAndExit[];

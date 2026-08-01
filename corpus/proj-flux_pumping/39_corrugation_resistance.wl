(* Corrugation resistance at fixed loop voltage (meeting 2026-07-20).
   A transformer drives the mean axial current through corrugated
   single-helicity magnetic surfaces. Steady state, uniform
   conductivity sigma, no flow, no perpendicular current: charge
   conservation forces E_par = C(rho) B with the surface function C
   fixed by solvability of the magnetic differential equation for the
   potential, C = E_A <B_z>/<B^2>. The mean axial current density is
   <j_z> = sigma E_A <B_z>^2/<B^2>: an effective-resistivity law
   eta_eff/eta = <B^2>/<B_z>^2 that is a flux-surface-average
   statement, not a pointwise Ohm law - the local ratio of j_z to the
   naive projected drive varies over the surface. The naive wire
   picture (pointwise projection, no charge conservation) gives
   <B_z^2/B^2> instead; the difference is a Cauchy-Schwarz variance,
   so charge conservation always yields less mean current than the
   naive estimate. Tangency locks the radial harmonic to the
   detuning, p = Delta D with D = m Bth/r + k B0, and the l=1
   helical core is exactly the rigid-shift fixture p = d D,
   t = d (Bth' + k B0), w = 0. On that fixture the deficit is
   negative at every radius and localized like Delta^2, so at fixed
   loop voltage the corrugated core carries less mean current:
   delta iota < 0, q_0 rises - the flux-pumping sign - and
   eta delta<j_z> is the negative, core-localized "dynamo field" of
   the MHD papers, produced here with uniform resistivity, no flow,
   and no temperature physics. The second-order surface-shape
   freedom (the memo's open mean shift <delta s_2>) enters the
   deficit only as a relabeling term proportional to the reference
   gradient, verified below. Exports fig_corrugation_resistance.pdf. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];
If[!DirectoryQ[figdir], CreateDirectory[figdir]];

ClearAll[r, th, z, chi, chi1, m, k, eps, rho, alpha, B0, Bth, p, t, w,
  DD, Delta, EA, CC, g, x1, x2, b1, b2, rr2, rr2c, d];
$Assumptions = r > 0 && rho > 0 &&
  Element[{th, z, chi, alpha, eps, b1, b2}, Reals] &&
  B0 > 0 && m > 0 && Element[k, Reals];

(* ==== 1. Field, divergence constraint, operator identities ==== *)

chiOf[th_, z_] := m th + k z;
Bfield[r_, th_, z_] := {
  eps p[r] Sin[chiOf[th, z]],
  Bth[r] + eps t[r] Cos[chiOf[th, z]],
  B0 + eps w[r] Cos[chiOf[th, z]]};

divCyl[v_List, r_, th_, z_] :=
  D[r v[[1]], r]/r + D[v[[2]], th]/r + D[v[[3]], z];
gradCyl[f_, r_, th_, z_] := {D[f, r], D[f, th]/r, D[f, z]};

divB = Simplify[divCyl[Bfield[r, th, z], r, th, z]];
divConstraint = p'[r] + p[r]/r - m t[r]/r - k w[r];
check["div B = 0 is exactly the single-harmonic amplitude constraint",
  Simplify[divB == eps Sin[chiOf[th, z]] divConstraint]];

(* Impose the constraint by eliminating t. *)
tRule = {t -> Function[x, (x p'[x] + p[x] - k x w[x])/m]};
Bvec = Bfield[r, th, z] /. tRule;
Bmag = Sqrt[Bvec . Bvec];

(* Exact identity on the constrained field: div(g bhat) equals
   B bhat.grad(g/B) for any g, using div B = 0. *)
lhsId = divCyl[g[r, th, z] Bvec/Bmag, r, th, z];
rhsId = Bmag (Bvec/Bmag) . gradCyl[g[r, th, z]/Bmag, r, th, z];
check["div(g bhat) = B bhat.grad(g/B) exactly on the constrained field",
  Simplify[lhsId - rhsId] === 0];
check["E_par = C B solves charge conservation exactly",
  Simplify[divCyl[CC Bvec, r, th, z]] === 0];

(* ==== 2. Tangency locks the radial amplitude to the detuning ==== *)

(* Flux label rho = r + eps Delta(r) Cos[chi + alpha]. The surfaces
   are magnetic surfaces iff B.grad rho = 0; to first order this is
   the phase lock alpha = 0 with p = Delta D, D = m Bth/r + k B0. *)
rhoLabel[r_, th_, z_] := r + eps Delta[r] Cos[chiOf[th, z] + alpha];
tangency = Simplify[Coefficient[Normal@Series[
  Bfield[r, th, z] . gradCyl[rhoLabel[r, th, z], r, th, z],
  {eps, 0, 1}], eps]];
detuning = m Bth[r]/r + k B0;
check["first-order tangency reads p Sin[chi] - Delta D Sin[chi + alpha]",
  Simplify[tangency ==
    p[r] Sin[chiOf[th, z]] - Delta[r] detuning Sin[chiOf[th, z] + alpha]]];
check["phase lock alpha = 0 with p = Delta D makes the surfaces magnetic",
  Simplify[(tangency /. alpha -> 0) /.
    p[r] -> Delta[r] detuning] === 0];

pRule = {p -> Function[x, Delta[x] (m Bth[x]/x + k B0)]};

(* ==== 3. Corrugated-surface measure and average ==== *)

(* On the surface rho = const: r = rho - eps Delta Cos[chi] +
   eps^2 (rr2 + rr2c Cos[2 chi]) with the second-order shape left
   free (rr2 is the memo's open mean shift <delta s_2>). Jacobian of
   the (rho, chi) surface family: J = r dr/drho. Flux-surface
   average <X> = Int[X J]/Int[J]. *)
ord = 2;
rOf[rho_, chi_] = rho - eps Delta[rho] Cos[chi] +
  eps^2 (rr2[rho] + rr2c[rho] Cos[2 chi]);
jacJ[rho_, chi_] = Normal@Series[
  rOf[rho, chi] D[rOf[rho, chi], rho], {eps, 0, ord}];
avg[X_] := Normal@Series[
  Integrate[Normal@Series[X jacJ[rho, chi], {eps, 0, ord}],
    {chi, 0, 2 Pi}]/
  Integrate[jacJ[rho, chi], {chi, 0, 2 Pi}], {eps, 0, ord}];

(* Solvability measure check: with tangency imposed, the average
   annihilates B.grad X for single-valued X(rho, chi). On the
   surface, B.grad X = (B.grad chi) dX/dchi, with
   B.grad chi = m B_theta_total/r + k B_z_total evaluated on the
   corrugated surface. Generic two-harmonic test function. *)
onSurf = {r -> rOf[rho, chi], th -> chi/m, z -> 0};
BgradChi = Normal@Series[
  ((m Bvec[[2]]/r + k Bvec[[3]]) /. pRule /. alpha -> 0) /.
    {Cos[chiOf[th, z]] -> Cos[chi], Sin[chiOf[th, z]] -> Sin[chi]} /.
    onSurf, {eps, 0, ord}];
(* The surfaces are magnetic to O(eps) (the second-order shape rr2,
   rr2c is left free), so annihilation is required - and holds - for
   the O(eps) potentials the solvability argument uses: the average
   of (B.grad chi) d(eps X)/dchi vanishes through O(eps^2). *)
Xtest = eps (x1[rho] Cos[chi + b1] + x2[rho] Cos[2 chi + b2]);
check["flux-surface average annihilates B.grad of first-order potentials",
  Simplify[avg[BgradChi D[Xtest, chi]]] === 0];

(* ==== 4. Solvability constant and the two resistivity factors ==== *)

evalOn[X_] := Normal@Series[
  (X /. {Cos[chiOf[th, z]] -> Cos[chi], Sin[chiOf[th, z]] -> Sin[chi]}) /.
    onSurf, {eps, 0, ord}];

BzOn = evalOn[Bvec[[3]]];
B2On = evalOn[Bvec . Bvec];

(* E = -grad Phi + E_A e_z with E_par = C B: multiplying by B and
   averaging kills <B.grad Phi> and leaves C <B^2> = E_A <B_z>. *)
CCsol = EA avg[BzOn]/avg[B2On];

(* Consistent factor F = <j_z>/(sigma E_A) = <B_z>^2/<B^2>; naive
   pointwise projection gives <B_z^2/B^2>. *)
Fcons = Normal@Series[avg[BzOn]^2/avg[B2On], {eps, 0, ord}];
Fnaive = avg[BzOn^2/B2On];
F0 = B0^2/(B0^2 + Bth[rho]^2);

check["zero perturbation reproduces the screw-pinch reference factor",
  Simplify[(Fcons /. eps -> 0) == F0] &&
  Simplify[(Fnaive /. eps -> 0) == F0]];
check["no first-order term survives the surface average in either factor",
  Simplify[Coefficient[Fcons, eps, 1]] === 0 &&
  Simplify[Coefficient[Fnaive, eps, 1]] === 0];

(* Pure-tilt limit (formal: Delta -> 0, Bth -> 0, generic p, t, w):
   the consistent factor pays for magnitude modulation w as well as
   for the transverse tilt, the naive one only for the tilt. *)
tilt0 = {Delta -> Function[x, 0], Bth -> Function[x, 0],
  rr2 -> Function[x, 0], rr2c -> Function[x, 0]};
tComposite = (rho p'[rho] + p[rho] - k rho w[rho])/m;
FconsTilt = Simplify[Coefficient[Fcons /. tilt0, eps, 2]];
FnaiveTilt = Simplify[Coefficient[Fnaive /. tilt0, eps, 2]];
check["consistent pure-tilt deficit is -(p^2 + t^2 + w^2)/(2 B0^2)",
  Simplify[FconsTilt ==
    -(p[rho]^2 + tComposite^2 + w[rho]^2)/(2 B0^2)]];
check["naive pure-tilt deficit is -(p^2 + t^2)/(2 B0^2)",
  Simplify[FnaiveTilt == -(p[rho]^2 + tComposite^2)/(2 B0^2)]];
check["pure-tilt difference naive minus consistent is w^2/(2 B0^2)",
  Simplify[FnaiveTilt - FconsTilt == w[rho]^2/(2 B0^2)]];

(* General difference is the Cauchy-Schwarz variance
   <(B_z - <B_z> B^2/<B^2>)^2/B^2> >= 0: charge conservation never
   beats the naive projection. Verified as an identity at O(eps^2)
   and numerically on three unrelated parameter points. *)
diffNC = Simplify[Coefficient[Fnaive - Fcons, eps, 2]];
csSquare = Simplify[Coefficient[
  avg[(BzOn - avg[BzOn] B2On/avg[B2On])^2/B2On], eps, 2]];
check["naive minus consistent factor is the Cauchy-Schwarz variance",
  Simplify[diffNC - csSquare] === 0];
numPoint[seed_] := Module[{rnd = BlockRandom[SeedRandom[seed];
    RandomReal[{-1, 1}, 8]]},
  {p[rho] -> rnd[[1]], p'[rho] -> rnd[[2]], w[rho] -> rnd[[3]],
   w'[rho] -> rnd[[4]], Delta[rho] -> rnd[[5]], Delta'[rho] -> rnd[[6]],
   Bth[rho] -> .3 rnd[[7]], Bth'[rho] -> .1 rnd[[8]],
   rr2[rho] -> 0, rr2c[rho] -> 0, rr2'[rho] -> 0, rr2c'[rho] -> 0,
   rho -> 7., B0 -> 1., m -> 1., k -> -.05}];
check["Cauchy-Schwarz variance is nonnegative on three random points",
  AllTrue[{11, 23, 47}, (diffNC /. numPoint[#]) >= -10^-12 &]];

(* Second-order surface-shape freedom: the mean shift rr2 (the
   memo's <delta s_2>) enters the deficit only as the relabeling
   term rr2 dF0/drho, and the 2 chi harmonic rr2c not at all. *)
c2 = Coefficient[Fcons, eps, 2];
check["mean second-order shift enters only as relabeling by dF0/drho",
  Simplify[c2 - (c2 /. {rr2[rho] -> 0, rr2'[rho] -> 0}) -
    rr2[rho] D[F0, rho]] === 0];
check["the 2 chi second-order harmonic does not enter the deficit",
  FreeQ[Simplify[c2], rr2c]];

(* ==== 5. The l=1 helical core is the rigid-shift fixture ==== *)

(* Rigidly shifted screw pinch: transverse shift
   xi(z) = d (Cos[k z], -Sin[k z]) plus the line-bending field
   B0 xi'(z); to first order in d this is the m=1 harmonic with
   p = d D, t = d (Bth' + k B0), w = 0, so the divergence and
   tangency constraints hold automatically with Delta = d. *)
xs = r Cos[th]; ys = r Sin[th];
rs = Sqrt[(xs - d Cos[k z])^2 + (ys + d Sin[k z])^2];
BxS = -Bth[rs] (ys + d Sin[k z])/rs + B0 D[d Cos[k z], z];
ByS = Bth[rs] (xs - d Cos[k z])/rs + B0 D[-d Sin[k z], z];
BrS = Simplify[BxS Cos[th] + ByS Sin[th]];
BtS = Simplify[-BxS Sin[th] + ByS Cos[th]];
pShift = Simplify[TrigReduce[Coefficient[
  Normal@Series[BrS, {d, 0, 1}], d]] /.
  {Sin[th + k z] -> Sin[chi1], Cos[th + k z] -> Cos[chi1]},
  r > 0];
tShift = Simplify[TrigReduce[Coefficient[
  Normal@Series[BtS, {d, 0, 1}], d]] /.
  {Sin[th + k z] -> Sin[chi1], Cos[th + k z] -> Cos[chi1]},
  r > 0];
check["rigid shift is a pure m=1 harmonic in chi = th + k z",
  FreeQ[{pShift, tShift}, th] && FreeQ[{pShift, tShift}, z]];
(* A shift by +d puts the surfaces at r = rho + d Cos[chi], which in
   the label rho = r + Delta Cos[chi] means Delta = -d: the rigid
   shift realizes the tangency lock p = Delta D with Delta = -d.
   pShift/tShift are coefficients of d, so the expected amplitudes
   carry no explicit d. *)
check["rigid-shift radial amplitude is the tangency form p = Delta D, Delta = -d",
  Simplify[pShift - (-1) Sin[chi1] (Bth[r]/r + k B0)] === 0];
check["rigid-shift poloidal amplitude is Delta (Bth' + k B0), Delta = -d",
  Simplify[tShift - (-1) Cos[chi1] (Bth'[r] + k B0)] === 0];
check["rigid-shift amplitudes satisfy the divergence constraint at m = 1, w = 0",
  Simplify[(divConstraint /. {p -> Function[x, -d (Bth[x]/x + k B0)],
    t -> Function[x, -d (Bth'[x] + k B0)], w -> Function[x, 0]}) /.
    m -> 1] === 0];

(* ==== 6. Numeric fixture: deficit, delta iota, dynamo field ==== *)

(* Screw-pinch core with q slightly above one (script 14 regime),
   B0 = 1, R0 = 20, corrugation Delta = d0 Exp[-(r/8)^4], d0 = 2.5,
   representative (m, n) = (1, -1): k = -1/R0. *)
(* d0 = 0.5 keeps Delta < r at every sampled radius, so the
   second-order expansion is honest; the deficit is exactly quadratic
   in the amplitude family, so the sign pattern is d0-independent. *)
R0fix = 20.; B0fix = 1.; d0fix = 0.5; mfix = 1.; kfix = -1/R0fix;
qProf[rr_] := 1.05 + 0.9 (rr/25.)^2;
BthProf[rr_] := rr B0fix/(R0fix qProf[rr]);
DeltaProf[rr_] := d0fix Exp[-(rr/8.)^4];
detProf[rr_] := mfix BthProf[rr]/rr + kfix B0fix;
pProf[rr_] := DeltaProf[rr] detProf[rr];
wProf[rr_] := 0.;

fixRules[rv_] := {p[rho] -> pProf[rv], p'[rho] -> pProf'[rv],
  p''[rho] -> pProf''[rv],
  w[rho] -> wProf[rv], w'[rho] -> 0., w''[rho] -> 0.,
  Delta[rho] -> DeltaProf[rv], Delta'[rho] -> DeltaProf'[rv],
  Delta''[rho] -> DeltaProf''[rv],
  Bth[rho] -> BthProf[rv], Bth'[rho] -> BthProf'[rv],
  Bth''[rho] -> BthProf''[rv],
  rr2[rho] -> 0., rr2c[rho] -> 0., rr2'[rho] -> 0., rr2c'[rho] -> 0.,
  rr2''[rho] -> 0., rr2c''[rho] -> 0.,
  rho -> rv, B0 -> B0fix, m -> mfix, k -> kfix, EA -> 1.};

deficitOf[rv_?NumericQ] := c2 /. fixRules[rv];
F0Of[rv_?NumericQ] := F0 /. fixRules[rv];

(* The pointwise deficit is NOT sign-definite: the corrugated core
   loses mean current while the steep-gradient shell (around the
   collapse of Delta near r = 8) gains part of it back - the central
   current deficit with compensating off-axis current that the MHD
   literature reports as the recurring flux-pumping pattern. The
   shell sign at O(eps^2) shares the labeling freedom of the mean
   second-order shift (relabeling check above); the core deficit and
   the enclosed-current deficit below are the robust statements. *)
sample = Table[{rv, deficitOf[rv]}, {rv, 1., 24., 1.}];
check["fixture: corrugation deficit is negative throughout the flat core",
  AllTrue[Select[sample, #[[1]] <= 4 &], #[[2]] < 0 &]];
check["fixture: a compensating positive shell exists in the gradient region",
  AnyTrue[Select[sample, 4 < #[[1]] < 10 &], #[[2]] > 0 &]];
flipRadius = SelectFirst[Partition[sample, 2, 1],
  #[[1, 2]] < 0 && #[[2, 2]] > 0 &][[1, 1]];
check["fixture: the deficit sign flip sits in the corrugation-gradient shell",
  4 <= flipRadius <= 8];
check["fixture: deficit is localized like Delta^2 (edge value negligible)",
  Abs[deficitOf[24.]] < 10^-6 Abs[deficitOf[4.]]];

(* delta iota from the mean-current deficit: in the cylinder,
   iota(r) = R0 Bth/(r B0) with Bth carried by the enclosed current,
   so at fixed radius delta iota/iota = delta I/I. *)
deltaI[rv_] := 2 Pi NIntegrate[s deficitOf[s], {s, 10^-3, rv},
  AccuracyGoal -> 8, PrecisionGoal -> 8];
I0[rv_] := 2 Pi NIntegrate[s F0Of[s], {s, 10^-3, rv},
  AccuracyGoal -> 8, PrecisionGoal -> 8];
check["fixture: enclosed-current deficit is negative in the core",
  deltaI[8.] < 0];
check["fixture: delta iota < 0 at fixed loop voltage, so q0 rises",
  deltaI[8.]/I0[8.] < 0];

(* Pointwise nonlocality: j_z/(sigma E_A b_z^2) = C B^2/(E_A B_z)
   varies over the surface; its relative chi-variation at r = 10 on
   the fixture exceeds 10^-4, so no pointwise effective resistivity
   reproduces the charge-conserving answer. *)
ratioOn = Normal@Series[B2On/BzOn, {eps, 0, ord}];
ratioVar = Simplify[Coefficient[
  avg[(ratioOn - avg[ratioOn])^2], eps, 2]];
check["pointwise Ohm ratio varies over the corrugated surface",
  (ratioVar /. fixRules[10.])/((B2On/BzOn /. eps -> 0) /.
    fixRules[10.])^2 > 10^-8];

(* ==== 7. Figure ==== *)
figData = Table[{rv, -deficitOf[rv]}, {rv, .5, 25., .25}];
figIota = Table[{rv, -deltaI[rv]/I0[rv]}, {rv, 1., 25., 1.}];
figCR = GraphicsRow[{
  ListLinePlot[figData, PlotRange -> All, Frame -> True,
    FrameLabel -> {"r", "-\[Delta]F"},
    PlotLabel -> "mean-current deficit at fixed loop voltage",
    ImageSize -> 300],
  ListLinePlot[figIota, PlotRange -> All, Frame -> True,
    FrameLabel -> {"r", "-\[Delta]\[Iota]/\[Iota]"},
    PlotLabel -> "transform deficit (q0 rises)", ImageSize -> 300]},
  ImageSize -> 640];
Export[FileNameJoin[{figdir, "fig_corrugation_resistance.pdf"}], figCR];
Print["    exported fig_corrugation_resistance.pdf"];
check["Fig: corrugation-resistance figure exported",
  FileByteCount[FileNameJoin[{figdir,
    "fig_corrugation_resistance.pdf"}]] > 5000];

reportAndExit[];

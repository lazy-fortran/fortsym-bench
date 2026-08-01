(* Memo extensions through 2026-07-14: local
   iota-clamping feedback in Sec. "Redistribution of the toroidal current".
   Ground-up verification of the chain (torcur_tot) -> (iotaeq):
   corrugation-averaged toroidal current -> Ampere/Stokes -> delta iota
   local in r; kinetic response (Lainer et al., PPCF 68, 055037 (2026),
   Eqs. (28), (29), source eq:chargedens-compact/eq:currpar-compact/eq:Fm,
   checked against ~/code/write/varenna-2024-mephit-edit) -> misaligned
   potential -> large-k_par Debye asymptotics (Lainer Eq. (46) = eq:F0as)
   -> algebraic clamping equation for iota. Cylinder metric
   diag(1, r^2, R^2), phase Exp[I(m th + n ph)], CGS. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];
figdir = FileNameJoin[{DirectoryName[$InputFileName], "figures"}];

$Assumptions = {r > 0, R > 0, B0 > 0, Bph > 0, cl > 0, kpar != 0,
    Element[m, Integers], Element[n, Integers], m != 0, m iota + n != 0};

sqrtg = r R;
metric = DiagonalMatrix[{1, r^2, R^2}];
crossCovCov[a_, b_] := Cross[a, b]/sqrtg;      (* both covariant -> contravariant *)

(* ==== (torcur_tot), (torcur): physical toroidal current, R factor ==== *)
(* e_ph = d x/d ph has length R (ph = z/R), so the physical toroidal current
   density is R j^ph and I_tor(a) = Int dA R j^ph = 2 pi R Int dr r jbar^ph. *)
check["|e_ph| = R: contravariant j^ph carries physical factor R",
  Simplify[Sqrt[metric[[3, 3]]]] === R];

javg[rr_] := Delta Cos[alpha]/(2 rr) D[rr jm[rr], rr];   (* (avertorcurden) *)
check["(torcur): delta I_tor(r) = pi R Delta Cos[alpha] r jm(r)",
  Simplify[D[Pi R Delta Cos[alpha] rv jm[rv], rv]
    == D[Integrate[2 Pi R rp javg[rp], rp] /. rp -> rv, rv]] &&
  Simplify[(Pi R Delta Cos[alpha] rv jm[rv] /. rv -> 0)] === 0];
check["physical-current bridge: Jz=R jm gives R jbar^ph=(2r)^-1 d(r Jz Delta Cos[alpha])/dr",
  Simplify[R javg[r] ==
    1/(2 r) D[r (R jm[r]) Delta Cos[alpha], r]]];
check["[definition] physical-current bridge: delta I_tor=pi r Jz Delta Cos[alpha] restates Jz=R jm",
  Simplify[Pi R r jm[r] Delta Cos[alpha] ==
    Pi r (R jm[r]) Delta Cos[alpha]]];
check["(torcur_tot): I_tor(infinity) = 0 for decaying profile r Exp[-r^2]",
  Simplify[Integrate[2 Pi R rp (javg[rp] /. jm -> (# Exp[-#^2] &)),
    {rp, 0, Infinity}]] === 0];

(* ==== (stokes), (Btcontr), (rotransas): Ampere chain ==== *)
(* Arbitrary regular poloidal field bth[r]: j^ph from the curl, I_tor by
   integration; Stokes loop integral = 2 pi B_th. *)
jphOfB[rr_] := cl/(4 Pi) 1/(rr R) D[rr^2 bth[rr], rr];
ItorOfB[rr_] := Integrate[2 Pi R rp jphOfB[rp], rp] /. rp -> rr;  (* bth regular: r^2 bth -> 0 *)
check["(stokes): 2 pi B_th = (4 pi/c) I_tor(r)",
  Simplify[2 Pi r^2 bth[r] == (4 Pi/cl) ItorOfB[r]]];
check["(Btcontr): B^th = B_th/r^2 = 2 I_tor/(c r^2)",
  Simplify[bth[r] == (r^2 bth[r])/r^2 == 2 ItorOfB[r]/(cl r^2)]];
check["(rotransas): iota = B^th/B^ph = 2 R I_tor/(c r^2 B) at B = R B^ph",
  Simplify[bth[r]/Bph == 2 R ItorOfB[r]/(cl r^2 (R Bph))]];

(* ==== (deltaiota): local delta iota from the helical current ==== *)
check["(deltaiota): delta iota = 2 pi R^2 Delta Cos[alpha] jm/(c r B)",
  Simplify[(2 R/(cl r^2 (R Bph))) Pi R Delta Cos[alpha] r jm[r]
    == 2 Pi R^2 Delta Cos[alpha] jm[r]/(cl r (R Bph))]];

(* ==== Kinetic response: (rhom), (jparm) first FLR-0 terms of Lainer
   eq:chargedens-compact/eq:currpar-compact; (divfree) ==== *)
drive = Brm/B0 - I kpar Phim/E0r;
rhom = kpar/omE F0 drive;
jparm = -F0 drive;
check["(divfree): omE rhom + kpar jparm = 0",
  Simplify[omE rhom + kpar jparm] === 0];

(* ==== (divfree_expl): k.V_E = omE exactly, with metric correction ==== *)
Bcontra = {0, iota Bph, Bph};                 (* B^th = iota B^ph *)
Bcov = metric.Bcontra;
Bmag = Simplify[Sqrt[Bcontra.Bcov], r > 0];
Ecov = {-Php, 0, 0};                          (* E_0 = -Phi0' grad r *)
VEcontra = cl crossCovCov[Ecov, Bcov]/Bmag^2;
kcov = {0, m, n};
kdotVE = Simplify[kcov.VEcontra];
check["k.V_E = (c Phi0'/B^2)(m R B^ph - n iota r^2 B^ph/R)/r",
  Simplify[kdotVE == cl Php Bph (m R^2 - n iota r^2)/(r R Bmag^2)]];
check["(kvecspres) omE: k.V_E -> c Phi0' m/(B0 r) with B -> R B^ph, correction n iota r^2/(m R^2)",
  Simplify[kdotVE == (cl Php m/((R Bph) r)) (1 - n iota r^2/(m R^2)) (R Bph)^2/Bmag^2]];

(* ==== (kvecspres) k_par and the resonant iota ==== *)
hcov = Bcov/Bmag;
kparExact = Simplify[kcov.Bcontra/Bmag];
check["k_par = B^ph (m iota + n)/B -> (m/R)(iota - iota_m), iota_m = -n/m",
  Simplify[kparExact == Bph (m iota + n)/Bmag] &&
  Simplify[(Bph (m iota + n)/(R Bph)) == (m/R) (iota - (-n/m))]];

(* ==== (alignpot): aligned potential from surface tangency ==== *)
(* Perturbed surface rho = r + rhom Exp[I(m th + n ph)]; tangency
   B.grad rho = 0 gives rhom; Phi = Phi0(rho) gives Phi^A. *)
rhomSurf = -Brm/(I (m Bcontra[[2]] + n Bcontra[[3]]));
check["surface label amplitude rhom = I Brm/(k_par B)",
  Simplify[rhomSurf == I Brm/(kparExact Bmag)]];
check["corrugation = -displacement: Brm = I k_par B xim  =>  rhom = -xim",
  Simplify[(rhomSurf /. Brm -> I kparExact Bmag xim) == -xim]];
PhiA = Simplify[Php rhomSurf];
check["(alignpot): Phi^A = I Phi0' Brm/(k_par B0) = -I E0r Brm/(k_par B0)",
  Simplify[PhiA == I Php Brm/(kparExact Bmag)] &&
  Simplify[I Php Brm/(kpar B0) == -I (-Php) Brm/(kpar B0)]];

(* ==== (jpar_misal): only the misaligned part drives the current ==== *)
check["(jpar_misal): jparm = I k_par F0 Phi^MA/E0r",
  Simplify[(jparm /. {Phim -> -I E0r Brm/(kpar B0) + PhiMA})
    == I kpar F0 PhiMA/E0r]];

(* ==== (jtorm): toroidal projection of the in-surface current ==== *)
gradrCov = {1, 0, 0}; gradphCov = {0, 0, 1};
kXgradr = crossCovCov[kcov, gradrCov];
ratioExact = Simplify[(kXgradr.gradphCov)/(kXgradr.hcov)];
hth = Simplify[hcov[[2]]]; hph = Simplify[hcov[[3]]];
check["(jtorm) exact: (k x grad r . grad ph)/(k x grad r . h) = m/(m h_ph - n h_th)",
  Simplify[ratioExact == m/(m hph - n hth)]];
check["(jtorm) correction: n h_th/(m h_ph) = n iota r^2/(m R^2) -> -(iota r/R)^2 at n/m = -iota",
  Simplify[n hth/(m hph) == n iota r^2/(m R^2)] &&
  Simplify[(n iota r^2/(m R^2) /. n -> -iota m) == -(iota r/R)^2]];
check["(jtorm) leading: j^ph_m = jparm/R for h_ph -> R",
  Simplify[m jparm0/(m R - n 0) == jparm0/R]];
check["2026-07-14 (jtorm) SIGN: positive projection is exact; a negative sign would be inconsistent",
  Simplify[m jparm0/(m R - n 0) == jparm0/R] &&
    Simplify[m jparm0/(m R - n 0) == -jparm0/R] =!= True];

(* ==== (largekpar): asymptotic F0, Lainer Eq. (46) ==== *)
(* Step 1, pure algebra: I11 = I13 -> -I x2/x1^2 in eq:Fm with
   x1 = k_par vT/nu, x2 = -omE/nu collapses vT and nu. *)
Ias = -I x2/x1^2 /. {x1 -> kpar vT/nu, x2 -> -omE/nu};
F0asSpecies = ea na vT^2/nu ((A1 + A2) Ias + A2/2 Ias);
check["(largekpar) step 1: species term -> I omE ea na (A1 + 3/2 A2)/k_par^2",
  Simplify[F0asSpecies == I omE ea na (A1 + 3 A2/2)/kpar^2]];

(* Step 2, neutrality reduction: A1 = n'/n + e Phi0'/T - (3/2) T'/T,
   A2 = T'/T (Lainer eq:thermodynamic-forces); sum over two species with
   qe ne + qi ni = 0 for all r. *)
A1of[q_, dens_, T_] := dens'[r]/dens[r] + q Php/T[r] - 3 T'[r]/(2 T[r]);
A2of[T_] := T'[r]/T[r];
sumEN = Sum[sp[[1]] sp[[2]][r] (A1of[sp[[1]], sp[[2]], sp[[3]]]
      + 3/2 A2of[sp[[3]]]), {sp, {{qe, nne, Te}, {qi, nni, Ti}}}];
neutral = nni -> Function[rr, -qe nne[rr]/qi];
check["(largekpar) step 2: Sum ea na (A1 + 3/2 A2) = Phi0' Sum ea^2 na/Ta under neutrality",
  Simplify[(sumEN /. neutral)
    == Php (qe^2 nne[r]/Te[r] + qi^2 (-qe nne[r]/qi)/Ti[r] /. neutral)]];
check["(largekpar) step 3: F0 -> -I omE E0r/(4 pi k_par^2) Sum 1/lambda_Da^2",
  Simplify[I omE Php (qe^2 nne[r]/Te[r] + qi^2 nni[r]/Ti[r])/kpar^2
    == -I omE (-Php)/(4 Pi kpar^2) (4 Pi nne[r] qe^2/Te[r]
        + 4 Pi nni[r] qi^2/Ti[r])]];

(* Independent physics check: at large k_par the response is Boltzmann
   (Debye) screening of the misaligned potential. delta n_a =
   -ea na Phi^MA/Ta, j_par from the divergence-free condition. *)
rhomBoltz = -(qe^2 nne[r]/Te[r] + qi^2 nni[r]/Ti[r]) PhiMA;
jparBoltz = -omE rhomBoltz/kpar;
jparAsymp = I kpar (-I omE (-Php)/(4 Pi kpar^2) (4 Pi nne[r] qe^2/Te[r]
    + 4 Pi nni[r] qi^2/Ti[r])) PhiMA/(-Php);
check["(largekpar) independent: Boltzmann screening of Phi^MA + (divfree) reproduces Eq. (46) response",
  Simplify[jparBoltz == jparAsymp]];

(* ==== (jtorm_asymp), (jtorm_asymp_expl), (iotaeq): final chains ==== *)
sumLam = 4 Pi nne[r] qe^2/Te[r] + 4 Pi nni[r] qi^2/Ti[r];  (* Sum 1/lambda_Da^2 *)
jphAsymp = Simplify[jparBoltz/R];
check["(jtorm_asymp): j^ph_m = omE Phi^MA Sum(1/lambda^2)/(4 pi k_par R)",
  Simplify[jphAsymp == omE PhiMA sumLam/(4 Pi kpar R)]];
jphExpl = Simplify[jphAsymp /. {kpar -> (m/R) (iota - iotam),
    omE -> cl Php m/(B0 r)}];
check["(jtorm_asymp_expl): j^ph_m = c Phi0' Phi^MA Sum(1/lambda^2)/(4 pi r B0 (iota - iota_m))",
  Simplify[jphExpl == cl Php PhiMA sumLam/(4 Pi r B0 (iota - iotam))]];
check["(iotaeq): iota = iota0 + R^2 Delta Phi0' Phi^MA Cos[alpha] Sum(1/lambda^2)/(2 r^2 B^2 (iota - iota_m))",
  Simplify[2 Pi R^2 Delta Cos[alpha]/(cl r B0) jphExpl
    == R^2 Delta Php PhiMA Cos[alpha] sumLam/(2 r^2 B0^2 (iota - iotam))]];

(* ==== Clamping branch structure of (iotaeq) ==== *)
(* (iota - iota0)(iota - iota_m) = KK. Pumping sign KK > 0: the lower branch
   stays below iota_m and clamps against it under overdrive iota0 > iota_m,
   i.e. q = 1/iota is held slightly above 1 no matter how strong the CD
   overdrive. This is the local skeleton of the script-13 fixed point. *)
lowRoot = (iota0 + iotam)/2 - Sqrt[(iota0 - iotam)^2/4 + KK];
upRoot = (iota0 + iotam)/2 + Sqrt[(iota0 - iotam)^2/4 + KK];
check["(iotaeq) roots solve the quadratic",
  Simplify[(# - iota0) (# - iotam) - KK == 0 & /@ {lowRoot, upRoot},
    KK > 0] === {True, True}];
check["clamped branch stays below iota_m for KK > 0",
  Simplify[lowRoot < iotam, KK > 0 && Element[iota0, Reals]
    && Element[iotam, Reals]]];
check["weak-coupling gap: iota_m - iota = KK/(iota0 - iota_m) + O(KK^2)",
  Simplify[Normal@Series[iotam - lowRoot, {KK, 0, 1}]
    == KK/(iota0 - iotam), iota0 > iotam]];
check["strong overdrive: clamp tightens, iota -> iota_m as iota0 -> infinity",
  Limit[iotam - lowRoot, iota0 -> Infinity, Assumptions -> KK > 0] === 0];
check["anti-pumping KK < 0: no real solution once (iota0 - iota_m)^2 < 4|KK|",
  Simplify[Reduce[Exists[x, Element[x, Reals],
      (x - iota0) (x - iotam) == KK], {iota0, iotam, KK}, Reals]
    /. {iota0 -> iotam, KK -> -1}] === False];

(* ==== AUG hybrid-core numbers and validity of the asymptotics ==== *)
Module[{nn = 5.*^13, TT = 3000. 1.602*^-12, B0n = 2.5*^4, Rn = 165.,
    rn = 15., mabs = 1, e0 = 4.803*^-10, me = 9.109*^-28, mi = 3.344*^-24,
    clN = 2.998*^10, lnL = 16., Ern, Phpn, lamDe2, lamDi2, sumL, omEn,
    vTe, vTi, nue, nui, gap, x1e, x2e, x1i, x2i, gapIon, cK, ov,
    PhiMAneed, PhiAn, DeltaN = 2.},
  Ern = 100./299.79;                    (* 100 V/cm in statvolt/cm *)
  Phpn = Ern;                           (* magnitudes only *)
  lamDe2 = TT/(4 Pi nn e0^2); lamDi2 = lamDe2;
  sumL = 1/lamDe2 + 1/lamDi2;
  vTe = Sqrt[TT/me]; vTi = Sqrt[TT/mi];
  nue = 2.91*^-6 nn lnL 3000.^-1.5;
  nui = 4.80*^-8 nn lnL 3000.^-1.5/Sqrt[2.];
  omEn = clN Phpn mabs/(B0n rn);
  gap = 0.01; ov = 0.07;
  x1e = gap mabs/Rn vTe/nue; x2e = omEn/nue;
  x1i = gap mabs/Rn vTi/nui; x2i = omEn/nui;
  gapIon = omEn Rn/(mabs vTi);
  cK = Rn^2 DeltaN Phpn sumL/(2 rn^2 B0n^2);
  PhiMAneed = gap ov/cK;
  PhiAn = Phpn DeltaN;
  Print["    lambda_De = ", Sqrt[lamDe2], " cm,  Sum 1/lambda^2 = ",
    sumL, " cm^-2"];
  Print["    omega_E = ", omEn, " s^-1 (E_r = 100 V/cm),  nu_e = ", nue,
    ",  nu_i = ", nui, " s^-1"];
  Print["    at |iota-iota_m| = 0.01: x1e^2 = ", x1e^2,
    " vs |x2e| max(1,|x2e|) = ", x2e Max[1., x2e],
    "; x1i^2 = ", x1i^2, " vs |x2i| max(1,|x2i|) = ", x2i Max[1., x2i]];
  Print["    ion asymptotics need |iota-iota_m| >> ", gapIon,
    " (= omE R/(|m| vTi)): violated at the clamped point"];
  Print["    K coefficient = ", cK, " per statvolt of Phi^MA; clamp gap ",
    gap, " at overdrive ", ov, " needs Phi^MA = ", PhiMAneed,
    " statvolt = ", 299.79 PhiMAneed, " V"];
  Print["    Phi^A ~ Phi0' Delta = ", PhiAn, " statvolt = ",
    299.79 PhiAn, " V;  Phi^MA/Phi^A = ", PhiMAneed/PhiAn];
  check["lambda_De ~ 5.8e-3 cm at n = 5e13, T = 3 keV",
    Abs[Sqrt[lamDe2]/5.76*^-3 - 1] < 0.02];
  check["electron asymptotics valid at the clamped point (x1e^2 >> |x2e| max(1,|x2e|))",
    x1e^2 > 10 x2e Max[1., x2e]];
  check["ion asymptotics NOT valid at the clamped point (x1i^2 < |x2i| max(1,|x2i|))",
    x1i^2 < x2i Max[1., x2i]];
  check["required Phi^MA is a moderate fraction of Phi^A (< 50%)",
    PhiMAneed/PhiAn < 0.5];
];

(* ==== Figure: clamping branch diagram of (iotaeq) ==== *)
(* Branch continued from the unperturbed solution: lower root for
   iota0 > iotam - continued smoothly through iota0 = iotam it is the
   root closer to iota0 far below resonance. *)
pumpedBranch[i0_, km_] := (i0 + 1)/2 - Sqrt[(i0 - 1)^2/4 + km];
otherBranch[i0_, km_] := (i0 + 1)/2 + Sqrt[(i0 - 1)^2/4 + km];
figClamp = Plot[
    {pumpedBranch[i0, 0.001], pumpedBranch[i0, 0.004],
     otherBranch[i0, 0.001], otherBranch[i0, 0.004], i0},
    {i0, 0.9, 1.15},
    PlotStyle -> {Directive[Thick, ColorData[97][1]],
      Directive[Thick, ColorData[97][2]],
      Directive[Thin, Gray], Directive[Thin, Gray, Dashed],
      Directive[Gray, Dashed]},
    PlotLegends -> Placed[{"pumped branch, K = 0.001",
      "pumped branch, K = 0.004", "upper branch, K = 0.001",
      "upper branch, K = 0.004", "no feedback (\[Iota] = \[Iota]0)"},
      {0.32, 0.75}],
    Epilog -> {Gray, Dotted, Line[{{0.9, 1}, {1.15, 1}}],
      Text[Style["\[Iota] = \[Iota]m (q = 1)", Gray, 11], {1.11, 1.008}]},
    Frame -> True,
    FrameLabel -> {"\[Iota]0 (unperturbed, with CD overdrive)",
      "\[Iota] (solution of the local feedback equation)"},
    PlotRange -> {{0.9, 1.15}, {0.9, 1.15}}, ImageSize -> 460];
Export[FileNameJoin[{figdir, "fig_iota_clamping_local.pdf"}], figClamp];
Print["    exported figures/fig_iota_clamping_local.pdf"];
check["[exists] fig_iota_clamping_local exported",
  FileExistsQ[FileNameJoin[{figdir, "fig_iota_clamping_local.pdf"}]]];

reportAndExit[];

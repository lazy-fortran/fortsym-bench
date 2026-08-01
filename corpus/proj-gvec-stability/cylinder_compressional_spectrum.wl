ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];
zeroQ[expr_] := SameQ[Together[expr], 0];
(* exact single-mode average over one angle: after TrigReduce every
   quadratic term is constant or oscillates in the angle; for a
   nonzero integer mode number the oscillating average vanishes
   exactly, without Integrate's symbolic Sin[4 pi m] residues. *)
phaseAverage[expr_, angle_] := Expand[TrigReduce[expr]] /.
  {Cos[a_] /; ! FreeQ[a, angle] :> 0,
   Sin[a_] /; ! FreeQ[a, angle] :> 0};

(* Single-(m,k) compressional spectrum of the GLISS three-component
   operator with the physical kinetic norm on the screw pinch, in the
   export chart of two_component_energy_identity.wl (r-label,
   right-handed, phase = m theta + k z; the fixture realizes theta01 =
   theta/(2 pi), zeta01 = z/len with n = -k len/(2 pi)).  Establishes:
   (1) the GLISS Lagrangian W - w2 M equals the physical compressible
       Lagrangian after eliminating the tangential amplitudes, as an
       exact rational identity in the profile values;
   (2) the Alfven and slow (sound) continua of the reduced operator;
   (3) the theta-pinch Bessel reduction with closed-form branch
       eigenvalues for the pinned cylinder fixture constants;
   (4) shooting references: no discrete mode below the stable member's
       slow edge, and the physical growth rate of the Suydam-unstable
       member, both with full gamma p compression. *)

coords = {r, theta, z};
phase = m theta + k z;
bField = {0, btheta[r], bz[r]};
bMag = Sqrt[btheta[r]^2 + bz[r]^2];
current = Curl[bField, coords, "Cylindrical"]/mu0;
forceBalance = Derivative[1][p][rr_] :>
  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -
    bz[rr] Derivative[1][bz][rr]/mu0;

(* ---- physical side: full three-component displacement ---- *)
xiVec = {xr[r] Cos[phase], -xt[r] Sin[phase], -xz[r] Sin[phase]};
qField = Curl[Cross[xiVec, bField], coords, "Cylindrical"];
divXi = Div[xiVec, coords, "Cylindrical"];
gradP = {Derivative[1][p][r], 0, 0};
wDensity = qField . qField/mu0 - xiVec . Cross[current, qField] +
  gam p[r] divXi^2 + (xiVec . gradP) divXi;
(* every oscillatory term carries the argument m theta + k z with
   m != 0, so averaging over theta alone is the exact phase average *)
wPhysical = phaseAverage[wDensity, theta] /. forceBalance;
mPhysical = phaseAverage[rho[r] xiVec . xiVec, theta];
lagPhysical = 2 Pi len r (wPhysical - w2 mPhysical);
check["physical tangential amplitudes are pointwise",
  FreeQ[lagPhysical, Derivative[1][xt]] &&
  FreeQ[lagPhysical, Derivative[1][xz]]];

(* ---- GLISS side: export-chart kernels with physical mass ---- *)
sqg = 2 Pi len r;
fluxT = 2 Pi r bz[r];
fluxP = len btheta[r];
fluxTslope = D[2 Pi rr bz[rr], rr] /. rr -> r;
fluxPslope = D[len btheta[rr], rr] /. rr -> r;
currentI = len bz[r];
currentJ = 2 Pi r btheta[r];
jDotB = mu0 current . bField;
pressureSlope = mu0 Derivative[1][p][r] /. forceBalance;
gradS2 = 1;

(* class-1 pairing: xi ~ cos, eta ~ sin, mu ~ sin; unit-box angular
   derivatives carry 2 pi m and k len exactly as assembled. *)
xiVal = xr[r] Cos[phi];
xiS = Derivative[1][xr][r] Cos[phi];
xiTheta = -2 Pi m xr[r] Sin[phi];
xiZeta = -k len xr[r] Sin[phi];
etaVal = et[r] Sin[phi];
etaTheta = 2 Pi m et[r] Cos[phi];
etaZeta = k len et[r] Cos[phi];
muTheta = 2 Pi m mv[r] Cos[phi];
muZeta = k len mv[r] Cos[phi];

bgradXi = (fluxP xiTheta + fluxT xiZeta)/sqg;
bgradEta = (fluxP etaTheta + fluxT etaZeta)/sqg;
cOne = bgradXi/Sqrt[gradS2];
cTwo = -(Sqrt[gradS2]/(bMag sqg)) (sqg bgradEta -
  (fluxT fluxPslope - fluxTslope fluxP) xiVal +
  jDotB sqg xiVal/gradS2);
cThree = (1/(bMag sqg)) (currentJ etaZeta - currentI etaTheta -
  (fluxT currentI + fluxP currentJ) xiS -
  (currentJ fluxPslope + currentI fluxTslope) xiVal -
  pressureSlope sqg xiVal);
driveA = 2 btheta[r] (D[s btheta[s], s] /. s -> r)/(mu0 r^2);
(* fluxT and fluxP are the flux SLOPES F_T', F_P' in this gate's
   naming (fluxTslope/fluxPslope are the curvatures), so the
   divergence and mass formulas below use fluxT/fluxP where the
   Fortran arguments read flux_t_slope/flux_p_slope. *)
fluxNorm2 = fluxT^2 + fluxP^2;
sqgXiRadial = D[sqg, r] xiVal + sqg xiS;
sqgEtaTheta = sqg etaTheta;
sqgEtaZeta = sqg etaZeta;
divKernel = sqgXiRadial/sqg + (fluxT sqgEtaTheta -
  fluxP sqgEtaZeta + fluxP muTheta +
  fluxT muZeta)/(sqg fluxNorm2);
wKernelDensity = (cOne^2 + cTwo^2 + cThree^2 -
  mu0 driveA xiVal^2)/mu0 + gam p[r] divKernel^2;

(* physical mass tensor rows on the plain cylinder chart:
   sigma-tilde = 0, beta-tilde = 0. *)
mRowOne = xiVal/Sqrt[gradS2];
mRowTwo = Sqrt[gradS2] etaVal/bMag;
mRowThree = -(currentI fluxP - currentJ fluxT) etaVal/
    (bMag fluxNorm2) + bMag mv[r] Sin[phi]/fluxNorm2;
mKernelDensity = rho[r] (mRowOne^2 + mRowTwo^2 + mRowThree^2);

lagKernel = phaseAverage[sqg (wKernelDensity - w2 mKernelDensity),
  phi];
(* both sides are phase-averaged, so the factor 2 pinned by
   two_component_energy_identity.wl (averaged kernel vs pointwise
   physical) does not appear; abs(sqg) = sqg in this right-handed
   chart. *)
check["kernel tangential amplitudes are pointwise",
  FreeQ[lagKernel, Derivative[1][et]] &&
  FreeQ[lagKernel, Derivative[1][mv]]];

(* ---- symbolize the profile values: exact rational identities ---- *)
symbolize = {Derivative[1][btheta][r] -> btp, Derivative[1][bz][r] -> bzp,
  Derivative[1][rho][r] -> rhop, Derivative[1][xr][r] -> xd,
  btheta[r] -> btv, bz[r] -> bzv, p[r] -> pv, rho[r] -> rhov,
  xr[r] -> xv, xt[r] -> xtv, xz[r] -> xzv, et[r] -> etv, mv[r] -> mvv};
lagKernelSym = lagKernel /. symbolize;
lagPhysicalSym = lagPhysical /. symbolize;
check["no unresolved profile functions remain",
  FreeQ[{lagKernelSym, lagPhysicalSym}, btheta] &&
  FreeQ[{lagKernelSym, lagPhysicalSym}, bz] &&
  FreeQ[{lagKernelSym, lagPhysicalSym}, p] &&
  FreeQ[{lagKernelSym, lagPhysicalSym}, rho] &&
  FreeQ[{lagKernelSym, lagPhysicalSym}, xr]];

(* Eliminate the pointwise tangential amplitudes by the exact 2-by-2
   block Schur complement of the quadratic-form matrix; every zero
   test then acts on entry-sized rational expressions. *)
quadMatrix[lag_, vars_] := Table[Together[D[D[lag, i], j]/2],
  {i, vars}, {j, vars}];
schurReduce[lag_, keep_, drop_] := Module[{mat, a, b, c},
  mat = quadMatrix[lag, Join[keep, drop]];
  a = mat[[1 ;; 2, 1 ;; 2]];
  b = mat[[1 ;; 2, 3 ;; 4]];
  c = mat[[3 ;; 4, 3 ;; 4]];
  Together[a - b . {{c[[2, 2]], -c[[1, 2]]}, {-c[[2, 1]], c[[1, 1]]}} .
    Transpose[b]/(c[[1, 1]] c[[2, 2]] - c[[1, 2]] c[[2, 1]])]];
schurKernel = schurReduce[lagKernelSym, {xv, xd}, {etv, mvv}];
schurPhysical = schurReduce[lagPhysicalSym, {xv, xd}, {xtv, xzv}];

check["reduced xi'^2 coefficients agree",
  zeroQ[schurKernel[[2, 2]] - schurPhysical[[2, 2]]]];
check["reduced cross coefficients agree",
  zeroQ[schurKernel[[1, 2]] + schurKernel[[2, 1]]
    - schurPhysical[[1, 2]] - schurPhysical[[2, 1]]]];
check["reduced xi^2 coefficients agree",
  zeroQ[schurKernel[[1, 1]] - schurPhysical[[1, 1]]]];
lagPhysicalRed = {xv, xd} . schurPhysical . {xv, xd};

(* ---- continua: zeros of the reduced xi'^2 coefficient ---- *)
fCoeff = schurPhysical[[2, 2]];
fNumerator = Numerator[Together[fCoeff]];
bigF = m btv/r + k bzv;
omegaA2 = bigF^2/(mu0 rhov);
omegaS2 = gam pv bigF^2/(rhov (gam mu0 pv + btv^2 + bzv^2));
check["xi'^2 coefficient vanishes on the Alfven continuum",
  zeroQ[fNumerator /. w2 -> omegaA2]];
check["xi'^2 coefficient vanishes on the slow continuum",
  zeroQ[fNumerator /. w2 -> omegaS2]];
check["xi'^2 coefficient is generically nonzero off the continua",
  ! zeroQ[fNumerator /. w2 -> 2 omegaA2 + omegaS2 /.
    {btv -> 1/5, bzv -> 1, rhov -> 2, pv -> 3, btp -> 1/7, bzp -> 1/11,
     gam -> 5/3, mu0 -> 7/10, r -> 1/3, m -> 2, k -> 3, len -> 6}]];

(* ---- theta-pinch Bessel reduction ---- *)
thetaPinch = {btv -> 0, btp -> 0, bzv -> b0, bzp -> 0, pv -> p0,
  rhov -> rho0, rhop -> 0};
lagTP = Together[lagPhysicalRed /. thetaPinch];
lagTPfun = lagTP /. {xv -> xr[r], xd -> xr'[r]};
eulerTP = D[lagTPfun, xr[r]] - D[D[lagTPfun, xr'[r]], r];
vA2 = b0^2/(mu0 rho0);
cS2 = gam p0/rho0;
kappa2 = ((w2 - k^2 vA2) (w2 - k^2 cS2))/((vA2 + cS2)
  (w2 - k^2 cS2 vA2/(vA2 + cS2)));
besselReduce[expr_] := expr //. BesselJ[n_ /; n >= 2, x_] :>
  2 (n - 1)/x BesselJ[n - 1, x] - BesselJ[n - 2, x];
(* each J0/J1 coefficient has the form even(kap^2) + kap odd(kap^2);
   it vanishes at kap = Sqrt[kappa2] iff even^2 - kappa2 odd^2 = 0
   together with one numeric sign confirmation at a generic point. *)
signPoint = {b0 -> 2, p0 -> 3, rho0 -> 5, mu0 -> 7/10, gam -> 5/3,
  k -> 1/3, w2 -> 1/2, r -> 6/5};
branchZeroQ[expr_] := Module[{num, even, odd},
  num = Expand[Numerator[Together[expr]]] /. kap^n_ /; n >= 2 :>
    kap^Mod[n, 2] kappa2^Quotient[n, 2];
  num = Together[num];
  even = num /. kap -> 0;
  odd = Together[(num - even)/kap];
  zeroQ[Together[even^2 - kappa2 odd^2]] &&
    Chop[N[num /. kap -> Sqrt[kappa2] /. signPoint /. r -> 6/5, 40],
      10^-25] == 0];
Do[Module[{residual, reduced, c0, c1, rest},
    residual = eulerTP /. m -> order /.
      {xr -> Function[rr, Evaluate[D[BesselJ[order, kap rr], rr]]]};
    reduced = Expand[besselReduce[residual]];
    c0 = Coefficient[reduced, BesselJ[0, kap r]];
    c1 = Coefficient[reduced, BesselJ[1, kap r]];
    rest = Together[reduced - c0 BesselJ[0, kap r] -
      c1 BesselJ[1, kap r]];
    check["theta-pinch equation is solved by the Bessel branch, m = "
      <> ToString[order],
      branchZeroQ[c0] && branchZeroQ[c1] && zeroQ[rest]]],
  {order, 1, 2}];

(* ---- fixture constants ---- *)
(* mode (3, 1): xi ~ r^2 = a^2 s at the axis is exactly representable
   by the P1-in-s space with the CAS3D xi(0) = 0 rule, so the axis
   constraint costs no convergence order; m = 1 and m = 2 modes hit
   the documented coefficient-rule limitation whose exact spaces are
   E2 scope. *)
prec = 40;
aWall = 1/2; lenF = 6 Pi; b0F = 1; mu0F = 4 Pi 10^-7;
bLin = 3/10; bCub = 4/10;
rho0F = 2; gamF = 5/3; pOffset = 100;
modeM = 3; modeN = 1;
kF = -2 Pi modeN/lenF;

vA2F = b0F^2/(mu0F rho0F); cS2F = gamF pOffset/rho0F;
alfvenPoint = N[kF^2 vA2F, prec];
slowPoint = N[kF^2 cS2F vA2F/(vA2F + cS2F), prec];
kappa2F = ((w2 - kF^2 vA2F) (w2 - kF^2 cS2F))/((vA2F + cS2F)
  (w2 - kF^2 cS2F vA2F/(vA2F + cS2F)));
besselPrimeSeed = {42/10, 80/10, 113/10};
besselRoot[j_] := (x /. FindRoot[D[BesselJ[modeM, y], y] /. y -> x,
  {x, besselPrimeSeed[[j]]}, WorkingPrecision -> prec])/aWall;
branchPair[j_] := Sort[Select[w2 /. NSolve[
  Numerator[Together[kappa2F - besselRoot[j]^2]] == 0, w2,
  WorkingPrecision -> prec], # > 0 &]];
pairOne = branchPair[1];
pairTwo = branchPair[2];
slowBranch = pairOne[[1]];
fastBranch = pairOne[[2]];
fastSecond = pairTwo[[2]];
(* the slow branch decreases with radial wavenumber, so the discrete
   slow modes accumulate at the slow point FROM ABOVE and the whole
   slow band is a few 1e-7 wide relative for these constants. *)
check["theta-pinch branches order as slow band, Alfven point, fast",
  slowPoint < slowBranch < alfvenPoint < fastBranch];
check["theta-pinch slow band is narrow",
  (slowBranch - slowPoint)/slowPoint < 10^-6];
Print["REF theta_pinch_slow_point      ", N[slowPoint, 16]];
Print["REF theta_pinch_alfven_point    ", N[alfvenPoint, 16]];
Print["REF theta_pinch_slow_lowest     ", N[slowBranch, 16]];
Print["REF theta_pinch_fast_lowest     ", N[fastBranch, 16]];
Print["REF theta_pinch_fast_second     ", N[fastSecond, 16]];

(* ---- screw-pinch fixture profiles ---- *)
bthetaF[rr_] := bLin rr + bCub rr^3;
integralAt[rr_] := bLin^2 rr^2 + (3/2) bLin bCub rr^4 +
  (2/3) bCub^2 rr^6;
pressureF[rr_, frac_] := frac (integralAt[aWall] - integralAt[rr])/
  mu0F + pOffset;
bAxialF[rr_, frac_] := Sqrt[b0F^2 + 2 (1 - frac)
  (integralAt[aWall] - integralAt[rr])];

screwLagFun[frac_, mm_, kk_] := Module[{lag},
  lag = lagPhysicalRed /. {m -> mm, k -> kk, len -> lenF,
    mu0 -> mu0F, gam -> gamF, rhov -> rho0F, rhop -> 0,
    btv -> bthetaF[r], btp -> D[bthetaF[rr], rr] /. rr -> r,
    bzv -> bAxialF[r, frac],
    bzp -> D[bAxialF[rr, frac], rr] /. rr -> r,
    pv -> pressureF[r, frac]};
  lag /. {xv -> xr[r], xd -> xr'[r]}];

(* normalized shooting residual: the raw edge value spans hundreds of
   orders of magnitude across the probe range, which lets FindRoot
   accept a bracket endpoint; the normalized value is O(1) with the
   same zeros. *)
shootResidual[lagFun_, w2val_?NumericQ, mm_] := Module[
  {eq, sol, r0 = 10^-6 aWall, edge, edgeSlope},
  eq = (D[lagFun, xr[r]] - D[D[lagFun, xr'[r]], r]) /. w2 -> w2val;
  sol = NDSolve[{eq == 0, xr[r0] == r0^(Abs[mm] - 1),
      xr'[r0] == (Abs[mm] - 1) r0^(Abs[mm] - 2)}, xr, {r, r0, aWall},
    WorkingPrecision -> 32, MaxSteps -> 10^6][[1]];
  edge = xr[aWall] /. sol;
  edgeSlope = xr'[aWall] /. sol;
  edge/Sqrt[edge^2 + (aWall edgeSlope)^2]];

refineBracket[lagFun_, bracket_, mm_, steps_] := Module[
  {grid, signs, pos},
  grid = bracket[[1] ] + (bracket[[2]] - bracket[[1]])
    Range[0, steps]/steps;
  signs = Sign[shootResidual[lagFun, #, mm] & /@ grid];
  pos = FirstPosition[Differences[signs], _?(# != 0 &)][[1]];
  {grid[[pos]], grid[[pos + 1]]}];

suydamM = 4; suydamN = 4;
suydamK = -2 Pi suydamN/lenF;
lagU = screwLagFun[1, suydamM, suydamK];

probeGrid = -10^Range[6, -2, -1];
probeSigns = Sign[shootResidual[lagU, #, suydamM] & /@ probeGrid];
crossing = FirstPosition[Differences[probeSigns], _?(# != 0 &)];
check["unstable member shooting scan finds a sign change",
  ! MissingQ[crossing]];
growthBracket = probeGrid[[{crossing[[1]], crossing[[1]] + 1}]];
growthBracket = refineBracket[lagU, growthBracket, suydamM, 8];
growthBracket = refineBracket[lagU, growthBracket, suydamM, 8];
growthRef = w2 /. FindRoot[shootResidual[lagU, w2, suydamM],
  {w2, Mean[growthBracket], growthBracket[[1]], growthBracket[[2]]},
  WorkingPrecision -> 24, AccuracyGoal -> 12, PrecisionGoal -> 12];
check["unstable growth lies inside the refined bracket",
  growthBracket[[1]] < growthRef < growthBracket[[2]]];
Print["REF screw_unstable_omega2       ", N[growthRef, 16]];

slowEdge[frac_, mm_, kk_] := Module[{expr},
  expr = gamF pressureF[r, frac] (mm bthetaF[r]/r + kk
    bAxialF[r, frac])^2/(rho0F (gamF mu0F pressureF[r, frac] +
    bthetaF[r]^2 + bAxialF[r, frac]^2));
  NMinValue[{expr, 0 < r < aWall}, r, WorkingPrecision -> prec]];

(* the (4,4) family member is resonant (iota crosses 1), so its slow
   edge is zero; the below-edge exclusion check uses the non-resonant
   (2,1) member instead: its resonance value n/m = 1/2 lies outside
   the iota range [0.9, 1.2], so F and the slow edge stay positive. *)
nonresM = 2; nonresN = 1;
nonresK = -2 Pi nonresN/lenF;
lagS = screwLagFun[1/4, nonresM, nonresK];
stableSlowEdge = slowEdge[1/4, nonresM, nonresK];
Print["REF screw_stable_slow_edge      ", N[stableSlowEdge, 16]];

check["stable member has no discrete mode at or below the slow edge",
  Module[{probe, signs},
    probe = Join[-stableSlowEdge {100, 1, 1/100},
      stableSlowEdge {1/50, 1/5, 1/2, 9/10}];
    signs = Sign[shootResidual[lagS, #, nonresM] & /@ probe];
    Length[Union[signs]] == 1]];
check["unstable member growth is negative and finite",
  growthRef < 0 && NumericQ[growthRef]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

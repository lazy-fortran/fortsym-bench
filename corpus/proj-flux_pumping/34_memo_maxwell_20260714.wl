(* Sergei Kasilov memo, 2026-07-14: exact check of the new "General
   helical geometry / Solution of Maxwell equations" section.  Cylindrical
   coordinates are (r, theta, phi=z/R0), sqrt(g)=r R0, and Fourier phase is
   Exp[I (m theta+n phi)].  Covariant angular field components are used in
   Ampere's law exactly as in the memo.  The checks also delimit the
   long-cylinder formula: its displayed powers and factorials require m>0;
   the FP harmonic m=-1 requires ell=Abs[m] in the Bessel order and powers,
   while signed factors 1/m must be retained.  Likewise the decaying Bessel
   argument is kappa=Abs[k_z]; the memo's k_z^2 prefactor for B^phi assumes
   its stated positive-n harmonics. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[r, rho, theta, phi, alpha, m, n, capR, cl, jacobian,
  jphi, jtheta, radius, current, bphi, br, y, kz];

(* --- (divfreej), (jtheta_df), (checkjrzero), (curincyl). --- *)
alpha = m theta + n phi;
jac = jacobian[rho, alpha];
jphiGeneral = jphi[rho, alpha];
jthetaGeneral = -n jphiGeneral/m + cSurface[rho]/jac;
divergenceNumerator =
  D[jac jthetaGeneral, theta] + D[jac jphiGeneral, phi];

check["2026-07-14 (divfreej,jtheta_df): general solution is solenoidal",
  FullSimplify[divergenceNumerator == 0, m != 0]];

radiusMap = radius[rho, alpha];
jthetaFree = jtheta[rho, alpha];
jphiFree = jphi[rho, alpha];
jrChain = D[radiusMap, theta] jthetaFree +
  D[radiusMap, phi] jphiFree;
jrChainCorrect = (m jthetaFree + n jphiFree) *
  Derivative[0, 1][radius][rho, alpha];

check["2026-07-14 (checkjrzero): chain rule contains partial r/partial alpha",
  FullSimplify[jrChain == jrChainCorrect]];
(* The memo prints the factor partial r/partial rho instead.  On an explicit
   corrugated fixture the printed factor differs from the chain rule. *)
jrChainPrinted = (m jthetaFree + n jphiFree) *
  Derivative[1, 0][radius][rho, alpha];
typoFixtureRules = {
  radius -> Function[{s, a}, s (1 + s Cos[a])],
  jtheta -> Function[{s, a}, s^2 + Sin[a]],
  jphi -> Function[{s, a}, Cos[a] - s],
  m -> 2, n -> 1, rho -> 1/2, theta -> Pi/5, phi -> Pi/7};
check["2026-07-14 (checkjrzero) TYPO: printed partial r/partial rho factor fails on a corrugated fixture",
  Abs[N[(jrChain /. typoFixtureRules) -
      (jrChainPrinted /. typoFixtureRules)]] > 10^-3];
check["2026-07-14 (curincyl): m jtheta+n jphi=0 makes jr vanish on every same-helicity surface",
  FullSimplify[(jrChainCorrect /. jtheta[rho, alpha] ->
      -n jphi[rho, alpha]/m) == 0, m != 0]];

(* The same result directly in the unperturbed cylindrical coordinates. *)
phase = Exp[I alpha];
jphiCyl = current[r] phase;
jthetaCyl = -n current[r] phase/m;
divJCyl = (D[capR r jthetaCyl, theta] +
    D[capR r jphiCyl, phi])/(capR r);
check["2026-07-14 (curincyl): arbitrary radial Fourier amplitude is divergence-free",
  FullSimplify[divJCyl == 0, m != 0]];

(* The memo uses the contravariant toroidal/axial amplitude
   scriptJ=j_m^phi, whereas the consolidated Maxwell section uses the
   physical axial amplitude J=R0 scriptJ.  Keep the R0 map explicit. *)
ClearAll[scriptJ, physicalJ, displacement, phaseCorrelation];
physicalJ[r_] := capR scriptJ[r];
check["[definition] 2026-07-14 current normalization: sqrt(g) j^phi = r J",
  FullSimplify[(r capR) scriptJ[r] == r physicalJ[r]]];
check["[definition] 2026-07-14 current normalization: physical axial j_z=R0 j^phi=J",
  FullSimplify[capR scriptJ[r] == physicalJ[r]]];

meanContravariant = D[r scriptJ[r] displacement[r] phaseCorrelation, r]/(2 r);
meanPhysicalFromMemo = capR meanContravariant;
meanPhysicalReport = D[r physicalJ[r] displacement[r] phaseCorrelation, r]/(2 r);
check["2026-07-14 mean-current map: R0 <j^phi> equals the physical-J formula",
  FullSimplify[meanPhysicalFromMemo == meanPhysicalReport]];
enclosedPhysicalDerivative = 2 Pi r meanPhysicalReport;
boundaryCurrentDerivative = D[
  Pi r physicalJ[r] displacement[r] phaseCorrelation, r];
check["2026-07-14 boundary map: enclosed physical current is Pi r J Delta cos",
  FullSimplify[enclosedPhysicalDerivative == boundaryCurrentDerivative]];

(* --- (rcompamp)--(divB0_subs). --- *)
bphiCov = bphi[r] phase;
bthetaCov = (m/n) bphi[r] phase;
brCov = br[r] phase;

curlContravariant = {
  (D[bphiCov, theta] - D[bthetaCov, phi])/(r capR),
  (D[brCov, phi] - D[bphiCov, r])/(r capR),
  (D[bthetaCov, r] - D[brCov, theta])/(r capR)};

check["2026-07-14 (rcompamp): m B_phi=n B_theta makes radial curl zero",
  FullSimplify[curlContravariant[[1]] == 0, n != 0]];
(* The prose before (phicompamp) prints B_theta=-m B_phi/n.  That sign
   leaves a nonvanishing radial curl 2 I m B_phi/(r R0), so only the
   positive sign is compatible with (rcompamp). *)
bthetaCovProse = -(m/n) bphi[r] phase;
curlRadialProse = (D[bphiCov, theta] - D[bthetaCovProse, phi])/(r capR);
check["2026-07-14 prose before (phicompamp) SIGN TYPO: printed B_theta=-m B_phi/n leaves radial curl 2 I m B_phi/(r R0)",
  FullSimplify[curlRadialProse == 2 I m bphi[r] phase/(r capR), n != 0]];

ampereSource = 4 Pi n r capR current[r]/(cl m);
phiAmpereLhs = bphi'[r] - I n br[r];
check["2026-07-14 (phicompamp): toroidal curl reduces to the printed scalar equation",
  FullSimplify[curlContravariant[[3]] ==
    m phase phiAmpereLhs/(n r capR), n != 0]];
check["2026-07-14: theta Ampere component is redundant when (phicompamp) holds",
  FullSimplify[(curlContravariant[[2]] /. bphi'[r] ->
      I n br[r] + ampereSource) ==
    4 Pi jthetaCyl/cl, m != 0 && n != 0]];

bthetaContrav = bthetaCov/r^2;
bphiContrav = bphiCov/capR^2;
divB = (D[r capR brCov, r] + D[r capR bthetaContrav, theta] +
    D[r capR bphiContrav, phi])/(r capR);
memoDivAmplitude = n D[r br[r], r]/r +
  I (m^2/r^2 + n^2/capR^2) bphi[r];
check["2026-07-14 (divB0): cylindrical divergence gives the printed equation",
  FullSimplify[n divB/phase == memoDivAmplitude, n != 0]];

brFromAmpere = I (ampereSource - bphi'[r])/n;
covariantResidual = D[r bphi'[r], r]/r -
  (m^2/r^2 + n^2/capR^2) bphi[r] -
  4 Pi n capR D[r^2 current[r], r]/(cl m r);
divAfterAmpere = n D[r brFromAmpere, r]/r +
  I (m^2/r^2 + n^2/capR^2) bphi[r];
check["2026-07-14 (divB0_subs): eliminating Br gives the printed scalar PDE",
  FullSimplify[divAfterAmpere + I covariantResidual == 0,
    m != 0 && n != 0]];

(* --- (divB0_fouramp), (amplbr), (amplbtheta). --- *)
kz = n/capR;
fourierResidual = D[r y'[r], r]/r -
  (m^2/r^2 + n^2/capR^2) y[r] -
  4 Pi n D[r^2 current[r], r]/(cl m capR r);
check["2026-07-14 (divB0_fouramp): B_phi=R0^2 B^phi gives the printed ODE",
  FullSimplify[(covariantResidual /. {
        bphi[r] -> capR^2 y[r], bphi'[r] -> capR^2 y'[r],
        bphi''[r] -> capR^2 y''[r]})/capR^2 == fourierResidual,
    capR != 0]];
check["2026-07-14 (amplbtheta): contravariant poloidal component",
  FullSimplify[(bthetaCov/(r^2 phase)) ==
    m capR^2 (bphiContrav/phase)/(n r^2), n != 0]];

brLocalMemo = I capR/kz (4 Pi kz r current[r]/(cl m) - y'[r]);
check["2026-07-14 (brsol line 1): local Br formula follows from phicompamp",
  FullSimplify[(brFromAmpere /. {
      bphi'[r] -> capR^2 y'[r], n -> kz capR}) == brLocalMemo,
    kz != 0 && capR != 0]];

ClearAll[radialIntegral];
brIntegral = -I capR^2 radialIntegral[r]/(n r);
integralRule = radialIntegral'[r] ->
  r (m^2/r^2 + n^2/capR^2) y[r];
check["2026-07-14 (amplbr line 1): regular-axis integral solves divB0",
  FullSimplify[
    ((n D[r brIntegral, r]/r +
      I capR^2 (m^2/r^2 + n^2/capR^2) y[r]) /.
      integralRule) == 0, n != 0]];

(* --- (wrbes), (solbes), (brsol): variation of constants.  Abstract
   regular/decaying functions use radial derivatives.  The memo primes on
   I_m(k r),K_m(k r) are derivatives with respect to their argument, hence
   the 1/k in the moment derivative rules below. --- *)
ClearAll[ell, kappa, signedK, signedM, ireg, kdec, lowerI, upperK];
prefactor = 4 Pi signedK kappa/(cl signedM);
green = prefactor (ireg[r] upperK[r] + kdec[r] lowerI[r]);
momentDerivativeRules = {
  lowerI'[r] -> r^2 ireg'[r] current[r]/kappa,
  upperK'[r] -> -r^2 kdec'[r] current[r]/kappa};
radialWronskian = ireg[r] kdec'[r] - ireg'[r] kdec[r];
greenPrimeMemo = prefactor (ireg'[r] upperK[r] +
    kdec'[r] lowerI[r] + r current[r]/kappa);

check["2026-07-14 (solbes): differentiating the Green moments gives the local source term",
  FullSimplify[(D[green, r] /. momentDerivativeRules) == greenPrimeMemo,
    radialWronskian == -1/r && kappa != 0]];

homogeneousRules = {
  ireg''[r] -> -ireg'[r]/r + (ell^2/r^2 + kappa^2) ireg[r],
  kdec''[r] -> -kdec'[r]/r + (ell^2/r^2 + kappa^2) kdec[r]};
greenSecond = D[greenPrimeMemo, r] /. momentDerivativeRules;
greenResidual = greenSecond + greenPrimeMemo/r -
  (ell^2/r^2 + kappa^2) green -
  4 Pi signedK (r current'[r] + 2 current[r])/(cl signedM);
check["2026-07-14 (solbes): Bessel Green solution satisfies divB0_fouramp",
  FullSimplify[(greenResidual /. homogeneousRules) == 0,
    kappa != 0 && signedK != 0]];

brGreenFromAmpere = I capR/signedK (
    4 Pi signedK r current[r]/(cl signedM) -
    greenPrimeMemo);
brGreenMemo = prefactor capR/(I signedK) (ireg'[r] upperK[r] +
    kdec'[r] lowerI[r]);
check["2026-07-14 (brsol line 2): differentiating solbes gives the printed Bessel formula",
  FullSimplify[brGreenFromAmpere == brGreenMemo,
    kappa != 0 && signedK != 0]];

check["2026-07-14 (wrbes): modified-Bessel Wronskian",
  FullSimplify[
    BesselI[ell, x] D[BesselK[ell, x], x] -
      D[BesselI[ell, x], x] BesselK[ell, x] == -1/x,
    x > 0 && ell > 0]];
check["2026-07-14 exact solution: negative integer order equals Abs[m] order",
  FullSimplify[BesselI[-1, x] == BesselI[1, x] &&
    BesselK[-1, x] == BesselK[1, x], x > 0]];
(* The radial ODE depends on k_z only through k_z^2, so the decaying
   solution carries the Bessel argument kappa r with kappa=|k_z|. *)
homogeneousRadialOperator = D[r y'[r], r]/r -
  (m^2/r^2 + n^2/capR^2) y[r];
check["2026-07-14 exact solution: homogeneous radial operator is even in k_z, so decay uses kappa=|k_z|",
  FullSimplify[(homogeneousRadialOperator /. n -> -n) ==
    homogeneousRadialOperator]];
(* The memo prints the Green prefactor as k_z^2; the derivation gives the
   signed product k_z kappa.  Rebuilding the Green solution with the printed
   prefactor kappa^2 satisfies the ODE only for k_z=+kappa and leaves the
   residual 8 pi kappa (r j' + 2 j)/(c m) for k_z=-kappa. *)
greenPrinted = 4 Pi kappa^2/(cl signedM) *
  (ireg[r] upperK[r] + kdec[r] lowerI[r]);
greenPrintedPrime = 4 Pi kappa^2/(cl signedM) *
  (ireg'[r] upperK[r] + kdec'[r] lowerI[r] + r current[r]/kappa);
greenPrintedSecond = D[greenPrintedPrime, r] /. momentDerivativeRules;
greenPrintedResidual = greenPrintedSecond + greenPrintedPrime/r -
  (ell^2/r^2 + kappa^2) greenPrinted -
  4 Pi signedK (r current'[r] + 2 current[r])/(cl signedM);
check["2026-07-14 solbes domain: printed k_z^2 prefactor solves the ODE only for k_z=+kappa",
  FullSimplify[(D[greenPrinted, r] /. momentDerivativeRules) ==
      greenPrintedPrime, radialWronskian == -1/r && kappa != 0] &&
  FullSimplify[((greenPrintedResidual /. homogeneousRules) /.
      signedK -> kappa) == 0, kappa > 0] &&
  FullSimplify[((greenPrintedResidual /. homogeneousRules) /.
      signedK -> -kappa) ==
    8 Pi kappa (r current'[r] + 2 current[r])/(cl signedM), kappa > 0]];

(* --- (beslead), (solbes_approx): positive-order and signed-m domains. --- *)
check["2026-07-14 (beslead): m=1 leading I and K coefficients",
  FullSimplify[
    Limit[BesselI[1, x]/(x/2), x -> 0] == 1 &&
    Limit[BesselK[1, x]/x^-1, x -> 0, Direction -> "FromAbove"] == 1]];
check["2026-07-14 (beslead): product kernel has the printed leading term for positive m",
  FullSimplify[Limit[
      BesselI[1, eps x] BesselK[1, eps xp]/(x/(2 xp)),
      eps -> 0, Direction -> "FromAbove"] == 1,
    x > 0 && xp > 0]];

ClearAll[lowerMoment, upperMoment];
momentRules = {
  lowerMoment'[r] -> r^(ell + 1) current[r],
  lowerMoment''[r] -> (ell + 1) r^ell current[r] +
    r^(ell + 1) current'[r],
  upperMoment'[r] -> -r^(1 - ell) current[r],
  upperMoment''[r] -> -(1 - ell) r^-ell current[r] -
    r^(1 - ell) current'[r]};
yLong = 2 Pi n/(cl signedM capR) (r^-ell lowerMoment[r] -
    r^ell upperMoment[r]);
brLong = 2 Pi I capR ell/(cl signedM r) (r^-ell lowerMoment[r] +
    r^ell upperMoment[r]);
longRadialResidual = D[r D[yLong, r], r]/r - ell^2 yLong/r^2 -
  4 Pi n D[r^2 current[r], r]/(cl signedM capR r);
check["2026-07-14 (solbes_approx): |m|-order moments solve the k_z=0 radial equation",
  FullSimplify[(longRadialResidual /. momentRules) == 0,
    ell > 0 && signedM != 0]];
longAmpereResidual = capR^2 D[yLong, r] - I n brLong -
  4 Pi n r capR current[r]/(cl signedM);
check["2026-07-14 (solbes_approx): signed-|m| fields retain phicompamp",
  FullSimplify[(longAmpereResidual /. momentRules) == 0,
    ell > 0 && signedM != 0]];
check["2026-07-14 (solbes_approx): printed Br coefficient is recovered for m=ell>0",
  FullSimplify[(brLong /. signedM -> ell) ==
    2 Pi I capR/r (r^-ell lowerMoment[r] +
      r^ell upperMoment[r])/cl, ell > 0]];
check["2026-07-14 FP m=-1: corrected Br carries ell/m=-1 and uses ell=|m| in all powers",
  FullSimplify[(brLong /. {signedM -> -1, ell -> 1}) ==
    -2 Pi I capR/r (r^-1 lowerMoment[r] +
      r upperMoment[r])/cl]];

fixtureCurrent[s_] := s Exp[-s];
printedNegativeM = -2 Pi (Integrate[fixtureCurrent[s], {s, 0, 1}] -
    Integrate[s^2 fixtureCurrent[s], {s, 1, Infinity}]);
correctNegativeM = -2 Pi (Integrate[s^2 fixtureCurrent[s], {s, 0, 1}] -
    Integrate[fixtureCurrent[s], {s, 1, Infinity}]);
check["2026-07-14 FP m=-1 DOMAIN ERROR: literal signed powers differ from the |m|-corrected Bessel limit",
  Abs[N[printedNegativeM - correctNegativeM]] > 1];

kernelRelativeError = Abs[
  BesselI[1, 1/10] BesselK[1, 1/10]/(1/2) - 1];
check["2026-07-14 one-percent caveat: k_z r=0.1 already gives >1% error in the leading m=1 kernel",
  N[kernelRelativeError] > 0.01];
Print["    leading-kernel relative error at k_z r=0.1 = ",
  N[kernelRelativeError, 8]];

reportAndExit[];

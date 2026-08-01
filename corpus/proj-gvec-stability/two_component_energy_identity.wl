ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, len > 0, mu0 > 0, bz[r] > 0,
  Element[{m, k}, Reals], m^2 + k^2 r^2 > 0,
  Element[{btheta[r], xr[r], eta[r], Derivative[1][xr][r],
    Derivative[1][btheta][r], Derivative[1][bz][r]}, Reals],
  btheta[r]^2 + bz[r]^2 > 0};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];
conj[expr_] := expr /. Complex[a_, b_] :> Complex[a, -b];

(* Does the two-component form (C^1)^2 + (C^2)^2 + (C^3)^2 - A (xi^s)^2,
   assembled exactly as GLISS pairs it (xi ~ cos phase, eta ~ sin phase,
   angular average), equal the physical incompressible energy density on
   the screw pinch with a GENERAL axial profile bz[r]?  Both sides
   reduce to radial (f, cross, c) coefficients after minimizing over
   the tangential amplitude.  r-label, right-handed chart,
   phase = m theta + k z. *)

coords = {r, theta, z};
phase = Exp[I (m theta + k z)];
bField = {0, btheta[r], bz[r]};
bMag = Sqrt[btheta[r]^2 + bz[r]^2];
current = Curl[bField, coords, "Cylindrical"]/mu0;
forceBalance = Derivative[1][p][rr_] :>
  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -
    bz[rr] Derivative[1][bz][rr]/mu0;

xiPerp = {xr[r], -I eta[r] bz[r]/bMag, I eta[r] btheta[r]/bMag} phase;
qField = Curl[Cross[xiPerp, bField], coords, "Cylindrical"];
divPerp = Div[xiPerp, coords, "Cylindrical"];
gradP = {Derivative[1][p][r], 0, 0};
density = qField . conj[qField]/mu0 -
  conj[xiPerp] . Cross[current, qField] +
  (xiPerp . gradP) conj[divPerp];
physical = Simplify[ComplexExpand[(density + conj[density])/2,
    TargetFunctions -> {Re, Im}] /. {theta -> 0, z -> 0} /.
    forceBalance, assumptions];
physicalWeighted = Simplify[2 Pi len r physical, assumptions];

(* Kernel side: GLISS two_component_components with the assembly's
   real trig pairing and mu0-scaled current inputs, angular-averaged.
   phi is the common phase; xi = xs Cos[phi], eta_K = et Sin[phi]. *)
sqg = 2 Pi len r;
fluxT = 2 Pi r bz[r];
fluxP = len btheta[r];
fluxTslope = D[2 Pi rr bz[rr], rr] /. rr -> r;
fluxPslope = D[len btheta[rr], rr] /. rr -> r;
currentI = len bz[r];
currentJ = 2 Pi r btheta[r];
jDotB = Simplify[mu0 current . bField, assumptions];
pressureSlope = mu0 Derivative[1][p][r] /. forceBalance;
gradS2 = 1;

xiVal = xr[r] Cos[phi];
xiS = Derivative[1][xr][r] Cos[phi];
xiTheta01 = -2 Pi m xr[r] Sin[phi]/(2 Pi);
xiZeta01 = -k len xr[r] Sin[phi]/(2 Pi);
etaTheta01 = 2 Pi m et[r] Cos[phi]/(2 Pi);
etaZeta01 = k len et[r] Cos[phi]/(2 Pi);
(* GLISS stores angular derivatives with respect to the unit-box
   angles theta01 = theta/(2 Pi), zeta01 = z/len (one period), so the
   assembly rows carry 2 Pi m and -2 Pi n = k len factors directly;
   the factors above already include them via the chain rule to
   (theta, z), keeping bgrad = (FP' d_theta01 + FT' d_zeta01)/sqg. *)
xiTheta = 2 Pi xiTheta01; xiZeta = 2 Pi xiZeta01;
etaTheta = 2 Pi etaTheta01; etaZeta = 2 Pi etaZeta01;

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
kernelDensity = cOne^2 + cTwo^2 + cThree^2 - mu0 driveA xiVal^2;
kernelAveraged = Simplify[
  Integrate[kernelDensity, {phi, 0, 2 Pi}]/(2 Pi), assumptions];
kernelWeighted = Simplify[kernelAveraged Abs[sqg]/mu0 2, assumptions];
(* factor 2: the angular average halves every square; the physical
   density at theta = z = 0 keeps full amplitudes. *)

reduceQuadratic[w_, amp_] := Module[{q},
  q = CoefficientList[w, amp];
  Simplify[q[[1]] - q[[2]]^2/(4 q[[3]]), assumptions]];

kernelReduced = reduceQuadratic[kernelWeighted, et[r]];
physicalReduced = reduceQuadratic[physicalWeighted, eta[r]];

fKernel = Simplify[D[kernelReduced, {xr'[r], 2}]/2, assumptions];
fPhysical = Simplify[D[physicalReduced, {xr'[r], 2}]/2, assumptions];
check["bending coefficients agree",
  FullSimplify[fKernel == fPhysical, assumptions]];

crossKernel = Simplify[D[D[kernelReduced, xr'[r]], xr[r]], assumptions];
crossPhysical = Simplify[D[D[physicalReduced, xr'[r]], xr[r]],
  assumptions];
cKernel = Simplify[D[kernelReduced, {xr[r], 2}]/2, assumptions];
cPhysical = Simplify[D[physicalReduced, {xr[r], 2}]/2, assumptions];
check["cross coefficients agree",
  FullSimplify[crossKernel == crossPhysical, assumptions]];
check["local coefficients agree",
  FullSimplify[cKernel == cPhysical, assumptions]];

difference = Simplify[cKernel - cPhysical, assumptions];
constantBz = Simplify[difference /. {Derivative[1][bz][r] -> 0,
  Derivative[2][bz][r] -> 0}, assumptions];
Print["c difference: ", difference];
Print["c difference with constant bz: ", constantBz];
Print["cross difference: ",
  Simplify[crossKernel - crossPhysical, assumptions]];
Print["f difference: ", Simplify[fKernel - fPhysical, assumptions]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

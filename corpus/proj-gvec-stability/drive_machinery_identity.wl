ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, aa > 0, r < aa, len > 0, mu0 > 0, bz[r] > 0,
  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],
    Derivative[2][btheta][r], Derivative[2][bz][r]}, Reals],
  btheta[r]^2 + bz[r]^2 > 0};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* The interchange-drive machinery that build_kernel_geometry assembles
   from export data (mu0-scaled currents, s-label, left-handed fixture
   chart, beta-tilde and chart terms vanishing on the cylinder) must
   reproduce the geometric drive A = 2 |grad s|^-4 (mu0 j x grad s) .
   (B . grad) grad s that the energy-identity gate certifies.  General
   axial profile bz[r]. *)

s2r = aa Sqrt[sv];             (* radial label: s in (0,1), r = a sqrt(s) *)
drds = D[s2r, sv];
sqg = -Pi aa^2 len;            (* signed, left-handed export chart *)
gradS2 = 4 r^2/aa^4;

fluxTslope = -Pi aa^2 bz[r];   (* d Phi_T / ds *)
fluxPslope = -(aa^2 len/2) (btheta[r]/r);
covariantZeta = len bz[r];     (* current function I in the code naming *)
covariantTheta = 2 Pi r btheta[r];

dds[f_] := (D[f /. r -> rr, rr] /. rr -> r) (aa^2/(2 r));
(* d/ds = (dr/ds) d/dr with dr/ds = a^2/(2 r) since s = (r/a)^2 *)

fluxTcurve = dds[fluxTslope];
fluxPcurve = dds[fluxPslope];
covariantZetaSlope = dds[covariantZeta];
covariantThetaSlope = dds[covariantTheta];
pressureSlopeS = dds[p[r]] /. Derivative[1][p][rr_] :>
  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -
    bz[rr] Derivative[1][bz][rr]/mu0;

jDotB = (covariantZetaSlope covariantTheta -
  covariantThetaSlope covariantZeta)/sqg;
(* fields(10) with beta-tilde = 0: mu0 sqrt(g) j^theta = -I',
   mu0 sqrt(g) j^zeta = J', dotted with covariant components. *)

term1 = (jDotB^2 + (mu0 pressureSlopeS)^2 gradS2)/
  ((btheta[r]^2 + bz[r]^2) gradS2);
term2 = (fluxTcurve covariantZetaSlope +
  fluxPcurve covariantThetaSlope)/sqg;
machinery = term1 + term2;

(* Geometric drive in the same s-label and code units: the kernel
   subtracts drive * xi^2 against C-components built from mu0-scaled
   currents, so drive = mu0^2 A(SI) with A from interchange_drive.wl,
   transformed to the s-label by |grad s|^-4 (j x grad s).(B.grad)grad s
   = (a^2/(2 r))^2 x (r-label value). *)
geometric = (aa^2/(2 r))^2 (2 btheta[r] (D[s btheta[s], s] /.
  s -> r)/(r^2));

check["the transcribed plus-sign group does not close the identity",
  ! TrueQ[FullSimplify[term1 + term2 - geometric, assumptions] == 0]];
check["the minus-sign current-curvature group closes the s-label identity",
  FullSimplify[term1 - term2 - geometric, assumptions] == 0];

(* r-label variant: sqrt(g) varies radially, so the p'(sqrt g)' term
   activates and its sign group gets pinned as well. *)
sqgR = -2 Pi len r;
gradS2R = 1;
fluxTslopeR = -2 Pi r bz[r];
fluxPslopeR = -len btheta[r];
ddr[f_] := D[f /. r -> rr, rr] /. rr -> r;
fluxTcurveR = ddr[fluxTslopeR];
fluxPcurveR = ddr[fluxPslopeR];
covariantZetaSlopeR = ddr[covariantZeta];
covariantThetaSlopeR = ddr[covariantTheta];
pressureSlopeR = mu0 (Derivative[1][p][r] /. Derivative[1][p][rr_] :>
  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -
    bz[rr] Derivative[1][bz][rr]/mu0);
jDotBR = (covariantZetaSlopeR covariantTheta -
  covariantThetaSlopeR covariantZeta)/sqgR;
term1R = (jDotBR^2 + pressureSlopeR^2 gradS2R)/
  ((btheta[r]^2 + bz[r]^2) gradS2R);
term2R = (fluxTcurveR covariantZetaSlopeR +
  fluxPcurveR covariantThetaSlopeR)/sqgR;
jacTermR = pressureSlopeR ddr[sqgR]/sqgR;
geometricR = 2 btheta[r] (D[s btheta[s], s] /. s -> r)/r^2;

check["the r-label identity pins both sign groups",
  FullSimplify[term1R - term2R - jacTermR - geometricR,
    assumptions] == 0];
check["no other sign combination closes the r-label identity",
  ! TrueQ[FullSimplify[term1R + term2R - jacTermR - geometricR,
      assumptions] == 0] &&
  ! TrueQ[FullSimplify[term1R - term2R + jacTermR - geometricR,
      assumptions] == 0] &&
  ! TrueQ[FullSimplify[term1R + term2R + jacTermR - geometricR,
      assumptions] == 0]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

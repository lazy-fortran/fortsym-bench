ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, rzero > 0, mu0 > 0, bz[r] > 0,
  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],
    Derivative[2][btheta][r], Derivative[2][bz][r],
    Derivative[1][p][r]}, Reals],
  btheta[r]^2 + bz[r]^2 > 0};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Screw pinch of length 2 Pi rzero with radian angles theta, zeta:
   surface quantities are constant on r = const, so the Mercier surface
   integrals of Landreman & Jorge (2020), eqs. 4.16-4.20 as implemented
   in DESC desc/compute/_stability.py, reduce to (2 Pi)^2 factors. *)
forceBalance = Derivative[1][p][rr_] :>
  -(btheta[rr] D[s btheta[s], s] /. s -> rr)/(mu0 rr) -
    bz[rr] Derivative[1][bz][rr]/mu0;

psiR[r_] := r bz[r];
iota[r_] := rzero btheta[r]/(r bz[r]);
iotaPsi[r_] := iota'[r]/psiR[r];
surfaceJacobian = r rzero;
gradPsi = r bz[r];
bSquared = btheta[r]^2 + bz[r]^2;
surfaceIntegral[f_] := (2 Pi)^2 f;

muJdotB = -bz'[r] btheta[r] + (D[s btheta[s], s] /. s -> r) bz[r]/r;
currentI[r_] := r btheta[r];
xiDotB = muJdotB - (currentI'[r]/psiR[r]) bSquared;

dShear = iotaPsi[r]^2/(16 Pi^2);
dCurrent = -(1/(2 Pi)^4) iotaPsi[r] surfaceIntegral[
  surfaceJacobian/gradPsi^3 xiDotB];
dpdPsi = mu0 Derivative[1][p][r]/psiR[r];
volume[r_] := 2 Pi^2 rzero r^2;
d2VdPsi2 = (volume''[r] psiR[r] - volume'[r] psiR'[r])/psiR[r]^3;
dWell = dpdPsi (d2VdPsi2 -
    dpdPsi surfaceIntegral[surfaceJacobian/(bSquared gradPsi)]) *
  surfaceIntegral[surfaceJacobian bSquared/gradPsi^3]/(2 Pi)^6;
dGeodesic = (surfaceIntegral[surfaceJacobian muJdotB/gradPsi^3]^2 -
    surfaceIntegral[surfaceJacobian bSquared/gradPsi^3] *
      surfaceIntegral[surfaceJacobian muJdotB^2/(bSquared gradPsi^3)])/
  (2 Pi)^6;
dMercier = dShear + dCurrent + dWell + dGeodesic;

check["geodesic term vanishes for the screw pinch",
  dGeodesic == 0];

safety[r_] := r bz[r]/(rzero btheta[r]);
shearRatio = safety'[r]/safety[r];
check["iota shear equals negative safety-factor shear",
  iota'[r]/iota[r] == -shearRatio];

suydamRatio = 1 + 8 mu0 Derivative[1][p][r]/(r bz[r]^2 shearRatio^2);
check["shear term is non-negative", dShear >= 0];
check["Mercier equals shear term times the Suydam ratio",
  FullSimplify[(dMercier /. forceBalance) -
      dShear (suydamRatio /. forceBalance), assumptions] == 0];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

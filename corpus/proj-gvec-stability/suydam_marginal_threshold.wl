ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[
  TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Physics reference for the discrete marginal-stability validation.
   Family: the cylinder fixture with B_theta fixed and the pressure
   gradient scaled by kappa, the difference absorbed by the axial
   field, so force balance holds exactly for every kappa:
     B_theta = 3/10 r + 2/5 r^3,  mu0 p' = -kappa I'(r),
     Bz(r)^2 = 1 + 2 (1 - kappa) (I(a) - I(r)),
     I(r) = b1^2 r^2 + (3/2) b1 b3 r^4 + (2/3) b3^2 r^6.
   At kappa = 1 this is the shipped fixture (Suydam-unstable at the
   iota = 1 surface); at kappa -> 0 the pressure gradient vanishes and
   Suydam is satisfied.  The gate pins the marginal kappa* where the
   Suydam function changes sign at the mode-resonant surface iota = 1;
   the GLISS acceptance bisects the assembled operator's stability
   boundary and must approach kappa* from below as the poloidal mode
   number grows (finite m is more stable than the localized limit). *)

b1 = 3/10; b3 = 2/5; a = 1/2; len = 6 Pi;
btheta[r_] := b1 r + b3 r^3;
bigI[r_] := b1^2 r^2 + 3/2 b1 b3 r^4 + 2/3 b3^2 r^6;
bzSq[r_, kappa_] := 1 + 2 (1 - kappa) (bigI[a] - bigI[r]);
iota[r_, kappa_] := len btheta[r]/(2 Pi r Sqrt[bzSq[r, kappa]]);
integralSlope[r_] := D[bigI[rr], rr] /. rr -> r;

check["force balance holds across the family",
  Simplify[D[-kappa bigI[rr]/mu0 + bzSq[rr, kappa]/(2 mu0), rr] mu0 +
    btheta[rr] D[rr btheta[rr], rr]/rr] === 0];

mu[r_, kappa_] := btheta[r]/(r Sqrt[bzSq[r, kappa]]);
suydamValue[r_?NumericQ, kappa_?NumericQ] :=
  r bzSq[r, kappa] ((D[mu[rr, kappa], rr] /. rr -> r)/
    mu[r, kappa])^2/8 - kappa integralSlope[r];

resonantRadius[kappa_?NumericQ] := r /. FindRoot[
  iota[r, kappa] == 1, {r, a Sqrt[1/3], a/100, a},
  WorkingPrecision -> 40];

check["kappa = 1 is the shipped fixture and Suydam unstable",
  bzSq[r, 1] === 1 &&
    suydamValue[resonantRadius[1], 1] < 0];
check["the pressure-free end of the family is Suydam stable",
  suydamValue[resonantRadius[1/10], 1/10] > 0];

marginal[kappa_?NumericQ] := suydamValue[resonantRadius[kappa], kappa];
kappaStar = kappa /. FindRoot[marginal[kappa] == 0,
  {kappa, 7/10, 1/10, 1}, WorkingPrecision -> 40];
signs = Split[Table[Sign[marginal[k]], {k, 1/10, 1, 1/100}]];
check["a single marginal crossing sits inside the bracket",
  1/10 < kappaStar < 1 && Length[signs] == 2];
check["stable below and unstable above kappa*",
  marginal[kappaStar - 1/20] > 0 && marginal[kappaStar + 1/20] < 0];
check["the resonant surface stays interior across the family",
  With[{lo = resonantRadius[1/10], hi = resonantRadius[1]},
    a/10 < lo < a && a/10 < hi < a]];
check["pinned reference constant brackets the root",
  marginal[31454704/10^8] > 0 && marginal[31454705/10^8] < 0];

Print["kappaStar = ", N[kappaStar, 20]];
Print["s at resonance(kappaStar) = ",
  N[(resonantRadius[kappaStar]/a)^2, 20]];
Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

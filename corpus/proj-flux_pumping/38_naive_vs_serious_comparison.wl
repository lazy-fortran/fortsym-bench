(* Verification of subsection IIC of the 2026-07-17 evening memo revision
   (memo_HC_and_RMP_ext.tex, sha256 b9e93435..., received 2026-07-17
   20:27 UTC): the comparison of the naive model (ssec:naive) with the
   semi-local response extracted from the field-line-integration model
   (ssec:moreserious), which Sergei finds to be the same expression with
   opposite sign, delta iota_loc = -delta iota_naive, asking where the
   sign has been lost.

   Result of this script: NO sign is lost.  Every printed step of both
   chains verifies (checks 1-15).  The two calculations use different
   currents: the single-harmonic input (curincyl)+(harmdep) of the serious
   model has zero phi-average at fixed r, while the corrugated-surface
   pattern (curdenform_corrugated) of the naive model carries the O(Delta)
   fixed-r average current (avertorcurden), which is the entire source of
   delta iota_naive.  Feeding the full corrugated pattern through the
   rigorous machinery - mean part via Ampere/Stokes as a shift of iota_0,
   helical part via the semi-local response of (deliota_smallamp) - the
   two contributions cancel at leading order; the survivor is smaller by
   r^2 iota_0 iota_m / R0^2 (checks 16-18).

   Cylinder metric diag(1, r^2, R0^2), phase exp(i(m th + n ph)),
   phi = m th + n ph, iota_m = -n/m, s0 = r^2/2, CGS.  (solbes),
   (amplbtheta), (amplbr), (wrbes), (brsol) are verified in script 34 and
   reused here in the same abstract form. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* ==== Part A: the naive model, (surflab) ... (deltaiota_naive) ==== *)

ClearAll[jm, rr, rho, dd, al, phi, capR, cl, bb];
(* (surflab): rho = r + Delta cos(phi+alpha); on the surface rho=const the
   cylinder radius is r = rho - Delta cos(phi+alpha).  The corrugated
   current pattern (curdenform_corrugated) expressed at fixed cylinder
   radius r uses rho(r,phi) = r + Delta cos(phi+alpha). *)
naiveCurrent = ((rr + dd Cos[phi + al])/rr) jm[rr + dd Cos[phi + al]] *
   Cos[phi];
naiveLinear = Normal@Series[naiveCurrent, {dd, 0, 1}] // TrigReduce;
printedTorcurden = jm[rr] Cos[phi] +
  (Cos[al] + Cos[2 phi + al]) (dd/(2 rr)) D[rr jm[rr], rr] // TrigReduce;
check["IIC (torcurden): O(Delta) expansion of the corrugated pattern",
  Simplify[naiveLinear == printedTorcurden]];

meanCurrent = Integrate[naiveLinear, {phi, 0, 2 Pi}]/(2 Pi);
printedAvertorcurden = (dd Cos[al]/(2 rr)) D[rr jm[rr], rr];
check["IIC (avertorcurden): fixed-r average of the corrugated pattern",
  Simplify[meanCurrent == printedAvertorcurden]];

(* (torcur): delta I_tor(r) = 2 pi R0 Int_0^r r' mean(r') dr'
   = pi R0 Delta cos(al) r jm(r), checked as a derivative identity with
   the regular-axis boundary value r jm -> 0. *)
printedTorcur = Pi capR dd Cos[al] rr jm[rr];
check["IIC (torcur): helical mean current inside radius r",
  Simplify[D[printedTorcur, rr] ==
    2 Pi capR rr printedAvertorcurden]];

(* (Btcontr)+(rotransas): delta iota = 2 R0 delta I /(c r^2 B). *)
printedDeltaiota = 2 Pi capR^2 dd Cos[al] jm[rr]/(cl rr bb);
check["IIC (deltaiota): naive rotational-transform correction",
  Simplify[2 capR printedTorcur/(cl rr^2 bb) == printedDeltaiota]];

(* (deltas_linorder): s - s0 with s = r^2/2, s0 = rho^2/2,
   r = rho - Delta cos(phi+alpha). *)
deltasExact = (rho - dd Cos[phi + al])^2/2 - rho^2/2;
deltasLinear = Normal@Series[deltasExact, {dd, 0, 1}];
printedDeltas = -rho dd Cos[phi + al];
check["IIC (deltas_linorder): linear surface-label shift",
  Simplify[deltasLinear == printedDeltas]];

(* (delsjpmav): phi-average of delta s * delta j^phi with the linearized
   current delta j^phi = jm(r) cos(phi), evaluated at rho = r. *)
avgDelsJ = Integrate[printedDeltas (jm[rho] Cos[phi]),
    {phi, 0, 2 Pi}]/(2 Pi);
printedDelsjpmav = -(1/2) rho jm[rho] dd Cos[al];
check["IIC (delsjpmav): corrugation-current correlation",
  Simplify[avgDelsJ == printedDelsjpmav]];

(* (deltaiota_naive): with s0 = rho^2/2 and rho = r the naive result is
   delta iota_naive = -(2 pi R0^2/(c s0 B)) <delta s delta j^phi>. *)
check["IIC (deltaiota_naive): naive result in correlation form",
  Simplify[(-2 Pi capR^2/(cl (rho^2/2) bb)) printedDelsjpmav ==
    (printedDeltaiota /. rr -> rho)]];

(* ==== Part B: the semi-local extraction, (locresp) ... final sign ==== *)

ClearAll[dio0, bphi0, ds, dbth, dbph, io0, iom, s0v, mm, nn];
(* (locresp) first form: term 2 of (deliota_smallamp) with (deltas),
   Int_0^s0 (dB^th - iota_m dB^ph) ds = -Diota0 B0^phi delta s,
   is a pointwise identity under the phi-average. *)
term2Integrand = -(dio0/bphi0) (-dio0 bphi0 ds) dX;
check["IIC (locresp): (deltas) turns term 2 into Diota0^2 <ds d/ds0(...)>",
  Simplify[term2Integrand == dio0^2 ds dX]];

(* (locresp) second form: keeping only the dB derivatives (the dropped
   derivatives of 1/(Diota0^2 B0^phi) and of iota_0 carry no local j_m
   content) and using d/ds0 = (1/r) d/dr. *)
ClearAll[dbthF, dbphF];
keptDerivative = dio0^2 ds (1/(dio0^2 bphi0)) (1/rr) *
  (dbthF'[rr] - io0 dbphF'[rr]);
printedLocresp = (1/(rr bphi0)) ds (dbthF'[rr] - io0 dbphF'[rr]);
check["IIC (locresp): chain rule s0=r^2/2 gives the printed second form",
  Simplify[keptDerivative == printedLocresp]];

(* (locresp_cont) step 1: insert (amplbtheta) B^th_m = (m R0^2/(n r^2))
   B^ph_m and keep the B^ph_m-derivative terms; with iota_m = -n/m the
   kept coefficient is the printed one. *)
ClearAll[bphm];
fullDerivative = D[(mm capR^2/(nn rr^2)) bphm[rr], rr] - io0 bphm'[rr];
keptPart = fullDerivative - ((-2 mm capR^2/(nn rr^3)) bphm[rr]);
printedStep1 = -(capR^2/(iom rr^2)) (1 + rr^2 io0 iom/capR^2) bphm'[rr];
check["IIC (locresp_cont 1): kept dB^phi/dr coefficient with iota_m=-n/m",
  Simplify[(keptPart /. iom -> -nn/mm) ==
      (printedStep1 /. iom -> -nn/mm), nn != 0 && mm != 0]];

(* (locresp_cont 2): prefactor bookkeeping after inserting (solbes)
   B^ph_m = (4 pi n k_z/(c m R0)) (Bessel moments); s0 = r^2/2. *)
ClearAll[kz];
check["IIC (locresp_cont 2): prefactor -(R0^2/(iota_m r^3)) 4 pi n k_z/(c m R0) = 2 pi R0 k_z/(r c s0)",
  Simplify[(-(capR^2/((-nn/mm) rr^3)) (4 Pi nn kz/(cl mm capR))) ==
      (2 Pi capR kz/(rr cl (rr^2/2))), nn != 0 && mm != 0 && rr > 0]];

(* (locresp_cont 3): the derivative of the Bessel moments keeps, besides
   the nonlocal ireg'/kdec' terms, the boundary (local) term
   -r^2 j (I K' - K I') from the integral limits; script-34 moment rules. *)
ClearAll[ireg, kdec, lowerI, upperK, current, kappa];
momentDerivativeRules = {
  lowerI'[r_] :> r^2 ireg'[r] current[r]/kappa,
  upperK'[r_] :> -r^2 kdec'[r] current[r]/kappa};
moments = ireg[rr] upperK[rr] + kdec[rr] lowerI[rr];
localPart = (D[moments, rr] /. momentDerivativeRules) -
  (ireg'[rr] upperK[rr] + kdec'[rr] lowerI[rr]);
(* memo primes are argument derivatives: kdec'[r] = kappa K'(kappa r), so
   (I K' - K I')(kappa r) = (ireg kdec' - kdec ireg')/kappa. *)
printedLocal = -rr^2 current[rr] *
  (ireg[rr] kdec'[rr] - kdec[rr] ireg'[rr])/kappa;
check["IIC (locresp_cont 3): limit terms give -r^2 j (I K' - K I')",
  Simplify[localPart == printedLocal]];

(* (locresp_cont 4): Wronskian (wrbes) I K' - K I' = -1/x at x = k_z r,
   imposed by solving it for kdec'[rr], collapses the prefactor to
   +2 pi R0/(c s0 B0^phi). *)
step34 = (2 Pi capR kz/(rr cl (rr^2/2) bphi0)) *
  ((printedLocal /. kappa -> kz) /. Derivative[1][kdec][rr] ->
    (kdec[rr] Derivative[1][ireg][rr] - 1/rr)/ireg[rr]);
check["IIC (locresp_cont 4): final semi-local coefficient +2 pi R0/(c s0 B0^phi) j",
  Simplify[step34 == (2 Pi capR/(cl (rr^2/2) bphi0)) current[rr],
    ireg[rr] != 0 && kz != 0 && rr > 0]];

(* Final printed statement: with <ds cos(phi)> j_m = <ds dj^phi>,
   B0^phi = B/R0 and dropping r^2 iota_0 iota_m/R0^2 << 1,
   delta iota_loc = -delta iota_naive as printed. *)
ClearAll[avgsj];
diotaLoc = (2 Pi capR/(cl s0v (bb/capR))) avgsj;
diotaNaive = -(2 Pi capR^2/(cl s0v bb)) avgsj;
check["IIC final: delta iota_loc = -delta iota_naive as printed",
  Simplify[diotaLoc == -diotaNaive]];

(* ==== Part C: resolution - no sign is lost, the inputs differ ==== *)

(* The serious model's input (curincyl)+(harmdep),
   delta j^phi = j_m(r) cos(phi), has zero fixed-r average; the naive
   corrugated pattern has the O(Delta) average (avertorcurden). *)
check["IIC resolution: single-harmonic input carries no fixed-r mean current",
  Simplify[Integrate[jm[rr] Cos[phi], {phi, 0, 2 Pi}]/(2 Pi) == 0]];
check["IIC resolution: corrugated pattern minus single harmonic = mean + 2nd harmonic",
  Simplify[TrigReduce[naiveLinear - jm[rr] Cos[phi] -
      printedAvertorcurden -
      (dd/(2 rr)) Cos[2 phi + al] D[rr jm[rr], rr]] == 0]];

(* Superposing at quadratic order: the mean current shifts iota_0 by the
   Stokes result +delta iota_naive; the pure harmonic adds the geometric
   semi-local response delta iota_loc.  With the exact factor
   (1 + r^2 iota_0 iota_m/R0^2) and B = R0 B0^phi the sum cancels at
   leading order, leaving the small geometric residual. *)
diotaLocExact = (2 Pi capR/(cl s0v bphi0)) *
  (1 + rr^2 io0 iom/capR^2) avgsj;
diotaNaiveExact = -(2 Pi capR^2/(cl s0v (capR bphi0))) avgsj;
residual = Simplify[diotaLocExact + diotaNaiveExact];
check["IIC resolution: mean-current Stokes response cancels the geometric response at leading order",
  Simplify[residual ==
    (2 Pi capR/(cl s0v bphi0)) (rr^2 io0 iom/capR^2) avgsj]];
check["IIC resolution: the survivor is down by r^2 iota_0 iota_m/R0^2",
  Simplify[residual/diotaLocExact ==
      (rr^2 io0 iom/capR^2)/(1 + rr^2 io0 iom/capR^2),
    1 + rr^2 io0 iom/capR^2 != 0 && avgsj != 0 &&
      cl s0v bphi0 != 0 && capR != 0]];

(* ==== numeric spot-check of the decisive local term ==== *)

(* m=-1, n=1 (FP), R0=10, k_z=1/10, Gaussian j_m: the numeric derivative
   of the Bessel moments minus the nonlocal terms reproduces
   -r^2 j (I K' - K I') = +r j/k_z to 1e-6, fixing the sign of the local
   term with concrete Bessel functions rather than formal rules. *)
Module[{kzv = 1/10, jf, up, lo, mom, dmom, nonloc, locNum, locRef, r0 = 11/10},
  jf[r_?NumericQ] := Exp[-((r - 1)/(3/10))^2];
  up[r_?NumericQ] := NIntegrate[
    Derivative[0, 1][BesselK][1, kzv rp] rp^2 jf[rp], {rp, r, 8},
    AccuracyGoal -> 12, PrecisionGoal -> 12];
  lo[r_?NumericQ] := NIntegrate[
    Derivative[0, 1][BesselI][1, kzv rp] rp^2 jf[rp], {rp, 0, r},
    AccuracyGoal -> 12, PrecisionGoal -> 12];
  mom[r_?NumericQ] := BesselI[1, kzv r] up[r] + BesselK[1, kzv r] lo[r];
  dmom = (mom[r0 + 1/1000] - mom[r0 - 1/1000])/(2/1000);
  nonloc = kzv (Derivative[0, 1][BesselI][1, kzv r0] up[r0] +
      Derivative[0, 1][BesselK][1, kzv r0] lo[r0]);
  locNum = dmom - nonloc;
  locRef = r0 jf[r0]/kzv;
  (* central difference with h=1e-3 carries an O(h^2) truncation error of
     a few 1e-6 relative; 1e-4 still pins sign and magnitude. *)
  check["IIC numeric: local moment derivative equals +r j/k_z (sign check)",
    Abs[locNum - locRef] < 10^-4 Abs[locRef]]];

reportAndExit[];

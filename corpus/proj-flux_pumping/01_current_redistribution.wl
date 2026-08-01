(* Memo Sec. 2: redistribution of toroidal current by a helical current on
   corrugated flux surfaces. Straight cylinder, coordinates (r, th, ph),
   Jacobian sqrt(g) = r (constant factor R0 dropped). Perturbed flux label
   rho = r + Del Cos[m th + n ph + al], Del, al const, |Del| << r.
   Verifies memo Eqs. (curdenform_corrugated), (torcurden), (avertorcurden),
   (torcur). *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

phase = m th + n ph;
rho[r_, th_, ph_] := r + Del Cos[m th + n ph + al];

(* Current on corrugated surfaces, memo (curdenform_corrugated):
   in coordinates (rho, th, ph) the components are
   jph = (rho/r) jm(rho) Cos[phase], jth = -(n/m) jph, jrho = 0,
   where r = r(rho,th,ph) inverts the label relation. The Jacobian of
   (rho,th,ph) is sqrtg = r(rho,th,ph) * dr/drho = r(rho,th,ph). *)

(* --- Check 1: exact divergence-freeness in (rho, th, ph). ---
   div j = (1/sqrtg) [ d_th (sqrtg jth) + d_ph (sqrtg jph) ]  (jrho = 0).
   sqrtg jph = rho jm(rho) Cos[phase] depends on angles only through Cos[phase],
   so the check is exact, not only to linear order in Del. *)
sqrtgJph = rhovar jm[rhovar] Cos[phase];      (* rhovar = independent coord *)
sqrtgJth = -(n/m) sqrtgJph;
divJ = D[sqrtgJth, th] + D[sqrtgJph, ph];
check["Sec2: helical current divergence-free on corrugated surfaces (exact)",
  divJ == 0];

(* --- Check 2: transform j^ph to cylindrical coordinates, linear in Del. ---
   j^ph is a scalar coordinate component shared by both charts (same th, ph);
   express it at fixed (r, th, ph) by substituting rho = rho(r,th,ph):
   j^ph(r,th,ph) = (rho/r) jm(rho) Cos[phase]. Expand to O(Del). *)
jphOld = (rho[r, th, ph]/r) jm[rho[r, th, ph]] Cos[phase];
jphLin = Normal[Series[jphOld, {Del, 0, 1}]];

(* Memo (torcurden): jm(r) Cos[phase]
   + (Cos[al] + Cos[2 phase + al]) (Del/(2 r)) d_r (r jm(r)) *)
jphMemo = jm[r] Cos[phase] +
  (Cos[al] + Cos[2 phase + al]) (Del/(2 r)) D[r jm[r], r];
check["Sec2 (torcurden): O(Del) toroidal current density matches memo",
  TrigExpand[jphLin - jphMemo] == 0];

(* --- Check 3: nonzero phase average, memo (avertorcurden). --- *)
avg = Integrate[jphLin /. {th -> s/m, ph -> 0}, {s, 0, 2 Pi},
    Assumptions -> m != 0]/(2 Pi);
avgMemo = (Del Cos[al]/(2 r)) D[r jm[r], r];
check["Sec2 (avertorcurden): phase-averaged current density",
  avg == avgMemo];

(* --- Check 4: zero net toroidal current, memo (torcur). ---
   2 Pi Integral r avg dr = Pi Del Cos[al] [r jm(r)] evaluated at borders;
   vanishes when r jm(r) -> 0 at r = 0 and r -> Infinity. *)
integrand = 2 Pi r avgMemo;
antideriv = Pi Del Cos[al] r jm[r];
check["Sec2 (torcur): integrand is a total derivative Pi Del Cos[al] d_r(r jm)",
  Simplify[D[antideriv, r] - integrand] == 0];

reportAndExit[];

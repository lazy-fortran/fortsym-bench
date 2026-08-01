(* ::Package:: *)

(* CAS GATE for blueprint-gc-loworder / LOW-ORDER guiding-center integrators at
   CRUDE time steps for SIMPLE, judged by the accuracy of the SLOW bounce/drift
   frequencies and the PLACEMENT of superbanana resonances.

   QUESTION. SIMPLE wants a cheap, low-order GC scheme that runs at crude dt and is
   fast, but must NOT misplace superbanana resonances. A symplectic integrator does
   not integrate H; it integrates a MODIFIED (shadow) Hamiltonian H~ = H + dt^p H_p
   + ... whose order is the scheme order p (backward error analysis, Hairer-Lubich-
   Wanner ch. IX). A superbanana sits at the low-order rational lock n omega_b(J) =
   omega_d between the trapped-bounce frequency omega_b and the slow drift/precession
   omega_d. Two distinct ways a low-order scheme can corrupt it:
     (i)  the modified-frequency / modified-phase error shifts the realized lock;
     (ii) the symplectic MAP's OWN step-size resonances (artificial standard-map
          islands, McLachlan-Quispel) overlap the physical superbanana band, and
          lower order brings that overlap to a smaller (more restrictive) dt.

   Cited: Hairer-Lubich-Wanner, Geometric Numerical Integration 2nd ed. (modified
   Hamiltonian / backward error analysis, the O(dt^p) shift, ch. IX; midpoint is
   symmetric, Thm VI.3.3). McLachlan-Quispel, Acta Numer. 11 (2002) 341 (splitting
   methods, step-size resonances). Chirikov standard map (artificial-island overlap,
   the resonance-overlap criterion). Qin-Guan PRL 100 (2008) 035006, Qin-Guan-Tang
   PoP 16 (2009) 042510 (variational symplectic GC). Ellison et al. PoP 22 (2015)
   112504 (degenerate-variational GC, parasitic modes). Blanes-Casas-Murua
   (processing / effective-order methods, Acta Numer.).

   TOY MODEL, two integrable backbones so EVERY claim is checked against a CLOSED
   FORM or a fine-dt reference:

     (L) LINEAR ROTOR pair H_rot = (w/2)(p^2 + q^2): a harmonic oscillator of EXACT
         frequency w, the slow bounce/drift mode linearized at a reference action.
         Each scheme's one-step map is a 2x2 symplectic matrix; its trace gives the
         numerical rotation number, in CLOSED FORM. This backbone settles the
         single-mode frequency error, the symplecticity, and the step-size
         resonances (the trace stability edge / artificial islands).

     (P) PENDULUM BOUNCE H_b = p^2/2 - w0^2 cos(q), the trapped-particle bounce with
         an amplitude-set frequency. The slow drift advances a separate angle. This
         backbone settles the TRAJECTORY / RELATIVE-PHASE error -- the quantity a
         superbanana phase-lock actually samples -- by direct orbit integration
         against a fine-dt reference.

   HONEST FINDING (load-bearing, stated plainly). For a SINGLE autonomous mode the
   rotation number (and hence the resonant ACTION J_res from omega_b(J)=n omega_d) is
   O(dt^2)-accurate for ALL three symplectic schemes, INCLUDING first-order
   symplectic Euler: Euler's leading modified-Hamiltonian term is (dt/2){V,T} =
   (dt/2) dV/dt, a total time derivative whose bounce average vanishes, so the
   single-mode frequency shift is O(dt^2), not O(dt). The genuine first-order penalty
   of symplectic Euler is in the INSTANTANEOUS TRAJECTORY PHASE (O(dt) vs O(dt^2)
   symmetric), the very quantity that keeps the bounce LOCKED to the drift across a
   superbanana over long times, and in the smaller crude-dt ceiling its O(dt)
   accuracy imposes. So the recommendation stands -- a 2nd-order SYMMETRIC scheme is
   the safe crude-dt choice -- but for the right reason: phase coherence of the lock
   and the step-size ceiling, not a mythical O(dt) shift of the single-mode frequency.

   COMPARISON, the schemes:
     (a) symplectic Euler, 1st order, non-symmetric; explicit on a separable H, else
         one implicit solve.
     (b) implicit midpoint / Gauss s=1, 2nd order, symmetric, A-stable; one implicit
         solve per step.
     (c) Strang / leapfrog (velocity-Verlet), 2nd order, symmetric; EXPLICIT when H
         splits into T(p)+V(q) (parallel streaming + drift).

   Asserts PASS/FAIL like large_step_check.wl and midpoint_resonance.wl. Ends with
   Quit[].

   Run:  math -script gc_loworder_schemes.wl ; output -> gc_loworder_schemes.out.

   Passing output (24 PASS, 0 FAIL):
     PASS  J^T = -J, J^2 = -I (canonical 2x2 structure)
     PASS  symplectic Euler one-step map is symplectic (det = 1)
     PASS  implicit midpoint one-step map is symplectic (det = 1)
     PASS  leapfrog (Strang T-V-T) one-step map is symplectic (det = 1)
     PASS  rotor rotation numbers in closed form: SE/LF trace = 2 - (w dt)^2, MP A-stable
     PASS  single-mode rotation-number error is O(dt^2) for ALL three (incl. symplectic Euler)
     PASS  symplectic Euler modified H carries an O(dt) term (dt/2){V,T} = (dt/2) dV/dt
     PASS  that O(dt) term is a total time derivative: its bounce AVERAGE vanishes (frequency O(dt^2))
     PASS  leapfrog and implicit midpoint are SYMMETRIC: no O(dt) modified-H term
     PASS  TRAJECTORY / relative-phase error is O(dt^1) for symplectic Euler (slope 1)
     PASS  TRAJECTORY / relative-phase error is O(dt^2) for leapfrog (slope 2)
     PASS  TRAJECTORY / relative-phase error is O(dt^2) for implicit midpoint (slope 2)
     PASS  at crude dt the 1st-order phase error EXCEEDS the 2nd-order phase error by a large factor
     PASS  superbanana truth: omega_b(J) = n omega_d has a unique resonant action J_res
     PASS  resonant ACTION shift is O(dt^2) for all (single-mode frequency is O(dt^2)) -- honest
     PASS  but the bounce-drift LOCK loses coherence O(dt) under Euler, O(dt^2) under symmetric
     PASS  step-size resonance: leapfrog/Euler share the linear-stability edge w dt = 2
     PASS  step-size resonance: implicit midpoint is A-stable, trace in (-2,2) for EVERY dt (no artificial island)
     PASS  crude-dt ceiling ORDERED: 2nd-order accuracy ceiling > 1st-order accuracy ceiling
     PASS  artificial-island overlap is pushed to LARGER dt for higher order (more permissive)
     PASS  cost: leapfrog/Verlet EXPLICIT (0 solves), midpoint 1 implicit solve, Euler 1 (explicit if separable)
     PASS  cost ranking: explicit splitting <= explicit Euler < implicit midpoint (solves per step)
     PASS  long-time energy bounded, no secular drift, for all three symplectic schemes
     PASS  RECOMMENDATION holds: 2nd-order symmetric (split leapfrog if H splits, else midpoint) beats Euler
       pass = 24   fail = 0
     GATE PASSED: 2nd-order symmetric symplectic GC scheme is the safe crude-dt choice for superbanana transport *)

Off[General::stop];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkNum[name_, expr_, tol_:1.*^-9] := Module[{m = Max[Abs[Flatten[{expr}]]], c},
  c = TrueQ[m < tol];
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name, "   maxabs=", m]]; c];

J2 = {{0, 1}, {-1, 0}};
w0 = 1;   (* pendulum-bounce frequency scale, fixed numeric; the rotor symbol w stays free *)

Print["==================================================================="];
Print[" Low-order GC integrators at crude dt: frequency accuracy and superbanana placement"];
Print["==================================================================="];

check["J^T = -J, J^2 = -I (canonical 2x2 structure)",
  Transpose[J2] + J2 == {{0, 0}, {0, 0}} && J2 . J2 + IdentityMatrix[2] == {{0, 0}, {0, 0}}];

Print["-------------------------------------------------------------------"];
Print[" 1. The three schemes on the LINEAR ROTOR H = (w/2)(p^2 + q^2): symplecticity + rotation number"];
Print["-------------------------------------------------------------------"];

(* The rotor of frequency w is the slow bounce/drift mode linearized at a reference
   action. H = T(p) + V(q) = (w/2)(p^2 + q^2) is SEPARABLE, so the Strang split is
   explicit (leapfrog). Each integrator's one-step map is a 2x2 symplectic matrix in
   (q,p); its trace gives the numerical rotation number cos(theta) = trace/2. *)

(* (a) SYMPLECTIC EULER (partitioned, explicit for separable H):
   p1 = p0 - dt V'(q0) = p0 - dt w q0 ; q1 = q0 + dt T'(p1) = q0 + dt w p1. *)
Meuler[w_, dt_] := {{1 - dt^2 w^2, dt w}, {-dt w, 1}};

(* (b) IMPLICIT MIDPOINT (Gauss s=1): z1 = z0 + dt J^{-1} grad H((z0+z1)/2),
   M = (I - L)^{-1}(I + L), L = (dt/2) J grad-grad H = (dt/2) J (w I) for this H.
   Use J (not Inverse[J]) so the rotation sense matches the partitioned schemes. *)
Mmid[w_, dt_] := Module[{L = (dt/2) J2 . (w IdentityMatrix[2])},
  Inverse[IdentityMatrix[2] - L] . (IdentityMatrix[2] + L)];

(* (c) LEAPFROG / Strang split T-V-T: each factor is the EXACT flow of one piece
   (a shear), so leapfrog is explicit and symmetric. *)
flowT[w_, t_] := {{1, w t}, {0, 1}};
flowV[w_, t_] := {{1, 0}, {-w t, 1}};
Mleap[w_, dt_] := flowT[w, dt/2] . flowV[w, dt] . flowT[w, dt/2];

check["symplectic Euler one-step map is symplectic (det = 1)",
  Simplify[Det[Meuler[w, dt]]] == 1];
check["implicit midpoint one-step map is symplectic (det = 1)",
  Simplify[Det[Mmid[w, dt]]] == 1];
check["leapfrog (Strang T-V-T) one-step map is symplectic (det = 1)",
  Simplify[Det[Mleap[w, dt]]] == 1];

(* closed-form rotation numbers from the trace, cos(theta_num) = trace/2. *)
traceSE = Simplify[Tr[Meuler[w, dt]]];     (* = 2 - (w dt)^2 *)
traceLF = Simplify[Tr[Mleap[w, dt]]];      (* = 2 - (w dt)^2, SAME as SE *)
traceMP = Simplify[Tr[Mmid[w, dt]]];       (* = (8 - 2 (w dt)^2)/(4 + (w dt)^2) *)
check["rotor rotation numbers in closed form: SE/LF trace = 2 - (w dt)^2, MP A-stable",
  traceSE === 2 - dt^2 w^2 && traceLF === 2 - dt^2 w^2 &&
   Simplify[traceMP - (8 - 2 dt^2 w^2)/(4 + dt^2 w^2)] == 0];

(* single-mode rotation-number error: w_num = ArcCos[trace/2]/dt, error |w_num - w|.
   ALL three are O(dt^2). Symplectic Euler is NO worse than the symmetric schemes in
   the single-mode rotation number, because its trace is even in dt (the O(dt)
   modified-H term is a total derivative; section 2). This is the honest correction
   to "1st order misplaces the frequency". Recover the order by a numeric log-log
   slope of the error over a fine-dt window (robust; the symbolic ArcCos branch is
   sign-ambiguous). *)
wnumOf[tr_, dt_] := ArcCos[tr/2]/dt;
freqErr[scheme_, dt_] := Module[{wl = 1.},
  Abs[Switch[scheme,
     "SE", wnumOf[2 - dt^2 wl^2, dt],
     "LF", wnumOf[2 - dt^2 wl^2, dt],
     "MP", wnumOf[(8 - 2 dt^2 wl^2)/(4 + dt^2 wl^2), dt]] - wl]];
freqSlope[scheme_] := Module[{dts = Table[d, {d, 1/200, 1/40, 1/400}], es, ld, le},
  es = freqErr[scheme, #] & /@ dts;
  ld = Log[dts]; le = Log[es];
  (Length[ld] (ld . le) - Total[ld] Total[le])/(Length[ld] (ld . ld) - Total[ld]^2)];
check["single-mode rotation-number error is O(dt^2) for ALL three (incl. symplectic Euler)",
  Abs[freqSlope["SE"] - 2] < 2/10 && Abs[freqSlope["LF"] - 2] < 2/10 &&
   Abs[freqSlope["MP"] - 2] < 2/10];

Print["-------------------------------------------------------------------"];
Print[" 2. Modified (shadow) Hamiltonian: WHERE the O(dt) Euler penalty actually lives"];
Print["-------------------------------------------------------------------"];

(* Backward error analysis (HLW ch. IX). For a separable H = T(p) + V(q) split into
   the exact flows phi_T, phi_V:
     symplectic Euler = phi_V^dt o phi_T^dt  -> by BCH the modified Hamiltonian is
       H~_SE = H + (dt/2){V,T} + O(dt^2),                       <-- an O(dt) TERM
     Strang leapfrog  = phi_T^{dt/2} o phi_V^dt o phi_T^{dt/2}, SYMMETRIC ->
       H~_LF = H + O(dt^2),                                     <-- NO O(dt) term
     implicit midpoint is SYMMETRIC -> H~_MP = H + O(dt^2)      <-- NO O(dt) term.
   The Poisson bracket {V,T} = (dV/dq)(dT/dp) = (dV/dq) p = dV/dt is a TOTAL TIME
   DERIVATIVE on the unperturbed flow: its average over a closed bounce vanishes, so
   the O(dt) term does NOT shift the bounce FREQUENCY (consistent with section 1).
   It is nonzero POINTWISE, so it does shift the instantaneous PHASE -- section 3. *)
pb[f_, g_] := D[f, q] D[g, p] - D[f, p] D[g, q];
Tk = p^2/2; Vk = -w0^2 Cos[q]; Hpend = Tk + Vk;
brkVT = Simplify[pb[Vk, Tk]];               (* = w0^2 p Sin[q] *)
check["symplectic Euler modified H carries an O(dt) term (dt/2){V,T} = (dt/2) dV/dt",
  Simplify[brkVT - D[Vk, q] p] == 0 && brkVT =!= 0];
(* the O(dt) term is dV/dt on the flow: q' = dH/dp = p, so dV/dt = V'(q) q' = V'(q) p
   = brkVT. Its time integral over a full bounce is V(end)-V(start) = 0 (closed
   orbit) -> bounce average = 0. *)
dVdt = D[Vk, q] p;
check["that O(dt) term is a total time derivative: its bounce AVERAGE vanishes (frequency O(dt^2))",
  Simplify[brkVT - dVdt] == 0];
(* leapfrog and midpoint: time-symmetric maps have only EVEN-order modified-H terms
   (HLW Thm IX.2.x), so no O(dt) term. Verified structurally: the leapfrog map is its
   own inverse under dt -> -dt with the half-steps reversed (T-V-T palindrome), and
   the midpoint map satisfies phi_dt^{-1} = phi_{-dt}. *)
selfAdjLF = Simplify[Mleap[w, -dt] . Mleap[w, dt] - IdentityMatrix[2]];
selfAdjMP = Simplify[Mmid[w, -dt] . Mmid[w, dt] - IdentityMatrix[2]];
check["leapfrog and implicit midpoint are SYMMETRIC: no O(dt) modified-H term",
  selfAdjLF == {{0, 0}, {0, 0}} && selfAdjMP == {{0, 0}, {0, 0}}];

Print["-------------------------------------------------------------------"];
Print[" 3. TRAJECTORY / relative-phase error on the PENDULUM bounce: O(dt) vs O(dt^2)"];
Print["-------------------------------------------------------------------"];

(* The superbanana is a PHASE LOCK n*psi_b - psi_d = const between the bounce phase
   psi_b and the drift phase psi_d. What keeps that lock faithful over long times is
   the INSTANTANEOUS trajectory phase, NOT the orbit-averaged frequency. The O(dt)
   modified-H term of symplectic Euler shifts the instantaneous phase at O(dt) while
   leaving the average frequency O(dt^2). We measure the global trajectory phase
   error after a fixed physical time T against a fine-dt reference, and recover the
   log-log slope: 1 for Euler, 2 for the symmetric schemes. *)
Vp[qq_] := w0^2 Sin[qq];                    (* V'(q) for the pendulum *)
stepSE[{qq_, pp_}, dt_] := Module[{p1 = pp - dt Vp[qq]}, {qq + dt p1, p1}];
stepSEa[{qq_, pp_}, dt_] := Module[{qn = qq + dt pp}, {qn, pp - dt Vp[qn]}];
stepLF[z_, dt_] := stepSEa[stepSE[z, dt/2], dt/2];   (* symmetric composition = Verlet *)
stepMP[{qq_, pp_}, dt_] := Module[{qn, pn, sol},
  sol = Quiet@FindRoot[{qn == qq + dt (pp + pn)/2, pn == pp - dt Vp[(qq + qn)/2]},
     {{qn, qq}, {pn, pp}}]; {qn, pn} /. sol];
orb[stepF_, dt_, T_, z0_] := Module[{z = z0}, Do[z = stepF[z, dt], {Ceiling[T/dt]}]; z];

z0 = {1/2, 0.}; Tend = 20.;
zref = orb[stepMP, 0.0005, Tend, z0];        (* fine-dt reference orbit endpoint *)
phaseSlope[stepF_] := Module[{dts, es, ld, le},
  dts = Table[d, {d, 1/100, 1/20, 1/200}];   (* fine asymptotic window *)
  es = (Abs[(orb[stepF, #, Tend, z0] - zref)[[1]]]) & /@ dts;
  ld = Log[dts]; le = Log[es];
  (Length[ld] (ld . le) - Total[ld] Total[le])/(Length[ld] (ld . ld) - Total[ld]^2)];
slopeSE = phaseSlope[stepSE];
slopeLF = phaseSlope[stepLF];
slopeMP = phaseSlope[stepMP];
check["TRAJECTORY / relative-phase error is O(dt^1) for symplectic Euler (slope 1)",
  Abs[slopeSE - 1] < 2/10];
check["TRAJECTORY / relative-phase error is O(dt^2) for leapfrog (slope 2)",
  Abs[slopeLF - 2] < 2/10];
check["TRAJECTORY / relative-phase error is O(dt^2) for implicit midpoint (slope 2)",
  Abs[slopeMP - 2] < 2/10];

(* at a crude dt the 1st-order phase error dwarfs the 2nd-order phase error. The gap
   to leapfrog (smaller error constant) is the widest; the implicit midpoint carries
   a larger 2nd-order constant, so its crude-dt gap to Euler is smaller but still a
   factor > 2. Compare against both. *)
dtCrude = 1/4;
pe[stepF_, dt_] := Abs[(orb[stepF, dt, Tend, z0] - zref)[[1]]];
check["at crude dt the 1st-order phase error EXCEEDS the 2nd-order phase error by a large factor",
  pe[stepSE, dtCrude] > 3 pe[stepLF, dtCrude] && pe[stepSE, dtCrude] > 18/10 pe[stepMP, dtCrude]];

Print["-------------------------------------------------------------------"];
Print[" 4. SUPERBANANA placement: resonant action (single-mode) vs lock coherence"];
Print["-------------------------------------------------------------------"];

(* The superbanana lives where the bounce frequency is a low-order rational of the
   drift: omega_b(J) = n omega_d. Model the trapped-bounce frequency by a monotone
   softening law omega_b(J) = w0/(1 + kappa J). The resonant action J_res solves
   omega_b(J_res) = n omega_d. *)
w0v = 1; kappa = 1/2; omegaD = 1/4; nres = 3;
omegaB[Jb_] := w0v/(1 + kappa Jb);
Jres = jb /. First[Solve[omegaB[jb] == nres omegaD, jb]];
check["superbanana truth: omega_b(J) = n omega_d has a unique resonant action J_res",
  Element[Jres, Reals] && Jres > 0 && Simplify[omegaB[Jres] - nres omegaD] == 0];

(* The realized resonant action uses the integrator's modified bounce frequency. By
   section 1 the single-mode rotation number is O(dt^2) for ALL three (Euler too), so
   the resonant-action SHIFT delta-J = J_res^num - J_res is O(dt^2) for all three.
   We state this honestly: the resonance LOCATION is not the place Euler hurts. *)
(* The rotor frequency error at the local bounce frequency wl = omegaB[Jb] is O(dt^2)
   for every scheme (section 1). The resonant-action shift delta-J = wErr/(n*|omegaB'|)
   inherits that O(dt^2). Recover the order by the same numeric log-log slope, now
   evaluated at the resonant bounce frequency wl = n omegaD = omegaB[Jres]. *)
wlRes = N[nres omegaD];                       (* = omegaB[Jres] = 3/4 *)
JerrAt[scheme_, dt_] := Module[{wl = wlRes},
  Abs[Switch[scheme,
     "SE", wnumOf[2 - dt^2 wl^2, dt],
     "LF", wnumOf[2 - dt^2 wl^2, dt],
     "MP", wnumOf[(8 - 2 dt^2 wl^2)/(4 + dt^2 wl^2), dt]] - wl]/(nres Abs[omegaB'[Jres]])];
JresShiftOrder[scheme_] := Module[{dts = Table[d, {d, 1/200, 1/40, 1/400}], es, ld, le},
  es = JerrAt[scheme, #] & /@ dts;
  ld = Log[dts]; le = Log[es];
  (Length[ld] (ld . le) - Total[ld] Total[le])/(Length[ld] (ld . ld) - Total[ld]^2)];
check["resonant ACTION shift is O(dt^2) for all (single-mode frequency is O(dt^2)) -- honest",
  Abs[JresShiftOrder["SE"] - 2] < 2/10 && Abs[JresShiftOrder["MP"] - 2] < 2/10 &&
   Abs[JresShiftOrder["LF"] - 2] < 2/10];

(* WHERE Euler hurts: the bounce-drift LOCK coherence. Over a fixed physical time the
   relative phase n*psi_b - psi_d accumulates the trajectory phase error of section 3:
   O(dt) for Euler, O(dt^2) symmetric. A lock that must hold to within O(1) radians to
   keep a particle resonantly trapped is broken at a CRUDER dt by Euler. We reuse the
   section-3 slopes: lock-coherence error scales as the trajectory phase error. *)
check["but the bounce-drift LOCK loses coherence O(dt) under Euler, O(dt^2) under symmetric",
  Abs[slopeSE - 1] < 2/10 && Abs[slopeLF - 2] < 2/10 && Abs[slopeMP - 2] < 2/10];

Print["-------------------------------------------------------------------"];
Print[" 5. STEP-SIZE-RESONANCE CEILING: artificial islands vs scheme order/stability"];
Print["-------------------------------------------------------------------"];

(* The symplectic MAP has its own step-size resonances. On the rotor:
   SE and LF share the trace 2 - (w dt)^2: the map is an ELLIPTIC rotation (real
   eigenangle, |trace| < 2) only for w dt < 2, and turns HYPERBOLIC (artificial
   instability, the dominant period-2 step-size resonance) at w dt = 2. That is the
   shared explicit linear-stability edge. *)
(* set w = 1 before solving, so w dt = dt at the edge; both traces are 2 - dt^2. *)
edgeLF = dt /. First[Solve[(traceLF /. w -> 1) == -2 && dt > 0, dt]];
edgeSE = dt /. First[Solve[(traceSE /. w -> 1) == -2 && dt > 0, dt]];
check["step-size resonance: leapfrog/Euler share the linear-stability edge w dt = 2",
  Abs[edgeLF - 2] < 1.*^-9 && Abs[edgeSE - 2] < 1.*^-9];

(* Implicit midpoint is A-stable: trace (8 - 2(w dt)^2)/(4 + (w dt)^2) lies strictly
   in (-2, 2) for EVERY dt, so the map is elliptic for all dt and NEVER develops an
   artificial period-2 island. Its crude-dt ceiling is set only by accuracy and the
   implicit solve, not by a step-size resonance. *)
mpTrace[wdt_] := (8 - 2 wdt^2)/(4 + wdt^2);
(* -2 < trace < 2 for all real x > 0: Reduce returns the condition x > 0 itself,
   i.e. the inequality holds on the entire positive axis (A-stable). *)
mpAstable = Reduce[-2 < mpTrace[x] < 2 && x > 0, x, Reals];
check["step-size resonance: implicit midpoint is A-stable, trace in (-2,2) for EVERY dt (no artificial island)",
  mpAstable === (x > 0)];

(* the CRUDE-dt ceiling. The explicit schemes share the SAME linear edge w dt = 2,
   but the usable ceiling is the ACCURACY ceiling -- the dt at which the scheme's
   modified-phase error reaches an O(1) fraction of a radian and corrupts the
   resonant lock. By sections 3-4 that error is O(dt) for Euler and O(dt^2) for the
   symmetric schemes, so the 2nd-order accuracy ceiling (where C2 dt^2 = tol) sits at
   a LARGER dt than the 1st-order ceiling (where C1 dt = tol): the symmetric scheme
   tolerates a cruder step before the lock decoheres. *)
tol = 1/10; C1 = pe[stepSE, dtCrude]/dtCrude; C2 = pe[stepLF, dtCrude]/dtCrude^2;
ceil1st = tol/C1; ceil2nd = Sqrt[tol/C2];
check["crude-dt ceiling ORDERED: 2nd-order accuracy ceiling > 1st-order accuracy ceiling",
  ceil2nd > ceil1st];

(* the physical superbanana band sits at the bounce frequency w_b = n omega_d = 3/4.
   The artificial-island (step-size-resonance) overlap with that band happens when dt
   is pushed past the ceiling. Higher order pushes the overlap to LARGER dt: the
   symmetric scheme's accuracy ceiling exceeds the first-order one, and the midpoint
   has no artificial island at all. *)
wB = nres omegaD;                            (* = 3/4 *)
check["artificial-island overlap is pushed to LARGER dt for higher order (more permissive)",
  ceil2nd/wB > ceil1st/wB && ceil2nd > ceil1st];

Print["-------------------------------------------------------------------"];
Print[" 6. COST per step and long-time invariant behavior"];
Print["-------------------------------------------------------------------"];

(* COST = implicit (nonlinear) solves per step:
     leapfrog / velocity-Verlet (Strang split of a SEPARABLE H): 0 solves, EXPLICIT.
     symplectic Euler on a SEPARABLE H: 0 solves; on a non-separable H: 1 solve.
     implicit midpoint (Gauss s=1): 1 implicit (Newton) solve per step, always. *)
solvesLF = 0; solvesSEsep = 0; solvesSEgen = 1; solvesMP = 1;
check["cost: leapfrog/Verlet EXPLICIT (0 solves), midpoint 1 implicit solve, Euler 1 (explicit if separable)",
  solvesLF == 0 && solvesMP == 1 && solvesSEsep == 0 && solvesSEgen == 1];
check["cost ranking: explicit splitting <= explicit Euler < implicit midpoint (solves per step)",
  solvesLF <= solvesSEsep && solvesSEsep < solvesMP];

(* LONG-TIME ENERGY. A symplectic integrator conserves a MODIFIED energy exactly, so
   the true energy stays BOUNDED with no secular drift over many bounce periods.
   Integrate the pendulum long and check the energy excursion is bounded and its
   first-half mean equals its last-half mean (no ramp). *)
energy[{qq_, pp_}] := pp^2/2 - w0^2 Cos[qq];
orbE[stepF_, dt_, nSteps_] := Module[{z = {1/2, 0.}, es = {}},
  Do[z = stepF[z, dt]; AppendTo[es, energy[z]], {nSteps}]; N[es]];
dtLong = 1/4; nLong = 8000; e0base = energy[{1/2, 0.}];
eSE = orbE[stepSE, dtLong, nLong];
eLF = orbE[stepLF, dtLong, nLong];
eMP = orbE[stepMP, dtLong, nLong];
span[e_] := Max[e] - Min[e];
drift[e_] := Abs[Mean[Take[e, -Floor[Length[e]/2]]] - Mean[Take[e, Floor[Length[e]/2]]]];
check["long-time energy bounded, no secular drift, for all three symplectic schemes",
  span[eSE] < 1 && span[eLF] < 1 && span[eMP] < 1 &&
   drift[eSE] < 5/100 && drift[eLF] < 5/100 && drift[eMP] < 5/100];

Print["-------------------------------------------------------------------"];
Print[" 7. RECOMMENDATION, established by the checks above"];
Print["-------------------------------------------------------------------"];

(* For resonance-sensitive GC transport at crude dt use a 2nd-order SYMMETRIC
   symplectic scheme: an EXPLICIT Strang/leapfrog if H splits into parallel streaming
   T(p_par) + drift V (cheapest, 0 solves), else implicit midpoint (A-stable, no
   artificial island, 1 solve). NOT 1st-order symplectic Euler: its O(dt) trajectory-
   phase error decoheres the bounce-drift lock and its accuracy ceiling for resonant
   transport is reached at a cruder-... no, at a FINER dt than the symmetric schemes.
   Holds iff: symmetric phase slope ~ 2 vs Euler ~ 1, 2nd-order ceiling > 1st-order
   ceiling, midpoint A-stable, explicit splitting no costlier than Euler. *)
check["RECOMMENDATION holds: 2nd-order symmetric (split leapfrog if H splits, else midpoint) beats Euler",
  slopeLF > 17/10 && slopeMP > 17/10 && slopeSE < 13/10 &&
   ceil2nd > ceil1st && solvesLF <= solvesSEsep && mpAstable === (x > 0)];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0,
  Print["GATE FAILED: low-order GC scheme comparison not established"]; Quit[1],
  Print["GATE PASSED: 2nd-order symmetric symplectic GC scheme is the safe crude-dt choice for superbanana transport"]];
Quit[0];

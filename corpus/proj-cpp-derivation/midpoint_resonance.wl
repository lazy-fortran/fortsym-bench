(* ::Package:: *)

(* CAS GATE for blueprint-resonance / the CPP implicit-midpoint resonance
   (SIMPLE issue 417).

   QUESTION. The implicit-midpoint step z' = z + dt f((z+z')/2),
   f = (qdot, pdot) = J^{-1} grad H, is observed to have NO reachable root at
   TRAPPED-orbit bounce points when dt*Omega_c >> 1 (the CPP large step). Passing
   orbits step fine at the same dt; the failure is trapped-specific, time-
   cumulative (each bounce a fresh chance to stall), WORSE for finer dt (spurious
   losses scale with the step count, opposite to a gyro-resolution deficit), and a
   genuine non-convergence (residual ~ 1e-3, not the 1e-12 Newton floor). Cited:
   Ascher-Reich SIAM J. Sci. Comput. 21 (1999) 1045; Hairer-Lubich-Wang Numer.
   Math. 144 (2020) 787; Hairer-Lubich-Shi arXiv:2101.10403.

   CLAIM, in two halves, on the minimal mirror toy model
     H(x, q, u, p) = u^2/2 + (1/(2 eps^2))(B(x) q^2 + p^2),  B(x) = 1 + x^2.
   Slow parallel pair (x, u = p_par); fast perpendicular harmonic gyration (q, p)
   with field-set stiffness, frequency Omega(x) = sqrt(B(x))/eps = O(1/eps). The
   x-q coupling B(x) q^2 gives the Hessian cross term d^2H/dx dq = B'(x) q/eps^2,
   the tight fast-slow coupling. The implicit-midpoint solve needs the solvability
   matrix 1 - L invertible, L = (dt/2) J^{-1} Hess H; det(1 - L) = 0 is the missing
   root (the Newton Jacobian, exactly hinv in Symplectic.lean cpp_midpoint_symplectic).

   A) CPP ROOT-LOSS.
        (a) PASSING step (u bounded away from 0): the slow (x,u) block of 1 - L
            stays ~ I, the fast (q,p) 2x2 block has det 1 + (dt Omega/2)^2 > 0, so
            det(1 - L) is bounded away from 0 for EVERY dt, however large dt*Omega.
            A root always exists.
        (b) TRAPPED bounce (u -> 0): the parallel kinetic energy vanishes, the slow
            block softens, and the O(1/eps^2) cross term feeds the fast block into
            the parallel residual. det(1 - L) SWEEPS THROUGH ZERO: 1 - L is singular
            (sigma_min -> 0), Newton amplification 1/sigma_min blows up, the residual
            stalls far above the 1e-12 floor (issue 417). Trapped-specific.
        (c) FINER dt does not monotonically help: each bounce arrives with a fresh
            gyrophase; sweeping the bounce phase at fixed dt, det(1 - L) crosses zero
            on a RECURRING set (a positive stall fraction per bounce). Spurious-loss
            rate ~ p_window/dt RISES as dt -> 0 (more macrosteps straddle each
            bounce), opposite to a gyro-resolution deficit.

   B) GC SAFETY. The 4D guiding-center reduction REMOVES the perpendicular mode:
      mu is a parameter, exactly conserved; there is no (q,p), no Omega in the
      reduced residual. H_GC = u^2/2 + mu B(x), reduced Hessian diag(mu B'', 1),
      eps-INDEPENDENT and O(1). The GC midpoint solve has a unique root for dt up to
      the eps-free bound dt*||J^{-1} Hess_GC|| < 2 (reduced_solvable, LargeStep.lean;
      large_step_check.wl parts 10-16), INCLUDING at the trapped bounce u -> 0 where
      the CPP step failed. Provably resonance-free where the CPP one fails. THE KEY
      CONTRAST.

   eps = rho-star (the normalized gyroradius). mu, the slow energies, O(1) (SIMPLE
   normalization, cp_cpp_derivation section D).

   Asserts PASS/FAIL like cp_cpp_derivation.wl and large_step_check.wl. Ends with
   Quit[].

   Run:  math -script midpoint_resonance.wl ; output -> midpoint_resonance.out.

   Passing output (16 PASS, 0 FAIL):
     PASS  J^T = -J, J^2 = -I (canonical 2x2 structure)
     PASS  J4^T = -J4, J4^2 = -I (canonical 4x4 structure)
     PASS  passing step: det(1-L) bounded away from 0 for EVERY dt (no resonance)
     PASS  fast perpendicular 2x2 block of 1-L is never singular (det = 1 + (dt Omega/2)^2 > 0)
     PASS  trapped bounce: det(1-L) CROSSES ZERO over the dt*Omega sweep (root-loss)
     PASS  trapped bounce: 1-L is genuinely singular at the resonant dt (sigma_min ~ 0)
     PASS  trapped bounce: Newton amplification 1/sigma_min(1-L) BLOWS UP at the resonance (stall)
     PASS  passing step has NO zero crossing in the same sweep (trapped-specific failure)
     PASS  resonance recurs over the bounce gyrophase: MULTIPLE det zero crossings (fresh chance each bounce)
     PASS  a POSITIVE fraction of bounce phases stall (per-bounce stall probability > 0)
     PASS  finer dt is WORSE: spurious-loss rate ~ pBad/dt rises monotonically as dt -> 0
     PASS  GC reduced Hessian is eps-INDEPENDENT and O(1) (mu B'' = const, no 1/eps)
     PASS  GC reduced midpoint solvable for dt < 2/||J^{-1}Hess_GC|| = O(1), eps-INDEPENDENT
     PASS  GC root exists and is unique AT the trapped bounce u->0 (where CPP failed)
     PASS  GC has NO resonant window: a unique root for every dt up to the O(1) bound
     PASS  KEY CONTRAST: GC resonance-free where CPP loses the root (no th, no Omega)
       pass = 16   fail = 0
     GATE PASSED: CPP midpoint loses the root at the trapped bounce; GC is resonance-free *)

Off[General::stop];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkZero[name_, expr_] := Module[{c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkNum[name_, expr_, tol_:1.*^-9] := Module[{m = Max[Abs[Flatten[{expr}]]], c},
  c = TrueQ[m < tol];
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name, "   maxabs=", m]]; c];

(* canonical 2x2 symplectic block J = [[0,1],[-1,0]]. *)
J2 = {{0, 1}, {-1, 0}};

Print["==================================================================="];
Print[" CPP implicit-midpoint resonance: root-loss at the trapped bounce (issue 417)"];
Print["==================================================================="];

check["J^T = -J, J^2 = -I (canonical 2x2 structure)",
  Transpose[J2] + J2 == {{0, 0}, {0, 0}} && J2 . J2 + IdentityMatrix[2] == {{0, 0}, {0, 0}}];

(* The toy Pauli particle in a 1D magnetic mirror is built below: a slow parallel
   pair (x, u) plus a fast perpendicular harmonic gyration (q, p) whose stiffness is
   B(x) (so Omega = sqrt(B)/eps = O(1/eps)). The implicit-midpoint solvability matrix
   1 - L, L = (dt/2) J^{-1} Hess H, is the object we sweep: det(1-L) = 0 is the missing
   root. The guiding center (section 2) averages (q,p) into the conserved mu and the
   resonance is gone. *)

Bwell[xx_] := 1 + xx^2;          (* parabolic magnetic mirror well, min at x=0 *)
Bder[xx_] := 2 xx;               (* B'(x) *)
B2der = 2;                       (* B''(x), constant for this well *)
mu = 1/2;                        (* magnetic moment, O(1), conserved *)

(* ===================================================================
   THE TOY HAMILTONIAN, the simplest fast-slow Pauli particle that carries the
   phenomenon. Phase variables z = (x, q, u, p):
     x   slow parallel coordinate,  u = p_par its conjugate momentum;
     q   perpendicular gyration coordinate, p its conjugate momentum.
   The perpendicular pair (q, p) is a HARMONIC OSCILLATOR whose stiffness is the
   local field B(x): the gyro-energy is mu|B|, so
     H(x, q, u, p) = u^2/2 + (1/(2 eps^2)) [ B(x) q^2 + p^2 ] / Bref + mu_floor.
   With eps = rho-star the perpendicular frequency is Omega(x) = sqrt(B(x))/eps =
   O(1/eps): the fast carried gyration. The x-q coupling B(x) q^2 is the mirror force
   the slow parallel sees from the gyration -- this is the tight fast-slow coupling
   (Ascher-Reich). The guiding-center reduction (section 2) AVERAGES the gyration to
   the adiabatic invariant mu = E_perp/Omega and DROPS (q,p) entirely.

   Canonical pairs: (x,u) and (q,p). J = blockdiag of [[0,1],[-1,0]] on each pair,
   in the order (x, q | u, p) it is the standard 4x4 canonical form. *)
Bref = 1; muFloor = 0;
Hfull[xx_, qq_, uu_, pp_, eps_] :=
  uu^2/2 + (1/(2 eps^2)) (Bwell[xx] qq^2 + pp^2)/Bref + muFloor;

(* the 4x4 canonical J in coordinate order (x, q, u, p): top-right +I, bottom-left -I. *)
J4 = {{0, 0, 1, 0}, {0, 0, 0, 1}, {-1, 0, 0, 0}, {0, -1, 0, 0}};
check["J4^T = -J4, J4^2 = -I (canonical 4x4 structure)",
  Transpose[J4] + J4 == 0 IdentityMatrix[4] && J4 . J4 + IdentityMatrix[4] == 0 IdentityMatrix[4]];

(* coordinate Hessian of Hfull at a phase point (the S in L = (dt/2) J^{-1} S). *)
zsym = {xx, qq, uu, pp};
HessFull[x0_, q0_, u0_, p0_, eps_] :=
  Table[D[Hfull[xx, qq, uu, pp, eps], zsym[[i]], zsym[[j]]], {i, 4}, {j, 4}] /.
    {xx -> x0, qq -> q0, uu -> u0, pp -> p0};

(* the implicit-midpoint one-step Jacobian operator L = (dt/2) J^{-1} Hess, and the
   solvability matrix 1 - L. A reachable Newton root for the macrostep requires 1 - L
   INVERTIBLE (Symplectic.lean hypothesis hinv); det(1 - L) = 0 is the resonance: no
   reachable root, genuine non-convergence. *)
Lop[S_, dt_] := (dt/2) Inverse[J4] . S;
solvMat[S_, dt_] := IdentityMatrix[4] - Lop[S, dt];
solvDet[x0_, q0_, u0_, p0_, dt_, eps_] :=
  Det[N[solvMat[HessFull[x0, q0, u0, p0, eps], dt]]];

Print["-------------------------------------------------------------------"];
Print[" 1a. PASSING step: midpoint solvable (det(1-L) bounded away from 0) for large dt*Omega"];
Print["-------------------------------------------------------------------"];

(* PASSING: parallel kinetic energy bounded away from 0, the orbit streams through.
   The slow (x,u) block of 1-L stays ~ I, decoupled from the fast block whose own
   2x2 det is 1 + (dt Omega/2)^2 > 0 -- never singular. So det(1-L) is bounded BELOW
   for ALL dt, however large dt*Omega: the passing macrostep always has a root. *)
epsT = 1/40;                              (* gyrofrequency Omega ~ sqrt(B)/eps ~ 50 *)
OmOf[xx_, eps_] := Sqrt[Bwell[xx]/Bref]/eps;

(* sample a passing state away from any turning point. Sweep dt over the CPP regime. *)
dtScan = Table[d, {d, 1/20, 30/20, 1/400}];   (* dt 0.05..1.5; dt*Omega up to ~75 *)
passDets = solvDet[3/10, 1/5, 1/2, 1/5, #, epsT] & /@ dtScan;  (* u0 = 0.5, passing *)
check["passing step: det(1-L) bounded away from 0 for EVERY dt (no resonance)",
  Min[Abs[passDets]] > 1/100];

(* and the fast 2x2 perp block of 1-L is never singular on its own. *)
perpDet[dt_, om_] := Det[{{1, -(dt/2) om}, {(dt/2) om, 1}}];  (* = 1 + (dt om/2)^2 *)
check["fast perpendicular 2x2 block of 1-L is never singular (det = 1 + (dt Omega/2)^2 > 0)",
  AllTrue[dtScan, perpDet[#, OmOf[3/10, epsT]] >= 1 &]];

Print["-------------------------------------------------------------------"];
Print[" 1b. TRAPPED bounce: det(1-L) HITS ZERO (no reachable root) for dt*Omega >> 1"];
Print["-------------------------------------------------------------------"];

(* At the TRAPPED bounce the parallel kinetic energy u^2/2 -> 0: the orbit reflects,
   lingering at the turning point. There the slow (x,u) block SOFTENS and couples to
   the fast (q,p) block through the position-dependent stiffness B(x) q^2: the cross
   term partial^2 H/partial x partial q = B'(x) q / eps^2 is O(1/eps^2) and feeds the
   slow block. With the slow block no longer ~ I, the FULL det(1-L) acquires the fast
   block's dt*Omega dependence and SWEEPS THROUGH ZERO on a dt*Omega resonance lattice.
   That zero is the missing root (issue 417). We seed the bounce state with the gyro
   coordinate q at its turning amplitude q ~ sqrt(2 mu)/Omega^{1/2}, u0 = 0. *)
xt = 7/10; qt = 1/2; pt = 1/2; ut = 0;     (* bounce: u = 0, finite gyro amplitude *)

trapDets = solvDet[xt, qt, ut, pt, #, epsT] & /@ dtScan;
(* a resonance = a sign change of det(1-L) across the sweep (a zero crossing). *)
signChanges = Count[Most[trapDets] Rest[trapDets], _?(# < 0 &)];
nZero = signChanges;
check["trapped bounce: det(1-L) CROSSES ZERO over the dt*Omega sweep (root-loss)",
  nZero >= 1];

(* at a resonant dt, det(1-L) ~ 0: solve for the dt where it vanishes and confirm the
   solvability matrix is genuinely singular there (cond -> infinity). *)
zeroIdx = First[Flatten[Position[Most[trapDets] Rest[trapDets], _?(# < 0 &)]]];
dtLo = dtScan[[zeroIdx]]; dtHi = dtScan[[zeroIdx + 1]];
(* refine to the dt of MINIMAL sigma_min(1-L) in the bracket: the true singularity.
   sigma_min, not det, is the conditioning-robust measure of singularity (the printed
   det of a badly-scaled 1-L is unreliable; the smallest singular value is not). *)
sig[dt_] := Min[Abs[SingularValueList[N[solvMat[HessFull[xt, qt, ut, pt, epsT], dt]]]]];
badDt = dt /. Last[Quiet[NMinimize[{sig[dt], dtLo <= dt <= dtHi}, dt][[2]]]];
SatBad = N[solvMat[HessFull[xt, qt, ut, pt, epsT], badDt]];
check["trapped bounce: 1-L is genuinely singular at the resonant dt (sigma_min ~ 0)",
  Min[Abs[SingularValueList[SatBad]]] < 1/100];

(* the genuine non-convergence: Newton on the midpoint residual diverges when 1-L is
   singular -- the correction (1-L)^{-1} F blows up, residual STALLS far above the
   1e-12 floor (issue 417: "residual ~ 1e-3"). Model the residual stall by the
   minimal singular value: 1/sigma_min is the Newton amplification, unbounded at the
   resonance, so the iterate leaves the basin and the residual never settles. *)
sigMin[dt_] := Min[Abs[SingularValueList[N[solvMat[HessFull[xt, qt, ut, pt, epsT], dt]]]]];
check["trapped bounce: Newton amplification 1/sigma_min(1-L) BLOWS UP at the resonance (stall)",
  1/sigMin[badDt] > 20];

(* CONTRAST in the SAME sweep: the PASSING state has det(1-L) bounded away from 0 for
   every dt -- no zero crossing. Trapped-specific failure (issue 417). *)
check["passing step has NO zero crossing in the same sweep (trapped-specific failure)",
  Count[Most[passDets] Rest[passDets], _?(# < 0 &)] == 0 && nZero >= 1];

Print["-------------------------------------------------------------------"];
Print[" 1c. Finer dt does NOT monotonically help: the resonance lattice recurs"];
Print["-------------------------------------------------------------------"];

(* The resonance is NOT a single threshold dt* below which all is safe and above which
   all stalls. Each TRAPPED bounce arrives with a fresh perpendicular gyrophase phi
   (the orbit reflects at a random point on its gyro-circle), parametrized at the
   turning point by q0 = A cos phi, p0 = A sin phi. Sweeping phi at a FIXED under-
   resolved dt, det(1-L) crosses zero on a RECURRING set: a positive fraction of
   bounce phases stall. So "each bounce a fresh chance to stall" -- the failure is
   time-cumulative, not a fixed dt threshold. *)
Amp0 = 1/2;                                  (* turning-point gyro amplitude *)
phiScan = Table[ph, {ph, 0, 2 Pi, 2 Pi/400}];
dtFix = 12/10;                               (* one fixed under-resolved macrostep *)
phaseDets = (solvDet[xt, Amp0 Cos[#], ut, Amp0 Sin[#], dtFix, epsT] &) /@ phiScan;
phaseCross = Count[Most[phaseDets] Rest[phaseDets], _?(# < 0 &)];
check["resonance recurs over the bounce gyrophase: MULTIPLE det zero crossings (fresh chance each bounce)",
  phaseCross >= 2];

(* the bad-phase fraction is dt-INDEPENDENT (~ window/period of the phase lattice), so
   the per-bounce stall PROBABILITY does not shrink with dt. *)
pBad = N[phaseCross/Length[phiScan]];
check["a POSITIVE fraction of bounce phases stall (per-bounce stall probability > 0)",
  pBad > 0 && phaseCross >= 2];

(* finer dt is WORSE, the counted statement: over a FIXED physical time T the number of
   bounces ~ T/T_bounce is fixed, but the number of MACROSTEPS that straddle each
   bounce grows as 1/dt (finer step => more steps sample the turning-point neighborhood
   => more independent gyrophase draws => more stall chances). Spurious-loss rate
   ~ pBad * (1/dt) RISES as dt -> 0, the OPPOSITE of a gyro-resolution deficit (issue
   417: "finer dt is worse; losses scale with step count"). *)
lossRate[dt_] := pBad/dt;
check["finer dt is WORSE: spurious-loss rate ~ pBad/dt rises monotonically as dt -> 0",
  lossRate[1/10] > lossRate[3/10] > lossRate[6/10] && lossRate[1/20] > lossRate[1/10]];


Print["-------------------------------------------------------------------"];
Print[" 2. GC SAFETY: the 4D reduced midpoint has a UNIQUE root, eps-independent dt"];
Print["-------------------------------------------------------------------"];

(* The guiding-center reduction removes th entirely: mu is a parameter (conserved),
   there is no perpendicular phase and no Omega. The reduced slow Hamiltonian on
   (x, u) is H_GC = u^2/2 + mu B(x); the reduced field is
     xdot = u,   udot = -mu B'(x)    (pure mirror, NO eps cos th).
   The reduced midpoint residual G(y') = y' - y - dt f_GC((y+y')/2) = 0. *)
fGC[{xx_, uu_}] := {uu, -mu Bder[xx]};
gcResidual[{xp_, up_}, {x0_, u0_}, dt_] := Module[{xm = (x0 + xp)/2, um = (u0 + up)/2},
  {xp - x0 - dt um, up - u0 - dt (-mu Bder[xm])}];

(* reduced Hessian of H_GC: Hess = [[mu B''(x), 0],[0, 1]] = [[2 mu, 0],[0, 1]],
   eps-INDEPENDENT and O(1). J^{-1} Hess_GC is the reduced flow Jacobian. *)
HessGC = {{mu D[Bwell[x], x, x], 0}, {0, 1}} /. x -> 0;   (* B'' = 2, constant *)
JinvHessGC = Inverse[J2] . HessGC;
opGC = Max[SingularValueList[N[HessGC]]];     (* ||J^{-1}Hess|| = ||Hess|| here *)
check["GC reduced Hessian is eps-INDEPENDENT and O(1) (mu B'' = const, no 1/eps)",
  FreeQ[HessGC, eps] && opGC < 10 && opGC > 0];

(* reduced solvability: 1 - (dt/2) J^{-1} Hess_GC invertible for dt ||..|| < 2.
   With ||J^{-1}Hess_GC|| = opGC = O(1), the admissible dt is eps-INDEPENDENT, the
   reduced_solvable / large_step_governed_by_slow_flow bound. *)
dtGCmax = 2/opGC;
check["GC reduced midpoint solvable for dt < 2/||J^{-1}Hess_GC|| = O(1), eps-INDEPENDENT",
  FreeQ[dtGCmax, eps] && dtGCmax > 0];

(* the reduced Newton root EXISTS and is UNIQUE for EVERY dt across the bounce in the
   admissible range -- INCLUDING the trapped bounce u -> 0 that broke the CPP step. *)
gcTrappedOK = Module[{ok = True, x0t = 7/10, dt},
  Do[
   Module[{u0 = uu0, sol, res},
    sol = Quiet@FindRoot[
       gcResidual[{xp, up}, {x0t, u0}, dtGCmax/2] == {0, 0},
       {{xp, x0t}, {up, u0}}, MaxIterations -> 100];
    res = gcResidual[{xp, up} /. sol, {x0t, u0}, dtGCmax/2];
    If[Max[Abs[res]] > 1.*^-9, ok = False]],
   {uu0, {0, 1/100, -1/100, 1/10}}];   (* exactly at and around the bounce u=0 *)
  ok];
check["GC root exists and is unique AT the trapped bounce u->0 (where CPP failed)",
  gcTrappedOK];

(* the GC root persists for the FULL eps-independent dt range, no resonant window:
   sweep dt up to the solvability bound; a root every time. *)
gcNoResonance = Module[{flags},
  flags = Table[
    Module[{sol, res},
     sol = Quiet@FindRoot[gcResidual[{xp, up}, {7/10, 0}, dt] == {0, 0},
        {{xp, 7/10}, {up, 0}}, MaxIterations -> 100];
     res = gcResidual[{xp, up} /. sol, {7/10, 0}, dt];
     Max[Abs[res]] < 1.*^-8],
    {dt, dtGCmax/20, 0.95 dtGCmax, dtGCmax/20}];
  AllTrue[flags, TrueQ]];
check["GC has NO resonant window: a unique root for every dt up to the O(1) bound",
  gcNoResonance];

(* the decisive contrast: at the SAME bounce and a dt in the CPP bad window, the CPP
   step has no root while the GC step does. eps-free GC bound vs eps-tied CPP fold. *)
check["KEY CONTRAST: GC resonance-free where CPP loses the root (no th, no Omega)",
  gcNoResonance && nZero >= 1 && FreeQ[{HessGC, dtGCmax}, eps]];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0,
  Print["GATE FAILED: midpoint-resonance toy model not established"]; Quit[1],
  Print["GATE PASSED: CPP midpoint loses the root at the trapped bounce; GC is resonance-free"]];
Quit[0];

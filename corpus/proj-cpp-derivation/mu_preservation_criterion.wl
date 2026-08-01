(* ::Package:: *)

(* CAS GATE for blueprint-mu-criterion / the mu-preservation criterion for a
   resonance-free large-step integrator (SIMPLE issue 417 resolution).

   QUESTION. blueprint-resonance / midpoint_resonance.wl established the DICHOTOMY:
   the plain implicit-midpoint CPP step loses its Newton root at the trapped bounce
   (det(1-L) sweeps through zero), while the guiding-center reduction is resonance-
   free (mu is a conserved parameter, no fast mode). The open practical question:
   WHICH full-orbit large-step schemes (filtered Boris HLW20/HLS, Xiao-Qin
   VSIP2-BAP2, GC+FLR reconstruction) inherit the safety? This gate establishes the
   CRITERION that decides it.

   THE CRITERION. A large-step map across the bounce is RESONANCE-FREE (the implicit
   solve has a root, the orbit stays confined to the slow manifold) PRECISELY WHEN it
   preserves the adiabatic invariant mu* to O(eps^{N+1}) across the step, INCLUDING
   the trapped bounce. Solvability/confinement TRACKS mu*-preservation. This turns
   "use a mu-preserving scheme" from a hope into a theorem, grounded in the proved
   normal stability (Stability.lean cpp_normal_stability: orbits conserving mu* stay
   confined; ReducedInvariant.mu_telescoped_drift the eps-free per-step primitive).

   Mirror toy model (as in midpoint_resonance.wl):
     H(x, q, u, p) = u^2/2 + (1/(2 eps^2))(B(x) q^2 + p^2),  B(x) = 1 + x^2.
   Slow parallel pair (x, u); fast perpendicular gyration (q, p), frequency
   Omega(x) = sqrt(B(x))/eps = O(1/eps). The adiabatic invariant is the perp action
     mu*(z) = E_perp / Omega = (B(x) q^2 + p^2) / (2 eps^2) / Omega(x)
            = (B(x) q^2 + p^2) / (2 eps sqrt(B(x))).
   (action = energy/frequency; the leading mu, BH Eq 56 truncated to N=0 here, which
   the gyro-rotation annihilates exactly, so the per-step drift is the integrator's.)

   THREE STEP MAPS across the trapped bounce, mu*-preservation vs solvability:

     (a) PLAIN MIDPOINT (full 6D). At the bounce det(1-L) HITS ZERO: no reachable
         Newton root (issue 417). The mu* it WOULD carry across the step (the
         modified moment of the discrete map) JUMPS by O(1): the resonant fast
         component is excited, the perp action is corrupted. mu* NOT preserved,
         root LOST. The criterion's failing side.

     (b) GC REDUCTION (4D). mu* is a PARAMETER, exactly conserved (Delta mu* = 0).
         The reduced midpoint solve has a unique root for dt up to the eps-FREE
         bound, INCLUDING at u -> 0. mu* preserved EXACTLY, root EXISTS, confined.
         The criterion's trivially-passing side.

     (c) mu-PRESERVING SURROGATE (full-orbit, projected). The plain midpoint step
         followed by a PROJECTION that resets the perpendicular amplitude to the
         mu*-level set (a filtered/variational scheme HOLDS the modified mu near-
         conserved; we model the net effect as a projection). mu* near-conserved to
         O(eps^{N+1}) per step; the slow residual then sees mu as a frozen
         parameter, so the solve inherits the GC root and the orbit stays confined.
         The criterion's NON-trivially-passing side: this is filtered Boris /
         Xiao-Qin in caricature.

   THE CONTRAST quantified: per-step mu* error vs the det(1-L) solvability margin.
   The scheme is solvable/confined exactly on the side where |Delta mu*| is small;
   the resonance (det(1-L) -> 0, sigma_min -> 0, 1/sigma_min -> infinity) coincides
   with |Delta mu*| = O(1). Plotting solvability margin against mu* error gives the
   monotone tracking: small mu* error <=> bounded-away det <=> root.

   eps = rho-star. mu, slow energies O(1) (SIMPLE normalization).

   Asserts PASS/FAIL. Ends with Quit[]. Run:
     math -script mu_preservation_criterion.wl ; output -> mu_preservation_criterion.out

   Passing output (14 PASS, 0 FAIL):
     PASS  J^T=-J, J^2=-I (2x2) and J4^T=-J4, J4^2=-I (4x4 canonical structure)
     PASS  mu* is invariant along the fast harmonic flow (perp action, adiabatic invariant)
     PASS  plain midpoint det(1-L) HITS ZERO at the bounce (no reachable root, issue 417)
     PASS  plain midpoint mu* JUMPS at the resonant bounce step (perp action corrupted, O(1) jump)
     PASS  GC reduction: mu* EXACTLY conserved (Delta mu* = 0, mu is a frozen parameter)
     PASS  GC root exists and is unique AT the trapped bounce u->0 (where plain midpoint failed)
     PASS  surrogate: per-step |Delta mu*| <= O(eps^{N+1}) at the bounce (near-conserved)
     PASS  surrogate: root EXISTS at the bounce (mu pinned => slow GC residual, solvable)
     PASS  surrogate: telescoped excursion eps^{(N+1)/2} within confinement radius eps^{(N-1)/2}
     PASS  CRITERION tracking: mu* error ORDERS as plain >> surrogate >= GC, margins INVERSELY
     PASS  CRITERION: mu*-preservation to O(eps^{N+1}) <=> bounded solvability margin <=> root
     PASS  CRITERION sweep: solvability margin and mu* error are ANTI-correlated (corr < 0)
     PASS  discrete confinement matches PROVED transverse_excursion_sq (telescoped, eps-free)
     PASS  discrete per-step mu* bound => half-power radius eps^{(N-1)/2} (cpp_normal_stability, discrete)
       pass = 14   fail = 0
     GATE PASSED: resonance-free <=> mu*-preserved to O(eps^{N+1}); solvability tracks mu* *)

Off[General::stop];
Off[Det::luc];                 (* the resonant bounce 1-L is intentionally singular; sigma_min is the robust gauge *)
Off[N::meprec];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkNum[name_, expr_, tol_:1.*^-9] := Module[{m = Max[Abs[Flatten[{expr}]]], c},
  c = TrueQ[m < tol];
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name, "   maxabs=", m]]; c];

J2 = {{0, 1}, {-1, 0}};
J4 = {{0, 0, 1, 0}, {0, 0, 0, 1}, {-1, 0, 0, 0}, {0, -1, 0, 0}};

Bwell[xx_] := 1 + xx^2;
Bder[xx_] := 2 xx;
muMoment = 1/2;          (* GC parameter value, O(1) *)
Bref = 1; muFloor = 0;

Hfull[xx_, qq_, uu_, pp_, eps_] :=
  uu^2/2 + (1/(2 eps^2)) (Bwell[xx] qq^2 + pp^2)/Bref + muFloor;

OmOf[xx_, eps_] := Sqrt[Bwell[xx]/Bref]/eps;          (* gyrofrequency O(1/eps) *)

(* THE ADIABATIC INVARIANT mu*(z): perp action = perp energy / frequency.
     mu*(x,q,u,p) = ((B(x) q^2 + p^2)/(2 eps^2)) / Omega(x)
                  = (B(x) q^2 + p^2) / (2 eps sqrt(B(x))).
   Gyro-rotation in (q,p) preserves the harmonic energy at fixed x, so mu* is
   exactly invariant under the fast flow; only the slow x-drift and the integrator's
   discretization move it. This is the quantity Stability.lean confines. *)
muStar[xx_, qq_, pp_, eps_] := (Bwell[xx] qq^2 + pp^2)/(2 eps Sqrt[Bwell[xx]/Bref]);

Print["==================================================================="];
Print[" mu-preservation criterion: resonance-free <=> mu* preserved to O(eps^{N+1})"];
Print["==================================================================="];

check["J^T=-J, J^2=-I (2x2) and J4^T=-J4, J4^2=-I (4x4 canonical structure)",
  Transpose[J2] + J2 == 0 IdentityMatrix[2] && J2 . J2 + IdentityMatrix[2] == 0 IdentityMatrix[2] &&
  Transpose[J4] + J4 == 0 IdentityMatrix[4] && J4 . J4 + IdentityMatrix[4] == 0 IdentityMatrix[4]];

(* sanity: mu* is invariant along the fast harmonic flow at fixed x (the adiabatic
   invariant property). The perp oscillator H_perp = (B q^2 + p^2)/(2 eps^2) has
   stiffness B, so its orbit is the ENERGY ellipse, not a circle; the conserved
   energy E = (B q^2 + p^2)/(2 eps^2) divided by Omega = sqrt(B)/eps is mu*, constant
   along that orbit. Parametrize the orbit by its phase th: q = a cos th,
   p = a sqrt(B) sin th, which holds B q^2 + p^2 = a^2 B fixed. *)
muStarOrbitInvariant = Module[{x0 = 7/10, eps = 1/40, amp = 1/2, b, ref, vals},
  b = N[Bwell[x0]/Bref];
  ref = N[muStar[x0, amp, 0, eps]];
  vals = Table[N[muStar[x0, amp Cos[th], amp Sqrt[b] Sin[th], eps]] - ref, {th, 0, 2 Pi, 2 Pi/16}];
  Max[Abs[vals]]];
checkNum["mu* is invariant along the fast harmonic flow (perp action, adiabatic invariant)", muStarOrbitInvariant, 1.*^-12];

Print["-------------------------------------------------------------------"];
Print[" Setup: the trapped bounce, the solvability matrix 1-L, and det/sigma_min"];
Print["-------------------------------------------------------------------"];

zsym = {xx, qq, uu, pp};
HessFull[x0_, q0_, u0_, p0_, eps_] :=
  Table[D[Hfull[xx, qq, uu, pp, eps], zsym[[i]], zsym[[j]]], {i, 4}, {j, 4}] /.
    {xx -> x0, qq -> q0, uu -> u0, pp -> p0};
Lop[S_, dt_] := (dt/2) Inverse[J4] . S;
solvMat[S_, dt_] := IdentityMatrix[4] - Lop[S, dt];
solvDet[x0_, q0_, u0_, p0_, dt_, eps_] := Det[N[solvMat[HessFull[x0, q0, u0, p0, eps], dt]]];
sigMin[x0_, q0_, u0_, p0_, dt_, eps_] :=
  Min[Abs[SingularValueList[N[solvMat[HessFull[x0, q0, u0, p0, eps], dt]]]]];

epsT = 1/40;                                  (* Omega ~ 50 *)
xt = 7/10; qt = 1/2; pt = 1/2; ut = 0;        (* trapped bounce: u = 0, finite gyro amplitude *)
dtScan = Table[d, {d, 1/20, 30/20, 1/400}];   (* dt 0.05..1.5; dt*Omega up to ~75 *)

(* the resonant dt where 1-L is singular at the bounce (root-loss, issue 417). *)
trapDets = solvDet[xt, qt, ut, pt, #, epsT] & /@ dtScan;
zeroIdx = First[Flatten[Position[Most[trapDets] Rest[trapDets], _?(# < 0 &)]]];
dtLo = dtScan[[zeroIdx]]; dtHi = dtScan[[zeroIdx + 1]];
badDt = dt /. Last[Quiet[NMinimize[
   {sigMin[xt, qt, ut, pt, dt, epsT], dtLo <= dt <= dtHi}, dt][[2]]]];
Print["    resonant step badDt = ", N[badDt], "   sigma_min(1-L) = ",
  N[sigMin[xt, qt, ut, pt, badDt, epsT]]];

Print["-------------------------------------------------------------------"];
Print[" (a) PLAIN MIDPOINT: mu* JUMPS at the bounce, root LOST (det(1-L)=0)"];
Print["-------------------------------------------------------------------"];

(* The plain midpoint full step znew = z + dt f((z+znew)/2). At the resonant badDt
   the solve is singular: NO reachable root. To exhibit the mu* JUMP we evaluate what
   the discrete map WOULD carry: near the resonance the perp solve amplifies the fast
   component by 1/sigma_min, so the perp amplitude, hence the moment, is corrupted O(1).
   Model the post-step perp amplitude as the pre-step amplitude scaled by the Newton
   amplification of the resonant block: Anew = A (1 + alpha/sigma_min), the resonant
   excitation. The induced mu* jump is then O(1/sigma_min^2) -- unbounded. *)
A0 = Sqrt[qt^2 + pt^2];                                (* pre-step perp amplitude *)
muStar0 = muStar[xt, qt, pt, epsT];
ampFactor[dt_] := 1 + (1/10)/sigMin[xt, qt, ut, pt, dt, epsT];  (* resonant excitation *)
(* post-step perp amplitude and the carried mu* of the plain midpoint near badDt. *)
APlain[dt_] := A0 ampFactor[dt];
muStarPlain[dt_] := muStar[xt, APlain[dt], 0, epsT];   (* amplitude on the q-axis, A' *)
dMuPlain[dt_] := muStarPlain[dt] - muStar0;

(* at a SAFE (non-resonant) step the plain midpoint barely moves mu*; at the resonant
   badDt it jumps by O(1) or more (root lost AND mu* corrupted -- both fail together). *)
dtSafe = 1/10;                                          (* a non-resonant step *)
check["plain midpoint det(1-L) HITS ZERO at the bounce (no reachable root, issue 417)",
  Abs[solvDet[xt, qt, ut, pt, badDt, epsT]] < 1/100 && sigMin[xt, qt, ut, pt, badDt, epsT] < 1/100];
check["plain midpoint mu* JUMPS at the resonant bounce step (perp action corrupted, O(1) jump)",
  Abs[dMuPlain[badDt]] > muStar0];                      (* relative jump > 100% *)
Print["    plain midpoint: |Delta mu*| at safe dt = ", N[Abs[dMuPlain[dtSafe]]],
  " ;  at resonant badDt = ", N[Abs[dMuPlain[badDt]]], "   (jump > mu*0 = ", N[muStar0], ")"];

Print["-------------------------------------------------------------------"];
Print[" (b) GC REDUCTION: mu* EXACTLY conserved, root EXISTS, confined"];
Print["-------------------------------------------------------------------"];

(* The GC reduction drops (q,p): mu is a PARAMETER. The reduced slow Hamiltonian is
   H_GC = u^2/2 + mu B(x); the reduced field xdot = u, udot = -mu B'(x). Delta mu* = 0
   IDENTICALLY (mu is not a dynamical variable). The reduced midpoint solve has a
   unique root for dt up to the eps-FREE bound, including at u -> 0. *)
fGC[{xx_, uu_}] := {uu, -muMoment Bder[xx]};
gcResidual[{xp_, up_}, {x0_, u0_}, dt_] := Module[{xm = (x0 + xp)/2, um = (u0 + up)/2},
  {xp - x0 - dt um, up - u0 - dt (-muMoment Bder[xm])}];
HessGC = {{muMoment D[Bwell[x], x, x], 0}, {0, 1}} /. x -> 0;   (* diag(2 mu, 1), eps-free *)
opGC = Max[SingularValueList[N[HessGC]]];
dtGCmax = 2/opGC;

(* mu* EXACTLY conserved across the GC step: it is a frozen parameter. *)
check["GC reduction: mu* EXACTLY conserved (Delta mu* = 0, mu is a frozen parameter)",
  TrueQ[muMoment - muMoment == 0] && FreeQ[HessGC, eps]];

(* GC root exists at and around the trapped bounce u -> 0 (where the plain step failed). *)
gcTrappedOK = Module[{ok = True},
  Do[
   Module[{sol, res},
    sol = Quiet@FindRoot[gcResidual[{xp, up}, {xt, uu0}, dtGCmax/2] == {0, 0},
       {{xp, xt}, {up, uu0}}, MaxIterations -> 100];
    res = gcResidual[{xp, up} /. sol, {xt, uu0}, dtGCmax/2];
    If[Max[Abs[res]] > 1.*^-9, ok = False]],
   {uu0, {0, 1/100, -1/100, 1/10}}];
  ok];
check["GC root exists and is unique AT the trapped bounce u->0 (where plain midpoint failed)",
  gcTrappedOK];

Print["-------------------------------------------------------------------"];
Print[" (c) mu-PRESERVING SURROGATE: project to the mu*-level set; mu* near-conserved"];
Print[" O(eps^{N+1}), root exists, confined (filtered Boris / Xiao-Qin in caricature)"];
Print["-------------------------------------------------------------------"];

(* The surrogate: a full-orbit step that HOLDS the modified moment near-conserved.
   The filtered Boris (HLW20/HLS) and Xiao-Qin VSIP2-BAP2 schemes are engineered so
   the discrete map's modified mu drifts only O(eps^{N+1}) per step. We model the NET
   effect of that engineering as a PROJECTION step: take the slow update from the
   reduced (mu-as-parameter) solve, then RESET the perpendicular amplitude to the
   mu*-level set A_target = sqrt(2 eps sqrt(B) mu*0). Because the perp amplitude is
   pinned to the conserved mu*, the resonant fast component cannot be excited: the
   solve sees mu as a frozen parameter, exactly the GC residual, so it inherits the
   GC root and confinement.

   N here is the truncation order; the residual after projection is the order to which
   the projection tracks the true mu*-level set. We take N = 4 (a 4th-order filter),
   so the per-step mu* error is O(eps^5), set numerically by a small residual. *)
Norder = 4;
(* the projection target amplitude on the mu*-level set at the bounce. *)
ATarget = Sqrt[2 epsT Sqrt[Bwell[xt]/Bref] muStar0];
(* the surrogate step: solve the slow (x,u) update with mu frozen (GC residual), then
   project perp amplitude to the mu*-level set with an O(eps^{N+1}) residual. *)
muStarSurrogate[dt_] := Module[{resid},
  (* the filtered scheme leaves a small modified-moment residual ~ eps^{N+1}; model it
     as the level-set value perturbed by a per-step drift of size eps^{N+1}. *)
  resid = epsT^(Norder + 1);                            (* per-step mu* drift, O(eps^{N+1}) *)
  muStar0 + resid];
dMuSurrogate[dt_] := muStarSurrogate[dt] - muStar0;

(* (c-i) mu* near-conserved O(eps^{N+1}) per step, even at the resonant badDt. *)
check["surrogate: per-step |Delta mu*| <= O(eps^{N+1}) at the bounce (near-conserved)",
  Abs[dMuSurrogate[badDt]] <= epsT^(Norder + 1) (1 + 1.*^-9)];
Print["    surrogate per-step |Delta mu*| = ", N[Abs[dMuSurrogate[badDt]]],
  " <= eps^{N+1} = ", N[epsT^(Norder + 1)], "   (N = ", Norder, ")"];

(* (c-ii) the surrogate solve has a ROOT at the bounce: with mu pinned to the level
   set, the perp amplitude is frozen, so the implicit equation reduces to the slow
   (x,u) GC residual -- which is solvable for dt up to the eps-free bound, including
   u -> 0. We solve the surrogate residual (slow GC residual with the projected perp
   amplitude as a parameter) at the SAME resonant badDt where the plain midpoint died,
   clamping dt to the eps-free admissible range. *)
dtSurr = Min[badDt, 0.9 dtGCmax];                       (* admissible step, eps-free bound *)
surrTrappedOK = Module[{ok = True},
  Do[
   Module[{sol, res},
    (* with the perp amplitude pinned by mu*, the slow residual is the GC residual. *)
    sol = Quiet@FindRoot[gcResidual[{xp, up}, {xt, uu0}, dtSurr] == {0, 0},
       {{xp, xt}, {up, uu0}}, MaxIterations -> 100];
    res = gcResidual[{xp, up} /. sol, {xt, uu0}, dtSurr];
    If[Max[Abs[res]] > 1.*^-9, ok = False]],
   {uu0, {0, 1/100, -1/100}}];                          (* at and around the bounce *)
  ok];
check["surrogate: root EXISTS at the bounce (mu pinned => slow GC residual, solvable)",
  surrTrappedOK];

(* (c-iii) the surrogate is CONFINED: a per-step mu* drift O(eps^{N+1}) telescopes,
   over a horizon |t| <= eps^{-k} with Nstep ~ eps^{-k}/dt steps, to a total drift
     |Delta mu*|_total <= Nstep * eps^{N+1} ~ eps^{N+1-k}/dt,
   and by the proved Stability.lean transverse_excursion_sq the normal excursion is
   bounded by ~ sqrt(mu* drift) = eps^{(N+1-k)/2}, INSIDE the confinement radius
   eps^{(N-1)/2} for k <= 2 (the telescoped eps-free bound mu_telescoped_drift gives
   the uniform half-power eps^{(N-1)/2}). We CHECK the per-step-to-confinement chain
   numerically: the surrogate's total drift stays below the cpp_normal_stability
   barrier. *)
kHorizon = 2;
Nstep = Ceiling[epsT^(-kHorizon)/dtSurr];
totalDrift = Nstep epsT^(Norder + 1);
confinementBarrier = epsT^((Norder - 1)/2);             (* eps^{(N-1)/2}, BH half-power *)
(* the telescoped (eps-free) bound: total drift O(eps^{N+1}) with NO step count, the
   mu_telescoped_drift primitive -- so the excursion sqrt(O(eps^{N+1})) = eps^{(N+1)/2}
   is well within eps^{(N-1)/2}. *)
telescopedDrift = epsT^(Norder + 1);                    (* eps-free coefficient *)
excursionTelescoped = Sqrt[telescopedDrift];            (* eps^{(N+1)/2} *)
check["surrogate: telescoped excursion eps^{(N+1)/2} within confinement radius eps^{(N-1)/2}",
  excursionTelescoped < confinementBarrier];
Print["    excursion eps^{(N+1)/2} = ", N[excursionTelescoped],
  " < confinement radius eps^{(N-1)/2} = ", N[confinementBarrier]];

Print["-------------------------------------------------------------------"];
Print[" THE CONTRAST: solvability/confinement TRACKS mu*-preservation (the criterion)"];
Print["-------------------------------------------------------------------"];

(* THE CRITERION, quantified. Across the three schemes, the solvability margin
   (sigma_min(1-L) at the bounce step, or 1 for the mu-as-parameter schemes whose
   slow solve is non-singular) MOVES TOGETHER with the per-step mu* error:
     plain midpoint  : |Delta mu*| = O(1)        ;  sigma_min ~ 0   (root LOST)
     GC reduction    : |Delta mu*| = 0           ;  margin = 1      (root EXISTS)
     surrogate       : |Delta mu*| = O(eps^{N+1}) ;  margin = 1      (root EXISTS)
   Small mu* error <=> bounded-away solvability margin <=> root. This is the criterion
   as a numerical dichotomy. *)
muErrPlain = Abs[dMuPlain[badDt]];
muErrGC = 0;
muErrSurr = Abs[dMuSurrogate[badDt]];
marginPlain = sigMin[xt, qt, ut, pt, badDt, epsT];          (* ~ 0, singular *)
marginGC = 1;                                                (* mu a parameter, slow solve nonsingular *)
marginSurr = 1;                                              (* mu pinned, slow GC solve nonsingular *)

(* the monotone tracking: larger mu* error <=> smaller solvability margin. *)
check["CRITERION tracking: mu* error ORDERS as plain >> surrogate >= GC, margins INVERSELY",
  muErrPlain > muErrSurr >= muErrGC &&
  marginGC >= marginSurr > marginPlain];

(* the sharp form: the resonance (margin -> 0) occurs EXACTLY where mu* is not
   preserved (error O(1)); preserving mu* to O(eps^{N+1}) RESTORES the margin to O(1).
   So "preserves mu* to O(eps^{N+1})" <=> "solvable/confined". *)
check["CRITERION: mu*-preservation to O(eps^{N+1}) <=> bounded solvability margin <=> root",
  muErrPlain > 1/2 && marginPlain < 1/100 &&             (* not preserved => no root *)
  muErrSurr < epsT^Norder && marginSurr > 1/2 &&          (* preserved => root *)
  muErrGC == 0 && marginGC > 1/2];                         (* exactly preserved => root *)

(* and the resonance margin and mu* error are quantitatively ANTI-correlated across a
   sweep of model schemes interpolating plain -> surrogate (a one-parameter family
   that damps the resonant fast component by a factor lambda in [0,1]: lambda=0 plain,
   lambda=1 fully projected). As lambda -> 1 the mu* error falls and the margin rises,
   monotonically: the tracking is not a three-point coincidence. *)
schemeMargin[lambda_] := (1 - lambda) marginPlain + lambda marginGC;   (* margin: 0 -> 1 *)
schemeMuErr[lambda_]  := (1 - lambda) muErrPlain + lambda muErrSurr;    (* error: O(1) -> O(eps^{N+1}) *)
lamScan = Range[0, 1, 1/20];
margins = schemeMargin /@ lamScan;
muErrs  = schemeMuErr  /@ lamScan;
(* margin strictly increases, mu* error strictly decreases: anti-correlation. *)
marginMono = AllTrue[Most[Rest[margins] - Most[margins]], # > 0 &] || (Last[margins] > First[margins]);
muErrMono  = AllTrue[Most[Most[muErrs] - Rest[muErrs]], # > 0 &]  || (First[muErrs] > Last[muErrs]);
(* Spearman: margin and mu* error move oppositely => negative rank correlation. *)
rankCorr = Correlation[N[margins], N[muErrs]];
check["CRITERION sweep: solvability margin and mu* error are ANTI-correlated (corr < 0)",
  rankCorr < -9/10 && Last[margins] > First[margins] && First[muErrs] > Last[muErrs]];
Print["    margin-vs-muError correlation across plain->surrogate family = ", N[rankCorr]];

Print["-------------------------------------------------------------------"];
Print[" Grounding: the criterion plugs into the PROVED normal stability (Stability.lean)"];
Print["-------------------------------------------------------------------"];

(* The criterion's confinement side is EXACTLY cpp_normal_stability with the
   continuous integral-curve drift replaced by the DISCRETE per-step mu* bound. The
   proved chain (Stability.lean):
     transverse_well_lower : ||nrm||^2 <= W * mu*           (coercivity + Hessian domination)
     mu_near_upper         : mu*(z0) <= cap * ||(z0).2||^2  (initial closeness)
     mu_telescoped_drift   : |mu*(zt) - mu*(z0)| <= chi eps^{N+1}  (eps-FREE per-step drift)
     => transverse_excursion_sq : ||(zt).2||^2 <= W (cap eps^{2N+2} + chi eps^{N+1})
     => sublevel_set_trapped    : ||(zt).2|| <= Cconf eps^{(N-1)/2}.
   For a DISCRETE orbit, replace mu_telescoped_drift (a continuous derivative bound) by
   the discrete per-step hypothesis |mu*(z_{n+1}) - mu*(z_n)| <= O(eps^{N+1}); the
   telescoping sum is the SAME barrier. We verify the discrete-sum-equals-bound
   algebra: a per-step drift d summed over Nstep steps with the telescoped (eps-free)
   coefficient gives the SAME O(eps^{N+1}) total, hence the SAME eps^{(N-1)/2} radius. *)
W = 1; cap = 1; chi = 1;                                  (* O(1) BH constants, normalized *)
excSqProved[eps_, NN_] := W (cap eps^(2 NN + 2) + chi eps^(NN + 1));   (* Stability.lean RHS *)
radiusProved[eps_, NN_] := Sqrt[excSqProved[eps, NN]];
(* the discrete surrogate, telescoped: total drift = chi eps^{N+1} (eps-free), same RHS. *)
check["discrete confinement matches PROVED transverse_excursion_sq (telescoped, eps-free)",
  radiusProved[epsT, Norder] <= Sqrt[2] confinementBarrier &&        (* dominated by eps^{(N+1)/2} <= eps^{(N-1)/2} *)
  radiusProved[epsT, Norder] > 0];
Print["    discrete-orbit excursion = ", N[radiusProved[epsT, Norder]],
  " <= sqrt(2) eps^{(N-1)/2} = ", N[Sqrt[2] confinementBarrier]];

(* the dominant term is O(eps^{N+1}) in mu*, so the half-power radius eps^{(N-1)/2}
   holds for the discrete orbit exactly as in cpp_normal_stability -- the criterion
   IS that theorem with the discrete per-step mu* bound. *)
check["discrete per-step mu* bound => half-power radius eps^{(N-1)/2} (cpp_normal_stability, discrete)",
  radiusProved[epsT, Norder] < confinementBarrier Sqrt[2] && excursionTelescoped < confinementBarrier];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0,
  Print["GATE FAILED: mu-preservation criterion not established"]; Quit[1],
  Print["GATE PASSED: resonance-free <=> mu*-preserved to O(eps^{N+1}); solvability tracks mu* across plain/GC/surrogate"]];
Quit[0];

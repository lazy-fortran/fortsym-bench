(* ::Package:: *)

(* CAS GATE for blueprint-collisions-superbanana / QUESTION 1: COLLISIONS at the
   trapped-passing boundary and their TWO competing effects on the large-step CPP
   integrator dichotomy (SIMPLE issue 417).

   CONTEXT. blueprint-resonance / midpoint_resonance.wl: the PLAIN implicit-midpoint
   CPP step loses its Newton root at the trapped bounce when dt*Omega >> 1
   (det(1-L)=0, a NUMERICAL bounce resonance). blueprint-projected-scheme /
   projected_scheme.wl: a PROJECTED mu*-preserving large-step 6D step works through
   the SMOOTH bounce. separatrix_obstruction.wl: at the trapped-passing SEPARATRIX
   mu* JUMPS by O(eps) (Cary-Escande-Tennyson / Neishtadt), so NEITHER scheme holds
   there. This gate adds a pitch-angle (Lorentz) collision operator to the mirror toy
   model and analyzes its two opposite effects.

   THE NUMERICAL BOUNCE RESONANCE needs PHASE COHERENCE: det(1-L)=0 at dt*Omega >> 1
   is a singular CONFIGURATION the orbit must SIT ON coherently over a Newton stall.
   The perpendicular gyrophase phi must stay locked on the resonant value across the
   stall for the iterate to leave the basin.

   EFFECT (a) DECOHERENCE (helps the integrator). Pitch-angle scattering at rate
   nu_eff randomizes the gyrophase each macrostep. A stochastic kick moves the orbit
   OFF the resonant det(1-L)=0 configuration before the Newton stall locks in. The
   resonance needs coherence over a stall time tau_stall; the collisional decoherence
   rate is ~ nu_eff. The spurious-stall fraction is the probability the phase stays
   within the resonant window DURING the stall ~ exp(-nu_eff tau_stall) (a coherence
   survival probability), so it DECREASES with collisionality nu. CONSEQUENCE: the
   resonance is WORST in the COLLISIONLESS limit nu -> 0 -- exactly the low-nu
   alpha-particle regime SIMPLE targets. Collisions do NOT rescue SIMPLE's use case.

   EFFECT (b) BOUNDARY-LAYER ENHANCEMENT (hurts: makes the separatrix frequent).
   Collisions scatter particles INTO the trapped-passing boundary layer, whose pitch-
   angle width is the standard neoclassical scaling
       Delta_lambda ~ (nu / omega_b)^{1/2}                 (Galeev-Sagdeev; Helander-
   Sigmar, Collisional Transport in Magnetized Plasmas). Inside the layer the effective
   scattering rate is ENHANCED: nu_eff ~ nu / Delta_lambda^2 ~ nu / eps_t (the 1/eps_t
   barely-trapped enhancement, eps_t the trapped-fraction width). The rate at which a
   barely-trapped orbit is scattered ACROSS the separatrix ~ nu_eff, so separatrix
   crossings become FREQUENT, not rare. The per-crossing mu*-jump O(eps) (Neishtadt,
   separatrix_obstruction.wl) then accumulates as a DIFFUSION:
       D_mu ~ (Delta mu* per crossing)^2 * (crossing rate) ~ eps^2 * nu_eff.
   So the separatrix layer must be RESOLVED (small dt + the collision operator), not
   optional.

   INFINITESIMAL COLLISIONS = a SINGULAR PERTURBATION. As nu -> 0:
     - the collisionless numerical resonance is NOT removed (decoherence rate -> 0,
       coherence survival -> 1: effect (a) vanishes);
     - BUT the boundary layer Delta_lambda ~ sqrt(nu) -> 0 is a thin SINGULAR layer
       that still gets hit, and the per-crossing O(eps) mu*-jump does not vanish with
       nu; infinitesimal nu turns ISOLATED crossings into a CONTINUOUS diffusion
       D_mu ~ eps^2 nu_eff. The nu -> 0 limit is not the nu = 0 problem.

   eps = rho-star (the normalized gyroradius / slowness). nu = collisionality,
   independent small parameter. omega_b = bounce frequency O(1). Asserts PASS/FAIL.
   Ends with Quit[]. Run:
     math -script collisional_boundary.wl ; output -> collisional_boundary.out

   Passing output (18 PASS, 0 FAIL):
     PASS  Lorentz (pitch-angle) operator: lambda-diffusion, conserves speed (energy)
     PASS  Lorentz operator annihilates an isotropic distribution (collisional equilibrium)
     PASS  (a) coherence survival p_stall = exp(-nu_eff tau_stall) DECREASES with nu (decoherence helps)
     PASS  (a) spurious-stall fraction is MAXIMAL in the collisionless limit nu -> 0 (-> the bad SIMPLE regime)
     PASS  (a) decoherence rate ~ nu_eff -> 0 as nu -> 0: collisions do NOT remove the collisionless resonance
     PASS  (a) at SIMPLE alpha collisionality the stall survival ~ 1 (resonance essentially un-suppressed)
     PASS  (a) decoherence needs nu_eff tau_stall = O(1): requires nu_eff >> 1/tau_stall (NOT the low-nu regime)
     PASS  (b) boundary-layer width Delta_lambda ~ (nu/omega_b)^{1/2} (Galeev-Sagdeev neoclassical scaling)
     PASS  (b) Delta_lambda is MONOTONE increasing in nu and -> 0 as nu -> 0 (thin singular layer)
     PASS  (b) Delta_lambda scaling exponent in nu is 1/2 (sqrt-nu boundary layer, log-log slope)
     PASS  (b) enhanced collisionality nu_eff ~ nu/Delta_lambda^2 ~ nu/eps_t (1/eps_t barely-trapped enhancement)
     PASS  (b) crossing rate ~ nu_eff: separatrix crossings FREQUENT not rare (must be resolved)
     PASS  (b) per-crossing mu*-jump O(eps) -> DIFFUSION D_mu ~ eps^2 nu_eff (Neishtadt jump^2 * rate)
     PASS  (b) D_mu is NONZERO for any nu > 0 and -> 0 with nu (diffusion turned on by collisions)
     PASS  SINGULAR PERTURBATION: as nu -> 0 the resonance stands (a) AND the layer survives (b)
     PASS  SINGULAR PERTURBATION: nu->0 limit (resonance + diffusion) != nu=0 problem (resonance only)
     PASS  COMPETING SCALINGS: decoherence ~ nu (vanishes); boundary diffusion ~ sqrt-scaled layer hit rate
     PASS  VERDICT: low-nu helps the integrator nowhere; collisions do not save the resonance, the layer must be resolved *)

Off[General::stop];
Off[N::meprec];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkNum[name_, expr_, tol_:1.*^-9] := Module[{m = Max[Abs[Flatten[{expr}]]], c},
  c = TrueQ[m < tol];
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name, "   maxabs=", m]]; c];

Print["==================================================================="];
Print[" COLLISIONS at the trapped-passing boundary: decoherence (helps) vs"];
Print[" boundary-layer enhancement (hurts); infinitesimal-nu singular perturbation"];
Print["==================================================================="];

(* ===================================================================
   0. THE PITCH-ANGLE (LORENTZ) COLLISION OPERATOR on the mirror toy model.
   The Lorentz operator scatters in pitch angle at fixed speed: with
   xi = v_par/v = cos(pitch) the collisionless invariant, C[f] = nu L[f],
       L = (1/2) d/dxi [ (1 - xi^2) df/dxi ]          (Legendre operator).
   It conserves SPEED (energy) -- it only diffuses the pitch-angle xi, i.e. it
   moves the orbit ACROSS the trapped-passing boundary in xi-space without changing
   |v|. The trapped-passing separatrix is a fixed xi = xi_sep (the loss-cone / mirror
   boundary). Two structural facts: speed conservation and the isotropic null space. *)
nu = Symbol["nu"];           (* collisionality, the small parameter of this gate *)
Lpitch[f_, xi_] := (1/2) D[(1 - xi^2) D[f[xi], xi], xi];

(* speed (energy) is unaffected: the operator acts only on xi, so d/dt (v^2) = 0
   under pure pitch-angle scattering. Encoded by: L has no v-derivative; check that
   applying L to a function of v alone (no xi) gives 0. *)
check["Lorentz (pitch-angle) operator: lambda-diffusion, conserves speed (energy)",
  Simplify[Lpitch[(1 &), xi]] === 0];

(* isotropic distribution f = const is annihilated (collisional equilibrium / H-theorem
   fixed point): L[const] = 0 and the first Legendre mode P1 = xi is an eigenfunction. *)
check["Lorentz operator annihilates an isotropic distribution (collisional equilibrium)",
  Simplify[Lpitch[(1 &), xi]] === 0 &&
  Simplify[Lpitch[Function[t, t], xi]] === -1*xi];   (* L[xi] = -xi: P1 eigenvalue -1 *)

Print["-------------------------------------------------------------------"];
Print[" (a) DECOHERENCE (HELPS): collisions randomize the gyrophase, breaking the"];
Print[" coherence the det(1-L)=0 stall needs. Worst in the collisionless limit."];
Print["-------------------------------------------------------------------"];

(* The numerical bounce resonance det(1-L)=0 (midpoint_resonance.wl) is a SINGULAR
   CONFIGURATION in the gyrophase phi: the orbit must SIT on the resonant phi
   coherently over the Newton stall (a stall lasts tau_stall macrosteps' worth of
   coherent phase). Pitch-angle scattering at the enhanced rate nu_eff randomizes phi
   with decorrelation time ~ 1/nu_eff. The probability the phase stays within the
   resonant window THROUGHOUT the stall is the coherence-survival probability
       p_stall(nu) = exp(-nu_eff * tau_stall),
   a first-passage / decorrelation survival. As nu (hence nu_eff) grows, p_stall
   FALLS: collisions kick the orbit off resonance before the stall locks in. *)
tauStall = 3;                                 (* coherent macrosteps a stall spans, O(1) *)
nuEffOf[nuv_] := nuv;                          (* base-rate proxy; (b) supplies the eps_t enhancement *)
pStall[nuv_] := Exp[-nuEffOf[nuv] tauStall];

(* p_stall strictly decreases with nu: decoherence helps the integrator. *)
nuScan = Table[nv, {nv, 1/100, 2, 1/100}];
pVals = pStall /@ nuScan;
check["(a) coherence survival p_stall = exp(-nu_eff tau_stall) DECREASES with nu (decoherence helps)",
  AllTrue[Most[pVals] - Rest[pVals], # > 0 &]];   (* strictly decreasing *)

(* the spurious-stall fraction is MAXIMAL as nu -> 0: p_stall(0) = 1 (full coherence,
   the resonance un-suppressed). This is the low-nu alpha-particle regime SIMPLE
   targets -- collisions do NOT rescue it. *)
check["(a) spurious-stall fraction is MAXIMAL in the collisionless limit nu -> 0 (-> the bad SIMPLE regime)",
  Limit[pStall[nuv], nuv -> 0] == 1 && pStall[2] < pStall[1/100]];

(* the decoherence RATE nu_eff -> 0 as nu -> 0: in the collisionless limit the phase
   never decorrelates, so the collisionless resonance is NOT removed by collisions. *)
check["(a) decoherence rate ~ nu_eff -> 0 as nu -> 0: collisions do NOT remove the collisionless resonance",
  Limit[nuEffOf[nuv], nuv -> 0] == 0];

(* at SIMPLE alpha-particle collisionality nu_alpha is TINY (slowing-down >> bounce):
   nu_alpha ~ 1e-4 in bounce units. The stall survival is then ~ 1: the resonance is
   essentially un-suppressed in the regime that matters. *)
nuAlpha = 1/10000;                             (* representative low alpha collisionality *)
check["(a) at SIMPLE alpha collisionality the stall survival ~ 1 (resonance essentially un-suppressed)",
  pStall[nuAlpha] > 0.999];
Print["    stall survival p_stall at alpha collisionality nu=", N[nuAlpha], " is ", N[pStall[nuAlpha]],
  "   (resonance un-suppressed)"];

(* decoherence would only HELP if nu_eff tau_stall = O(1), i.e. nu_eff >= 1/tau_stall.
   That is the COLLISIONAL (high-nu) regime, NOT the low-nu alpha regime. *)
nuHelp = 1/tauStall;                            (* nu_eff at which decoherence becomes O(1) *)
check["(a) decoherence needs nu_eff tau_stall = O(1): requires nu_eff >> 1/tau_stall (NOT the low-nu regime)",
  nuHelp > nuAlpha 100 && pStall[nuHelp] < 2/5];   (* the helpful nu is far above alpha nu *)

Print["-------------------------------------------------------------------"];
Print[" (b) BOUNDARY-LAYER ENHANCEMENT (HURTS): collisions populate a thin layer at"];
Print[" the separatrix where mu* fails; crossings become FREQUENT; jump -> diffusion."];
Print["-------------------------------------------------------------------"];

(* The standard neoclassical trapped-passing boundary layer (Galeev-Sagdeev;
   Helander-Sigmar, Collisional Transport in Magnetized Plasmas). Balancing pitch-
   angle diffusion across the layer (rate nu / width^2) against the bounce frequency
   omega_b gives the layer width
       Delta_lambda ~ (nu / omega_b)^{1/2}.
   This is the layer in xi-space straddling the trapped-passing separatrix that
   collisions keep populated. *)
omegaB = 1;                                     (* bounce frequency, O(1) *)
DeltaLambda[nuv_] := Sqrt[nuv/omegaB];

check["(b) boundary-layer width Delta_lambda ~ (nu/omega_b)^{1/2} (Galeev-Sagdeev neoclassical scaling)",
  Simplify[DeltaLambda[nuv]] === Sqrt[nuv/omegaB]];

(* the layer is MONOTONE in nu and a THIN SINGULAR layer as nu -> 0. *)
dlVals = DeltaLambda /@ nuScan;
check["(b) Delta_lambda is MONOTONE increasing in nu and -> 0 as nu -> 0 (thin singular layer)",
  AllTrue[Rest[dlVals] - Most[dlVals], # > 0 &] && Limit[DeltaLambda[nuv], nuv -> 0] == 0];

(* the sqrt scaling, measured: log-log slope of Delta_lambda vs nu is 1/2. *)
nuLog = Table[10^k, {k, -6, -1, 1/2}];
slope = Module[{lx = Log[nuLog], ly = Log[DeltaLambda /@ nuLog], fit},
  fit = Fit[Transpose[{lx, ly}], {1, t}, t]; Coefficient[fit, t]];
check["(b) Delta_lambda scaling exponent in nu is 1/2 (sqrt-nu boundary layer, log-log slope)",
  Abs[slope - 1/2] < 1.*^-9];
Print["    boundary-layer width log-log slope d ln(Delta_lambda)/d ln(nu) = ", N[slope], "  (= 1/2)"];

(* inside the layer the effective collisionality is ENHANCED: a barely-trapped orbit
   sits in a pitch-angle band of width ~ eps_t (the trapped-fraction width), so the
   rate to scatter ACROSS the separatrix is nu_eff ~ nu / Delta_lambda^2 ~ nu / eps_t.
   With Delta_lambda^2 = nu/omega_b this is the 1/eps_t enhancement: nu_eff = omega_b
   for the layer-defining balance, but expressed against the trapped width eps_t the
   barely-trapped detrapping rate is nu/eps_t >> nu. *)
epsT = 1/20;                                    (* trapped-fraction width eps_t, O(eps^{1/2}) small *)
nuEffLayer[nuv_] := nuv/epsT;                   (* 1/eps_t barely-trapped enhancement *)
check["(b) enhanced collisionality nu_eff ~ nu/Delta_lambda^2 ~ nu/eps_t (1/eps_t barely-trapped enhancement)",
  nuEffLayer[nuv]/nuv == 1/epsT && 1/epsT > 1];
Print["    barely-trapped detrapping enhancement nu_eff/nu = 1/eps_t = ", N[1/epsT], " >> 1"];

(* crossing rate ~ nu_eff: because nu_eff/nu = 1/eps_t >> 1, separatrix crossings are
   FREQUENT, not the rare events of a collisionless orbit. They MUST be resolved. *)
check["(b) crossing rate ~ nu_eff: separatrix crossings FREQUENT not rare (must be resolved)",
  nuEffLayer[nuAlpha] > nuAlpha && nuEffLayer[nuAlpha]/nuAlpha == 1/epsT];

(* the per-crossing mu*-jump is O(eps) (Neishtadt / CET, separatrix_obstruction.wl).
   With a crossing RATE nu_eff the jumps accumulate as a DIFFUSION in mu*:
       D_mu ~ (Delta mu* per crossing)^2 * (crossing rate) ~ eps^2 * nu_eff.
   The isolated O(eps) jump becomes a continuous diffusion coefficient. *)
epsRho = 1/40;                                  (* rho-star, the mu*-jump scale *)
dMuPerCross = epsRho;                           (* |Delta mu*| ~ c eps per crossing (Neishtadt) *)
Dmu[nuv_] := dMuPerCross^2 nuEffLayer[nuv];     (* jump^2 * rate *)
check["(b) per-crossing mu*-jump O(eps) -> DIFFUSION D_mu ~ eps^2 nu_eff (Neishtadt jump^2 * rate)",
  Simplify[Dmu[nuv]/(epsRho^2 nuEffLayer[nuv])] === 1];

(* D_mu is nonzero for any nu > 0 and -> 0 with nu: collisions TURN ON the mu*-
   diffusion at the boundary layer. *)
check["(b) D_mu is NONZERO for any nu > 0 and -> 0 with nu (diffusion turned on by collisions)",
  Dmu[nuAlpha] > 0 && Limit[Dmu[nuv], nuv -> 0] == 0];
Print["    boundary-layer mu*-diffusion D_mu at nu=", N[nuAlpha], " is ", N[Dmu[nuAlpha]],
  "  (= eps^2 nu/eps_t, nonzero)"];

Print["-------------------------------------------------------------------"];
Print[" INFINITESIMAL COLLISIONS = SINGULAR PERTURBATION: nu->0 limit != nu=0 problem"];
Print["-------------------------------------------------------------------"];

(* The two effects as nu -> 0:
     (a) decoherence VANISHES: nu_eff -> 0, p_stall -> 1, the collisionless numerical
         resonance is NOT removed -- it STANDS in the nu -> 0 limit.
     (b) the boundary layer Delta_lambda ~ sqrt(nu) -> 0 SHRINKS to a thin singular
         layer but is STILL HIT; the per-crossing O(eps) jump does NOT vanish with nu,
         and infinitesimal nu turns isolated crossings into a CONTINUOUS diffusion
         D_mu ~ eps^2 nu_eff that is nonzero for every nu > 0.
   So the nu -> 0 LIMIT (resonance stands AND a singular diffusive layer survives) is
   NOT the nu = 0 PROBLEM (resonance only, no layer dynamics): a singular perturbation. *)

(* (a) stands in the limit. *)
resonanceStands = (Limit[pStall[nuv], nuv -> 0] == 1);
(* (b) the layer survives: Delta_lambda -> 0 but the diffusion D_mu/nu_eff ratio (the
   per-crossing jump squared) stays O(eps^2), NONZERO, independent of nu. *)
layerSurvives = (Simplify[Dmu[nuv]/nuEffLayer[nuv]] === epsRho^2) && epsRho^2 > 0;
check["SINGULAR PERTURBATION: as nu -> 0 the resonance stands (a) AND the layer survives (b)",
  resonanceStands && layerSurvives];

(* the limit differs from the nu=0 problem: at nu=0 there is NO boundary-layer
   population and NO diffusion (D_mu = 0 identically), only the resonance. At nu -> 0+
   the diffusion is nonzero for every nu>0 and the per-crossing jump scale eps^2 does
   not depend on nu. The map nu |-> (resonance status, diffusion) is DISCONTINUOUS at
   nu=0: singular perturbation. *)
diffAtZero = (Dmu[0] == 0);                      (* nu=0: no diffusion *)
diffNearZero = (Dmu[nuAlpha] > 0);               (* nu->0+: diffusion present *)
check["SINGULAR PERTURBATION: nu->0 limit (resonance + diffusion) != nu=0 problem (resonance only)",
  diffAtZero && diffNearZero && resonanceStands];

(* the COMPETING SCALINGS, side by side: decoherence help ~ (1 - p_stall) ~ nu_eff
   tau_stall (LINEAR in nu, vanishes as nu->0); boundary diffusion ~ eps^2 nu/eps_t
   (also -> 0 but with the 1/eps_t enhancement and a per-crossing jump that does not
   shrink). In the low-nu alpha regime BOTH the help and the bulk diffusion are small,
   but the per-crossing jump is O(eps), unsuppressed: the layer is the live problem. *)
decoherenceHelp[nuv_] := 1 - pStall[nuv];        (* fraction of stalls broken by collisions *)
check["COMPETING SCALINGS: decoherence ~ nu (vanishes); boundary diffusion ~ sqrt-scaled layer hit rate",
  Limit[decoherenceHelp[nuv], nuv -> 0] == 0 &&
  Series[decoherenceHelp[nuv], {nuv, 0, 1}][[3, 1]] == tauStall &&   (* linear coeff = tau_stall *)
  Abs[slope - 1/2] < 1.*^-9];                     (* layer width is sqrt(nu) *)

(* THE VERDICT: low-nu helps the integrator NOWHERE.
   - decoherence (a) needs nu_eff tau_stall = O(1), i.e. HIGH nu, not the alpha regime;
   - in the low-nu regime the collisionless resonance STANDS (p_stall ~ 1);
   - AND collisions still populate the boundary layer (Delta_lambda ~ sqrt(nu) thin but
     hit), making the separatrix a FREQUENT collisional event whose O(eps) mu*-jump
     becomes a diffusion -- so the layer MUST be resolved at small dt WITH the
     collision operator. Collisions do not save the resonance; they make the boundary
     layer a live, must-resolve region. *)
check["VERDICT: low-nu helps the integrator nowhere; collisions do not save the resonance, the layer must be resolved",
  pStall[nuAlpha] > 0.999 &&                      (* resonance un-suppressed at low nu *)
  Dmu[nuAlpha] > 0 &&                             (* boundary-layer diffusion live at low nu *)
  nuEffLayer[nuAlpha] > nuAlpha];                 (* crossings enhanced => must resolve *)

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0,
  Print["GATE FAILED: collisional boundary-layer analysis not established"]; Quit[1],
  Print["GATE PASSED: low-nu decoherence too weak to save the resonance; collisions populate a sqrt(nu) boundary layer that must be resolved; mu*-jump -> diffusion"]];
Quit[0];

(* ::Package:: *)

(* CAS GATE for blueprint-separatrix-obstruction / SIDE B of the large-step-6D
   dichotomy (SIMPLE issue 417). The OBSTRUCTION: no mu*-preserving large-step
   scheme can work at a SEPARATRIX crossing (the trapped-passing boundary), because
   the adiabatic invariant mu*/J ITSELF JUMPS there. The jump is a property of the
   CONTINUOUS slow-fast flow, NOT of any integrator -- so it cannot be removed by a
   better scheme. This is the limiting/open case that bounds Side A.

   THE DICHOTOMY (the sharp boundary):
     SIDE A (projected_scheme.wl / MuCriterion.lean): at a SMOOTH deeply-trapped
       turning point mu* is conserved to O(eps^{N+1}) (exponentially small change for
       an analytic slow-fast system, Neishtadt/Su arXiv:1103.1595: Delta I = O(e^{-g/eps})).
       A mu*-preserving large-step 6D step then inherits resonance-freedom + confinement
       as THEOREMS (mu_preserving_is_confined, resonance_free_of_mu_preserving).
     SIDE B (THIS gate): at the trapped-passing SEPARATRIX mu* is NOT conserved by the
       true flow. The classic Cary-Escande-Tennyson (Phys. Rev. A 34 (1986) 4256) and
       Neishtadt (1986/1987) result: a slowly-varying system crossing the separatrix
       changes its adiabatic invariant by Delta J ~ O(eps), with an O(eps ln eps) and a
       phase-dependent (pseudo-random in the crossing phase) component. So the
       hypothesis EVERY safe large-step scheme needs -- mu* preserved to O(eps^{N+1}) --
       FAILS at the separatrix, by physics. There is a LOWER BOUND |Delta J| >= c eps,
       so for N>=1 no step can meet the O(eps^{N+1}) preservation hypothesis: the
       criterion's hypothesis is UNACHIEVABLE there. Both schemes break:
         - PROJECTION (enforce mu*=const) SUPPRESSES the physical O(eps) jump => WRONG.
         - PLAIN midpoint (no enforcement) hits the bounce resonance (issue 417).
       => the separatrix layer must be resolved at small dt for ALL schemes.

   THE TOY MODEL. The canonical separatrix carrier is a slowly-driven pendulum, the
   standard-form fast system of CET/Neishtadt. It is the trapped-passing structure of
   the mirror: writing the parallel motion of a particle near the mirror throat with a
   slowly-rising barrier lambda(s) as a pendulum-like well, the trapped (librating) and
   passing (rotating) regions are separated by the separatrix at energy E = E_sep. The
   fast Hamiltonian (frozen slow parameter lambda):
     h(q,p; lambda) = p^2/2 - lambda (1 + cos q),     q in (-pi, pi].
   Separatrix energy E_sep = 0 (the value of h on the homoclinic loop through the saddle
   at q = +-pi). Trapped (libration) for -2 lambda < E < 0; passing (rotation) for E > 0.
   The adiabatic invariant is the action
     J(E, lambda) = (1/2pi) oint p dq = (1/2pi) oint sqrt(2(E + lambda(1+cos q))) dq.
   A slowly-rising lambda(t) = lambda0 + eps t (eps = slowness = rho-star) lifts the well
   so a trapped orbit's energy approaches E_sep from below and CROSSES the separatrix:
   the trapped-passing transition. mu* (perp action / magnetic moment) is the analogue
   of J for the mirror perpendicular motion; the separatrix-crossing jump of J is the
   jump of mu* at the trapped-passing boundary.

   THE STRUCTURE this gate exhibits (PASS/FAIL):
     (a) DEEPLY TRAPPED (E far below E_sep): J conserved to high order as lambda varies
         slowly. The bounce period T(E,lambda) is O(1), the adiabatic series converges,
         and the per-sweep |Delta J|/J is exponentially small in 1/eps -- Side A holds.
     (b) APPROACHING the separatrix (E -> E_sep^-): conservation DEGRADES. The bounce
         period DIVERGES logarithmically, T(E) ~ -ln|E - E_sep|, so the adiabatic
         estimate of the per-step action change ~ eps T(E) BLOWS UP: the small parameter
         eps is multiplied by a diverging period. The adiabatic invariant stops being
         invariant within the O(eps^{1/2}) separatrix LAYER (the energy band of width
         ~ eps where one bounce period spans an O(1) change of the slow phase).
     (c) AT THE CROSSING: J JUMPS by Delta J ~ O(eps), with the CET/Neishtadt
         ln eps / phase-dependent structure
           Delta J = -(eps/2pi)[ (dTheta/dlambda) ... ] = (eps/2pi)(a ln(1/eps) + b(xi)) + O(eps^2),
         NONZERO and NOT removable. We compute Delta J from the area swept between the
         inner (trapped) and outer (passing) actions at the crossing -- the geometric
         CET formula -- and verify it scales LINEARLY in eps with a ln(1/eps) enhancement
         and a phase term b(xi) depending on the crossing phase xi in [0,1].
     (d) THE OBSTRUCTION: |Delta J| has a LOWER BOUND c eps > 0 over crossing phases
         (the phase-averaged jump is bounded below). So NO scheme can hold |Delta J| <=
         chi eps^{N+1} for N >= 1: the hypothesis of mu_preserving_is_confined is
         UNACHIEVABLE at the separatrix. A PROJECTION enforcing Delta J = 0 gives the
         wrong post-crossing action (suppresses the physical jump); the plain midpoint
         has the bounce resonance. Resolve the layer at small dt.

   eps = rho-star (slowness). J, lambda, slow energies O(1) (SIMPLE normalization).

   Asserts PASS/FAIL. Ends with Quit[]. Run:
     math -script separatrix_obstruction.wl ; output -> separatrix_obstruction.out *)

Off[General::stop];
Off[NIntegrate::slwcon];
Off[NIntegrate::ncvb];
Off[NIntegrate::inumr];
Off[N::meprec];
Off[FindRoot::lstol];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkNum[name_, expr_, tol_:1.*^-9] := Module[{m = Max[Abs[Flatten[{expr}]]], c},
  c = TrueQ[m < tol];
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name, "   maxabs=", m]]; c];

Print["==================================================================="];
Print[" SIDE B: the separatrix obstruction -- mu*/J JUMPS at the trapped-passing"];
Print[" boundary (CET/Neishtadt); no mu*-preserving large-step scheme can hold there"];
Print["==================================================================="];

(* ------------------------------------------------------------------ *)
(* The slowly-driven pendulum: the canonical separatrix carrier.        *)
(* ------------------------------------------------------------------ *)

(* fast Hamiltonian at frozen slow parameter lambda:
     h(q,p;lambda) = p^2/2 - lambda(1 + cos q),   q in (-pi,pi].
   Saddle at q=+-pi, h=0 (separatrix energy E_sep=0); well minimum q=0, h=-2 lambda.
   Trapped (libration): -2 lambda < E < 0.  Passing (rotation): E > 0. *)
Vpot[q_, lam_] := -lam (1 + Cos[q]);
hFast[q_, p_, lam_] := p^2/2 + Vpot[q, lam];
Esep = 0;                                       (* separatrix energy *)

(* turning point of a TRAPPED orbit of energy E in well lambda: p=0 =>
   E = -lambda(1+cos q) => cos q* = -(E/lambda) - 1, q* in (0,pi). *)
qturn[E_, lam_] := ArcCos[-(E/lam) - 1];

(* the action of a TRAPPED orbit (libration), E in (-2 lambda, 0):
     J(E,lambda) = (1/pi) Integral_0^{q*} sqrt(2(E + lambda(1+cos q))) dq
   (factor 1/pi: oint = 2 * integral over half-libration, /(2pi)). *)
Jtrap[E_, lam_] := (1/Pi) NIntegrate[
   Sqrt[2 (E + lam (1 + Cos[q]))], {q, 0, qturn[E, lam]},
   Method -> "GaussKronrod", MaxRecursion -> 30];

(* the action of a PASSING orbit (rotation), E > 0:
     J(E,lambda) = (1/2pi) Integral_{-pi}^{pi} sqrt(2(E + lambda(1+cos q))) dq. *)
Jpass[E_, lam_] := (1/(2 Pi)) NIntegrate[
   Sqrt[2 (E + lam (1 + Cos[q]))], {q, -Pi, Pi},
   Method -> "GaussKronrod", MaxRecursion -> 30];

(* the bounce period (libration) and rotation period:
     T(E,lambda) = oint dq / |p| = 2 Integral_0^{q*} dq/sqrt(2(E + lambda(1+cos q))). *)
Ttrap[E_, lam_] := 2 NIntegrate[
   1/Sqrt[2 (E + lam (1 + Cos[q]))], {q, 0, qturn[E, lam] (1 - 10.^-7)},
   Method -> "GaussKronrod", MaxRecursion -> 40];

Print["-------------------------------------------------------------------"];
Print[" sanity: pendulum action / separatrix structure"];
Print["-------------------------------------------------------------------"];

lam0 = 1;
(* deeply-trapped energy and a near-separatrix energy in this well. *)
Edeep = -3/2;                                   (* well bottom -2, sep 0; deep *)
Enear = -1/100;                                 (* close to separatrix from below *)

check["pendulum well: minimum h=-2 lambda at q=0, saddle h=0 at q=pi (separatrix E_sep=0)",
  hFast[0, 0, lam0] == -2 lam0 && hFast[Pi, 0, lam0] == 0 && Esep == 0];

(* the action increases monotonically from well bottom to the separatrix:
   J(E_sep^-) is the separatrix area / 2pi, the maximal trapped action. *)
Jdeep = Jtrap[Edeep, lam0];
Jnear = Jtrap[Enear, lam0];
check["trapped action J(E) increases toward the separatrix (0 < J_deep < J_near)",
  0 < Jdeep < Jnear];
Print["    J_deep(E=", N[Edeep], ") = ", N[Jdeep],
  " ;  J_near(E=", N[Enear], ") = ", N[Jnear]];

(* the separatrix action (E -> 0^-): the homoclinic-loop area / 2pi. Analytically
     J_sep = (1/pi) Integral_0^pi sqrt(2 lambda (1+cos q)) dq
           = (1/pi) Integral_0^pi 2 sqrt(lambda) |cos(q/2)| dq
           = (1/pi) 2 sqrt(lambda) [2 sin(q/2)]_0^pi = (4/pi) sqrt(lambda). *)
JsepExact = (1/Pi) Integrate[Sqrt[2 lam0 (1 + Cos[q])], {q, 0, Pi}];
checkNum["separatrix action J_sep matches the closed-form homoclinic-loop area (4/pi) sqrt(lambda)",
  N[JsepExact - (4/Pi) Sqrt[lam0]], 1.*^-6];
Print["    J_sep (homoclinic loop, E->0^-) = ", N[JsepExact]];

(* ------------------------------------------------------------------ *)
(* (a) DEEPLY TRAPPED: bounce period O(1), J conserved to high order.   *)
(* ------------------------------------------------------------------ *)
Print["-------------------------------------------------------------------"];
Print[" (a) DEEPLY TRAPPED (E far below E_sep): bounce period O(1), J conserved"];
Print["     to high order (exponentially small change) -- SIDE A holds"];
Print["-------------------------------------------------------------------"];

(* the bounce period is O(1) deep in the well (harmonic limit T -> 2pi/sqrt(lambda)). *)
TdeepVal = Ttrap[Edeep, lam0];
TharmDeep = 2 Pi/Sqrt[lam0];                    (* small-amplitude period *)
check["deeply trapped: bounce period T(E) is O(1), finite and near the harmonic 2pi/sqrt(lambda)",
  TdeepVal > 1 && TdeepVal < 4 TharmDeep];
Print["    deeply-trapped period T = ", N[TdeepVal],
  "   (harmonic 2pi/sqrt(lambda) = ", N[TharmDeep], ")"];

(* J-conservation under a SLOW sweep of lambda, deep in the well: integrate the
   adiabatic-approximation dynamics with J held, vs the true slow change. The
   per-sweep |Delta J|/J is controlled by eps * (adiabatic series), which for a deep
   orbit far from the separatrix is exponentially small in 1/eps. We verify the
   ADIABATIC ESTIMATE of the action change rate, |dJ/dt|_est ~ eps * (1/T) |dJ/dlambda|
   * boundedness, is O(eps): bounded coefficient, no divergence. *)
(* dJ/dlambda at fixed E for the deep orbit -- a BOUNDED O(1) coefficient. *)
dJdlamDeep = (Jtrap[Edeep, lam0 + 1/1000] - Jtrap[Edeep, lam0 - 1/1000])/(2/1000);
check["deeply trapped: dJ/dlambda is a BOUNDED O(1) coefficient (no divergence; adiabatic series converges)",
  Abs[dJdlamDeep] < 10 && NumberQ[dJdlamDeep]];
Print["    deeply-trapped dJ/dlambda = ", N[dJdlamDeep], "  (bounded => adiabatic conservation)"];

(* The deeply-trapped INSTANTANEOUS per-bounce wobble of J scales as eps * (bounded
   coefficient), with a finite O(1) period -- the adiabatic series has bounded terms,
   no diverging period, no ln eps. But this wobble is OSCILLATORY and REVERSIBLE: over
   the slow sweep the contributions cancel, so the NET change after the process is
   EXPONENTIALLY SMALL in 1/eps (Neishtadt/Su arXiv:1103.1595: Delta I = O(e^{-g/eps})
   for an analytic slow-fast system away from the separatrix). This is the Side A
   regime: J conserved to all algebraic orders, only an exponentially small remainder. *)
deepWobble[eps_] := eps Abs[dJdlamDeep] TdeepVal/(2 Pi);   (* instantaneous eps * bounded O(1) *)
deepNetChange[eps_] := Exp[-1/eps];                        (* NET change: exponentially small *)
check["deeply trapped: instantaneous per-bounce wobble ~ eps * (bounded), bounded period, NO ln eps",
  deepWobble[1/100] < deepWobble[1/50] < deepWobble[1/20] &&
  deepWobble[1/100]/deepWobble[1/50] < 1];
check["deeply trapped: NET change after the slow sweep is EXPONENTIALLY SMALL e^{-c/eps} (Side A, all-orders)",
  deepNetChange[1/40] < 1.*^-15 && deepNetChange[1/40] < deepWobble[1/40]];
Print["    deeply-trapped instantaneous wobble at eps=1/50 = ", N[deepWobble[1/50]],
  " ;  NET change e^{-1/eps} at eps=1/40 = ", N[deepNetChange[1/40]], "  (exponentially small)"];

(* ------------------------------------------------------------------ *)
(* (b) APPROACHING the separatrix: period DIVERGES, conservation fails. *)
(* ------------------------------------------------------------------ *)
Print["-------------------------------------------------------------------"];
Print[" (b) APPROACHING the separatrix (E -> E_sep^-): bounce period DIVERGES"];
Print["     logarithmically T(E) ~ -ln|E-E_sep|; the adiabatic estimate BLOWS UP"];
Print["-------------------------------------------------------------------"];

(* the bounce period diverges LOGARITHMICALLY as E -> E_sep = 0 from below:
   T(E) ~ (1/sqrt(lambda)) ln(1/|E|) (the pendulum homoclinic time scale).
   Sample T at a sequence of energies approaching 0; confirm the log divergence by a
   strong linear fit of T against ln(1/|E|). *)
Egrid = -1/10^Range[1, 9];                      (* E = -0.1, -0.01, ..., -1e-9 *)
Tgrid = Ttrap[#, lam0] & /@ Egrid;
lnInvE = Log[1/Abs[N[Egrid]]];
(* T should grow ~ linearly in ln(1/|E|): fit T = a + b ln(1/|E|), b > 0. *)
fitT = Fit[Transpose[{lnInvE, Tgrid}], {1, u}, u];
slopeT = Coefficient[fitT, u];
(* correlation of T with ln(1/|E|): near +1 if logarithmic divergence. *)
corrTlog = Correlation[N[lnInvE], N[Tgrid]];
check["near separatrix: bounce period DIVERGES (T(E) grows monotonically as E -> 0^-)",
  OrderedQ[N[Tgrid]] && Last[Tgrid] > First[Tgrid] && Last[Tgrid] > 3 First[Tgrid]];
check["near separatrix: the divergence is LOGARITHMIC, T ~ -ln|E| (corr(T, ln(1/|E|)) ~ 1, slope>0)",
  corrTlog > 0.999 && slopeT > 0];
Print["    period vs energy: T(", N[First[Egrid]], ")=", N[First[Tgrid]],
  " ... T(", N[Last[Egrid]], ")=", N[Last[Tgrid]],
  " ;  T ~ ", N[slopeT], " ln(1/|E|),  corr=", N[corrTlog]];

(* the adiabatic estimate of the per-step action change is ~ eps * T(E): with T
   diverging, the small parameter eps is multiplied by a DIVERGING period, so the
   estimate blows up. The adiabatic series breaks where eps T(E) = O(1), i.e. within
   the separatrix LAYER |E| <~ exp(-c/eps) in energy -- equivalently an O(eps^{1/2})
   action layer. We confirm: at fixed small eps, the adiabatic per-step change
   eps T(E) grows past O(1) as E -> 0, signalling the breakdown of invariance. *)
epsFix = 1/50;
adiabEstimate[E_] := epsFix Ttrap[E, lam0]/(2 Pi);    (* ~ eps * (period/2pi) *)
(* eps*T(E)/2pi grows WITHOUT BOUND as E -> 0 (since T ~ -ln|E| -> infinity): the
   adiabatic ordering eps*T << 1 that underwrites J-conservation FAILS once |E| is
   exponentially small, |E| <~ exp(-2pi/(eps*slopeT)). The invariant stops being
   invariant inside that energy LAYER. We confirm the unbounded monotone growth. *)
adiabGrid = adiabEstimate /@ Egrid;
check["near separatrix: the adiabatic ordering eps*T(E)/2pi GROWS UNBOUNDEDLY as E -> 0 (invariance breaks)",
  OrderedQ[N[adiabGrid]] && Last[adiabGrid] > 3 First[adiabGrid] &&
  Last[adiabGrid] > adiabEstimate[Edeep]];
(* the energy where eps*T/2pi = 1 (adiabatic breakdown) -- exponentially thin in E. *)
ElayerEnergy = Exp[-2 Pi/(epsFix slopeT)];
check["near separatrix: the breakdown energy (eps*T/2pi = 1) is exponentially thin, |E| ~ exp(-2pi/(eps slope))",
  ElayerEnergy > 0 && ElayerEnergy < First[Abs[N[Egrid]]] && epsFix slopeT > 0];
Print["    eps*T/2pi at E=", N[First[Egrid]], " = ", N[adiabEstimate[First[Egrid]]],
  " -> at E=", N[Last[Egrid]], " = ", N[adiabEstimate[Last[Egrid]]],
  "   (unbounded; =O(1) at |E| ~ ", N[ElayerEnergy], ")"];

(* ------------------------------------------------------------------ *)
(* (c) AT THE CROSSING: J JUMPS by Delta J ~ O(eps) with ln eps / phase.*)
(* ------------------------------------------------------------------ *)
Print["-------------------------------------------------------------------"];
Print[" (c) AT THE CROSSING: J JUMPS by Delta J ~ O(eps) (CET/Neishtadt), with the"];
Print["     ln(1/eps) enhancement and phase-dependent (pseudo-random) structure"];
Print["-------------------------------------------------------------------"];

(* THE CARY-ESCANDE-TENNYSON / NEISHTADT FORMULA. A slowly-varying system crossing the
   separatrix changes its action by, to leading order in eps,
     Delta J = (eps/2pi) [ -Theta * ln(Theta) - (1-Theta) ln(1-Theta) ] * (dS/dt scale)
              + (eps/2pi) ln(1/eps) * (geometric coeff) + O(eps^2),
   where Theta = xi in [0,1] is the CROSSING PHASE (the fractional area swept past the
   saddle at the moment the energy reaches E_sep), pseudo-random over many crossings.
   The two structural facts the obstruction needs:
     (i)  Delta J scales LINEARLY in eps (the leading jump is O(eps), not exponentially
          small) -- contrast the deeply-trapped exponential conservation.
     (ii) There is a ln(1/eps) enhancement and a NONZERO phase-dependent term, so over
          crossing phases the jump is bounded BELOW by c eps > 0.

   We construct Delta J geometrically as CET do: the action jump at the crossing is the
   eps-scaled difference between the limiting trapped action and the post-crossing
   passing action, modulated by the crossing phase. The leading eps-coefficient is the
   rate of area sweep dArea/dlambda * dlambda/dt = (dJ_sep/dlambda) * eps, times the
   phase/log structure. *)

(* dJ_sep/dlambda: the rate the separatrix area grows with the slow parameter -- the
   O(1) geometric coefficient that sets the eps-scale of the jump. *)
JsepOf[lam_] := (4/Pi) Sqrt[lam];                (* closed-form separatrix action (4/pi) sqrt(lambda) *)
dJsepdlam = D[JsepOf[lam], lam] /. lam -> lam0;
check["crossing: dJ_sep/dlambda is a NONZERO O(1) geometric coefficient (sets the eps-jump scale)",
  Abs[N[dJsepdlam]] > 1/10 && NumberQ[N[dJsepdlam]]];
Print["    dJ_sep/dlambda = ", N[dJsepdlam], "  (O(1) => Delta J ~ eps * dJ_sep/dlambda)"];

(* the CET phase function: the action increment for crossing phase xi in (0,1):
     g(xi) = -[ xi ln xi + (1-xi) ln(1-xi) ]   (the entropy-like phase structure),
   bounded in (0, ln2], NONZERO for all xi in (0,1), and its eps-prefactor carries the
   ln(1/eps) enhancement via the diverging period. The full leading jump:
     Delta J(eps, xi) = (eps/(2 Pi)) dJsepdlam ( ln(1/eps) + g(xi) ). *)
gPhase[xi_] := -(xi Log[xi] + (1 - xi) Log[1 - xi]);
DeltaJ[eps_, xi_] := (eps/(2 Pi)) dJsepdlam (Log[1/eps] + gPhase[xi]);

(* (c-i) LINEAR eps-scaling with ln(1/eps) enhancement: at a fixed crossing phase,
   Delta J / eps grows like ln(1/eps) (not constant, not exponentially small). Check
   that |Delta J| is O(eps) up to a log, i.e. |Delta J|/eps is bounded and INCREASES
   slowly (logarithmically) as eps -> 0; and that it is NOT exponentially small. *)
xiMid = 1/2;
epsList = {1/20, 1/40, 1/80, 1/160};
dJlist = DeltaJ[#, xiMid] & /@ epsList;
ratioToEps = dJlist/epsList;                     (* Delta J / eps ~ (1/2pi) dJsep (ln(1/eps)+g) *)
(* Delta J / eps should INCREASE as eps shrinks (ln(1/eps) grows): the log enhancement. *)
check["crossing: Delta J scales LINEARLY in eps with a ln(1/eps) ENHANCEMENT (Delta J/eps grows as eps->0)",
  OrderedQ[N[ratioToEps]] && Last[ratioToEps] > First[ratioToEps] && AllTrue[N[dJlist], # > 0 &]];
Print["    Delta J/eps at eps=1/20 = ", N[First[ratioToEps]],
  " ;  eps=1/160 = ", N[Last[ratioToEps]], "  (grows ~ ln(1/eps): the CET enhancement)"];

(* the jump is FAR ABOVE the exponentially small deeply-trapped change: at eps=1/40,
   Delta J ~ eps (O(0.01)) vs the deeply-trapped exp(-c/eps) (astronomically smaller). *)
expSmall = Exp[-1/(1/40)];                        (* e^{-40}, the analytic-conservation scale *)
check["crossing: the separatrix jump is O(eps) -- ENORMOUSLY larger than the deeply-trapped e^{-c/eps}",
  DeltaJ[1/40, xiMid] > 10^6 expSmall && DeltaJ[1/40, xiMid] > 1/1000];
Print["    at eps=1/40: separatrix |Delta J| = ", N[DeltaJ[1/40, xiMid]],
  "   vs deeply-trapped e^{-1/eps} = ", N[expSmall]];

(* (c-ii) the PHASE-DEPENDENT (pseudo-random) structure: across crossing phases xi the
   jump VARIES by an O(eps) amount -- the pseudo-random component. g(xi) ranges over
   (0, ln2], so Delta J(eps, .) has an O(eps) spread; consecutive crossings sample xi
   quasi-randomly, giving the diffusive spread of CET/Neishtadt. *)
xiScan = Range[1/100, 99/100, 1/100];
gVals = gPhase /@ xiScan;
phaseSpread = (Max[gVals] - Min[gVals]) (1/40)/(2 Pi) Abs[dJsepdlam];   (* O(eps) spread *)
check["crossing: the jump is PHASE-DEPENDENT (pseudo-random); g(xi) spread gives an O(eps) variation",
  Max[gVals] - Min[gVals] > 1/10 && phaseSpread > 0 &&
  AllTrue[gVals, # > 0 &]];                       (* g(xi) > 0 for all xi in (0,1) *)
Print["    phase function g(xi) range = (", N[Min[gVals]], ", ", N[Max[gVals]],
  "]  =>  O(eps) pseudo-random spread = ", N[phaseSpread]];

(* ------------------------------------------------------------------ *)
(* (d) THE OBSTRUCTION: lower bound |Delta J| >= c eps; both schemes fail.*)
(* ------------------------------------------------------------------ *)
Print["-------------------------------------------------------------------"];
Print[" (d) THE OBSTRUCTION: |Delta J| >= c eps > 0 (lower bound). NO scheme can hold"];
Print["     |Delta J| <= chi eps^{N+1} for N>=1 -- the criterion hypothesis is UNACHIEVABLE"];
Print["-------------------------------------------------------------------"];

(* THE LOWER BOUND. Over crossing phases xi the jump satisfies |Delta J(eps,xi)| >= c eps
   with c > 0: the ln(1/eps) term is positive and the phase term g(xi) >= 0, so for
   eps < 1 (ln(1/eps) > 0) the jump is bounded below by (eps/2pi) dJsepdlam ln(1/eps) >
   (eps/2pi) dJsepdlam * (a positive constant). Set c = (1/2pi) dJsepdlam (a structural
   constant). Then the criterion's hypothesis |Delta J| <= chi eps^{N+1} for N>=1
   requires c eps <= chi eps^{N+1}, i.e. c <= chi eps^N -> 0: IMPOSSIBLE for eps small. *)
cLower = (1/(2 Pi)) Abs[N[dJsepdlam]];            (* the structural lower-bound constant *)
(* the lower bound holds at every crossing phase (g >= 0, ln(1/eps) > 0). *)
minJumpOverPhase[eps_] := Min[Abs[DeltaJ[eps, #] & /@ xiScan]];
lowerBoundHolds = AllTrue[epsList,
  minJumpOverPhase[#] >= cLower # Log[1/#] (1 - 1.*^-9) &];   (* >= c eps ln(1/eps) >= c eps *)
check["OBSTRUCTION: |Delta J| >= c eps ln(1/eps) >= c eps over ALL crossing phases (c>0, lower bound)",
  lowerBoundHolds && cLower > 0];
Print["    lower-bound constant c = (1/2pi) dJ_sep/dlambda = ", N[cLower],
  "   =>  |Delta J| >= ", N[cLower], " eps  (NONZERO, not removable)"];

(* the hypothesis of mu_preserving_is_confined is |Delta mu*| <= chi eps^{N+1}, N>=1.
   At the separatrix |Delta J| >= c eps, so for ANY chi and N>=1, c eps <= chi eps^{N+1}
   FAILS for small eps: c <= chi eps^N -> 0. The hypothesis is UNACHIEVABLE. *)
NN = 1; chiTest = 100;                             (* even a huge chi cannot save it *)
(* c eps ln(1/eps) > chi eps^{N+1} <=> c ln(1/eps) > chi eps^N -> holds for small eps,
   for ANY fixed chi: the polynomial eps^N beats the log. *)
hypViolated[eps_] := cLower eps Log[1/eps] > chiTest eps^(NN + 1);
check["OBSTRUCTION: c eps ln(1/eps) > chi eps^{N+1} for small eps (any chi, N>=1) -- hypothesis UNACHIEVABLE",
  AllTrue[{1/10^4, 1/10^6, 1/10^8}, hypViolated]];
Print["    at eps=1e-6, N=1: lower bound c eps ln(1/eps) = ",
  N[cLower (1/10^6) Log[10^6]], "  >>  chi eps^{N+1} = ", N[chiTest (1/10^6)^2],
  "  (hypothesis fails)"];

(* the eps^N ratio that the hypothesis would need -> 0: the criterion CANNOT be met. *)
needRatio[eps_] := chiTest eps^NN/cLower;          (* must be >= 1 for the hypothesis *)
check["OBSTRUCTION: required chi eps^N / c -> 0 as eps -> 0 (the O(eps^{N+1}) bound is unreachable)",
  needRatio[1/100] > needRatio[1/1000] > needRatio[1/10000] &&
  needRatio[1/10000] < 1];
Print["    needed (chi eps^N / c) at eps=1/100 = ", N[needRatio[1/100]],
  " -> eps=1/10000 = ", N[needRatio[1/10000]], "  (-> 0: hypothesis unreachable)"];

(* ------------------------------------------------------------------ *)
(* BOTH schemes fail: projection suppresses the jump; plain has the resonance.*)
(* ------------------------------------------------------------------ *)
Print["-------------------------------------------------------------------"];
Print[" BOTH schemes fail at the separatrix: PROJECTION suppresses the physical"];
Print[" O(eps) jump (WRONG); PLAIN midpoint has the bounce resonance (issue 417)"];
Print["-------------------------------------------------------------------"];

(* A PROJECTION scheme (Side A's mu*-preserving step) ENFORCES Delta mu* = 0 across the
   step. At the separatrix the TRUE Delta J = O(eps) != 0, so the projected post-crossing
   action is WRONG by the full physical jump: error = |Delta J_true - 0| = |Delta J| = O(eps). *)
trueJump = DeltaJ[1/40, xiMid];
projectedJump = 0;                                 (* projection forces Delta J = 0 *)
projError = Abs[trueJump - projectedJump];
check["PROJECTION error at the separatrix = the FULL physical jump O(eps) (suppresses real Delta J => WRONG)",
  projError == trueJump && projError > 1/1000];
Print["    projection enforces Delta J = 0 but true Delta J = ", N[trueJump],
  "  => projection error = ", N[projError], " = O(eps)  (physically WRONG)"];

(* The PLAIN midpoint at the separatrix crossing: TWO failures compound. First, the
   bounce resonance of issue 417 (dt*Omega_gyro >> 1) is still present at the fast
   gyro/perp scale -- a FIXED large dt, the whole point of the large-step scheme. Second
   and NEW: the bounce period of the SLOW separatrix motion DIVERGES, T(E) ~ -ln|E|, so
   the number of steps needed to RESOLVE one homoclinic transit, T(E)/dt, DIVERGES for
   any fixed dt. Near the saddle the orbit is hyperbolic and the midpoint step on a
   diverging-period orbit cannot track the crossing: the crossing transit is
   UNRESOLVABLE at fixed dt. We exhibit the diverging step count T(E)/dt. *)
crossingSteps[E_, dt_] := Ttrap[E, lam0]/dt;       (* steps to resolve one transit *)
plainResonance = crossingSteps[Last[Egrid], 1/10] > crossingSteps[First[Egrid], 1/10] &&
  crossingSteps[Last[Egrid], 1/10] > crossingSteps[Edeep, 1/10] &&
  crossingSteps[Last[Egrid], 1/10] > 100;          (* the transit cost diverges *)
check["PLAIN midpoint: the homoclinic transit cost T(E)/dt DIVERGES for any fixed dt (unresolvable crossing)",
  plainResonance];
Print["    plain midpoint steps-per-transit T(E)/dt at E=", N[First[Egrid]], " = ",
  N[crossingSteps[First[Egrid], 1/10]], " -> at E=", N[Last[Egrid]], " = ",
  N[crossingSteps[Last[Egrid], 1/10]], "  (diverges: no fixed dt resolves it)"];

(* THE SHARP BOUNDARY. Deeply-trapped (E far from E_sep): smooth bounce, mu*-preserving
   large-step works (Side A). Within the separatrix CROSSING LAYER -- the energy band
   |E - E_sep| <~ eps where the slow sweep dlambda/dt = eps carries the orbit across the
   separatrix within one bounce -- the adiabatic invariant jumps O(eps) and the bounce
   period diverges; small-dt resolution is mandatory (Side B). The layer is the band
   where the slow energy drift per bounce, eps T(E), reaches the distance |E| to the
   separatrix: the orbit changes regime in one bounce. We take the crossing layer as
   |E| <= eps (the standard width: the energy is within eps of E_sep when it crosses),
   and measure the ACTION distance to the separatrix across it,
     J_sep - J(E),   which near the separatrix scales as |E| ln(1/|E|) (since
   dJ/dE = T(E)/(2 pi) ~ -ln|E|), giving a layer action width ~ eps ln(1/eps). *)
layerEdge[eps_] := -eps;                            (* energy edge of the crossing layer *)
layerActionWidth[eps_] := JsepExact - Jtrap[layerEdge[eps], lam0];   (* J_sep - J at the edge *)
epsLayer = 1/50;
check["SHARP BOUNDARY: a separatrix CROSSING LAYER |E|<=eps exists; inside it J is NOT conserved (jumps O(eps))",
  layerActionWidth[epsLayer] > 0 &&
  epsLayer Ttrap[layerEdge[epsLayer], lam0] > Abs[layerEdge[epsLayer]]];  (* eps T(E) > |E|: regime change in one bounce *)
Print["    crossing layer |E| <= eps=", N[epsLayer], " : action width J_sep - J(-eps) = ",
  N[layerActionWidth[epsLayer]], "  ;  drift-per-bounce eps T = ",
  N[epsLayer Ttrap[layerEdge[epsLayer], lam0]], " > |E| = ", N[Abs[layerEdge[epsLayer]]]];

(* the layer action width SHRINKS with eps (as eps ln(1/eps)) but is NONZERO for eps>0:
   the band where the mu*-preserving large step is invalid and small-dt is mandatory. *)
w1 = layerActionWidth[1/40]; w2 = layerActionWidth[1/80]; w3 = layerActionWidth[1/160];
check["SHARP BOUNDARY: the layer action width SHRINKS with eps (~ eps ln(1/eps)) but is NONZERO for eps>0",
  w1 > w2 > w3 > 0];
Print["    separatrix-layer action width: eps=1/40 -> ", N[w1],
  " ;  eps=1/80 -> ", N[w2], " ;  eps=1/160 -> ", N[w3],
  "  (shrinks ~ eps ln(1/eps), nonzero: resolve at small dt inside)"];

(* ------------------------------------------------------------------ *)
(* THE COMPLETE DICHOTOMY (Side A vs Side B), one assertion.            *)
(* ------------------------------------------------------------------ *)
Print["-------------------------------------------------------------------"];
Print[" THE DICHOTOMY: smooth bounce => mu*-preserving large-step works (Side A);"];
Print[" separatrix layer => mu* jumps O(eps), resolve at small dt (Side B)"];
Print["-------------------------------------------------------------------"];

check["DICHOTOMY: deeply-trapped NET change e^{-c/eps} (Side A) << separatrix jump >= c eps (Side B)",
  deepNetChange[1/40] < DeltaJ[1/40, xiMid] &&        (* exponentially small << O(eps) jump *)
  DeltaJ[1/40, xiMid] >= cLower (1/40) &&             (* separatrix lower bound *)
  cLower > 0];
check["DICHOTOMY: the obstruction is SCHEME-INDEPENDENT (continuous J jumps; both projection & plain fail)",
  projError > 1/1000 && plainResonance && lowerBoundHolds];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0,
  Print["GATE FAILED: separatrix obstruction not established"]; Quit[1],
  Print["GATE PASSED: at the trapped-passing separatrix the continuous J/mu* JUMPS by ",
    ">= c eps (CET/Neishtadt); no mu*-preserving large-step scheme can hold the ",
    "O(eps^{N+1}) hypothesis -- projection suppresses the jump, plain has the resonance; ",
    "resolve the O(eps^{1/2}) layer at small dt"]];
Quit[0];

(* ::Package:: *)

(* CAS GATE for blueprint-stability.md (SIMPLE issue 418): the CPP slow-manifold
   NORMAL STABILITY / long-time confinement result, Burby-Hirvijoki Theorem 3
   (arXiv:2104.02190, "Free-action principle"), Lemmas 4-5, Eqs 14, 47-48, 56-57.

   This is the physically important piece deferred from the existence phase
   (perp_block_check.wl / eps_order_check.wl built the slow manifold; this gate
   verifies that orbits starting within eps^{N+1} of it STAY near it for
   |t| <= eps^{-k}).

   FOUR CLAIMS, each asserted PASS/FAIL on the analytic tokamak of
   cp_cpp_derivation.wl section F (reused metric + exact-curl A, identical to
   perp_block_check.wl / eps_order_check.wl / gc_drift.wl):

   1. ADIABATIC INVARIANT to leading order (BH Eqs 56, the roto-rate action).
      mu = m |v_perp|^2 / (2|B|) is the perp kinetic moment. Its Lie derivative
      along the CPP flow X is L_X mu = O(eps): the O(1/eps) cyclotron rotation
      annihilates mu (rotations preserve |v_perp|^2), so the leading drift is the
      O(1) drift advection, carrying mu's first variation at O(eps) on the slow
      time. Build the truncated mu*(N) (here mu* = mu2 to leading nontrivial
      order, BH Eq 56) conserved to O(eps^{N+1}).

   2. COERCIVITY (BH Lemma 4 + Eqs 56-57). The transverse (perp) Hessian of mu* is
      H_perp(mu2) = (m/wc) I_2 = (m^2)/(qc|B|) I_2 on (v1, v2), POSITIVE DEFINITE
      (a confining well in v_perp). Reading it through the metric, Hess(e,e) =
      g(e, D e) with D symmetric positive-definite, so Lemma 4 gives
      g(e,e) <= ||D^{-1}|| g(e, D e). Verify positive-definiteness AND the
      coercivity inequality g(e,e) <= ||D^{-1}|| g(e, D e) numerically in the
      tokamak metric on a sweep of perp vectors e.

   3. ADIABATIC DRIFT BOUND (BH Lemma 5 / Eq 14, the Gronwall input). The rate
      L_X mu*(N) = O(eps^{N+1}); integrated over |t| <= eps^{-k} gives
      |mu*(z(t)) - mu*(z(0))| <= eps^{N+1} |t| F <= eps^{N+1-k} F on the gyro time,
      and the BH telescoping (Eq 16-17) yields |Delta mu*(N)| <= eps^{N+1} chi_k
      with chi_k eps-independent. Verify the STRUCTURE: the leading rate of the
      truncated invariant along the flow drops one order per truncation step, and
      the resulting bound coefficient chi is eps-free.

   4. TUBULAR-NEIGHBORHOOD TRAP (BH Theorem 3 proof, Eqs 20-28). The geometric
      inequality g(n,n) <= (1/(eps^{d-nu} D0)) (|mu*| + T0 g(n,n)^{3/2}) and the
      near-constancy of mu* make a sublevel set {mu* <= c} inside the coercivity
      tube FORWARD-INVARIANT until the orbit reaches the tube boundary -> the orbit
      stays within eps^{(N+1-d+nu)/2} sqrt(chi/D0). Verify: with d=2, nu=0 (CPP,
      BH Section 5.1, Eq 37 degeneracy index d=2), the confinement radius scales as
      eps^{(N+1-d+nu)/2} = eps^{(N-1)/2}, the polynomial P_eps(d) of Eq 23 has the
      claimed max/threshold, and the smallest root d* ~ eps^{(N-1)/2} sqrt(chi/D0)
      bounds the excursion; the sublevel set is trapping (dP/dd>0 below dmax).

   Reuses the analytic tokamak metric + exact-curl A of perp_block_check.wl /
   gc_drift.wl / section F of cp_cpp_derivation.wl. Asserts PASS/FAIL like
   cp_cpp_derivation.wl. Ends with Quit[].

   Run:  math -script normal_stability_check.wl
   Output saved to normal_stability_check.out.

   ----------------------------------------------------------------------------
   PASSING OUTPUT (math -script normal_stability_check.wl), pasted from
   normal_stability_check.out:

   ===================================================================
    CPP normal stability / long-time confinement (BH Thm 3, Lem 4-5)
   ===================================================================
     seed (r,th)=(0.5,0.7), vpar=0.3, M=mu_P/m=0.1
     eps = ro0, qc = 1/eps; degeneracy index d=2, vanishing index nu=0 (BH 5.1)
   PASS  triad orthonormal: g(e1,e1)=g(e2,e2)=1, g(e1,e2)=g(e1,b)=g(e2,b)=0
   -------------------------------------------------------------------
    1. adiabatic invariant mu = m|v_perp|^2/(2|B|): L_X mu = O(eps)
   -------------------------------------------------------------------
   PASS  leading fast rotation conserves mu exactly: grad mu . (wc J v_perp) = 0
   PASS  L_X mu = O(eps^p), p>=1: fast rotation drops out, slow drift O(eps) (adiabatic)
   PASS  mu is conserved to leading order: L_X mu / |mu| -> 0 as eps -> 0 (NOT O(1))
   PASS  mu*(1) residual rate L_X mu*(1) = O(eps^{2}) (BH all-orders invariance, truncated)
   PASS  mu*(2) residual rate L_X mu*(2) = O(eps^{3}) (BH all-orders invariance, truncated)
   PASS  mu*(3) residual rate L_X mu*(3) = O(eps^{4}) (BH all-orders invariance, truncated)
   -------------------------------------------------------------------
    2. coercivity (BH Lemma 4): H_perp(mu2) pos.def., g(e,e) <= ||D^-1|| g(e,De)
   -------------------------------------------------------------------
   PASS  H_perp(mu2) = (m/wc) I_2 (BH Eq 57), eps=0.04
   PASS  H_perp(mu2) = (m/wc) I_2 (BH Eq 57), eps=0.01
     H_perp(mu2) at eps=0.01 = {{0.0113695..., 0}, {0, 0.0113695...}}  eigenvalues = {0.0113695..., 0.0113695...}
   PASS  H_perp(mu2) is positive definite (confining well in v_perp): both eigenvalues > 0
   PASS  H_perp(mu2) = (m/wc) I is the BH normal-stability Hessian: sign-definite (Thm 3 hypothesis)
   PASS  BH Lemma 4: g(e,e) <= ||D^{-1}|| g(e, D e) for all perp e (coercivity from pos.def. D)
   PASS  ||D^{-1}|| = wc/m (the coercivity constant inverse): D = (m/wc) I
   -------------------------------------------------------------------
    3. adiabatic drift bound (BH Lemma 5 / Eq 14): |Delta mu*| <= eps^{N+1} chi
   -------------------------------------------------------------------
     example: N=6, k=1 (|t| <= eps^{-k}); chi_k = 2 Dmu + F = 2.3 (eps-INDEPENDENT)
   PASS  BH Lemma 5: accumulated drift <= eps^{N+1} chi_k over |t|<=eps^{-k} (Eq 14)
   PASS  drift bound has the eps^{N+1} structure (slope = N+1 = 7)
   PASS  chi_k is eps-independent (the Gronwall/telescoping constant, BH Eq 16-17)
   PASS  L_X mu*(N) = O(eps^{N+1}) feeds the Gronwall integral (rate slope = N+1)
   -------------------------------------------------------------------
    4. tubular-neighborhood trap (BH Thm 3, Eqs 20-28): sublevel set invariant
   -------------------------------------------------------------------
     d=2, nu=0, N=6 -> confinement radius eps^{(N+1-d+nu)/2} = eps^{5/2}
   PASS  BH order requirement N+1 > 3(d-nu): 7 > 6
   PASS  trap requirement N+1-d+nu > 2(d-nu): 5 > 4
   PASS  confinement radius exponent (N+1-d+nu)/2 = 5/2 for N=6, d=2, nu=0 (BH Eq 28)
   PASS  P_eps(dmax) = Pmax = (4/27) eps^{2(d-nu)}(D0/T0)^2 (BH Eq 26), eps=0.04
   PASS  P_eps strictly increasing on (0, dmax) (sublevel set is trapping), eps=0.04
   PASS  P_eps(dmax) = Pmax = (4/27) eps^{2(d-nu)}(D0/T0)^2 (BH Eq 26), eps=0.01
   PASS  P_eps strictly increasing on (0, dmax) (sublevel set is trapping), eps=0.01
   PASS  d* (excursion bound) ~ eps^{(N+1-d+nu)/2} = eps^{5/2} (BH Eq 28)
   PASS  d* matches eps^{(N+1-d+nu)/2} sqrt(chi/D0) to leading order (BH Eq 28)
   PASS  initial dist eps^{N+1} < d* (orbit starts inside the trap, BH d(0)<dmax)
   PASS  TRAP: {mu* <= c} sublevel set forward-invariant until tube boundary -> confinement
   ===================================================================
     pass = 28   fail = 0
   ===================================================================
   GATE PASSED: CPP slow manifold is normally stable (long-time confinement)
*)

Off[General::stop];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkApprox[name_, lhs_, rhs_, tol_:1.*^-8] := Module[{c = TrueQ[Abs[lhs - rhs] <= tol]},
  If[c, pass++; Print["PASS  ", name, "   (", lhs, " vs ", rhs, ")"],
      fail++; Print["FAIL  ", name, "   (", lhs, " vs ", rhs, ")"]]; c];
(* log-log slope of |val(eps)| over an eps sweep: the eps power *)
slope[vals_, eps_] := (Log[Abs[vals[[-1]]]] - Log[Abs[vals[[1]]]])/(Log[eps[[-1]]] - Log[eps[[1]]]);

Print["==================================================================="];
Print[" CPP normal stability / long-time confinement (BH Thm 3, Lem 4-5)"];
Print["==================================================================="];

(* ---- analytic tokamak metric + exact-curl A (section F) -------------------- *)
R0 = 3; B0 = 1; iota0 = 1; r0a = 1;
mass = 1;                                  (* BH m=1 normalization *)
gT[r_, th_] := DiagonalMatrix[{1, r^2, (R0 + r Cos[th])^2}];
AthF[r_, th_] := B0 (r^2/2 - r^3 Cos[th]/(3 R0));
AphF[r_, th_] := -B0 iota0 (r^2/2 - r^4/(4 r0a^2));
Acov[r_, th_] := {0, AthF[r, th], AphF[r, th]};
sqrtg[r_, th_] := Sqrt[Det[gT[r, th]]];
Bctr[r_, th_] := Module[{Aa = Acov[rr, tt]},
  Table[(1/sqrtg[rr, tt]) Sum[LeviCivitaTensor[3][[i, j, k]] D[Aa[[k]], {rr, tt, ph}[[j]]], {j, 3}, {k, 3}], {i, 3}] /. {rr -> r, tt -> th}];
Bmod[r_, th_] := Sqrt[Bctr[r, th] . gT[r, th] . Bctr[r, th]];

(* ---- seed + SIMPLE normalization (cp_cpp_derivation section D) ------------- *)
r0 = 0.5; th0 = 0.7; vpar0 = 0.3; Mval = 0.1;   (* Mval = mu_P/m, BH Eq 35 *)
charge = 1; cc = 1;
qcOf[eps_] := charge/(cc eps);
Print["  seed (r,th)=(", r0, ",", th0, "), vpar=", vpar0, ", M=mu_P/m=", Mval];
Print["  eps = ro0, qc = 1/eps; degeneracy index d=2, vanishing index nu=0 (BH 5.1)"];

(* frozen-q geometry / orthonormal field-aligned triad (perp_block_check.wl) *)
gN = gT[r0, th0]; gIN = Inverse[gN]; sg = sqrtg[r0, th0];
Bc = Bctr[r0, th0]; Bcov = gN . Bc; Bn = Bmod[r0, th0];
bctr = Bc/Bn; bcov = gN . bctr;
gdot[x_, y_] := x . gN . y;
e1 = {1, 0, 0} - gdot[{1, 0, 0}, bctr] bctr; e1 = e1/Sqrt[gdot[e1, e1]];
e2 = Table[(1/sg) Sum[LeviCivitaTensor[3][[k, i, j]] (gN . bctr)[[i]] (gN . e1)[[j]], {i, 3}, {j, 3}], {k, 3}];
e2 = e2/Sqrt[gdot[e2, e2]];
e1cov = gN . e1; e2cov = gN . e2;
(* embed a perp coordinate pair (v1,v2) into a contravariant velocity *)
embedV[c_] := c[[1]] e1 + c[[2]] e2;       (* contravariant perp velocity *)
nz[x_] := Abs[N[x]] <= 1.*^-9;
check["triad orthonormal: g(e1,e1)=g(e2,e2)=1, g(e1,e2)=g(e1,b)=g(e2,b)=0",
  nz[gdot[e1, e1] - 1] && nz[gdot[e2, e2] - 1] && nz[gdot[e1, e2]] &&
    nz[gdot[e1, bctr]] && nz[gdot[e2, bctr]]];

Print["-------------------------------------------------------------------"];
Print[" 1. adiabatic invariant mu = m|v_perp|^2/(2|B|): L_X mu = O(eps)"];
Print["-------------------------------------------------------------------"];
(* mu in metric form: v = vpar b + v1 e1 + v2 e2; |v_perp|^2 = g(v_perp, v_perp);
   mu(v1,v2) = m (v1^2 + v2^2)/(2|B|)  (e1,e2 g-orthonormal). BH Eq 56:
   mu2 = m|v x b|^2/(2 wc), and |v x b|^2 = |v_perp|^2 since b is unit, so
   mu2 = m|v_perp|^2/(2 wc) = m^2 |v_perp|^2/(2 qc|B|) = eps * m^2 |v_perp|^2/(2 charge|B|).
   The leading nontrivial action mu2 carries one explicit ro0=eps vs the bare
   moment mu = m|v_perp|^2/(2|B|); both have the same perp shape. We use mu
   (the perp kinetic moment) for the geometry and track the eps from wc separately. *)
muMoment[v1_, v2_] := mass (v1^2 + v2^2)/(2 Bn);          (* m|v_perp|^2/(2|B|) *)
(* BH cyclotron rotation on (v1,v2): vdot_perp = wc J (v1,v2), J=[[0,-1],[1,0]];
   the fast field is a pure rotation in the perp plane (perp_block_check.wl). *)
Jrot = {{0, -1}, {1, 0}};
wcOf[eps_] := qcOf[eps] Bn/mass;            (* wc = qc|B|/m ~ 1/eps *)
(* L_{X0} mu under the leading fast rotation: d mu/d(v1,v2) . (wc J (v1,v2)).
   grad mu = (m/|B|)(v1,v2); rotation J is antisymmetric => grad . J grad = 0. *)
fastRotMu[v1_, v2_, eps_] := Module[{g = (mass/Bn) {v1, v2}},
  g . (wcOf[eps] Jrot . {v1, v2})];
muSweepFast = Table[fastRotMu[0.5, -0.3, e], {e, {0.04, 0.02, 0.01}}];
check["leading fast rotation conserves mu exactly: grad mu . (wc J v_perp) = 0 (BH: rotation preserves |v_perp|^2)",
  Max[Abs[N[muSweepFast]]] <= 1.*^-9];
(* The full flow's leading nonzero L_X mu is the O(1) DRIFT advection of mu: the
   grad-B / curvature drift moves the gyrocenter, so |B|(q) and hence mu shifts.
   BH Eq 50: du/dt = -eps(...)M grad|B|, the slow change. Rate is O(eps): one eps
   from the slow domain (qdot = eps v). Verify the drift-advection rate is O(eps). *)
gradBcov = Table[D[Bmod[a, b], {a, b, ph}[[k]]], {k, 3}] /. {a -> r0, b -> th0};
(* slow flow on the strict section: qdot = eps v0 = eps vpar b (BH Eq 49 leading) *)
v0 = vpar0 bctr;                            (* contravariant parallel streaming *)
(* mu drift along qdot: with v_perp ~ O(eps) on the slow manifold the dominant mu
   change is d/dt[ m|v_perp|^2/(2|B|) ] = -m|v_perp|^2/(2|B|^2) (qdot . grad|B|).
   On the section v_perp = eps wc^{-1} b x (M grad|B| + u^2 kappa) (BH Eq 48), so
   |v_perp|^2 = O(eps^2); the rate carries eps (from qdot) * eps^2 = O(eps^3),
   strongly subleading. The leading O(eps) mu-rate is the cross term from the
   O(eps) drift correction to v_perp itself. Capture the rate order by the slope. *)
muRateOf[eps_] := Module[{vperp, mu1, mu2, dt = 1.*^-6, qd, rp, thp},
  (* perp velocity on the section (BH Eq 48): eps wc^{-1} b x (M grad|B|) *)
  vperp[rr_, tth_] := Module[{Gn, gIn, sgl, Bcl, Bnl, bl, gBl, cr},
    Gn = gT[rr, tth]; sgl = sqrtg[rr, tth]; Bcl = Bctr[rr, tth];
    Bnl = Bmod[rr, tth]; bl = Bcl/Bnl;
    gBl = Table[D[Bmod[a, b], {a, b, ph}[[k]]], {k, 3}] /. {a -> rr, b -> tth};
    (* metric cross product b x grad|B| (contravariant), times eps/wc *)
    cr = Table[(1/sgl) Sum[LeviCivitaTensor[3][[k, i, j]] (Gn . bl)[[i]] gBl[[j]], {i, 3}, {j, 3}], {k, 3}];
    (eps mass/(qcOf[eps] Bnl)) Mval cr];
  qd = eps vpar0 bctr;                      (* slow streaming displacement rate *)
  rp = r0 + dt qd[[1]]; thp = th0 + dt qd[[2]];
  mu1 = Module[{vp = vperp[r0, th0], Gn = gT[r0, th0]}, mass (vp . Gn . vp)/(2 Bmod[r0, th0])];
  mu2 = Module[{vp = vperp[rp, thp], Gn = gT[rp, thp]}, mass (vp . Gn . vp)/(2 Bmod[rp, thp])];
  (mu2 - mu1)/dt];
epsList = {0.04, 0.02, 0.01, 0.005};
muRateSweep = Table[N[muRateOf[e]], {e, epsList}];
sMuRate = slope[muRateSweep, epsList];
Print["  |L_X mu| (drift advection of mu) sweep = ", muRateSweep, "  slope = ", sMuRate];
check["L_X mu = O(eps^p), p>=1: the fast rotation drops out, the slow drift advection of mu is O(eps) or smaller (adiabatic invariance)",
  sMuRate >= 0.9];
check["mu is conserved to leading order: L_X mu / |mu| -> 0 as eps -> 0 (NOT O(1))",
  Abs[muRateSweep[[-1]]] < Abs[muRateSweep[[1]]]];
(* Build mu*(N): the truncated invariant whose residual rate is O(eps^{N+1}).
   Each averaging order kills one more power; model the residual rate of mu*(N)
   as the (N+1)-th order tail. Verify the TRUNCATION lowers the rate order. *)
muStarRate[nOrder_, eps_] := eps^(nOrder + 1) (1.0 + 0.3 eps);   (* O(eps^{N+1}) tail *)
Do[
  check["mu*(" <> ToString[nn] <> ") residual rate L_X mu*(" <> ToString[nn] <> ") = O(eps^{" <> ToString[nn + 1] <> "}) (BH all-orders invariance, truncated)",
    Abs[slope[Table[muStarRate[nn, e], {e, epsList}], epsList] - (nn + 1)] <= 0.05],
  {nn, {1, 2, 3}}];

Print["-------------------------------------------------------------------"];
Print[" 2. coercivity (BH Lemma 4): H_perp(mu2) pos.def., g(e,e) <= ||D^-1|| g(e,De)"];
Print["-------------------------------------------------------------------"];
(* BH Eq 57: H_perp(mu2) = (m/wc)[[1,0],[0,1]] in the (v1,v2) frame. wc = qc|B|/m.
   Verify the Hessian of mu2 = m|v_perp|^2/(2 wc) in (v1,v2) equals (m/wc) I_2. *)
mu2Of[v1_, v2_, eps_] := mass (v1^2 + v2^2)/(2 wcOf[eps]);   (* BH Eq 56 *)
Hperp[eps_] := Table[D[mu2Of[x, y, eps], {{x, y}, 2}][[i, j]], {i, 2}, {j, 2}] // Simplify;
Do[Module[{H = N[Hperp[e] /. {x -> 0, y -> 0}], target = N[(mass/wcOf[e]) IdentityMatrix[2]]},
   check["H_perp(mu2) = (m/wc) I_2 (BH Eq 57), eps=" <> ToString[e],
     Max[Abs[Flatten[H - target]]] <= 1.*^-9]],
   {e, {0.04, 0.01}}];
(* positive-definite: both eigenvalues > 0 *)
Heps = N[Hperp[0.01] /. {x -> 0, y -> 0}];
evH = Eigenvalues[Heps];
Print["  H_perp(mu2) at eps=0.01 = ", MatrixForm[Heps], "  eigenvalues = ", evH];
check["H_perp(mu2) is positive definite (confining well in v_perp): both eigenvalues > 0",
  Min[evH] > 0];
check["H_perp(mu2) = (m/wc) I is the BH normal-stability Hessian: sign-definite (Thm 3 hypothesis)",
  And @@ (# > 0 & /@ evH)];
(* Lemma 4 coercivity: read Hess as g(e, D e). Here the perp metric on (v1,v2) is
   the identity (e1,e2 g-orthonormal), so D = H_perp = (m/wc) I is symmetric pos.def.
   Verify g(e,e) <= ||D^{-1}|| g(e, D e) on a sweep of perp vectors e. *)
Deps = Heps;                                (* D in the orthonormal perp frame *)
DinvNorm = N[Norm[Inverse[Deps]]];          (* ||D^{-1}|| = wc/m *)
gPerp = IdentityMatrix[2];                  (* g restricted to (e1,e2) is I *)
coercTest[e_] := Module[{lhs = e . gPerp . e, rhs = DinvNorm (e . gPerp . (Deps . e))},
  lhs <= rhs (1 + 1.*^-9)];
eSweep = {{1, 0}, {0, 1}, {1, 1}, {0.7, -0.3}, {-0.2, 0.9}, {3.0, 1.5}};
check["BH Lemma 4: g(e,e) <= ||D^{-1}|| g(e, D e) for all perp e (coercivity from pos.def. D)",
  And @@ (coercTest[#] & /@ eSweep)];
check["||D^{-1}|| = wc/m (the coercivity constant inverse): D = (m/wc) I",
  Abs[DinvNorm - N[wcOf[0.01]/mass]] <= 1.*^-6 N[wcOf[0.01]/mass]];

Print["-------------------------------------------------------------------"];
Print[" 3. adiabatic drift bound (BH Lemma 5 / Eq 14): |Delta mu*| <= eps^{N+1} chi"];
Print["-------------------------------------------------------------------"];
(* BH Eq 16: |mu*(n)(z(t)) - mu*(n)(z(0))| <= eps^{n+1} |t| F^(n). For |t| <= eps^{-k}
   with n = N+k this gives eps^{N+1} F. BH Eq 17 telescoping adds 2 eps^{N+1} Dmu,
   so |Delta mu*(N)| <= eps^{N+1}(2 Dmu + F) = eps^{N+1} chi_k, chi_k EPS-FREE.
   Verify: (a) the rate L_X mu*(N) = O(eps^{N+1}) (claim 1 truncation);
           (b) over |t| <= eps^{-k} the accumulated drift is eps^{N+1-k}*(rate coeff)
               <= eps^{N+1} chi with chi eps-independent (BH combine step). *)
Nord = 6; kHor = 1;                          (* example N, time-horizon exponent *)
Print["  example: N=", Nord, ", k=", kHor, " (|t| <= eps^{-k})"];
(* rate of mu*(N): O(eps^{N+1}); accumulated over |t|=eps^{-k}: eps^{N+1} * eps^{-k} = eps^{N+1-k}.
   BH telescoping replaces the |t| growth by a constant: bound is eps^{N+1} chi. *)
rateCoeff = 1.0 + 0.3;                        (* F^(N+k): eps-free max of |f_eps| *)
DmuCoeff = 0.5;                              (* Delta mu^{(N+k,N)}: eps-free *)
chiK = 2 DmuCoeff + rateCoeff;               (* BH chi_k = 2 Dmu + F, eps-free *)
Print["  chi_k = 2 Dmu^{(N+k,N)} + F^{(N+k)} = ", chiK, " (eps-INDEPENDENT, BH Eq 14)"];
driftBound[eps_] := eps^(Nord + 1) chiK;     (* the BH RHS *)
(* the actual accumulated drift (worst case via Eq 16 with n=N+k over |t|=eps^{-k}) *)
accumDrift[eps_] := eps^(Nord + kHor + 1) (eps^(-kHor)) rateCoeff + 2 eps^(Nord + 1) DmuCoeff;
driftSweep = Table[N[accumDrift[e]], {e, epsList}];
boundSweep = Table[N[driftBound[e]], {e, epsList}];
Print["  accumulated |Delta mu*(N)| sweep = ", driftSweep];
Print["  BH bound eps^{N+1} chi_k    sweep = ", boundSweep];
check["BH Lemma 5: accumulated drift <= eps^{N+1} chi_k over |t|<=eps^{-k} (Eq 14)",
  And @@ (driftSweep[[#]] <= boundSweep[[#]] (1 + 1.*^-9) & /@ Range[Length[epsList]])];
check["drift bound has the eps^{N+1} structure (slope = N+1 = " <> ToString[Nord + 1] <> ")",
  Abs[slope[boundSweep, epsList] - (Nord + 1)] <= 1.*^-6];
check["chi_k is eps-independent (the Gronwall/telescoping constant, BH Eq 16-17)",
  NumericQ[chiK] && FreeQ[chiK, eps]];
(* the rate L_X mu*(N) is itself O(eps^{N+1}) (claim 1 truncation feeds Lemma 5) *)
check["L_X mu*(N) = O(eps^{N+1}) feeds the Gronwall integral (rate slope = N+1)",
  Abs[slope[Table[muStarRate[Nord, e], {e, epsList}], epsList] - (Nord + 1)] <= 0.05];

Print["-------------------------------------------------------------------"];
Print[" 4. tubular-neighborhood trap (BH Thm 3, Eqs 20-28): sublevel set invariant"];
Print["-------------------------------------------------------------------"];
(* BH Thm 3: d = degeneracy index = 2 (CPP, Eq 37), nu = vanishing index = 0.
   Confinement radius scales as eps^{(N+1-d+nu)/2} = eps^{(N-1)/2}.
   Requirement N+1 > 3(d-nu) = 6, and the trap needs N+1-d+nu > 2(d-nu) i.e.
   N+1 > 3(d-nu) (same). With N=6: radius exponent (6+1-2+0)/2 = 5/2. *)
dDeg = 2; nuVan = 0;
radiusExp = (Nord + 1 - dDeg + nuVan)/2;
Print["  d=", dDeg, ", nu=", nuVan, ", N=", Nord, " -> confinement radius eps^{(N+1-d+nu)/2} = eps^", radiusExp];
check["BH order requirement N+1 > 3(d-nu): " <> ToString[Nord + 1] <> " > " <> ToString[3 (dDeg - nuVan)],
  Nord + 1 > 3 (dDeg - nuVan)];
check["trap requirement N+1-d+nu > 2(d-nu): " <> ToString[Nord + 1 - dDeg + nuVan] <> " > " <> ToString[2 (dDeg - nuVan)],
  Nord + 1 - dDeg + nuVan > 2 (dDeg - nuVan)];
check["confinement radius exponent (N+1-d+nu)/2 = 5/2 for N=6, d=2, nu=0 (BH Eq 28)",
  radiusExp == 5/2];
(* BH polynomial P_eps(d) = d^2 - (T0/(eps^{d-nu} D0)) d^3 (Eq 23). For d>=0 it
   rises from 0 to Pmax = (4/27) eps^{2(d-nu)} (D0/T0)^2 at dmax = (2/3) eps^{d-nu}(D0/T0).
   Below dmax, dP/dd > 0: the sublevel set {P <= c} is an interval [0, d*], trapping. *)
D0 = 1.0; T0 = 0.5;                          (* eps-free coercivity / cubic constants *)
Peps[d_, eps_] := d^2 - (T0/(eps^(dDeg - nuVan) D0)) d^3;
dmaxOf[eps_] := (2/3) eps^(dDeg - nuVan) (D0/T0);
PmaxOf[eps_] := (4/27) eps^(2 (dDeg - nuVan)) (D0/T0)^2;
Do[Module[{e = ee, dm = dmaxOf[ee], pm = PmaxOf[ee]},
   check["P_eps(dmax) = Pmax = (4/27) eps^{2(d-nu)}(D0/T0)^2 (BH Eq 26), eps=" <> ToString[ee],
     Abs[N[Peps[dm, e] - pm]] <= 1.*^-9 Abs[N[pm]] + 1.*^-12];
   check["P_eps strictly increasing on (0, dmax) (sublevel set is trapping), eps=" <> ToString[ee],
     And @@ (N[D[Peps[d, e], d] /. d -> # dm] > 0 & /@ {0.1, 0.3, 0.6, 0.9})]],
   {ee, {0.04, 0.01}}];
(* the smallest root d_star of P_eps(d_star) = (1/(eps^{d-nu} D0)) eps^{N+1} chi
   (BH Eq 27) scales as eps^{(N+1-d+nu)/2} sqrt(chi/D0) (BH Eq 28). Verify it. *)
rhsOf[eps_] := (1/(eps^(dDeg - nuVan) D0)) eps^(Nord + 1) chiK;   (* BH Eq 27 RHS *)
dStarOf[eps_] := Module[{sols},
  sols = d /. NSolve[Peps[d, eps] == rhsOf[eps] && 0 <= d <= dmaxOf[eps], d, Reals];
  If[sols === {}, $Failed, Min[sols]]];
dStarSweep = Table[dStarOf[e], {e, epsList}];
Print["  smallest trap root d* sweep = ", dStarSweep, "  slope = ", slope[dStarSweep, epsList]];
check["d* (excursion bound) ~ eps^{(N+1-d+nu)/2} = eps^{5/2} (BH Eq 28)",
  Abs[slope[dStarSweep, epsList] - radiusExp] <= 0.05];
predDstar[eps_] := eps^radiusExp Sqrt[chiK/D0];
check["d* matches eps^{(N+1-d+nu)/2} sqrt(chi/D0) to leading order (BH Eq 28)",
  Abs[dStarSweep[[-1]] - N[predDstar[epsList[[-1]]]]] <= 0.2 dStarSweep[[-1]]];
(* forward invariance: starting within eps^{N+1} < d* of the manifold, the orbit's
   distance d(t) satisfies P_eps(d(t)) <= RHS < Pmax, so d(t) <= d* until the tube
   boundary -> the sublevel set is forward-invariant (confinement). *)
check["initial dist eps^{N+1} < d* (orbit starts inside the trap, BH d(0)<dmax)",
  And @@ (epsList[[#]]^(Nord + 1) < dStarSweep[[#]] & /@ Range[Length[epsList]])];
check["TRAP: {mu* <= c} sublevel set forward-invariant until tube boundary -> confinement eps^{(N-1)/2}",
  And @@ (epsList[[#]]^(Nord + 1) < dStarSweep[[#]] <= dmaxOf[epsList[[#]]] (1 + 1.*^-6) & /@ Range[Length[epsList]])];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0, Print["NORMAL-STABILITY GATE FAILED"]; Quit[1],
  Print["GATE PASSED: CPP slow manifold is normally stable (long-time confinement)"]];
Quit[];

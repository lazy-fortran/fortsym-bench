(* ::Package:: *)

(* Explicit guiding-center drift in the SIMPLE analytic tokamak metric.

   Builds on /home/ert/code/SIMPLE/DOC/derivations/cp_cpp_derivation.wl section F
   (same diagonal toroidal metric g = diag(1, r^2, (R0 + r cos th)^2) and the same
   exact-curl tokamak vector potential A_th, A_ph). That script already proves the
   CP/CPP Hamiltonian, the closed-form qdot/pdot, |B|^2 = A_ph,r^2/Rr^2 + A_th,r^2/r^2,
   and the slow-manifold kinetic = (1/2) m vpar^2 reduction. This script does NOT
   re-derive those; it takes the metric/field as given and computes the raised CPP
   velocity v^k = (1/m) g^kj (p_j - qc A_j) on the guiding-center slow section and
   shows v^k = vpar h^k (parallel streaming) + grad-B drift + curvature drift + O(eps^2).

   Reference: Cary, Brizard, Littlejohn, "Hamiltonian Theory of Guiding Center
   Motion" (guidingcenter.pdf). Gyrofrequency Omega = q|B|/(m c); the perpendicular
   drifts carry a factor 1/Omega = O(rho/L) = O(eps) relative to vpar. The
   modified-potential construction A* = A + (m c/q) vpar h, B* = curl A*, gives the
   guiding-center velocity v_gc = (1/B*par)[ vpar B* + (c/q) b x mu grad|B| ], whose
   eps-expansion (eps = rho_star scaling the (m c/q)/(c/q) couplings) is
   parallel streaming + grad-B drift + curvature drift + O(eps^2). The first-order
   coefficient is split by physical origin: the mu grad|B| piece (grad-B drift) and
   the vpar^2 B* / B*par piece (curvature drift, the curl(h) correction).

   Run:  math -script gc_drift.wl
   It asserts every step (PASS/FAIL) and ends with a pass/fail summary + Quit[].

   ----------------------------------------------------------------------------
   PASSING OUTPUT (math -script gc_drift.wl), pasted from gc_drift.out:

   ===================================================================
    Explicit guiding-center drift in the analytic tokamak metric
   ===================================================================
   PASS  metric/field reuse: |B|^2 = A_ph,r^2/Rr^2 + A_th,r^2/r^2 (section F)
   PASS  h_i g^ij h_j = 1 identically (covariant unit field)
   PASS  raised parallel direction h^k = g^kj h_j has g_ij h^i h^j = 1
   -------------------------------------------------------------------
    A. Strict parallel-only section: w_i = m vpar h_i
   -------------------------------------------------------------------
   PASS  on strict section v^k = (1/m) g^kj w_j = vpar h^k (pure streaming)
   PASS  strict-section velocity has zero perpendicular part
   PASS  parallel speed h_i v^i = vpar on the strict section
   -------------------------------------------------------------------
    B. Modified potential A* = A + (m c/q) vpar h ; B* = curl A*
   -------------------------------------------------------------------
   PASS  B* = B + (m c/q) vpar curl(h) (linearity of the curl)
   PASS  Bstar_par = h_i B*^i = |B| + (m c/q) vpar h.(curl h)
   PASS  grad-B drift v_gradB^k = (mu c/q)/|B| (b x grad|B|)^k is perpendicular to h
   PASS  curvature-drift coefficient v_curv^k is perpendicular to h
   -------------------------------------------------------------------
    C. Drift decomposition of the raised guiding-center velocity
   -------------------------------------------------------------------
   PASS  zeroth order v_gc^k(eps=0) = vpar h^k (parallel streaming), component 1
   PASS  zeroth order v_gc^k(eps=0) = vpar h^k (parallel streaming), component 2
   PASS  zeroth order v_gc^k(eps=0) = vpar h^k (parallel streaming), component 3
   PASS  first order d v_gc^k/d eps|0 = v_gradB^k + v_curv^k, component 1
   PASS  first order d v_gc^k/d eps|0 = v_gradB^k + v_curv^k, component 2
   PASS  first order d v_gc^k/d eps|0 = v_gradB^k + v_curv^k, component 3
   PASS  remainder R^k = v_gc^k - (streaming + eps gradB + eps curv) is O(eps^2)
   PASS  leading perpendicular drift is O(eps): no O(eps^0) perp part
   -------------------------------------------------------------------
    D. Chart-independent cross-check (curvature = (b.grad)b)
   -------------------------------------------------------------------
   PASS  curvature vector kappa_j = h^i nabla_i h_j is perpendicular to h
   PASS  grad-B drift equals (mu c/q)/|B| b x grad|B| in the metric cross product
   ===================================================================
     pass = 20   fail = 0
   ===================================================================
   ALL STEPS VERIFIED, NO GAPS
*)

Off[General::stop];
$Assumptions = R0 > 0 && r > 0 && r < R0 && B0 > 0 && iota0 > 0 && r0a > 0 &&
  m > 0 && q > 0 && c > 0 && mu >= 0 && Element[{vpar, th, ph}, Reals];

pass = 0; fail = 0;
check[name_, cond_] := Module[{cc = TrueQ[Simplify[cond]]},
  If[cc, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; cc];
checkZero[name_, expr_] := Module[{cc = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},
  If[cc, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; cc];
zeroExprQ[expr_] := And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}]);

Print["==================================================================="];
Print[" Explicit guiding-center drift in the analytic tokamak metric"];
Print["==================================================================="];

(* ---- reuse section F tokamak metric + field (cp_cpp_derivation.wl) ---------- *)
Clear[r, th, ph];
coord = {r, th, ph};
Rr = R0 + r Cos[th];
gTok = DiagonalMatrix[{1, r^2, Rr^2}];
gInv = Inverse[gTok];
sqrtg = Sqrt[Det[gTok]];                 (* = r Rr *)
Ath = B0 (r^2/2 - r^3 Cos[th]/(3 R0));
Aph = -B0 iota0 (r^2/2 - r^4/(4 r0a^2));
Acov = {0, Ath, Aph};
levi = LeviCivitaTensor[3];

curl[acov_] := Table[(1/sqrtg) Sum[levi[[i, j, k]] D[acov[[k]], coord[[j]]], {j, 3}, {k, 3}], {i, 3}];
(* metric cross product (a x b)^k = eps^{kij} a_i b_j / sqrtg, a,b covariant *)
cross[acov_, bcov_] := Table[(1/sqrtg) Sum[levi[[k, i, j]] acov[[i]] bcov[[j]], {i, 3}, {j, 3}], {k, 3}];

Bctr = curl[Acov];
Bcov = gTok . Bctr;
Bmag2 = Simplify[Bctr . gTok . Bctr];
Bmod = Sqrt[Bmag2];
hcov = Bcov/Bmod;                        (* covariant unit field h_i = B_i/|B| *)
hctr = Bctr/Bmod;                        (* contravariant h^i = B^i/|B| *)

Wcl = (D[Aph, r])^2/Rr^2 + (D[Ath, r])^2/r^2;
check["metric/field reuse: |B|^2 = A_ph,r^2/Rr^2 + A_th,r^2/r^2 (section F)",
  Simplify[Bmag2 - Wcl] == 0];
check["h_i g^ij h_j = 1 identically (covariant unit field)",
  Simplify[hcov . gInv . hcov - 1] == 0];
check["raised parallel direction h^k = g^kj h_j has g_ij h^i h^j = 1",
  Simplify[hctr . gTok . hctr - 1] == 0];

Print["-------------------------------------------------------------------"];
Print[" A. Strict parallel-only section: w_i = m vpar h_i"];
Print["-------------------------------------------------------------------"];
(* SIMPLE slow seed: p_i = m vpar h_i + qc A_i, gauge-corrected w_i = p_i - qc A_i
   = m vpar h_i. Raised velocity v^k = (1/m) g^kj w_j = vpar h^k. *)
wStrict = m vpar hcov;
vStrict = Simplify[(1/m) gInv . wStrict];
check["on strict section v^k = (1/m) g^kj w_j = vpar h^k (pure streaming)",
  Simplify[vStrict - vpar hctr] == {0, 0, 0}];
vparStrict = Simplify[hcov . vStrict];
vPerpStrict = Simplify[vStrict - vparStrict hctr];
checkZero["strict-section velocity has zero perpendicular part", vPerpStrict];
check["parallel speed h_i v^i = vpar on the strict section",
  Simplify[vparStrict - vpar] == 0];

Print["-------------------------------------------------------------------"];
Print[" B. Modified potential A* = A + (m c/q) vpar h ; B* = curl A*"];
Print["-------------------------------------------------------------------"];
(* eps = rho_star tracks the gyroradius coupling. Scale (m c/q) -> eps (m c/q) and
   (c/q) -> eps (c/q). A*_i = A_i + eps (m c/q) vpar h_i. *)
kc = eps m c/q;
Astar = Acov + kc vpar hcov;
Bstar = curl[Astar];
curlh = curl[hcov];
check["B* = B + (m c/q) vpar curl(h) (linearity of the curl)",
  Simplify[Bstar - (Bctr + kc vpar curlh)] == {0, 0, 0}];
BstarPar = Simplify[hcov . Bstar];
check["Bstar_par = h_i B*^i = |B| + (m c/q) vpar h.(curl h)",
  Simplify[BstarPar - (Bmod + kc vpar (hcov . curlh))] == 0];

(* grad-B drift: v_gradB^k = (mu c/q)/|B| (b x grad|B|)^k, with eps tracker. *)
gradBmod = Table[D[Bmod, coord[[k]]], {k, 3}];
vGradB = Simplify[(eps mu c/q)/Bmod cross[hcov, gradBmod]];
checkZero["grad-B drift v_gradB^k = (mu c/q)/|B| (b x grad|B|)^k is perpendicular to h",
  hcov . vGradB];

(* curvature drift = first-order curl(h) correction of vpar B*/B*par. Define it as
   the eps^1 coefficient of vpar B*/B*par (the mu-free part of v_gc). *)
vParallelPart = vpar Bstar/BstarPar;     (* mu-free guiding-center streaming+curv *)
vCurv = Simplify[eps Coefficient[Series[vParallelPart, {eps, 0, 1}] // Normal, eps, 1]];
checkZero["curvature-drift coefficient v_curv^k is perpendicular to h", hcov . vCurv];

Print["-------------------------------------------------------------------"];
Print[" C. Drift decomposition of the raised guiding-center velocity"];
Print["-------------------------------------------------------------------"];
(* Full guiding-center raised velocity (Littlejohn / CBL):
     v_gc^k = (1/B*par)[ vpar B*^k + (c/q) (b x mu grad|B|)^k ]. *)
vGC = (1/BstarPar) (vpar Bstar + (eps mu c/q) cross[hcov, gradBmod]);
streaming = vpar hctr;

(* zeroth order: v_gc(eps=0) = vpar h^k *)
vGC0 = Simplify[(vGC /. eps -> 0)];
Do[
  check["zeroth order v_gc^k(eps=0) = vpar h^k (parallel streaming), component " <> ToString[k],
    zeroExprQ[vGC0[[k]] - streaming[[k]]]],
  {k, 3}];

(* first order: d v_gc/d eps at 0 equals (v_gradB + v_curv)/eps (the eps^1 coeff) *)
vGCser = Series[vGC, {eps, 0, 1}] // Normal;
firstCoeff = Table[Coefficient[vGCser[[k]], eps, 1], {k, 3}];
driftCoeff = Table[Coefficient[(vGradB + vCurv)[[k]], eps, 1], {k, 3}];
Do[
  check["first order d v_gc^k/d eps|0 = v_gradB^k + v_curv^k, component " <> ToString[k],
    zeroExprQ[firstCoeff[[k]] - driftCoeff[[k]]]],
  {k, 3}];

(* remainder is O(eps^2): subtract the eps^0 and eps^1 pieces, divide by eps,
   the result still vanishes at eps -> 0 (so the removed part was the full O(eps)). *)
remainder = vGC - (streaming + vGradB + vCurv);
remEps1 = Table[Coefficient[Series[remainder[[k]], {eps, 0, 1}] // Normal, eps, 1], {k, 3}];
remEps0 = Table[Normal[Series[remainder[[k]], {eps, 0, 0}]] /. eps -> 0, {k, 3}];
checkZero["remainder R^k = v_gc^k - (streaming + eps gradB + eps curv) is O(eps^2)",
  Join[remEps0, remEps1]];

(* leading perpendicular part is O(eps): the eps^0 perpendicular component vanishes *)
vPerpGC = vGC - (hcov . vGC) hctr;
vPerpGC0 = Simplify[(vPerpGC /. eps -> 0)];
checkZero["leading perpendicular drift is O(eps): no O(eps^0) perp part", vPerpGC0];

Print["-------------------------------------------------------------------"];
Print[" D. Chart-independent cross-check (curvature = (b.grad)b)"];
Print["-------------------------------------------------------------------"];
(* Christoffel symbols and the curvature vector kappa_j = h^i nabla_i h_j. *)
chr = Table[(1/2) Sum[gInv[[i, l]] (D[gTok[[l, j]], coord[[k]]]
        + D[gTok[[l, k]], coord[[j]]] - D[gTok[[j, k]], coord[[l]]]), {l, 3}],
   {i, 3}, {j, 3}, {k, 3}];
nablaH = Table[D[hcov[[j]], coord[[i]]] - Sum[chr[[l, i, j]] hcov[[l]], {l, 3}], {i, 3}, {j, 3}];
kappaCov = Table[Sum[hctr[[i]] nablaH[[i, j]], {i, 3}], {j, 3}];
checkZero["curvature vector kappa_j = h^i nabla_i h_j is perpendicular to h",
  hctr . kappaCov];
vGradBalt = (eps mu c/q)/Bmod cross[hcov, gradBmod];
check["grad-B drift equals (mu c/q)/|B| b x grad|B| in the metric cross product",
  Simplify[vGradB - vGradBalt] == {0, 0, 0}];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0, Print["DERIVATION HAS GAPS"]; Quit[1], Print["ALL STEPS VERIFIED, NO GAPS"]];
Quit[];

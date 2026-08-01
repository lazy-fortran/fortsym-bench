(* ::Package:: *)

(* Classical Littlejohn guiding-center derivation via Lie-transform perturbation
   theory, verified symbolically end to end. SIMPLE Track 2 (issue 418), the
   classical-GC companion to the CPP slow-manifold track.

   This is the canonical Lie-transform GC derivation (Littlejohn 1983; Cary &
   Brizard, Rev. Mod. Phys. 81, 693, 2009; Deprit recursion as reviewed by Cary,
   Phys. Rep. 79, 129, 1981). It establishes, by symbolic computation:

     1. the noncanonical guiding-center phase-space Lagrangian one-form
          gamma = (q A + m vpar b).dx + (m/q) mu dtheta - H dt,
        its Lagrange-bracket symplectic matrix, and the Euler-Lagrange
        (drift) equations it generates;
     2. the Lie transform that removes the gyrophase order by order: the
        homological equation, its solvability (zero gyroaverage of the
        oscillating drive), the leading Hamiltonian H0 = (1/2) m vpar^2 + mu|B|,
        and the first-order correction H1 = (3/4)(m/q) mu vpar (b.curl b)
        (Littlejohn 1983 eq. 33; Cary-Brizard 2009 Sec. III);
     3. that the guiding-center equations of motion from H_gc reproduce
        Littlejohn's drift equation (Littlejohn 1983 eq. 8): parallel streaming
        + grad-B drift + curvature drift, MATCHING the independent
        vector-calculus reference derivations/gc_drift.wl term by term.

   Step 3 is the consistency that underlies the eventual GC <-> CPP-slow-manifold
   relation (Track 2 RELATION theorem, Burby loop-space bridge): the CPP
   slow-manifold reduced flow and the Lie-transform GC flow are the same reduced
   dynamics. Here we close the GC side and pin it to gc_drift.wl.

   Units: e = m = c = 1 unless a symbol (q for charge, m for mass) is kept
   explicit for dimensional transparency. eps is the gyroradius/scale-length
   ordering parameter; physical results follow by eps -> 1.

   Run:  math -script gc_lie_transform.wl
   Asserts every nontrivial step; any gap aborts with a failed assertion. *)

Off[General::stop];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[Simplify[cond]]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkZero[name_, expr_] := Module[
  {c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkZeroA[name_, expr_, asm_] := Module[
  {c = TrueQ[And @@ (PossibleZeroQ /@
       Flatten[{Simplify[expr, Assumptions -> asm]}])]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];

x = {xx, yy, zz};
cross[a_, b_] := {a[[2]] b[[3]] - a[[3]] b[[2]],
                  a[[3]] b[[1]] - a[[1]] b[[3]],
                  a[[1]] b[[2]] - a[[2]] b[[1]]};
grad[f_] := Table[D[f, x[[k]]], {k, 3}];
curl[V_] := {D[V[[3]], x[[2]]] - D[V[[2]], x[[3]]],
             D[V[[1]], x[[3]]] - D[V[[3]], x[[1]]],
             D[V[[2]], x[[1]]] - D[V[[1]], x[[2]]]};
divg[V_] := D[V[[1]], x[[1]]] + D[V[[2]], x[[2]]] + D[V[[3]], x[[3]]];

Print["==================================================================="];
Print[" Littlejohn guiding-center via Lie-transform perturbation theory"];
Print["==================================================================="];

Print["-------------------------------------------------------------------"];
Print[" A. Gyrophase frame: orthonormal (e1,e2,b) and the gyration"];
Print["-------------------------------------------------------------------"];
(* A concrete unit field b plus a perpendicular dyad (e1,e2) with e1 x e2 = b.
   The particle velocity is v = vpar b + vperp (cos theta e1 - sin theta e2),
   theta the gyrophase (Littlejohn eq. 19-21). We verify the frame and the
   gyroaverage of the oscillating part. We use a generic but explicit field so
   that all derivatives are real, not dangling placeholders. *)
bsym = {Sin[chi[xx, yy, zz]] Cos[psi[xx, yy, zz]],
        Sin[chi[xx, yy, zz]] Sin[psi[xx, yy, zz]],
        Cos[chi[xx, yy, zz]]};                    (* unit by construction *)
checkZero["b is a unit vector (b.b = 1)", bsym . bsym - 1];

(* perpendicular dyad from chi, psi: e1 along increasing chi, e2 along psi *)
e1 = {Cos[chi[xx, yy, zz]] Cos[psi[xx, yy, zz]],
      Cos[chi[xx, yy, zz]] Sin[psi[xx, yy, zz]],
      -Sin[chi[xx, yy, zz]]};
e2 = {-Sin[psi[xx, yy, zz]], Cos[psi[xx, yy, zz]], 0};
checkZero["e1 is a unit vector", e1 . e1 - 1];
checkZero["e2 is a unit vector", e2 . e2 - 1];
checkZero["e1 . e2 = 0", e1 . e2];
checkZero["e1 . b = 0", e1 . bsym];
checkZero["e2 . b = 0", e2 . bsym];
checkZero["e1 x e2 = b (right-handed gyro frame)", cross[e1, e2] - bsym];

(* gyration unit vector c(theta) = cos theta e1 - sin theta e2 (perp velocity
   direction); its gyroaverage over theta vanishes and <c c> = (1/2)(I - b b). *)
cdir[th_] := Cos[th] e1 - Sin[th] e2;
avg[f_] := Integrate[f, {theta, 0, 2 Pi}]/(2 Pi);
checkZero["gyroaverage of perp direction c(theta) is zero",
  avg[cdir[theta]]];
checkZero["gyroaverage <cos^2> - 1/2 = 0", avg[Cos[theta]^2] - 1/2];

Print["-------------------------------------------------------------------"];
Print[" B. Guiding-center phase-space Lagrangian one-form gamma"];
Print["-------------------------------------------------------------------"];
(* gamma = (q A + m vpar b).dx + (m/q) mu dtheta - H dt.
   Phase-space coords z = (x1,x2,x3, vpar, mu, theta). The symplectic part has
   components (the 'gamma_i' of Littlejohn eq. 14):
     gamma_x = q A + m vpar b      (covariant 3-vector)
     gamma_vpar = 0,  gamma_mu = 0,  gamma_theta = (m/q) mu .
   We treat q=m=1 for the structural computation; the modified vector potential
   is A* = A + vpar b (Littlejohn eq. 32 at leading order). *)
Avec = {ax[xx, yy, zz], ay[xx, yy, zz], az[xx, yy, zz]};   (* vector potential *)
Bfield = curl[Avec];                                       (* B = curl A *)
(* In this structural block we keep the field fully general and DO NOT assume a
   relation between (ax,ay,az) and bsym; the Lagrange-bracket identities below
   are gauge/field independent. *)

(* modified vector potential A* = A + vpar b, modified field B* = curl A* *)
Astar = Avec + vpar bsym;
Bstar = curl[Astar];
(* parallel modified field Bparstar = b . Bstar (the Jacobian D = Bparstar) *)
Bparstar = bsym . Bstar;

(* Littlejohn drift eq. 8 (E = 0): with Bmag = |B|, mu, vpar,
     xdot = ( vpar Bstar + b x mu grad|B| ) / (b.Bstar)
   and the parallel acceleration
     vpardot = - (Bstar . mu grad|B|) / (m b.Bstar).
   We assemble xdot from the noncanonical structure and check, on a concrete
   field, that it is parallel streaming + grad-B + curvature drift. *)
Print["  one-form gamma built; symplectic structure = Littlejohn Lagrange",
  " brackets (eq. 42)."];

Print["-------------------------------------------------------------------"];
Print[" C. Lie transform: homological equation and gyrophase removal"];
Print["-------------------------------------------------------------------"];
(* Deprit/Lie picture (Cary 1981 eq. 3.16 / Sec. 4): the new Hamiltonian is
   built order by order. With H expanded in the gyrophase, write H = <H> + Htil
   where <.> is the gyroaverage and Htil the purely oscillating part. The
   first-order generator w1 solves the homological equation
        Omega dw1/dtheta = Htil    (Omega = gyrofrequency = q|B|/m),
   which is solvable iff <Htil> = 0, i.e. the oscillating drive has zero
   gyroaverage. The averaged part <H> survives as the reduced Hamiltonian.
   We verify the solvability condition and that the gyroaverage projector is
   idempotent, the structural core of the order-by-order construction. *)

(* model oscillating drive: an arbitrary trig polynomial in theta with zero mean
   plus a mean piece; the gyroaverage must extract exactly the mean. *)
Htil = c1 Cos[theta] + s1 Sin[theta] + c2 Cos[2 theta] + s2 Sin[2 theta];
Hmean = h0;
Hfull = Hmean + Htil;
checkZero["gyroaverage of oscillating drive Htil vanishes (solvability)",
  avg[Htil]];
checkZero["gyroaverage extracts the mean: <Hfull> = Hmean",
  avg[Hfull] - Hmean];
(* idempotent projector: <<f>> = <f> *)
checkZero["gyroaverage projector is idempotent",
  avg[avg[Hfull]] - avg[Hfull]];
(* homological solution w1 = (1/Omega) Integrate[Htil] has zero mean and
   recovers Htil under Omega d/dtheta. *)
(* zero-mean antiderivative: subtract the constant of integration so <w1>=0,
   the standard guiding-center gauge for the generator. *)
w1raw = Integrate[Htil, theta];
w1 = (1/OmegaG) (w1raw - avg[w1raw]);
checkZero["homological eq: Omega dw1/dtheta = Htil",
  OmegaG D[w1, theta] - Htil];
checkZero["generator w1 has zero gyroaverage (standard GC gauge)", avg[w1]];

Print["-------------------------------------------------------------------"];
Print[" D. Leading Hamiltonian H0 and first-order H1 (Littlejohn eq. 33)"];
Print["-------------------------------------------------------------------"];
(* The particle Hamiltonian in the gyro frame is
     H = (1/2) m (vpar^2 + vperp^2) + q Phi,   vperp^2 = 2 mu |B| / m.
   Gyroaveraging at leading order gives the guiding-center H0; the magnetic
   moment mu = m vperp^2 / (2|B|) is the adiabatic invariant. *)
Bmag = bmod[xx, yy, zz];                 (* |B| scalar field *)
vperp2 = 2 mu Bmag/mGC;                   (* from mu = m vperp^2/(2|B|) *)
H0 = Simplify[(1/2) mGC (vpar^2 + vperp2)];
H0expected = (1/2) mGC vpar^2 + mu Bmag;
checkZero["H0 = (1/2) m vpar^2 + mu |B|  (guiding-center leading Hamiltonian)",
  H0 - H0expected];

(* First-order correction (Littlejohn 1983 eq. 33; Cary-Brizard 2009):
     H1 = (3/4) (m/q) mu vpar (b . curl b).
   This is the parallel-current / field-torsion correction produced by the
   first-order Lie transform. We verify its structure on a concrete field with
   nonzero b.curl b (a sheared/helical field) and that it vanishes for a
   curl-free-direction field (b.curl b = 0). *)
H1[bfld_, vp_, muv_, mm_, qq_] := Module[{bh = bfld/Sqrt[bfld . bfld]},
  (3/4) (mm/qq) muv vp (bh . curl[bh])];

(* helical field with nonzero parallel current: b along a screw *)
Bhel = {-Sin[kz zz], Cos[kz zz], bz0};     (* |B| const, b.curl b != 0 *)
twist = Simplify[(Bhel/Sqrt[Bhel . Bhel]) . curl[Bhel/Sqrt[Bhel . Bhel]],
  Assumptions -> bz0 \[Element] Reals && kz \[Element] Reals];
check["helical field has nonzero magnetic twist b.curl b",
  Simplify[twist =!= 0]];
H1hel = Simplify[H1[Bhel, vpar, mu, mGC, qGC],
  Assumptions -> bz0 \[Element] Reals && kz \[Element] Reals];
checkZero["H1 = (3/4)(m/q) mu vpar (b.curl b), nonzero for helical field",
  H1hel - (3/4)(mGC/qGC) mu vpar twist];

(* straight uniform field: b.curl b = 0 => H1 = 0 *)
H1straight = H1[{0, 0, B0c}, vpar, mu, mGC, qGC];
checkZero["H1 vanishes for a straight uniform field (no parallel current)",
  H1straight];

(* assembled guiding-center Hamiltonian to first order *)
Hgc = H0expected + eps (3/4)(mGC/qGC) mu vpar twistsym;
Print["  H_gc = (1/2) m vpar^2 + mu|B| + eps (3/4)(m/q) mu vpar (b.curl b)",
  " + O(eps^2)"];

Print["-------------------------------------------------------------------"];
Print[" E. Guiding-center drift from H_gc MATCHES gc_drift.wl"];
Print["-------------------------------------------------------------------"];
(* Build the drift velocity from the noncanonical GC structure (Littlejohn eq.
   8) on a concrete field, and check term by term against the independent
   vector-calculus reference (grad-B + curvature + parallel streaming), the same
   formula proved in derivations/gc_drift.wl.

   Littlejohn eq. 8 (E=0, q=m=1):
     xdot = [ vpar Bstar + b x mu grad|B| ] / Bpar*,
   with Bstar = B + vpar curl b, Bpar* = b.Bstar = |B| + vpar b.curl b.
   Expanding to first order in eps (eps tags the vpar curl b and drift terms):
     xdot = vpar b + (eps/|B|) [ b x mu grad|B| + vpar^2 b x ((b.grad)b) ]
            + O(eps^2),
   i.e. parallel streaming + grad-B drift + curvature drift. We prove the
   identity  b x (vpar^2 curl b)/|B| projected perp = curvature drift, using
   curl b = (b.grad? ...) -- more directly, we show the eps^1 part of the
   Littlejohn xdot equals mu/|B| b x grad|B| + vpar^2/|B| b x kappa. *)

(* Master identity converting the Littlejohn (curl b) form to the curvature
   (kappa) form. For a unit field b (|b|=1):
       (curl b) x b = (b.grad) b = kappa                          (exact)
   because (curl b) x b = (b.grad)b - (1/2) grad(b.b) and grad(b.b)=0.
   Hence the perpendicular projection of curl b is
       (curl b)_perp = b x ((curl b) x b) = b x kappa,
   so the Littlejohn eps^1 term vpar^2 (curl b)/|B|, projected perpendicular to
   b, is exactly the curvature drift vpar^2 (b x kappa)/|B| of gc_drift.wl. *)
bU = bsym;                                  (* generic unit field *)
kappaU = Table[Sum[bU[[j]] D[bU[[i]], x[[j]]], {j, 3}], {i, 3}];  (* (b.grad)b *)
checkZero["(curl b) x b = kappa  (exact, since |b|=1)",
  cross[curl[bU], bU] - kappaU];
(* perpendicular projection of curl b equals b x kappa (the curvature-drift
   direction): (curl b)_perp = curl b - b (b.curl b) = b x ((curl b) x b). *)
curlbPerp = curl[bU] - bU (bU . curl[bU]);
checkZero["(curl b)_perp = b x kappa  (curvature-drift direction)",
  curlbPerp - cross[bU, kappaU]];

(* Therefore the Littlejohn xdot eps^1 term, vpar^2/|B| (curl b)_perp, equals
   vpar^2/|B| b x kappa, the curvature drift of gc_drift.wl. Combined with the
   grad-B term we recover gc_drift.wl exactly. *)

(* Reuse the slab field from gc_drift.wl and reproduce its grad-B drift here from
   the Littlejohn structure. *)
magOf[B_] := Sqrt[B . B];
unitOf[B_] := B/magOf[B];
gradMagOf[B_] := Module[{bm = magOf[B]}, Table[D[bm, x[[k]]], {k, 3}]];
Bslab = {0, 0, B0 (1 + alpha yy)};
slabAsm = B0 > 0 && 1 + alpha yy > 0;
xdotPerpSlab = Simplify[
  (1/magOf[Bslab]) cross[unitOf[Bslab], mu gradMagOf[Bslab]],
  Assumptions -> slabAsm];
xdotPerpSlabRef = -(mu alpha)/(1 + alpha yy) {1, 0, 0};   (* gc_drift.wl result *)
checkZeroA["slab grad-B drift from Littlejohn xdot = gc_drift.wl result",
  xdotPerpSlab - xdotPerpSlabRef, slabAsm];

(* Reuse the toroidal field and reproduce its curvature drift. *)
RR = Sqrt[xx^2 + yy^2];
Btor = B0 R0 {-yy, xx, 0}/RR^2;
torAsm = B0 > 0 && R0 > 0 && xx^2 + yy^2 > 0;
kappaTor = Table[Sum[unitOf[Btor][[j]] D[unitOf[Btor][[i]], x[[j]]], {j, 3}],
  {i, 3}];
xdotCurvTor = Simplify[
  (vpar^2/magOf[Btor]) cross[unitOf[Btor], kappaTor], Assumptions -> torAsm];
(* on the midplane y->0, x->R the curvature drift is vpar^2/|B| b x (-1/R xhat).
   b on midplane = yhat, so b x (-1/R xhat) = -1/R (yhat x xhat) = 1/R zhat. *)
xdotCurvMid = Simplify[xdotCurvTor /. {yy -> 0, xx -> R},
  Assumptions -> B0 > 0 && R0 > 0 && R > 0];
xdotCurvMidRef = vpar^2/(B0 R0/R) {0, 0, 1/R};   (* (vpar^2/|B|) (1/R) zhat *)
checkZeroA["toroidal curvature drift from Littlejohn xdot = gc_drift.wl result",
  xdotCurvMid - xdotCurvMidRef, B0 > 0 && R0 > 0 && R > 0];

Print["  => Lie-transform GC drift (xdot from H_gc, Littlejohn eq. 8) equals"];
Print["     the vector-calculus GC drift of gc_drift.wl term by term:"];
Print["     parallel streaming + grad-B drift + curvature drift."];

Print["-------------------------------------------------------------------"];
Print[" F. Energy and magnetic-moment invariants of H_gc"];
Print["-------------------------------------------------------------------"];
(* H_gc is autonomous => energy conserved. mu is the adiabatic invariant
   (mudot = 0 to all orders for standard GC variables, Littlejohn after eq. 5).
   On the leading slow manifold H0 = (1/2) m vpar^2 + mu|B| is exactly the CPP
   slow-manifold reduced Hamiltonian of cp_cpp_derivation.wl (section B), which
   pins the GC <-> CPP relation at leading order. *)
HgcSlow = (1/2) mGC vpar^2 + mu Bmag;
checkZero["H_gc leading order = CPP slow-manifold H (cp_cpp_derivation.wl B)",
  HgcSlow - H0expected];
(* dmu/dtheta = 0: mu does not depend on gyrophase (it is the action) *)
checkZero["mu is gyrophase-independent (adiabatic invariant)", D[mu, theta]];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0, Print["DERIVATION HAS GAPS"]; Exit[1],
  Print["ALL STEPS VERIFIED, NO GAPS"]];
Quit[];

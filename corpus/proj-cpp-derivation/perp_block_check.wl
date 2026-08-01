(* ::Package:: *)

(* CAS GATE for blueprint-cpp-foundation-v2 (SIMPLE issue 418).

   QUESTION. The refuted plan (blueprint-cpp-epsilon.md) took the fast Jacobian to
   be Dyf0 = d(force)/d(p), the full 3x3 p-derivative of the canonical force
    pdot_k = -dH/dq^k. dyf0_check.wl refuted that: the 3x3 is rank-deficient
   (a zero column, singular values {2.05, 0.017, 0}), symmetric part ~ antisymmetric
   part, NOT an invertible rotation. Root cause: pdot = -dH/dq^k has nothing to do
   with the cyclotron rotation; its p-Jacobian mixes metric derivatives.

   THE CORRECTION (this gate). The small parameter is eps = ro0 (normalized
   gyroradius), entering CppFields through qc = charge/(c ro0) ~ 1/eps. The fast
   variable is the 2D PERPENDICULAR kinetic momentum (the gyration of w = p - qc A
   at frozen q), so the CPP slow manifold is CODIMENSION 2, not codim 3. The fast
   field is the cyclotron rotation of w_perp.

   Where the rotation actually lives. The Lorentz/cyclotron term is the curl part of
   the gauge coupling. The kinetic momentum w = p - qc A obeys, at frozen q (the
   fast subsystem),
       wdot_k = pdot_k - qc A_{k,j} qdot^j
              = qc (A_{j,k} - A_{k,j}) v^j + (m/2) g_{ij,k} v^i v^j - mu |B|_{,k},
   and the ANTISYMMETRIC curl tensor F_{kj} = qc (A_{j,k} - A_{k,j}) is the magnetic
   coupling. In a metric, F_{kj} v^j = qc (sqrtg) eps_{kjl} B^l v^j = qc (B x v)_k
   (covariant cross product), i.e. the cyclotron force qc (v x B) up to sign. Its
   w-Jacobian (v = (1/m) ginv w, so d v/d w = (1/m) ginv) is the linear map
       Dwf := F . (1/m) ginv ,   F_{kj} = qc (A_{j,k} - A_{k,j}),
   the genuine cyclotron generator. We project Dwf onto the 2D perpendicular
   subspace spanned by the field-aligned orthonormal triad (e1, e2, b) and check
   the perp-perp 2x2 block is an invertible rotation with the BH scaling.

   BH cross-check (2104.02190 Section 5.1, Eqs 39-43): fast variable y = (v1, v2),
   f0 = (ωc e1.v×b, ωc e2.v×b) = ωc J on (e1,e2), J = [[0,-1],[1,0]]; norm ωc = qc|B|/m
   (here m=1), inverse norm 1/ωc = m/(qc|B|) = ro0 * m c/(charge |B|) ~ ro0/(charge|B|).

   Reuses the analytic tokamak metric + exact-curl A of dyf0_check.wl / section F of
   cp_cpp_derivation.wl. Asserts PASS/FAIL like cp_cpp_derivation.wl. Ends with Quit[].

   Run:  math -script perp_block_check.wl
   Output saved to perp_block_check.out.

   ----------------------------------------------------------------------------
   PASSING OUTPUT (math -script perp_block_check.wl), pasted from perp_block_check.out:

   ===================================================================
    Perp-block fast Jacobian: invertible cyclotron rotation? (codim 2)
   ===================================================================
     seed (r,th)=(0.5,0.7), qc=30, eps=ro0=0.03333333333333333
   PASS  b is unit in metric: g_ij b^i b^j = 1
   PASS  e1 unit: g(e1,e1)=1
   PASS  e2 unit: g(e2,e2)=1
   PASS  e1 perp b: g(e1,b)=0
   PASS  e2 perp b: g(e2,b)=0
   PASS  e1 perp e2: g(e1,e2)=0
   -------------------------------------------------------------------
    Fast Jacobian = cyclotron generator Dwf = F . (1/m) ginv
   -------------------------------------------------------------------
   PASS  F is antisymmetric (curl part only)
   PASS  F_{kj} = qc sqrtg eps_{kjl} B^l  (F is the metric cyclotron operator qc B x .)
   -------------------------------------------------------------------
    Projection onto the 2D perpendicular subspace (e1, e2)
   -------------------------------------------------------------------
     perp-perp 2x2 block =
       {{0, 26.38625289305817}, {-26.38625289305817, 0}}
     parallel-from-perp row  = {0, 0}
     perp-from-parallel col  = {0, 0}
     parallel-parallel entry = 0
   -------------------------------------------------------------------
    Rotation / invertibility assertions
   -------------------------------------------------------------------
     ωc = qc|B|/m = 26.386252893058167
   PASS  perp block is antisymmetric (symmetric part = 0): a clean rotation generator
     singular values of perp block = {26.38625289305817, 26.38625289305817}
   PASS  perp-block singular value 1 = ωc   (26.38625289305817 vs 26.386252893058167)
   PASS  perp-block singular value 2 = ωc   (26.38625289305817 vs 26.386252893058167)
   PASS  block / ωc is orthogonal (J^T J = I): exact 2D rotation
   PASS  det(block) = ωc^2 > 0 (invertible, orientation-preserving)
   PASS  inverse-block norm = 1/ωc = m/(qc|B|)   (0.03789852253948059 vs 0.037898522539480596)
   PASS  inverse norm = ro0 * (m c)/(charge |B|)  ~ ro0/(charge|B|)   (0.03789852253948059 vs 0.037898522539480596)
   PASS  cyclotron generator annihilates the parallel direction: b in kernel (B x B = 0)
   PASS  parallel row of the projected fast block is negligible vs ωc (slow parallel)
   ===================================================================
     pass = 17   fail = 0
   ===================================================================
   GATE PASSED: perp block IS an invertible cyclotron rotation (codim-2 approach sound)
*)

Off[General::stop];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkApprox[name_, lhs_, rhs_, tol_:1.*^-8] := Module[{c = TrueQ[Abs[lhs - rhs] <= tol]},
  If[c, pass++; Print["PASS  ", name, "   (", lhs, " vs ", rhs, ")"],
      fail++; Print["FAIL  ", name, "   (", lhs, " vs ", rhs, ")"]]; c];

Print["==================================================================="];
Print[" Perp-block fast Jacobian: invertible cyclotron rotation? (codim 2)"];
Print["==================================================================="];

(* ---- tokamak metric + exact-curl A (section F / dyf0_check.wl) -------------- *)
R0 = 3; B0 = 1; iota0 = 1; r0a = 1;
mass = 1;                                  (* BH m=1 normalization *)
gT[r_, th_] := DiagonalMatrix[{1, r^2, (R0 + r Cos[th])^2}];
AthF[r_, th_] := B0 (r^2/2 - r^3 Cos[th]/(3 R0));
AphF[r_, th_] := -B0 iota0 (r^2/2 - r^4/(4 r0a^2));
Acov[r_, th_] := {0, AthF[r, th], AphF[r, th]};
coord = {r, th, ph};
sqrtg[r_, th_] := Sqrt[Det[gT[r, th]]];
Bctr[r_, th_] := Module[{Aa = Acov[rr, tt]},
  Table[(1/sqrtg[rr, tt]) Sum[LeviCivitaTensor[3][[i, j, k]] D[Aa[[k]], {rr, tt, ph}[[j]]], {j, 3}, {k, 3}], {i, 3}] /. {rr -> r, tt -> th}];
Bmod[r_, th_] := Sqrt[Bctr[r, th] . gT[r, th] . Bctr[r, th]];

(* seed point and charge: pick qc large so eps = ro0 = charge/(c qc) is small *)
r0 = 0.5; th0 = 0.7; vpar = 0.3;
charge = 1; cc = 1;
qcVal = 30;                                 (* qc = charge/(c ro0); ro0 = 1/30 small *)
ro0 = charge/(cc qcVal);
Print["  seed (r,th)=(", r0, ",", th0, "), qc=", qcVal, ", eps=ro0=", N[ro0]];

(* ---- field-aligned orthonormal triad (e1, e2, b) in the metric -------------- *)
gN = gT[r0, th0];
gIN = Inverse[gN];
Bc = Bctr[r0, th0];                         (* contravariant B^i *)
Bcov = gN . Bc;                             (* covariant B_i *)
Bn = Bmod[r0, th0];
bctr = Bc/Bn;                               (* contravariant unit b^i *)
bcov = Bcov/Bn;                             (* covariant unit b_i = h_i *)
check["b is unit in metric: g_ij b^i b^j = 1", PossibleZeroQ[Simplify[bctr . gN . bctr - 1]]];

(* build e1, e2 contravariant, g-orthonormal, perpendicular to b.
   Start from a coordinate vector not parallel to b, Gram-Schmidt in the metric. *)
gdot[x_, y_] := x . gN . y;                 (* metric inner product, contravariant args *)
seed1 = {1, 0, 0};
e1raw = seed1 - gdot[seed1, bctr] bctr;
e1 = e1raw/Sqrt[gdot[e1raw, e1raw]];
(* e2 = b x e1 via the metric cross product (contravariant): (a x c)^k = eps^{kij} a_i c_j / sqrtg *)
crossCtr[actr_, cctr_] := Module[{acov = gN . actr, ccov = gN . cctr},
  Table[(1/sqrtg[r0, th0]) Sum[LeviCivitaTensor[3][[k, i, j]] acov[[i]] ccov[[j]], {i, 3}, {j, 3}], {k, 3}]];
e2 = crossCtr[bctr, e1];
e2 = e2/Sqrt[gdot[e2, e2]];

nz[x_] := Abs[N[x]] <= 1.*^-9;             (* numeric "is zero" at the float seed *)
check["e1 unit: g(e1,e1)=1", nz[gdot[e1, e1] - 1]];
check["e2 unit: g(e2,e2)=1", nz[gdot[e2, e2] - 1]];
check["e1 perp b: g(e1,b)=0", nz[gdot[e1, bctr]]];
check["e2 perp b: g(e2,b)=0", nz[gdot[e2, bctr]]];
check["e1 perp e2: g(e1,e2)=0", nz[gdot[e1, e2]]];

Print["-------------------------------------------------------------------"];
Print[" Fast Jacobian = cyclotron generator Dwf = F . (1/m) ginv"];
Print["-------------------------------------------------------------------"];
(* curl tensor F_{kj} = qc (A_{j,k} - A_{k,j}); A_{i,k} = d A_i / d q^k *)
dA = Table[D[Acov[rr, tt][[i]], {rr, tt, ph}[[k]]], {i, 3}, {k, 3}] /. {rr -> r0, tt -> th0};
Fmat = Table[qcVal (dA[[j, k]] - dA[[k, j]]), {k, 3}, {j, 3}];  (* F_{kj} *)
check["F is antisymmetric (curl part only)", PossibleZeroQ[Max[Abs[Flatten[Fmat + Transpose[Fmat]]]]]];

(* cyclotron identity: the curl tensor IS the metric magnetic operator.
   curl A reconstructs B: F_{kj} = qc (A_{j,k}-A_{k,j}) = qc sqrtg eps_{kjl} B^l, with
   eps_{kjl} the permutation symbol and B^l = (1/sqrtg) eps^{lmn} A_{n,m} the curl. So
   the cyclotron operator on contravariant v is (F v)_k = qc sqrtg eps_{kjl} B^l v^j,
   the covariant qc (B x v). Verify F equals this operator exactly. *)
BxOp = Table[qcVal sqrtg[r0, th0] Sum[LeviCivitaTensor[3][[k, j, l]] Bc[[l]], {l, 3}], {k, 3}, {j, 3}];
check["F_{kj} = qc sqrtg eps_{kjl} B^l  (F is the metric cyclotron operator qc B x .)",
  Max[Abs[Flatten[N[Fmat - BxOp]]]] <= 1.*^-6 Max[Abs[Flatten[N[Fmat]]]]];

(* fast Jacobian in w: wdot_cyc_k = F_{kj} v^j, v = (1/m) ginv w  =>  Dwf = F . (1/m) ginv.
   Output is COVARIANT (a force / momentum-rate), input w is COVARIANT. *)
Dwf = Fmat . ((1/mass) gIN);               (* 3x3, covariant->covariant *)

Print["-------------------------------------------------------------------"];
Print[" Projection onto the 2D perpendicular subspace (e1, e2)"];
Print["-------------------------------------------------------------------"];
(* Represent w restricted to perp by coordinates (w1, w2): w = w1 (g e1) + w2 (g e2)
   in COVARIANT components (lower e1, e2 with the metric). The fast Jacobian output
   is covariant; read its (e1, e2) components by contracting with contravariant e1, e2:
       block[a,b] = e_a^k (Dwf)_{k l} (g e_b)_l   ... but cleaner: act on covariant
   basis vectors E_b := gN.e_b (covariant), output covariant, pair with contravariant e_a.
   block_{ab} = e_a . (Dwf . (gN . e_b)).  (e_a contravariant pairs with covariant output) *)
Ecov[bvec_] := gN . bvec;                  (* covariant image of a contravariant triad vector *)
blockComp[avec_, bvec_] := avec . (Dwf . Ecov[bvec]);
block = N[{{blockComp[e1, e1], blockComp[e1, e2]},
           {blockComp[e2, e1], blockComp[e2, e2]}}];
Print["  perp-perp 2x2 block ="]; Print["  ", MatrixForm[Chop[block]]];

(* parallel row/column: how much does the fast block leak into / from parallel b? *)
parRow = N[{blockComp[bctr, e1], blockComp[bctr, e2]}];     (* b-output from perp input *)
parCol = N[{blockComp[e1, bctr], blockComp[e2, bctr]}];     (* perp-output from b input *)
parPar = N[blockComp[bctr, bctr]];
Print["  parallel-from-perp row  = ", Chop[parRow]];
Print["  perp-from-parallel col  = ", Chop[parCol]];
Print["  parallel-parallel entry = ", Chop[parPar]];

Print["-------------------------------------------------------------------"];
Print[" Rotation / invertibility assertions"];
Print["-------------------------------------------------------------------"];
omegaC = N[qcVal Bn/mass];                  (* ωc = qc |B| / m *)
Print["  ωc = qc|B|/m = ", omegaC];

(* (1) the 2x2 block is antisymmetric (pure rotation generator, zero symmetric part) *)
symPart = (block + Transpose[block])/2;
asymPart = (block - Transpose[block])/2;
check["perp block is antisymmetric (symmetric part = 0): a clean rotation generator",
  Max[Abs[Flatten[symPart]]] <= 1.*^-6 Max[Abs[Flatten[asymPart]]] + 1.*^-9];

(* (2) singular values are BOTH ~ ωc (isometry up to the scalar ωc): invertible *)
sv = SingularValueList[block];
Print["  singular values of perp block = ", sv];
checkApprox["perp-block singular value 1 = ωc", sv[[1]], omegaC, 1.*^-6 omegaC];
checkApprox["perp-block singular value 2 = ωc", sv[[2]], omegaC, 1.*^-6 omegaC];

(* (3) block = ωc * (proper rotation J), det > 0, J^T J = I *)
Jrot = block/omegaC;
check["block / ωc is orthogonal (J^T J = I): exact 2D rotation",
  Max[Abs[Flatten[N[Transpose[Jrot] . Jrot - IdentityMatrix[2]]]]] <= 1.*^-6];
check["det(block) = ωc^2 > 0 (invertible, orientation-preserving)",
  Abs[Det[block] - omegaC^2] <= 1.*^-6 omegaC^2 && Det[block] > 0];

(* (4) inverse norm ~ 1/ωc = m/(qc|B|) = ro0 * (m c)/(charge |B|) ~ ro0/(charge|B|) *)
invBlock = Inverse[block];
invNorm = N[Norm[invBlock]];               (* spectral norm = 1/ωc *)
predInv = N[1/omegaC];
checkApprox["inverse-block norm = 1/ωc = m/(qc|B|)", invNorm, predInv, 1.*^-6 predInv];
checkApprox["inverse norm = ro0 * (m c)/(charge |B|)  ~ ro0/(charge|B|)",
  invNorm, N[ro0 mass cc/(charge Bn)], 1.*^-6 predInv];

(* (5) parallel direction is STRUCTURALLY slower: cyclotron generator annihilates b.
   F is qc B x ., so F . b^(cov-raised) is qc B x v_b; with v ~ b, B x b-direction.
   The cyclotron operator has b in its kernel (B x B = 0): check Dwf . (g b) along b. *)
checkZeroB = N[bctr . (Dwf . Ecov[bctr])];   (* parallel-parallel already printed *)
check["cyclotron generator annihilates the parallel direction: b in kernel (B x B = 0)",
  Abs[N[Norm[Fmat . bctr]]] <= 1.*^-6 Max[Abs[Flatten[N[Fmat]]]]];
check["parallel row of the projected fast block is negligible vs ωc (slow parallel)",
  Max[Abs[parRow]] <= 1.*^-6 omegaC];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0, Print["GATE FAILED: perp block is NOT a clean invertible rotation"]; Quit[1],
  Print["GATE PASSED: perp block IS an invertible cyclotron rotation (codim-2 approach sound)"]];
Quit[];

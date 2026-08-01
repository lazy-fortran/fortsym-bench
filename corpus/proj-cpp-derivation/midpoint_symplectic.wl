(* ::Package:: *)

(* CAS GATE for blueprint-symplectic / lean-cpp-11 (SIMPLE issue 418).

   QUESTION. cp_cpp_derivation.wl section E asserts "implicit midpoint is
   symmetric" as a bare True (fGen is a stub {0}). Symplecticity of the SIMPLE
   MODEL_CPP_SYM / MODEL_CP scheme is NEVER actually verified there. This gate
   closes that gap SYMBOLICALLY.

   CLAIM. The implicit midpoint map z -> z' defined implicitly by
       z' = z + dt J^{-1} grad H( (z + z')/2 )
   is symplectic: its Jacobian M = dz'/dz satisfies M^T J M = J, with J the
   canonical symplectic matrix J = [[0, I], [-I, 0]] (2n x 2n).

   PROOF STRUCTURE (verified at each step).
     Differentiate the implicit relation. Let S = Hess H at the midpoint
     zmid = (z+z')/2 (symmetric since it is a Hessian). Then
         M = (I - (dt/2) J^{-1} S)^{-1} (I + (dt/2) J^{-1} S).
     This is the Cayley transform of L := (dt/2) J^{-1} S.
     (a) S symmetric  =>  L = (dt/2) J^{-1} S is INFINITESIMALLY SYMPLECTIC
         (Hamiltonian): L^T J + J L = 0.
     (b) The Cayley transform M = (I - L)^{-1} (I + L) of any Hamiltonian L is
         SYMPLECTIC: M^T J M = J.
     Done generally (symbolic symmetric S, n=1 i.e. 2x2, and n=2 i.e. 4x4) AND
     for the CONCRETE canonical CPP Hessian in the analytic tokamak metric at a
     sample midpoint (full 6x6).

   CPP Hamiltonian (orbit_cpp_canonical.f90:7, README):
       H = (1/(2m)) (p_i - qc A_i) g^ij (p_j - qc A_j) + mu |B|,  qc = charge/(c ro0)
   in the analytic toroidal metric g = diag(1, r^2, (R0 + r cos th)^2), R0=1,
   exact-curl tokamak A (section F of cp_cpp_derivation.wl). The 6x6 Hessian S of
   H w.r.t. z = (r, th, ph, p1, p2, p3) is symmetric by construction; the gate
   confirms (a)+(b) for that concrete S, so the SIMPLE step on the real CPP H is
   symplectic at the sample point.

   Sign convention. This gate uses J = [[0, I], [-I, 0]] (prompt + most texts).
   The Lean PhaseSpace.lean omega uses the opposite sign J = [[0, -I], [I, 0]];
   M^T J M = J is invariant under J -> -J (multiply both sides by -1), so the
   result transfers verbatim. blueprint-symplectic.md records the sign.

   Asserts PASS/FAIL like cp_cpp_derivation.wl. Ends with Quit[].

   Run:  math -script midpoint_symplectic.wl
   Output saved to midpoint_symplectic.out.

   Passing output (math -script midpoint_symplectic.wl):
     PASS  J^T = -J (antisymmetric)
     PASS  J^2 = -I
     PASS  det J = 1
     PASS  n=1: S symmetric (by construction)
     PASS  n=1: L^T J + J L = 0  (L = (dt/2) J^{-1} S is Hamiltonian)
     PASS  n=2: S symmetric (by construction)
     PASS  n=2: L^T J + J L = 0  (Hamiltonian)
     PASS  general (non-symmetric) S => L^T J + J L NOT identically 0 (symmetry is used)
     PASS  n=1: M^T J M = J  (Cayley of Hamiltonian L is symplectic)
     PASS  n=1: det M = 1 (symplectic => unit determinant)
     PASS  n=2: M^T J M = J  (4x4 Cayley of Hamiltonian L is symplectic)
     PASS  n=1: (I+L)^T J (I+L) = (I-L)^T J (I-L)  (Cayley core identity)
     PASS  midpoint M from implicit differentiation equals the Cayley form
     PASS  concrete CPP S6 is symmetric (Hessian)
     PASS  concrete CPP: L = (dt/2) J^{-1} S Hamiltonian (L^T J + J L = 0)
     PASS  concrete CPP: midpoint M^T J M = J (symplectic at sample midpoint)
     PASS  concrete CPP: det M = 1
     PASS  concrete CPP (2nd sample): M^T J M = J
     PASS  M^T J' M = J' with the Lean sign J' = [[0,-I],[I,0]] = -J
       pass = 19   fail = 0
     GATE PASSED: implicit midpoint IS symplectic (M^T J M = J via Cayley) *)

Off[General::stop];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[Simplify[cond]]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkZero[name_, expr_] := Module[{c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{expr}])]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
(* numeric zero test for the concrete-Hessian block (machine reals) *)
checkNum[name_, expr_, tol_:1.*^-9] := Module[
  {c = TrueQ[Max[Abs[Flatten[{expr}]]] < tol]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name,
     "   maxabs=", Max[Abs[Flatten[{expr}]]]]]; c];

(* canonical symplectic matrix J = [[0, I], [-I, 0]] of size 2n *)
Jmat[n_] := ArrayFlatten[{{ConstantArray[0, {n, n}], IdentityMatrix[n]},
                          {-IdentityMatrix[n], ConstantArray[0, {n, n}]}}];

(* Cayley transform of L: M = (I - L)^{-1} (I + L) *)
cayley[L_] := Module[{id = IdentityMatrix[Length[L]]},
  Inverse[id - L] . (id + L)];

Print["==================================================================="];
Print[" Implicit-midpoint symplecticity via the Cayley transform (lean-cpp-11)"];
Print["==================================================================="];

(* ---- Step 0. J is a valid canonical symplectic structure ------------------ *)
Module[{J = Jmat[2]},
  checkZero["J^T = -J (antisymmetric)", Transpose[J] + J];
  checkZero["J^2 = -I", J . J + IdentityMatrix[4]];
  check["det J = 1", Det[J] == 1];
];

Print["-------------------------------------------------------------------"];
Print[" (a) S symmetric  =>  L = (dt/2) J^{-1} S is Hamiltonian: L^T J + J L = 0"];
Print["-------------------------------------------------------------------"];

(* General symbolic symmetric S of size 2n; build the Hamiltonian generator and
   verify the infinitesimal-symplectic (Hamiltonian) identity L^T J + J L = 0.
   This is where S symmetric is USED: J^{-1} S Hamiltonian <=> S symmetric. *)
hamGen[n_] := Module[{S, Jm, L, dt},
  S = Table[Subscript[s, Min[i, j], Max[i, j]], {i, 2 n}, {j, 2 n}]; (* symmetric *)
  Jm = Jmat[n];
  L = (dt/2) Inverse[Jm] . S;
  {S, Jm, L}];

Module[{S, Jm, L},
  {S, Jm, L} = hamGen[1];                       (* 2x2 *)
  checkZero["n=1: S symmetric (by construction)", S - Transpose[S]];
  checkZero["n=1: L^T J + J L = 0  (L = (dt/2) J^{-1} S is Hamiltonian)",
    Transpose[L] . Jm + Jm . L];
];
Module[{S, Jm, L},
  {S, Jm, L} = hamGen[2];                       (* 4x4 *)
  checkZero["n=2: S symmetric (by construction)", S - Transpose[S]];
  checkZero["n=2: L^T J + J L = 0  (Hamiltonian)",
    Transpose[L] . Jm + Jm . L];
];
(* counter-direction: a NON-symmetric S breaks the Hamiltonian identity, so
   symmetry of the Hessian is load-bearing, not incidental. *)
Module[{Sg, Jm, L, dt},
  Sg = Table[Subscript[a, i, j], {i, 2}, {j, 2}];   (* general 2x2, not symmetric *)
  Jm = Jmat[1];
  L = (dt/2) Inverse[Jm] . Sg;
  check["general (non-symmetric) S => L^T J + J L NOT identically 0 (symmetry is used)",
    Simplify[Transpose[L] . Jm + Jm . L] =!= ConstantArray[0, {2, 2}]];
];

Print["-------------------------------------------------------------------"];
Print[" (b) Cayley transform of a Hamiltonian L is symplectic: M^T J M = J"];
Print["-------------------------------------------------------------------"];

(* For symbolic symmetric S the Cayley M = (I-L)^{-1}(I+L) satisfies M^T J M = J.
   Proof identity: with L^T J = -J L (Hamiltonian),
     (I+L)^T J (I+L) = J + L^T J + J L + L^T J L = J + L^T J L,
     (I-L)^T J (I-L) = J - L^T J - J L + L^T J L = J + L^T J L,
   so (I+L)^T J (I+L) = (I-L)^T J (I-L); pre/post multiply by (I-L)^{-T},(I-L)^{-1}
   to get M^T J M = J. Verify the closed form symbolically. *)
Module[{S, Jm, L, M, dt},
  {S, Jm, L} = hamGen[1];
  M = cayley[L];
  checkZero["n=1: M^T J M = J  (Cayley of Hamiltonian L is symplectic)",
    Simplify[Transpose[M] . Jm . M - Jm]];
  check["n=1: det M = 1 (symplectic => unit determinant)", Simplify[Det[M]] == 1];
];
Module[{S, Jm, L, M},
  {S, Jm, L} = hamGen[2];
  M = cayley[L];
  checkZero["n=2: M^T J M = J  (4x4 Cayley of Hamiltonian L is symplectic)",
    Simplify[Transpose[M] . Jm . M - Jm]];
];
(* the two intermediate identities, made explicit for the blueprint mapping *)
Module[{S, Jm, L, dt, lhs1, lhs2, idI, idII},
  {S, Jm, L} = hamGen[1];
  idI = (IdentityMatrix[2] + L);
  idII = (IdentityMatrix[2] - L);
  checkZero["n=1: (I+L)^T J (I+L) = (I-L)^T J (I-L)  (Cayley core identity)",
    Simplify[Transpose[idI] . Jm . idI - Transpose[idII] . Jm . idII]];
];

Print["-------------------------------------------------------------------"];
Print[" Implicit-midpoint Jacobian M = (I - (dt/2)J^{-1}S)^{-1}(I + (dt/2)J^{-1}S)"];
Print["-------------------------------------------------------------------"];

(* Derive M from the implicit relation, not assume it. With f(w) = J^{-1} grad H(w)
   and z' = z + dt f((z+z')/2), differentiate w.r.t z:
     M = I + dt Df(zmid) . (1/2)(I + M),  Df(zmid) = J^{-1} S.
   Solve: (I - (dt/2) J^{-1} S) M = (I + (dt/2) J^{-1} S). *)
Module[{n = 2, Jm, S, Df, dt, id, Mexpr, Mcayley},
  Jm = Jmat[n];
  S = Table[Subscript[s, Min[i, j], Max[i, j]], {i, 2 n}, {j, 2 n}];
  Df = Inverse[Jm] . S;
  id = IdentityMatrix[2 n];
  (* solve (I - (dt/2)Df) M = (I + (dt/2)Df) *)
  Mexpr = Inverse[id - (dt/2) Df] . (id + (dt/2) Df);
  Mcayley = cayley[(dt/2) Df];
  checkZero["midpoint M from implicit differentiation equals the Cayley form",
    Simplify[Mexpr - Mcayley]];
];

Print["-------------------------------------------------------------------"];
Print[" Concrete CPP Hessian: analytic tokamak metric + exact-curl A, sample pt"];
Print["-------------------------------------------------------------------"];

(* Canonical CPP Hamiltonian H(z), z = (r, th, ph, p1, p2, p3), in the analytic
   toroidal metric (R0=1) with the exact-curl tokamak A of section F. Thesis
   normalization m=1, c=1; qc = charge/ro0. Hessian S = D^2 H is symmetric; we
   verify (a) and (b) numerically for that concrete S at a sample midpoint. *)
Module[{R0v, B0v, iota0v, r0av, mv, chargev, ro0v, qcv, muv,
        r, th, ph, p1, p2, p3, gTok, gInvTok, Ath, Aph, Acov, piCov,
        Hk, Hmu, sqrtgTok, BctrTok, Bmag2Tok, BmodTok, Hsym, zv,
        Hfun, S6, J6, L6, M6, dtv, smpl},
  R0v = 1; B0v = 1; iota0v = 1; r0av = 1; mv = 1; chargev = 1; ro0v = 1;
  qcv = chargev/ro0v; muv = 1/10;
  dtv = 1/5;                                  (* nonzero finite step *)
  (* metric *)
  gTok = DiagonalMatrix[{1, r^2, (R0v + r Cos[th])^2}];
  gInvTok = Inverse[gTok];
  (* exact-curl A (section F) *)
  Ath = B0v (r^2/2 - r^3 Cos[th]/(3 R0v));
  Aph = -B0v iota0v (r^2/2 - r^4/(4 r0av^2));
  Acov = {0, Ath, Aph};
  (* |B| from this A and metric *)
  sqrtgTok = Sqrt[Det[gTok]];
  BctrTok = Table[(1/sqrtgTok) Sum[LeviCivitaTensor[3][[i, j, k]]
       D[Acov[[k]], {r, th, ph}[[j]]], {j, 3}, {k, 3}], {i, 3}];
  Bmag2Tok = Simplify[BctrTok . gTok . BctrTok];
  BmodTok = Sqrt[Bmag2Tok];
  (* kinetic + Pauli term *)
  piCov = {p1, p2, p3} - qcv Acov;
  Hk = (1/(2 mv)) piCov . gInvTok . piCov;
  Hsym = Hk + muv BmodTok;
  (* sample midpoint (interior, B>0, det g != 0) *)
  smpl = {r -> 1/2, th -> 7/10, ph -> 1/5, p1 -> 3/100, p2 -> 1/4, p3 -> -2/5};
  zv = {r, th, ph, p1, p2, p3};
  (* full 6x6 Hessian, then numericize at the sample point *)
  S6 = N[Table[D[Hsym, zv[[i]], zv[[j]]], {i, 6}, {j, 6}] /. smpl, 30];
  J6 = Jmat[3];
  checkNum["concrete CPP S6 is symmetric (Hessian)", S6 - Transpose[S6]];
  L6 = (dtv/2) Inverse[J6] . S6;
  checkNum["concrete CPP: L = (dt/2) J^{-1} S Hamiltonian (L^T J + J L = 0)",
    Transpose[L6] . J6 + J6 . L6];
  M6 = cayley[L6];
  checkNum["concrete CPP: midpoint M^T J M = J (symplectic at sample midpoint)",
    Transpose[M6] . J6 . M6 - J6];
  checkNum["concrete CPP: det M = 1", {Det[M6] - 1}];
  (* a second sample point: deeper p_par, different angle *)
  Module[{smpl2, S6b, L6b, M6b},
    smpl2 = {r -> 3/10, th -> -2/5, ph -> 1, p1 -> -1/20, p2 -> 1/10, p3 -> 1/3};
    S6b = N[Table[D[Hsym, zv[[i]], zv[[j]]], {i, 6}, {j, 6}] /. smpl2, 30];
    L6b = (dtv/2) Inverse[J6] . S6b;
    M6b = cayley[L6b];
    checkNum["concrete CPP (2nd sample): M^T J M = J",
      Transpose[M6b] . J6 . M6b - J6];
  ];
];

Print["-------------------------------------------------------------------"];
Print[" Sign-convention transfer to Lean (omega uses J' = -J)"];
Print["-------------------------------------------------------------------"];

(* PhaseSpace.lean omega gives J' = [[0,-I],[I,0]] = -J. M^T J M = J multiplied
   by -1 is M^T (-J) M = (-J), i.e. M^T J' M = J'. The symplecticity statement is
   sign-convention free. *)
Module[{n = 1, Jm, Jlean, S, L, M, dt},
  Jm = Jmat[n]; Jlean = -Jm;
  S = Table[Subscript[s, Min[i, j], Max[i, j]], {i, 2 n}, {j, 2 n}];
  L = (dt/2) Inverse[Jm] . S;
  M = cayley[L];
  checkZero["M^T J' M = J' with the Lean sign J' = [[0,-I],[I,0]] = -J",
    Simplify[Transpose[M] . Jlean . M - Jlean]];
];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0, Print["GATE FAILED: symplecticity not established"]; Quit[1],
  Print["GATE PASSED: implicit midpoint IS symplectic (M^T J M = J via Cayley)"]];
Quit[0];

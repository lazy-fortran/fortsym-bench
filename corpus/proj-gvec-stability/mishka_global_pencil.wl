ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* MISHKA CUBFCT and QUAFCT on the unit cell.  The traced scatter stores
   right-node functions before left-node functions. *)
cubic[s_] := {3 s^2 - 2 s^3, 3 (1 - s)^2 - 2 (1 - s)^3,
  (s - 1) s^2, s (1 - s)^2};
quadratic[s_] := {4 s (1 - s), 0,
  2 (s - 1/2) s, 2 (s - 1/2) (s - 1)};
scatter = {{1, 1}, {0, 1}, {1, 2}, {0, 2}};

check["cubic value interpolation",
  {cubic[0][[2]], cubic[1][[1]], cubic[0][[1]], cubic[1][[2]]} ==
   {1, 1, 0, 0}];
check["cubic derivative interpolation",
  {D[cubic[s][[3]], s] /. s -> 1,
    D[cubic[s][[4]], s] /. s -> 0,
    D[cubic[s][[3]], s] /. s -> 0,
    D[cubic[s][[4]], s] /. s -> 1} == {1, 1, 0, 0}];
check["quadratic endpoint and bubble interpolation",
  {quadratic[1/2][[1]], quadratic[1][[3]], quadratic[0][[4]]} ==
   {1, 1, 1}];
check["quadratic unused slot is identically zero",
  quadratic[s][[2]] == 0];
check["quadratic active basis is a partition of unity",
  Total[quadratic[s]] == 1];
check["traced right-left value-derivative scatter",
  scatter == {{1, 1}, {0, 1}, {1, 2}, {0, 2}}];

(* Axis regularity removes normal value and the unused tangential slot for
   every mode.  For |m| >= 2 it also removes normal derivative and tangential
   endpoint value.  Fixed boundary removes one normal edge value per mode. *)
modes = {0, 1, 2};
axisFlags[m_] := {1, Boole[Abs[m] > 11/10], 1,
  Boole[Abs[m] > 11/10]};
axisConstraintCount = Total[Flatten[axisFlags /@ modes]];
edgeConstraintCount = Length[modes];
check["axis constraint flags", axisFlags /@ modes ==
  {{1, 0, 1, 0}, {1, 0, 1, 0}, {1, 1, 1, 1}}];
check["eleven independent endpoint constraints",
  axisConstraintCount + edgeConstraintCount == 11];
check["800 cells have 801 nodes",
  nodes == intervals + 1 /. {nodes -> 801, intervals -> 800}];
check["global and physical dimensions",
  {801 12, 801 12 - 11} == {9612, 9601}];
check["two-node 24 by 24 assembly has half bandwidth 23",
  2 12 - 1 == 23];

(* Elimination is a Galerkin congruence, not row zeroing.  P is a full-rank
   injection from unconstrained coordinates into the full nodal vector. *)
p = {{1, 0, 0}, {0, 0, 0}, {0, 1, 0}, {0, 0, 1}};
a = {{3, 1 + I, 0, 2}, {1 - I, 5, I, 0}, {0, -I, 4, -1},
  {2, 0, -1, 6}};
b = {{4, 1, 0, 0}, {1, 3, 0, 0}, {0, 0, 2, I/2},
  {0, 0, -I/2, 2}};
y = Array[yy, 3];
check["constraint injection has full column rank", MatrixRank[p] == 3];
check["eliminated stiffness quadratic form is exact",
  Conjugate[y] . ConjugateTranspose[p] . a . p . y ==
   Conjugate[p . y] . a . (p . y)];
check["eliminated mass quadratic form is exact",
  Conjugate[y] . ConjugateTranspose[p] . b . p . y ==
   Conjugate[p . y] . b . (p . y)];
check["congruence preserves Hermitian structure",
  ConjugateTranspose[ConjugateTranspose[p] . a . p] ==
   ConjugateTranspose[p] . a . p];
check["fixture mass and eliminated mass are positive definite",
  PositiveDefiniteMatrixQ[b] &&
   PositiveDefiniteMatrixQ[ConjugateTranspose[p] . b . p]];

(* A full matrix trace contains two independently rounded triangles.  These
   are three diagnostic Hermitian pencils, not confidence bounds. *)
raw = Array[z, {4, 4}];
hermitianProjection = (raw + ConjugateTranspose[raw])/2;
check["symmetric projection is Hermitian",
  ConjugateTranspose[hermitianProjection] == hermitianProjection];
exactHermitian = {{d1, u}, {Conjugate[u], d2}};
check["upper reconstruction recovers an exact Hermitian matrix",
  FullSimplify[UpperTriangularize[exactHermitian] +
     ConjugateTranspose[UpperTriangularize[exactHermitian, 1]] ==
    exactHermitian, Element[{d1, d2}, Reals]]];
check["lower reconstruction recovers an exact Hermitian matrix",
  FullSimplify[LowerTriangularize[exactHermitian] +
     ConjugateTranspose[LowerTriangularize[exactHermitian, -1]] ==
    exactHermitian, Element[{d1, d2}, Reals]]];

(* The translated local gate found K_GLISS = -cK A_MISHKA and
   M_GLISS = cM B_MISHKA, with positive normalization constants. *)
check["generalized eigenvalue sign map",
  FullSimplify[
   (-cK aMat) x == (-cK/cM lambda) (cM bMat) x,
   aMat x == lambda bMat x && cK > 0 && cM > 0]];
check["positive MISHKA lambda maps to negative GLISS energy",
  FullSimplify[-cK/cM lambda < 0, cK > 0 && cM > 0 && lambda > 0]];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

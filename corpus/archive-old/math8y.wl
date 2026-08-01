$Version

A = {{1, 2, 3, 4}, {2, 3, 0, -5}, {2, -1, 1, 1}, {-2, 2, 0, -5}}

MatrixForm[A]

M = Table[m[i, j], {i, 2}, {j, 3}]

MatrixForm[M]

f[i_, j_] = i/j; MF = Table[f[i, j], {i, 3}, {j, 3}]

TableForm[MF]

Clear[a, aa], Null, aa = Array[a, {3, 4}]

MatrixForm[%]

a[i_, j_] := ToExpression[StringJoin["a", {ToString[i], ToString[j]}]]

MatrixForm[aa]

Clear[a, aa], Null, aa = Array[a, {3, 4}]; 

a[i_, j_] := Subscript[a, i, j]

MatrixForm[aa]

Di = DiagonalMatrix[{2, 1, 0, -1, -2}]; MatrixForm[Di]

MatrixForm[IdentityMatrix[3]]

MatrixForm[0*IdentityMatrix[3]]

MatrixForm[Table[0, {2}, {4}]]

Array[0, {2, 4}]

MatrixForm[Table[If[i > j, 0, 1], {i, 3}, {j, 3}]]

MatrixForm[Table[If[i == j, 0, 1], {i, 3}, {j, 3}]]

MatrixForm[Table[If[i <= j, 0, 1], {i, 3}, {j, 3}]]

A = {{1, 2, 3, 4}, {2, 3, 0, -5}, {2, -1, 1, 1}, {-2, 2, 0, -5}}; MatrixForm[A]

A[[3,2]]

A[[2]]

B = Transpose[A]; MatrixForm[B]

B[[2]]

MatrixForm[A[[{2, 4},{1, 3}]]]

MatrixForm[A[[Range[2, 4],Range[1, 3]]]]

v = {a, b, c}; VectorQ[v]

VectorQ[p + q]

Di = DiagonalMatrix[{2, 1, 0, -1, -2}]; 

Dimensions[Di]

Dimensions[v]

MatrixQ[{Di, v}]

MatrixQ[Di]

Log[{a, b, c}]

MatrixForm[Exp[Di]]

D[{1, x, x^2, x^3}, x]

{a, b} + {c, d}

{a, b, c} + {d, s}

1 + {a, b}

{a, b} + p

% /. p -> {c, d}

Exp[Di] + c; MatrixForm[%]

k*{a, b}

{a, b}/k

v = {a, b, c}

s*v

v . {ap, bp, cp}

v . v

{a, b, c}*{d, e, f}

{{a, b}, {c, d}} . {x, y}

m1 = {{a, b}, {c, d}}; m2 = {{1, 2}, {3, 4}}; 

MatrixForm[m1]

MatrixForm[m2]

m = m1 . m2

MatrixForm[m]

v = {x, y}

MatrixForm[m1 . v]

MatrixForm[v . m1]

ExpandAll[MatrixForm[v . m1 . v]]

Outer[Times, {a, b, c}, {x, y, z}]

MatrixForm[%]

r = {x, y, z}; 

MatrixForm[IdentityMatrix[3]*r . r - Outer[Times, r, r]]

f[i_, j_] = i/j; , Null, Outer[f, {1, 2, 3}, {2, 4, 8, 10}]

Outer[List, {1, 2, 3}, {2, 4, 8, 10}]

Outer[Times, {a, b}, {c, d}, {e, f}]

MatrixForm[%]

Clear[x, y, z]; r = {x, y, z}; 

m1 = {{a, b}, {c, d}}; m2 = {{1, 2}, {3, 4}}; 

m12 = MatrixForm[Outer[Times, m1, m2]]

m21 = MatrixForm[Outer[Times, m2, m1]]

Clear[m1, m2], Null, m1 = {{a, b}, {c, d}}; , Null, m2 = {{1, 2, 3}, {4, 5, 6}}; , Null, MatrixForm[m1], Null, MatrixForm[m2]

MatrixForm[KroneckerProduct[m1, m2]]

MatrixForm[A]

MatrixForm[Transpose[A]]

Det[A]

B = Inverse[A]; MatrixForm[B]

MatrixForm[A . B]

G = A; G[[1]] = G[[2]]; MatrixForm[G]

Inverse[G]

Det[G]

MatrixRank[G]

ma = Array[a, {3, 4}]; MatrixForm[ma]

mi3 = Minors[ma, 3]

Dimensions[mi3]

mi2 = Minors[ma, 2]

Dimensions[mi2]

mi1 = MatrixForm[Minors[ma, 1]]

Minors[G, 3]

Tr[A]

Tr[G]

A = {{1, 2, 3, 4}, {2, 3, 0, -5}, {2, -1, 1, 1}, {-2, 2, 0, -5}}; 

f = Det[A - x*IdentityMatrix[4]]

cp = CharacteristicPolynomial[A, λ]

Solve[f == 0., x]

Clear[a, b, c, d], Null, m = {{a, b}, {c, d}}; MatrixForm[m]

MatrixForm[m^2]

MatrixForm[m . m]

MatrixForm[MatrixPower[m, 2]]

dd = DiagonalMatrix[{1, -1}]; MatrixForm[dd]

MatrixForm[MatrixExp[dd]]

dd = I*x*DiagonalMatrix[{1, -1}]; MatrixForm[dd]

MatrixExp[dd]

MatrixForm[ComplexExpand[%]]

MatrixExp[m]

FullSimplify[%]

m = {{1, 5}, {2, 1}}; MatrixForm[m]

m . {x, y} == {a, b}

Solve[%, {x, y}]

{x + y, 2*x + 2*y} == {0, 0}; Solve[%, {x, y}]

{x + y, 2*x + 2*y} == {a, b}; Solve[%, {x, y}]

Inverse[m] . {a, b}

LinearSolve[m, {a, b}]

LinearSolve[{{1, 1}, {2, 2}}, {0, 0}]

h1 = Append[m[[1]], a]; h2 = Append[m[[2]], b]; ma = {h1, h2}; MatrixForm[ma]

MatrixForm[RowReduce[ma]]

mm = {{1, 1, 0}, {2, 2, 0}}; MatrixForm[mm]

MatrixForm[RowReduce[mm]]

mm = {{1, 1, a}, {2, 2, b}}; MatrixForm[mm]

MatrixForm[RowReduce[mm]]

g = {{-3, 2, 11, 1}, {1, 3, 7, -5}, {-2, -3, 5, 2}}; MatrixForm[g]

rr = RowReduce[g]; MatrixForm[rr]

v = Transpose[rr][[4]]

cm = g[[Range[3],Range[3]]]; MatrixForm[cm]

cm . v == Transpose[g][[4]]

me = {{1, 1, 1, -1}, {1, 2, 3, -4}, {1, 3, 6, -10}, {1, 4, 10, -a}}

Thread[me[[Range[4],Range[3]]] . {x, y, z} == me[[4]]]

Solve[%, {x, y, z}]

Thread[me[[Range[3],Range[3]]] . {x, y, z} == me[[4,Range[3]]]]

Flatten[Solve[%, {x, y, z}]]

met = RowReduce[me]; MatrixForm[met]

mer = RowReduce[me[[Range[3],Range[3]]]]; MatrixForm[mer]

sa = Flatten[Solve[Det[me] == 0, a]]

RowReduce[me /. sa]

Solve[(me /. sa) . {x, y, z, 1} == 0, {x, y, z}]

A = {{1, 2, 3, 4}, {2, 3, 0, -5}, {2, -1, 1, 1}, {-2, 2, 0, -5}}; MatrixForm[A]

Det[A]

NullSpace[A]

G = A; G[[1]] = G[[2]]; MatrixForm[G]

v = NullSpace[G]

G . Transpose[v]

v . G

v . Transpose[G]

A = {{1, 1, 2}, {1, 2, 1}, {2, 1, 1}}; MatrixForm[A]

Eigenvalues[A]

AM = A - x*IdentityMatrix[3]; MatrixForm[AM]

ceq = Det[AM]

ds = Solve[ceq == 0, x]

Eigenvectors[A]

Eigensystem[A]

AM1 = AM /. ds[[1]]

NullSpace[AM1]

AM /. ds

NullSpace[%[[2]]]

m = {{a, b}, {c, d}}; MatrixForm[m]

Eigenvalues[m]

Eigensystem[m]

mm = {{1, 0, 0}, {2, 1, 0}, {0, 0, -1}}; MatrixForm[mm]

Eigensystem[mm]

jd = JordanDecomposition[mm]

MatrixForm[jd[[2]]]

J = Inverse[jd[[1]]] . mm . jd[[1]]; MatrixForm[J]

SingularValueList[m]

A = {{1, 1, 2}, {1, 2, 1}, {2, 1, 1}}; MatrixForm[A]

SingularValueList[A]

Eigenvalues[A]

{u, w, v} = SingularValueDecomposition[A]

MatrixForm[u]

MatrixForm[w]

MatrixForm[v]

MatrixForm[u . w . Transpose[v]]

MatrixForm[Transpose[u] . w . v]

A = {{1, 1, 2}, {1, I, 1}, {2, 1, 1}}; MatrixForm[A]

{u, w, v} = SingularValueDecomposition[A]

w

N[w]

Eigenvalues[A]

N[%]

Simplify[A == u . w . Conjugate[Transpose[v]]]

ma = {{1, -2}, {2, -1}, {1, 1}}; MatrixForm[ma]

{u, w, v} = Chop[SingularValueDecomposition[ma]]

MatrixForm[w]

u . w . Transpose[v] == ma

ma = {{1, 0, 0}, {2, 1, 0}, {0, 0, -1}}; MatrixForm[ma]

{u, w, v} = SingularValueDecomposition[ma]; 

MatrixForm[u]

MatrixForm[w]

MatrixForm[v]

FullSimplify[MatrixForm[u . w . Transpose[v]]]

wa = {Sqrt[2] + 1, 1, Sqrt[2] - 1}; , Null, Chop[N[wa] - w]

Eigenvalues[ma]

v1 = Sqrt[1/2 - 1/(2*Sqrt[2])]; v2 = Sqrt[1/2 + 1/(2*Sqrt[2])]; 

ua = {{v1, 0, -v2}, {v2, 0, v1}, {0, -1, 0}}; MatrixForm[ua]

N[ua], Null, N[u]

va = {{v2, 0, -v1}, {v1, 0, v2}, {0, 1, 0}}; MatrixForm[va]

N[va], Null, N[v]

ma = {{1, 0, 0, 3}, {2, 1, 0, 1}, {0, 0, -1, 1}}; MatrixForm[ma]

{u, w, v} = SingularValueDecomposition[ma]; 

N[MatrixForm[w]]

N[MatrixForm[u]], Null, N[MatrixForm[v]]

MatrixForm[Chop[N[u . w . Transpose[v] - ma]]]

MatrixForm[Chop[N[Transpose[u] . u]]]

MatrixForm[Chop[N[u . Transpose[u]]]]

MatrixForm[Chop[N[v . Transpose[v]]]]

MatrixForm[Chop[N[Transpose[v] . v]]]

ma = {{1, -2}, {2, -1}, {1, 1}}; , Null, mb = {-1, 1, 5}; , Null, lx = {x, y}; , Null, eq = Thread[ma . lx == mb]

MatrixRank[ma]

pa = Transpose[ma] . ma

ba = Inverse[pa] . Transpose[ma]

ba . mb

pia = PseudoInverse[ma], Null, MatrixForm[pia . ma], Null, pso = pia . mb

ma = Transpose[{{1, 2, 3}, {I, 1., -I}}]; MatrixForm[ma]

pa = PseudoInverse[ma]; MatrixForm[pa]

MatrixForm[Chop[pa . ma]]

Inverse[Conjugate[Transpose[ma]] . ma] . Transpose[ma]

m = {{a, b}, {c, d}}; MatrixForm[m]

MatrixForm[Inverse[m]]

MatrixForm[FullSimplify[PseudoInverse[m]]]

MatrixForm[m = {{1, 2}, {1, 2}}]

Inverse[m]

MatrixForm[p = PseudoInverse[m]]

m . p . m == m, Null, p . m . p == p, Null, p . m == Transpose[p . m], Null, m . p == Transpose[m . p]

mm = {{1, 2, 3}, {3, 2, 1}}; 

MatrixForm[p = PseudoInverse[mm]]

posize = PointSize[0.02]; 

c1 = {1, 1}; , Null, c2 = {3, 2}; , Null, c3 = {2, 3}; , Null, cp = Point /@ {c1, c2, c3}

g1 = x - 2*y == -1, Null, g2 = 2*x - y == 1, Null, g3 = x + y == 5

s1 = Flatten[y /. Solve[g1, y]], Null, s2 = Flatten[y /. Solve[g2, y]], Null, s3 = Flatten[y /. Solve[g3, y]]

gr1 = Plot[Flatten[{s1, s2, s3}], {x, 0, 3.2}, PlotRange -> {0, 3.2}, Ticks -> {Range[3], Range[3]}, Epilog -> Prepend[cp, posize]]

ma = {{1, -2}, {2, -1}, {1, 1}}; , Null, mb = {-1, 1, 5}; , Null, lx = {x, y}; , Null, eq = Thread[ma . lx == mb]

pia = PseudoInverse[ma], Null, MatrixForm[pia . ma], Null, pso = pia . mb

Show[gr1, Graphics[{Hue[0], posize, Point[pso]}]]

c1 = {1, 1}; , Null, c2 = {3, 2}; , Null, c3 = {2, 3}; , Null, cp = Point /@ {c2, c3}; 

g1 = x - 2*y == -1; , Null, g2 = x - 2*y == -3.95; , Null, g3 = x + y == 5; 

s1 = Flatten[y /. Solve[g1, y]], Null, s2 = Flatten[y /. Solve[g2, y]], Null, s3 = Flatten[y /. Solve[g3, y]]

gr2 = Plot[Flatten[{s1, s2, s3}], {x, 0, 3.2}, PlotRange -> {0, 3.2}, Ticks -> {Range[3], Range[3]}, Epilog -> Prepend[cp, posize]]

ma = {{1, -2}, {1, -2}, {1, 1}}; MatrixForm[ma], Null, mb = {-1, -3.95, 5}; , Null, eq = Thread[ma . lx == mb]

pia = PseudoInverse[ma]; MatrixForm[pia], Null, MatrixForm[pia . ma], Null, pso = pia . mb

Show[gr2, Graphics[{Hue[0], posize, Point[pso]}]]

g1 = x - 2*y == -1; , Null, g2 = x - 2*y == -3.95; , Null, g3 = x - 2*y == -2.1; 

s1 = Flatten[y /. Solve[g1, y]], Null, s2 = Flatten[y /. Solve[g2, y]], Null, s3 = Flatten[y /. Solve[g3, y]]

gr3 = Plot[Flatten[{s1, s2, s3}], {x, -1, 3.2}, PlotRange -> {0, 3.2}, Ticks -> {Range[-1, 3], Range[3]}, Epilog -> Prepend[cp, posize]]

(ma = {{1, -2}, {1, -2}, {1, -2}}; )*(mb = {-1, -3.95, -2}; )*(eq = Thread[ma . lx == mb])

pia = PseudoInverse[ma], Null, MatrixForm[pia . ma], Null, pso = pia . mb

Show[gr3, Graphics[{Hue[0], posize, Point[pso]}]]

{{0, 1, -3, -1}, {1, 0, 1, 1}, {3, 1, 0, 2}, {1, 1, -2, 0}}

{{1, 3, 2, 4}, {5, 2, 0, 1}, {3, -4, -4, -7}, {-7, 5, 6, 10}}

{{10, -14, -10}, {-14, 7, -4}, {-10, -4, 19}}

{{5, 2, 2}, {2, 2, 1}, {2, 1, 1}}

{{-2, 0, -4}, {0, 2, 4}, {-4, 4, 0}}

{{1, 0, Sqrt[3]}, {0, 1, 1}, {Sqrt[3], 1, 1}}

{{1, -2, 1}, {-1, 2, -1}, {2, 1, 1}}

{{8, 2, 3, 4}, {2, 5, 4, 5}, {3, 4, 5, 6}, {5, 6, 7, 9}}

{{-(1/2), Sqrt[3]/2}, {Sqrt[3]/2, 1/2}}

{{-(1/2), -(Sqrt[3]/2)}, {Sqrt[3]/2, -(1/2)}}

{{1/Sqrt[2], -(1/Sqrt[2])}, {1/Sqrt[2], 1/Sqrt[2]}}

{{0, 1, 0}, {0, 0, 1}, {-1, -1, -1}}

{{0, 1, 0}, {0, 0, 1}, {1, 0, 0}}

(* UNCONVERTED CELL *)

(* UNCONVERTED CELL *)

(* UNCONVERTED CELL *)

(* UNCONVERTED CELL *)

{{1, 2}, {-2, -3}}

Clear; , Null, m = {{1, 1, 1}, {1, 2, 3}, {1, 3, 6}, {1, 4, 6}}; , Null, b = {1, 4, 10, 19}; , Null, u = {u1, u2, u3}; , Null, Solve[m . u == b, u], Null, MatrixForm[RowReduce[Transpose[Append[Transpose[m], b]]]], Null

m = {{1, 1, 1}, {1, 2, 3}, {1, 3, 6}, {1, 4, 10}}; , Null, b = {1, 4, 10, 19}; , Null, Solve[m . u == b, u], Null, LinearSolve[m, b], Null, MatrixForm[RowReduce[Transpose[Append[Transpose[m], b]]]]

{{0, 1, -3, -1}, {1, 0, 1, 1}, {3, 1, 0, 2}, {1, 1, -2, 0}}

{{1, 3, 2, 4}, {5, 2, 0, 1}, {3, -4, -4, -7}, {-7, 5, 6, 10}}

m = {{0, 1, -3, -1}, {1, 0, 1, 1}, {3, 1, 0, 2}, {1, 1, -2, 0}}; , Null, b = {0, 0, 0, 0}; , Null, LinearSolve[m, b], Null, MatrixForm[RowReduce[Transpose[Append[Transpose[m], b]]]], Null, NullSpace[m]

m = {{1, 3, 2, 4}, {5, 2, 0, 1}, {3, -4, -4, -7}, {-7, 5, 6, 10}}; , Null, b = {0, 0, 0, 0}; , Null, LinearSolve[m, b], Null, MatrixForm[RowReduce[Transpose[Append[Transpose[m], b]]]], Null, NullSpace[m]

me = {{1, 1, 1, 1}, {1, 2, 3, 4}, {1, 3, 6, 10}, {1, 4, 10, a}}; , Null, Solve[Det[me] == 0], Null

{{10, -14, -10}, {-14, 7, -4}, {-10, -4, 19}}

{{5, 2, 2}, {2, 2, 1}, {2, 1, 1}}

{{-2, 0, -4}, {0, 2, 4}, {-4, 4, 0}}

{{1, 0, Sqrt[3]}, {0, 1, 1}, {Sqrt[3], 1, 1}}

{{1, -2, 1}, {-1, 2, -1}, {2, 1, 1}}

{{8, 2, 3, 4}, {2, 5, 4, 5}, {3, 4, 5, 6}, {5, 6, 7, 9}}

M = {{{10, -14, -10}, {-14, 7, -4}, {-10, -4, 19}}, {{5, 2, 2}, {2, 2, 1}, {2, 1, 1}}, {{-2, 0, -4}, {0, 2, 4}, {-4, 4, 0}}, {{1, 0, Sqrt[3]}, {0, 1, 1}, {Sqrt[3], 1, 1}}, {{1, -2, 1}, {-1, 2, -1}, {2, 1, 1}}, N[{{8, 2, 3, 4}, {2, 5, 4, 5}, {3, 4, 5, 6}, {5, 6, 7, 9}}]}; 

Print["Traces: ", Tr /@ M], Null, Print["Determinants: ", Det /@ M], Null, Print["Inverses (for nonzero Det): ", MatrixForm /@ Inverse /@ Select[M, Det[#1] != 0 & ]]; 

charpoly = (CharacteristicPolynomial[#1, z] & ) /@ M; , Null, Print["Characteristic Polynomials:", charpoly]; , Null, aneig = (Solve[#1 == 0] & ) /@ charpoly; , Null, eig = Eigenvalues /@ M; , Null, eigvec = Eigenvectors /@ M; , Null, Print["Eigenvalue sets:", (MatrixForm[DiagonalMatrix[#1]] & ) /@ eig]; , Null, Print["Eigenvector sets:", MatrixForm /@ eigvec]; 

{{-(1/2), Sqrt[3]/2}, {Sqrt[3]/2, 1/2}}

{{-(1/2), -(Sqrt[3]/2)}, {Sqrt[3]/2, -(1/2)}}

{{1/Sqrt[2], -(1/Sqrt[2])}, {1/Sqrt[2], 1/Sqrt[2]}}

{{0, 1, 0}, {0, 0, 1}, {-1, -1, -1}}

{{0, 1, 0}, {0, 0, 1}, {1, 0, 0}}

M = {{{-(1/2), Sqrt[3]/2}, {Sqrt[3]/2, 1/2}}, {{-(1/2), -(Sqrt[3]/2)}, {Sqrt[3]/2, -(1/2)}}, {{1/Sqrt[2], -(1/Sqrt[2])}, {1/Sqrt[2], 1/Sqrt[2]}}, {{0, 1, 0}, {0, 0, 1}, {-1, -1, -1}}, {{0, 1, 0}, {0, 0, 1}, {1, 0, 0}}}; , Null, me = (Eigenvalues[#1] & ) /@ M; , Null, Print["Eigenvalues: ", MatrixForm /@ me]; , Null, Print["Direkte Loesung: "]; , Null, (Reduce[MatrixPower[#1, n] == IdentityMatrix[Length[#1]] && Element[n, Integers], n] & ) /@ M, Null, Print["Loesung ueber Eigenwerte: "]; , Null, (Reduce[#1^n == Table[1, {Length[#1]}] && Element[n, Integers], n] & ) /@ me

RootOfUnityProg[m_, m0_, i_, n_] := If[m == IdentityMatrix[Length[m]], i, If[i < n, RootOfUnityProg[m0 . m, m0, i + 1, n], 0]]; , Null, RootOfUnity[m_, n_] := RootOfUnityProg[m, m, 1, n]; , Null, (RootOfUnity[#1, 255] & ) /@ M

ZeroMatrix[n_] := ConstantArray[0, {n, n}]; , Null, RootOfZeroProg[m_, m0_, i_, n_] := If[m == ZeroMatrix[Length[m]], i, If[i < n, RootOfZeroProg[m0 . m, m0, i + 1, n], 0]]; , Null, RootOfZero[m_, n_] := RootOfZeroProg[m, m, 1, n]; 

RootOfZero[{{0, 1}, {0, 0}}, 255]

ProveCharEq[a_] := Complement[z /. Solve[Det[a - z*IdentityMatrix[Length[a]]] == 0, z], Eigenvalues[a]]; , Null, ProveCharEq[{{0, 1, 0}, {0, 0, 1}, {-1, -1, -1}}]

TestCharEq[a_] := (Det[a - #1*IdentityMatrix[Length[a]]] & ) /@ Eigenvalues[a]; 

TestCharEq[{{0, 1, 0}, {0, 0, 1}, {-1, -1, -1}}]

(* UNCONVERTED CELL *)

(* UNCONVERTED CELL *)

m = {{2, 0, -1}, {3, 4, 2}, {0, -8, -7}}; , Null, L = NullSpace[Transpose[m]], Null, R = Transpose[NullSpace[m]], Null, L . m, Null, m . R

(m = {{1, 1, 1, 1}, {1, 2, 3, 4}, {3, 5, 7, 8}, {6, 5, 4, 2}}; )*(L = NullSpace[Transpose[m]])*(R = Transpose[NullSpace[m]])*L . m*m . R

m = {{1, 0, 0}, {0, 5, 0}, {-8, 8, 3}}; , Null, lam = Eigenvalues[m], Null, v = Normalize /@ Eigenvectors[m]

p1 = ContourPlot3D[x^2 + 5*y^2 + 3*z^2 + 8*y*z - 8*x*z == 1, {x, -5, 5}, {y, -5, 5}, {z, -5, 5}]; , Null, p2 = Graphics3D[Table[Arrow[{{0, 0, 0}, lam[[i]]*Normalize[v[[i]]]}], {i, 1, 3}]]; , Null, Show[p1, p2]

m = {{5, 0, 0}, {12, 13, 0}, {-4, 12, 14}}; , Null, lam = Eigenvalues[m], Null, v = Normalize /@ Eigenvectors[m]

p1 = ContourPlot3D[5*x^2 + 13*y^2 + 14*z^2 + 12*y*z - 4*x*z + 12*x*y == 1, {x, -2, 2}, {y, -2, 2}, {z, -2, 2}]; , Null, p2 = Graphics3D[Table[Arrow[{{0, 0, 0}, lam[[i]]*Normalize[v[[i]]]}], {i, 1, 3}]]; , Null, Show[p1, p2]

Clear[elist], Null, ex = {{0, 1}, {1, 0}}; , Null, ey = {{0, -I}, {I, 0}}; , Null, ez = {{1, 0}, {0, -1}}; , Null, e = {{1, 0}, {0, 1}}; , Null, elist = {ex, ey, ez, e}; 

(MatrixForm[KroneckerProduct[#1, ex]] & ) /@ elist, Null, (MatrixForm[KroneckerProduct[#1, ey]] & ) /@ elist, Null, (MatrixForm[KroneckerProduct[#1, ez]] & ) /@ elist, Null, (MatrixForm[KroneckerProduct[#1, e]] & ) /@ elist

DiagTest1[a_] := ConjugateTranspose[a] . a == a . ConjugateTranspose[a]; , Null, DiagTest2[a_] := Length[Union[Eigenvalues[a]]] == Length[a]; , Null, DiagTest[a_] := DiagTest1[a] || DiagTest2[a]; 

DiagTest1[{{1, 1}, {0, 2}}], Null, DiagTest2[{{1, 1}, {0, 2}}], Null, DiagTest[{{1, 1}, {0, 2}}], Null, DiagTest1[{{1, -I}, {I, 2}}], Null, DiagTest2[{{1, -I}, {I, 2}}], Null, DiagTest[{{1, -I}, {I, 2}}]

m = {{1, 2}, {-2, -3}}; , Null, DiagTest[m]

Eigenvalues[m]

Eigenvectors[m]

Null

Null

Plus @@@ {(DiagonalMatrix[#1[[1]], #1[[2]]] & ) /@ Join[{{Abs[Range[-10, 10]], 0}}, ({Table[1, {20}], #1} & ) /@ {1, -1}]}

Eigenvalues[N[%]]

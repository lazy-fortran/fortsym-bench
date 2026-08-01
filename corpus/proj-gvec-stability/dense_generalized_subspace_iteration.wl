ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* The implementation diagonally equilibrates the shifted pencil.  Solving
   the scaled system and mapping back must be exactly the physical block
   inverse action. *)
mass = DiagonalMatrix[{2, 3, 5}];
stiffness = DiagonalMatrix[{4, 9, 25}];
shift = 1/2;
scaling = DiagonalMatrix[1/Sqrt[Diagonal[mass]]];
vector = {2, -3, 4};
scaledSolution = LinearSolve[
   scaling . (stiffness - shift mass) . scaling,
   scaling . mass . vector];
physicalSolution = scaling . scaledSolution;
check["diagonal scaling preserves the physical inverse action",
 (stiffness - shift mass) . physicalSolution == mass . vector];

(* Exact generalized eigenvectors are invariant under shifted inverse
   iteration.  The multipliers are 1/(lambda-shift), so no copied kernel is
   involved in this property. *)
eigenvalues = {2, 3, 5};
eigenvectors = DiagonalMatrix[1/Sqrt[Diagonal[mass]]];
inverseAction = Inverse[stiffness - shift mass] . mass;
check["shifted inverse preserves the exact generalized eigenspace",
 FullSimplify[inverseAction . eigenvectors ==
   eigenvectors . DiagonalMatrix[1/(eigenvalues - shift)]]];
check["fixture eigenvectors are physical-mass orthonormal",
 Transpose[eigenvectors] . mass . eigenvectors == IdentityMatrix[3]];

(* Rayleigh--Ritz on an invariant block recovers the same generalized levels. *)
block = eigenvectors[[All, 1 ;; 2]];
reducedStiffness = Transpose[block] . stiffness . block;
reducedMass = Transpose[block] . mass . block;
check["invariant-block Rayleigh Ritz recovers its levels",
 Sort[Eigenvalues[{reducedStiffness, reducedMass}]] == {2, 3}];

(* The reported overlap uses G_initial^(-1/2) X^T M Q.  Its singular values
   are cosines of physical-mass principal angles. *)
final = {{1, 0}, {0, 1}, {0, 0}};
initial = {{1, 0}, {0, 1/2}, {0, Sqrt[3]/2}};
gram = Transpose[initial] . initial;
cross = Transpose[initial] . final;
normalizedCross = MatrixPower[gram, -1/2] . cross;
check["overlap singular values are principal-angle cosines",
 Sort[SingularValueList[normalizedCross], Greater] == {1, 1/2}];

(* A close Ritz value without a small full residual is not an eigenpair. *)
trial = {1, 1/100, 0};
quotient = (trial . stiffness . trial)/(trial . mass . trial);
residual = stiffness . trial - quotient mass . trial;
check["Rayleigh proximity does not imply zero operator residual",
 quotient > 2 && quotient < 201/100 && residual != {0, 0, 0}];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

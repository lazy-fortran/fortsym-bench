(* Symbolic derivatives and numerical Fisher-rank check for the sheet model. *)
root = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
results = FileNameJoin[{root, "03_prestudies", "results"}];
If[!DirectoryQ[results], CreateDirectory[results, CreateIntermediateDirectories -> True]];

Clear[z, t, z0, u, ell, alpha];
width = Exp[ell + alpha t];
field = Tanh[(z - z0 - u t)/width];
parameters = {z0, u, ell, alpha};
gradient = FullSimplify[D[field, #] & /@ parameters];

truth = {z0 -> 0.12, u -> 0.42, ell -> 0.0, alpha -> -0.24};
times = Subdivide[-0.85, 0.85, 55];
fisher[separation_] := Module[{positions, rows, matrix, eigenvalues, condition},
  positions = separation {-1.5, -0.5, 0.5, 1.5};
  rows = Flatten[Table[N[gradient /. truth /. {z -> zz, t -> tt}],
                       {zz, positions}, {tt, times}], 1];
  matrix = Transpose[rows].rows;
  eigenvalues = N[Eigenvalues[matrix]];
  condition = If[Min[Abs[eigenvalues]] < 10^-12, -1.0,
                 Max[Abs[eigenvalues]]/Min[Abs[eigenvalues]]];
  <|"separation_over_L0" -> separation,
    "rank" -> MatrixRank[matrix, Tolerance -> 10^-10],
    "condition_number" -> condition,
    "eigenvalues" -> eigenvalues|>
  ];

checks = fisher /@ {0.0, 0.05, 0.25, 0.75, 1.5};
Export[FileNameJoin[{results, "symbolic_gradient.txt"}],
       ToString[InputForm[gradient]], "Text"];
Export[FileNameJoin[{results, "fisher_rank_checks.json"}], checks, "RawJSON"];
Print[ExportString[checks, "RawJSON"]];

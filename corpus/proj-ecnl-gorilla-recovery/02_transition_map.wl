Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[z, zp, dz, f, p, tau, a];

(* Discrete counterpart of the transition kernel. *)
matrix = {{1 - a, a}, {a/2, 1 - a/2}};
check["transition rows normalize", Total /@ matrix == {1, 1}, 0 <= a <= 1];
check["Markov step conserves total weight",
  Total[{n1, n2}.matrix] == n1 + n2, 0 <= a <= 1];

(* Kramers-Moyal expansion of f(z-dz) through second order. *)
taylor = Normal[Series[f[z - dz], {dz, 0, 2}]];
check["second-order Taylor kernel",
  taylor == f[z] - dz f'[z] + dz^2 f''[z]/2];

(* Random phase kick. *)
meanKick = Integrate[a Sin[psi], {psi, 0, 2 Pi}]/(2 Pi);
meanSquare = Integrate[(a Sin[psi])^2, {psi, 0, 2 Pi}]/(2 Pi);
checkZero["random-phase mean kick", meanKick];
check["random-phase kick variance", meanSquare == a^2/2];
check["quasilinear diffusion coefficient", meanSquare/(2 tau) == a^2/(4 tau),
  tau > 0];

reportAndExit[];

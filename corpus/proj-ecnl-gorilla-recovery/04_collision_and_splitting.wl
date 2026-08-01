Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[v, xi, theta, nuv, nux, f, a, b, dt];

fM = Exp[-v^2/(2 theta)];
radialFlux = v fM + theta D[fM, v];
pitchTerm = D[(1 - xi^2) D[fM, xi], xi];
checkZero["Maxwellian radial collision flux", radialFlux, theta > 0];
checkZero["isotropic Maxwellian pitch collision term", pitchTerm, theta > 0];

(* Pitch scattering conserves particles because its boundary flux vanishes. *)
pitchFlux = (1 - xi^2) g'[xi];
checkZero["pitch flux vanishes at xi=+1", pitchFlux /. xi -> 1];
checkZero["pitch flux vanishes at xi=-1", pitchFlux /. xi -> -1];

(* Non-commuting scalar placeholders reproduce the first-order Lie split.
   The missing cross ordering is O(dt^2). *)
exactSeries = Normal[Series[Exp[dt (a + b)], {dt, 0, 1}]];
splitSeries = Normal[Series[Exp[dt a] Exp[dt b], {dt, 0, 1}]];
check["Lie splitting agrees through first order", exactSeries == splitSeries];

reportAndExit[];

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[psi, h, p, i, k, s, omega, t, a, b, j, jr];

(* A perturbation depending only on psi=s phi+k z-omega t gives three
   linked Hamilton equations.  These checks prove the two invariants used
   to reduce the crossing problem to one action-angle pair. *)
pDot = -k h'[psi];
iDot = -s h'[psi];
hDot = -omega h'[psi];
checkZero["canonical momentum invariant", pDot - (k/s) iDot, s != 0];
checkZero["wave-frame energy invariant", hDot - (omega/s) iDot, s != 0];

(* Harmonic projection selects the requested cyclotron phase. *)
harmonic = hminus Exp[-I phi] + hzero + hplus Exp[I phi];
projection = Integrate[harmonic Exp[-I phi], {phi, 0, 2 Pi}]/(2 Pi);
check["cyclotron Fourier projection selects harmonic s", projection == hplus];

reduced = a (j - jr)^2/2 - b Cos[psi];
hamiltonEquations = {D[reduced, j], -D[reduced, psi]};
check["reduced Hamilton equations",
  hamiltonEquations == {a (j - jr), -b Sin[psi]}];

(* Separatrix energy is +b and the stable point has energy -b. *)
turningEquation = (a deltaJ^2/2 - b) == b;
width = deltaJ /. First[Solve[turningEquation, deltaJ]];
check["separatrix half width", width^2 == 4 b/a, a > 0 && b > 0];

(* Linearization about the stable fixed point gives psi''=-a b psi. *)
check["bounce-frequency scale", omegaB^2 == a b /. omegaB -> Sqrt[a b],
  a > 0 && b > 0];

reportAndExit[];

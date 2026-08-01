Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[theta, phi, m, n, amp, phase];

qfield = amp Exp[I (m theta - n phi)];
coefficient = Integrate[
  qfield Exp[-I (m theta - n phi)],
  {theta, 0, 2 Pi}, {phi, 0, 2 Pi}]/(2 Pi)^2;
check["Fourier projection recovers complex amplitude", coefficient == amp,
  Element[{m, n}, Integers]];

realField = amp Exp[I phase] Exp[I (theta - phi)] +
  amp Exp[-I phase] Exp[-I (theta - phi)];
check["real 1/1 reconstruction",
  ComplexExpand[realField, TargetFunctions -> {Re, Im}] ==
    2 amp Cos[phase + theta - phi],
  Element[{amp, phase, theta, phi}, Reals]];

(* A same-helicity current in a straight periodic cylinder is solenoidal
   when m j_theta/r + k j_z=0. *)
divAmplitude = I m jtheta/r + I kz jz;
checkZero["same-helicity current continuity",
  divAmplitude /. jtheta -> -kz r jz/m, m != 0];

reportAndExit[];

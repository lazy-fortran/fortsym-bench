Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[power, field, b, a, tau, chi, nu, qc];

(* Wave field is proportional to sqrt(power), the pendulum bounce frequency
   to sqrt(field), hence chi scales as the fourth root of beam power. *)
field = cE Sqrt[power];
b = cb field;
omegaB = Sqrt[a b];
chi = omegaB tau;
check["finite-crossing parameter scales as P^(1/4)",
  FullSimplify[chi /. power -> lambda^4 power] == lambda chi,
  {a > 0, cb > 0, cE > 0, power > 0, tau > 0, lambda > 0}];

qc = nu tau;
check["collision ordering is a crossing-time ratio", qc/chi == nu/omegaB,
  {nu > 0, tau > 0, omegaB > 0}];

(* Linear/quasilinear diffusion is second order in wave amplitude. *)
kick = eps g Sin[psi];
secondMoment = Integrate[kick^2, {psi, 0, 2 Pi}]/(2 Pi);
check["quasilinear response is quadratic in field amplitude",
  Exponent[secondMoment, eps] == 2];

reportAndExit[];

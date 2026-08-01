(* Enforced-periodicity ansatz: localizer smoothness, periodized-background
   construction from the FORCED_PERIODICITY prototype, and the periodized
   gyroaverage identity of the 2026-07-04 note. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* Localizer weight of localizer.f90 on the transition variable t. *)
w[t_] = Exp[-2 Pi/(1 - t) Exp[-Sqrt[2]/t]];

check["Per1: localizer approaches 1 and 0 at the transition ends",
  Limit[w[t], t -> 0, Direction -> "FromAbove"] === 1 &&
    Limit[w[t], t -> 1, Direction -> "FromBelow"] === 0];

check["Per2: localizer derivatives through order 4 vanish at both ends",
  And @@ Table[
    Limit[D[w[t], {t, k}], t -> 0, Direction -> "FromAbove"] === 0 &&
      Limit[D[w[t], {t, k}], t -> 1, Direction -> "FromBelow"] === 0,
    {k, 1, 4}]];

check["Per3: localizer is strictly decreasing inside the transition",
  Simplify[D[w[t], t] < 0, 0 < t < 1]];

(* make_periodic.f90 with sig = +1 localizer calls, exact arithmetic. *)
wLoc[x1_, x2_, x_] := Piecewise[{{1, (x - x1)/(x2 - x1) <= 0},
    {0, (x - x1)/(x2 - x1) >= 1}}, w[(x - x1)/(x2 - x1)]];

periodized[f_, xmid_, dr_, drtr_, x_] := Module[
  {l = 2 (dr + drtr), xleft = xmid - dr - drtr, xin, g},
  xin = xleft + Mod[x - xleft, l];
  g = f[xin] wLoc[xmid + dr, xmid + dr + 2 drtr, xin] +
    f[xin - l] (1 - wLoc[xmid + dr, xmid + dr + 2 drtr, xin]);
  g (1 - wLoc[xmid - dr - 2 drtr, xmid - dr, xin]) +
    f[xin + l] wLoc[xmid - dr - 2 drtr, xmid - dr, xin]];

(* Note and prototype test case: r_m = 1/2, dr = 1/4, drtr = 1/2, L = 3/2. *)
layerPoints = Range[1/4, 3/4, 1/20];
check["Per4: the resonant layer |x - x_m| <= dr is left unmodified",
  And @@ Table[
      periodized[#^2 &, 1/2, 1/4, 1/2, x] === x^2 &&
        periodized[Identity, 1/2, 1/4, 1/2, x] === x,
      {x, layerPoints}]];

samples = Range[-2, 3, 1/13];
check["Per5: the construction is exactly L-periodic",
  And @@ Table[
      periodized[#^2 &, 1/2, 1/4, 1/2, x + 3/2] ==
        periodized[#^2 &, 1/2, 1/4, 1/2, x],
      {x, samples}]];

(* One open period [xleft, xleft + L) without Mod: derivatives at the seam
   from the right of xleft must match those from the left of xleft + L. *)
blend[f_, xmid_, dr_, drtr_, x_] := Module[{l = 2 (dr + drtr), g},
  g = f[x] wLoc[xmid + dr, xmid + dr + 2 drtr, x] +
    f[x - l] (1 - wLoc[xmid + dr, xmid + dr + 2 drtr, x]);
  g (1 - wLoc[xmid - dr - 2 drtr, xmid - dr, x]) +
    f[x + l] wLoc[xmid - dr - 2 drtr, xmid - dr, x]];

seam = -1/4;
check["Per6: seam values and derivatives through order 4 are continuous",
  And @@ Table[
    Simplify[
      Limit[D[blend[#^2 &, 1/2, 1/4, 1/2, x], {x, k}],
        x -> seam, Direction -> "FromAbove"] ==
      Limit[D[blend[#^2 &, 1/2, 1/4, 1/2, x], {x, k}],
        x -> seam + 3/2, Direction -> "FromBelow"]],
    {k, 0, 4}]];

(* Differentiation does not commute with periodization inside the
   transition zone: the periodized gradient must be computed from the
   periodized profile, never periodized separately. *)
xtr = 9/8;
check["Per7: periodizing the derivative differs from differentiating",
  N[periodized[2 # &, 1/2, 1/4, 1/2, xtr] -
      (D[blend[#^2 &, 1/2, 1/4, 1/2, x], x] /. x -> xtr), 30] != 0];

(* Gyroaverage identity of the note, Eq. (fourcoef_f_expl_fin): for a
   periodic harmonic F the phi integral yields 2 pi J0(k rho). *)
check["Per8: gyrophase integral gives 2 pi J0(k rho)",
  Simplify[Integrate[Exp[-I k rho Sin[phi]], {phi, 0, 2 Pi},
      Assumptions -> k > 0 && rho > 0] == 2 Pi BesselJ[0, k rho]]];

(* Discrete orthogonality behind Eq. (fourcd): one-period integral of a
   harmonic against a grid mode selects the diagonal. *)
check["Per9: one-period Fourier orthogonality on k_m = 2 pi m/L",
  Module[{l = 3/2},
    Simplify[Integrate[Exp[I (2 Pi 2/l) x] Exp[-I (2 Pi 2/l) x],
        {x, 0, l}] == l] &&
      Simplify[Integrate[Exp[I (2 Pi 2/l) x] Exp[-I (2 Pi 1/l) x],
        {x, 0, l}] == 0]]];

reportAndExit[];

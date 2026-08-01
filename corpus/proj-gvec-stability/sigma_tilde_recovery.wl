ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, len > 0, bz[r] > 0, btheta[r] > 0,
  Element[{lam[r], Derivative[1][lam][r]}, Reals],
  btheta[r]^2 + bz[r]^2 > 0, 0 < u < 1/4, 0 < v < 1};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Boozer gauge freedom theta -> theta + lambda(s) on the screw pinch:
   tests whether sigma-tilde (Schwab 1991, eq. 3.2.10) is determined by
   surface data alone or is chart data that the exporter must supply. *)
position[r_, u_, v_] := {r Cos[2 Pi (u + lam[r])],
  r Sin[2 Pi (u + lam[r])], len v};
basis[r_, u_, v_] := {D[position[r, u, v], r], D[position[r, u, v], u],
  D[position[r, u, v], v]};
jac[r_, u_, v_] := basis[r, u, v][[1]] .
  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]];
duals[r_, u_, v_] := Module[{b = basis[r, u, v]},
  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],
    Cross[b[[1]], b[[2]]]}/jac[r, u, v]];
field[r_, u_, v_] := btheta[r] {-Sin[2 Pi (u + lam[r])],
  Cos[2 Pi (u + lam[r])], 0} + bz[r] {0, 0, 1};
bmag2 = btheta[r]^2 + bz[r]^2;

covariantS = FullSimplify[basis[r, u, v][[1]] . field[r, u, v],
  assumptions];
covariantU = FullSimplify[basis[r, u, v][[2]] . field[r, u, v],
  assumptions];
covariantV = FullSimplify[basis[r, u, v][[3]] . field[r, u, v],
  assumptions];
gsu = FullSimplify[basis[r, u, v][[1]] . basis[r, u, v][[2]],
  assumptions];
gsv = FullSimplify[basis[r, u, v][[1]] . basis[r, u, v][[3]],
  assumptions];
check["shifted chart has nonzero beta-tilde",
  covariantS == 2 Pi r btheta[r] Derivative[1][lam][r]];

gradS = duals[r, u, v][[1]];
gradTheta = duals[r, u, v][[2]];
gradZeta = duals[r, u, v][[3]];
fluxTslope = FullSimplify[jac[r, u, v] (gradZeta . field[r, u, v]),
  assumptions];
sigmaFirst = FullSimplify[(covariantV gsu - covariantU gsv)/
    (jac[r, u, v] Sqrt[bmag2]), assumptions];
fluxPslope = FullSimplify[jac[r, u, v] (gradTheta . field[r, u, v]),
  assumptions];
sigmaContra = FullSimplify[(fluxTslope (gradS . gradTheta) -
    fluxPslope (gradS . gradZeta))/Sqrt[bmag2], assumptions];
check["contravariant sigma-tilde form matches the covariant one up to
the Jacobian sign",
  FullSimplify[sigmaFirst Sign[jac[r, u, v]] + sigmaContra,
    Join[assumptions, {jac[r, u, v] > 0}]] == 0];
sigmaSecond = FullSimplify[-(bmag2 gsu - covariantU covariantS)/
    (fluxTslope Sqrt[bmag2]), assumptions];
check["beta form matches the contravariant form",
  FullSimplify[sigmaContra - sigmaSecond] == 0];
check["sigma-tilde depends on the radial gauge",
  ! TrueQ[FullSimplify[
    D[sigmaFirst /. Derivative[1][lam][r] -> lamslope, lamslope] == 0,
    assumptions]]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

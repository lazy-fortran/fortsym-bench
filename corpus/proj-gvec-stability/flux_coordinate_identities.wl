ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Screw pinch of length len = 2 Pi R0, periodic in z, mapped to
   straight-field-line flux coordinates (r, u, v) with normalized angles
   u = theta/(2 Pi), v = z/len as in the CAS3D one-period convention. *)
position[r_, u_, v_] := {r Cos[2 Pi u], r Sin[2 Pi u], len v};
basis[r_, u_, v_] := {
  D[position[r, u, v], r],
  D[position[r, u, v], u],
  D[position[r, u, v], v]};
jacobian[r_, u_, v_] := basis[r, u, v][[1]] .
  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]];
check["cylindrical Jacobian", jacobian[r, u, v] == 2 Pi len r];

field[r_, u_, v_] := btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +
  bz[r] {0, 0, 1};

toroidalFlux[r_] := Integrate[2 Pi rho bz[rho], {rho, 0, r},
  Assumptions -> 0 < r];
poloidalFlux[r_] := Integrate[len btheta[rho], {rho, 0, r},
  Assumptions -> 0 < r];
currentJ[r_] := 2 Pi r btheta[r];
currentI[r_] := len bz[r];

contravariant[r_, u_, v_] := Module[{b = basis[r, u, v], jac},
  jac = jacobian[r, u, v];
  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],
      Cross[b[[1]], b[[2]]]}/jac];
covariantB[r_, u_, v_] := basis[r, u, v] . field[r, u, v];
contravariantB[r_, u_, v_] := contravariant[r, u, v] . field[r, u, v];

check["contravariant B^r vanishes", contravariantB[r, u, v][[1]] == 0];
check["sqrt(g) B^u is the poloidal flux derivative",
  jacobian[r, u, v] contravariantB[r, u, v][[2]] == poloidalFlux'[r]];
check["sqrt(g) B^v is the toroidal flux derivative",
  jacobian[r, u, v] contravariantB[r, u, v][[3]] == toroidalFlux'[r]];
check["covariant B_r vanishes: Boozer form with zero beta",
  covariantB[r, u, v][[1]] == 0];
check["covariant B_u is the toroidal-current function",
  covariantB[r, u, v][[2]] == currentJ[r]];
check["covariant B_v is the poloidal-current function",
  covariantB[r, u, v][[3]] == currentI[r]];

check["Boozer Jacobian identity  B^2 sqrt(g) = FT' I + FP' J",
  field[r, u, v] . field[r, u, v] jacobian[r, u, v] ==
    toroidalFlux'[r] currentI[r] + poloidalFlux'[r] currentJ[r]];

iota[r_] := poloidalFlux'[r]/toroidalFlux'[r];
check["rotational transform from flux slopes",
  iota[r] == len btheta[r]/(2 Pi r bz[r])];
check["field lines are straight:  B.grad(u - iota v) = 0",
  contravariantB[r, u, v][[2]] - iota[r] contravariantB[r, u, v][[3]] == 0];

testFunction[r_, u_, v_] := f[r, u, v];
gradTest[r_, u_, v_] := Transpose[contravariant[r, u, v]] . {
  D[testFunction[r, u, v], r],
  D[testFunction[r, u, v], u],
  D[testFunction[r, u, v], v]};
check["magnetic differential operator  sqrt(g) B.grad",
  FullSimplify[jacobian[r, u, v] field[r, u, v] . gradTest[r, u, v] -
      (poloidalFlux'[r] D[f[r, u, v], u] +
        toroidalFlux'[r] D[f[r, u, v], v])] == 0];
gradR[r_, u_, v_] := contravariant[r, u, v][[1]];
(* Right-handed (r,u,v); the left-handed CAS3D frame flips this sign. *)
check["surface operator  sqrt(g) (grad r x B).grad",
  FullSimplify[jacobian[r, u, v]
        Cross[gradR[r, u, v], field[r, u, v]] . gradTest[r, u, v] -
      (currentJ[r] D[f[r, u, v], v] - currentI[r] D[f[r, u, v], u])] == 0];

currentDensity[r_, u_, v_] := Module[{x, y, z, bCart},
  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +
    bz[Sqrt[x^2 + y^2]] {0, 0, 1};
  Curl[bCart, {x, y, z}]/mu0 /.
    {x -> position[r, u, v][[1]], y -> position[r, u, v][[2]],
      z -> position[r, u, v][[3]]}];
contravariantCurrent[r_, u_, v_] :=
  contravariant[r, u, v] . currentDensity[r, u, v];
simplifyAssuming[expr_] := FullSimplify[expr,
  {0 < r, 0 < u < 1, 0 < v < 1, Cos[2 Pi u] != 0}];
check["Ampere:  mu0 sqrt(g) j^u = -I'",
  simplifyAssuming[mu0 jacobian[r, u, v]
        contravariantCurrent[r, u, v][[2]] + currentI'[r]] == 0];
check["Ampere:  mu0 sqrt(g) j^v = J'",
  simplifyAssuming[mu0 jacobian[r, u, v]
        contravariantCurrent[r, u, v][[3]] - currentJ'[r]] == 0];

forceBalanceP[r_] := -btheta[r] D[rho btheta[rho], rho]/(mu0 r) -
    bz[r] bz'[r]/mu0 /. rho -> r;
check["radial force balance  mu0 p' sqrt(g) + FT' I' + FP' J' = 0",
  simplifyAssuming[mu0 forceBalanceP[r] jacobian[r, u, v] +
      toroidalFlux'[r] currentI'[r] + poloidalFlux'[r] currentJ'[r]] == 0];
check["force balance matches j x B . grad r",
  simplifyAssuming[forceBalanceP[r] -
      Cross[currentDensity[r, u, v], field[r, u, v]] .
        basis[r, u, v][[1]]/basis[r, u, v][[1]] .
        basis[r, u, v][[1]]] == 0];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

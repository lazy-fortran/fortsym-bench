ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, len > 0, mu0 > 0, bz[r] > 0,
  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],
    beta[r, u, v], Derivative[1, 0, 0][beta][r, u, v],
    Derivative[0, 1, 0][beta][r, u, v],
    Derivative[0, 0, 1][beta][r, u, v]}, Reals],
  btheta[r]^2 + bz[r]^2 > 0};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Screw pinch in normalized one-period coordinates (r,u,v), as in
   flux_coordinate_identities.wl.  This gate verifies that every Mercier
   ingredient is recoverable from the quantities the GVEC CAS3D export
   provides: contravariant field, angular metric, Jacobian, and radial
   profiles, plus radial derivatives of position harmonics for the
   covariant radial component. *)
position[r_, u_, v_] := {r Cos[2 Pi u], r Sin[2 Pi u], len v};
basis[r_, u_, v_] := {
  D[position[r, u, v], r],
  D[position[r, u, v], u],
  D[position[r, u, v], v]};
jacobian[r_, u_, v_] := basis[r, u, v][[1]] .
  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]];
field[r_, u_, v_] := btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +
  bz[r] {0, 0, 1};
metric[r_, u_, v_] := Module[{b = basis[r, u, v]},
  Table[b[[i]] . b[[j]], {i, 3}, {j, 3}]];
contravariantB[r_, u_, v_] := Module[{b = basis[r, u, v], jac},
  jac = jacobian[r, u, v];
  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],
      Cross[b[[1]], b[[2]]]} . field[r, u, v]/jac];

bSupU = contravariantB[r, u, v][[2]];
bSupV = contravariantB[r, u, v][[3]];
g = metric[r, u, v];

check["iota from contravariant field ratio",
  bSupU/bSupV == len btheta[r]/(2 Pi r bz[r])];
check["toroidal flux slope from Jacobian and B^v",
  jacobian[r, u, v] bSupV == 2 Pi r bz[r]];
check["poloidal flux slope from Jacobian and B^u",
  jacobian[r, u, v] bSupU == len btheta[r]];
covariantU = g[[2, 2]] bSupU + g[[2, 3]] bSupV;
covariantV = g[[3, 2]] bSupU + g[[3, 3]] bSupV;
check["current function J from angular metric only",
  covariantU == 2 Pi r btheta[r]];
check["current function I from angular metric only",
  covariantV == len bz[r]];
covariantS = g[[1, 2]] bSupU + g[[1, 3]] bSupV;
check["covariant radial component vanishes for the screw pinch",
  covariantS == 0];

(* Pointwise mu0 J.B from covariant components: the curl in flux
   coordinates needs only angular flux functions and beta = B_s. *)
fieldWithBeta[r_, u_, v_] := Module[{b = basis[r, u, v], jac, gradS},
  jac = jacobian[r, u, v];
  gradS = Cross[b[[2]], b[[3]]]/jac;
  field[r, u, v] + beta[r, u, v] gradS];
curlCartesian[r_, u_, v_] := Module[{fx, fy, fz, jacInv, b, jac, grads},
  b = basis[r, u, v];
  jac = jacobian[r, u, v];
  grads = {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],
    Cross[b[[1]], b[[2]]]}/jac;
  Sum[Cross[grads[[i]],
    D[fieldWithBeta[rr, uu, vv], {{rr, uu, vv}[[i]]}] /.
      {rr -> r, uu -> u, vv -> v}], {i, 3}]];
betaU = D[beta[r, uu, v], uu] /. uu -> u;
betaV = D[beta[r, u, vv], vv] /. vv -> v;
curlFormula[r_, u_, v_] := Module[{b = basis[r, u, v], jac},
  jac = jacobian[r, u, v];
  (betaV - D[covariantV, r]) b[[2]]/jac +
    (D[covariantU, r] - betaU) b[[3]]/jac];
check["covariant curl formula matches Cartesian curl",
  FullSimplify[curlCartesian[r, u, v] - curlFormula[r, u, v]] ==
    {0, 0, 0}];
check["mu0 sqrt(g) J.B from export quantities",
  FullSimplify[jacobian[r, u, v] curlCartesian[r, u, v] .
        fieldWithBeta[r, u, v] -
      ((betaV - D[covariantV, r]) covariantU +
        (D[covariantU, r] - betaU) covariantV)] == 0];

(* Pressure gradient from force balance: no pressure profile derivative
   is needed beyond the exported profiles. *)
check["p' recovered from force-balance identity",
  FullSimplify[-(2 Pi r bz[r] D[len bz[rr], rr] +
        len btheta[r] D[2 Pi rr btheta[rr], rr])/(
        mu0 jacobian[r, u, v]) -
      (-(btheta[r] D[rr btheta[rr], rr])/(mu0 r) -
        bz[r] Derivative[1][bz][r]/mu0) /. rr -> r] == 0];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

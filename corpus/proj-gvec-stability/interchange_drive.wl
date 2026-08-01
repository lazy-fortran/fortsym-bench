ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, len > 0, mu0 > 0, bz[r] > 0,
  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],
    Derivative[2][btheta][r], Derivative[2][bz][r]}, Reals],
  btheta[r]^2 + bz[r]^2 > 0};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Interchange drive coefficient of the symmetric W_P (Schwab 1991,
   eq. 3.2.3 and appendix D.2) on the analytic screw pinch. *)
position[r_, u_, v_] := {r Cos[2 Pi u], r Sin[2 Pi u], len v};
basis[r_, u_, v_] := {D[position[r, u, v], r], D[position[r, u, v], u],
  D[position[r, u, v], v]};
jacobian[r_, u_, v_] := basis[r, u, v][[1]] .
  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]];
field[r_, u_, v_] := btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +
  bz[r] {0, 0, 1};
gradS[r_, u_, v_] := Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]]/
  jacobian[r, u, v];
current[r_, u_, v_] := Module[{x, y, z, bCart},
  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +
    bz[Sqrt[x^2 + y^2]] {0, 0, 1};
  Curl[bCart, {x, y, z}]/mu0 /.
    {x -> position[r, u, v][[1]], y -> position[r, u, v][[2]],
      z -> position[r, u, v][[3]]}];
bGradGradS[r_, u_, v_] := Module[{x, y, z, gradSCart, bCart},
  gradSCart = {x, y, 0}/Sqrt[x^2 + y^2];
  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +
    bz[Sqrt[x^2 + y^2]] {0, 0, 1};
  (bCart . {D[#, x], D[#, y], D[#, z]} & /@ gradSCart) /.
    {x -> position[r, u, v][[1]], y -> position[r, u, v][[2]],
      z -> position[r, u, v][[3]]}];

simp[expr_] := FullSimplify[expr,
  Join[assumptions, {0 < u < 1/4, 0 < v < 1}]];

gradSsquared = simp[gradS[r, u, v] . gradS[r, u, v]];
check["screw-pinch grad s has unit magnitude in radius label",
  gradSsquared == 1];

driveA = simp[2/gradSsquared^2 *
  Cross[current[r, u, v], gradS[r, u, v]] . bGradGradS[r, u, v]];
pressureSlope = -(btheta[r] D[s btheta[s], s]/(mu0 r) /. s -> r) -
  bz[r] Derivative[1][bz][r]/mu0;
check["drive reduces to the cylindrical interchange form",
  simp[driveA - 2 btheta[r] (D[s btheta[s], s] /. s -> r)/
    (mu0 r^2)] == 0];

jSquared = simp[current[r, u, v] . current[r, u, v]];
jDotB = simp[current[r, u, v] . field[r, u, v]];
check["current magnitude identity of appendix D",
  simp[jSquared - (jDotB^2 + pressureSlope^2 gradSsquared)/
    (btheta[r]^2 + bz[r]^2)] == 0];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

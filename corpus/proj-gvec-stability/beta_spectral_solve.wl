ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, len > 0, mu0 > 0, bz[r] > 0, mm > 0, nn > 0,
  Element[{btheta[r], Derivative[1][btheta][r], Derivative[1][bz][r],
    beta[r, u, v]}, Reals], btheta[r]^2 + bz[r]^2 > 0};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];
conj[expr_] := expr /. Complex[a_, b_] :> Complex[a, -b];

(* Screw pinch with an arbitrary covariant radial component beta, as in
   mercier_from_export.wl.  This gate verifies the magnetic differential
   equation that determines beta from export quantities alone, and its
   spectral inversion, following Schwab (1991) eq. 3.2.9. *)
position[r_, u_, v_] := {r Cos[2 Pi u], r Sin[2 Pi u], len v};
basis[r_, u_, v_] := {D[position[r, u, v], r], D[position[r, u, v], u],
  D[position[r, u, v], v]};
jacobian[r_, u_, v_] := basis[r, u, v][[1]] .
  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]];
field[r_, u_, v_] := btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +
  bz[r] {0, 0, 1};
fieldWithBeta[r_, u_, v_] := Module[{b = basis[r, u, v], jac},
  jac = jacobian[r, u, v];
  field[r, u, v] + beta[r, u, v] Cross[b[[2]], b[[3]]]/jac];
curlCartesian[r_, u_, v_] := Module[{b, jac, grads},
  b = basis[r, u, v]; jac = jacobian[r, u, v];
  grads = {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],
    Cross[b[[1]], b[[2]]]}/jac;
  Sum[Cross[grads[[i]],
    D[fieldWithBeta[rr, uu, vv], {{rr, uu, vv}[[i]]}] /.
      {rr -> r, uu -> u, vv -> v}], {i, 3}]];

covariantU = 2 Pi r btheta[r];
covariantV = len bz[r];
contravariantU = btheta[r]/(2 Pi r);
contravariantV = bz[r]/len;
betaU = D[beta[r, uu, v], uu] /. uu -> u;
betaV = D[beta[r, u, vv], vv] /. vv -> v;

forceS = Cross[curlCartesian[r, u, v], fieldWithBeta[r, u, v]] .
  basis[r, u, v][[1]];
check["B.grad beta from export quantities",
  FullSimplify[contravariantU betaU + contravariantV betaV -
      (forceS + D[covariantV, r] contravariantV +
        D[covariantU, r] contravariantU)] == 0];

fluxP = len btheta[r];
fluxT = 2 Pi r bz[r];
harmonic = Cos[2 Pi (mm u - nn v)];
check["spectral symbol of the magnetic differential operator",
  FullSimplify[jacobian[r, u, v] (contravariantU D[harmonic, u] +
        contravariantV D[harmonic, v]) +
      2 Pi (mm fluxP - nn fluxT) Sin[2 Pi (mm u - nn v)]] == 0];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, len > 0, bz[r] > 0, btheta[r] > 0,
  btheta[r]^2 + bz[r]^2 > 0, 0 < u < 1/4, 0 < v < 1};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* CAS3D scalar components (Schwab 1991, eq. 3.2.14) verified against
   C = curl(xi x B) + (j x grad s/|grad s|^2) xi^s on the screw pinch
   with a generic displacement; thesis units with mu0 = 1, so j = curl B
   and p' follows from force balance in those units.  On this equilibrium
   beta and g_stheta vanish, hence sigma-tilde = 0.  Chart: right-handed
   with toroidal flux increasing outward; the dissertation states a
   left-handed frame, and in this chart the C^3 radial-derivative and
   flux-curvature terms verify with negative signs where the print has
   positive ones.  The realization question is settled downstream by the
   Newcomb/Suydam limit in the export convention. *)
position[r_, u_, v_] := {r Cos[2 Pi u], r Sin[2 Pi u], len v};
basis[r_, u_, v_] := {D[position[r, u, v], r], D[position[r, u, v], u],
  D[position[r, u, v], v]};
jac[r_, u_, v_] := basis[r, u, v][[1]] .
  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]];
duals[r_, u_, v_] := Module[{b = basis[r, u, v]},
  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],
    Cross[b[[1]], b[[2]]]}/jac[r, u, v]];
field[r_, u_, v_] := btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} +
  bz[r] {0, 0, 1};
bmag = Sqrt[btheta[r]^2 + bz[r]^2];
current[r_, u_, v_] := Module[{x, y, z, bCart},
  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +
    bz[Sqrt[x^2 + y^2]] {0, 0, 1};
  Curl[bCart, {x, y, z}] /.
    {x -> position[r, u, v][[1]], y -> position[r, u, v][[2]],
      z -> position[r, u, v][[3]]}];

displacement[rr_, uu_, vv_] := xs[rr, uu, vv] duals[rr, uu, vv][[1]]/
    (duals[rr, uu, vv][[1]] . duals[rr, uu, vv][[1]]) +
  xu[rr, uu, vv] basis[rr, uu, vv][[2]] +
  xv[rr, uu, vv] basis[rr, uu, vv][[3]];
cVector = Sum[Cross[duals[r, u, v][[i]],
    D[Cross[displacement[rr, uu, vv], field[rr, uu, vv]],
      {{rr, uu, vv}[[i]]}] /. {rr -> r, uu -> u, vv -> v}], {i, 3}] +
  Cross[current[r, u, v], duals[r, u, v][[1]]] xs[r, u, v]/
    (duals[r, u, v][[1]] . duals[r, u, v][[1]]);

gradS = duals[r, u, v][[1]];
gradSmag = 1;
e1 = gradS;
e3 = field[r, u, v]/bmag;
e2 = Cross[e1, e3];

sqg = jac[r, u, v];
fluxT[rr_] := 2 Pi rr bz[rr];
fluxP[rr_] := len btheta[rr];
currentI[rr_] := len bz[rr];
currentJ[rr_] := 2 Pi rr btheta[rr];
eta[rr_, uu_, vv_] := fluxT[rr] xu[rr, uu, vv] - fluxP[rr] xv[rr, uu, vv];
bGrad[f_] := (fluxP[r] (D[f /. u -> uu, uu] /. uu -> u) +
    fluxT[r] (D[f /. v -> vv, vv] /. vv -> v))/sqg;
pressureSlope = -(btheta[r] (D[s btheta[s], s] /. s -> r)/r) -
  bz[r] Derivative[1][bz][r];
jDotB = FullSimplify[current[r, u, v] . field[r, u, v], assumptions];

cOneFormula = bGrad[xs[r, u, v]]/gradSmag;
check["C1 field-line bending component",
  FullSimplify[cVector . e1 - cOneFormula] == 0];

cTwoFormula = -(gradSmag/(bmag sqg)) (sqg bGrad[eta[r, u, v]] -
    (fluxT[r] fluxP'[r] - fluxT'[r] fluxP[r]) xs[r, u, v] +
    jDotB sqg xs[r, u, v]/gradSmag^2);
check["C2 local-shear component",
  FullSimplify[cVector . e2 - cTwoFormula] == 0];

cThreeFormula = (1/(bmag sqg)) (currentJ[r] (D[eta[r, u, vv], vv] /.
      vv -> v) - currentI[r] (D[eta[r, uu, v], uu] /. uu -> u) +
    (fluxT[r] currentI[r] + fluxP[r] currentJ[r]) (-(D[xs[rr, u, v],
      rr] /. rr -> r)) -
    (currentJ[r] fluxP'[r] + currentI[r] fluxT'[r]) xs[r, u, v] -
    pressureSlope sqg xs[r, u, v]);
check["C3 field-compression component",
  FullSimplify[cVector . e3 - cThreeFormula] == 0];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

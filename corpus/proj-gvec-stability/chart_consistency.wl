ClearAll["Global`*"];
pass = 0; fail = 0;
assumptions = {r > 0, len > 0, bz[r] > 0, btheta[r] > 0,
  btheta[r]^2 + bz[r]^2 > 0, 0 < u1 < 1/4, 0 < v < 1,
  Element[{lam[r], Derivative[1][lam][r]}, Reals]};
check[name_, condition_] := If[
  TrueQ[FullSimplify[condition, assumptions]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Chart consistency of the two-component kernel under the Boozer gauge
   freedom theta -> theta + lambda(s) on the screw pinch.  The shifted
   chart has g_stheta != 0, nonzero sigma-tilde, and a physical B_s that
   is a pure flux function.  Verifies the exported-metric consumption
   formulas (cofactor inverses, beta-tilde and sigma-tilde pointwise
   from g_st, g_sz) and that the kernel C-components reproduce the
   chart-free covariant construction ONLY with the physical B_s as
   beta-tilde: the mean-free spectral solution drops the flux-function
   part, which is chart data.  Kernel formulas transcribed from GLISS
   two_component_kernel.f90; covariant construction and conventions
   follow c_components.wl (right-handed chart, thesis units mu0 = 1). *)

geo = u1 - lam[r];
position = {r Cos[2 Pi geo], r Sin[2 Pi geo], len v};
basis = {D[position, r], D[position, u1], D[position, v]};
jacS = basis[[1]] . Cross[basis[[2]], basis[[3]]];
duals = {Cross[basis[[2]], basis[[3]]], Cross[basis[[3]], basis[[1]]],
    Cross[basis[[1]], basis[[2]]]}/jacS;
field = btheta[r] {-Sin[2 Pi geo], Cos[2 Pi geo], 0} + bz[r] {0, 0, 1};
bmag = Sqrt[btheta[r]^2 + bz[r]^2];

gss = basis[[1]] . basis[[1]]; gst = basis[[1]] . basis[[2]];
gsz = basis[[1]] . basis[[3]]; gtt = basis[[2]] . basis[[2]];
gtz = basis[[2]] . basis[[3]]; gzz = basis[[3]] . basis[[3]];
det = jacS^2;

check["cofactor g^ss matches grad s . grad s",
  (gtt gzz - gtz^2)/det == duals[[1]] . duals[[1]]];
check["cofactor g^stheta matches grad s . grad theta",
  (gsz gtz - gst gzz)/det == duals[[1]] . duals[[2]]];
check["cofactor g^szeta matches grad s . grad zeta",
  (gst gtz - gsz gtt)/det == duals[[1]] . duals[[3]]];

covariantS = field . basis[[1]];
covariantU = field . basis[[2]];
covariantV = field . basis[[3]];
contraU = field . duals[[2]]; contraV = field . duals[[3]];
check["covariant B_s follows from contravariant B and g_st, g_sz",
  covariantS == contraU gst + contraV gsz];
check["physical B_s is a pure flux function in the shifted chart",
  D[covariantS, u1] == 0 && D[covariantS, v] == 0];

fluxT[rr_] := 2 Pi rr bz[rr];
fluxP[rr_] := len btheta[rr];
currentI[rr_] := len bz[rr];
currentJ[rr_] := 2 Pi rr btheta[rr];
sigmaFirst = (covariantV gst - covariantU gsz)/(jacS bmag);
sigmaContra = (fluxT[r] (duals[[1]] . duals[[2]]) -
    fluxP[r] (duals[[1]] . duals[[3]]))/bmag;
check["sigma-tilde first form matches the contravariant definition",
  FullSimplify[sigmaFirst + sigmaContra Sign[jacS], assumptions] == 0];

(* Physical displacement: identical scalar fields in geometric
   coordinates; kernel inputs are their shifted-chart derivatives. *)
xsS[rr_, uu_, vv_] := xs[rr, uu - lam[rr], vv];
xuContra[rr_, uu_, vv_] := xu[rr, uu - lam[rr], vv] +
  Derivative[1][lam][rr] xs[rr, uu - lam[rr], vv];
etaS[rr_, uu_, vv_] := fluxT[rr] xuContra[rr, uu, vv] -
  fluxP[rr] xv[rr, uu - lam[rr], vv];

bGradS[f_] := (fluxP[r] D[f, u1] + fluxT[r] D[f, v])/jacS;
gradS2 = duals[[1]] . duals[[1]];
xiS = xsS[r, u1, v];
xiSs = D[xsS[rr, u1, v], rr] /. rr -> r;
pressureSlope = -(btheta[r] (D[s btheta[s], s] /. s -> r)/r) -
  bz[r] Derivative[1][bz][r];

(* Chart-free covariant construction, from c_components.wl, in the
   geometric chart; projections are physical scalars. *)
positionG = {r Cos[2 Pi u], r Sin[2 Pi u], len v};
basisG = {D[positionG, r], D[positionG, u], D[positionG, v]};
jacG = basisG[[1]] . Cross[basisG[[2]], basisG[[3]]];
dualsG = {Cross[basisG[[2]], basisG[[3]]],
    Cross[basisG[[3]], basisG[[1]]],
    Cross[basisG[[1]], basisG[[2]]]}/jacG;
fieldG = btheta[r] {-Sin[2 Pi u], Cos[2 Pi u], 0} + bz[r] {0, 0, 1};
currentG = Module[{x, y, z, bCart},
  bCart = btheta[Sqrt[x^2 + y^2]] {-y, x, 0}/Sqrt[x^2 + y^2] +
    bz[Sqrt[x^2 + y^2]] {0, 0, 1};
  Curl[bCart, {x, y, z}] /. {x -> positionG[[1]],
    y -> positionG[[2]], z -> positionG[[3]]}];
displacementG[rr_, uu_, vv_] := Module[{b, d},
  b = {D[{#1 Cos[2 Pi #2], #1 Sin[2 Pi #2], len #3}, #1],
      D[{#1 Cos[2 Pi #2], #1 Sin[2 Pi #2], len #3}, #2],
      D[{#1 Cos[2 Pi #2], #1 Sin[2 Pi #2], len #3}, #3]} &[rr, uu, vv];
  d = {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],
      Cross[b[[1]], b[[2]]]}/(b[[1]] . Cross[b[[2]], b[[3]]]);
  xs[rr, uu, vv] d[[1]]/(d[[1]] . d[[1]]) +
    xu[rr, uu, vv] b[[2]] + xv[rr, uu, vv] b[[3]]];
cVector = Sum[Cross[dualsG[[i]],
    D[Cross[displacementG[rr, uu, vv], btheta[rr] {-Sin[2 Pi uu],
        Cos[2 Pi uu], 0} + bz[rr] {0, 0, 1}],
      {{rr, uu, vv}[[i]]}] /. {rr -> r, uu -> u, vv -> v}], {i, 3}] +
  Cross[currentG, dualsG[[1]]] xs[r, u, v]/
    (dualsG[[1]] . dualsG[[1]]);
e1 = dualsG[[1]]; e3 = fieldG/bmag; e2 = Cross[e1, e3];

toGeo = {u1 -> u + lam[r]};
jDotB = FullSimplify[currentG . fieldG, assumptions];

cOneKernel = bGradS[xiS]/Sqrt[gradS2];
check["C1 kernel matches the covariant projection in the shifted chart",
  FullSimplify[(cOneKernel /. toGeo) - cVector . e1, assumptions] == 0];

cTwoKernel = -(Sqrt[gradS2]/(bmag jacS)) (jacS bGradS[etaS[r, u1, v]] -
    (fluxT[r] Derivative[1][fluxP][r] -
      Derivative[1][fluxT][r] fluxP[r]) xiS +
    jDotB jacS xiS/gradS2 +
    sigmaFirst bmag jacS bGradS[xiS]/gradS2);
check["C2 kernel with first-form sigma-tilde matches the projection",
  FullSimplify[(cTwoKernel /. toGeo) - cVector . e2, assumptions] == 0];

cThreeKernel[beta_] := (1/(bmag jacS)) (currentJ[r] D[etaS[r, u1, v], v] -
    currentI[r] D[etaS[r, u1, v], u1] -
    (fluxT[r] currentI[r] + fluxP[r] currentJ[r]) xiSs -
    (currentJ[r] Derivative[1][fluxP][r] +
      currentI[r] Derivative[1][fluxT][r]) xiS -
    pressureSlope jacS xiS + beta jacS bGradS[xiS]);
check["C3 kernel closes with the physical B_s as beta-tilde",
  FullSimplify[(cThreeKernel[covariantS] /. toGeo) - cVector . e3,
    assumptions] == 0];
check["mean-free beta-tilde does not close C3 in the shifted chart",
  ! TrueQ[FullSimplify[(cThreeKernel[0] /. toGeo) - cVector . e3,
    assumptions] == 0]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

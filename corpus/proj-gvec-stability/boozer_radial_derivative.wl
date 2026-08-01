ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[
  TrueQ[Simplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Gate for the g_st exporter extension (calbert/gvec MR spec in
   ROADMAP.md): the Boozer radial basis vector

     e_rho_B = e_rho - (LA_r + iota' nu + iota nu_r) e_theta_B
                     - nu_r e_zeta_B

   with theta_B = theta + LA + iota nu, zeta_B = zeta + nu (GVEC
   convention, quantities.py dtB_*/dzB_* block), and the spectral
   recovery of nu_r from the rho-differentiated closed-form angular
   derivatives dNU_B_dt, dNU_B_dz.  Angles u, v in [0,1) with explicit
   2 Pi factors, phase convention m u - n v.  Assumes the exporter's
   normalization <nu>_surface = 0 on every surface, so the (0,0)
   harmonic of nu_r vanishes. *)

r0 = 7/2; rr = 2/5; uu = 3/10; vv = 7/10;
iota[r_] := 2/5 + r^2/3;
la[r_, u_, v_] := r^2/7 Sin[2 Pi (u - v)];
nu[r_, u_, v_] := r^2/5 Sin[2 Pi (u - 2 v)] + r^3/11 Sin[2 Pi (-v)];

position[r_, u_, v_] := Module[{R = r0 + r Cos[2 Pi u], phi = 2 Pi v},
  {R Cos[phi], R Sin[phi], r Sin[2 Pi u]}];

thetaB[r_, u_, v_] := u + la[r, u, v] + iota[r] nu[r, u, v];
zetaB[r_, u_, v_] := v + nu[r, u, v];

basis[r_, u_, v_] := {D[position[r, u, v], r],
  D[position[r, u, v], u], D[position[r, u, v], v]};
jac[r_, u_, v_] := basis[r, u, v][[1]] .
  Cross[basis[r, u, v][[2]], basis[r, u, v][[3]]];
duals[r_, u_, v_] := Module[{b = basis[r, u, v]},
  {Cross[b[[2]], b[[3]]], Cross[b[[3]], b[[1]]],
    Cross[b[[1]], b[[2]]]}/jac[r, u, v]];

gradScalar[f_, r_, u_, v_] := Module[{d = duals[r, u, v]},
  D[f[r, u, v], r] d[[1]] + D[f[r, u, v], u] d[[2]] +
    D[f[r, u, v], v] d[[3]]];

(* e_theta_B, e_zeta_B from the 2x2 angle block, as quantities.py
   builds them from dtB_dt, dtB_dz, dzB_dt, dzB_dz. *)
angleJacobian[r_, u_, v_] :=
  {{D[thetaB[r, u, v], u], D[thetaB[r, u, v], v]},
   {D[zetaB[r, u, v], u], D[zetaB[r, u, v], v]}};
angleInverse[r_, u_, v_] := Inverse[angleJacobian[r, u, v]];
eThetaB[r_, u_, v_] := basis[r, u, v][[2]] angleInverse[r, u, v][[1, 1]] +
  basis[r, u, v][[3]] angleInverse[r, u, v][[2, 1]];
eZetaB[r_, u_, v_] := basis[r, u, v][[2]] angleInverse[r, u, v][[1, 2]] +
  basis[r, u, v][[3]] angleInverse[r, u, v][[2, 2]];

eRhoB[r_, u_, v_] := basis[r, u, v][[1]] -
  (D[la[r, u, v], r] + Derivative[1][iota][r] nu[r, u, v] +
    iota[r] D[nu[r, u, v], r]) eThetaB[r, u, v] -
  D[nu[r, u, v], r] eZetaB[r, u, v];

at[expr_] := N[expr /. {r -> rr, u -> uu, v -> vv}, 30];
close[a_, b_] := Abs[a - b] < 10^-20;

gradRho = at[duals[r, u, v][[1]]];
gradThetaB = at[gradScalar[thetaB, r, u, v]];
gradZetaB = at[gradScalar[zetaB, r, u, v]];
erb = at[eRhoB[r, u, v]]; etb = at[eThetaB[r, u, v]];
ezb = at[eZetaB[r, u, v]];

check["e_rho_B is dual to grad rho", close[N[gradRho . erb, 30], 1]];
check["e_rho_B annihilates grad theta_B",
  close[N[gradThetaB . erb, 30], 0]];
check["e_rho_B annihilates grad zeta_B",
  close[N[gradZetaB . erb, 30], 0]];
check["e_theta_B is dual to the Boozer angles",
  close[N[gradThetaB . etb, 30], 1] &&
    close[N[gradZetaB . etb, 30], 0] &&
    close[N[gradRho . etb, 30], 0]];
check["e_zeta_B is dual to the Boozer angles",
  close[N[gradZetaB . ezb, 30], 1] &&
    close[N[gradThetaB . ezb, 30], 0] &&
    close[N[gradRho . ezb, 30], 0]];

(* Spectral recovery of nu_r: the exporter only has the pointwise
   rho-derivatives of dNU_B_dt = nu_u and dNU_B_dz = nu_v.  Because
   mixed partials commute, those equal the angular derivatives of
   nu_r, so harmonic (m, n) of nu_r is (rho-derivative of nu_u)_mn
   divided by 2 Pi m, with the n channel as fallback for m = 0. *)
mixedU = D[nu[r, u, v], r, u];
mixedV = D[nu[r, u, v], r, v];
projectCos[f_, m_, n_] := Integrate[Integrate[
  2 f Cos[2 Pi (m u - n v)], {u, 0, 1}], {v, 0, 1}];
projectSin[f_, m_, n_] := Integrate[Integrate[
  2 f Sin[2 Pi (m u - n v)], {u, 0, 1}], {v, 0, 1}];
slopeCoefficient[m_, n_] := If[m != 0,
  projectCos[mixedU, m, n]/(2 Pi m),
  -projectCos[mixedV, m, n]/(2 Pi n)];
harmonics = {{1, 2}, {0, 1}};
recovered = Sum[slopeCoefficient[h[[1]], h[[2]]] Sin[
    2 Pi (h[[1]] u - h[[2]] v)], {h, harmonics}];

check["theta channel recovers the m != 0 slope harmonic",
  Simplify[slopeCoefficient[1, 2] ==
    projectSin[D[nu[r, u, v], r], 1, 2]]];
check["zeta channel recovers the m = 0 slope harmonic",
  Simplify[slopeCoefficient[0, 1] ==
    projectSin[D[nu[r, u, v], r], 0, 1]]];
check["recovered nu_r matches D[nu, r] pointwise",
  Simplify[recovered == D[nu[r, u, v], r]]];

(* s-chart scaling: the CAS3D export radializes in s = rho^2, so
   g_st = (e_rho_B . e_theta_B) drho/ds = g_rt_B / (2 rho). *)
check["g_st in the s chart is g_rt_B / (2 rho)",
  close[at[(erb . etb)/(2 rr)],
    at[erb . etb] N[D[Sqrt[s], s] /. s -> rr^2, 30]]];

Print[pass, " passed, ", fail, " failed"];
If[fail > 0, Exit[1]];

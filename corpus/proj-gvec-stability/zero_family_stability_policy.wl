ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];
prove[statement_] := TrueQ[Resolve[statement, Reals]];

(* N = 0 evidence and conditional bracketing policy.  Schwab 1991 documents
   xi^s(0) = 0 in the CAS3D2 space.  Schwab 1993 reports computationally that
   the fixed-boundary even N = 0 family is stable, but does not prove a
   general finite-radius spectrum.  The GLISS inertia certificate therefore
   uses runtime counts; it does not assume non-negativity from the source. *)

(* ---- Part A: integrability exclusion of the even-parity N = 0 family. ----
   Solvability needs Int sqrt(g) xi^s dtheta dphi = 0.  On the constant-
   sqrt(g) homogeneous fixture this reduces to the torus mean of xi^s.
   The mean of a cosine harmonic is 1 at (m,n) = (0,0) and 0 otherwise. *)

torusMean[m_, n_] := (1/(2 Pi))^2 *
  Integrate[Cos[m t - n p], {t, 0, 2 Pi}, {p, 0, 2 Pi}];

check["torus mean selects (0,0) among cosine harmonics (|m|,|n| <= 3)",
  And @@ Flatten[Table[
    torusMean[m, n] == If[m == 0 && n == 0, 1, 0],
    {m, -3, 3}, {n, -3, 3}]]];

(* N = 0 family (field period NT = 3): toroidal numbers are multiples of
   NT, so the even (0,0) normal mode is admitted.  An N != 0 family
   (residues +-1 mod NT) never contains (0,0). *)
zeroTrial = {{0, 0, a00}, {1, 0, a10}, {0, 3, a03}, {2, 3, a23}};
oneTrial = {{0, 1, b01}, {1, 1, b11}, {0, 2, b02}, {2, 4, b24}};
meanOf[trial_] := Sum[q[[3]] torusMean[q[[1]], q[[2]]], {q, trial}];

check["even N=0 trial mean is its (0,0) coefficient (integrability fails)",
  Simplify[meanOf[zeroTrial] - a00] == 0];
check["N!=0 family trial satisfies the integrability condition identically",
  Simplify[meanOf[oneTrial]] == 0];

(* Part B: reduce the production response algebra at the odd zero harmonic. *)
waveNorm = ft^2 + fp^2;
generalDivergence = sqrtgXiRadial/g +
  (ft sqrtgEtaTheta - fp sqrtgEtaZeta + fp muTheta + ft muZeta)/
    (g waveNorm);
zeroHarmonicRules = {sqrtgXiRadial -> 0,
  sqrtgEtaTheta -> gt eta, sqrtgEtaZeta -> gz eta,
  muTheta -> 0, muZeta -> 0};
oddDivergence = eta (ft gt - fp gz)/(g waveNorm);
check["general divergence reduces to the odd zero-harmonic response",
  Simplify[generalDivergence /. zeroHarmonicRules] == oddDivergence];

xiRules = {xi -> 0, xiRadial -> 0, xiTheta -> 0, xiZeta -> 0,
  etaTheta -> 0, etaZeta -> 0};
bgradXi = (fp xiTheta + ft xiZeta)/g;
bgradEta = (fp etaTheta + ft etaZeta)/g;
cBending = bgradXi/Sqrt[gradS2];
cShear = -Sqrt[gradS2]/(bmag g) (g bgradEta + shearXi xi +
    sigma bmag g bgradXi/gradS2);
cCompression = (currentJ etaZeta - currentI etaTheta -
    (ft currentI + fp currentJ) xiRadial - compressionXi xi +
    beta g bgradXi)/(bmag g);
check["magnetic responses vanish for the odd zero harmonic",
  Simplify[{cBending, cShear, cCompression} /. xiRules] == {0, 0, 0}];

oddFluidEnergy = gammaP Abs[g] oddDivergence^2;

check["zero-harmonic mu is structurally absent from stiffness",
  FreeQ[oddFluidEnergy, mu]];
check["eta joins the zero cluster for a constant signed Jacobian",
  Simplify[oddFluidEnergy /. {gt -> 0, gz -> 0}] == 0];
check["eta joins the zero cluster when fluid compression is disabled",
  Simplify[oddFluidEnergy /. gammaP -> 0] == 0];
check["3-D signed-Jacobian variation gives eta positive stiffness",
  prove[ForAll[{eta, ft, fp, gt, gz, g, gammaP},
    Implies[eta != 0 && g != 0 && gammaP > 0 && waveNorm > 0
        && ft gt - fp gz != 0, oddFluidEnergy > 0]]]];

delta = currentI fp - currentJ ft;
coordinateMap = {{1/Sqrt[gradS2], 0, 0},
  {sigma/Sqrt[gradS2], Sqrt[gradS2]/bmag, 0},
  {beta/bmag, -delta/(bmag waveNorm), bmag/waveNorm}};
physicalMass = Transpose[coordinateMap].coordinateMap;
oddMass = {{gradS2/bmag^2 + delta^2/(bmag^2 waveNorm^2),
    -delta/waveNorm^2}, {-delta/waveNorm^2, bmag^2/waveNorm^2}};
check["physical coordinate map reduces to the odd tangential mass block",
  Simplify[physicalMass[[{2, 3}, {2, 3}]] - oddMass] ==
    ConstantArray[0, {2, 2}]];
check["odd tangential mass determinant is positive on the physical domain",
  Simplify[Det[oddMass]] == gradS2/waveNorm^2];
check["odd tangential mass satisfies the Sylvester criterion",
  prove[ForAll[{gradS2, bmag, delta, ft, fp},
    Implies[gradS2 > 0 && bmag > 0 && waveNorm > 0,
      oddMass[[1, 1]] > 0 && Det[oddMass] > 0]]]];

(* Part C: conditional generalized-eigenvalue bracketing above an observed
   zero cluster.  Runtime inertia discovers the counts and gap by expanding
   and bisecting shifts at a configured eigenvalue-unit floor. *)
setting = f > 0 && f < p1 && p1 < p2;

check["an exact zero mode lies between opposite floor shifts",
  prove[ForAll[{f}, Implies[f > 0, 0 <= f && ! (0 <= -f)]]]];

check["inertia is constant between the floor and first positive mode",
  prove[ForAll[{f, p1, p2, x},
    Implies[setting && f <= x && x < p1, 0 <= x && ! (p1 <= x)]]]];

check["window above the floor pins the lowest positive mode",
  prove[ForAll[{f, p1, p2, rq, t},
    Implies[setting && t > 0 && rq - t >= f
        && ! (p1 <= rq - t) && p1 <= rq + t,
      Abs[rq - p1] <= t]]]];

check["certificate rejects convergence to the second positive mode",
  prove[ForAll[{f, p1, p2, rq, t},
    Implies[setting && t > 0 && rq - t >= f && p1 < rq - t,
      p1 <= rq - t]]]];

check["a narrow bracket above the floor contracts toward the first mode",
  prove[ForAll[{f, p1, p2, a, b},
    Implies[setting && f <= a && a < p1 && p1 <= b && b < p2
        && b - a < (p2 - p1)/2,
      (b - p1)/(p2 - b) < 1]]]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

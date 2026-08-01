ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

q[s_] = q0 + q1 s + q2 s^2 + q3 s^3;
f[s_, a_] = s^a q[s];
firstFormula[s_, a_] = s^a (D[q[s], s] + a q[s]/s);
secondFormula[s_, a_] =
  s^a (D[q[s], {s, 2}] + 2 a D[q[s], s]/s +
    a (a - 1) q[s]/s^2);

check["axis-factor first derivative product rule",
 FullSimplify[D[f[s, a], s] == firstFormula[s, a], s > 0]];
check["axis-factor second derivative product rule",
 FullSimplify[D[f[s, a], {s, 2}] == secondFormula[s, a], s > 0]];

check["m zero axis jet",
 Limit[{f[s, 0], D[f[s, 0], s], D[f[s, 0], {s, 2}]},
   s -> 0, Direction -> "FromAbove"] == {q0, q1, 2 q2}];
check["absolute m two axis jet",
 Limit[{f[s, 1], D[f[s, 1], s], D[f[s, 1], {s, 2}]},
   s -> 0, Direction -> "FromAbove"] == {0, q0, 2 q1}];
check["absolute m four axis jet",
 Limit[{f[s, 2], D[f[s, 2], s], D[f[s, 2], {s, 2}]},
   s -> 0, Direction -> "FromAbove"] == {0, 0, 2 q0}];
check["absolute m at least five has zero axis jet",
 FullSimplify[
  Limit[{f[s, a], D[f[s, a], s], D[f[s, a], {s, 2}]},
    s -> 0, Direction -> "FromAbove", Assumptions -> a > 2] ==
   {0, 0, 0}, a > 2]];

check["absolute m one radial slope is generically singular",
 Assuming[q0 > 0,
  Limit[D[f[s, 1/2], s], s -> 0, Direction -> "FromAbove"] ==
   Infinity]];
check["absolute m three second radial derivative is generically singular",
 Assuming[q0 > 0,
  Limit[D[f[s, 3/2], {s, 2}], s -> 0,
    Direction -> "FromAbove"] == Infinity]];

z = x + I y;
rhoRule = {x -> rho Cos[theta], y -> rho Sin[theta]};
Do[
  cartesianCos = ComplexExpand[Re[z^m]];
  cartesianSin = ComplexExpand[Im[z^m]];
  check["cosine harmonic is Cartesian polynomial m=" <> ToString[m],
   FullSimplify[(cartesianCos /. rhoRule) ==
    rho^m Cos[m theta], rho >= 0]];
  check["sine harmonic is Cartesian polynomial m=" <> ToString[m],
   FullSimplify[(cartesianSin /. rhoRule) ==
    rho^m Sin[m theta], rho >= 0]],
  {m, 0, 5}];

check["normalized toroidal flux supplies the axis factor",
 FullSimplify[(rho^m /. rho -> Sqrt[s]) == s^(m/2),
  s >= 0 && Element[m, Integers] && m >= 0]];

fixtureQ[s_] = 1 + 2 s - 3 s^2 + s^3;
fixtureF[s_] = s^(1/2) fixtureQ[s];
fixtureJet = {fixtureF[s], D[fixtureF[s], s],
    D[fixtureF[s], {s, 2}]} /. s -> 1/4;
check["exact fractional-axis fixture",
 fixtureJet == {85/128, 107/64, -113/32}];
Print["fixture jet = ", fixtureJet];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];

(* Slide 7: resonance condition k.Omega = omega. Near a resonance the
   dynamics reduces to the pendulum-like Hamiltonian
       H(theta, J) = J^2/(2 M) - K Cos[theta].
   Verify symbolically: separatrix energy E_sx = +K (hyperbolic point
   J = 0, theta = Pi), island half-width DeltaJ = 2 Sqrt[M K] (maximum J
   excursion on the separatrix, at theta = 0). Then the Chirikov overlap
   criterion (DeltaJ1 + DeltaJ2) >= |J2 - J1| on two numeric cases. *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

ham[theta_, jj_] := jj^2/(2 m) - k Cos[theta];
assum = {m > 0, k > 0};

(* ---------- fixed points ---------- *)
eqs = {D[ham[theta, jj], theta] == 0, D[ham[theta, jj], jj] == 0};
check["(theta, J) = (0, 0) is a fixed point",
    Simplify[eqs /. {theta -> 0, jj -> 0}, assum] === {True, True}];
check["(theta, J) = (Pi, 0) is a fixed point",
    Simplify[eqs /. {theta -> Pi, jj -> 0}, assum] === {True, True}];
(* character via Hessian: Det > 0 elliptic at 0, Det < 0 hyperbolic at Pi *)
hess[t0_] = D[ham[theta, jj], {{theta, jj}, 2}] /. {theta -> t0, jj -> 0};
check["(0, 0) is elliptic (Det Hess = k/m > 0)",
    Simplify[Det[hess[0]] == k/m, assum]];
check["(Pi, 0) is hyperbolic (Det Hess = -k/m < 0)",
    Simplify[Det[hess[Pi]] == -k/m, assum]];

(* ---------- separatrix energy and island half-width ---------- *)
esx = ham[Pi, 0];
check["separatrix energy E_sx = H(Pi, 0) = +K", Simplify[esx == k, assum]];

jsol = Solve[ham[0, jj] == esx, jj];
jvals = Simplify[jj /. jsol, assum];
check["separatrix J at theta = 0 is +/- 2 Sqrt[M K]",
    Simplify[Sort[jvals] == Sort[{-2 Sqrt[m k], 2 Sqrt[m k]}], assum]];
(* general trapped excursion Jmax(E) = Sqrt[2 M (E + K)], at E = E_sx: *)
jmax[e_] = Simplify[Sqrt[2 m (e + k)], assum];
check["half-width DeltaJ = Jmax(E_sx) = 2 Sqrt[M K]",
    Simplify[jmax[esx] == 2 Sqrt[m k], assum]];

(* ---------- Chirikov overlap criterion, numeric ---------- *)
width[mv_, kv_] := 2 Sqrt[mv kv];
overlapQ[j1_, w1_, j2_, w2_] := w1 + w2 >= Abs[j2 - j1];

(* case A: strong resonances close together -> overlap *)
{w1a, w2a} = {width[1., 0.09], width[1., 0.04]}; (* 0.6 and 0.4 *)
sA = (w1a + w2a)/Abs[1.8 - 1.];
Print["  case A: DeltaJ1 = ", w1a, ", DeltaJ2 = ", w2a,
    ", separation = 0.8, Chirikov S = ", sA];
check["case A: (DeltaJ1 + DeltaJ2) >= |J2 - J1| -> islands overlap",
    overlapQ[1., w1a, 1.8, w2a] && sA >= 1.];

(* case B: weak resonances far apart -> no overlap *)
{w1b, w2b} = {width[1., 0.0025], width[1., 0.0025]}; (* 0.1 and 0.1 *)
sB = (w1b + w2b)/Abs[2. - 1.];
Print["  case B: DeltaJ1 = ", w1b, ", DeltaJ2 = ", w2b,
    ", separation = 1.0, Chirikov S = ", sB];
check["case B: (DeltaJ1 + DeltaJ2) < |J2 - J1| -> no overlap",
    ! overlapQ[1., w1b, 2., w2b] && sB < 1.];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];

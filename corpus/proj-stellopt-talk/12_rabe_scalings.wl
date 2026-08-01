(* Slide 12: rabe scalings. Model boundary-layer integrals reproducing the
   two offset exponents in
       lambda_off = Lambda_A/Sqrt[nu_star] + Lambda_B/nu_star:
     - trapped-passing boundary-layer contribution
           I_A[nu_star] = Integral[Exp[-x^2 nu_star], {x, 0, Infinity}],
       a Gaussian collisional layer, scales as nu_star^(-1/2);
     - local-maxima misalignment contribution
           I_B[nu_star] = Integral[Exp[-x nu_star], {x, 0, Infinity}]
       scales as nu_star^(-1).
   Exponents verified with exact symbolic Integrate, log-derivatives,
   and Limit; plus dominance of the nu_star^(-1) term as nu_star -> 0+.
   CAUTION for editors: never write "nu" followed by star-paren in a
   comment; the star-paren pair terminates a Mathematica comment. *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

iA = Integrate[Exp[-x^2 nu], {x, 0, Infinity}, Assumptions -> nu > 0];
iB = Integrate[Exp[-x nu], {x, 0, Infinity}, Assumptions -> nu > 0];
Print["  I_A(nu*) = ", iA];
Print["  I_B(nu*) = ", iB];

check["I_A = Sqrt[Pi/nu*]/2 exactly",
    Simplify[iA - Sqrt[Pi/nu]/2, nu > 0] === 0];
check["I_B = 1/nu* exactly",
    Simplify[iB - 1/nu, nu > 0] === 0];

(* exponents via logarithmic derivative d ln I / d ln nu ---------- *)
expA = Simplify[nu D[iA, nu]/iA, nu > 0];
expB = Simplify[nu D[iB, nu]/iB, nu > 0];
Print["  d ln I_A / d ln nu* = ", expA, ",  d ln I_B / d ln nu* = ", expB];
check["boundary-layer exponent: I_A ~ nu*^(-1/2)", expA === -1/2];
check["misalignment exponent:   I_B ~ nu*^(-1)", expB === -1];

(* exponents via Limit: nu^p I(nu) finite and nonzero at the claimed p *)
check["Limit nu*^(1/2) I_A = Sqrt[Pi]/2 (finite, nonzero)",
    Simplify[Limit[Sqrt[nu] iA, nu -> 0, Direction -> "FromAbove"] -
        Sqrt[Pi]/2] === 0];
check["Limit nu* I_B = 1 (finite, nonzero)",
    Limit[nu iB, nu -> 0, Direction -> "FromAbove"] === 1];

(* collisional layer width of Exp[-x^2/nu] scales as Sqrt[nu]:
   the e-folding point x* solves x^2/nu = 1 *)
xstar = Simplify[x /. Last[Solve[x^2/nu == 1 && x > 0, x,
    Assumptions -> nu > 0]], nu > 0];
check["collisional layer width x* of Exp[-x^2/nu] equals Sqrt[nu]",
    Simplify[xstar - Sqrt[nu], nu > 0] === 0];

(* dominance: misalignment term overtakes boundary-layer term as nu* -> 0 *)
check["I_B/I_A -> Infinity as nu* -> 0+ (nu*^(-1) dominates nu*^(-1/2))",
    Limit[iB/iA, nu -> 0, Direction -> "FromAbove"] === Infinity];
check["I_B/I_A -> 0 as nu* -> Infinity (Sqrt term dominates collisional side)",
    Limit[iB/iA, nu -> Infinity] === 0];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];

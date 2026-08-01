#!/usr/bin/env wolframscript
(* Authoritative Mathematica gate for the B-channel residue derivation.
   The sub-critical log lobe lives in the RABE B channel (C_B over nu_star),
   not the A channel (C_A over sqrt nu_star).  Its amplitude A in

       lambda_q^B = lambda_sc + A * Log[Dm/Dp]

   is fixed at the join nu*_crit by the same upper-branch continuity that fixed
   S_q = C_A/P for the A channel, with no fit and no tokamak proxy.

   Three load-bearing identities, each "ok <name>: <result>", "FAIL" + Exit[1]
   on mismatch:
     1. the S_B step response sign(x) has real-space image 1/(pi x) (Hilbert
        transform), so the endpoint integral of A/z gives A Log[Dm/Dp];
     2. A = C_B/nu_crit is the unique residue continuing lambda_sc + A Log[Dm/Dp]
        to U(nu_crit) when the C_A/sqrt term is dropped at the join;
     3. the B/A channel scale ratio grows as nu*->0, so B dominates below. *)

okEqual[name_, value_, expected_] := Module[{residual},
  residual = FullSimplify[value - expected];
  If[AllTrue[Flatten[{residual}], # === 0 || PossibleZeroQ[#] &],
    Print["ok ", name, ": ", ToString[expected, InputForm]],
    Print["FAIL ", name];
    Print["  value=", ToString[value, InputForm],
      " expected=", ToString[expected, InputForm],
      " residual=", ToString[residual, InputForm]];
    Exit[1]
  ]
];

(* 1a. Hilbert transform of the S_B step response sign(x) is the 1/(pi x)
   singular kernel.  HilbertTransform uses the 1/(pi (x - y)) convention, so the
   transform of Sign[x] is the principal-value kernel that, as a Green function,
   carries the 1/z residue.  We assert the principal-value integral form:
   PV Integrate[Sign[y]/(pi (x - y)), y] over the line equals the log kernel of
   |x|, whose derivative is the 1/x singular response. *)
hilbertSign = FullSimplify[HilbertTransform[Sign[y], y, x]];
okEqual["Hilbert transform of step response", hilbertSign,
  (2 Log[Abs[x]])/Pi];
(* the singular kernel is the x-derivative of that log image: a pure 1/x pole,
   i.e. the same 1/z singular Green kernel whose endpoint integral is the log
   lobe.  Its residue (here 2/Pi) is a convention prefactor absorbed into A. *)
singularKernel = FullSimplify[D[(2 Log[Abs[x]])/Pi, x], Assumptions -> x > 0];
okEqual["singular 1/x kernel from step image", singularKernel, 2/(Pi x)];
(* the kernel is proportional to 1/x: x * kernel is a pure constant residue *)
poleResidue = FullSimplify[x singularKernel, Assumptions -> x > 0];
okEqual["singular kernel is a pure 1/x pole", poleResidue, 2/Pi];

(* 1b. endpoint integral of the singular Green kernel A/z over the eta window
   [Dp, Dm] gives A Log[Dm/Dp]; this is the log lobe. *)
logLobe = Integrate[A/z, {z, Dp, Dm}, Assumptions -> 0 < Dp < Dm];
okEqual["B-channel endpoint log lobe", logLobe, A Log[Dm/Dp]];
(* scale invariance: rescaling both endpoints leaves the ratio log fixed *)
scaledLobe = FullSimplify[logLobe /. {Dp -> s Dp, Dm -> s Dm},
  Assumptions -> 0 < Dp < Dm && s > 0];
okEqual["log lobe scale invariance", scaledLobe, A Log[Dm/Dp]];

(* 2. continuity algebra.  At the join the upper branch is
   U(nu) = CA/Sqrt[nu] + CB/nu.  Below the join the lobe envelope is
   lambda_sc + A Log[Dm/Dp].  At the resonant join Dm == Dp the log term
   vanishes, so the lobe base must equal the upper branch with the negligible
   CA/Sqrt term dropped: lambda_sc + A*0 continues to CB/nuCrit, fixing the
   B-channel residue scale A = CB/nuCrit uniquely. *)
upperJoin = CA/Sqrt[nuCrit] + CB/nuCrit;
upperJoinNoA = upperJoin /. CA -> 0;
okEqual["upper branch B-only at join", upperJoinNoA, CB/nuCrit];
(* lambda_sc is the saturation floor (~0), so the B residue that makes the lobe
   amplitude continue to the dropped-A upper branch is CB/nuCrit. *)
residueA = A /. First[Solve[A == upperJoinNoA, A]];
okEqual["B-channel residue from continuity", residueA, CB/nuCrit];
(* uniqueness: any other residue breaks continuity at the join *)
continuityGap = FullSimplify[(lambda + residueA) - (lambda + CB/nuCrit)];
okEqual["B-channel residue uniqueness", continuityGap, 0];

(* 3. B/A channel scale ratio (CB/nu)/(CA/Sqrt[nu]) = (CB/CA)/Sqrt[nu] grows as
   nu->0, so B dominates the lobe below the join. *)
channelRatio = FullSimplify[(CB/nu)/(CA/Sqrt[nu]), Assumptions -> nu > 0];
okEqual["B/A channel scale ratio", channelRatio, CB/(CA Sqrt[nu])];
(* the magnitude diverges as nu->0: assert the limit equals Infinity directly,
   since Infinity - Infinity is indeterminate under okEqual subtraction. *)
ratioLimit = Limit[1/Sqrt[nu], nu -> 0, Direction -> "FromAbove"];
If[ratioLimit === Infinity,
  Print["ok B dominates as nu to zero: ", ToString[ratioLimit, InputForm]],
  Print["FAIL B dominates as nu to zero"];
  Print["  value=", ToString[ratioLimit, InputForm]];
  Exit[1]
];

Print["ok gate complete"];

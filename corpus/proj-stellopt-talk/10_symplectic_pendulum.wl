(* Slide 10: structure preservation. Pendulum H = p^2/2 - Cos[q].
   (a) Symplectic Euler map  p' = p - h Sin[q]; q' = q + h p'  has
       Jacobian determinant exactly 1; explicit Euler has 1 + h^2 Cos[q].
   (b) Long run (1e5 steps): symplectic energy error stays bounded
       (no growth between first and second half), explicit Euler drifts
       monotonically and ends far above the symplectic error band. *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

(* ---------- (a) symbolic Jacobians ---------- *)
sympMap = {q + h (p - h Sin[q]), p - h Sin[q]};   (* {q', p'} *)
explMap = {q + h p, p - h Sin[q]};
detS = Simplify[Det[D[sympMap, {{q, p}}]]];
detE = Simplify[Det[D[explMap, {{q, p}}]]];
Print["  det J (symplectic Euler) = ", detS];
Print["  det J (explicit Euler)   = ", detE];
check["symplectic Euler: det = 1 exactly (preserves dq ^ dp)", detS === 1];
check["explicit Euler: det = 1 + h^2 Cos[q]",
    Simplify[detE - (1 + h^2 Cos[q])] === 0];
check["explicit Euler: det != 1 generically", Simplify[detE == 1] =!= True];

(* ---------- (b) long-time energy behaviour ---------- *)
ham = Function[{qq, pp}, pp^2/2 - Cos[qq]];
hh = 0.01; n = 100000; q0 = 1.5; p0 = 0.;
h0 = ham[q0, p0];

(* symplectic Euler *)
qs = q0; ps = p0; maxdS = 0.; maxdSHalf = 0.;
Do[
    ps = ps - hh Sin[qs]; qs = qs + hh ps;
    d = Abs[ham[qs, ps] - h0];
    If[d > maxdS, maxdS = d];
    If[i == n/2, maxdSHalf = maxdS],
    {i, n}];

(* explicit Euler, energy error at checkpoints n/4, n/2, 3n/4, n *)
qe = q0; pe = p0; cps = {};
Do[
    dq = hh pe; pe = pe - hh Sin[qe]; qe = qe + dq;
    If[Mod[i, n/4] == 0, AppendTo[cps, Abs[ham[qe, pe] - h0]]],
    {i, n}];
dEfinal = Last[cps];

Print["  symplectic: max|dH| first half = ", maxdSHalf,
    ", whole run = ", maxdS];
Print["  explicit:   |dH| at t = {250, 500, 750, 1000}: ", cps];
check["symplectic: max|dH| small and bounded (< 0.05 over 1e5 steps)",
    maxdS < 0.05];
check["symplectic: no growth (max over run <= 1.5 x max over first half)",
    maxdS <= 1.5 maxdSHalf];
check["explicit: monotone energy drift at checkpoints",
    cps[[1]] < cps[[2]] < cps[[3]] < cps[[4]]];
check["explicit final |dH| exceeds symplectic max by factor > 50",
    dEfinal > 50 maxdS];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];

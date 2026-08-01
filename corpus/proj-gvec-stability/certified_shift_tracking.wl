ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[
  TrueQ[condition],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* Shift strategy for tracking the lowest family eigenvalue with the
   block factorization only: inertia bisection brackets lambda1, the
   inverse iteration runs at the bracket top, and an inertia window
   around the converged Rayleigh value certifies the result.  The
   pivot negative count of the factorization shifted by x counts the
   eigenvalues at or below x; for the three-eigenvalue model spectrum
   l1 < l2 < l3 that count is zero at x iff every li exceeds x, and
   at least one at x iff some li is at or below x -- written out as
   the inequality logic the checks quantify over. *)

countZero[x_] := l1 > x && l2 > x && l3 > x;
countSome[x_] := l1 <= x || l2 <= x || l3 <= x;
ordering = l1 < l2 && l2 < l3 && a < l1 && l1 <= b && b < l2;
prove[statement_] := TrueQ[Resolve[statement, Reals]];

(* Bisection invariant: starting from N(a) = 0, N(b) >= 1, either
   branch of the midpoint test keeps the invariant and halves the
   bracket. *)
check["bisection keeps the bracket invariant and halves the width",
  prove[ForAll[{l1, l2, l3, a, b},
    Implies[ordering && countZero[(a + b)/2],
      countSome[b] && b - (a + b)/2 == (b - a)/2]]]
  && prove[ForAll[{l1, l2, l3, a, b},
    Implies[ordering && countSome[(a + b)/2],
      countZero[a] && (a + b)/2 - a == (b - a)/2]]]];

(* Certificate: a converged Rayleigh value rq with an empty inertia
   window below and a populated one above pins lambda1 to within the
   window half-width, regardless of clustering above. *)
check["inertia window certifies the lowest eigenvalue",
  prove[ForAll[{l1, l2, l3, rq, t},
    Implies[l1 < l2 && l2 < l3 && t > 0
      && countZero[rq - t] && countSome[rq + t],
      Abs[rq - l1] <= t]]]];

(* Contraction: once the bracket is narrower than half the gap to the
   next eigenvalue, iterating at the bracket top contracts toward
   lambda1 (the spectral ratio is below one). *)
check["a narrow bracket makes the top-shift iteration contract",
  prove[ForAll[{l1, l2, l3, a, b},
    Implies[ordering && b - a < (l2 - l1)/2,
      (b - l1)/(l2 - b) < 1]]]];

(* The certificate refuses a converged value near a higher eigenvalue
   when the lowest lies below the window: the window below rq is then
   populated. *)
check["the certificate rejects convergence to a higher eigenvalue",
  prove[ForAll[{l1, l2, l3, rq, t},
    Implies[l1 < l2 && l2 < l3 && t > 0 && l1 < rq - t,
      ! countZero[rq - t]]]]];

Print["SUMMARY ", pass, " passed, ", fail, " failed"];
Quit[If[fail == 0, 0, 1]];

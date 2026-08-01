(* Slide 14: derivatives and Gauss-Newton. For residual r(x), Jacobian
   J = dr/dx and G = J^T J:
     - the Gauss-Newton step dx solves G dx = -J^T r and is exactly the
       minimizer of the linearized least squares |r + J dx|^2;
     - G equals the Hessian of f = (1/2)|r|^2 minus the second-order
       residual term Sum_i r_i Hess[r_i];
     - for linear residuals r = A x - b, one Gauss-Newton step from any
       start reaches the least-squares minimizer (one-step convergence). *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

(* ---------- concrete nonlinear (quadratic) residual, symbolic ---------- *)
vars = {x1, x2};
r = {x1 - 1, x2 - 2, x1 x2 - 3};
jac = D[r, {vars}];
g = Transpose[jac] . jac;
f = r . r/2;
hessF = D[f, {vars, 2}];
secondOrder = Sum[r[[i]] D[r[[i]], {vars, 2}], {i, Length[r]}];

check["G = Hess[(1/2)|r|^2] - Sum_i r_i Hess[r_i] (symbolic identity)",
    Simplify[hessF - secondOrder - g] === {{0, 0}, {0, 0}}];

dx = Simplify[-Inverse[g] . Transpose[jac] . r]; (* Gauss-Newton step *)
check["Gauss-Newton step satisfies G dx = -J^T r",
    Simplify[g . dx + Transpose[jac] . r] === {0, 0}];

(* minimizer of |r + J d|^2 over d = {d1, d2}: stationarity J^T (r + J d) = 0 *)
dvec = {d1, d2};
statSol = Solve[Thread[Transpose[jac] . (r + jac . dvec) == {0, 0}], dvec];
dstar = Simplify[dvec /. First[statSol]];
check["minimizer of linearized |r + J dx|^2 equals the Gauss-Newton step",
    Simplify[dstar - dx] === {0, 0}];
(* it is a minimum: G is positive definite at a generic point, e.g. (2, 2) *)
check["G positive definite at test point (2, 2) (stationary point is a min)",
    PositiveDefiniteMatrixQ[g /. {x1 -> 2, x2 -> 2}]];

(* ---------- linear residuals: one-step convergence, exact ---------- *)
a = {{1, 2}, {3, 4}, {5, 6}}; b = {1, 1, 1};
rLin[x_] := a . x - b;
gLin = Transpose[a] . a;
gnStep[x_] := x - Inverse[gLin] . Transpose[a] . rLin[x];
xls = Inverse[gLin] . Transpose[a] . b; (* normal-equations solution *)
x0 = {7, -5};
x1n = gnStep[x0];
check["linear residual: one GN step from x0 reaches least-squares solution",
    Simplify[x1n - xls] === {0, 0}];
check["least-squares solution matches PseudoInverse[A].b",
    Simplify[xls - PseudoInverse[a] . b] === {0, 0}];
check["gradient J^T r vanishes at the one-step result",
    Simplify[Transpose[a] . rLin[x1n]] === {0, 0}];
check["second GN step changes nothing (already converged)",
    Simplify[gnStep[x1n] - x1n] === {0, 0}];
(* one-step convergence from a second, symbolic start point *)
xsym = gnStep[{s1, s2}];
check["one GN step from symbolic start {s1, s2} also lands on x_ls",
    Simplify[xsym - xls] === {0, 0}];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];

Needs["DifferentialEquations`NDSolveProblems`"]; , Null, Needs["DifferentialEquations`NDSolveUtilities`"]; 

V[x_, y_] := x^2/2 + y^2/2 + x^2*y - y^3/3; , Null, H[x_, y_, px_, py_] := (1/2)*(px^2 + py^2) + V[x, y]; , Null, xdot[x_, y_, px_, py_] := D[H[x, y, px, py], px], Null, ydot[x_, y_, px_, py_] := D[H[x, y, px, py], py]; , Null, pxdot[x_, y_, px_, py_] := -D[H[x, y, px, py], x]; , Null, pydot[x_, y_, px_, py_] := -D[H[x, y, px, py], y]; 

Plot3D[V[x, y], {x, -1.5, 1.5}, {y, -1.5, 1.5}, PlotRange -> {-0.5, 0.5}], Null, ContourPlot[V[x, y], {x, -1.5, 1.5}, {y, -1.5, 1.5}, Contours -> 20, ColorFunctionScaling -> False, PlotRange -> {-0.5, 0.5}]

t0 := 0; , Null, t1 := 400; , Null, E0 := 1; , Null, s := NDSolve[{D[x[t], t] == xdot[x[t], y[t], px[t], py[t]], D[y[t], t] == ydot[x[t], y[t], px[t], py[t]], D[px[t], t] == pxdot[x[t], y[t], px[t], py[t]], D[py[t], t] == pydot[x[t], y[t], px[t], py[t]], x[0] == -0.1, y[0] == -0.2, px[0] == 0.25, py[0] == -0.05}, {x[t], y[t], px[t], py[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {x[t], y[t]}}, StartingStepSize -> 0.001, MaxSteps -> Infinity]; , Null, ParametricPlot[Evaluate[{x[t], px[t]} /. s], {t, 0, t1}], Null, ParametricPlot[Evaluate[{y[t], py[t]} /. s], {t, 0, t1}], Null, p3 = ContourPlot[V[x, y], {x, -0.5, 0.5}, {y, -0.5, 0.5}, Contours -> 20]; p4 = ParametricPlot[Evaluate[{x[t], y[t]} /. s], {t, 0, t1}]; , Null, Show[p3, p4]

(* UNCONVERTED CELL *)

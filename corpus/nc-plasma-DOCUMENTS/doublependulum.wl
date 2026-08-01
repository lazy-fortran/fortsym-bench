Needs["DifferentialEquations`NDSolveProblems`"]; , Null, Needs["DifferentialEquations`NDSolveUtilities`"]; 

Null

H = (1/2)*(Subscript[p, x][t]^2 + (Subscript[p, φ][t]/(1 + x[t]))^2) - g*(1 + x[t])*Cos[φ[t]] + (k/2)*x[t]^2 /. {g -> 5, k -> 50}; , Null, t0 = 0; , Null, t1 = 10; , Null, s = NDSolve[{D[φ[t], t] == D[H, Subscript[p, φ][t]], D[x[t], t] == D[H, Subscript[p, x][t]], D[Subscript[p, φ][t], t] == -D[H, φ[t]], D[Subscript[p, x][t], t] == -D[H, x[t]], φ[0] == Pi/2, x[0] == 0, Subscript[p, φ][0] == 0, Subscript[p, x][0] == 1}, {φ[t], x[t], Subscript[p, φ][t], Subscript[p, x][t]}, {t, t0, t1}, Method -> "ImplicitRungeKutta"]; , Null, ParametricPlot[Evaluate[{φ[t], Subscript[p, φ][t]} /. s], {t, 0, t1}, PlotRange -> {{-Pi, Pi}, Automatic}, AspectRatio -> 0.5], Null, ParametricPlot[Evaluate[{x[t], Subscript[p, x][t]} /. s], {t, 0, t1}, AspectRatio -> 0.5], Null

Null

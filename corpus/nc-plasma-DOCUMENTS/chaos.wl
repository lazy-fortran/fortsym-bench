Needs["DifferentialEquations`NDSolveProblems`"]; , Null, Needs["DifferentialEquations`NDSolveUtilities`"]; 

H[φ[t], p[t]] := p[t]^2 - Cos[φ[t]], Null, t0 = 0; , Null, t1 = 5; 

sco = Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t]], p[t]], D[p[t], t] == -D[H[φ[t], p[t]], φ[t]], φ[0] == -Pi, p[0] == 0.2*k}, {φ[t], p[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {φ[t]}}, StartingStepSize -> 0.1, MaxSteps -> Infinity], {k, 1, 15}]; , Null, sct = Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t]], p[t]], D[p[t], t] == -D[H[φ[t], p[t]], φ[t]], φ[0] == Pi, p[0] == -0.2*k}, {φ[t], p[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {φ[t]}}, StartingStepSize -> 0.1, MaxSteps -> Infinity], {k, 1, 15}]; , Null, str = Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t]], p[t]], D[p[t], t] == -D[H[φ[t], p[t]], φ[t]], φ[0] == 0, p[0] == 0.14*k}, {φ[t], p[t]}, {t, t0, t1}, Method -> {"SymplecticPartitionedRungeKutta", "DifferenceOrder" -> 2, "PositionVariables" -> {φ[t]}}, StartingStepSize -> 0.1, MaxSteps -> Infinity], {k, -10, 10}]; , Null, plt = Show[ParametricPlot[Evaluate[{φ[t], p[t]} /. sco], {t, 0, t1}, PlotRange -> {{-Pi, Pi}, {-Pi, Pi}}], ParametricPlot[Evaluate[{φ[t], p[t]} /. sct], {t, 0, t1}, PlotRange -> {{-Pi, Pi}, {-Pi, Pi}}], ParametricPlot[Evaluate[{φ[t], p[t]} /. str], {t, 0, t1}, PlotRange -> {{-Pi, Pi}, {-Pi, Pi}}]]

Null

Null

K[q, p] := p^2/2 - Cos[q] + a*Cos[q]^2, Null, qdot = D[K[q, p], p]; pdot = -D[K[q, p], q]; , Null, Manipulate[StreamPlot[{qdot, pdot} /. a -> a0, {q, -Pi, Pi}, {p, -4, 4}], {a0, 0, 0.1}]

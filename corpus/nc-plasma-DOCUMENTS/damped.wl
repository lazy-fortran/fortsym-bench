Needs["DifferentialEquations`NDSolveProblems`"]; , Null, Needs["DifferentialEquations`NDSolveUtilities`"]; 

lam = 0.5; , Null, H[φ[t], p[t], t] := p[t]^2*Exp[(-lam)*t] + φ[t]^2*Exp[lam*t], Null, t0 = 0; , Null, t1 = 3; 

sco = Table[NDSolve[{D[φ[t], t] == D[H[φ[t], p[t], t], p[t]], D[p[t], t] == -D[H[φ[t], p[t], t], φ[t]], φ[0] == 0.3*k, p[0] == 0}, {φ[t], p[t]}, {t, t0, t1}], {k, 1, 10}]; , Null, ParametricPlot[Evaluate[{φ[t], p[t]} /. sco], {t, 0, t1}, PlotRange -> {{-Pi, Pi}, {-Pi, Pi}}]

Null

Null

Null

K[q, p] := (-a/2)*q*p - Log[p*q] + Log[q], Null, qdot = D[K[q, p], p]; pdot = -D[K[q, p], q]; , Null, Manipulate[StreamPlot[{qdot, pdot} /. a -> a0, {q, -Pi, Pi}, {p, -10, 10}], {a0, 0, 1}]

FullSimplify[Solve[(p - (k/2)*p^2)*Exp[(-k)*t] == xd, p], Reals]

Limit[(1 + E^(k*t)*Sqrt[(1 - 2*E^(k*t)*k*xd)/E^(2*k*t)])/k, k -> 0]

FullSimplify[Series[(1 + E^(k*t)*Sqrt[(1 - 2*E^(k*t)*k*xd)/E^(2*k*t)])/k, {k, 0, 2}], Reals]

FullSimplify[Series[(1 + Sqrt[1 - 2*E^(k*t)*k*xd])/k, {k, Infinity, 1}, {xd, (p - (k/2)*p^2)*Exp[(-k)*t], 1}], Reals]

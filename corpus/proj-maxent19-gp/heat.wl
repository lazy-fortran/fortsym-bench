Null

X = -Sin[(Pi/2)*(1 - x)]; , Null, u = X*T[t]; , Null, sol = Flatten[DSolve[D[u, t] == D[u, x, x], T[t], t]], Null, usol = u /. sol /. C[1] -> 1, Null, Plot[{usol /. x -> 0, usol /. x -> 0.5, usol /. x -> 1}, {t, 0, 1}, PlotLabel -> "x fixed", AxesLabel -> {t, "u"}], Null, Plot[{usol /. t -> 0, usol /. t -> 0.5, usol /. t -> 1}, {x, 0, 1}, PlotLabel -> "t fixed", AxesLabel -> {x, "u"}], Null, Plot3D[usol, {x, 0, 1}, {t, 0, 1}, PlotLabel -> "u(x,t)", AxesLabel -> {"x", "t"}]

X = Sum[Cos[(2*k + 1)*Pi*(x/2)], {k, 0, Infinity}]; , Null, u = X*T[t]; , Null, sol = Flatten[DSolve[D[u, t] == D[u, x, x], T[t], t]], Null, usol = u /. sol /. C[1] -> 1, Null, ul = usol /. x -> 0, Null, Solve[ul == HeavisideTheta[t], a[k]]

Solve

G[x_, t_, xk_, tk_] := (1/Sqrt[4*Pi*(t - tk)])*Exp[-((x - xk)^2/(4*(t - tk)))]

k1fin = Simplify[Integrate[G[x0, t0, xi, 0]*G[x1, t1, xi, 0], {xi, -xmax, xa}]]

k1 = Simplify[(Erf[((-t1)*x0 - t0*x1 + (t0 + t1)*xa)/(2*Sqrt[t0]*Sqrt[t1]*Sqrt[t0 + t1])] + 1)/(E^((x0 - x1)^2/(4*(t0 + t1)))*(4*Sqrt[Pi]*Sqrt[t0 + t1]))]

k1 /. xa -> 0

k2fin = Simplify[Integrate[G[x0, t0, xi, 0]*G[x1, t1, xi, 0], {xi, xb, xmax}]]

k2 = Simplify[(-Erf[((-t1)*x0 - t0*x1 + (t0 + t1)*xb)/(2*Sqrt[t0]*Sqrt[t1]*Sqrt[t0 + t1])] + 1)/(E^((x0 - x1)^2/(4*(t0 + t1)))*(4*Sqrt[Pi]*Sqrt[t0 + t1]))]

k0a = Simplify[k1 + k2]

k0 = k0a /. {xa -> 0, xb -> 1}

k3fin = Simplify[Integrate[G[x0, t0, k, 0]*G[x1, t1, k, 0], {k, -kmax, kmax}]]

k3 = Simplify[(1 + 1)/(E^((x0 - x1)^2/(4*(t0 + t1)))*(4*Sqrt[Pi]*Sqrt[t0 + t1]))]

Plot[k0 /. {x0 -> 1, t0 -> 1, x1 -> 0}, {t1, 1, 2}, PlotLabel -> "x fixed", AxesLabel -> {t, "u"}]

Plot[k0 /. {x0 -> {0, 0.2, 1}, t0 -> 1, t1 -> 1}, {x1, 0, 1}, PlotLabel -> "t fixed", AxesLabel -> {x, "u"}]

ContourPlot[k0 /. {x0 -> 1, x1 -> 1}, {t0, 0, 2}, {t1, 0, 2}, PlotLabel -> "x fixed", AxesLabel -> {t0, t1}, PlotLegends -> Automatic]

ContourPlot[k0 /. {t0 -> 1, t1 -> 1}, {x0, 0, 1}, {x1, 0, 1}, PlotLabel -> "t fixed", AxesLabel -> {x0, x1}, PlotLegends -> Automatic]

Simplify[D[k3, x0, x0] - D[k3, t0]], Null, Simplify[D[k0, x0, x0] - D[k0, t0]]

k4fin = Simplify[Integrate[G[x0, t0, k, l]*G[x1, t1, k, l], {k, -kmax, kmax}]]

Simplify[D[k0, t0, t1] /. {t0 -> D*t0, t1 -> D*t1}]

Simplify[k0 /. {t0 -> D*t0, t1 -> D*t1}, Assumptions -> {D > 0, t0 > 0, t1 > 0}]

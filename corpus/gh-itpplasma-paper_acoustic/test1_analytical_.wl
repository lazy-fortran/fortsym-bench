rho = 1.*10^3, Null, K = 2.25*10^9, Null, c = Sqrt[K/rho]

R[x_, y_] := Sqrt[x^2 + y^2], Null, G[x_, y_, t_, xpr_, ypr_, tpr_] := (1/(2*Pi))*(HeavisideTheta[(t - tpr) - R[x - xpr, y - ypr]/c]/Sqrt[(t - tpr)^2 - R[x - xpr, y - ypr]^2/c^2])

x0 = (120*0.05)/10^3, Null, y0 = (200*0.05)/10^3, Null, x1 = (120*0.05)/10^3, Null, y1 = y0 + 3/10^3

t0 = 1.5/10^6, Null, q[t_] := Exp[-(t - t0)^2/((0.3*1.5)/10^6)^2]

Table[(t1 - t0) - R[x1 - x0, y1 - y0]/c, {t1, t0, t0 + 10/10^6, 10^(-6)}], Null, Vals = Table[NIntegrate[G[x1, y1, t1, x0, y0, t]*q[t], {t, t0, t1}], {t1, 0, 10/10^6, 10^(-6)}]

ListPlot[Vals]

Null

Null

t1 = 6/10^6, Null, Integrate[G[x1, y1, t1, x0, y0, t]*q[t], {t, a, b}], Null, Plot[q[t], {t, 0, 10^(-5)}], Null, ContourPlot[G[x1, y1, t1, x0, y0, t], {t, 0, 10^(-5)}, {t1, 0, 10^(-5)}], Null, ContourPlot[G[x1, y1, t1, x0, y0, t]*q[t], {t, 0, 10^(-5)}, {t1, 0, 10^(-5)}]

Null

Plot[G[x0, y0, t, x1, y1, t0], {t, 0, 10/10^6}]

Null

G0[x_, y_, t_, xpr_, ypr_, tpr_] := HeavisideTheta[(t - tpr) - R[x - xpr, y - ypr]]/Sqrt[(t - tpr)^2 - R[x - xpr, y - ypr]^2]

Manipulate[Plot3D[G0[x, y, t, 96, 0, 96], {x, 92, 100}, {y, -4, 4}], {t, 96, 104}]

Integrate[D[a[t], t]/a[t], t]

o

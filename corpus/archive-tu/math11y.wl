Clear[x, y, a], Null, DSolve[Derivative[1][y][x] == a*y[x], y[x], x]

{{y[x] -> E^(a*x)*C[1]}}

DSolve[Derivative[1][Derivative[1][y]][x] + k^2*y[x] == 0, y[x], x]

DSolve[Derivative[1][Derivative[1][Derivative[1][Derivative[1][y]]]][x] + k^4*y[x] == 0, y[x], x]

DSolve[Derivative[1][Derivative[1][y]][x] + Derivative[1][y][x]/x + (1 - n^2/x^2)*y[x] == 0, y[x], x]

DSolve[Derivative[1][Derivative[1][y]][x] + Derivative[1][y][x]/x + (1 - 4/x^2)*y[x] == 0, y[x], x]

ExpandAll[DSolve[Derivative[1][Derivative[1][y]][x] + 2*(Derivative[1][y][x]/x) + (1 - n*((n + 1)/x^2))*y[x] == 0, y[x], x]]

so = DSolve[Derivative[1][Derivative[1][Derivative[1][Derivative[1][y]]]][x] + 3*Derivative[1][Derivative[1][Derivative[1][y]]][x] + k^4*y[x] == 0, y[x], x]

(* UNCONVERTED CELL *)

(* UNCONVERTED CELL *)

DSolve[{Derivative[1][y][x] == a*y[x], y[0] == y0}, y[x], x]

DSolve[{Derivative[1][y][x] - a*y[x] == d*Exp[c*x], y[0] == y0}, y[x], x]

Flatten[DSolve[{x[0] == 3, Derivative[1][x][0] == 0, Derivative[1][Derivative[1][x]][t] + Derivative[1][x][t] - x[t] == 6}, x[t], t]]

Flatten[DSolve[{x[0] == 3, x[5] == 9, Derivative[1][Derivative[1][x]][t] + Derivative[1][x][t] - x[t] == 6}, x[t], t]]

Clear[x, y, f]; so = Flatten[DSolve[{Derivative[1][y][x] == 2*y[x], y[0] == 3}, y[x], x]]

g = y[x] /. so

Plot[g, {x, 0, 4}, AxesLabel -> {"x", "y[x] = 3 \!\(\*SuperscriptBox[\(\), \(2 x\)]\)"}, ImageSize -> 200]

tso = Table[Flatten[{x, g}], {x, 0, 4, 0.5}]

TableForm[{"x   y(x)"}], Null, TableForm[tso]

Clear[x, y, f]; , Null, f = Flatten[DSolve[{Derivative[1][y][x] == 2*y[x], y[0] == 3}, y[x], x]]

y[x] + 2*Derivative[1][y][x] + y[0] /. f

Clear[x, y, f]; , Null, f = Flatten[DSolve[{Derivative[1][y][x] == a*y[x]}, y, x]]

y[x] + 2*Derivative[1][y][x] + y[0] /. f

Clear[x, y, h]; , Null, h = Flatten[DSolve[{Derivative[1][y][x] == 2*y[x], y[0] == 3}, y, x]]

y[x] + 2*Derivative[1][y][x] + y[0] /. h

g = f /. {a -> 2, C[1] -> 3}

Plot[y[x] /. g, {x, 0, 4}, AxesLabel -> {"x", "y[x] = 3 \!\(\*SuperscriptBox[\(\), \(2 x\)]\)"}, ImageSize -> 200]; 

Clear[y, x], Null, syseqn = {Derivative[1][Derivative[1][y]][x] + k^2*y[x] == 0}

DSolve[syseqn, y[x], x]

Clear[y, x, f, g], Null, syseqn = {Derivative[1][Derivative[1][y]][x] + k^2*y[x] == 0, y[0] == 0, Derivative[1][y][0] == 1}

so = Flatten[DSolve[syseqn, y[x], x]]

su = Flatten[DSolve[syseqn, y, x]]

ExpandAll[su]

g = y[x] /. su

Clear[x, y, f, g]; , Null, sy = {Derivative[1][x][t] - y[t] == t, Derivative[1][y][t] - 4*x[t] == -2}

Flatten[DSolve[sy, {x[t], y[t]}, t]]

Clear[x, y, f, g]; , Null, sy = {Derivative[1][x][t] - y[t] == t, Derivative[1][y][t] - 4*x[t] == -2, x[0] == 1, y[0] == 1}

DSolve[sy, {x[t], y[t]}, t]

DSolve[sy, {x, y}, t]

Clear[m, r, v, a, B0, E0], Null, Efield = {0, E0, 0}; Bfield = {0, 0, B0}; , Null, r = {x[t], y[t], z[t]}; v = D[r, t]; a = D[v, t]; 

Force = q*Efield + q*Cross[v, Bfield]

eq = Table[Force[[i]] == m*a[[i]], {i, 3}]

(id = {x[0] == 0, Derivative[1][x][0] == vx, y[0] == 0, Derivative[1][y][0] == vy, z[0] == 0, Derivative[1][z][0] == vz}; )*(Soln = Flatten[DSolve[Union[eq, id], {x, y, z}, t]]; TableForm[Soln])

Simplify[eq /. Soln]

Simplify[{x[0], y[0], z[0]} /. Soln]

Simplify[{Derivative[1][x][0], Derivative[1][y][0], Derivative[1][z][0]} /. Soln]

X[t_] := Expand[x[t] /. Soln], Null, Y[t_] := Expand[y[t] /. Soln], Null, Z[t_] := Expand[z[t] /. Soln]

rs = {X[t], Y[t], Z[t]} /. {m -> q*(B0/ω), E0 -> vd*B0}; , Null, TableForm[rs], Null

rf1 = rs /. {ω -> 1, vd -> 0.04, vx -> 0.05, vy -> 0.033, vz -> 0.03}; TableForm[rf]

pleb1 = ParametricPlot3D[Evaluate[rf1], {t, 0, 20}, Boxed -> False, AxesLabel -> {"x", "y", "z"}, DisplayFunction -> Identity, BoxRatios -> {1, 1, 1}, ViewPoint -> {-1.01, -2.4, 2.}]; 

rf2 = rs /. {ω -> 1, vd -> 0.02, vx -> 0.05, vy -> 0.06, vz -> 0.03}; pleb2 = ParametricPlot3D[Evaluate[rf2], {t, 0, 20}, Boxed -> False, AxesLabel -> {"x", "y", "z"}, DisplayFunction -> Identity, BoxRatios -> {1, 1, 1}, ViewPoint -> {-1.01, -2.4, 2.}]; 

Show[GraphicsRow[{pleb1, pleb2}]]

Clear[m, w, x, z, y], Null, oldeq = Derivative[1][Derivative[1][y]][x] + Derivative[1][y][x]/x + y[x]*(1 - m^2/x^2)

Length[oldeq]

FullForm[oldeq]

cold = Table[Coefficient[oldeq, Derivative[k][y][x]], {k, 0, 2}]

neweq = Expand[Sum[D[z[x]*w[x], {x, k}]*cold[[k + 1]], {k, 0, 2}]]

cnew = Table[Coefficient[neweq, Derivative[k][z][x]], {k, 0, 2}]

fneweq = Sum[D[z[x], {x, k}]*cnew[[k + 1]], {k, 0, 2}]

heq = cnew[[2]] == 0

s1 = Flatten[DSolve[heq, w, x]]

fnew = fneweq /. s1

normf = Coefficient[fnew, Derivative[2][z][x]]

fnew = Expand[fnew/normf]

fdeq = Collect[fnew, z[x]/x^2] == 0

Clear[y, x]; xmin = 0.; xmax = 6; , Null, s = Flatten[NDSolve[{Derivative[1][Derivative[1][y]][x] == -y[x], y[0] == 0, Derivative[1][y][0] == 1}, y, {x, xmin, xmax}]]

y[2] /. s, Null, Derivative[1][y][2] /. s, Null, Derivative[1][Derivative[1][y]][2] /. s

np = 5; xk := k*((xmax - xmin)/np); , Null, ts = Chop[Table[{k, N[xk], y[xk] /. s, Derivative[1][y][xk] /. s}, {k, 0, np}]]; 

TableForm["k x   y(x)       y'(x)  "], Null, TableForm[ts]

py = Plot[Evaluate[y[x] /. s], {x, xmin, xmax}, AxesLabel -> {x, y[x]}]; 

dpy = Plot[Evaluate[Derivative[1][y][x] /. s], {x, xmin, xmax}, AxesLabel -> {x, Derivative[1][y][x]}]; 

Show[GraphicsRow[{py, dpy}]]

Clear[sol]; , Null, sol[t_] = First[x[t] /. NDSolve[{Derivative[2][x][t] == Sqrt[x[t]]*Derivative[1][x][t] + 1, x[1] == 7, Derivative[1][x][1] == -1}, {x[t]}, {t, 1, 2}, MaxSteps -> 10^4]]

sol[1.5]

Plot[sol[t], {t, 1, 2}, ImageSize -> 250]

Clear[x, y, z, r, v, b], Null, r[t_] = {x[t], y[t]}; , Null, v[t_] = D[r[t], t]; , Null, b[t_] = D[v[t], t]; , Null, m = 1; g = 10; a = 0.3; , Null, sys = Thread[m*b[t] == {0, (-m)*g}]

sysa = Thread[m*b[t] == {0, (-m)*g} - a*v[t]*Sqrt[v[t] . v[t]]]

anf = {x[0] == 0, y[0] == 0, Derivative[1][x][0] == 2, Derivative[1][y][0] == 10}; 

sol = Flatten[NDSolve[Join[sys, anf], {x, y}, {t, 0, 4}]]; 

sola = Flatten[NDSolve[Join[sysa, anf], {x, y}, {t, 0, 2}]]; 

p = ParametricPlot[Evaluate[{x[t], y[t]} /. sol], {t, 0, 4}]; , Null, pa = ParametricPlot[Evaluate[{x[t], y[t]} /. sola], {t, 0, 2}, PlotStyle -> Dashing[{0.01}]]; 

Show[p, pa, AxesLabel -> {"x", "y"}, AspectRatio -> 0.4]

te = t /. FindRoot[Evaluate[y[t] /. sol] == 0., {t, 2, 4}]*ta = t /. FindRoot[Evaluate[y[t] /. sola] == 0., {t, 1, 2}]

p = ParametricPlot[Evaluate[{x[t], y[t]} /. sol], {t, 0, te}]; , Null, pa = ParametricPlot[Evaluate[{x[t], y[t]} /. sola], {t, 0, ta}, PlotStyle -> Dashing[{0.01}]]; 

Show[p, pa, AxesLabel -> {"x", "y"}, AspectRatio -> Automatic, ImageSize -> 200]

sy = {-Derivative[1][y][t] + Derivative[1][Derivative[1][x]][t] == 0, Derivative[1][x][t] + Derivative[1][Derivative[1][y]][t] == 0, Derivative[1][Derivative[1][z]][t] == 0, x[0] == 0, y[0] == 0, z[0] == 0, Derivative[1][x][0] == 2, Derivative[1][y][0] == 0, Derivative[1][z][0] == 1/3}

tmax = 11; , Null, sosy = NDSolve[sy, {x, y, z}, {t, 0, tmax}]

ParametricPlot3D[Evaluate[{x[t], y[t], z[t]} /. sosy], {t, 0, tmax}, BoxRatios -> {1, 1, 1.5}, AxesLabel -> {"x", "y", "z"}, ImageSize -> 200]

Information["NDSolve", LongForm -> True]

sy = {-Derivative[1][y][t] + Derivative[1][Derivative[1][x]][t] == 0, Derivative[1][x][t] + Derivative[1][Derivative[1][y]][t] == 0, Derivative[1][Derivative[1][z]][t] == 0, x[0] == 0, y[0] == 0, z[0] == 0, Derivative[1][x][0] == 1, Derivative[1][y][0] == 0, Derivative[1][z][0] == 1/3}; 

NDSolve[sy, {x, y, z}, {t, 0, 2000}]

NDSolve[sy, {x, y, z}, {t, 0, 2000}, MaxSteps -> 20000]

Information["AccuracyGoal", LongForm -> True]

Information["PrecisionGoal", LongForm -> True]

Information["WorkingPrecision", LongForm -> True]

Information["StartingStepSize", LongForm -> True]

Clear[t, r, x, y, vx, vy, sys, en, tmax, force], Null, r[t_] = {x[t], y[t]}; v[t_] = {vx[t], vy[t]}; , Null, force = {-x[t] - 2*x[t]*y[t], -y[t] + y[t]^2 - x[t]^2}; , Null, sys = Thread[D[Join[r[t], v[t]], t] == Join[v[t], force]]

en = (vx[t]^2 + vy[t]^2)/2 + (x[t]^2 + y[t]^2)/2 + x[t]^2*y[t] - y[t]^3/3; 

ad = {x[0], y[0], vx[0], vy[0]}; 

anf = {0, 0.1, 0.15, 0.55}; tmax = 15.; 

sol = Flatten[NDSolve[Join[sys, Thread[ad == anf]], {x, y, vx, vy}, {t, 0, tmax}]]; 

eni = en /. sol /. t -> 0

enf = en /. sol /. t -> tmax

(enf - eni)/eni

Flatten[{x[tmax], y[tmax], vx[tmax], vy[tmax]} /. sol]

anfr = %*{1, 1, -1, -1}

sor = Flatten[NDSolve[Join[sys, Thread[ad == anfr]], {x, y, vx, vy}, {t, 0, tmax}]]; 

Flatten[{x[tmax], y[tmax], vx[tmax], vy[tmax]} /. sor]

anf

p1 = ParametricPlot[Evaluate[r[t] /. sol], {t, 0, tmax}, AxesLabel -> {"x", "y"}, PlotLabel -> "First run", AspectRatio -> 1]; , Null, p2 = ParametricPlot[Evaluate[r[t] /. sor], {t, 0, tmax}, AxesLabel -> {"x", "y"}, PlotLabel -> "Return run", AspectRatio -> 1]; , Null, Show[GraphicsRow[{p1, p2}]]

tmax = 150.; 

{time, sol0} = Timing[Flatten[NDSolve[Join[sys, Thread[ad == anf]], {x, y, vx, vy}, {t, 0, tmax}, MaxSteps -> 5000]]]

g0x = Plot[Evaluate[x[t] /. sol0], {t, 0, tmax}, AxesLabel -> {"t", "x[t]"}, PlotStyle -> {{Thickness[0.001], Dashing[{0.01}]}}, PlotPoints -> 500]; , Null, g0y = Plot[Evaluate[y[t] /. sol0], {t, 0, tmax}, AxesLabel -> {"t", "y[t]"}, PlotStyle -> {{Thickness[0.001], Dashing[{0.01}]}}, PlotPoints -> 500]; 

{x[tmax], y[tmax], vx[tmax], vy[tmax]} /. sol0

anfr = %*{1, 1, -1, -1}

{time, sor0} = Timing[Flatten[NDSolve[Join[sys, Thread[ad == anfr]], {x, y, vx, vy}, {t, 0, tmax}, MaxSteps -> 5000]]]

{x[tmax], y[tmax], vx[tmax], vy[tmax]} /. sor0

anf

eni = en /. sol0 /. t -> 0

enr = en /. sor0 /. t -> tmax

{time, sol1} = Timing[Flatten[NDSolve[Join[sys, Thread[ad == anf]], {x, y, vx, vy}, {t, 0, tmax}, AccuracyGoal -> 20, WorkingPrecision -> 25, PrecisionGoal -> 20, MaxSteps -> 400000]]]

g1x = Plot[Evaluate[x[t] /. sol1], {t, 0, tmax}, AxesLabel -> {"t", "x[t]"}, PlotStyle -> Thickness[0.001], PlotPoints -> 500, DisplayFunction -> Identity]; g1y = Plot[Evaluate[y[t] /. sol1], {t, 0, tmax}, AxesLabel -> {"t", "y[t]"}, PlotStyle -> Thickness[0.001], PlotPoints -> 500, DisplayFunction -> Identity]; 

SetPrecision[{x[tmax], y[tmax], vx[tmax], vy[tmax]} /. sol1, 30]

anfr = %*{1, 1, -1, -1}

{time, sor1} = Timing[Flatten[NDSolve[Join[sys, Thread[ad == anfr]], {x, y, vx, vy}, {t, 0, tmax}, AccuracyGoal -> 20, WorkingPrecision -> 25, PrecisionGoal -> 20, MaxSteps -> 400000]]]

{x[tmax], y[tmax], vx[tmax], vy[tmax]} /. sor1

anf

eni = en /. sol1 /. t -> 0

enr = en /. sor1 /. t -> tmax

g1x = Plot[Evaluate[x[t] /. sol1], {t, 0, tmax}, AxesLabel -> {"t", "x[t]"}, PlotStyle -> {Thickness[0.001], Black}, PlotPoints -> 500]; g1y = Plot[Evaluate[y[t] /. sol1], {t, 0, tmax}, AxesLabel -> {"t", "y[t]"}, PlotStyle -> Thickness[0.001], PlotPoints -> 500]; 

Show[g0x, g1x, ImageSize -> 600, PlotLabel -> "__  high precision,   --- default precision"]

Show[g0y, g1y, ImageSize -> 600, PlotLabel -> "__  high precision,   --- default precision"]

sys = Derivative[1][y][t] == y[t] - t^2; DSolve[sys, y[t], t]

anf1 = y[0] == 2; so1 = DSolve[{sys, anf1}, y[t], t]

anf2 = y[0] == 2.00001; so2 = DSolve[{sys, anf2}, y[t], t]

tmax = 17.5; dino = DisplayFunction -> Identity; , Null, p1 = Plot[Evaluate[y[t] /. so1], {t, 0, tmax}, Evaluate[dino], PlotStyle -> {{RGBColor[0.9, 0, 0], Dashing[{0.02}]}}], Null, p2 = Plot[Evaluate[y[t] /. so2], {t, 0, tmax}, Evaluate[dino], PlotStyle -> {{RGBColor[0, 0.7, 0], Dashing[{0.05}]}}], Null, Show[p1, p2, PlotRange -> All], Null, no1 = Flatten[NDSolve[{sys, anf1}, y, {t, 0, tmax}]]; , Null, no2 = Flatten[NDSolve[{sys, anf2}, y, {t, 0, tmax}]]; , Null, pn1 = Plot[Evaluate[y[t] /. no1], {t, 0, tmax}, PlotStyle -> RGBColor[0.9, 0, 0]]; , Null, pn2 = Plot[Evaluate[y[t] /. no2], {t, 0, tmax}, PlotStyle -> RGBColor[0, 0.7, 0]]; , Null, Show[pn1, p1, PlotRange -> All], Null, Show[pn2, p2, PlotRange -> All]

Show[p1, pn1, pn2, p2, PlotRange -> All, AxesLabel -> {"t", "y(t)"}, BaseStyle -> {FontSize -> 10}, PlotLabel -> Row[{"Red = sol1,  Green = sol2,  Dashed = numeric\n\n"}]]

deq = Derivative[1][Derivative[1][x]][t] + 0.3*Derivative[1][x][t] + 5*x[t]; tmin = 0; tmax = 20; , Null, dosc = NDSolve[{deq == 0, x[0] == 0, Derivative[1][x][0] == 1}, x, {t, tmin, tmax}]

ParametricPlot[Evaluate[{x[t], Derivative[1][x][t]} /. dosc], {t, tmin, tmax}, PlotRange -> {{-0.45, 0.45}, {-1, 1}}, AxesLabel -> {x, Derivative[1][x]}, Ticks -> None]

deq = Derivative[1][Derivative[1][p]][t] + Derivative[1][p][t] + 5*Sin[p[t]]; tmin = 0; tmax = 6; , Null, dap = NDSolve[{deq == 0, p[0] == 0, Derivative[1][p][0] == 8}, p, {t, tmin, tmax}]; 

dapp = Plot[Evaluate[p[t] /. dap], {t, tmin, tmax}, AxesLabel -> {t, "ϕ(t)"}, PlotRange -> {0, 8}, Ticks -> {{1, 2, 3, 4, 5, 6}, {0, Pi, 2*Pi}}, PlotLabel -> "Damped Pendulum"]; , Null, dappp = Plot[Evaluate[Derivative[1][p][t] /. dap], {t, tmin, tmax}, AxesLabel -> {t, "ϕ'(t)"}, PlotRange -> {-2, 8}, Ticks -> {{1, 2, 3, 4, 5, 6}, {1, 2, 3, 4, 5, 6, 7, 8}}, PlotLabel -> "Damped Pendulum"]; 

Show[GraphicsRow[{dapp, dappp}], ImageSize -> 550]

plc = ParametricPlot[Evaluate[{p[t], Derivative[1][p][t]} /. dap], {t, tmin, tmax}, AxesLabel -> {"ϕ", "ϕ'"}, Ticks -> {{0, Pi, 2*Pi}, {-2, 0, 2, 4, 6, 8}}, PlotStyle -> {GrayLevel[0], Thickness[0.004]}, PlotRange -> {{0, 8}, {-2, 8}}]

np = 5; tk := (k*(tmax - tmin))/np; Print[{"k", " time", "      ϕ  ", "   ϕ'      "}]*Do[Print[Column[{{k, N[tk + 0.001], Evaluate[{p[tk], Derivative[1][p][tk]} /. dap]}}, Center]], {k, 0, np}]

np = 20; tk := k*((tmax - tmin)/np); lp = Table[Flatten[Evaluate[{p[tk], Derivative[1][p][tk]} /. dap]], {k, 0, np}]; 

plp = ListPlot[lp, Ticks -> {{0, Pi, 2*Pi}, {-2, 0, 2, 4, 6, 8}}]; 

plt = Show[plc, plp, Prolog -> PointSize[0.01], PlotRegion -> {{0.01, 0.99}, {0.01, 0.99}}]; Show[GraphicsRow[{plp, plt}], ImageSize -> 550]

v[x_, y_] = (x^2 + y^2)/2 + x^2*y - y^3/3; 

plv = Plot3D[v[x, y], {x, -1.2, 1.2}, {y, -1., 1.05}, PlotPoints -> 30, PlotRange -> {0, 0.2}, AxesLabel -> {"x", "y", "   V(x,z)"}, ViewPoint -> {1, -0.6, 1}, Ticks -> {Automatic, Automatic, {0., 0.1, 0.2}}]; , Null, plc = ContourPlot[v[x, y], {x, -1.2, 1.2}, {y, -1.2, 1.05}, ColorFunction -> Hue]; 

Show[GraphicsRow[{plv, plc}], ImageSize -> 500]

r[t_] = {x[t], y[t]}; v[t_] = {vx[t], vy[t]}; , Null, force = {-x[t] - 2*x[t]*y[t], -y[t] + y[t]^2 - x[t]^2}; , Null, sys = Thread[D[Join[r[t], v[t]], t] == Join[v[t], force]]

en = (vx[t]^2 + vy[t]^2)/2 + (x[t]^2 + y[t]^2)/2 + x[t]^2*y[t] - y[t]^3/3; 

x0 = 0.; y0 = 0.01; vx0 = 0.141; vy0 = 0.; tmax = N[251*Pi]

eno = en /. {x[t] -> x0, y[t] -> y0, vx[t] -> vx0, vy[t] -> vy0}

anf = {x[0] == x0, y[0] == y0, vx[0] == vx0, vy[0] == vy0}

solo = Flatten[NDSolve[Join[sys, anf], {x, y, vx, vy}, {t, 0, tmax}, MaxSteps -> 6500]]

ParametricPlot[Evaluate[r[t] /. solo], {t, 0, 6.5}, AxesLabel -> {"x", "y"}, AspectRatio -> Automatic, PlotStyle -> {AbsoluteThickness[0.2], GrayLevel[0]}, ImageSize -> 500]

ParametricPlot[Evaluate[r[t] /. solo], {t, 0, 75.}, AxesLabel -> {"x", "y"}, AspectRatio -> Automatic, PlotStyle -> {AbsoluteThickness[0.2], GrayLevel[0]}, ImageSize -> 500]

ParametricPlot[Evaluate[r[t] /. solo], {t, 0, tmax}, AxesLabel -> {"x", "y"}, AspectRatio -> Automatic, PlotStyle -> AbsoluteThickness[0.1], PlotPoints -> 3000, ImageSize -> 500]

Plot[Evaluate[x[t] /. solo], {t, 0, 150.}, PlotPoints -> 2500, PlotStyle -> Thickness[0.001], AxesLabel -> {"t", "x"}]

Plot[Evaluate[y[t] /. solo], {t, 0, 150.}, PlotPoints -> 2500, PlotStyle -> Thickness[0.001], AxesLabel -> {"t", "y"}]

Plot[Evaluate[x[t] /. solo], {t, 0, tmax}, PlotPoints -> 3500, PlotStyle -> {Thickness[0.001], GrayLevel[0]}, ImageSize -> 500, AxesLabel -> {"t", "x"}]

Plot[Evaluate[y[t] /. solo], {t, 0, tmax}, PlotPoints -> 3500, PlotStyle -> {Thickness[0.001], GrayLevel[0]}, ImageSize -> 500, AxesLabel -> {"t", "y"}]

x0 = 0.; y0 = 0.1; vx0 = 0.15; vy0 = 0.54; , Null, anf = {x[0] == x0, y[0] == y0, vx[0] == vx0, vy[0] == vy0}

enc = en /. {x[t] -> x0, y[t] -> y0, vx[t] -> vx0, vy[t] -> vy0}

solc = Flatten[NDSolve[Join[sys, anf], {x, y, vx, vy}, {t, 0, tmax}, AccuracyGoal -> 15, WorkingPrecision -> 20, PrecisionGoal -> 15, MaxSteps -> 26250]]

ParametricPlot[Evaluate[{x[t], y[t]} /. solc], {t, 0, 150.}, AxesLabel -> {x, y}, PlotStyle -> Thickness[0.001], AspectRatio -> Automatic]

ParametricPlot[Evaluate[{x[t], y[t]} /. solc], {t, 0, tmax}, AxesLabel -> {x, y}, PlotStyle -> Thickness[0.001], PlotPoints -> 15000, AspectRatio -> Automatic]

fx[t_] = Evaluate[x[t] /. Flatten[solo][[1]]]; fy[t_] = Evaluate[y[t] /. Flatten[solo][[2]]]; fpx[t_] = Evaluate[vx[t] /. Flatten[solo][[3]]]; fpy[t_] = Evaluate[vy[t] /. Flatten[solo][[4]]]; 

pas = 1; tx = Chop[Table[Evaluate[fx[t]], {t, 0, 10, pas}]]

Sign[Drop[Chop[tx], 1]*Drop[Chop[tx], -1]]

li = Flatten[Position[Sign[Drop[tx, 1]*Drop[tx, -1]], -1]]

Table[FindRoot[Evaluate[fx[t]] == 0., {t, li[[k]]}], {k, Length[li]}]

tax = (pas*(li - 1)*fx[pas*li] - pas*li*fx[pas*(li - 1)])/(fx[pas*li] - fx[pas*(li - 1)])

fx[tax]

pas = 0.1; tx = Chop[Table[Evaluate[fx[t]], {t, 0, 10, pas}]]; 

li = Flatten[Position[Sign[Drop[tx, 1]*Drop[tx, -1]], -1]]; 

tax = (pas*(li - 1)*fx[pas*li] - pas*li*fx[pas*(li - 1)])/(fx[pas*li] - fx[pas*(li - 1)])

fx[tax]

Transpose[{fy[tax], fpy[tax]}]

pas = 0.1; tx = Chop[Table[Evaluate[fx[t]], {t, 0, tmax, pas}]]; 

li = Flatten[Position[Sign[Drop[tx, 1]*Drop[tx, -1]], -1]]; 

tax = (pas*(li - 1)*fx[pas*li] - pas*li*fx[pas*(li - 1)])/(fx[pas*li] - fx[pas*(li - 1)]); 

Max[Abs[fx[tax]]]

py = ListPlot[Transpose[{fy[tax], fpy[tax]}], Axes -> None, RotateLabel -> False, Frame -> True, FrameLabel -> {"y", "vy"}]

solc

fx[t_] = Evaluate[x[t] /. Flatten[solc][[1]]]; fy[t_] = Evaluate[y[t] /. Flatten[solc][[2]]]; fpx[t_] = Evaluate[vx[t] /. Flatten[solc][[3]]]; fpy[t_] = Evaluate[vy[t] /. Flatten[solc][[4]]]; 

pas = 0.1; tx = Chop[Table[Evaluate[fx[t]], {t, 0, tmax, pas}]]; 

li = Flatten[Position[Sign[Drop[tx, 1]*Drop[tx, -1]], -1]]; 

tax = (pas*(li - 1)*fx[pas*li] - pas*li*fx[pas*(li - 1)])/(fx[pas*li] - fx[pas*(li - 1)]); 

ScientificForm[Max[Abs[fx[tax]]]]

py = ListPlot[Transpose[{fy[tax], fpy[tax]}], Axes -> None, RotateLabel -> False, Frame -> True, FrameLabel -> {"y", "vy"}]

Clear[x, y, sh, nu, xe]

sh[nu_, xe_] := NDSolve[{Derivative[1][Derivative[1][y]][x] + (2*nu + 1 - x^2)*y[x] == 0, y[-5] == 4/10^6, Derivative[1][y][-5] == 5/10^5}, y[x], {x, -5, xe}]

SetOptions[Plot, PlotStyle -> Thickness[0.005], DisplayFunction -> Identity]; dd = PlotStyle -> Dashing[{0.01}]; dt = PlotStyle -> Dashing[{0.02, 0.01, 0.0025, 0.01}]; 

so = Table[0, {5}]; pp = so; 

so[[1]] = sh[-1.5, xe = -0.5]; pp[[1]] = Plot[Evaluate[y[x] /. so[[1]]], {x, -5, xe}, Evaluate[dd]]; so[[2]] = sh[-0.5, xe = 1]; pp[[2]] = Plot[Evaluate[y[x] /. so[[2]]], {x, -5, xe}, Evaluate[dd]]; so[[3]] = sh[-0.01, xe = 6]; pp[[3]] = Plot[Evaluate[y[x] /. so[[3]]], {x, -5, xe}, Evaluate[dd]]; so[[4]] = sh[0, xe = 7]; pp[[4]] = Plot[Evaluate[y[x] /. so[[4]]], {x, -5, xe}]; so[[5]] = sh[0.01, xe = 6]; pp[[5]] = Plot[Evaluate[y[x] /. so[[5]]], {x, -5, xe}, Evaluate[dt]]; 

Show[pp[[1]], pp[[2]], pp[[3]], pp[[4]], pp[[5]], PlotRange -> {-5, 5}, AxesLabel -> {"x", "y(x)"}, PlotLabel -> "Harm.oscillator:  ν =  -1.5, -.5, -.1, 0, .1 . \n\n", PlotRegion -> {{0.01, 0.99}, {0.01, 0.99}}, DisplayFunction -> $DisplayFunction]

xe = 5; 

te[nu_] := Hold[y[xe] /. NDSolve[{Derivative[1][Derivative[1][y]][x] + (2*nu + 1 - x^2)*y[x] == 0, y[-5] == 4/10^6, Derivative[1][y][-5] == 5/10^5}, y, {x, -5, xe}]]

(* UNCONVERTED CELL *)

(* UNCONVERTED CELL *)

(* UNCONVERTED CELL *)

ten[(nu_)?NumericQ] := y[xe] /. NDSolve[{Derivative[1][Derivative[1][y]][x] + (2*nu + 1 - x^2)*y[x] == 0, y[-5] == 4/10^6, Derivative[1][y][-5] == 5/10^5}, y, {x, -5, xe}]

FindRoot[ten[nnn], {nnn, 0.8, 1.3}], Null, ten[nnn /. %]

deq = y*D[u[x, y], x] + x*D[u[x, y], y] == 0

so = DSolve[deq, u[x, y], {x, y}]

deq = y*D[u[x, y], x] + x*D[u[x, y], y] == 1

so = DSolve[deq, u[x, y], {x, y}]

deq = y*D[u[x, y], x] - x*D[u[x, y], y] == 0

so = DSolve[deq, u[x, y], {x, y}]

deq = x*D[u[x, y, z], x] + y*D[u[x, y, z], y] + z*D[u[x, y, z], z] == 0

so = DSolve[deq, u[x, y, z], {x, y, z}]

deq = D[u[x, y], {x, 2}] + D[u[x, y], {y, 2}] == 0

so = DSolve[deq, u[x, y], {x, y}]

deq = D[u[x, t], {x, 2}] - (1/c^2)*D[u[x, t], {t, 2}] == 0

so = DSolve[deq, u[x, t], {x, t}]

Flatten[PowerExpand[so]]

deq = D[u[r, ϕ], {r, 2}] + (1/r)*D[u[r, ϕ], r] + (1/r^2)*D[u[r, ϕ], {ϕ, 2}] == 0

so = DSolve[deq, u[r, ϕ], {r, ϕ}]

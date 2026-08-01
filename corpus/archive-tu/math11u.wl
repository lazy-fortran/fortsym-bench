Clear[x, y, z, m, r, v, a, B0, E0, sol]; , Null, Ef = {0, E0, 0}; , Null, Bf = {0, 0, B0}; , Null, r = {x[t], y[t], z[t]}; , Null, v = D[r, t]; , Null, b = D[v, t]; , Null, Force = q*Ef + q*Cross[v, Bf] - m*a*v; 

eq = Table[b[[i]] == Force[[i]], {i, 3}]

id = {x[0] == 0, Derivative[1][x][0] == vx, y[0] == 0, Derivative[1][y][0] == vy, z[0] == 0, Derivative[1][z][0] == vz}; 

sol = Flatten[DSolve[Union[eq, id], {x, y, z}, t]]

Simplify[eq /. sol]

Null

Force := q*Ef + q*Cross[v, Bf] - m*a*v*Abs[v]; eq := Table[b[[i]] == Force[[i]], {i, 3}] /. {q -> 1, m -> 1, a -> 1, E0 -> 1, B0 -> 10}; 

id = {x[0] == 0, Derivative[1][x][0] == 1, y[0] == 0, Derivative[1][y][0] == 1, z[0] == 0, Derivative[1][z][0] == 1}; , Null, sol = Flatten[NDSolve[Union[eq, id], {x, y, z}, {t, 0, 1}]]

p1 = ParametricPlot3D[Evaluate[{x[t], y[t], z[t]} /. sol], {t, 0, 1}]; , Null, p2 = ListPointPlot3D[Evaluate[({x[#1], y[#1], z[#1]} & ) /@ Range[0, 1, 0.05] /. sol], PlotStyle -> {PointSize -> Medium}]; , Null, Show[p1, p2]

Clear[Force, m, r, x, y, z, v, a, mg, c1, c2, sol]; , Null, r = {x[t], y[t], z[t]}; , Null, v = D[r, t]; , Null, a = D[v, t]; , Null, Force = {0, 0, -g} - c1*v - c2*v*Abs[v]; , Null, eq = Table[a[[i]] == Force[[i]], {i, 1, 3}] /. {g -> 10}

id = {x[0] == 0, Derivative[1][x][0] == 0, y[0] == 0, Derivative[1][y][0] == 5, z[0] == 0, Derivative[1][z][0] == 10}; , Null, sol = Array[Null, 3]; , Null, sol[[1]] = Flatten[NDSolve[Union[eq, id] /. {c1 -> 0, c2 -> 0}, {x, y, z}, {t, 0, 2}]]; , Null, sol[[2]] = Flatten[NDSolve[Union[eq, id] /. {c1 -> 0.5, c2 -> 0}, {x, y, z}, {t, 0, 2}]]; , Null, sol[[3]] = Flatten[NDSolve[Union[eq, id] /. {c1 -> 0, c2 -> 0.5}, {x, y, z}, {t, 0, 2}]]; p1 = ParametricPlot3D[Evaluate[{x[t], y[t], z[t]} /. sol], {t, 0, 2}]; , Null, p2 = ListPointPlot3D[Evaluate[({x[#1], y[#1], z[#1]} & ) /@ Range[0, 2, 0.1] /. sol], PlotStyle -> {PointSize -> Medium}]; , Null, Show[p1, p2]

Null

Clear[Force, m, r, x, y, z, v, a, mg, c1, c2, sol]; , Null, Force = If[Abs[x[t]] < 1, -x[t], 0]; , Null, eq = Derivative[2][x][t] == Force; , Null, sol = Array[Null, 2]; , Null, sol[[1]] = NDSolve[{eq, x[0] == 0, Derivative[1][x][0] == v0} /. v0 -> 1, {x}, {t, 0, 3}]; , Null, sol[[2]] = NDSolve[{eq, x[0] == 0, Derivative[1][x][0] == v0} /. v0 -> 1.1, {x}, {t, 0, 3}]; p1 = Plot[Evaluate[x[t] /. sol], {t, 0, 3}]

TODO

dgl = Derivative[2][y][x] + 2*x*Derivative[1][y][x] + 2*y[x] == 0; 

asol1 = DSolve[dgl, y[x], x]

asol2 = DSolve[{dgl, y[0] == 0, y[2] == 1}, y[x], x]

nsol1 := NDSolve[{dgl, y[0] == 1, Derivative[1][y][0] == 0}, y[x], {x, 0, 3}]

Plot[Evaluate[y[x] /. nsol1], {x, 0, 3}]

y[x] - x*Derivative[1][y][x] + (-3 + 2*x)*Derivative[2][y][x] + (2 - x)*Derivative[3][y][x] == 0

FullSimplify[% /. y -> Exp]

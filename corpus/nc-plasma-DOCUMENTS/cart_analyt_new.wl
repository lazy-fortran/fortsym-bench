FullSimplify[Curl[nu*Curl[{Ax[x], Ay[x], 0}*Exp[I*n*z], {x, y, z}, "Cartesian"], {x, y, z}, "Cartesian"]]/Exp[I*n*z]

sol = Flatten[DSolve[nu*(n^2*Ay[x] - Derivative[2][Ay][x]) == 0, Ay[x], x]]

FullSimplify[Curl[Curl[{0, Ay[x] /. sol, 0}*Exp[I*n*z], {x, y, z}, "Cartesian"], {x, y, z}, "Cartesian"]]/Exp[I*n*z]

eq1 = Ay[x] == 1 /. sol /. x -> 0

Ay[x] == 1 /. sol /. x -> 1

eq2 = E^n*C[1] + C[2]/E^n == 1

csol = Flatten[FullSimplify[Solve[{eq1, eq2}, {C[1], C[2]}]]]

FullSimplify[Ay[x] /. sol /. csol]

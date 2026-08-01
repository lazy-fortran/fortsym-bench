$Assumptions = {Element[{a, et, th, m}, Reals], a > 0, m != 0, et >= 0, th > -Pi, th <= Pi}

R = Sqrt[Cosh[et] - Cos[th]], Null, g11 = a^2/(Cosh[et] - Cos[th])^2, Null, g22 = g11, Null, g33 = g11*Sinh[et]^2, Null, sqg = FullSimplify[Sqrt[g11*g22*g33]], Null

A[1] = aet[et, th], Null, A[2] = ath[et, th], Null, curlt[v_] := (1/sqg)*(D[v[2], et] - D[v[1], th]), Null, eq1 = FullSimplify[D[g33*curlt[A], th] + (m^2/sqg)*(g22*A[1]) == 0], Null, eq2 = FullSimplify[-D[g33*curlt[A], et] + (m^2/sqg)*(g11*A[2]) == 0]

AR[1] = RA[et, th]*E1[et]*T1[th], Null, AR[2] = 0

eq1R = Simplify[D[g33*curlt[AR], th] + (m^2/sqg)*(g22*AR[1]) == 0], Null, eq2R = Simplify[-D[g33*curlt[AR], et] + (m^2/sqg)*(g11*AR[2]) == 0]

FullSimplify[D[g33*curlt[A], et]], Null, FullSimplify[D[g33*curlt[A], th]]

FullSimplify[D[R, th] + R]

v[1][x, y] = X1[1][x]*X1[2][y], Null, v[2][x, y] = X2[1][x]*X2[2][y], Null, CurlCurl = {D[D[v[2][x, y], x] - D[v[1][x, y], y], y], -D[D[v[2][x, y], x] - D[v[1][x, y], y], x]}

Null

DeltaStar[f_] := D[f, {z, 2}] + R*D[(1/R)*D[f, R], R], Null, rhs := R^2*a + R0^2*b

psimn[R_, z_, m_, n_] := c[m, 2*n]*(R^2 - R0^2)^m*z^(2*n), Null, psi[R_, z_] := Sum[psimn[R, z, m, n], {m, 0, 3}, {n, 0, 1}]

cmn = Flatten[Table[c[m, 2*n], {m, 0, 3}, {n, 0, 1}]]

lhs = FullSimplify[DeltaStar[psi[R, z]] /. R -> Sqrt[R0^2 + dR2]]

rhs = FullSimplify[rhs /. R -> Sqrt[R0^2 + dR2]]

sol = Solve[lhs == rhs, cmn]

lhscoef = CoefficientList[lhs, {dR2, z}]

CoefficientList[rhs, {dR2, z}]

rhscoef = {{(a + b)*R0^2, 0, 0}, {a, 0, 0}, {0, 0, 0}}

Solve[{(a + b)*R0^2 == 2*c[0, 2] + 8*R0^2*c[2, 0], 8*R0^2*c[2, 2] == 0, 2*c[1, 2] + 8*c[2, 0] + 24*R0^2*c[3, 0] == a, 8*(c[2, 2] + 3*R0^2*c[3, 2]) == 0, c[1, 2] == A*(c/2), c[2, 0] == (a + b - A)/8}, cmn]

Null

Coefficient[lhs, dR2] /. z -> 0

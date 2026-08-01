ClearAll, Null, B0[z_] = 1 + z^2, Null, A[x1_, x2_, x3_] = {(-2^(-1))*B0[x3]*x2, (1/2)*B0[x3]*x1, 0}

D[A[x1, x2, x3], x3]

B = Simplify[Curl[A[x1, x2, x3], {x1, x2, x3}]]

e1 = FullSimplify[Cross[B, {1, 0, 0}]]

e2 = FullSimplify[Cross[B, Cross[B, {1, 0, 0}]]]

Null

VectorPlot3D[{B, e1, e2}, {x1, -1, 1}, {x2, -1, 1}, {x3, -1, 1}]

Null

StreamPlot3D[{B, e1, e2}, {x1, -1, 1}, {x2, -1, 1}, {x3, -1, 1}]

Simplify[D[(p1 + A1[x1, x2])^2 + (p2 + A2[x1, x2])^2, x1]/2]

D[A[x1 + rho1[x1, x2], x2 + rho2[x1, x2]], x1]

FullSimplify[D[e1/Sqrt, x2]]

FullSimplify[D[e1/Sqrt[e1[[1]]^2 + e1[[2]]^2 + e1[[3]]^2], x1]]

FullSimplify[D[e1/Sqrt[e1[[1]]^2 + e1[[2]]^2 + e1[[3]]^2], x2]]

FullSimplify[D[e1/Sqrt[e1[[1]]^2 + e1[[2]]^2 + e1[[3]]^2], x3]]

FullSimplify[D[e2/Sqrt[e2[[1]]^2 + e2[[2]]^2 + e2[[3]]^2], x1]]

FullSimplify[D[e2/Sqrt[e2[[1]]^2 + e2[[2]]^2 + e2[[3]]^2], x2]]

FullSimplify[D[e2/Sqrt[e2[[1]]^2 + e2[[2]]^2 + e2[[3]]^2], x3]]

Null

Grad[(1 + z^2)*z, {x, y, z}]

B = Curl[Bval[x3]*{(-2^(-1))*x2, (1/2)*x1, 0}, {x1, x2, x3}]

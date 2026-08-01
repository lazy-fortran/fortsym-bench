G1[n_, k_, x] = (-1)^k*(n!/(n - 2*k)!)*(1/(2^(2*k)*k!*(k - 1)!))*x^(2*k)*(2*log[x] + 1/k - 2*Sum[1/j, {j, 1, k}])

G2[n_, k_, x] = (-1)^k*(n!/(n - 2*k)!)*(1/(2^(2*k)*k!*(k + 1)!))*x^(2*k + 2)

G[n_, k_, x] = c[n, 1]*G1[n, k, x] + c[n, 2]*G2[n, k, x], Null, G0[n_, x] = c[n, 1] + c[n, 2]*x^2

lhs = Sum[G[n, k, x]*y^(n - 2*k), {n, 0, 6, 2}, {k, 1, n/2}] + Sum[G0[n, x]*y^n, {n, 0, 6, 2}]

cmn = Flatten[Table[c[m, n], {m, 0, 6, 2}, {n, 1, 2}]], Null, Collect[lhs, cmn] /. c[6, 2] -> 0

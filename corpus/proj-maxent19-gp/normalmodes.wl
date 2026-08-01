fun = Sum[Cos[k*Pi*x1]*(Cos[k*Pi*x2]/k^4), {k, 1, Infinity}]

Plot[fun /. x1 -> 0, {x2, -1, 1}]

fpr = D[fun, x2], Null, Plot[fpr /. x1 -> 0, {x2, -1, 1}]

fprpr = D[fpr, x2]

Plot[fprpr /. x1 -> 0, {x2, -1, 1}]

DSolve[Laplacian[phi[x, y], {x, y}] == -Log[Sqrt[x^2 + y^2]], phi[x, y], {x, y}]

Integrate[(1/((xpr - xppr)^2 + (ypr - yppr)^2 + (zpr - zppr)^2))*(1/Sqrt[(x - xppr)^2 + (y - yppr)^2 + (z - zppr)^2]), {xppr, -Infinity, Infinity}, {yppr, -Infinity, Infinity}, {zppr, -Infinity, Infinity}]

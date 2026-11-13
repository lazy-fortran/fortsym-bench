L = FullSimplify[Laplacian[f[r, p], {r, p}, "Polar"]]

GreenFunction[L, f[r, p], Element[{r, p}, ImplicitRegion[r >= 1 && p >= 0 && 2*pi >= p, {r, p}]], {rp, pp}]

DSolve[{L == 0, f[1, p] == 1}, f[r, p], {r, p}]

L2 = Laplacian[f[x, y], {x, y}]

DSolve[{L2 == 0, f[x, 0] == 1}, f[x, y], {x, y}]

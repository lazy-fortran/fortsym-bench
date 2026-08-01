Null

$Assumptions = {Element[n, PositiveIntegers], n >= 1, n <= N, Element[k, PositiveIntegers]}

r = Sqrt[Sum[(x[k] - y[k])^2, {k, 1, N}]]

Simplify[D[Cos[r], x[n]]]

Simplify[D[Cos[r], y[n]]]

Simplify[D[Cos[r], x[n], x[n]]]

Simplify[D[Cos[r], x[n], y[n]]]

Simplify[D[Cos[r], y[n], y[n]]]

Null

k0 = Exp[-(x - y)^2/(2*l^2)]

Simplify[D[k0, x]]

Simplify[D[k0, y]]

Simplify[D[k0, x, x]]

Simplify[D[k0, x, y]]

Simplify[D[k0, y, y]]

k1 = Exp[-Sin[x - y]^2/(2*l^2)]

Simplify[D[k1, x]]

Simplify[D[k1, y]]

Simplify[D[k1, x, x]]

Simplify[D[k1, x, y]]

Simplify[D[k1, y, y]]

kprod = ka[x0 - y0]*kb[x1 - y1]

D[kprod, x0]

D[kprod, x1]

D[kprod, x0, x0]

D[kprod, x0, y1]

kprodtest = kprod /. {ka[x0 - y0] -> k0 /. {x -> x0, y -> y0}, kb[x1 - y1] -> k1 /. {x -> x1, y -> y1}}

Simplify[D[kprodtest, x0, x1]]

Simplify[D[(k0 /. {x -> x0, y -> y0})*(k1 /. {x -> x1, y -> y1}), x0, x1]]

om = Sqrt[g*k*Tanh[k*h]]

Phi = (om/k)*(Cosh[k*(z + h)]/Sinh[k*h])*Sin[k*x - om*t]

eta = Simplify[Cos[k*x - om*t]]

Limit[om, h -> Infinity]

om0 = Sqrt[g*k]

Integrate[Cos[k*x - c*k*t]^2, {k, -Infinity, Infinity}]

Null

test = Sum[Cos[k*((x - xpr) - c*(t - tpr))]/k^2, {k, 1, 10}]; 

Plot[test /. {c -> 1, t -> 1, tpr -> 1, xpr -> 0}, {x, -10, 10}]

K = Cos[k*(x - xpr)] + f[x - xpr]

D[K, x, x]

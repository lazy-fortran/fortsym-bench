$Assumptions = {Element[k, Reals], Element[x, Reals]}; 

H = p^2/(2*m) + U0*Sin[x/2]^2

Solve[H == e, p]

J1 = FullSimplify[Integrate[Sqrt[k - Sin[x/2]^2], {x, 0, 2*Pi}], Assumptions -> k > 1]/(2*Pi)

J2 = 2*(Sqrt[k]/Pi)*EllipticE[1/k]

Plot[{J1, J2}, {k, 1.1, 2.}, PlotStyle -> {Thick, Dashed}]

J2 = 4*(Sqrt[H/U0]/Pi)*EllipticE[U0/H]

x0 = ArcCos[1 - 2*k]; 

J1 = FullSimplify[Integrate[Sqrt[k - Sin[x/2]^2], {x, -x0, x0}, Assumptions -> {k < 1, k > 0}]]/Pi

J2 = (4/Pi)*(EllipticE[k] - (1 - k)*EllipticK[k])

Plot[{J1, J2}, {k, 0.1, 0.9}, PlotStyle -> {Thick, Dashed}]

Null

tau = FullSimplify[Integrate[1/Sqrt[k - Sin[x/2]^2], x, Assumptions -> {k < 1, k > 0}]]

Simplify[Limit[(tau /. x -> x0 - eps) - (tau /. x -> -x0 + eps), eps -> 0]]

FullSimplify[(8/Pi)*D[EllipticE[H/U0] - (1 - H/U0)*EllipticK[H/U0], H]]

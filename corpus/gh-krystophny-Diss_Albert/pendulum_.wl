$Assumptions = {Element[k, Reals], Element[x, Reals]}; 

H = p^2/(2*m) + U0*Sin[x/2]^2

Solve[H == e, p]

J1 = FullSimplify[Integrate[Sqrt[k - Sin[x/2]^2], {x, 0, 2*Pi}], Assumptions -> k > 1]/(2*Pi)

J2 = 2*(Sqrt[k]/Pi)*EllipticE[1/k]

Plot[{J1, J2}, {k, 1.1, 2.}, PlotStyle -> {Thick, Dashed}]

J2 = 4*(Sqrt[H/U0]/Pi)*EllipticE[U0/H]

x0 = ArcCos[1 - 2*k^2]; 

J1 = FullSimplify[Integrate[Sqrt[k - Sin[x/2]^2], {x, -x0, x0}, Assumptions -> {k < 1, k > 0}]]/Pi

J2 = (4/Pi)*(EllipticE[k] - (1 - k)*EllipticK[k])

Plot[{J1, J2}, {k, 0.1, 0.9}, PlotStyle -> {Thick, Dashed}]

Null

tau = FullSimplify[Integrate[1/Sqrt[k - Sin[x/2]^2], x, Assumptions -> {k < 1, k > 0}]]

Simplify[Limit[(tau /. x -> x0 - eps) - (tau /. x -> -x0 + eps), eps -> 0]]

FullSimplify[(8/Pi)*D[EllipticE[H/U0] - (1 - H/U0)*EllipticK[H/U0], H]]

J[H_] := Sqrt[m*U0]*(8/Pi)*(EllipticE[H/(2.*U0)] - (1 - H/(2.*U0))*EllipticK[H/(2.*U0)])

FullSimplify[D[J[H], H]]

FullSimplify[1/D[FullSimplify[D[J[H], H]], H] /. H -> k^2*U0]

FullSimplify[Integrate[1/Sqrt[k^2 - Sin[x/2]^2], {x, 0, 2*Pi}], Assumptions -> k > 1]/(2*Pi)

(xm = -ArcCos[1 - 2*k2]; )*(xp = ArcCos[1 - 2*k2]; )*FullSimplify[Integrate[1/Sqrt[k2 - Sin[x/2]^2], {x, xm + eps, xp - eps}], Assumptions -> {k2 < 1, k2 > 0, eps > 0}]

FullSimplify[Integrate[1/Sqrt[k^2 - Sin[x/2]^2], {x, 0, xa}, Assumptions -> {k < 1, k > 0}]]

FullSimplify[Integrate[1/Sqrt[k^2 - Sin[x/2]^2], {x, 0, xa}, Assumptions -> {k > 1}]]

tht[k_, x_] := (2*EllipticF[x/2, 1/k^2])/k

FullSimplify[tht[k, x0] /. k -> 0.9999]

Plot[Pi*(EllipticF[x/2, 1/k^2]/EllipticK[1/k^2]) /. k -> 1.001, {x, -Pi, Pi}]

Plot[Pi*(EllipticF[ArcSin[Sin[x/2]/k], k^2]/(2*EllipticK[k^2])) /. k -> 0.5, {x, -Pi, Pi}]

Null

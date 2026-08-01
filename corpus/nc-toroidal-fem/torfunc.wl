Plot[LegendreP[-0.5, Cosh[x]], {x, 0, 1}]

TorQCosh[m_, t_] := (1/Sqrt[2])*NIntegrate[Cos[m*th]/Sqrt[Cosh[t] - Cos[th]], {th, 0, Pi}]

Plot[TorQCosh[0, x], {x, 0.01, 10}]

TorP[x_] := (2/Pi)*Sqrt[2/(1 + x)]*EllipticK[(x - 1)/(1 + x)], Null, TorQ[x_] := Sqrt[2/(1 + x)]*EllipticK[2/(1 + x)]

Plot[{TorQCosh[0, x], TorQ[Cosh[x]], LegendreP[-0.5, Cosh[x]], TorP[Cosh[x]]}, {x, 0.01, 10}]

Plot[{TorQCosh[0, x], LegendreP[-0.5, Cosh[x]]}, {x, 0.01, 10}]

R = a*(Sinh[eta]/(Cosh[eta] - Cos[th])), Null, phi = ph, Null, z = a*(Sinh[th]/(Cosh[eta] - Cos[th])), Null, J = {{D[z, eta], D[z, th], D[z, phi]}, {D[R, eta], D[R, th], D[R, phi]}, {D[phi, eta], D[phi, th], D[phi, phi]}}

MatrixForm[FullSimplify[J]]

FullSimplify[Det[J]]

Null

Jinv = FullSimplify[Inverse[FullSimplify[J]]]

FullSimplify[Det[Jinv]]

d1 = Sqrt[(R0 + a)^2 + z0^2], Null, d2 = Sqrt[(R0 - a)^2 + z0^2], Null, eta0 = FullSimplify[Log[d1/d2], Reals, Assumptions -> {Element[{a, R0, z0}, Reals], R0 > 0, a > 0}], Null, th0 = FullSimplify[ArcCos[-(4*a^2 - d1^2 - d2^2)/(2*d1*d2)], Reals, Assumptions -> {Element[{a, R0, z0}, Reals], R0 > 0, a > 0}]

Jinv2 = FullSimplify[{{D[eta0, z0], D[eta0, R0]}, {D[th0, z0], D[th0, R0]}}, Reals]

DetJinv2 = FullSimplify[Abs[Det[Jinv2]], Assumptions -> {Element[{a, R0, z0}, Reals], R0 > 0, a > 0}]

R03 = a*Coth[eta03], Null, r03 = a*Csch[eta03]

FullSimplify[Solve[{R03 == R030 && r03 == r030 && r030 > 0 && R030 > r030 && a > 0}, {a, eta03}, Reals]]

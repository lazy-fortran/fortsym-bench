J = {{1, 0, 0}, {a21, a22, 0}, {a31, a32, 1}}; MatrixForm[J], Null, MatrixForm[Inverse[J]]

g1 = 1; g2 = 1; B1 = 1; B2 = 1; B3 = 1; , Null, b = Sqrt[g1*(g2/(B1*B2))], Null, d = B1*g2 + B2*g1, Null, u = (g2*xi + g1*eta)/d - lam/B3, Null, z = lam/B3 + b*Tanh[u/b], Null, phi = (B2*xi - B1*eta)/d, Null, rho = b*Sech[u/b], Null, x = rho*Cos[phi], Null, y = rho*Sin[phi]

Plot3D

g1 = 1; g2 = 1; B1 = 1; B2 = 1; B3 = 1; b = Sqrt[g1*(g2/(B1*B2))]; , Null, rho = Sqrt[x^2 + y^2]; phi = ArcTan[y, x]; , Null, xi = B1*z + g1*phi + B1*(Sqrt[b^2 - rho^2] + b*Log[rho/(b + Sqrt[b^2 - rho^2])]), Null, eta = B2*z - g2*phi + B2*(Sqrt[b^2 - rho^2] + b*Log[rho/(b + Sqrt[b^2 - rho^2])]), Null, lam = B3*(z + Sqrt[b^2 - rho^2])

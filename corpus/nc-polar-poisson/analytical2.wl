$Assumptions = {Element[{R, R1, R2, ph}, Reals], Element[n, Integers], R > 0, R1 > 0, R2 > 0, R2 > R1, n > 0}; 

n = 1; rho0 = FullSimplify[1 - (2*((R - (R1 + R2)/2)/(R2 - R1)))^2]; , Null, rho0 = (4/(R1 + R2))*FullSimplify[rho0/Integrate[rho0, {R, R1, R2}]], Null, dgl = FullSimplify[-Laplacian[u[R]*Cos[n*ph], {R, ph}, "Polar"] == rho0*Cos[n*ph]], Null, sol = Flatten[FullSimplify[DSolve[dgl, u[R], R]]], Null, ursol = u[R] /. sol, Null, durdr = D[ursol, R]

eqs = {ursol == A*R^n /. R -> R1, durdr == A*n*R^(n - 1) /. R -> R1, ursol == B/R^n /. R -> R2, durdr == (-B)*(n/R^(n + 1)) /. R -> R2}, Null, solcoef = FullSimplify[Flatten[Solve[eqs, {A, B, C[1], C[2]}]]]

Phi = FullSimplify[(Boole[R <= R1]*A*R + Boole[R1 < R]*Boole[R < R2]*ursol + Boole[R >= R2]*(B/R))*Cos[n*ph]] /. solcoef, Null, rho = FullSimplify[-Laplacian[Phi, {R, ph}, "Polar"]]

R1b = 0.3; R2b = 0.5; phb = 0; , Null, rho0b = rho0 /. {R1 -> R1b, R2 -> R2b, ph -> phb}; , Null, rhob = rho /. {R1 -> R1b, R2 -> R2b, ph -> phb}; , Null, Phi0b1 = A*R^n*Cos[n*ph] /. solcoef /. {R1 -> R1b, R2 -> R2b, ph -> phb}; , Null, Phi0b2 = (B*Cos[n*ph])/R^n /. solcoef /. {R1 -> R1b, R2 -> R2b, ph -> phb}; , Null, Phib = Phi /. {R1 -> R1b, R2 -> R2b, ph -> phb}; 

Plot[{rho0b, rhob, rhob}, {R, 0, 1}, PlotRange -> {-20., 50.}, PlotLabel -> "Charge Density rho"], Null, Plot[{Phi0b1, Phi0b2, Phib}, {R, 0, 1}, PlotRange -> {0., 1.2}, PlotLabel -> "Potential Phi"]

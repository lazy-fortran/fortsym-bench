$Assumptions = Element[{B0ph, B0th}, Reals]; 

R = R0*(1 + (r/R0)*Cos[th]); , Null, Ar = 0; , Null, Ath = B0ph*(r^2/2 - (r^3/(3*R0))*Cos[th]); , Null, Aph = (-B0th)*R0*r; , Null, sqrtg = r*R; , Null, gthth = r^2; , Null, gphph = R^2; 

Brctr = (1/sqrtg)*(D[Aph, th] - D[Ath, ph]), Null, Bthctr = FullSimplify[(1/sqrtg)*(D[Ar, ph] - D[Aph, r])], Null, Bphctr = FullSimplify[(1/sqrtg)*(D[Ath, r] - D[Ar, th])], Null, Bthcov = FullSimplify[gthth*Bthctr], Null, Bphcov = FullSimplify[gphph*Bphctr]

Bmod = FullSimplify[Sqrt[Bthctr*Bthcov + Bphctr*Bphcov]]

FullSimplify[Series[Bmod /. r -> eps*R0, {eps, 0, 1}] /. eps -> r/R0]

hthcov = Simplify[Bthcov/Bmod], Null, hphcov = Simplify[Bphcov/Bmod], Null, FullSimplify[Series[hthcov /. r -> eps*R0, {eps, 0, 1}] /. eps -> r/R0], Null, FullSimplify[Series[hphcov /. r -> eps*R0, {eps, 0, 1}] /. eps -> r/R0]

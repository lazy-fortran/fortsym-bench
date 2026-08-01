((rho = {(-rl)*Cos[phi2], rl*Sin[phi2]*(hz/r0), (-rl)*Sin[phi2]*(ht/r0)}; )*(xg = {r0, th2, z2}; )*(xc = xg + rho; )*(theta = {phi2, th2, z2}; )*(dxcdth = D[xc, {theta}]; )*MatrixForm[dxcdth])*(Fe = Exp[I*ks*rl*Sin[phi2]]; )*(T[k_, r_] := Sqrt[alpha]*Sqrt[k + 1/2]*LegendreP[k, alpha*r + beta])*(a[k_] := T[k, r0 + rho[[1]]]*Fe*dxcdth)*($Assumptions = {Element[{rl, ks, ht, hz, r0}, Reals], Element[{rl}, NonNegative]}; )*(aF[k_, l_] := Integrate[Exp[(-I)*l*phi2]*a[k], {phi2, -Pi, Pi}]/2/Pi; )

L[n_, k_] := Coefficient[LegendreP[k, z], z, n], Null, L1[m_, k_, r_] := Sum[L[n, k]*Binomial[n, m]*r^(n - m), {n, m, k}], Null, L2[m_, k_] := Sqrt[alpha]*Sqrt[k + 1/2]*alpha^m*L1[m, k, alpha*r0 + beta], Null, mod[p1_, p2_] := Sqrt[p1^2 + p2^2]; , Null, arg[p1_, p2_] := ArcTan[p2/p1]; , Null, JE[l_, p1_, p2_] := BesselJ[l, mod[p1, p2]*rl]*Exp[I*l*arg[p1, p2]], Null, Der1[l_, m_, p1_, p2_] := D[JE[l, p1, p2], {p2, m}]; , Null, Der2[l_, m_, p1_, p2_] := D[Der1[l, m, p1, p2], {p1, 1}]; , Null, Dmat[l_, m_, ks_] := {{(-I)*Der2[l, m, p1, p2], 0, 0}, {(-I)*(hz/r0)*Der1[l, m + 1, p1, p2], Der1[l, m, p1, p2], 0}, {I*(ht/r0)*Der1[l, m + 1, p1, p2], 0, Der1[l, m, p1, p2]}} /. {p2 -> 0, p1 -> ks}; , Null, aFa[k_, l_] := Refine[Sum[L2[m, k]*I^m*Dmat[l, m, ks], {m, 0, k}], ks >= 0]; 

aF11 = aF[1, 7]

aFa11 = aFa[1, l]

FullSimplify[aFa11 - aF11]

$Assumptions

FullSimplify[aFa11]

For[k = 0, k <= Kmax, k++; amat[k] = aFa[k, l]]

Array[a, 10]

H = Array[Ht, 2]; , Null, VE = Array[Ht, 2], Null, Omega = {omc, H[[1]]*u + VE[[2]], H[[2]]*u + VE[[2]]}

(* UNCONVERTED CELL *)

DD = Derivative[1] + Derivative[2]

Null

DD*Sin[x]

R = Integrate[x^(2*b + 1)*Exp[(-a)*x^2]*BesselJ[n, k1*x]*BesselJ[n, k2*x]]

NIntegrate[(x^(1 + 2*b)*BesselJ[l, k1*x]*BesselJ[l, k2*x])/E^(a*x^2) /. {a -> 2, b -> 3, l -> 0, k1 -> 10, k2 -> 2}, {x, 0, Infinity}, WorkingPrecision -> 50, PrecisionGoal -> 20]

Jquad[n_, l_] = (-1)^n*D[(1/2/a)*Exp[-(k1^2 + k2^2)/4/a]*BesselI[l, k1*(k2/2/a)], {a, n}]

N[Jquad[n, l] /. {n -> 3, b -> 0, l -> 0, k1 -> 10, k2 -> 2}, 20] /. a -> 2

Jquad[n_, l_] = (-1)^n*D[(1/2/a)*Exp[-(k1^2 + k2^2)/4/a]*BesselI[l, k1*(k2/2/a)], {a, n}]

FullSimplify[Jquad[1, l]]

FullSimplify[Jquad[2, l]]

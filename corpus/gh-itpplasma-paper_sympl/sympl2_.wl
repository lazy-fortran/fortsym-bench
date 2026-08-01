$Assumptions = {Element[{h0ph, h0th, B0}, Reals], h0ph > 0, h0ph < 1}; 

R = R0*(1 + (r/R0)*Cos[th]); , Null, Ar = 0; , Null, Ath = h0ph*B0*(r^2/2 - (r^3/(3*R0))*Cos[th]); , Null, Aph = (-h0th)*B0*R0*r; , Null, sqrtg = r*R; , Null, gthth = r^2; , Null, gphph = R^2; 

Bmod = B0*(1 - (r/R0)*Cos[th])

hth = r*h0th, Null, hph = R*h0ph

pthofw = m*vpar*hth + (e/c)*Ath, Null, pphofw = m*vpar*hph + (e/c)*Aph

dpdq = FullSimplify[{{D[pthofw, th], D[pthofw, ph]}, {D[pphofw, th], D[pphofw, ph]}}]

dpdw = FullSimplify[{{D[pthofw, r], D[pthofw, vpar]}, {D[pphofw, r], D[pphofw, vpar]}}]

dwdp = FullSimplify[Inverse[dpdw] /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1}]

dwdq = FullSimplify[-dwdp . dpdq /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1}]

Part(dwdq,1,1)

Part(dwdq,1,2)

Part(dwdq,2,1)

Part(dwdq,2,2)

Part(dwdp,1,1)

Part(dwdp,1,2)

Part(dwdp,2,1)

Part(dwdp,2,2)

Hofw = m*(vpar^2/2) + Jperp*e*(c/m)*Bmod

dHdr = FullSimplify[D[Hofw, r] /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1}]

dHdvpar = FullSimplify[D[Hofw, vpar] /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1, Jperp -> 1}]

dHdth = FullSimplify[D[Hofw, th] /. {e -> 1, m -> 1, c -> 1, B0 -> 1, R0 -> 1, Jperp -> 1}]

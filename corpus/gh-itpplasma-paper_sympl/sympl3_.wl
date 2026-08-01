$Assumptions = {Element[{h0ph, h0th, B0}, Reals], h0ph > 0, h0ph < 1, h0th > 0, h0th < 1}; , Null, R = R0*(1 + (r/R0)*Cos[th]); , Null, Ar = 0; , Null, Ath = h0ph*B0*(r^2/2 - (r^3/(3*R0))*Cos[th]); , Null, Aph = (-h0th)*B0*R0*r; , Null, sqrtg = r*R; , Null, gthth = r^2; , Null, gphph = R^2; , Null, Bmod = B0*(1 - (r/R0)*Cos[th]); , Null, hr = 0; , Null, hth = r*h0th; , Null, hph = R*h0ph; , Null, pth = m*vp*hth + eoc*Ath; , Null, pph = m*vp*hph + eoc*Aph; , Null, eoc = 1; m = 1; B0 = 1; R0 = 1; Jperp = 0.1; 

dpdq = FullSimplify[{{D[pth, th], D[pth, ph]}, {D[pph, th], D[pph, ph]}}]

dpdw = FullSimplify[{{D[pth, r], D[pth, vp]}, {D[pph, r], D[pph, vp]}}]

{{0, 0}, {0, 0}}

dwdp = FullSimplify[Inverse[dpdw]]

dwdq = FullSimplify[-dwdp . dpdq]

Part(dwdq,1,1)

Part(dwdq,1,2)

Part(dwdq,2,1)

Part(dwdq,2,2)

Part(dwdp,1,1)

Part(dwdp,1,2)

Part(dwdp,2,1)

Part(dwdp,2,2)

H = m*(vp^2/2) + Jperp*eoc*m*Bmod

vp^2/2 + 100*(1 - r*Cos[th])

dHdr = FullSimplify[D[H, r]]

dHdvp = FullSimplify[D[H, vp]]

vp

dHdth = FullSimplify[D[H, th]]

Lgc = pth*thdot - H /. {th -> th[t], r -> r[t], vp -> vp[t], thdot -> D[th[t], t]} /. {h0th -> 1, h0ph -> 0} /. r[t] -> 0.3

eq1 = FullSimplify[D[D[Lgc, Derivative[1][th][t]], t] - D[Lgc, th[t]] == 0]

eq2 = FullSimplify[D[Lgc, r[t]] == 0]

eq3 = FullSimplify[D[Lgc, vp[t]] == 0]

tmax = 100; , Null, sol = Flatten[NDSolve[{eq1, eq3, th[0] == 1.5, vp[0] == 0.}, {th[t], vp[t]}, {t, 0, tmax}]], Null, Plot[Evaluate[th[t] /. sol], {t, 0, tmax}]

tmax = 100; , Null, th0 = 1.5; , Null, r0 = 0.3; , Null, vp0 = 0.; , Null, w = m*(vp^2/2) + Jperp*(eoc/m)*Bmod /. {vp -> vp0, th -> th0, r -> r0}, Null, Astarr = Ar + m*(vp/eoc)*hr; , Null, Astarth = Ath + m*(vp/eoc)*hth; , Null, Astarph = Aph + m*(vp/eoc)*hph; , Null, U = (1/m)*(w - Jperp*(eoc/m)*Bmod), Null, Brctr = (1/sqrtg)*(D[Aph, th] - D[Ath, ph]); , Null, Bthctr = FullSimplify[(1/sqrtg)*(D[Ar, ph] - D[Aph, r])]; , Null, Bphctr = FullSimplify[(1/sqrtg)*(D[Ath, r] - D[Ar, th])]; , Null, Bthcov = FullSimplify[gthth*Bthctr]; , Null, Bphcov = FullSimplify[gphph*Bphctr]; , Null, Bstarr = FullSimplify[Brctr + m*(vp/eoc)*(1/sqrtg)*(D[hph, th] - D[hth, ph])], Null, Bstarth = FullSimplify[Bthctr + m*(vp/eoc)*(1/sqrtg)*(D[hr, ph] - D[hph, r])], Null, Bstarph = FullSimplify[Bphctr + m*(vp/eoc)*(1/sqrtg)*(D[hth, r] - D[hr, th])], Null, Bstarpar = FullSimplify[hth*Bstarth + hph*Bstarph], Null, rdot = FullSimplify[(1/(Bstarpar*sqrtg))*(vp*(D[Aph, th] - D[Ath, ph]) + 2*U*(m/eoc)*(D[hph, th] - D[hth, ph]) + (m/eoc)*(hph*D[U, th] - hth*D[U, ph])) /. {th -> th[t], r -> r[t], vp -> vp[t]}], Null, thdot = FullSimplify[(1/(Bstarpar*sqrtg))*(vp*(D[Ar, ph] - D[Aph, r]) + 2*U*(m/eoc)*(D[hr, ph] - D[hph, r]) + (m/eoc)*(hr*D[U, ph] - hph*D[U, r])) /. {th -> th[t], r -> r[t], vp -> vp[t]}], Null, phdot = FullSimplify[(1/(Bstarpar*sqrtg))*(vp*(D[Ath, r] - D[Ar, th]) + 2*U*(m/eoc)*(D[hth, r] - D[hr, th]) + (m/eoc)*(hth*D[U, r] - hr*D[U, th])) /. {th -> th[t], r -> r[t], vp -> vp[t]}], Null, vpdot = FullSimplify[(1/(Bstarpar*sqrtg))*(D[U, r]*(D[Aph, th] + vp*(m/eoc)*D[hph, th]) + D[U, th]*(D[Ar, ph] + vp*(m/eoc)*D[hr, ph]) + D[U, ph]*(D[Ath, r] + vp*(m/eoc)*D[hth, r]) - D[U, r]*(D[Ath, ph] + vp*(m/eoc)*D[hth, ph]) - D[U, th]*(D[Aph, r] + vp*(m/eoc)*D[hph, r]) - D[U, ph]*(D[Ar, th] + vp*(m/eoc)*D[hr, th])) /. {th -> th[t], r -> r[t], vp -> vp[t]}], Null, repl = {h0th -> 0.99, h0ph -> Sqrt[1 - 0.99^2]}; , Null, eq1a = D[r[t], t] == rdot /. repl; , Null, eq2a = D[th[t], t] == thdot /. repl; , Null, eq3a = D[ph[t], t] == phdot /. repl; , Null, eq4a = D[vp[t], t] == vpdot /. repl; , Null, sol = Flatten[NDSolve[{eq1a, eq2a, eq4a, th[0] == th0, r[0] == r0, vp[0] == vp0}, {th[t], r[t], vp[t]}, {t, 0, tmax}, Method -> "BDF"]], Null, Plot[Evaluate[th[t] /. sol], {t, 0, tmax}], Null, Plot[Evaluate[r[t] /. sol], {t, 0, tmax}], Null, ParametricPlot[{R0 + r[t]*Cos[th[t]] /. sol, r[t]*Sin[th[t]] /. sol}, {t, 0, tmax}]

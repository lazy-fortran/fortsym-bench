(Ass1 = {Element[{omega0, kp, nu, Vt, tau}, Reals], Vt > 0, nu > 0, tau >= 0}; )*($Assumptions = Ass1)*(a[tau_, nu_] := (Vt^2/2)*(1 - Exp[-2*nu*tau]); )*(b[tau_, nu_] := 2*kp*(Vt^2/nu)*(1 - Exp[(-nu)*tau]); )*(c[tau_, nu_] := (I*(omega0 - omega) + kp^2*(Vt^2/nu))*tau; )*(argG[w1_, w2_, tau_, nu_] := I*(kp/nu)*(w1 - w2) - c[tau, nu] - (1/4/a[tau, nu])*(w1 - w2*Exp[(-nu)*tau] + I*b[tau, nu])^2; )*(G[w1_, w2_, tau_, nu_] := (1/Sqrt[4*Pi*a[tau, nu]])*Exp[argG[w1, w2, tau, nu]]; )

(dt = D[G[w1, w2, tau, nu], {tau, 1}]; )*(d1 = D[G[w1, w2, tau, nu], {w1, 1}]; )*(d2 = D[G[w1, w2, tau, nu], {w1, 2}]; )*(Simplify[Expand[dt + (I*omega0 + I*kp*w1 - nu)*G[w1, w2, tau, nu] - nu*Vt^2*d2 - nu*w1*d1]] /. omega -> 0)

Simplify[Series[arg[w1, w2, tau, nu], {nu, 0, 1}]], Null, Integrate[Exp[I*(omega - omega0 - kp*w)*tau], {tau, 0, Infinity}], Null, Null

W1[n_] := If[Mod[n, 2] == 0, Sqrt[2*Pi]*(n - 1)!!*Vt^(n + 1), 0]; 

W1[4]

(n = 4; )*(Int = Integrate[w^n*Exp[-w^2/2/Vt^2], {w, -Infinity, Infinity}])*Simplify[Int - W1[n]]*(Clear[n]; )

(AA[nu_] := I*(omega - omega0) - kp^2*(Vt^2/nu); )*(BB[alpha_, beta_, nu_] := Vt^2*(alpha + I*(kp/nu))*(beta + I*(kp/nu)); )*(CC[alpha_, beta_, nu_] := (Vt^2/2)*(alpha^2 + beta^2) - I*(kp/nu)*Vt^2*(alpha + beta) + kp^2*(Vt^2/nu^2); )*(gamma[a_, z_] := Gamma[a] - Gamma[a, z]; )*(J1k[alpha_, beta_, tau_, nu_] := Sqrt[2*Pi]*Vt*Exp[CC[alpha, beta, nu] + BB[alpha, beta, nu]*Exp[(-nu)*tau] + AA[nu]*tau]; )*(J1s[m_, n_, tau_, nu_] := FullSimplify[D[D[J1k[alpha, beta, tau, nu], {beta, n}], {alpha, m}] /. {alpha -> 0, beta -> 0}]; )*(J1ana[m_, n_, nu_] := FullSimplify[Integrate[J1s[m, n, tau, nu], {tau, 0, Infinity}]]; )*(J1d[m_, n_, alpha_, beta_, nu_] := Sqrt[2*Pi]*Vt*D[D[(Exp[CC[alpha, beta, nu]]/nu)*(-BB[alpha, beta, nu])^(AA[nu]/nu)*gamma[-AA[nu]/nu, -BB[alpha, beta, nu]], {alpha, m}], {beta, n}]; )*(J1der[m_, n_, nu_] := FullSimplify[J1d[m, n, alpha, beta, nu] /. {alpha -> 0, beta -> 0}]; )*(W2[m_, n_] := J1der[m, n, nu]; )

(Lim0 = Limit[J1s[0, 0, tau, nu], nu -> 0]; )*(Lim1 = Limit[J1s[1, 0, tau, nu], nu -> 0]; )*(Lim2 = Limit[J1s[2, 0, tau, nu], nu -> 0]; )*Simplify[Lim2 - Limit[J1s[1, 1, tau, nu], nu -> 0]]*(J10Lim = FullSimplify[Integrate[Lim0, {tau, 0, Infinity}]])*(J11Lim = FullSimplify[Integrate[Lim1, {tau, 0, Infinity}]])*(J12Lim = FullSimplify[Integrate[Lim2, {tau, 0, Infinity}]])

LimT = Limit[J1k[alpha, beta, tau, nu], nu -> 0], Null, JLimT = FullSimplify[Integrate[LimT, {tau, 0, Infinity}]]

dev = FullSimplify[tst - tst0 /. {alpha -> 0, beta -> 0}]

$MaxExtraPrecision = 1000; , Null, N[dev /. {kp -> 1/10, Vt -> 100/505, nu -> 2555/1000, omega -> 13457/1000, omega0 -> 1234/10}, 50], Null

(SubInt[alpha_, beta_, tau_, nu_] = Integrate[Exp[-w2^2/2/Vt^2 + alpha*w1 + beta*w2]*G[w1, w2, tau, nu], {w1, -Infinity, Infinity}, {w2, -Infinity, Infinity}])*(J1exa[m_, n_, nu_] := Integrate[Integrate[w1^m*w2^n*Exp[-w2^2/2/Vt^2]*G[w1, w2, tau, nu], {w1, -Infinity, Infinity}, {w2, -Infinity, Infinity}], {tau, 0, Infinity}]; )*Simplify[SubInt[alpha, beta, tau, nu] - J1k[alpha, beta, tau, nu]]

For[m = 0, m <= 3, m++, For[n = 0, n <= 3, n++, J1v[m, n] = J1ana[m, n, nu]; dev = FullSimplify[J1v[m, n] - J1exa[m, n, nu]]; Print[{m, n, J1v[m, n], dev}]; ]]; 

J1exaWTW[m_, n_, nu_] := Integrate[w1^m*Integrate[G[w1, w2, tau, nu]*w2^n*Exp[-w2^2/2/Vt^2], {w2, -Infinity, Infinity}, {tau, 0, Infinity}], {w1, -Infinity, Infinity}]; 

(SuL = {m -> 0, n -> 0, nu -> 10^4, Vt -> 10^8, kp -> 0.1, omega -> 10^3, omega0 -> 10^4}; )*(Aw = J1ana[0, 0, nu]; )*(Aw = N[Aw /. SuL, 20])*(Tw = NIntegrate[w1^m*G[w1, w2, tau, nu]*w2^n*Exp[-w2^2/2/Vt^2] /. SuL, {w1, -Infinity, Infinity}, {tau, 10^(-3), Infinity}, {w2, -Infinity, Infinity}, WorkingPrecision -> 500, PrecisionGoal -> 20]; )*N[Simplify[Tw - Aw], 20]

(rho = {(-rl)*Cos[phi2], rl*Sin[phi2]*(hz/r0), (-rl)*Sin[phi2]*(ht/r0)}; )*(xg = {r0, th2, z2}; )*(xc = xg + rho; )*(theta = {phi2, th2, z2}; )*(dxcdth = D[xc, {theta}]; )*MatrixForm[dxcdth]*(Fe = Exp[I*ks*rl*Sin[phi2]]; )*(a[n_] := (rho[[1]]^n/n!)*Fe*dxcdth)*(Ass2 = {Element[{rl, ks, ht, hz, r0, m0, omc}, Reals], rl >= 0, m0 > 0}; )*($Assumptions = Join[Ass1, Ass2])*(aF[n_, l_] := Integrate[Exp[(-I)*l*phi2]*a[n], {phi2, -Pi, Pi}]/2/Pi; )*(mod[p1_, p2_] := Sqrt[p1^2 + p2^2]; )*(arg[p1_, p2_] := ArcTan[p2/p1]; )*(JE[l_, p1_, p2_] := BesselJ[l, mod[p1, p2]*rl]*Exp[I*l*arg[p1, p2]])*(Der1[l_, m_, p1_, p2_] := D[JE[l, p1, p2], {p2, m}]; )*(Der2[l_, m_, p1_, p2_] := D[Der1[l, m, p1, p2], {p1, 1}]; )*(Dmat[l_, m_, ks_] := {{(-I)*Der2[l, m, p1, p2], 0, 0}, {(-I)*(hz/r0)*Der1[l, m + 1, p1, p2], Der1[l, m, p1, p2], 0}, {I*(ht/r0)*Der1[l, m + 1, p1, p2], 0, Der1[l, m, p1, p2]}} /. {p1 -> ks, p2 -> 0}; )*(aFa[n_, l_] := Refine[(I^n/n!)*Dmat[l, n, ks], ks >= 0]; )

For[n = 0, n <= 5, n++, For[l = -1, l <= 10, l++, an = aFa[n, l]; dev = FullSimplify[aF[n, l] - an]; Print[{n, l, an, dev}]; ]]; 

(Jk[b_, l_] := (-1)^b*D[(1/2/a)*Exp[-(p1^2 + p2^2 + q1^2 + q2^2)/4/a]*BesselI[l, mod[p1, p2]*(mod[q1, q2]/2/a)], {a, b}]; )*(JqSS[b_, l_] := Simplify[((m0*omc)^(b + 1)/2^b)*Jk[b, l] /. a -> (1/2)*(omc^2/Vt^2)]; )*(JqFS[b_, l_] := FullSimplify[((m0*omc)^(b + 1)/2^b)*Jk[b, l] /. a -> (1/2)*(omc^2/Vt^2)]; )*(DDk[m_, n_, m1_, n1_, b_, l_] := D[D[D[D[Exp[I*l*(arg[p1, p2] - arg[q1, q2])]*JqSS[b, l], {p2, n1}], {p1, m1}], {q2, n}], {q1, m}]; )*(DD[m_, n_, m1_, n1_, b_, l_] := Simplify[DDk[m, n, m1, n1, b, l] /. {q1 -> ks, q2 -> 0, p1 -> ks, p2 -> 0}]; )

(Jt1k[m_, n_, l] := D[D[Exp[I*l*arg[p1, p2]]*BesselJ[l, mod[p1, p2]*rl], {p2, n}], {p1, m}]; )*(Jt2k[m_, n_, l] := D[D[Exp[(-I)*l*arg[q1, q2]]*BesselJ[l, mod[q1, q2]*rl], {q2, n}], {q1, m}]; )*(Jtt[m_, n_, m1_, n1_, b_, l_] := Simplify[Jt1k[m1, n1, l]*Conjugate[Jt1k[m, n, l]]*J^b*Exp[(-omc/m0/Vt^2)*J] /. {q1 -> ks, q2 -> 0, p1 -> ks, p2 -> 0, rl -> Sqrt[2*(J/m0/omc)]}]; )

BesselRule1 = BesselI[(in_Integer /; in > 1) + l, z_] -> BesselI[l + in - 2, z] - 2*((l + in - 1)/z)*BesselI[l + in - 1, z], Null, BesselRule2 = BesselI[(in_Integer /; in < 0) + l, z_] -> BesselI[l + in + 2, z] + 2*((l + in + 1)/z)*BesselI[l + in + 1, z], Null, expr = BesselI[l - 10, z] + BesselI[l + 9, z] + BesselI[l, z], Null, tst = Simplify[expr //. {BesselRule1, BesselRule2}], Null, FullSimplify[tst - expr]

(* UNCONVERTED CELL *)

(* UNCONVERTED CELL *)

(T = NIntegrate[Jtt[2, 2, 2, 1, 2, l] /. {ks -> 0.5, omc -> 10^9, m0 -> 10^(-10), Vt -> 10^8, l -> 2}, {J, 0, Infinity}, WorkingPrecision -> 250, PrecisionGoal -> 20])*(A = N[DD[2, 2, 2, 1, 2, l] /. {ks -> 0.5, omc -> 10^9, m0 -> 10^(-10), Vt -> 10^8, l -> 2}, 20])*N[Simplify[T - A], 20]

$MaxExtraPrecision = 1000; , Null, N[dev /. {kp -> 3/10, Vt -> 10000/505, nu -> 2555/100, omega -> 13457/100, omega0 -> 1234/10}, 50], Null

IGammaRule = Gamma[(a_) + (n_Integer), z_] -> z^(a + n - 1)*Exp[-z] + (a + n - 1)*Gamma[a + n - 1, z], Null, GammaRule = Gamma[(z_) + (n_Integer)] -> (z + n - 1)*Gamma[z + n - 1], Null, Null

Mumax = 3; , Null, mm = 3; nn = 3; , Null, res = J1der[mm, nn, nu]; , Null, res = res //. {Sqrt[2*Pi] -> sqrt2p, kp^2*(Vt^2/nu^2) -> t1, ((-I)*nu*(omega - omega0) + kp^2*Vt^2)/nu^2 -> t2, (I*nu*(omega - omega0) - kp^2*Vt^2)/nu^2 -> -t2, Gamma[t2] -> Gamma[t2, t1] + gam, Exp[t1] -> Ex, t1^(-t2) -> 1/t1Pt2, omega - omega0 -> dom}; , Null, res = Simplify[res /. {gam -> (1/Ex)*(t1Pt2/t2)*F11, omega -> dom + omega0}], Null, res = Simplify[res //. {F11 -> 1 + t1/(1 + t2) + (t1^2/(1 + t2)/(t2 + 2))*(1 + F11m), t2 -> t1 - I*(dom/nu), t1 -> kp^2*(Vt^2/nu^2)}], Null, res = FullSimplify[res/(sqrt2p*(Vt^{mm + nn + 1}/nu)) //. {dom -> x2*nu, kp -> x1*(nu/Vt)}], Null, res = res //. {x1^(p_)?Positive -> x1[p], x2^(p_)?Positive -> x2[p]}, Null

(* UNCONVERTED CELL *)

Limit[res, dom -> (-I)*(nu + kp^2*(Vt^2/nu))]

dev = Expand //@ Simplify[a1 - a2] //. {IGammaRule, GammaRule}, Null, Simplify[dev]

Clear[Dsrm]

(Mumax = 3; )*(Numax = 3; )*(For[m = 0, m <= Mumax, m++, For[n = 0, n <= m, n++, res = J1der[m, n, nu]; res = res //. {Sqrt[2*Pi] -> sqrt2p, kp^2*(Vt^2/nu^2) -> t1, ((-I)*nu*(omega - omega0) + kp^2*Vt^2)/nu^2 -> t2, (I*nu*(omega - omega0) - kp^2*Vt^2)/nu^2 -> -t2, Gamma[t2] -> Gamma[t2, t1] + gam, Exp[t1] -> Ex, t1^(-t2) -> 1/t1Pt2, omega - omega0 -> dom}; res = Simplify[res /. {gam -> (1/Ex)*(t1Pt2/t2)*F11}]; Print[res]; res = Simplify[res //. {F11 -> 1 + t1/(1 + t2) + (t1^2/(1 + t2)/(t2 + 2))*(1 + F11m), t2 -> t1 - I*(dom/nu), t1 -> kp^2*(Vt^2/nu^2)}]; res = FullSimplify[res/(sqrt2p*(Vt^{m + n + 1}/nu)) //. {dom -> x2*nu, kp -> x1*(nu/Vt)}]*Print[res]; ]]; )

Null

Series[1/(1 + (j0 + j1)*x), {x, 0}]

Expand[Normal[Series[1/(1 + (j0 + j1*w)*x), {x, 0, 3}]], w] /. x -> 1

Series[1/(1 + x), {x, 0, 2}]

dev = gamma[a, z] - (z^a/a)*Exp[-z]*Hypergeometric1F1[1, 1 + a, z], Null, FullSimplify[dev], Null, N[dev /. {a -> 10 - 100*I, z -> -200 - 299*I}, 50]

Null

t1[nu_] := kp^2*(Vt^2/nu^2); , Null, t2[nu_] := (-I)*((omega - omega0)/nu) + t1[nu]; , Null, W00[nu_] := Sqrt[2*Pi]*Vt*(Hypergeometric1F1[1, 1 + t2[nu], t1[nu]]/nu/t2[nu]); 

N[W00[nu] /. {kp -> 1/1000, Vt -> 10^8, omega -> 10, omega0 -> 10^3, nu -> 20}, 20]

N[CN /. {kp -> 1/1000, Vt -> 10^8, omega -> 10, omega0 -> 10^3, nu -> 100000}, 20]

N[res /. {kp -> 1/100000, Vt -> 10^8, omega -> 10^4, omega0 -> 10^5, nu -> 1}, 20]

LimT = Limit[J1k[alpha, beta, tau, nu], nu -> 0], Null, JLimT = FullSimplify[Integrate[LimT, {tau, 0, Infinity}]], Null

JLimT = Sqrt[2*Pi]*Vt*((E^(((omega - omega0)*(-omega + omega0 + 2*(alpha + beta)*kp*Vt^2))/(2*kp^2*Vt^2))*Sqrt[Pi/2]*(1 - I*Erfi[((-omega + omega0 + (alpha + beta)*kp*Vt^2)*Abs[kp])/(Sqrt[2]*kp^2*Vt)]))/(Vt*Abs[kp]))

(J1dNC[m_, n_, alpha_, beta_, nu_] := D[D[JLimT, {alpha, m}], {beta, n}]; )*(J1derNC[m_, n_, nu_] := FullSimplify[J1dNC[m, n, alpha, beta, nu] /. {alpha -> 0, beta -> 0}]; )

$MaxExtraPrecision = 1000; , Null, N[J1derNC[1, 2, nu] /. {kp -> 1/1000, Vt -> 10^8, omega -> 10, omega0 -> 10^3}, 20], Null, t2v = t2[nu] /. {kp -> 1/1000, Vt -> 10^8, omega -> 10, omega0 -> 10^3, nu -> 12}; , Null, sqrt2pv = Sqrt[2*Pi]; , Null, F11v = Hypergeometric1F1[1, 1 + t2[nu], t1[nu]] /. {kp -> 1/1000, Vt -> 10^8, omega -> 10, omega0 -> 10^3, nu -> 12}; , Null, N[W2arr[1, 2] //. {kp -> 1/1000, Vt -> 10^8, dom -> omega - omega0, omega -> 10, omega0 -> 10^3, nu -> 12, t2 -> t2v, sqrt2p -> sqrt2pv, F11 -> F11v}, 20], Null, Null

res = J1derNC[1, 0, nu], Null, res = FullSimplify[res /. {ErfiRule}], Null

ErfiRule = Erfi[x_] -> (-I)*(W[x]*Exp[x^2] - 1), Null, Get["Algebra`Horner`"]; , Null, Dstrm = OpenWrite["/home/hare/KiLCA-CE/tensor/W2_nc.t90"]; , Null, SetOptions[Dstrm, FormatType -> OutputForm]; , Null, Mumax = 1; , Null, Numax = 3; , Null, Write[Dstrm, StringJoin["!complex(dpc), dimension(0:", ToString[Mumax], ", 0:", ToString[Numax], ", -Nmax:Nmax) :: W2"]]; , Null, For[m = 0, m <= Mumax, m++, For[n = 0, n <= Numax, n++, res = J1derNC[m, n, nu]; res = FullSimplify[res //. {ErfiRule}]; res = Simplify[Assuming[kp > 0, Simplify[res]]]; res = Simplify[res //. {omega - omega0 -> z*Sqrt[2]*kp*Vt, kp -> dom/z/Sqrt[2]/Vt}]; res = FullSimplify[res //. {W[z] -> (I/Sqrt[Pi])*(1/z + 1/2/z^3 + Wm/z^5)}]; res = res /. {z -> z[1]}; res = Expand[res, z]; res = res /. {z[1]^(p_)?Positive -> z[p], z[1]^(p_)?Negative -> z[p]}; res = res /. {Vt[1]^(p_)?Positive -> Vt[p], Vt[1]^(p_)?Negative -> 1/Vt[-p]}; res = FullSimplify[res]; Print[m, ", ", n, ", ", res]; SetOptions[Dstrm, FormatType -> OutputForm]; Write[Dstrm, ""]; Write[Dstrm, "W2(", m, ",", n, ",l) = "]; SetOptions[Dstrm, FormatType -> InputForm]; Write[Dstrm, res]; ]]; , Null, Close[Dstrm]; , Null, Clear[m, n, Mumax, Numax]; 

Null

(Wfunc1[z_] := Exp[-z^2]*(skp + I*Erfi[z]); )*(Wfunc2[z_] := FullSimplify[skp*Exp[-z^2]*Erfc[(-skp)*I*z]]; )*FullSimplify[Wfunc1[z] - Wfunc2[z] /. skp -> 1]*FullSimplify[Wfunc1[z] - Wfunc2[z] /. skp -> -1]

Res = FullSimplify[Normal[Series[Wfunc2[1/tt] /. skp -> 1, {tt, 0, 24}]]]; , Null, res1 = FullSimplify[Res /. {tt -> 1/z, skp -> 1}], Null, Res = FullSimplify[Normal[Series[Wfunc2[1/tt] /. skp -> -1, {tt, 0, 24}]]]; , Null, res2 = FullSimplify[Res /. {tt -> 1/z, skp -> -1}], Null

ee = Assuming[z < 0, Simplify[res1]], Null, zv = 100*I; , Null, fac = 0; , Null, r1 = N[res1 /. z -> zv, 500]; , Null, r2 = N[fac*skp*Exp[-z^2] + ee /. {z -> zv, skp -> 1}, 500]; , Null, re = N[Wfunc2[zv] /. skp -> 1, 500], Null, N[r1 - re, 100], Null, N[r2 - re, 100], Null

s1 = {{1, 0, 0}, {0, 0, 0}, {0, 0, 0}}; , Null, MatrixForm[s1], Null, s2 = {{0, 0, 0}, {1, 0, 0}, {1, 0, 0}}; , Null, MatrixForm[s2], Null, A[n_] := {{-(1 - KroneckerDelta[n, flreo]), 0, 0}, {-hz/r, 1, 0}, {ht, 0, 1}}; , Null, MatrixForm[A[n]], Null, dimF = {1, 4, 4}; , Null, MatrixForm[dimF], Null, Fs1 = {{0, Null, Null, Null}, {0, 1, 0, 2}, {0, 1, 0, 2}}; , Null, MatrixForm[Fs1], Null, Fs2 = {{0, Null, Null, Null}, {0, 0, 1, 0}, {0, 0, 1, 0}}; , Null, MatrixForm[Fs2], Null, FF = {{m0*r*omc^2, Null, Null, Null}, {hz*var1, (-m0)*(dVz - omc*ht), hz*var2, (-m0)*dvTz}, {(-r)*ht*var1, m0*(dVt + omc*r*ht), (-r)*ht*var2, m0*dvTt}}; , Null, MatrixForm[FF], Null, M00v = r*ks*var1, Null, M01v = r*ks*var2, Null, M10v = m0*(-dkxV + r*kp*omc), Null, M20v = (-m0)*(ks + r*dksvT), Null, dimG = {4, 6, 6}; , Null, MatrixForm[dimG], Null, Gs1 = {{0, 0, 0, 0, Null, Null}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}}; , Null, MatrixForm[Gs1], Null, Gs2 = {{0, 1, 0, 2, Null, Null}, {0, 1, 0, 2, 1, 3}, {0, 1, 0, 2, 1, 3}}; , Null, MatrixForm[Gs2], Null, Gs3 = {{0, 1, 0, 2, Null, Null}, {0, 1, 0, 2, 1, 3}, {0, 1, 0, 2, 1, 3}}; , Null, MatrixForm[Gs2], Null, GGa := {{m0*r*omc^3*l + omc*M00, omc*M01, omc*M10, omc*M20}, {(m0*r*omc^2*l + M00)*Vth, Vth*M01, Vth*M10 + (ht/r)*(M00 + m*r*omc^2*l), Vth*M20 + (ht/r)*M10, (ht/r)*M01, (ht/r)*M20}, {(m0*r*omc^2*l + M00)*Vz, Vz*M01, Vz*M10 + hz*(M00 + m*r*omc^2*l), Vz*M20 + hz*M10, hz*M01, hz*M20}}; , Null, MatrixForm[GGa], Null, GG[l_] := GGa /. {M00 -> M00v, M01 -> M01v, M10 -> M10v, M20 -> M20v}; , Null, MatrixForm[GG[l]], Null, dimI = {1, 2, 2}; , Null, MatrixForm[dimI], Null, Is1 = {{0, Null}, {0, 1}, {0, 1}}; , Null, MatrixForm[Is1], Null, II = {{omc_, Null}, {Vth, ht/r}, {Vz, hz}}; , Null, MatrixForm[II], Null, kmat[k_, j_, n1_, n2_, l_] := (1/(2*Pi)^(3/2))*(n0/m0^3/vT^5)*(-1)^(n1 + 1)*(I^(n1 + n2)/n1!/n2!)*Sum[(-1)^(s1[[k,alpha]] + s2[[k,alpha]])*I^(s1[[k,alpha]] + s2[[k,alpha]] + s1[[j,beta]] + s2[[j,beta]])*A[n1][[k,alpha]]*A[n2][[j,beta]]*(I*Sum[II[[alpha,i1]]*GG[l][[beta,i3]]*W2[Gs1[[beta,i3]] + Is1[[alpha,i1]], Gs2[[beta,i3]], l]*D[s1[[k,alpha]], s2[[k,alpha]] + n1, s1[[j,beta]], s2[[j,beta]] + n2, Gs3[[beta,i3]], l], {i3, 1, dimG[[beta]]}, {i1, 1, dimI[[alpha]]}] - Sum[II[[alpha,i1]]*FF[[beta,i3]]*W1[Fs1[[beta,i2]] + Is1[[alpha,i1]]]*D[s1[[k,alpha]], s2[[k,alpha]] + n1, s1[[j,beta]], s2[[j,beta]] + n2, Fs2[[beta,i3]], l], {i1, 1, dimF[[beta]]}, {i1, 1, dimI[[alpha]]}]), {alpha, 1, 3}, {beta, 1, 3}]; , Null

kmat[1, 1, 0, 0, 0]

Series[BesselI[0, x^2]*Exp[-x^2], {x, 0, 5}], Null, Series[BesselI[1, x^2]*Exp[-x^2], {x, 0, 5}], Null, Series[BesselI[2, x^2]*Exp[-x^2], {x, 0, 5}]

A[l, x_] := BesselI[l, x]*Exp[-x]; , Null, Series[(l^2/x^2)*A[l, x^2] - 2*x^2*(D[A[l, y], y] /. y -> x^2) /. l -> 3, {x, 0, 0}]

I[alpha_, i1_] := 1

N[(z/b)^907]

Null

Null

P = Array[f, 3], Null, P[[1]] = 1, Null, P[[2]] = 2, Null, P[[3]] = 3, Null, MatrixForm[P], Null

df0dJ := (-f0/T)*{Z00[[1]] + Z01[[1]]*J + Z10[[1]]*w1 + Z20[[1]]*w1^2}

df0dJ

Null

N[z], Null, z = 2374064/10^2; , Null, b = N[1 + z - (1202121/10^5)*I]

N[17592693789899024881*(I/10^20)], Null, z = N[55210145923239827004/10^21]

F11as[b_, z_] := (-(b - 1)/z)*Sum[Pochhammer[2 - b, n]/(-z)^n, {n, 0, 50}] + Gamma[b]*Exp[z]*z^(1 - b); , Null, F11in[b_, z_] := (b - 1)*NIntegrate[Exp[z*t]*(1 - t)^(b - 2), {t, 0, 1}, AccuracyGoal -> 50]; , Null, F11ku[b_, z_] := Sum[z^n/Pochhammer[b, n], {n, 0, Ceiling[Abs[-20/Log[10, z/b]]]}]; 

z = 22030755774330544227*(10^5/10^20); , Null, b = 1 + z - 39812023159305316433*(I/10^19); , Null, (re = N[(Hypergeometric1F1[1, b, z] - 1 - z/b)*b*((b + 1)/z^2) - 1, 20])*Null*Null, Null, (re - rk)/re

(0.18332036465894694288`19.263210712467636*E + 3*0.38971877295606653924`19.590751326487737*E + 1)*(0.14555258906303416211`19.163019934994953*E + 3*0.3787863454742240954`19.578394315125113*E + 1)

(* UNCONVERTED CELL *)

z

FullSimplify[Gamma[ff]/Gamma[ff - 1]]

Hypergeometric1F1[1, b, 0]

N[Hypergeometric1F1[1, -1, 1]]

Gamma[-2]

ContinuedFraction[Hypergeometric1F1[1, b, z], 10]

(n = 500; )*(t = (n + b)*(z/(n + 1 + b + z)); )*For[i = n - 1, i >= 0, i--, (t = (i + b)*(z/((i + 1 + b + z) - t)); ); ]*(f = b/(b - t); )

N[f /. {b -> 10^5 + I*10^6, z -> 10^5}, 50], Null, N[Hypergeometric1F1[1, 1 + b, z] /. {b -> 10^5 + I*10^6, z -> 10^5}, 50]

$MaxExtraPrecision = 500; , Null, N[Hypergeometric1F1[1, 1 + b, z] /. {b -> 10^2 - I*10, z -> 10^2}, 50]

N[f /. {b -> 10^2 - I*10, z -> 10^2}, 20]

N[Sum[z^n/Pochhammer[1 + b, n], {n, 0, 100}] /. {b -> 10^2 - I*10, z -> 10^2}, 20]

n = 2; , Null, t = n*(z/(b + n - z)); , Null, For[i = n - 1, i > 0, i--, t = i*(z/((b + i - z) + t)); Null; ], Null, g = b/(b - z + t); 

L = {b -> 10^2 - I*10, z -> 10^2}, Null, er = N[Hypergeometric1F1[1, 1 + b, z] /. L, 50], Null, fr = N[f /. L, 20], Null, (fr - er)/er, Null, gr = N[g /. L, 20], Null, (gr - er)/er, Null, Null

Null

g = b/(b - z + z/(1 + b - z + (2*z)/(2 + b - z + R)))

Simplify[Expand[(z^2*b - z^3 - b)*(2 + b - z + R2) + 2*z^3]]

Simplify[ExpandAll[((g /. b -> b - 1) - 1 - z/b)*b*((b + 1)/z^2) - 1]]

h = Sum[z^n/Pochhammer[b, n], {n, 0, 3}]

Get["KiLCA-CE/tensor/F_factors.txt"]

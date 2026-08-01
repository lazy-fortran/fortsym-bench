(G[u1_, u2_, tau_] := (-Sqrt[2*Pi]^(-1))*(1/Sqrt[1 - Exp[-2*tau]])*Exp[I*x1*(u1 - u2) - (x1^2 - I*x2)*tau - (1/2/(1 - Exp[-2*tau]))*(u1 - u2*Exp[-tau] + 2*I*x1*(1 - Exp[-tau]))^2])*(Kmn[u1_, u2_, tau_] := FullSimplify[Exp[x*u1 + y*u2]*G[u1, u2, tau]*Exp[(-2^(-1))*u2^2]*Exp[(gamma/2)*(u1^2 + u2^2)]])*(Kmn[tau_] := FullSimplify[Integrate[Kmn[u1, u2, tau], {u1, -Infinity, Infinity}, {u2, -Infinity, Infinity}]])

Kmn[u1, u2, tau], Null, Karg = Collect[Kmn[u1, u2, tau][[2,2]], {u1, u2}], Null, CL = FullSimplify /@ CoefficientList[Karg, {u1, u2}], Null, MatrixForm[CL], Null, AL = {{AL11, AL12, AL13}, {AL21, AL22, 0}, {AL31, 0, 0}}, Null, arg = Sum[AL[[i,j]]*u1^(i - 1)*u2^(j - 1), {i, 1, 3}, {j, 1, 3}], Null, RL = {AL11 -> CL[[1,1]], AL12 -> CL[[1,2]], AL13 -> CL[[1,3]], AL21 -> CL[[2,1]], AL22 -> CL[[2,2]], AL31 -> CL[[3,1]]}, Null, test = Simplify[(arg /. RL) - Karg], Null, subint = -Exp[arg]/2/Sqrt[Pi]/Sqrt[Exp[-tau]*Sinh[tau]], Null, test = Simplify[(subint /. RL) - Kmn[u1, u2, tau]], Null, kermn = Integrate[Exp[arg], {u1, -Infinity, Infinity}, {u2, -Infinity, Infinity}], Null, Ker = FullSimplify[kermn, Re[-(AL22^2/AL13) + 4*AL31] < 0], Null, Ker = Simplify[-(Ker //. RL)/2/Sqrt[Pi]/Sqrt[Exp[-tau]*Sinh[tau]], tau >= 0], Null, KerF = FullSimplify[TrigToExp[Numerator[Ker]]]/Sqrt[Simplify[TrigToExp[Denominator[Ker]^2]]], Null, arg = KerF[[2,2]]; , Null, iden = KerF[[3]]; , Null, argnum = Numerator[arg]; , Null, argden = Denominator[arg]; , Null, KerR = -2*Sqrt[Pi]*Exp[argnum/argden]*iden; , Null, FullSimplify[KerR - KerF], Null, arg = Collect[argnum*Exp[-2*tau], Exp[tau], Simplify]/Collect[argden*Exp[-2*tau], Exp[tau], Simplify]; , Null, arg = Collect[Simplify[arg], {tau, x1, x2}, Simplify]; , Null, KerR = -2*Sqrt[Pi]*Exp[arg]*iden; , Null, FullSimplify[KerR - KerF]

II[m_, n_] := Collect[Simplify[D[D[KerR, {x, m}], {y, n}] /. {x -> 0, y -> 0}], {tau, x1, x2}, Simplify]; , Null, II[m_, n_, l_] := Collect[Simplify[(D[D[KerR, {x, m}], {y, n}] /. {x -> 0, y -> 0})/(1 + I*x4*tau)^(l + 1)], {tau, x1, x2}, Simplify]; 

KerR, Null, I00 = II[0, 0], Null, I01 = II[0, 1], Null, I02 = II[0, 2], Null, I03 = II[0, 3], Null, I11 = II[1, 1], Null, I12 = II[1, 2], Null, I13 = II[1, 3], Null, I22 = II[2, 2], Null, I23 = II[2, 3], Null, I33 = II[3, 3]

Omegap = omc, Null, Omegat = ht*up + VEt - (hz/omc)*(ht*up + VEt)^2 + hz*(domc/m0/omc/r0)*Jperp, Null, Omegaz = hz*up + VEz + ht*(r0^2/omc)*(ht*up + VEt)^2 - ht*r0*(domc/m0/omc)*Jperp, Null, Omegatb = Collect[Omegat /. {up -> Vp + ub*VT*s, Jperp -> (1/2)*m0*(VT^2/omc)*L^2}, {ub, L}, FullSimplify], Null, Omegazb = Collect[Omegaz /. {up -> Vp + ub*VT*s, Jperp -> (1/2)*m0*(VT^2/omc)*L^2}, {ub, L}, FullSimplify], Null, COmegatb = FullSimplify /@ CoefficientList[Omegatb, {ub, L}]; , Null, COmegazb = FullSimplify /@ CoefficientList[Omegazb, {ub, L}]; , Null, MatrixForm[COmegatb], Null, MatrixForm[COmegazb]

Null

mdf0dJ = P00 + P02*L^2 + P12*u*L^2 + P10*u + P20*u^2 + P30*u^3, Null, Omegab = Q00 + Q10*u + Q20*u^2 + Q02*L^2, Null, df0dJb = Z00 + Z02*L^2 + Z12*u*L^2 + Z10*u + Z20*u^2 + Z30*u^3, Null, mOMEGAmomega = R00 + R10*u + R20*u^2 + R02*L^2, Null, F = Collect[mdf0dJ*Omegab - mOMEGAmomega*df0dJb, {u, L}, Simplify], Null, MatrixForm[CoefficientList[F, {u, L}]], Null

Integrate[z^(2*d + 1)*BesselJ[l, k*1*z]*BesselJ[l, k2*z]*Exp[(-2^(-1))*C*z^2] /. d -> 0, {z, 0, Infinity}]

JJ[l_, k_, z_] := Sum[z^(l + 2*b)*((-1)^b/b!/(l + b)!/2^(l + 2*b))*k^(l + 2*b), {b, 0, 6}]

JJ[0, k, z], Null, Normal[Series[BesselJ[0, k*z], {z, 0, 10}]], Null, Normal[Series[BesselJ[0, k*z], {z, 0, 10}]]

Table[(-1)^b/b!/(l + b)!/2^(l + 2*b), {b, 0, 6}] /. l -> l

{1/(2^l*l!), -(2^(-2 - l)/(1 + l)!), 2^(-5 - l)/(2 + l)!, -(2^(-7 - l)/(3*(3 + l)!)), 2^(-11 - l)/(3*(4 + l)!), -(2^(-13 - l)/(15*(5 + l)!)), 2^(-16 - l)/(45*(6 + l)!)}, Null, -1!

2/0!, Null, 2/(-1)!, Null

NIntegrate[z^(2*d + 1)*BesselJ[l, k1*z]*BesselJ[l, k2*z]*Exp[(-2^(-1))*C*z^2] /. {d -> 2, l -> 0, k1 -> 1, k2 -> 0.5, C -> 1/2}, {z, 0, Infinity}], Null, NIntegrate[z^(2*d + 1)*JJ[l, k1, z]*JJ[l, k2, z]*Exp[(-2^(-1))*C*z^2] /. {d -> 2, l -> 0, k1 -> 1, k2 -> 0.5, C -> 1/2}, {z, 0, Infinity}]

Integrate[z^(2*d + 1)*Exp[(-2^(-1))*C*z^2], {z, 0, Infinity}]

Null

Null

DDk[m_, n_, l_, b_, rho_] := D[D[Exp[I*l*ArcTan[k2/k1]]*(rho*Sqrt[k1^2 + k2^2])^(l + 2*b), {k1, m}], {k2, n}]/rho^(m + n); , Null, DD[m_, n_, l_, b_, rho_] := FullSimplify[DDk[m, n, l, b, rho] /. {k1 -> ks, k2 -> 0}, {ks > 0, rho > 0}], Null, Print["0 ", "0 ", FullSimplify[DD[0, 0, l, b, rho]]], Null, Print["0 ", "1 ", FullSimplify[DD[0, 1, l, b, rho]]], Null, Print["0 ", "2 ", FullSimplify[DD[0, 2, l, b, rho]]], Null, Print["0 ", "3 ", FullSimplify[DD[0, 3, l, b, rho]]], Null, Print["0 ", "4 ", FullSimplify[DD[0, 4, l, b, rho]]], Null, Print["0 ", "5 ", FullSimplify[DD[0, 5, l, b, rho]]], Null, Print["0 ", "6 ", FullSimplify[DD[0, 6, l, b, rho]]], Null, Print["1 ", "0 ", FullSimplify[DD[1, 0, l, b, rho]]], Null, Print["1 ", "1 ", FullSimplify[DD[1, 1, l, b, rho]]], Null, Print["1 ", "2 ", FullSimplify[DD[1, 2, l, b, rho]]], Null, Print["1 ", "3 ", FullSimplify[DD[1, 3, l, b, rho]]], Null, Print["1 ", "4 ", FullSimplify[DD[1, 4, l, b, rho]]], Null, Print["1 ", "5 ", FullSimplify[DD[1, 5, l, b, rho]]], Null, Print["1 ", "6 ", FullSimplify[DD[1, 6, l, b, rho]]]

FullSimplify[((-1)^b/b!/(l + b)!)*(1/2)^(l + 2*b)*DD[0, 0, l, b, rho]] /. l -> L, Null, FullSimplify[((-1)^b/b!/(l + b)!)*(1/2)^(l + 2*b)*DD[0, 0, l, b, rho]] /. l -> -L

(* UNCONVERTED CELL *)

-4.425094388027373/1000

Imnl = (1/(1 + 2*alpha)^((3 + 1 + 5)/2))*II[1, 5, 19]; , Null, res = NIntegrate[Simplify[Imnl //. {gamma -> alpha/(1 + 2*alpha), alpha -> Sqrt[1/4 - I*x3] - 1/2, x1 -> 24.963007776733463/(1 + 2*alpha)^(3/2), x2 -> -11.620797243229703/(1 + 2*alpha) + I*gamma, x3 -> -7.685579463339158/100, x4 -> -4.425094388027373/100/(1 + 2*alpha)}], {tau, 0, Infinity}, {PrecisionGoal -> 20, MaxRecursion -> 100, WorkingPrecision -> 32}]; , Null, N[res, 20]

DDkexa[m1_, n1_, m2_, n2_, l_, nu_, rho_] := D[D[D[D[Exp[(-I)*l*(ArcTan[q2/q1] - ArcTan[p2/p1])]*z^(2*nu + 1)*BesselJ[l, rho*Sqrt[q1^2 + q2^2]*z]*BesselJ[l, rho*Sqrt[p1^2 + p2^2]*z]*Exp[-z^2/2], {q1, m1}], {q2, n1}], {p1, m2}], {p2, n2}]; , Null, DDexa[m1_, n1_, m2_, n2_, l_, nu_, rho_] := (-1)^(m1 + n1)*I^(m1 + n1 + m2 + n2)*FullSimplify[DDkexa[m1, n1, m2, n2, l, nu, rho] /. {q1 -> ks, q2 -> 0, p1 -> ks, p2 -> 0}, {ks > 0, rho > 0}]; , Null, BJE[l_, z_] = Normal[Series[BesselJ[l, z], {z, 0, 16}]]; , Null, DDkapp[m1_, n1_, m2_, n2_, l_, nu_, rho_] := D[D[D[D[Exp[(-I)*l*(ArcTan[q2/q1] - ArcTan[p2/p1])]*z^(2*nu + 1)*BesselJ[l, rho*Sqrt[q1^2 + q2^2]*z]*BesselJ[l, rho*Sqrt[p1^2 + p2^2]*z]*Exp[-z^2/2] /. BesselJ -> BJE, {q1, m1}], {q2, n1}], {p1, m2}], {p2, n2}]; , Null, DDapp[m1_, n1_, m2_, n2_, l_, nu_, rho_] := (-1)^(m1 + n1)*I^(m1 + n1 + m2 + n2)*FullSimplify[DDkapp[m1, n1, m2, n2, l, nu, rho] /. {q1 -> ks, q2 -> 0, p1 -> ks, p2 -> 0}, {ks > 0, rho > 0}]; 

res = DDexa[1, 2, 0, 5, l, nu, rho], Null, resI = res //. {l -> 3, nu -> 2, ks -> -(3/4)/rho, rho -> 125/1000}, Null, resF = NIntegrate[resI, {z, 0, Infinity}, {PrecisionGoal -> 12, MaxRecursion -> 500, WorkingPrecision -> 32}], Null, resA = NIntegrate[N[resI /. BesselJ -> BJE], {z, 0, Infinity}], Null, resE = II[1, 6, 1, 6, l, nu, rho]; , Null, resE = N[resE //. {l -> 1, nu -> 2, ks -> 2/4/rho, rho -> 125/1000}, 30], Null, Null

0. + 0.000011407165469043465*I, Null, 1.1407160779386467*E - 5

0. - 2.862886153500454*^-7*I, Null, -2.862894556040405*E - 7

-1.874662847007018*E - 7, Null, -1.874662847007018*E - 7, Null

1.859654244981495*E - 7

1.8596793598827976*E - 7

2.2668273424305276*E + 0

0.4267576280084742456894633411282435978624531561169706699859`30., Null, 4.2246815874454535*E - 5

0.0000422468158744545356363402005336622741879697872194843768`30., Null, 4.2246815874454535*E - 5

1.0051527725652589301870776305146547283307097417659801`30.*^-6, Null, 1.005152772565259*E - 6

3.7893621523937844*^-6

3.789362158221311*E - 6

0.7910171621392972

0.7910171621397237

II[m1_, n1_, m2_, n2_, l_, nu_, rho_] := Sum[((nu + Abs[l] + b1 + b2)!/b1!/(Abs[l] + b1)!/b2!/(Abs[l] + b2)!)*(-1)^(b1 + b2)*2^(nu - Abs[l] - b1 - b2)*rho^(m1 + n1 + m2 + n2)*Conjugate[DD[m1, n1, l, b2, rho]]*DD[m2, n2, l, b1, rho], {b1, 0, 8}, {b2, 0, 8}]; 

res = DDapp[1, 2, 1, 2, l, nu, rho], Null, resI = res //. {l -> 0, nu -> 0, ks -> 0.5/rho, rho -> 0.125}, Null, resF = NIntegrate[resI, {z, 0, Infinity}], Null

0.00038328941279699226

1.8596793597987904*^-7

0. + 0.0789854396037407*I, Null, 7.51358905758163166801249400001032419`35.87584743841101*E - 2

0.3612562515613973752754395264409249766622421725948833757997`31.95342602493601*I

0.36125625152421226*I

0.361245899113498954607170448588428345`35.55780292565392, Null, 0.361245963135072141402787372914511573`35.55780300262147, Null, 0.3612459631350721441146423460811320930000000000000000000001`35.55780300262147

0.6209399612705205914810874680153235050000000000000000000001`35.79304961024189

0.36125625152421226*I

0.36125625152421226*I, Null, 0.3612459631350724

0.20965789825534836, Null, 0.2096013162213115, Null, 0.20850246699046693

0.20965789825534836, Null, 0.36229552808345034, Null, N[125/1000]

2.2699197556097603, Null, 2.269919755606601, Null, 2.269919755606601

1.6451581539676132

0.7262522366644598

1.6451581539256495

Null

0.16667612198462456, Null, 0.1666761219846192

Null

0.16667359980292998, Null, 0.1666761219846192

0.6157526998283018, Null, 0.6157526998923262, Null, 0.6157518759722223

(* UNCONVERTED CELL *)

0.31494911573735285

(* UNCONVERTED CELL *)

0.4657596075936506

0.4656439887152777, Null, 0.46575972376727803

NIntegrate[resI /. BesselJ -> BJE, {z, 0, Infinity}]

(* UNCONVERTED CELL *)

0.5413316667518368103218632116362916952602854380524809089271`32.

0.5413316667518376

resI /. BesselJ -> BJE

N[BJE[0, z]]

FullSimplify[(nu + l + b1 + b2)!/b1!/(l + b1)!/b2!/(l + b2)!, Element[{nu, l, b1, b2}, Integers]]

Print["0 ", "1 ", FullSimplify[DD[1, 2, l, b, rho] /. {b -> 1}]], Null, Print["0 ", "1 ", FullSimplify[DD[1, 2, l, 0, rho]]]

PP[m1_, n1_, m2_, n2_, l_, nu_, rho_, b1_, b2_] := Print[((nu + Abs[l] + b1 + b2)!/b1!/(Abs[l] + b1)!/b2!/(Abs[l] + b2)!)*(-1)^(b1 + b2)*2^(nu - Abs[l] - b1 - b2)*rho^(m1 + n1 + m2 + n2)*Conjugate[DD[m1, n1, l, b2, rho]]*DD[m2, n2, l, b1, rho]]; 

PP[0, 0, 0, 0, 0, 0, rho, 1, 1] /. {}

KerR/(1 + I*x4*tau)^(l + 1)

RS = FullSimplify[(-(z - 1)^(-1))*(KerR/(1 + I*x4*tau)^(l + 1)) //. tau -> -Log[z - 1]], Null, Series[RS, {gamma, 0, 0}], Null

aaa = Simplify[((1 - E^(-tau))*(-1 + 2*gamma)*x1^2)/(-1 + gamma + gamma/E^tau) + tau*(-x1^2 + I*x2) + (I*(1 - E^(-tau))*x1*(x + y))/(-1 + gamma + gamma/E^tau) + ((2*x*y)/E^tau - (-1 + gamma)*(x^2 + y^2) + (gamma*(x^2 + y^2))/E^(2*tau))/(2*((-1 + gamma)^2 - gamma^2/E^(2*tau)))]

aaa = Simplify[((2*x*y)/E^tau - (-1 + gamma)*(x^2 + y^2) + (gamma*(x^2 + y^2))/E^(2*tau))/(2*((-1 + gamma)^2 - gamma^2/E^(2*tau)))]

Null

SubFunc[tau_, l_, x_, y_] := (-Sqrt[2*Pi]/(1 + I*x4*tau)^(l + 1)/Sqrt[(gamma - 1)^2 - gamma^2*Exp[-2*tau]])*Exp[(-x1^2 + I*x2)*tau + ((1 - Exp[-tau])/(gamma - 1 + gamma*Exp[-tau]))*x1*((2*gamma - 1)*x1 + (x + y)*I) + (gamma*(x^2 + y^2)*Exp[-2*tau] + 2*x*y*Exp[-tau] - (gamma - 1)*(x^2 + y^2))/2/((gamma - 1)^2 - gamma^2*Exp[-2*tau])]; , Null, Simplify[SubFunc[tau, l, x, y] - KerR/(1 + I*x4*tau)^(l + 1)]

N[Integrate[Exp[I*F*tau], {tau, 0, Infinity}] /. {F -> 10^3 + I}], Null, NIntegrate[Exp[I*F*tau] /. {F -> 10^3 + I}, {tau, 0, Infinity}, {MaxRecursion -> 500}]

Imnl = (1/(1 + 2*alpha)^((3 + 0 + 0)/2))*II[0, 0, 0]; , Null, res = NIntegrate[Simplify[Imnl //. {gamma -> alpha/(1 + 2*alpha), alpha -> Sqrt[1/4 - I*x3] - 1/2, x1 -> -189.0296385141525/(1 + 2*alpha)^(3/2), x2 -> -48812.00253615297/(1 + 2*alpha) + I*gamma, x3 -> -0.5453998676943281, x4 -> 0.5625488099071595/(1 + 2*alpha)}], {tau, 0, Infinity}, {PrecisionGoal -> 20, MaxRecursion -> 100, WorkingPrecision -> 32}]; , Null, N[res, 20], Null, resS = NIntegrate[Simplify[(1/(1 + 2*alpha)^((3 + 0 + 0)/2))*(RS /. {x -> 0, y -> 0}) //. {l -> 20, gamma -> alpha/(1 + 2*alpha), alpha -> Sqrt[1/4 - I*x3] - 1/2, x1 -> 24.963007776733463/(1 + 2*alpha)^(3/2), x2 -> -116207.97243229703/(1 + 2*alpha) + I*gamma, x3 -> -7.685579463339158/100, x4 -> -4.425094388027373/100/(1 + 2*alpha)}], {z, 2, 1}, {PrecisionGoal -> 20, MaxRecursion -> 100, WorkingPrecision -> 32}]; , Null, N[resS, 20]

-0.114136216329515 + 0.044233372055982*i

4.453591750737235*e - 16 + 2.157018692023446*e - 5*i, Null, 2.157018692042264*e - 5*i

Plot[SubFunc[tau, 0, 0, 0] //. {gamma -> alpha/(1 + 2*alpha), alpha -> Sqrt[1/4 - I*x3] - 1/2, x1 -> 24.963007776733463/(1 + 2*alpha)^(3/2), x2 -> -116207.97243229703/(1 + 2*alpha) + I*gamma, x3 -> -7.685579463339158/100, x4 -> -4.425094388027373/100/(1 + 2*alpha)}, {tau, 0, 10^(-10)}, ClippingStyle -> None]

SubFunc[0.01, 0, 0, 0] //. {gamma -> alpha/(1 + 2*alpha), alpha -> Sqrt[1/4 - I*x3] - 1/2, x1 -> 24.963007776733463/(1 + 2*alpha)^(3/2), x2 -> -116207.97243229703/(1 + 2*alpha) + I*gamma, x3 -> -7.685579463339158/100, x4 -> -4.425094388027373/100/(1 + 2*alpha)}

RS

Collect[RS, z - 2]

RS

Integrate[(1/(1 + A*tau)^(l + 1))*Exp[B + C*tau], {tau, 0, Infinity}]

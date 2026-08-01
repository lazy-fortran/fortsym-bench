"""Generated SymPy translation of ``corpus/code-KiLCA/mag_drift.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 93 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('II', 'Collect[Simplify[D[D[KerR, {x, m}], {y, n}] /. {x -> 0, y -> 0}], {tau, x1, x2}, Simplify]', ('m', 'n')),
    ('Omegap', 'omc, Null, Omegat = ht*up + VEt - (hz/omc)*(ht*up + VEt)^2 + hz*(domc/m0/omc/r0)*Jperp, Null, Omegaz = hz*up + VEz + ht*(r0^2/omc)*(ht*up + VEt)^2 - ht*r0*(domc/m0/omc)*Jperp, Null, Omegatb = Collect[Omegat /. {up -> Vp + ub*VT*s, Jperp -> (1/2)*m0*(VT^2/omc)*L^2}, {ub, L}, FullSimplify], Null, Omegazb = Collect[Omegaz /. {up -> Vp + ub*VT*s, Jperp -> (1/2)*m0*(VT^2/omc)*L^2}, {ub, L}, FullSimplify], Null, COmegatb = FullSimplify /@ CoefficientList[Omegatb, {ub, L}]', ()),
    ('mdf0dJ', 'P00 + P02*L^2 + P12*u*L^2 + P10*u + P20*u^2 + P30*u^3, Null, Omegab = Q00 + Q10*u + Q20*u^2 + Q02*L^2, Null, df0dJb = Z00 + Z02*L^2 + Z12*u*L^2 + Z10*u + Z20*u^2 + Z30*u^3, Null, mOMEGAmomega = R00 + R10*u + R20*u^2 + R02*L^2, Null, F = Collect[mdf0dJ*Omegab - mOMEGAmomega*df0dJb, {u, L}, Simplify], Null, MatrixForm[CoefficientList[F, {u, L}]], Null', ()),
    ('JJ', 'Sum[z^(l + 2*b)*((-1)^b/b!/(l + b)!/2^(l + 2*b))*k^(l + 2*b), {b, 0, 6}]', ('l', 'k', 'z')),
    ('DDk', 'D[D[Exp[I*l*ArcTan[k2/k1]]*(rho*Sqrt[k1^2 + k2^2])^(l + 2*b), {k1, m}], {k2, n}]/rho^(m + n)', ('m', 'n', 'l', 'b', 'rho')),
    ('Imnl', '(1/(1 + 2*alpha)^((3 + 1 + 5)/2))*II[1, 5, 19]', ()),
    ('DDkexa', 'D[D[D[D[Exp[(-I)*l*(ArcTan[q2/q1] - ArcTan[p2/p1])]*z^(2*nu + 1)*BesselJ[l, rho*Sqrt[q1^2 + q2^2]*z]*BesselJ[l, rho*Sqrt[p1^2 + p2^2]*z]*Exp[-z^2/2], {q1, m1}], {q2, n1}], {p1, m2}], {p2, n2}]', ('m1', 'n1', 'm2', 'n2', 'l', 'nu', 'rho')),
    ('res', 'DDexa[1, 2, 0, 5, l, nu, rho], Null, resI = res //. {l -> 3, nu -> 2, ks -> -(3/4)/rho, rho -> 125/1000}, Null, resF = NIntegrate[resI, {z, 0, Infinity}, {PrecisionGoal -> 12, MaxRecursion -> 500, WorkingPrecision -> 32}], Null, resA = NIntegrate[N[resI /. BesselJ -> BJE], {z, 0, Infinity}], Null, resE = II[1, 6, 1, 6, l, nu, rho]', ()),
    ('II', 'Sum[((nu + Abs[l] + b1 + b2)!/b1!/(Abs[l] + b1)!/b2!/(Abs[l] + b2)!)*(-1)^(b1 + b2)*2^(nu - Abs[l] - b1 - b2)*rho^(m1 + n1 + m2 + n2)*Conjugate[DD[m1, n1, l, b2, rho]]*DD[m2, n2, l, b1, rho], {b1, 0, 8}, {b2, 0, 8}]', ('m1', 'n1', 'm2', 'n2', 'l', 'nu', 'rho')),
    ('res', 'DDapp[1, 2, 1, 2, l, nu, rho], Null, resI = res //. {l -> 0, nu -> 0, ks -> 0.5/rho, rho -> 0.125}, Null, resF = NIntegrate[resI, {z, 0, Infinity}], Null', ()),
    ('PP', 'Print[((nu + Abs[l] + b1 + b2)!/b1!/(Abs[l] + b1)!/b2!/(Abs[l] + b2)!)*(-1)^(b1 + b2)*2^(nu - Abs[l] - b1 - b2)*rho^(m1 + n1 + m2 + n2)*Conjugate[DD[m1, n1, l, b2, rho]]*DD[m2, n2, l, b1, rho]]', ('m1', 'n1', 'm2', 'n2', 'l', 'nu', 'rho', 'b1', 'b2')),
    ('RS', 'FullSimplify[(-(z - 1)^(-1))*(KerR/(1 + I*x4*tau)^(l + 1)) //. tau -> -Log[z - 1]], Null, Series[RS, {gamma, 0, 0}], Null', ()),
    ('aaa', 'Simplify[((1 - E^(-tau))*(-1 + 2*gamma)*x1^2)/(-1 + gamma + gamma/E^tau) + tau*(-x1^2 + I*x2) + (I*(1 - E^(-tau))*x1*(x + y))/(-1 + gamma + gamma/E^tau) + ((2*x*y)/E^tau - (-1 + gamma)*(x^2 + y^2) + (gamma*(x^2 + y^2))/E^(2*tau))/(2*((-1 + gamma)^2 - gamma^2/E^(2*tau)))]', ()),
    ('aaa', 'Simplify[((2*x*y)/E^tau - (-1 + gamma)*(x^2 + y^2) + (gamma*(x^2 + y^2))/E^(2*tau))/(2*((-1 + gamma)^2 - gamma^2/E^(2*tau)))]', ()),
    ('SubFunc', '(-Sqrt[2*Pi]/(1 + I*x4*tau)^(l + 1)/Sqrt[(gamma - 1)^2 - gamma^2*Exp[-2*tau]])*Exp[(-x1^2 + I*x2)*tau + ((1 - Exp[-tau])/(gamma - 1 + gamma*Exp[-tau]))*x1*((2*gamma - 1)*x1 + (x + y)*I) + (gamma*(x^2 + y^2)*Exp[-2*tau] + 2*x*y*Exp[-tau] - (gamma - 1)*(x^2 + y^2))/2/((gamma - 1)^2 - gamma^2*Exp[-2*tau])]', ('tau', 'l', 'x', 'y')),
    ('Imnl', '(1/(1 + 2*alpha)^((3 + 0 + 0)/2))*II[0, 0, 0]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/mag_drift.wl')

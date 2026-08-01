"""Generated SymPy translation of ``corpus/code-KiLCA/coll.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 112 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('W1', 'If[Mod[n, 2] == 0, Sqrt[2*Pi]*(n - 1)!!*Vt^(n + 1), 0]', ('n',)),
    ('LimT', 'Limit[J1k[alpha, beta, tau, nu], nu -> 0], Null, JLimT = FullSimplify[Integrate[LimT, {tau, 0, Infinity}]]', ()),
    ('dev', 'FullSimplify[tst - tst0 /. {alpha -> 0, beta -> 0}]', ()),
    ('$MaxExtraPrecision', '1000', ()),
    ('J1exaWTW', 'Integrate[w1^m*Integrate[G[w1, w2, tau, nu]*w2^n*Exp[-w2^2/2/Vt^2], {w2, -Infinity, Infinity}, {tau, 0, Infinity}], {w1, -Infinity, Infinity}]', ('m', 'n', 'nu')),
    ('BesselRule1', 'BesselI[(in_Integer /; in > 1) + l, z_] -> BesselI[l + in - 2, z] - 2*((l + in - 1)/z)*BesselI[l + in - 1, z], Null, BesselRule2 = BesselI[(in_Integer /; in < 0) + l, z_] -> BesselI[l + in + 2, z] + 2*((l + in + 1)/z)*BesselI[l + in + 1, z], Null, expr = BesselI[l - 10, z] + BesselI[l + 9, z] + BesselI[l, z], Null, tst = Simplify[expr //. {BesselRule1, BesselRule2}], Null, FullSimplify[tst - expr]', ()),
    ('$MaxExtraPrecision', '1000', ()),
    ('IGammaRule', 'Gamma[(a_) + (n_Integer), z_] -> z^(a + n - 1)*Exp[-z] + (a + n - 1)*Gamma[a + n - 1, z], Null, GammaRule = Gamma[(z_) + (n_Integer)] -> (z + n - 1)*Gamma[z + n - 1], Null, Null', ()),
    ('res', 'J1der[0, 2, nu], Null, res = res //. {Sqrt[2*Pi] -> sqrt2p, kp^2*(Vt^2/nu^2) -> t1, ((-I)*nu*(omega - omega0) + kp^2*Vt^2)/nu^2 -> t2, (I*nu*(omega - omega0) - kp^2*Vt^2)/nu^2 -> -t2, Gamma[t2] -> Gamma[t2, t1] + gam, Exp[t1] -> Ex, t1^(-t2) -> 1/t1Pt2, omega - omega0 -> dom}', ()),
    ('dev', 'Expand //@ Simplify[a1 - a2] //. {IGammaRule, GammaRule}, Null, Simplify[dev]', ()),
    ('dev', 'gamma[a, z] - (z^a/a)*Exp[-z]*Hypergeometric1F1[1, 1 + a, z], Null, FullSimplify[dev], Null, N[dev /. {a -> 10 - 100*I, z -> -200 - 299*I}, 50]', ()),
    ('t1', 'kp^2*(Vt^2/nu^2)', ('nu',)),
    ('LimT', 'Limit[J1k[alpha, beta, tau, nu], nu -> 0], Null, JLimT = FullSimplify[Integrate[LimT, {tau, 0, Infinity}]], Null, Null', ()),
    ('JLimT', 'Sqrt[2*Pi]*Vt*((E^(((omega - omega0)*(-omega + omega0 + 2*(alpha + beta)*kp*Vt^2))/(2*kp^2*Vt^2))*Sqrt[Pi/2]*(1 - I*Erfi[((-omega + omega0 + (alpha + beta)*kp*Vt^2)*Abs[kp])/(Sqrt[2]*kp^2*Vt)]))/(Vt*Abs[kp]))', ()),
    ('$MaxExtraPrecision', '1000', ()),
    ('res', 'J1derNC[1, 0, nu], Null, res = FullSimplify[res /. {ErfiRule}], Null, Null', ()),
    ('ErfiRule', 'Erfi[x_] -> (-I)*(W[x]*Exp[x^2] - 1), Null, Get["Algebra`Horner`"]', ()),
    ('Res', 'FullSimplify[Normal[Series[Wfunc2[1/tt] /. skp -> 1, {tt, 0, 24}]]]', ()),
    ('ee', 'Assuming[z < 0, Simplify[res1]], Null, zv = 100*I', ()),
    ('s1', '{{1, 0, 0}, {0, 0, 0}, {0, 0, 0}}', ()),
    ('I', '1', ('alpha', 'i1')),
    ('P', 'Array[f, 3], Null, P[[1]] = 1, Null, P[[2]] = 2, Null, P[[3]] = 3, Null, MatrixForm[P], Null, Null', ()),
    ('df0dJ', '(-f0/T)*{Z00[[1]] + Z01[[1]]*J + Z10[[1]]*w1 + Z20[[1]]*w1^2}', ()),
    ('F11as', '(-(b - 1)/z)*Sum[Pochhammer[2 - b, n]/(-z)^n, {n, 0, 50}] + Gamma[b]*Exp[z]*z^(1 - b)', ('b', 'z')),
    ('z', '22030755774330544227*(10^5/10^20)', ()),
    ('$MaxExtraPrecision', '500', ()),
    ('n', '2', ()),
    ('L', '{b -> 10^2 - I*10, z -> 10^2}, Null, er = N[Hypergeometric1F1[1, 1 + b, z] /. L, 50], Null, fr = N[f /. L, 20], Null, (fr - er)/er, Null, gr = N[g /. L, 20], Null, (gr - er)/er, Null, Null', ()),
    ('g', 'b/(b - z + z/(1 + b - z + (2*z)/(2 + b - z + R)))', ()),
    ('h', 'Sum[z^n/Pochhammer[b, n], {n, 0, 3}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/coll.wl')

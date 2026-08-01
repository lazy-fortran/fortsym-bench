"""Generated SymPy translation of ``corpus/code-KiLCA/cond.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 23 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('L', 'Coefficient[LegendreP[k, z], z, n]', ('n', 'k')),
    ('L1', 'Sum[L[n, k]*Binomial[n, m]*r^(n - m), {n, m, k}]', ('m', 'k', 'r')),
    ('L2', 'Sqrt[alpha]*Sqrt[k + 1/2]*alpha^m*L1[m, k, alpha*r0 + beta]', ('m', 'k')),
    ('mod', 'Sqrt[p1^2 + p2^2]', ('p1', 'p2')),
    ('arg', 'ArcTan[p2/p1]', ('p1', 'p2')),
    ('JE', 'BesselJ[l, mod[p1, p2]*rl]*Exp[I*l*arg[p1, p2]]', ('l', 'p1', 'p2')),
    ('Der1', 'D[JE[l, p1, p2], {p2, m}]', ('l', 'm', 'p1', 'p2')),
    ('Der2', 'D[Der1[l, m, p1, p2], {p1, 1}]', ('l', 'm', 'p1', 'p2')),
    ('Dmat', '{{(-I)*Der2[l, m, p1, p2], 0, 0}, {(-I)*(hz/r0)*Der1[l, m + 1, p1, p2], Der1[l, m, p1, p2], 0}, {I*(ht/r0)*Der1[l, m + 1, p1, p2], 0, Der1[l, m, p1, p2]}} /. {p2 -> 0, p1 -> ks}', ('l', 'm', 'ks')),
    ('aFa', 'Refine[Sum[L2[m, k]*I^m*Dmat[l, m, ks], {m, 0, k}], ks >= 0]', ('k', 'l')),
    ('aF11', 'aF[1, 7]', ()),
    ('aFa11', 'aFa[1, l]', ()),
    ('H', 'Array[Ht, 2]', ()),
    ('VE', 'Array[Ht, 2]', ()),
    ('Omega', '{omc, H[[1]]*u + VE[[2]], H[[2]]*u + VE[[2]]}', ()),
    ('DD', 'Derivative[1] + Derivative[2]', ()),
    ('R', 'Integrate[x^(2*b + 1)*Exp[(-a)*x^2]*BesselJ[n, k1*x]*BesselJ[n, k2*x]]', ()),
    ('Jquad', '(-1)^n*D[(1/2/a)*Exp[-(k1^2 + k2^2)/4/a]*BesselI[l, k1*(k2/2/a)], {a, n}]', ('n', 'l')),
    ('Jquad', '(-1)^n*D[(1/2/a)*Exp[-(k1^2 + k2^2)/4/a]*BesselI[l, k1*(k2/2/a)], {a, n}]', ('n', 'l')),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/cond.wl')

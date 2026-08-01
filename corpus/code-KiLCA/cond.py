"""Generated SymPy translation of ``corpus/code-KiLCA/cond.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 20 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('L', 'Coefficient[LegendreP[k, z], z, n], Null, L1[m_, k_, r_] := Sum[L[n, k]*Binomial[n, m]*r^(n - m), {n, m, k}], Null, L2[m_, k_] := Sqrt[alpha]*Sqrt[k + 1/2]*alpha^m*L1[m, k, alpha*r0 + beta], Null, mod[p1_, p2_] := Sqrt[p1^2 + p2^2]', ('n', 'k')),
    ('aF11', 'aF[1, 7]', ()),
    ('aFa11', 'aFa[1, l]', ()),
    ('H', 'Array[Ht, 2]', ()),
    ('DD', 'Derivative[1] + Derivative[2]', ()),
    ('R', 'Integrate[x^(2*b + 1)*Exp[(-a)*x^2]*BesselJ[n, k1*x]*BesselJ[n, k2*x]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/cond.wl')

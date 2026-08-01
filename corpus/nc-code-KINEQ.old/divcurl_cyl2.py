"""Generated SymPy translation of ``corpus/nc-code-KINEQ.old/divcurl_cyl2.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 30 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[{r, r0, s, p, z, l, m, n, sr, sz}, Reals], r0 > 0, r > 0}', ()),
    ('bas', 'Exp[I*n*p]', ()),
    ('tail', 'r^3*Exp[-((r - r0)^2/(2*sr^2) + z^2/(2*sr^2))]', ()),
    ('Ar', 'tail*bas', ()),
    ('Az', '0', ()),
    ('A', '{Ar, 0, Az}', ()),
    ('B', 'FullSimplify[Curl[A, {r, p, z}, "Cylindrical"]]', ()),
    ('J', 'FullSimplify[Curl[B, {r, p, z}, "Cylindrical"]]', ()),
    ('conds', '{r0 -> 160, n -> 1, sr -> 10, sz -> 10}', ()),
    ('Jv', 'Simplify[Re[J[[{1, 3}]]/bas] /. conds]', ()),
    ('Bv', 'Simplify[Im[B[[{1, 3}]]/bas] /. conds]', ()),
    ('Av', 'Simplify[Re[{Ar, Az}/bas] /. conds]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-code-KINEQ.old/divcurl_cyl2.wl')

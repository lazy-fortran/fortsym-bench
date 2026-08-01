"""Generated SymPy translation of ``corpus/nc-code-KINEQ.old/divcurl_cyl2.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 11 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$Assumptions', '{Element[{r, r0, s, p, z, l, m, n, sr, sz}, Reals], r0 > 0, r > 0}', ()),
    ('bas', 'Exp[I*n*p]', ()),
    ('Ar', 'tail*bas', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-code-KINEQ.old/divcurl_cyl2.wl')

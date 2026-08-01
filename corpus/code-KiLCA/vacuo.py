"""Generated SymPy translation of ``corpus/code-KiLCA/vacuo.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 19 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('T', '{I*kt[r]*F3[r] - I*kz*F2[r] - I*(om/c)*B1[r], I*kz*F1[r] - D[F3[r], r] - I*(om/c)*B2[r], (1/r)*D[r*F2[r], r] - I*kt[r]*F1[r] - I*(om/c)*B3[r], I*kt[r]*B3[r] - I*kz*B2[r] + I*(oms/c)*F1[r], I*kz*B1[r] - D[B3[r], r] + I*(oms/c)*F2[r], (1/r)*D[r*B2[r], r] - I*kt[r]*B1[r] + I*(oms/c)*F3[r]}', ()),
    ('Es', '{0, 0, 0}', ()),
    ('Bs', '{0, 0, 0}', ()),
    ('dEs', 'D[Es, r]', ()),
    ('dBs', 'D[Bs, r]', ()),
    ('res', 'T /. {D[F1[r], r] -> dEs[[1]], D[F2[r], r] -> dEs[[2]], D[F3[r], r] -> dEs[[3]], D[B1[r], r] -> dBs[[1]], D[B2[r], r] -> dBs[[2]], D[B3[r], r] -> dBs[[3]]}', ()),
    ('res', 'res /. {F1[r] -> Es[[1]], F2[r] -> Es[[2]], F3[r] -> Es[[3]], B1[r] -> Bs[[1]], B2[r] -> Bs[[2]], B3[r] -> Bs[[3]]}', ()),
    ('res', 'FullSimplify[res /. {kt[r] -> m/r, D[kt[r], r] -> -m/r/r, kz -> Sqrt[gamma^2 + om*(oms/c^2)]}]', ()),
    ('res', 'Collect[res, {C1, C2, C3, C4}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-KiLCA/vacuo.wl')

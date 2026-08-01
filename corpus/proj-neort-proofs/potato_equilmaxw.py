"""Generated SymPy translation of ``corpus/proj-neort-proofs/potato_equilmaxw.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('delta', '(mm cc/ee) R vtor', ()),
    ('shift', 'ee (Phi[psi] - Phi[psi + delta]) + T (Log[nbar[psi]] - Log[nbar[psi + delta]])', ()),
    ('lin', 'Normal[Series[shift, {vtor, 0, 1}]]', ()),
    ('Vtor', "cc R (Phi'[psi] + T/(ee nbar[psi]) nbar'[psi])", ()),
    ('Omtor', "cc (Phi'[psi] + T/(ee nbar[psi]) nbar'[psi])", ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/potato_equilmaxw.wl')

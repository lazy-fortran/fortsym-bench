"""Generated SymPy translation of ``corpus/proj-stellopt-talk/13_pca_svd.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('n', '40', ()),
    ('p', '6', ()),
    ('tol', '10.^-10', ()),
    ('xraw', 'RandomReal[{-1, 1}, {n, p}]', ()),
    ('xc', '# - Mean[xraw] & /@ xraw', ()),
    ('sig', 'Diagonal[s]', ()),
    ('cov', 'Transpose[xc] . xc/(n - 1)', ()),
    ('aligns', 'Table[Abs[evecs[[i]] . v[[All, i]]], {i, p}]', ()),
    ('k', '2', ()),
    ('xk', 'u[[All, 1 ;; k]] . s[[1 ;; k, 1 ;; k]] . Transpose[v[[All, 1 ;; k]]]', ()),
    ('errSVD', 'Norm[xc - xk, "Frobenius"]', ()),
    ('worst', 'True', ()),
    ('errs', '{}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/13_pca_svd.wl')

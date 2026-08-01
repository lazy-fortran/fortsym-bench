"""Generated SymPy translation of ``corpus/code-paper_magnetic/paper_magnetic_old.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 10 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Acov', '{A1cov[x1, x2], A2cov[x1, x2], A3cov[x1, x2]}*Exp[I*n*x3]', ()),
    ('Jctr', '{J1ctr[x1, x2], J2ctr[x1, x2], J3ctr[x1, x2]}*Exp[I*n*x3]', ()),
    ('nucov', '{{nu11[x1, x2], nu12[x1, x2], 0}, {nu21[x1, x2], nu22[x1, x2], 0}, {0, 0, nu33[x1, x2]}}', ()),
    ('Ectr', '(1/sqrtg)*{{0, 1}, {-1, 0}}', ()),
    ('Curlt', '(1/sqrtg)*{D[V, x2], -D[V, x1]}', ('V',)),
    ('curlt', '(1/sqrtg)*(D[v[[2]], x1] - D[v[[1]], x2])', ('v',)),
    ('Curl3', '(1/sqrtg)*{D[v[[3]], x2] - D[v[[2]], x3], D[v[[1]], x3] - D[v[[3]], x1], D[v[[2]], x1] - D[v[[1]], x2]}', ('v',)),
    ('divt', '(1/sqrtg)*(D[sqrtg*v[[1]], x1] + D[sqrtg*v[[2]], x2])', ('v',)),
    ('gradt', '{D[V, x1], D[V, x2]}]FullSimplify[jctr 〚 {1, 2} 〛]]                                                                                        FullSimplify[jctrt]]                                              FullSimplify[jctr 〚 3 〛]]                                                                                          FullSimplify[jctrl]]                                                                                       FullSimplify[jctrlalt]', ('V',)),
    ('jctr', 'Curl3[nucov . Curl3[Acov] /. {n -> 0}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-paper_magnetic/paper_magnetic_old.wl')

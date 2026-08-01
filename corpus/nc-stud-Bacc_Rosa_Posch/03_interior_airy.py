"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/03_interior_airy.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('Lsol', 'Solve[nu/L^2 == I a L, L]', ()),
    ('widthExp', '1/3', ()),
    ('sol', "DSolve[nu g''[s] == I a s g[s], g[s], s]", ()),
    ('Reg', 'gamma/((a s)^2 + gamma^2)', ()),
    ('plateau', 'Integrate[Reg, {s, -Infinity, Infinity},\n            Assumptions -> {gamma > 0, a != 0}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/03_interior_airy.wl')

"""Generated SymPy translation of ``corpus/proj-stellopt-talk/07_resonance_islands.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 15 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('ham', 'jj^2/(2 m) - k Cos[theta]', ('theta', 'jj')),
    ('assum', '{m > 0, k > 0}', ()),
    ('eqs', '{D[ham[theta, jj], theta] == 0, D[ham[theta, jj], jj] == 0}', ()),
    ('hess', 'D[ham[theta, jj], {{theta, jj}, 2}] /. {theta -> t0, jj -> 0}', ('t0',)),
    ('esx', 'ham[Pi, 0]', ()),
    ('jsol', 'Solve[ham[0, jj] == esx, jj]', ()),
    ('jvals', 'Simplify[jj /. jsol, assum]', ()),
    ('jmax', 'Simplify[Sqrt[2 m (e + k)], assum]', ('e',)),
    ('width', '2 Sqrt[mv kv]', ('mv', 'kv')),
    ('overlapQ', 'w1 + w2 >= Abs[j2 - j1]', ('j1', 'w1', 'j2', 'w2')),
    ('sA', '(w1a + w2a)/Abs[1.8 - 1.]', ()),
    ('sB', '(w1b + w2b)/Abs[2. - 1.]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/07_resonance_islands.wl')

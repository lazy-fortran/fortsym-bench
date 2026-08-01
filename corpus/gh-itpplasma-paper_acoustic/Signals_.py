"""Generated SymPy translation of ``corpus/gh-itpplasma-paper_acoustic/Signals_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 80 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('evs', 'E^(-12.5*(s - τg)^2)', ('s',)),
    ('subs', '{τ -> s - τg}', ()),
    ('uss', 'Cos[10*Pi*τ] /. subs', ('s',)),
    ('subs', '{τ -> -(3/4) + s}', ()),
    ('evs', 'ev[τ] /. subs', ('s',)),
    ('uss', 'us[τ] /. subs', ('s',)),
    ('fus', 'fu[τ] /. subs', ('s',)),
    ('tus', 'tu[τ] /. subs', ('s',)),
    ('ess', 'evs[s]*uss[s]', ('s',)),
    ('fus', 'UnitBox[2*(τ/3)] /. subs', ('s',)),
    ('endls', '{Line[{{0, 0}, {0, 1}}], Line[{{1.5, 0}, {1.5, 1}}]}', ()),
    ('tus', 'fus[s]*ess[s]', ('s',)),
    ('titg', 'Table[0, {i, 11}]', ()),
    ('titH', 'Table[0, {i, 11}]', ()),
    ('titGH', 'Table[0, {i, 11}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-paper_acoustic/Signals_.wl')

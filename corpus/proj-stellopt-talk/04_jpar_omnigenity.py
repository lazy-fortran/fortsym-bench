"""Generated SymPy translation of ``corpus/proj-stellopt-talk/04_jpar_omnigenity.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 16 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('failed', '0', ()),
    ('Bomni', 'b0 (1 - eps Cos[2 Pi l/len])', ('l',)),
    ('vpar', 'Sqrt[2 (en - mu Bomni[l])]', ('l',)),
    ('eps0', '0.2', ()),
    ('lam0', '0.9', ()),
    ('jref', 'jpar[eps0, lam0]', ()),
    ('da', '10.^-3', ()),
    ('dJomni', '(jOmni[1. + da] - jOmni[1. - da])/(2 da)', ()),
    ('dJgen', '(jGen[1. + da] - jGen[1. - da])/(2 da)', ()),
    ('psidot', '-D[j[psi, alpha], alpha]/(q taub)', ()),
    ('alphadot', 'D[j[psi, alpha], psi]/(q taub)', ()),
    ('jdot', 'D[j[psi, alpha], psi] psidot + D[j[psi, alpha], alpha] alphadot', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-stellopt-talk/04_jpar_omnigenity.wl')

"""Generated SymPy translation of ``corpus/proj-neort-proofs/ch02b_decorrelation_D.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 13 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('fsol', 'Exp[I phi - I omeff x t - (1/3) nueff omeff^2 t^3]', ()),
    ('hmix', 'Exp[-I omeff x t]', ()),
    ('taudec', '(3/(nueff omeff^2))^(1/3)', ()),
    ('minInt', 'Integrate[tpp^2/2 + tpp (t - tpp), {tpp, 0, t}, Assumptions -> t > 0]', ()),
    ('ombN', 'Sqrt[Op Hm]', ()),
    ('taubN', '2 Pi/ombN', ()),
    ('AQL', '(1/3) nueff omeff^2 taubN^3', ()),
    ('Dres', 'nueff omeff^2/Op^2', ()),
    ('Dthesis', 'Dres Sqrt[Op]/Hm^(3/2)', ()),
    ('assum', 'nueff > 0 && omeff > 0 && Op > 0 && Hm > 0', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/ch02b_decorrelation_D.wl')
